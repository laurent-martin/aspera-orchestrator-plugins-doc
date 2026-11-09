# Toolbox extension: install and list portlets (no REST API exists for them).
# Install as <config_dir>/toolbox/portlets.rb on the Orchestrator server.
# A portlet is a folder <config_dir>/portlets/<name>/ with <name>.rb and metadata.yml.
# Orchestrator loads a portlet when it starts: restart it (`orchestrator restart`) after an install, the toolbox cannot do it
# (the restart would stop the step that runs it).
require 'fileutils'
require 'yaml'

PORTLET_NAME = /\A[a-z][a-z0-9_]*\z/

def portlets_dir
  File.join(OrchConfig.get.config_dir, 'portlets')
end

# Highest :version of the :revision_history of a metadata.yml, nil if unreadable
def portlet_version(dir)
  history = YAML.safe_load_file(File.join(dir, 'metadata.yml'), permitted_classes: [Symbol])[:revision_history]
  history.map { |r| r[:version].to_s }.max_by { |v| Gem::Version.new(v) }
rescue StandardError
  nil
end

def portlet_files(dir)
  Dir.children(dir).sort
end

function('list_portlets', ': installed portlets (folders of <config_dir>/portlets) with their version and files') do |_a|
  Dir.glob(File.join(portlets_dir, '*')).select { |d| File.directory?(d) }.sort.map do |d|
    { 'name' => File.basename(d), 'version' => portlet_version(d), 'files' => portlet_files(d), 'mtime' => File.mtime(d).utc.iso8601 }
  end
end

function('install_portlet', 'name src [confirm]: copy the folder src (on the server, with metadata.yml and <name>.rb) to portlets/<name>; ' \
                            'an installed portlet is replaced only with confirm=true, after a copy in <config_dir>/portlets_backup. Restart Orchestrator after.') do |a|
  need(a, 'name', 'src')
  name = a['name'].to_s
  raise ArgumentError, "invalid portlet name: #{name}" unless name.match?(PORTLET_NAME)
  src = File.realpath(a['src'].to_s)
  raise ArgumentError, "src is not a folder: #{src}" unless File.directory?(src)
  raise ArgumentError, 'src must not be in the portlets folder' if src.start_with?("#{portlets_dir}/")
  %W[metadata.yml #{name}.rb].each { |f| raise ArgumentError, "src has no #{f}" unless File.file?(File.join(src, f)) }
  links = Dir.glob(File.join(src, '**', '*'), File::FNM_DOTMATCH).select { |f| File.symlink?(f) }
  raise ArgumentError, "src has symbolic links: #{links.map { |l| File.basename(l) }.join(', ')}" unless links.empty?
  version = portlet_version(src)
  raise ArgumentError, 'src/metadata.yml: no :revision_history with :version' if version.nil?
  target = File.join(portlets_dir, name)
  previous = File.directory?(target) ? portlet_version(target) : nil
  backup = nil
  if File.directory?(target)
    raise ArgumentError, "portlet #{name} #{previous} is installed: confirm=true replaces it" unless a['confirm'].to_s == 'true'
    backup = File.join(OrchConfig.get.config_dir, 'portlets_backup', "#{name}_#{previous || 'unknown'}_#{Time.now.utc.strftime('%Y%m%d%H%M%S')}")
    FileUtils.mkdir_p(File.dirname(backup))
    FileUtils.cp_r(target, backup)
  end
  # Files of the portlet replaced one by one: the folder stays, and files that are not in src are removed
  FileUtils.mkdir_p(target)
  (portlet_files(target) - portlet_files(src)).each { |f| FileUtils.rm_rf(File.join(target, f)) }
  FileUtils.cp_r(File.join(src, '.'), target)
  { 'name' => name, 'version' => version, 'previous_version' => previous, 'backup' => backup, 'files' => portlet_files(target),
    'next' => 'restart Orchestrator: orchestrator restart' }
end
