# Toolbox extension: install and list portlets (no REST API exists for them).
# Install as <config_dir>/toolbox/portlets.rb on the Orchestrator server.
# A portlet is a folder <config_dir>/portlets/<name>/ with <name>.rb and metadata.yml.
# Orchestrator loads a portlet when it starts: restart it (`orchestrator restart`) after an install, the toolbox cannot do it
# (the restart would stop the step that runs it).
require 'base64'
require 'fileutils'
require 'rubygems/package'
require 'stringio'
require 'zlib'
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

PORTLET_FILE = /\A[A-Za-z0-9_][A-Za-z0-9_.-]*\z/

# Files of a .portlet archive (tar.gz of the folder <name>/, as made by `rake package`)
# The archive is its base64 content, or `@file:<path>` of the file on the server, as with ascli
def portlet_archive_files(name, base64)
  files = {}
  data = base64.to_s
  if data.start_with?('@file:')
    path = data.delete_prefix('@file:')
    raise ArgumentError, "archive: not a file on the server: #{path}" unless path.start_with?('/') && File.file?(path)
    data = File.binread(path)
  else
    data = Base64.strict_decode64(data)
  end
  Gem::Package::TarReader.new(Zlib::GzipReader.new(StringIO.new(data))).each do |entry|
    next unless entry.file?
    folder, file = entry.full_name.sub(%r{\A\./}, '').split('/', 2)
    raise ArgumentError, "archive: #{entry.full_name} is not in the folder #{name}/" unless folder == name && file && !file.include?('/')
    files[file] = entry.read.force_encoding('UTF-8')
  end
  files
rescue Zlib::Error, Gem::Package::TarInvalidError, ArgumentError => e
  raise e if e.message.start_with?('archive:')
  raise ArgumentError, "archive: not a base64 tar.gz (#{e.message})"
end

function('install_portlet', 'name archive|files [confirm]: install the portlet name from archive (the .portlet file, a tar.gz of the folder name/: its base64 content, or @file:<path> on the server), ' \
                            'or from files, a Hash file name -> text (small portlets: the arguments are limited to about 100 KB); metadata.yml and <name>.rb required; ' \
                            'an installed portlet is replaced only with confirm=true, after a copy in <config_dir>/portlets_backup. Restart Orchestrator after.') do |a|
  need(a, 'name')
  name = a['name'].to_s
  raise ArgumentError, "invalid portlet name: #{name}" unless name.match?(PORTLET_NAME)
  raise ArgumentError, 'Missing argument: archive or files' unless a['archive'] || a['files']
  files = a['archive'] ? portlet_archive_files(name, a['archive']) : a['files']
  raise ArgumentError, 'files: expecting a Hash of file name -> text' unless files.is_a?(Hash) && files.values.all?(String)
  files = files.transform_keys(&:to_s)
  bad = files.keys.reject { |f| f.match?(PORTLET_FILE) }
  raise ArgumentError, "invalid file names: #{bad.join(', ')}" unless bad.empty?
  %W[metadata.yml #{name}.rb].each { |f| raise ArgumentError, "files has no #{f}" unless files.key?(f) }
  version = begin
    YAML.safe_load(files['metadata.yml'], permitted_classes: [Symbol])[:revision_history].map { |r| r[:version].to_s }.max_by { |v| Gem::Version.new(v) }
  rescue StandardError
    nil
  end
  raise ArgumentError, 'metadata.yml: no :revision_history with :version' if version.nil?
  target = File.join(portlets_dir, name)
  previous = File.directory?(target) ? portlet_version(target) : nil
  backup = nil
  if File.directory?(target)
    raise ArgumentError, "portlet #{name} #{previous} is installed: confirm=true replaces it" unless a['confirm'].to_s == 'true'
    backup = File.join(OrchConfig.get.config_dir, 'portlets_backup', "#{name}_#{previous || 'unknown'}_#{Time.now.utc.strftime('%Y%m%d%H%M%S')}")
    FileUtils.mkdir_p(File.dirname(backup))
    FileUtils.cp_r(target, backup)
  end
  # The folder stays; files that are not given are removed
  FileUtils.mkdir_p(target)
  (portlet_files(target) - files.keys).each { |f| FileUtils.rm_rf(File.join(target, f)) }
  files.each { |f, text| File.write(File.join(target, f), text) }
  { 'name' => name, 'version' => version, 'previous_version' => previous, 'backup' => backup, 'files' => portlet_files(target),
    'next' => 'restart Orchestrator: orchestrator restart' }
end
