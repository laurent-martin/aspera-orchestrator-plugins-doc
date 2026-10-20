# frozen_string_literal: true

# Loads Orchestrator action plugins outside of Rails, and finds for each plugin:
# - from its edit form (`edit.html.erb`): label, widget, placeholder and allowed values of template attributes;
# - by calling its methods `inputs_spec` and `outputs_spec` on templates with different settings:
#   which inputs and outputs exist, for which template settings.
#
# It loads plugin code and changes core classes: run it in its own process.
# The result is printed on stdout as JSON.
#
# Usage: ruby lib/plugin_probe.rb <actions_dir> <lib_dir>
# <lib_dir> contains the Orchestrator files listed in CORE_FILES (see task extract_rpm).

require 'json'
require 'prism'
require 'timeout'
require 'logger'
require_relative 'action_template_reference'

%w[date time uri net/http fileutils pathname open3 securerandom digest base64 erb set stringio tempfile cgi csv rexml/document].each do |lib|
  require lib
rescue LoadError
  nil
end

# Subset of ActiveSupport used by Orchestrator and plugins
class Object
  def blank? = respond_to?(:empty?) ? !!empty? : !self
  def present? = !blank?
  def presence = (self if present?)
  def try(name, *args, &block) = respond_to?(name) ? public_send(name, *args, &block) : nil
  def in?(list) = list.include?(self)
end

class NilClass
  def blank? = true
end

class Numeric
  def blank? = false
end

class String
  def blank? = !match?(/\S/)
  def underscore = gsub('::', '/').gsub(/([A-Z\d]+)([A-Z][a-z])/, '\1_\2').gsub(/([a-z\d])([A-Z])/, '\1_\2').tr('-', '_').downcase
  def camelize = split('/').map { |part| part.split('_').map(&:capitalize).join }.join('::')
  def humanize = tr('_', ' ').sub(/\A\s+/, '').downcase.sub(/\A\w/, &:upcase)
  def pluralize = end_with?('y') && !end_with?('ay', 'ey', 'oy', 'uy') ? "#{self[0..-2]}ies" : (end_with?('s', 'x', 'ch', 'sh') ? "#{self}es" : "#{self}s")
  def tableize = underscore.pluralize
  def constantize = Object.const_get(self)
  def squish = strip.gsub(/\s+/, ' ')
end

class Hash
  def with_indifferent_access = self
  def symbolize_keys = transform_keys(&:to_sym)
  def stringify_keys = transform_keys(&:to_s)
end

module Rails
  def self.logger = (@logger ||= Logger.new(nil))
  def self.root = Pathname.new('/tmp')
  def self.env = 'production'
end

# Template table: attributes are the columns found in migrations
module ActiveRecord
  class Base
    Column = Struct.new(:name, :type, :default)

    class << self
      attr_writer :probe_columns

      def probe_columns = (@probe_columns ||= {})
      def columns_hash = probe_columns
      def column_names = probe_columns.keys
      def columns = probe_columns.values
      def table_name = "action_#{name.tableize}"

      # class macros: has_many, serialize, validates, before_save...
      def method_missing(*) = nil
      def respond_to_missing?(*) = false
    end

    attr_reader :attributes

    def initialize(attributes = {})
      @attributes = attributes.transform_keys(&:to_s)
    end

    def id = 0
    def new_record? = false
    def [](key) = @attributes[key.to_s]
    def []=(key, value)
      @attributes[key.to_s] = value
    end

    def read_attribute(key) = @attributes[key.to_s]
    def write_attribute(key, value)
      @attributes[key.to_s] = value
    end

    def has_attribute?(key) = @attributes.key?(key.to_s)
    def save(*) = true
    def save!(*) = true
    def reload = self

    def method_missing(name, *args, &block)
      key = name.to_s
      if key.end_with?('=') && @attributes.key?(key[0..-2])
        @attributes[key[0..-2]] = args.first
      elsif key.end_with?('?') && @attributes.key?(key[0..-2])
        @attributes[key[0..-2]].present?
      elsif @attributes.key?(key)
        @attributes[key]
      else
        super
      end
    end

    def respond_to_missing?(name, include_private = false) = @attributes.key?(name.to_s.delete_suffix('=').delete_suffix('?')) || super
  end
