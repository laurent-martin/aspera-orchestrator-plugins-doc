# frozen_string_literal: true

# Generates the reference of Orchestrator action templates (plugins), in Markdown and YAML,
# from an Orchestrator `actions` directory (source tree or RPM extract).
# No Rails needed: metadata, migrations and plugin classes are parsed as text.
# The YAML file also uses the result of PluginProbe (lib/plugin_probe.rb), which evaluates plugin code.
#
# Usage: ruby lib/action_template_reference.rb <actions_dir> <output.md|output.yml> [<orchestrator_version> [<probe.json>]]

require 'yaml'
require 'json'

class ActionTemplateReference
  # MultiType constants used in plugin code
  TYPE_CONSTANTS = {
    'TYPE_INT' => 'int', 'TYPE_FLOAT' => 'float', 'TYPE_STRING' => 'string', 'TYPE_ARRAY' => 'array',
    'TYPE_HASH' => 'hash', 'TYPE_FLAG' => 'flag', 'TYPE_DATE' => 'date', 'TYPE_OBJECT' => 'object',
    'TYPE_PASSWORD' => 'pwd', 'TYPE_ATTACHMENT' => 'attachment'
  }.freeze
  ALL_TYPES = TYPE_CONSTANTS.values.freeze
  # MultiType::MAP_TYPE: column type to value type
  COLUMN_TO_VALUE_TYPE = {'string' => 'string', 'text' => 'string', 'mediumtext' => 'string', 'integer' => 'int', 'boolean' => 'flag', 'datetime' => 'date', 'float' => 'float'}.freeze
  # Columns not part of the configuration
  IGNORED_COLUMNS = %w[id created_at updated_at].freeze

  # Widget of the template editor (PluginProbe) to the value shown in the YAML file
  WIDGETS = {
    'text_field' => 'text', 'email_field' => 'text', 'url_field' => 'text', 'text_area' => 'multiline_text', 'password_field' => 'password',
    'number_field' => 'number', 'radio_button' => 'select', 'hidden_field' => 'hidden', 'file_field' => 'file_upload',
    'date_field' => 'date', 'time_field' => 'time', 'datetime_field' => 'date'
  }.freeze
  # Widget not written in the YAML file, by column type
  DEFAULT_WIDGETS = {'string' => 'text', 'text' => 'text', 'mediumtext' => 'text', 'boolean' => 'boolean', 'integer' => 'text', 'bigint' => 'text', 'float' => 'text'}.freeze
  # Columns of every template, not written in the YAML file
  COMMON_COLUMNS = %w[name comments].freeze
  # Notes made useless by the evaluation of the plugin
  PROBED_NOTES = /has conditions|No `inputs_spec`|No `outputs_spec`/

  Plugin = Struct.new(:dir, :plugin_name, :display_name, :category, :description, :version, :min_server, :columns, :constants, :inputs, :outputs, :notes)

  # @param probe [Hash, nil] result of PluginProbe: plugin name => form, inputs, outputs, placeholders, errors
  def initialize(actions_dir, probe = nil)
    @actions_dir = actions_dir
    @probe = probe || {}
  end

  YAML_HEADER = <<~HEADER
    # Aspera Orchestrator %<version>s action plugins: template attributes, inputs and outputs.
    # Generated from the plugin source code: do not edit.
    # How to use it in a workflow file: see workflow-authoring-guide.md.
    #
    # <PluginClass>:          Step_type of a step, and class of its action template (key <PluginClass>__<N>)
    #   attributes:           fields of the action template (element 3 of a workflow file), besides name and comments
    #     <attribute>:
    #       type:             database column type; in plain format, write a boolean as 1 or 0
    #       label:            label in the template editor, when it is not the attribute name (aws_key: Aws key)
    #       widget:           when not text or boolean: select, multiline_text, password, number, remote_node (name of a remote node),
    #                         type_map ({'name'=>'type'}), list, hash, file, action_template (name of a template)
    #       values:           allowed values
    #       dynamic_values:   true: allowed values come from the server or an external system
    #       run_time_value:   remote_node: value that makes the node an input of the step
    #       default:          database default
    #       code_default:     value used by the plugin when the attribute is blank
    #       hint:             placeholder text in the template editor
    #       format:           language of the value (code editor)
    #       placeholders:     true: each <%%= variable %%> in the value creates a required input `variable`;
    #                         also true for every text attribute named by the if_blank of an input
    #       declares:         the value declares inputs or outputs of the step (required_inputs, optional_inputs, outputs),
    #                         as {'name'=>'type'} (type_map) or ['name'] (list)
    #   inputs, outputs:
    #     <name>:             a name in angle brackets is the value of that template attribute
    #       type:             value type: string, int, float, flag, date, array, hash, object, pwd, attachment
    #       required:         inputs: the input must be mapped (false: optional)
    #       if_blank:         exists only when this template attribute is blank (inputs: it replaces the attribute)
    #       when:             exists only for some values of a template attribute: {<attribute>: {in: [...]}} or {not_in: [...]}
    #   notes:                limits of the information above
    #
    # Inputs and outputs were found by calling the plugin with each attribute changed in turn from the default template.
  HEADER

  def yaml(version)
    data = plugins.to_h { |plugin| [plugin.plugin_name, plugin_spec(plugin)] }
    # copy through JSON: no shared object, so no YAML alias
    stream = Psych.parse_stream(Psych.dump(JSON.parse(JSON.generate(data)), line_width: -1))
    flow_style(stream.children.first.root, [])
    format(YAML_HEADER, version: version) + stream.to_yaml(nil, line_width: -1)
  end

  def plugins
    Dir.children(@actions_dir).sort.filter_map do |dir|
      path = File.join(@actions_dir, dir)
      next unless File.exist?(File.join(path, 'metadata.yml'))
      parse_plugin(path)
    rescue StandardError => e
      warn("#{dir}: #{e.class}: #{e.message}")
      nil
    end.sort_by(&:plugin_name)
  end

  def markdown(version)
    list = plugins
    out = []
    out << '<!--'
    out << 'PANDOC_DEFAULTS_BEGIN'
    out << 'metadata:'
    out << '  title: "Aspera Orchestrator Action Template Reference"'
    out << '  author: "IBM Aspera"'
    out << 'PANDOC_DEFAULTS_END'
    out << '-->'
    out << ''
    out << "# Aspera Orchestrator #{version} Action Template Reference"
    out << ''
    out << '> Generated from the Orchestrator `actions` directory: do not edit.'
    out << '> See the [Workflow Authoring Guide](workflow-authoring-guide.md) for how to use this reference.'
    out << ''
    out << 'For each action plugin, this reference lists:'
    out << ''
    out << '- **Template attributes**: the fields of an action template, as written in element 3 (action templates) of a workflow file.'
    out << '  Built from the database migrations of the plugin.'
    out << '  For a text field left blank in the template, the column **Input if blank** gives the name of the step input that replaces it (see `default_inputs_spec`).'
    out << '- **Inputs** and **Outputs**: names and types found in methods `inputs_spec` and `outputs_spec` of the plugin class.'
    out << '  They are extracted from source text: when the method computes names at run time (for example from a template field), the list is incomplete and a note says so.'
    out << '  Every step also has output `Step_information` (`hash`).'
    out << '- **Default**: the database default of the attribute, or, marked `(code)`, the value used by the plugin when the attribute is blank.'
    out << ''
    out << '## Index'
    out << ''
    out << '| Plugin | Display name | Category | Version |'
    out << '|--------|--------------|----------|---------|'
    list.each do |plugin|
      out << "| [#{plugin.plugin_name}](##{anchor(plugin.plugin_name)}) | #{cell(plugin.display_name)} | #{cell(plugin.category)} | #{plugin.version} |"
    end
    out << ''
    list.each { |plugin| out.concat(plugin_section(plugin)) }
    out.join("\n")
  end

  private

  # @return [Hash] entry of a plugin in the YAML file
  def plugin_spec(plugin)
    probe = @probe[plugin.plugin_name] || {}
    form = probe['form'] || {}
    probed = probe.key?('inputs')
    spec = {
      'display_name' => plugin.display_name.to_s.strip,
      'category' => plugin.category.to_s.strip,
      'version' => plugin.version,
      'min_orchestrator' => plugin.min_server&.to_s,
      'description' => plugin.description.to_s.gsub(/\s+/, ' ').strip
    }.reject { |_, value| value.nil? || value.empty? }
    inputs = probed ? probe['inputs'] : static_io(plugin.inputs, true)
    outputs = probed ? probe['outputs'] : static_io(plugin.outputs, false).merge('Step_information' => {'types' => ['hash']})
    unless probed
      # input that replaces a blank attribute, found in source text
      plugin.columns.each { |name, col| inputs[col[:input]]['if_blank'] = name if col[:input] && inputs[col[:input]] }
    end
    blank_inputs = inputs.filter_map { |_, info| info['if_blank'] }
    spec['attributes'] = plugin.columns.except(*COMMON_COLUMNS).to_h do |name, col|
      info = form[name] || {}
      attribute = {'type' => col[:type]}
      attribute['label'] = info['label'] if info['label'] && info['label'] != humanize(name)
      widget = WIDGETS.fetch(info['widget'], info['widget'])
      attribute['widget'] = widget if widget && widget != DEFAULT_WIDGETS[col[:type]]
      attribute['values'] = info['values'] if info['values']
      attribute['dynamic_values'] = true if info['dynamic_values'] && !info['values']
      %w[run_time_value action_type format hint].each { |key| attribute[key] = info[key] if info[key] }
      attribute['default'] = typed_default(col[:default], col[:type]) unless col[:default].nil?
      if col[:default].nil?
        code_default = probe['code_defaults']&.key?(name) ? probe['code_defaults'][name] : col[:code_default] && typed_default(col[:code_default], col[:type])
        attribute['code_default'] = code_default unless code_default.nil? || code_default == ''
      end
      # a text attribute that gives an input when blank always accepts placeholders
      attribute['placeholders'] = true if probe['placeholders']&.include?(name) && !blank_inputs.include?(name)
      attribute['declares'] = probe['declares'][name] if probe['declares']&.key?(name)
      [name, attribute]
    end
    spec['inputs'] = io_spec(inputs, true)
    spec['outputs'] = io_spec(outputs, false)
    notes = plugin.notes.uniq
    # angle brackets are explained in the header of the file
    notes = notes.grep_v(/angle brackets/)
    if probed
      notes = notes.grep_v(PROBED_NOTES)
    else
      notes << "Inputs and outputs found in source text only (the plugin could not be evaluated: #{probe['errors']&.first || 'no probe'}): conditions and required flags may be missing."
    end
    spec['notes'] = notes.map { |note| note.delete('`') } unless notes.empty?
    spec
  end

  # Inputs or outputs found in source text, in the format of PluginProbe
  def static_io(items, inputs)
    items.to_h do |name, info|
      entry = {'types' => info[:types]}
      entry['required'] = info[:required] if inputs && !info[:required].nil?
      [name, entry]
    end
  end

  def io_spec(items, inputs)
    items.to_h do |name, info|
      types = info['types'] || []
      entry = {}
      entry['type'] = types.size == 1 ? types.first : types unless types.empty?
      entry['required'] = info['required'] if inputs && !info['required'].nil?
      entry['if_blank'] = info['if_blank'] || info['when_blank'] if info['if_blank'] || info['when_blank']
      entry['when'] = info['when'] if info['when']
      [name, entry]
    end
  end

  # Rails label of an attribute
  def humanize(name) = name.tr('_', ' ').downcase.sub(/\A\w/, &:upcase)

  # Flow style (one line) for each attribute, input and output: plugin > attributes|inputs|outputs > name
  def flow_style(node, path)
    if path.size == 3 && %w[attributes inputs outputs].include?(path[1])
      all_flow(node)
    elsif node.is_a?(Psych::Nodes::Mapping)
      node.children.each_slice(2) { |key, value| flow_style(value, path + [key.value]) }
    end
  end

  def all_flow(node)
    case node
    when Psych::Nodes::Sequence then node.style = Psych::Nodes::Sequence::FLOW
    when Psych::Nodes::Mapping then node.style = Psych::Nodes::Mapping::FLOW
    when Psych::Nodes::Scalar
      # a string that cannot be plain in flow style (for example with a comma) is quoted, without tag `!`
      node.quoted = true
      return
    else return
    end
    node.children.each { |child| all_flow(child) }
  end

  def typed_default(value, type)
    case type
    when 'boolean' then %w[true 1 t].include?(value.to_s)
    when 'integer', 'bigint' then Integer(value, exception: false) || value
    when 'float', 'decimal' then Float(value, exception: false) || value
    else value
    end
  end

  def anchor(text) = text.downcase.gsub(/[^a-z0-9 -]/, '').tr(' ', '-')

  def cell(text) = text.to_s.gsub('|', '\\|').gsub(/\s+/, ' ').strip

  def plugin_section(plugin)
    out = []
    out << "## #{plugin.plugin_name}"
    out << ''
    out << "- **Display name**: #{cell(plugin.display_name)}"
    out << "- **Category**: #{cell(plugin.category)}"
    out << "- **Version**: #{plugin.version}#{" (requires Orchestrator #{plugin.min_server} or later)" if plugin.min_server}"
    out << "- **Description**: #{cell(plugin.description)}" unless plugin.description.to_s.strip.empty?
    out << ''
    out << '### Template attributes'
    out << ''
    if plugin.columns.empty?
      out << 'None.'
    else
      out << '| Attribute | Type | Default | Input if blank |'
      out << '|-----------|------|---------|----------------|'
      plugin.columns.each do |name, col|
        default = col[:default].nil? ? (col[:code_default] ? "`#{cell(col[:code_default])}` (code)" : '') : "`#{cell(col[:default])}`"
        out << "| `#{name}` | #{col[:type]} | #{default} | #{col[:input] ? "`#{col[:input]}`" : ''} |"
      end
    end
    out << ''
    out << '### Inputs'
    out << ''
    out.concat(io_list(plugin.inputs))
    out << ''
    out << '### Outputs'
    out << ''
    out.concat(io_list(plugin.outputs))
    out << '- `Step_information` (`hash`)'
    out << ''
    unless plugin.notes.empty?
      out << '### Notes'
      out << ''
      plugin.notes.uniq.each { |note| out << "- #{note}" }
      out << ''
    end
    out
  end

  def io_list(items)
    return ['- None found in source.'] if items.empty?
    items.map do |name, info|
      types = info[:types].map { |t| "`#{t}`" }.join(' or ')
      qualifier = [types.empty? ? nil : types, info[:required].nil? ? nil : (info[:required] ? 'required' : 'optional')].compact.join(', ')
      "- `#{name}`#{" (#{qualifier})" unless qualifier.empty?}"
    end
  end

  public

  # @return [Plugin] information found in source text of the plugin folder
  def parse_plugin(path)
    metadata = YAML.safe_load_file(File.join(path, 'metadata.yml'), permitted_classes: [Symbol, Date, Time])
    history = Array(metadata[:revision_history])
    latest = history.max_by { |rev| Gem::Version.new(rev[:version].to_s) } || {}
    # the plugin class includes module Action (other files: migrations, helpers, controllers)
    class_files = Dir.glob(File.join(path, '*.rb')).reject { |f| File.basename(f).match?(/^\d/) }.sort
    class_file = class_files.find { |f| File.read(f).match?(/^\s*include\s+Action\b/) } || class_files.first
    source = class_file ? File.read(class_file) : ''
    constants = parse_constants(source)
    columns = parse_migrations(Dir.glob(File.join(path, '*.rb')).select { |f| File.basename(f).match?(/^\d/) }.sort)
    # Step_type is the class name, which may differ from the name in metadata
    class_name = source[/^class\s+(\w+)\s*<\s*(?:ActiveRecord::Base|ApplicationRecord)\b/, 1] || metadata[:plugin_name].to_s
    plugin = Plugin.new(path, class_name, metadata[:display_name], metadata[:category], metadata[:description],
      latest[:version].to_s, latest[:minimum_server_version], columns, constants, {}, {}, [])
    plugin.notes << "The name in `metadata.yml` is `#{metadata[:plugin_name]}`: use the class name `#{class_name}`." if class_name != metadata[:plugin_name].to_s
    columns.each do |name, col|
      code_default = constants["DEFAULT_#{name.upcase}"]
      col[:code_default] = unquote(code_default) if col[:default].nil? && code_default && code_default != 'nil'
    end
    analyze_inputs(plugin, method_body(source, 'inputs_spec'))
    analyze_outputs(plugin, method_body(source, 'outputs_spec'))
    plugin
  end

  private

  # Constants defined at class level: NAME = value
  def parse_constants(source)
    source.scan(/^\s{2}([A-Z][A-Z0-9_]*)\s*=\s*(.+?)\s*(?:#.*)?$/).to_h
  end

  def unquote(value)
    return nil if value.nil?
    m = value.strip.match(/\A(['"])(.*)\1\z/)
    m ? m[2] : value.strip
  end

  # Columns of the template table, applying migrations in order (only up/change part)
  def parse_migrations(files)
    columns = {}
    files.each do |file|
      text = File.read(file).split(/^\s*def\s+(?:self\.)?down\b/).first
      text.each_line do |line|
        case line
        when /^\s*t\.(string|text|boolean|integer|datetime|float|decimal|mediumtext)\s+[:"]([a-zA-Z0-9_]+)"?(.*)$/
          columns[Regexp.last_match(2)] = {type: Regexp.last_match(1), default: default_of(Regexp.last_match(3))}
        when /^\s*t\.column\s+[:"]([a-zA-Z0-9_]+)"?\s*,\s*:(\w+)(.*)$/
          columns[Regexp.last_match(1)] = {type: Regexp.last_match(2), default: default_of(Regexp.last_match(3))}
        when /^\s*add_column\s+:\w+\s*,\s*[:"]([a-zA-Z0-9_]+)"?\s*,\s*:(\w+)(.*)$/
          columns[Regexp.last_match(1)] = {type: Regexp.last_match(2), default: default_of(Regexp.last_match(3))}
        when /^\s*change_column\s+:\w+\s*,\s*[:"]([a-zA-Z0-9_]+)"?\s*,\s*:(\w+)(.*)$/
          col = columns[Regexp.last_match(1)] ||= {}
          col[:type] = Regexp.last_match(2)
          default = default_of(Regexp.last_match(3))
          col[:default] = default unless default.nil?
        when /^\s*change_column_default\s+:\w+\s*,\s*[:"]([a-zA-Z0-9_]+)"?\s*,\s*(.+)$/
          col = columns[Regexp.last_match(1)] ||= {}
          col[:default] = Regexp.last_match(2).sub(/\A.*to:\s*/, '').sub(/\)\s*\z/, '').strip
        when /^\s*remove_column\s+:\w+\s*,\s*[:"]([a-zA-Z0-9_]+)"?/
          columns.delete(Regexp.last_match(1))
        when /^\s*rename_column\s+:\w+\s*,\s*[:"]([a-zA-Z0-9_]+)"?\s*,\s*[:"]([a-zA-Z0-9_]+)"?/
          columns[Regexp.last_match(2)] = columns.delete(Regexp.last_match(1)) || {type: '?'}
        end
      end
    end
    columns.except(*IGNORED_COLUMNS)
  end

  def default_of(rest)
    m = rest.match(/default:\s*("(?:[^"\\]|\\.)*"|'(?:[^'\\]|\\.)*'|[^,\s)]+)/)
    m && unquote(m[1])
  end

  # Text of method `name` (indented by 2), or nil
  def method_body(source, name)
    m = source.match(/^(\s*)def #{name}\b.*?\n(.*?)^\1end\b/m)
    m && m[2]
  end

  def resolve_name(plugin, token)
    token = token.strip
    return unquote(token) if token.match?(/\A(['"]).*\1\z/)
    value = plugin.constants[token]
    value && unquote(value)
  end

  def resolve_type(token)
    token = token.strip
    TYPE_CONSTANTS[token] || TYPE_CONSTANTS[token.sub(/\A\w+::/, '')] || (ALL_TYPES.include?(unquote(token)) ? unquote(token) : nil)
  end

  # Pairs `name => type` or `hash[name] = type` found in method body
  # A key that is a template attribute gives a name defined by the template: `<attribute>`
  def pairs(plugin, body)
    key_re = /([A-Z][A-Z0-9_:]*|'[^']+'|"[^"]+"|[a-z_][a-z0-9_]*)/
    type_re = /(\w+(?:::\w+)?|'[a-z]+'|"[a-z]+")/
    found = body.scan(/#{key_re}\s*=>\s*#{type_re}/) + body.scan(/\[\s*#{key_re}\s*\]\s*=\s*#{type_re}/)
    found.filter_map do |key, type|
      name = plugin.columns.key?(key) ? "<#{key}>" : resolve_name(plugin, key)
      value_type = resolve_type(type) || (plugin.columns.key?(type) ? "<#{type}>" : nil)
      [name, value_type] if name && value_type
    end
  end

  def analyze_inputs(plugin, body)
    if body.nil?
      plugin.notes << 'No `inputs_spec` in plugin class: every template field left blank becomes an input (default behavior).'
      plugin.columns.each_key { |field| field_input(plugin, field) }
      return
    end
    # fields passed to default_inputs_spec become inputs when blank in the template
    body.scan(/default_inputs_spec\(\s*\[([^\]]*)\]/).each do |(list)|
      list.scan(/:(\w+)/).flatten.each { |field| field_input(plugin, field) }
    end
    pairs(plugin, body).each { |name, type| add_io(plugin.inputs, name, type) }
    plugin.notes << 'Method `inputs_spec` has conditions: some inputs exist only for some template settings.' if body.match?(/\bif\b|\bunless\b|\?\s/)
    plugin.notes << 'A name in angle brackets (`<attribute>`) is the value of that template attribute.' if (plugin.inputs.keys + plugin.inputs.values.flat_map { |v| v[:types] }).any? { |n| n.start_with?('<') }
    if body.match?(/convert_value_hash|eval\(|Payload\.variables|inputs_spec_code/)
      plugin.notes << 'Inputs are partly defined by template fields (for example a list of inputs, or `<%= variable %>` placeholders): see the template attributes.'
    end
  end

  # Input created when template field is blank (ActionTools#default_inputs_spec)
  def field_input(plugin, field)
    col = plugin.columns[field]
    return if col.nil?
    implied = field
    type = COLUMN_TO_VALUE_TYPE[col[:type]] || 'string'
    if (m = field.match(/\A(.*)_(#{ALL_TYPES.join('|')})\z/))
      implied = m[1]
      type = m[2]
    end
    var = plugin.constants["VAR_#{implied.upcase}"]
    name = (var && unquote(var).is_a?(String) && !unquote(var).empty? && unquote(var) != 'false') ? unquote(var) : implied.capitalize
    optional = plugin.constants.key?("DEFAULT_#{field.upcase}")
    col[:input] = name
    add_io(plugin.inputs, name, type, required: !optional)
  end

  # Record an input or output, accumulating the possible types
  def add_io(items, name, type, required: nil)
    item = items[name] ||= {types: [], required: required}
    item[:types] |= [type]
  end

  def analyze_outputs(plugin, body)
    return plugin.notes << 'No `outputs_spec` in plugin class.' if body.nil?
    pairs(plugin, body).each { |name, type| add_io(plugin.outputs, name, type) }
    plugin.notes << 'Method `outputs_spec` has conditions: some outputs exist only for some template settings.' if body.match?(/\bif\b|\bunless\b|\?\s/)
    plugin.notes << 'A name in angle brackets (`<attribute>`) is the value of that template attribute.' if (plugin.outputs.keys + plugin.outputs.values.flat_map { |v| v[:types] }).any? { |n| n.start_with?('<') }
    if body.match?(/convert_value_hash|eval\(|outputs_spec_code|\w+ => variable_type|fanned_as/)
      plugin.notes << 'Outputs are partly defined by template fields: see the template attributes.'
    end
  end
end

if $PROGRAM_NAME == __FILE__
  actions_dir, output, version, probe_file = ARGV
  abort("Usage: #{$PROGRAM_NAME} <actions_dir> <output.md|output.yml> [<version> [<probe.json>]]") if output.nil?
  reference = ActionTemplateReference.new(actions_dir, probe_file && JSON.parse(File.read(probe_file)))
  File.write(output, output.end_with?('.yml') ? reference.yaml(version || '') : reference.markdown(version || ''))
  puts "Generated #{output}"
end
