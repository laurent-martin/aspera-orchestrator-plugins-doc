# Build plugin doc for IBM Aspera Orchestrator
# Laurent Martin

require 'pathname'
require_relative 'lib/aspera_orchestrator_doc_generator'
require_relative 'lib/pdf_generator'

# Load pandoc helper from aspera-cli if DIR_PANDOC is set
if ENV['DIR_PANDOC']
  # Convert DIR_PANDOC to absolute path
  ENV['DIR_PANDOC'] = (Pathname.new(__dir__) / ENV['DIR_PANDOC']).expand_path.to_s

  # Load required dependencies from aspera-cli
  aspera_cli_build = (Pathname.new(__dir__).parent / 'aspera-cli' / 'build').expand_path
  $LOAD_PATH.unshift((aspera_cli_build / 'lib').to_s)

  require 'fileutils'
  require 'logger'

  # Define minimal stubs for missing dependencies
  module Paths
    TMP = Pathname.new('tmp')
    TMP.mkpath
  end

  module BuildTools
    def run(*cmd, **options)
      system(*cmd) || raise("Command failed: #{cmd.join(' ')}")
    end

    def log
      @log ||= Logger.new(STDOUT)
    end
  end

  # Now load pandoc.rb
  require (aspera_cli_build / 'lib' / 'pandoc.rb').to_s
end

def build_version
  return $build_version if $build_version
  raise 'Set env var VERSION' unless ENV.key?('VERSION')

  $build_version = ENV['VERSION']
  src = build_src_dir
  raise "Dir not found: #{src}" unless src.exist?

  $build_version
end

# working folder
def build_main_dir
  Pathname.new('build') / build_version
end

def build_src_dir
  (build_main_dir / 'src').mkpath
end

def build_out_dir
  build_main_dir / 'out'
end

desc 'Build all documentation (HTML + PDF)'
task default: [:pdf]

desc 'Generate HTML documentation'
task html: build_out_dir / 'doc.html'

desc 'Generate PDF documentation'
task pdf: build_out_dir / 'doc.created'

# Generate PDFs from HTML files
file (build_out_dir / 'doc.created').to_s => [(build_out_dir / 'doc.html').to_s] do
  build_out_dir.mkpath
  PdfGenerator.generate_all(out_dir: build_out_dir, version: build_version)
  FileUtils.touch((build_out_dir / 'doc.created').to_s)
end

# build doc (create latest link)
file (build_out_dir / 'doc.html').to_s => [build_main_dir.to_s] do
  build_out_dir.mkpath
  AsperaOrchestratorDocGenerator.new.build_doc(build_version, build_src_dir, build_out_dir)
end

directory build_main_dir.to_s do
  puts 'do: VERSION=xxx RPM=/path/to/rpm rake extract_rpm  or  rake extract_remote'
  exit 1
end

desc 'Extract RPM package'
task :extract_rpm do
  rpm = ENV['RPM']
  raise 'set RPM env var' if rpm.nil? || rpm.empty?

  version = build_version
  puts "Version: #{version}"
  build_main_dir.mkpath
  build_out_dir.mkpath
  (build_src_dir / 'lib').mkpath
  rpmout_dir = build_main_dir / 'rpmout'
  rpmout_dir.mkpath

  sh "rpm2cpio #{rpm} | (cd #{rpmout_dir} && cpio -idv \"*\" \"*/actions/*\" \"*/lib/action_tools.rb\")"

  # Move actions directory
  actions_src = Dir.glob("#{rpmout_dir}/opt/aspera/orchestrator*/actions").first
  FileUtils.mv(actions_src, build_src_dir.to_s) if actions_src

  # Move action_tools.rb file
  action_tools_src = Dir.glob("#{rpmout_dir}/opt/aspera/orchestrator*/lib/action_tools.rb").first
  FileUtils.mv(action_tools_src, (build_src_dir / 'lib').to_s) if action_tools_src

  # FileUtils.rm_rf(rpmout_dir.to_s)
end

desc 'Extract from remote server'
task :extract_remote do
  rpm = ENV['RPM']
  version = build_version
  ascp = ENV['ASCP']
  keys = ENV['KEYS']
  remote_host = ENV['REMOTE_HOST']
  remote_user = ENV['REMOTE_USER']

  raise 'set RPM env var' if rpm.nil? || rpm.empty?
  raise 'set VERSION env var' if version.nil? || version.empty?

  puts "Version: #{version}"

  build_main_dir.mkpath
  build_out_dir.mkpath
  (build_src_dir / 'lib').mkpath

  sh "#{ascp} -l 100m #{keys} -d --mode=recv --host=#{remote_host} --user=#{remote_user} --src-base=/opt/aspera/orchestrator/actions /opt/aspera/orchestrator/actions #{build_src_dir / 'actions'}"
  sh "#{ascp} -l 100m #{keys} -d --mode=recv --host=#{remote_host} --user=#{remote_user} /opt/aspera/orchestrator/lib/action_tools.rb #{build_src_dir / 'lib'}"
end

desc 'Clean generated files'
task :clean do
  FileUtils.rm_rf(build_out_dir.to_s)
end

# Generate PDF from Markdown documentation
namespace :doc do
  desc 'Generate PDF from plugin development guide'
  task :guide do
    if ENV['DIR_PANDOC']
      markdown_to_pdf(
        md: (Pathname.new('docs') / 'plugin-development-guide.md').to_s,
        pdf: (Pathname.new('docs') / 'plugin-development-guide.pdf').to_s
      )
    else
      puts 'Warning: DIR_PANDOC not set. Install aspera-cli or set DIR_PANDOC environment variable.'
      puts 'Example: DIR_PANDOC=../aspera-cli/build/doc/pandoc rake doc:guide'
    end
  end
end