end

class ApplicationRecord < ActiveRecord::Base
end

# Value returned for constants of gems that are not loaded
class ProbeAnything
  PATH = '/tmp/probe'
  def self.method_missing(*) = self
  def self.respond_to_missing?(name, *) = !name.to_s.start_with?('to_')
  def self.to_s = PATH
  def self.to_str = PATH
  def method_missing(*) = self
  def respond_to_missing?(name, *) = !name.to_s.start_with?('to_')
  def to_s = PATH
  def to_str = PATH
end

# Server configuration: folders used in class bodies of plugins
class OrchConfig
  def self.get = self
  def self.method_missing(*) = ProbeAnything::PATH
  def self.respond_to_missing?(*) = true
end

# Orchestrator lib/safe_yaml.rb, without the classes of the database
module SafeYaml
  PERMITTED = [Symbol, Date, Time].freeze
  def self.load(str, **) = YAML.safe_load(str, permitted_classes: PERMITTED, aliases: true)
  def self.safe_load(str, **) = YAML.safe_load(str, permitted_classes: PERMITTED, aliases: true)
  def self.load_file(file, **) = YAML.safe_load_file(file, permitted_classes: PERMITTED, aliases: true)
  def self.safe_load_file(file, **) = YAML.safe_load_file(file, permitted_classes: PERMITTED, aliases: true)
end

def silence_warnings = yield

# Modules included by plugins, and not provided by the files loaded
module LibXML; end
module Service; end
module ProgressObserver; end

