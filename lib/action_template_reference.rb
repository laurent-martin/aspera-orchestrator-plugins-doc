# frozen_string_literal: true

# Generates the Markdown reference of Orchestrator action templates (plugins)
# from an Orchestrator `actions` directory (source tree or RPM extract).
# No Rails needed: metadata, migrations and plugin classes are parsed as text.
#
# Usage: ruby lib/action_template_reference.rb <actions_dir> <output.md> [<orchestrator_version>]

require 'yaml'

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

  Plugin = Struct.new(:dir, :plugin_name, :display_name, :category, :description, :version, :min_server, :columns, :constants, :inputs, :outputs, :notes)

  def initialize(actions_dir)
    @actions_dir = actions_dir
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

  def parse_plugin(path)
    metadata = YAML.safe_load_file(File.join(path, 'metadata.yml'), permitted_classes: [Symbol, Date, Time])
    history = Array(metadata[:revision_history])
    latest = history.max_by { |rev| Gem::Version.new(rev[:version].to_s) } || {}
    class_file = Dir.glob(File.join(path, '*.rb')).reject { |f| File.basename(f).match?(/^\d/) }.first
    source = class_file ? File.read(class_file) : ''
    constants = parse_constants(source)
    columns = parse_migrations(Dir.glob(File.join(path, '*.rb')).select { |f| File.basename(f).match?(/^\d/) }.sort)
    plugin = Plugin.new(path, metadata[:plugin_name].to_s, metadata[:display_name], metadata[:category], metadata[:description],
      latest[:version].to_s, latest[:minimum_server_version], columns, constants, {}, {}, [])
    columns.each do |name, col|
      code_default = constants["DEFAULT_#{name.upcase}"]
      col[:code_default] = unquote(code_default) if col[:default].nil? && code_default && code_default != 'nil'
    end
    analyze_inputs(plugin, method_body(source, 'inputs_spec'))
    analyze_outputs(plugin, method_body(source, 'outputs_spec'))
    plugin
  end

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
  actions_dir, output, version = ARGV
  abort("Usage: #{$PROGRAM_NAME} <actions_dir> <output.md> [<version>]") if output.nil?
  File.write(output, ActionTemplateReference.new(actions_dir).markdown(version || ''))
  puts "Generated #{output}"
end
