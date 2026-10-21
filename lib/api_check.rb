# frozen_string_literal: true

# Compares the REST API of Orchestrator (routes and controller source of an RPM extract) with an OpenAPI description.
# No Rails needed: `config/routes.rb` and the controllers are parsed as text.
# Reports: endpoints missing in the OpenAPI file or not implemented, HTTP methods that differ,
# and for each endpoint the parameters read by the source and not declared, or declared and not read.
# The parameters of a request body read as a whole (`request.body`) cannot be found: such endpoints are reported.
#
# Usage: ruby lib/api_check.rb <orchestrator_dir> <openapi.yaml>

require 'yaml'

# Comparison of the Orchestrator API (source) with an OpenAPI description
class ApiCheck
  # Parameters that are not specific to an endpoint
  COMMON_PARAMETERS = %w[format controller action login password apikey].freeze
  # Parameters read by an endpoint, that are not part of the API (web interface, error messages, request wrapper)
  INTERNAL_PARAMETERS = {
    # `work_order`: Rails wraps the JSON body in it; `outputs`: alias of `external_parameters`; `redirect`, `id`: pages of the web interface
    'initiate' => %w[work_order outputs redirect id],
    # `id`: only in error messages
    'custom_api_call' => %w[id]
  }.freeze
  # Reading a request parameter: params[:x], params["x"], params.fetch(:x), params.key?(:x), params.dig(:x)...
  PARAMETER_READ = /params(?:\[|\.(?:fetch|key\?|dig|require|has_key\?|include\?)\(\s*)[:"']([A-Za-z_]\w*)/.freeze
  # Explicit route of the API: get "api/<name>", to: "<controller>#<action>"
  ROUTE = %r{^\s*(get|post|put|patch|delete|match)\s+"api/([a-z_]+)[^"]*",\s*to:\s*"([a-z_/]+)#([a-z_]+)"}.freeze
  # Generic route: any public action of ApiController, with an id in the path, any HTTP method
  GENERIC_ROUTE = %r{match\s+"api/:action/:id", controller: "api"}.freeze

  Endpoint = Struct.new(:name, :controller, :action, :http_methods, :generic, keyword_init: true)

  # @param orchestrator_dir [String] Root of Orchestrator in the RPM extract (contains `app` and `config`)
  # @param openapi_path     [String] OpenAPI file (YAML)
  def initialize(orchestrator_dir, openapi_path)
    @dir = orchestrator_dir
    @openapi = YAML.load_file(openapi_path)
    @controllers = {}
  end

  # @return [Hash{String=>Endpoint}] Endpoints of the API, by name (`api/<name>`)
  def endpoints
    return @endpoints if @endpoints

    @endpoints = {}
    routes = File.read(File.join(@dir, 'config', 'routes.rb'))
    if routes.match?(GENERIC_ROUTE)
      public_methods('api').each do |action|
        next unless renders?('api', action)

        @endpoints[action] =
          Endpoint.new(name: action, controller: 'api', action: action, http_methods: [], generic: true)
      end
    end
    routes.each_line do |line|
      m = line.match(ROUTE) or next
      endpoint = (@endpoints[m[2]] ||= Endpoint.new(name: m[2], controller: m[3], action: m[4], http_methods: [],
                                                    generic: false))
      endpoint.http_methods |= [m[1].eql?('match') ? 'any' : m[1]]
    end
    # namespace :api do post "login", to: "sessions#create" end
    if (m = routes.match(/namespace :api do\s+(get|post)\s+"([a-z_]+)",\s*to:\s*"([a-z_]+)#([a-z_]+)"/))
      @endpoints[m[2]] =
        Endpoint.new(name: m[2], controller: "api/#{m[3]}", action: m[4], http_methods: [m[1]], generic: false)
    end
    @endpoints
  end

  # @return [Hash] `missing`: endpoints not in the OpenAPI file, `unknown`: paths of the OpenAPI file not implemented,
  #   `endpoints`: name => differences (`methods`, `not_declared`, `not_read`, `body`)
  def compare
    declared = openapi_endpoints
    result = {
      'missing' => (endpoints.keys - declared.keys).sort,
      'unknown' => (declared.keys - endpoints.keys).sort,
      'endpoints' => {}
    }
    (endpoints.keys & declared.keys).sort.each do |name|
      endpoint = endpoints[name]
      spec = declared[name]
      read = parameters_read(endpoint.controller, endpoint.action)
      differences = {}
      explicit = endpoint.http_methods - ['any']
      unless explicit.empty? || (spec[:methods] - explicit).empty?
        differences['methods'] =
          { 'route' => explicit,
            'openapi' => spec[:methods] }
      end
      not_declared = read[:names] - spec[:parameters] - COMMON_PARAMETERS - INTERNAL_PARAMETERS.fetch(name, [])
      not_declared -= ['id'] if spec[:path_id]
      differences['not_declared'] = not_declared unless not_declared.empty?
      not_read = spec[:parameters] - read[:names] - COMMON_PARAMETERS
      # the id segment of the path is required by the route, even if the endpoint does not use it
      not_read -= ['id'] if spec[:path_id]
      differences['not_read'] = not_read unless not_read.empty? || read[:body]
      differences['body'] = 'request body read as a whole: parameters not checked' if read[:body]
      # without explicit route, only `api/<name>/<id>` is routed
      differences['path'] = "only `api/#{name}/{id}` is routed" if endpoint.http_methods.empty? && !spec[:path_id]
      if read[:format_default] && spec[:format_default] && !read[:format_default].eql?(spec[:format_default])
        differences['format'] = "format default: #{read[:format_default]}, OpenAPI #{spec[:format_default]}"
      end
      result['endpoints'][name] = differences unless differences.empty?
    end
    result
  end

  # @return [String] Report in Markdown
  def markdown
    result = compare
    out = ["# Orchestrator API compared with #{@openapi.dig('info', 'title')} #{@openapi.dig('info', 'version')}", '']
    out.push("Endpoints implemented: #{endpoints.size}, in the OpenAPI file: #{openapi_endpoints.size}.", '')
    out.push("Not in the OpenAPI file: #{list(result['missing'])}", '')
    out.push("In the OpenAPI file, not implemented: #{list(result['unknown'])}", '')
    out.push("Endpoints with differences: #{result['endpoints'].size}", '')
    unless result['endpoints'].empty?
      out.push('| Endpoint | Read, not declared | Declared, not read | Other |', '|---|---|---|---|')
      result['endpoints'].each do |name, diff|
        methods = diff['methods'] && "methods: route #{diff['methods']['route'].join('/')}, OpenAPI #{diff['methods']['openapi'].join('/')}"
        other = [diff['body'], methods, diff['path'], diff['format']].compact.join('; ')
        out.push("| `#{name}` | #{list(diff['not_declared'])} | #{list(diff['not_read'])} | #{other} |")
      end
    end
    out.join("\n") + "\n"
  end

  private

  def list(names)
    names.nil? || names.empty? ? '-' : names.map { |n| "`#{n}`" }.join(', ')
  end

  # @return [Hash{String=>Hash}] name => {methods:, parameters:, path_id:}
  def openapi_endpoints
    @openapi_endpoints ||= (@openapi['paths'] || {}).each_with_object({}) do |(path, operations), result|
      name = path[%r{\A/api/([a-z_]+)}, 1] or next
      entry = (result[name] ||= { methods: [], parameters: [], path_id: false })
      entry[:path_id] ||= path.include?('{id}')
      operations.each do |method, operation|
        next unless operation.is_a?(Hash) && %w[get post put patch delete].include?(method)

        entry[:methods] |= [method]
        (Array(operations['parameters']) + Array(operation['parameters'])).each do |parameter|
          parameter = resolve(parameter)
          entry[:parameters] |= [parameter['name']] if parameter['name']
          entry[:format_default] ||= parameter.dig('schema', 'default') if parameter['name'].eql?('format')
        end
        (operation.dig('requestBody', 'content') || {}).each_value do |content|
          entry[:parameters] |= (resolve(content['schema'] || {})['properties'] || {}).keys
        end
      end
    end
  end

  # Resolve a local reference (`#/components/...`)
  def resolve(object)
    return object unless object.is_a?(Hash) && object['$ref'].is_a?(String) && object['$ref'].start_with?('#/')

    @openapi.dig(*object['$ref'].delete_prefix('#/').split('/')) || {}
  end

  # @return [Hash{String=>String}] Source of each method of the controller
  def methods_of(controller)
    @controllers[controller] ||= begin
      lines = File.read(File.join(@dir, 'app', 'controllers', "#{controller}_controller.rb")).lines
      visibility = :public
      result = {}
      current = nil
      lines.each do |line|
        visibility = Regexp.last_match(1).to_sym if line =~ /^  (private|protected|public)\s*$/
        if (m = line.match(/^  def (?:self\.)?([a-z_?!]+)/))
          current = m[1]
          result[current] = { visibility: visibility, source: +'' }
        end
        # comments (also those of the next method, before its `def`) are not code
        result[current][:source] << line.sub(/(^|\s)#(?![{]).*$/, '\1') if current
      end
      result
    end
  end

  def public_methods(controller)
    methods_of(controller).select { |_, method| method[:visibility].eql?(:public) }.keys
  end

  # @return [Array<String>] Source of the action, and of the methods of the controller that it calls, directly or not
  def sources(controller, action)
    methods = methods_of(controller)
    visited = []
    pending = [action]
    until pending.empty?
      name = pending.shift
      next if visited.include?(name) || !methods.key?(name)

      visited.push(name)
      # a method name in a string literal (e.g. an XML root name), or assigned as a local variable, is not a call
      code = methods[name][:source].gsub(/"(?:[^"\\]|\\.)*"|'(?:[^'\\]|\\.)*'/, '""')
      variables = code.scan(/(?<![\w:.@])([a-z_]\w*)\s*=(?![=~>])/).flatten
      pending.concat((methods.keys - variables).select { |other| code.match?(/(?<![\w:.])#{Regexp.escape(other)}\b/) })
    end
    visited.map { |name| methods[name][:source] }
  end

  def renders?(controller, action)
    sources(controller, action).any? { |text| text.match?(/\b(render|send_file|send_data|redirect_to)\b/) }
  end

  # @return [Hash] `names`: parameter names, `body`: true if the request body is read as a whole,
  #   `format_default`: response format when parameter `format` is not given
  def parameters_read(controller, action)
    texts = sources(controller, action)
    {
      names: texts.flat_map { |text| text.scan(PARAMETER_READ).flatten }.uniq,
      body: texts.any? { |text| text.match?(/request\.(body|raw_post)/) },
      format_default: texts.first[/params\[:format\]\s*\|\|\s*["'](\w+)["']/, 1]
    }
  end
end

if __FILE__ == $PROGRAM_NAME
  abort("Usage: #{$PROGRAM_NAME} <orchestrator_dir> <openapi.yaml>") unless ARGV.size.eql?(2)
  puts ApiCheck.new(*ARGV).markdown
end