class PluginProbe
  CORE_FILES = %w[multi_type.rb payload.rb abstract.rb action_tools.rb action.rb module_trigger_tools.rb module_ssh_tools.rb module_soap_tools.rb].freeze
  # Calls on the form builder that render a field for an attribute (first argument)
  FORM_FIELDS = %i[text_field text_area password_field check_box select number_field email_field url_field hidden_field file_field radio_button date_field time_field datetime_field].freeze
  # Tag helpers that render a field named `model[attribute]`
  TAG_FIELDS = %i[select_tag select_tag_blank text_field_tag text_area_tag password_field_tag check_box_tag hidden_field_tag number_field_tag].freeze
  # Orchestrator helpers: method => [index of attribute argument, index of label argument, widget]
  HELPER_FIELDS = {
    node_selector_by_name: [1, nil, 'remote_node'],
    double_password:       [0, 1, 'password'],
    draw_variables_hash:   [1, 2, 'type_map'],
    draw_variables_array:  [1, 2, 'list'],
    draw_openended_hash:   [1, 2, 'hash'],
    draw_closedlist_hash:  [1, 2, 'hash'],
    file_selector:         [1, nil, 'file'],
    action_template_select: [1, nil, 'action_template']
  }.freeze
  CALL_TIMEOUT = 5
  PLACEHOLDER_VAR = 'probe_placeholder_variable'
  MARKER_PREFIX = 'probe_value_of_'
  OTHER_MARKER_PREFIX = 'other_probe_value_of_'
  # Pairs of attributes are tested when each has at most this number of values, up to a total number of templates
  MAX_PAIR_VALUES = 30
  MAX_CONTEXTS = 5000

  class << self
    attr_accessor :stub_constants

    # Load Ruby source without its `require` (gems are not available)
    def load_ruby(path)
      path = File.expand_path(path)
      @loaded ||= {}
      return if @loaded[path]
      @loaded[path] = true
      dir = File.dirname(path)
      source = File.read(path).gsub(/^\s*require_relative\s+['"]([^'"]+)['"].*$/) do
        "PluginProbe.load_ruby(#{File.expand_path(Regexp.last_match(1).sub(/(\.rb)?\z/, '.rb'), dir).inspect})"
      end
      source = source.gsub(/^\s*require\s+.*$/, '')
      # a top-level module used before its definition must not be stubbed as a class
      source.scan(/^module\s+([A-Z]\w*)\s*$/).flatten.uniq.each do |name|
        Object.const_set(name, Module.new) unless Object.const_defined?(name, false)
      end
      TOPLEVEL_BINDING.eval(source, path, 1)
    end
  end

  # Missing constants are stubbed while loading plugin code
  module ConstStub
    def const_missing(name)
      return super unless PluginProbe.stub_constants
      const_set(name, Class.new(ProbeAnything))
    end
  end
  Module.prepend(ConstStub)

  def initialize(actions_dir, lib_dir)
    @actions_dir = actions_dir
    @lib_dir = lib_dir
    @reference = ActionTemplateReference.new(actions_dir)
  end

  def run
    self.class.stub_constants = true
    result = {}
    CORE_FILES.each do |file|
      self.class.load_ruby(File.join(@lib_dir, file))
    rescue Exception => e # rubocop:disable Lint/RescueException
      warn("#{file}: #{e.class}: #{e.message}")
    end
    Dir.children(@actions_dir).sort.each do |dir|
      path = File.join(@actions_dir, dir)
      next unless File.exist?(File.join(path, 'metadata.yml'))
      plugin = @reference.parse_plugin(path)
      result[plugin.plugin_name] = probe_plugin(plugin)
    rescue Exception => e # rubocop:disable Lint/RescueException
      result[dir] = {'errors' => ["#{e.class}: #{e.message}"]}
    end
    result
  end

  private

  def probe_plugin(plugin)
    errors = []
    klass = load_class(plugin, errors)
    return {'errors' => errors} if klass.nil?
    klass.probe_columns = plugin.columns.to_h { |name, col| [name, ActiveRecord::Base::Column.new(name, col[:type].to_sym, typed(col[:default], col[:type]))] }
    form = read_form(plugin, klass, errors)
    plugin.constants.each_key do |const|
      next unless (m = const.match(/\AVALUES_(\w+)\z/)) && plugin.columns.key?(m[1].downcase)
      values = evaluate_values("#{klass.name}::#{const}")
      (form[m[1].downcase] ||= {})['values'] ||= values if values
    end
    # values submitted by the form are cast to the column type
    form.each { |attr, info| info['values'] = info['values'].map { |v| typed(v, plugin.columns[attr][:type]) }.uniq if info['values'] }
    specs = probe_specs(plugin, klass, form, errors)
    {'form' => form, 'code_defaults' => code_defaults(plugin, klass), 'errors' => errors}.merge(specs)
  end

  # Values of constants DEFAULT_<ATTRIBUTE>: used by the plugin when the attribute is blank
  def code_defaults(plugin, klass)
    plugin.columns.keys.each_with_object({}) do |name, defaults|
      constant = "DEFAULT_#{name.upcase}"
      next unless klass.const_defined?(constant)
      # a value computed at load time (date, random, environment) is not a default: source text is used instead
      next if plugin.constants[constant].to_s.match?(/Time|Date|rand|Random|ENV|Process/)
      value = klass.const_get(constant)
      value = value.to_s if value.is_a?(Symbol)
      next unless [String, Integer, Float, TrueClass, FalseClass].any? { |type| value.is_a?(type) }
      defaults[name] = value
    rescue Exception # rubocop:disable Lint/RescueException
      nil
    end
  end

  def load_class(plugin, errors)
    class_file = Dir.glob(File.join(plugin.dir, '*.rb')).find { |f| File.read(f).match?(/^\s*include\s+Action\b/) }
    return errors.push('No plugin class file found') && nil if class_file.nil?
    self.class.load_ruby(class_file)
    self.class.stub_constants = false
    klass = Object.const_get(plugin.plugin_name)
    return errors.push("#{plugin.plugin_name} is not a template class") && nil unless klass < ActiveRecord::Base
    klass
  rescue Exception => e # rubocop:disable Lint/RescueException
    errors << "load: #{e.class}: #{e.message.lines.first&.strip}"
    nil
  ensure
    self.class.stub_constants = true
  end

  def typed(value, type)
    return nil if value.nil?
    case type
    when 'boolean' then %w[true 1 t].include?(value.to_s)
    when 'integer', 'bigint' then Integer(value, exception: false) || value
    when 'float', 'decimal' then Float(value, exception: false) || value
    else value.to_s
    end
  end

  # Evaluate a Ruby expression giving the options of a select: nil if not static
  def evaluate_values(source)
    self.class.stub_constants = false
    value = Timeout.timeout(CALL_TIMEOUT) { TOPLEVEL_BINDING.eval(source) }
    value = value.to_a if value.is_a?(Range)
    values =
      case value
      when Hash then value.values
      when Array then value.map { |item| item.is_a?(Array) ? item.last : item }
      end
    return nil if values.nil?
    values = values.map { |v| v.is_a?(Symbol) ? v.to_s : v }.reject { |v| v.nil? || v == '' }
    return nil unless values.all? { |v| v.is_a?(String) || v.is_a?(Numeric) || v == true || v == false }
    values.uniq
  rescue Exception # rubocop:disable Lint/RescueException
    nil
  ensure
    self.class.stub_constants = true
  end

  # -- edit form --------------------------------------------------------------

  # Collects calls in source order
  class CallCollector < Prism::Visitor
    attr_reader :calls

    def initialize
      super
      @calls = []
    end

    def visit_call_node(node)
      @calls << node
      super
    end
  end

  # @return [Hash] attribute => {label, widget, hint, values, dynamic_values, format, ...}
  def read_form(plugin, klass, errors)
    form = {}
    file = File.join(plugin.dir, 'edit.html.erb')
    return form unless File.exist?(file)
    model = klass.name.underscore
    # a label not bound to an attribute goes to the field in the same list item (before or after it), else to the next field
    pending_label = nil
    group = nil
    flush = lambda do
      next if group.nil?
      unlabeled = group[:fields].reject { |attr| form[attr]['label'] }
      unlabeled.zip(group[:labels]).each { |attr, text| form[attr]['label'] = text if text }
      group = nil
    end
    File.read(file).scan(%r{<%(=|-|#)?(.*?)-?%>|<label\b([^>]*)>(.*?)</label>|<(/?)li\b}m) do |kind, code, label_attrs, label_text, li_close|
      if li_close
        flush.call
        group = {fields: [], labels: []} if li_close.empty?
        next
      end
      labels = []
      fields = []
      if label_text
        text = clean_text(label_text)
        attr = label_attrs.to_s[/\bfor=["'](\w+)["']/, 1]&.delete_prefix("#{model}_")
        if attr && plugin.columns.key?(attr)
          (form[attr] ||= {})['label'] ||= text
        elsif text
          labels << text
        end
      elsif kind != '#'
        collector = CallCollector.new
        Prism.parse(code).value.accept(collector)
        collector.calls.each do |call|
          attr, entry = form_call(call, model, plugin)
          if attr == :label
            labels << entry
          elsif attr
            info = (form[attr] ||= {})
            bound = entry.delete('label_bound')
            entry.each { |key, value| info[key] ||= value unless value.nil? }
            fields << attr unless bound
          end
        end
      end
      if group
        group[:labels].concat(labels)
        group[:fields].concat(fields)
      else
        pending_label = labels.last if labels.any?
        fields.each do |attr|
          form[attr]['label'] ||= pending_label if pending_label
          pending_label = nil
        end
      end
    end
    flush.call
    form.select! { |attr, _| plugin.columns.key?(attr) }
    form
  rescue StandardError => e
    errors << "form: #{e.class}: #{e.message}"
    form
  end

  # @return [Array] [attribute, info] for a field, [:label, text] for a label not bound to a field, or nil
  def form_call(call, model, plugin)
    args = call.arguments&.arguments || []
    receiver_local = call.receiver.is_a?(Prism::LocalVariableReadNode) || call.receiver.is_a?(Prism::CallNode) && call.receiver.receiver.nil? && call.receiver.arguments.nil?
    case call.name
    when :label
      return nil unless receiver_local || call.receiver.nil?
      name = literal(args[0])
      text = literal(args[1])
      return nil if name.nil?
      if plugin.columns.key?(name.to_s)
        return [name.to_s, {'label' => text || name.to_s.humanize, 'label_bound' => true}]
      end
      [:label, text || name.to_s.humanize]
    when :label_tag
      text = literal(args[1]) || literal(args[0])&.humanize
      text ? [:label, text] : nil
    when *FORM_FIELDS
      return nil unless receiver_local
      attr = literal(args[0])&.to_s
      return nil if attr.nil?
      info = {'widget' => call.name == :check_box ? 'boolean' : call.name.to_s, 'hint' => keyword(args, :placeholder)}
      info.merge!(select_values(args[1])) if call.name == :select
      info['values'] = [literal(args[1])].compact if call.name == :radio_button
      [attr, info]
    when *TAG_FIELDS
      return nil unless call.receiver.nil?
      attr = tag_attribute(literal(args[0]), model, plugin)
      return nil if attr.nil?
      info = {'widget' => call.name.to_s.sub(/_tag(_blank)?\z/, '').sub('check_box', 'boolean'), 'hint' => keyword(args, :placeholder)}
      info.merge!(select_values(args[1])) if call.name.to_s.start_with?('select')
      [attr, info]
    when *HELPER_FIELDS.keys
      return nil unless call.receiver.nil?
      attr_index, label_index, widget = HELPER_FIELDS[call.name]
      attr = literal(args[attr_index])&.to_s
      return nil if attr.nil?
      info = {'widget' => widget}
      info['label'] = literal(args[label_index]) if label_index
      info['label_bound'] = true if info['label']
      info['run_time_value'] = literal(args[4]) if call.name == :node_selector_by_name && literal(args[4]).is_a?(String)
      info['action_type'] = literal(args[2]) if call.name == :action_template_select
      [attr, info]
    when :enable_rich_textedit
      attr = tag_attribute(literal(args[0]), model, plugin)
      format = literal(args[1])
      attr && format ? [attr, {'format' => format}] : nil
    end
  end

  # Attribute from a field name: `model[attr]`, `model_attr` or `attr`
  def tag_attribute(name, model, plugin)
    return nil unless name.is_a?(String)
    attr = name[/\[(\w+)\]\z/, 1] || name.delete_prefix("#{model}_")
    plugin.columns.key?(attr) ? attr : nil
  end

  def select_values(node)
    return {} if node.nil?
    node = node.arguments.arguments.first if node.is_a?(Prism::CallNode) && node.name == :options_for_select && node.arguments
    values = evaluate_values(node.slice)
    values ? {'values' => values} : {'dynamic_values' => true}
  end

  def literal(node)
    case node
    when Prism::StringNode then node.unescaped
    when Prism::SymbolNode then node.unescaped
    when Prism::IntegerNode then node.value
    when Prism::TrueNode then true
    when Prism::FalseNode then false
    end
  end

  def keyword(args, key)
    args.each do |arg|
      next unless arg.is_a?(Prism::KeywordHashNode) || arg.is_a?(Prism::HashNode)
      arg.elements.each do |element|
        next unless element.is_a?(Prism::AssocNode) && literal(element.key)&.to_s == key.to_s
        value = literal(element.value)
        return value.is_a?(String) && !value.strip.empty? ? value.strip : nil
      end
    end
    nil
  end

  def clean_text(html)
    text = html.gsub(/<%.*?%>/m, '').gsub(/<[^>]*>/, '').gsub(/&nbsp;/, ' ').squish
    text.empty? ? nil : text
  end

  # -- inputs_spec and outputs_spec -------------------------------------------

  # Call inputs_spec and outputs_spec with given attributes
  # @return [Hash] {required: {name=>type}, optional: {name=>type}, outputs: {name=>type}} or nil on error
  def call_specs(klass, attributes, errors)
    template = klass.new(attributes)
    inputs = Timeout.timeout(CALL_TIMEOUT) { template.inputs_spec }
    required, optional = inputs.is_a?(Array) ? inputs : [inputs, nil]
    outputs = Timeout.timeout(CALL_TIMEOUT) { klass.new(attributes).all_outputs_spec }
    {required: spec_hash(required), optional: spec_hash(optional), outputs: spec_hash(outputs)}
  rescue Exception => e # rubocop:disable Lint/RescueException
    errors << "#{e.class}: #{e.message.lines.first&.strip} (#{attributes.compact.map { |k, v| "#{k}=#{v.inspect}" }.join(', ')})"
    nil
  end

  def spec_hash(hash)
    return {} unless hash.is_a?(Hash)
    hash.to_h { |name, type| [name.to_s, type.to_s] }
  end

  # Text set in an attribute to find names and types given by its value
  def marker(attr) = "#{MARKER_PREFIX}#{attr}"

  def filled_value(name, col, form_info)
    values = form_info&.dig('values')
    return values.first if values&.any?
    case col[:type]
    when 'boolean' then false
    when 'integer', 'bigint' then 1
    when 'float', 'decimal' then 1.0
    when 'datetime' then Time.at(0)
    else marker(name)
    end
  end

  # Values tested for each attribute, besides its default: allowed values, booleans, remote node or run time,
  # else a value for an attribute not set by default
  # @return [Hash] attribute => [values, choice?]
  def variations(plugin, form, baseline)
    plugin.columns.except('name', 'comments').each_with_object({}) do |(name, col), result|
      info = form[name] || {}
      values =
        if info['widget'] == 'remote_node' then [info['run_time_value'], 'probe_remote_node'].compact
        elsif info['values'] then info['values']
        elsif col[:type] == 'boolean' then [true, false]
        end
      choice = !values.nil?
      values ||= [filled_value(name, col, info)] if baseline[name].nil?
      values = values&.reject { |value| value == baseline[name] }
      result[name] = [values, choice] unless values.nil? || values.empty?
    end
  end

  # Template settings to test: the default template, with one or two attributes changed
  # Pairs of attributes with allowed values come first, as the number of templates is limited
  def contexts(variations, baseline)
    list = [{}]
    variations.each { |attr, (values, _)| values.each { |value| list << {attr => value} } }
    pairs = variations.select { |_, (values, _)| values.size <= MAX_PAIR_VALUES }.keys.combination(2).sort_by do |pair|
      -pair.count { |attr| variations[attr][1] }
    end
    pairs.each do |attr1, attr2|
      variations[attr1][0].product(variations[attr2][0]).each { |value1, value2| list << {attr1 => value1, attr2 => value2} }
      break if list.size > MAX_CONTEXTS
    end
    list.map { |changed| {changed: changed, attributes: baseline.merge(changed)} }
  end

  def probe_specs(plugin, klass, form, errors)
    baseline = plugin.columns.to_h { |name, col| [name, typed(col[:default], col[:type])] }
    variations = variations(plugin, form, baseline)
    call_errors = []
    contexts = contexts(variations, baseline).filter_map do |ctx|
      ctx[:spec] = call_specs(klass, ctx[:attributes], call_errors)
      ctx[:named] = {inputs: {}, outputs: {}}
      ctx if ctx[:spec]
    end
    errors.concat(call_errors.uniq.first(3))
    return {} if contexts.empty?
    contexts.each { |ctx| ctx[:derived] = derived_names(klass, ctx) }
    singles = contexts.select { |ctx| ctx[:changed].size <= 1 }
    text_columns = plugin.columns.select { |_, col| %w[string text mediumtext].include?(col[:type]) }.keys
    # name of the input given by an attribute left blank (ActionTools#implied_field_spec)
    implied = plugin.columns.keys.to_h { |name| [name, implied_input(klass, baseline, name)] }.compact
    if_blank = {}
    placeholders = []
    implied.each do |name, input|
      # a template where the attribute is processed: its input is present while the attribute is blank
      ctx = contexts.find { |c| c[:attributes][name].nil? && inputs_of(c[:spec]).key?(input) }
      next if ctx.nil?
      filled = call_specs(klass, ctx[:attributes].merge(name => filled_value(name, plugin.columns[name], form[name])), [])
      if_blank[input] = name if filled && !inputs_of(filled).key?(input)
      placeholders << name if text_columns.include?(name) && placeholder?(klass, ctx[:attributes], name)
    end
    declares = {}
    singles.each do |ctx|
      # input or output whose name or type is the value of an attribute
      markers = text_columns.to_h { |name| [marker(name), "<#{name}>"] }
      filled = call_specs(klass, ctx[:attributes].merge(markers.to_h { |marker, attr| [attr[1..-2], marker] }), [])
      if filled
        {inputs: inputs_of(filled), outputs: filled[:outputs]}.each do |kind, found|
          found.each do |name, type|
            next unless markers.key?(name)
            ctx[:named][kind][markers[name]] = markers.fetch(type, type)
            ctx[:required_named] = (ctx[:required_named] || []) | [markers[name]] if kind == :inputs && filled[:required].key?(name)
          end
        end
      end
      text_columns.each do |name|
        # attribute that declares inputs or outputs: {'name'=>'type'} or ['name']
        if %w[type_map list hash].include?(form.dig(name, 'widget')) && !declares.key?(name)
          ["{'#{PLACEHOLDER_VAR}'=>'int'}", "['#{PLACEHOLDER_VAR}']"].each do |value|
            found = call_specs(klass, ctx[:attributes].merge(name => value), [])
            next if found.nil?
            kind = if found[:required].key?(PLACEHOLDER_VAR) then 'required_inputs'
                   elsif found[:optional].key?(PLACEHOLDER_VAR) then 'optional_inputs'
                   elsif found[:outputs].key?(PLACEHOLDER_VAR) then 'outputs'
                   end
            next if kind.nil?
            declares[name] = kind
            break
          end
        end
        next if placeholders.include?(name) || implied.key?(name) && if_blank.value?(name)
        placeholders << name if placeholder?(klass, ctx[:attributes], name)
      end
    end
    tested = variations.to_h { |attr, (values, _)| [attr, [baseline[attr]] + values] }
    choices = variations.select { |_, (_, choice)| choice }.keys
    {
      'inputs' => aggregate(contexts, singles, tested, choices, if_blank, :inputs),
      'outputs' => aggregate(contexts, singles, tested, choices, if_blank, :outputs),
      'placeholders' => placeholders,
      'declares' => declares
    }
  end

  # true if `<%= variable %>` in the attribute creates an input `variable`
  def placeholder?(klass, attributes, name)
    filled = call_specs(klass, attributes.merge(name => "<%= #{PLACEHOLDER_VAR} %>"), [])
    !filled.nil? && inputs_of(filled).key?(PLACEHOLDER_VAR)
  end

  def implied_input(klass, attributes, name)
    klass.new(attributes).implied_field_spec(name).first.to_s
  rescue Exception # rubocop:disable Lint/RescueException
    nil
  end

  def inputs_of(spec) = spec[:required].merge(spec[:optional])

  # Merge results of all contexts: type, required, condition on template settings
  # A value of an attribute is excluded when the item is present in a template, and absent in the same template with only this attribute changed to the value.
  def aggregate(contexts, singles, tested, choices, if_blank, kind)
    names = contexts.flat_map { |ctx| items(ctx, kind).keys }.uniq
    indexes = {contexts: contexts.to_h { |ctx| [ctx[:changed], ctx] }, singles: singles.to_h { |ctx| [ctx[:changed], ctx] }}
    names.to_h do |name|
      # names given by attribute values are tested with one attribute changed only
      pool = name.start_with?('<') ? singles : contexts
      index = indexes[name.start_with?('<') ? :singles : :contexts]
      present = pool.select { |ctx| items(ctx, kind).key?(name) }
      info = {'types' => present.map { |ctx| items(ctx, kind)[name] }.uniq.reject(&:empty?)}
      if kind == :inputs
        required = ->(ctx) { ctx[:spec][:required].key?(name) || ctx[:required_named].to_a.include?(name) }
        flags = present.map(&required).uniq
        info['required'] =
          if flags.size == 1 then flags.first
          else
            # templates where the input does not exist tell nothing on whether it is required
            condition = describe(present, index, tested, choices, domain: ->(ctx) { items(ctx, kind).key?(name) }, &required)
            condition['other_conditions'] ? 'depends' : condition
          end
      end
      # attributes that must all be blank, or all set
      lists = {'if_blank' => [if_blank[name]].compact, 'if_set' => []}
      if present.size != pool.size
        condition = describe(present, index, tested, choices) { |ctx| items(ctx, kind).key?(name) }
        lists.each_key { |key| lists[key] |= condition[key] if condition[key] }
        # a name given by an attribute exists only when the attribute is set
        lists['if_set'] -= [name[1..-2]] if name.start_with?('<')
        # a condition on values of an attribute tells when it may be blank
        lists['if_blank'] -= condition['when'].keys if condition['when']
        info['when'] = condition['when'] if condition['when']
        info['other_conditions'] = true if condition['other_conditions']
      end
      lists.each { |key, list| info[key] = list.size == 1 ? list.first : list unless list.empty? }
      if info['required'].is_a?(Hash)
        # conditions of existence are not repeated
        lists.each do |key, list|
          next unless info['required'][key]
          remaining = info['required'][key] - list
          if remaining.empty?
            info['required'].delete(key)
          else
            info['required'][key] = remaining.size == 1 ? remaining.first : remaining
          end
        end
        info['required'] = true if info['required'].empty?
      end
      [name, info]
    end
  end

  # Condition on template attributes for which the predicate is true, from contexts where it is true
  # @param choices [Array] attributes with allowed values (always set)
  # @return [Hash] 'when' => {attribute => {'in' => values} | {'not_in' => values}}, 'if_blank' => [attributes], 'if_set' => [attributes], or 'other_conditions' => true
  def describe(matching, index, tested, choices, domain: nil, &predicate)
    matching = matching.select(&predicate)
    result = {}
    condition = {}
    explained = false
    tested.each do |attr, values|
      allowed = []
      excluded = []
      matching.each do |ctx|
        allowed << ctx[:attributes][attr]
        others = ctx[:changed].except(attr)
        values.each do |value|
          # the same template with only this attribute changed
          neighbour = index[value == values.first ? others : others.merge(attr => value)]
          next if neighbour.nil? || domain && !domain.call(neighbour)
          (predicate.call(neighbour) ? allowed : excluded) << value
        end
      end
      excluded = excluded.uniq - allowed
      next if excluded.empty?
      explained = true
      ok = values - excluded
      # nil is the value of an attribute not set: true only then means "if blank"
      if ok == [nil]
        (result['if_blank'] ||= []) << attr
        next
      end
      set_values = values.compact
      blank_ok = ok.include?(nil) && allowed.include?(nil)
      ok = ok.compact
      if ok.size == set_values.size
        # false only when the attribute is not set: a condition for an attribute without allowed values
        (result['if_set'] ||= []) << attr unless choices.include?(attr)
        next
      end
      # nil in list `in`: also when the attribute is blank; `not_in`: set to another value
      condition[attr] =
        if blank_ok then {'in' => [nil] + ok}
        elsif ok.size <= set_values.size - ok.size then {'in' => ok}
        else {'not_in' => set_values - ok}
        end
    end
    result['when'] = condition unless condition.empty?
    result['other_conditions'] = true unless explained
    result
  end

  def items(ctx, kind)
    found = kind == :inputs ? inputs_of(ctx[:spec]) : ctx[:spec][:outputs]
    # a name given by an attribute is empty when the attribute is blank, and the marker when it is filled
    found.except('').to_h { |name, type| [ctx.dig(:derived, kind, name) || unmark(name), unmark(type)] }.merge(ctx[:named][kind])
  end

  # Names that change with the value of a filled attribute are given by this value: name => <attribute>
  def derived_names(klass, ctx)
    derived = {inputs: {}, outputs: {}}
    ctx[:changed].each do |attr, value|
      next unless value.is_a?(String) && value.start_with?(MARKER_PREFIX)
      other = call_specs(klass, ctx[:attributes].merge(attr => value.sub(MARKER_PREFIX, OTHER_MARKER_PREFIX)), [])
      next if other.nil?
      {inputs: [inputs_of(ctx[:spec]), inputs_of(other)], outputs: [ctx[:spec][:outputs], other[:outputs]]}.each do |kind, (found, other_found)|
        (found.keys - other_found.keys).each { |name| derived[kind][name] = "<#{attr}>" unless name.start_with?(MARKER_PREFIX) }
      end
    end
    derived
  end

  def unmark(text) = text.start_with?(MARKER_PREFIX) ? "<#{text.delete_prefix(MARKER_PREFIX)}>" : text
end

if $PROGRAM_NAME == __FILE__
  actions_dir, lib_dir = ARGV
  abort("Usage: #{$PROGRAM_NAME} <actions_dir> <lib_dir>") if lib_dir.nil?
  $stdout.write(JSON.pretty_generate(PluginProbe.new(actions_dir, lib_dir).run))
end
