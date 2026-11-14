#!/usr/bin/env ruby
# frozen_string_literal: true

# Generates an Orchestrator workflow file (plain format, see docs/orchestrator-development-guide.md, chapter Workflow authoring)
# from a compact spec: a Ruby file that evaluates to a Hash.
#
# Usage: ruby tools/figures/wfgen.rb [--deploy] tools/figures/practices/<workflow>.rb   # writes tools/figures/practices/<workflow>[.<variant>].yml
#   --deploy: also import it (env ASCLI, ORCH_FOLDER_ID, ORCH_SSH: see deploy)
#
# Spec keys:
#   name:   workflow name
#   start:, end:, fail:, error:  [x, y] of the terminal nodes
#   end_from:, fail_from:, error_from:  links into the terminal node (see links)
#   end_or:, fail_or:, error_or:  [n, x, y]: OR operator "n of m" drawn at x, y
#   steps:  list of {id:, name:, type:, at: [x, y], from: links, or: [n, x, y],
#                    attrs: {template attributes}, template: 'global template name',
#                    inputs: {input => mapping}, carry: [[step id, output]], outputs: {output => processing},
#                    xml: 'extra raw XML in the Step element'}
#   params: list of {id:, name:, type:, value:, runtime: bool, optional: bool, at: [x, y], link: node id or list}
#   notes:  list of {text:, at: [x, y]}
# Alignment of links (port centers, from the y of the node): step +52, Start +31, End, Fail, Error +33, OR +38.
#   For steps at y: Start at y + 21, End at y + 19, OR before a step at y + 14, OR before End at End y - 5.
# Links: 'id' (Complete, or true from start), 'id:Failed', 'id:Error', or a list of them;
#   suffix /bezier, /null, /fan for another line style than Manhattan (designer only), e.g. 'id:Error/bezier'
#   (only where the graph looks better, for example when a Manhattan line would cross a step;
#   the failed and error exits of a step have the same style: both Manhattan or both curves).
# Input mapping: [:value, 'v'] | [:param, 'name'] | [:output, 'step id', 'output name'], optional 3rd/4th item: processing code.

require 'cgi'
require 'digest'
require 'erb'
require 'json'

class WorkflowGenerator
  ROUTER = 'draw2d.ManhattanConnectionRouter'
  PARAM_ROUTER = 'draw2d.BezierConnectionRouter'
  ROUTERS = {'manhattan' => ROUTER, 'bezier' => PARAM_ROUTER, 'null' => 'draw2d.NullConnectionRouter', 'fan' => 'draw2d.FanConnectionRouter'}.freeze

  def initialize(spec)
    @spec = spec
    @steps = spec.fetch(:steps)
    @by_id = @steps.to_h { |s| [s[:id], s] }
    # one template per step, or shared global template
    counters = Hash.new(0)
    shared = {}
    @steps.each do |s|
      key = s[:template] ? [s[:type], s[:template]] : nil
      if key && shared[key]
        s[:action_id] = shared[key]
        s[:shared] = true
      else
        counters[s[:type]] += 1
        s[:action_id] = counters[s[:type]]
        shared[key] = s[:action_id] if key
      end
    end
  end

  def x(text) = CGI.escapeHTML(text.to_s).gsub("\n", "&#10;")

  def links(spec)
    Array(spec).map do |l|
      ref, style = l.split('/')
      id, status = ref.split(':')
      status ||= id == 'start' ? 'true' : 'Complete'
      router = id == 'start' && style.nil? ? '' : %( router="#{style ? ROUTERS.fetch(style) : ROUTER}")
      %(<Prerequisite id="#{x(id)}" status="#{status}"#{router}/>)
    end.join
  end

  def synch(orspec)
    return '<Synch_factor>0</Synch_factor>' if orspec.nil?
    n, ox, oy = orspec
    %(<Synch_factor x="#{ox}" y="#{oy}">#{n}</Synch_factor>)
  end

  def map_to(m)
    kind, a, b = m
    case kind
    when :value then %(<Map_to type="value" name="#{x(a)}"/>)
    when :param then %(<Map_to type="parameter" name="#{x(a)}"/>)
    when :output
      s = @by_id.fetch(a)
      %(<Map_to type="output" name="#{x(b)}" step_type="#{s[:type]}" action_id="#{s[:action_id]}" step_name="#{x(s[:name])}"/>)
    else raise "unknown mapping #{kind}"
    end
  end

  def inputs(step)
    (step[:inputs] || {}).map do |name, m|
      n = m[0] == :output ? 3 : 2
      proc_code = m[n]
      pr = proc_code ? "<Processing>#{x(proc_code)}</Processing>" : ''
      %(<Input name="#{x(name)}">#{map_to(m[0, n])}#{pr}</Input>)
    end.join
  end

  def outputs(step)
    o = (step[:outputs] || {}).map { |name, code| %(<Output name="#{x(name)}"><Processing>#{x(code)}</Processing></Output>) }
    c = (step[:carry] || []).map do |sid, out|
      if sid == :param
        %(<Carry_thru type="parameter" name="#{x(out)}"/>)
      else
        s = @by_id.fetch(sid)
        %(<Carry_thru type="output" name="#{x(out)}" step_type="#{s[:type]}" action_id="#{s[:action_id]}" step_name="#{x(s[:name])}"/>)
      end
    end
    (o + c).join
  end

  def param_links(node_id)
    (@spec[:params] || []).select { |p| Array(p[:link]).include?(node_id) }
                          .map { |p| %(<Parameter id="#{x(p[:id])}" router="#{PARAM_ROUTER}"/>) }.join
  end

  def terminal(tag, key)
    ax, ay = @spec.fetch(key)
    if tag == 'Start'
      %(<Start x="#{ax}" y="#{ay}" id="start"><Parameters>#{param_links('start')}</Parameters></Start>)
    else
      %(<#{tag} x="#{ax}" y="#{ay}" id="#{key}">#{synch(@spec[:"#{key}_or"])}<Prerequisites>#{links(@spec[:"#{key}_from"])}</Prerequisites></#{tag}>)
    end
  end

  def step_xml(s)
    sx, sy = s[:at]
    %(<Step x="#{sx}" y="#{sy}" id="#{x(s[:id])}"><Action_id>#{s[:action_id]}</Action_id><Step_name>#{x(s[:name])}</Step_name>) +
      %(<Step_type>#{s[:type]}</Step_type>#{synch(s[:or])}<Prerequisites>#{links(s[:from])}</Prerequisites>) +
      %(<Parameters>#{param_links(s[:id])}</Parameters><Inputs>#{inputs(s)}</Inputs><Outputs>#{outputs(s)}</Outputs>#{s[:xml]}</Step>)
  end

  def params_xml
    (@spec[:params] || []).map do |p|
      px, py = p[:at]
      %(<Parameter x="#{px}" y="#{py}" id="#{x(p[:id])}"><Name>#{x(p[:name])}</Name><Value>#{x(p[:value])}</Value>) +
        %(<Value_type>#{p[:type] || 'string'}</Value_type><Runtime_override>#{p[:runtime] ? 'true' : 'false'}</Runtime_override>) +
        %(<Runtime_optional>#{p[:optional] ? 'true' : 'false'}</Runtime_optional></Parameter>)
    end.join
  end

  # Note ids must be unique on the server: Orchestrator 4.1.6 finds a note by its id in all workflows at publish
  # (Whiteboard: Note.find_by(note_id:)), so a common id like note1 updates the note of another workflow.
  # The designer stores the text URL-encoded.
  def notes_xml
    (@spec[:notes] || []).each_with_index.map do |n, i|
      nx, ny = n[:at]
      id = Digest::MD5.hexdigest("#{@spec[:name]}/note#{i + 1}").sub(/\A(.{8})(.{4})(.{4})(.{4})(.{12})\z/, '\\1-\\2-\\3-\\4-\\5')
      %(<Note id="#{id}" note_id="#{id}" x="#{nx}" y="#{ny}" collapsed="false"><Text>#{x(ERB::Util.url_encode(n[:text]))}</Text></Note>)
    end.join
  end

  def graph
    lines = ['<?xml version="1.0" encoding="UTF-8"?>', '<Workflow id="0">',
             terminal('Start', :start), terminal('Error', :error), terminal('End', :end), terminal('Fail', :fail), '<Steps>']
    lines += @steps.map { |s| step_xml(s) }
    lines += ['</Steps>', "<Parameters>#{params_xml}</Parameters><Notes>#{notes_xml}</Notes>", '</Workflow>']
    lines
  end

  # YAML scalar for the line-based converter: double-quoted (JSON escapes are valid YAML)
  def scalar(v)
    case v
    when true then '1'
    when false then '0'
    when Integer then v.to_s
    else v.to_s.to_json
    end
  end

  def to_yaml
    out = ['---', '- !ruby/object:Workflow', '  attributes:', "    name: #{scalar(@spec.fetch(:name))}", '    run_as: SYSTEM']
    out << "    description: #{scalar(@spec[:description])}" if @spec[:description]
    out += ['- !ruby/object:Whiteboard', '  attributes:', '    error_free: true', '    xml_export: |']
    out += graph.map { |l| "      #{l}" }
    first = true
    @steps.reject { |s| s[:shared] }.each do |s|
      key = "#{s[:type]}__#{s[:action_id]}"
      out << (first ? "- #{key}: !ruby/object:#{s[:type]}" : "  #{key}: !ruby/object:#{s[:type]}")
      first = false
      out << '    attributes:'
      out << "      name: #{scalar(s[:template] || "W0__#{s[:name]}")}"
      (s[:attrs] || {}).each do |k, v|
        if v.is_a?(String) && v.include?("\n")
          out << "      #{k}: |"
          out += v.lines.map { |l| "        #{l.chomp}" }
        else
          out << "      #{k}: #{scalar(v)}"
        end
      end
    end
    out += ['- {}', '- {}', '- {}']
    out.join("\n") + "\n"
  end
end

# Id of a workflow of the server, by name (for SubWorkflow and WorkflowLauncher): specs do not hold ids
def wf_id(name)
  @wf_ids ||= JSON.parse(`#{ENV.fetch('ASCLI', 'ascli')} orchestrator workflows list --format=json --fields=id,name`).to_h { |w| [w['name'], w['id']] }
  @wf_ids.fetch(name) { raise "workflow not found on server: #{name}" }
end

def ascli(*args)
  cmd = [ENV.fetch('ASCLI', 'ascli'), 'orchestrator', *args]
  out = IO.popen(cmd, &:read)
  raise "failed: #{cmd.join(' ')}\n#{out}" unless $?.success?
  out
end

# Imports the workflow file in folder ORCH_FOLDER_ID, or, if a workflow of that name exists,
# adds it as a revision (the file is copied to the server with ssh ORCH_SSH), then publishes,
# and gives back to the step configurations their name without revision suffix (rails runner over ssh).
# Global templates that exist are mapped, not changed: change them in the web UI.
# ("Override the existing Global Template" creates a copy named <name>_1 in 4.1.6.)
def deploy(file, spec)
  name = spec.fetch(:name)
  existing = JSON.parse(ascli('workflows', 'list', '--format=json', '--fields=id,name')).find { |w| w['name'] == name }
  unless existing
    puts ascli('workflows', 'import', file, "@json:#{{folder_id: ENV.fetch('ORCH_FOLDER_ID').to_i, publish: true}.to_json}", '--fields=id,name')
    return
  end
  remote = "/opt/aspera/orchestrator/var/run/orchestrator/workflows/import/#{File.basename(file)}"
  ssh = ENV.fetch('ORCH_SSH')
  system('scp', '-q', file, "#{ssh}:#{remote}", exception: true)
  system('ssh', ssh, "chown aspweb: '#{remote}'", exception: true)
  globals = spec[:steps].filter_map { |s| s[:template] }.uniq.to_h { |t| [t, 'Map to the existing Global Template'] }
  payload = {filename: remote, add_as_revision: existing['id'], auto_enable_missing_plugins: true}
  payload[:action_template_constraints] = globals unless globals.empty?
  ascli('workflows', 'import_with_constraints', "@json:#{payload.to_json}", '--format=json')
  puts "#{existing['id']}: #{name}: #{ascli('workflows', 'publish', existing['id'].to_s).strip}"
  restore_template_names(ssh, existing['id'])
end

# Rails runner script: the embedded templates of the last revision of workflow ARGV[0] get back the name
# W<id>__<step name> (a revision gets new templates named with a suffix _<n>, shown in the designer);
# the templates of previous revisions that had that name are renamed "W<id>__<step name> (rev <template id>)".
RESTORE_NAMES = <<~'RUBY'
  require 'cgi'
require 'digest'
require 'erb'
  w = Workflow.find(ARGV[0].to_i)
  xml = Whiteboard.where(workflow_id: w.id).order(:id).last.xml_export
  xml.scan(%r{<Step\b.*?</Step>}m).each do |step|
    klass = step[%r{<Step_type>([^<]+)<}, 1].constantize
    template = klass.find(step[%r{<Action_id>(\d+)<}, 1])
    base = "W#{w.id}__#{CGI.unescapeHTML(step[%r{<Step_name>([^<]+)<}, 1])}"
    next if !template.name.start_with?("W#{w.id}__") || template.name == base
    klass.where(name: base).where.not(id: template.id).each { |old| old.update_column(:name, "#{base} (rev #{old.id})") }
    template.update_column(:name, base)
    puts "#{template.id}: #{base}"
  end
RUBY

def restore_template_names(ssh, workflow_id)
  script = '/tmp/wfgen_restore_names.rb'
  IO.popen(['ssh', ssh, "cat > #{script} && chmod 644 #{script}"], 'w') { |io| io.write(RESTORE_NAMES) }
  rails = "cd /opt/aspera/orchestrator && sudo -u aspweb env PATH=#{ENV.fetch('ORCH_RUBY_PATH', '/opt/rbenv/versions/3.4.11/bin')}:/usr/bin:/bin " \
          "RAILS_ENV=production bin/rails runner #{script} #{workflow_id} 2>/dev/null | sed '/ INFO -- /d'"
  system('ssh', ssh, rails, exception: true)
end

# Workflows of a spec: [file, spec] for the spec itself, or for each of its variants (key variants:
# a Hash of name => keys that replace those of the spec): file <spec>.<variant>.yml.
# Variants are deployed in order as successive revisions of the same workflow: the last one is published.
def workflow_files(src, spec)
  base = src.sub(/\.rb\z/, '')
  variants = spec.delete(:variants)
  return [["#{base}.yml", spec]] if variants.nil?
  variants.map { |key, changes| ["#{base}.#{key}.yml", Marshal.load(Marshal.dump(spec.merge(changes)))] }
end

if $PROGRAM_NAME == __FILE__
  do_deploy = ARGV.delete('--deploy')
  src = ARGV.fetch(0)
  spec = eval(File.read(src), binding, src) # rubocop:disable Security/Eval
  workflow_files(src, spec).each do |dst, wf|
    File.write(dst, WorkflowGenerator.new(wf).to_yaml)
    puts dst
    deploy(dst, wf) if do_deploy
  end
end
