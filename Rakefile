# Build plugin doc for IBM Aspera Orchestrator
# Laurent Martin

require_relative 'lib/aspera_orchestrator_doc_generator'
require_relative 'lib/pdf_generator'

# Load pandoc helper from aspera-cli if DIR_PANDOC is set
if ENV['DIR_PANDOC']
  # Convert DIR_PANDOC to absolute path
  ENV['DIR_PANDOC'] = File.expand_path(ENV['DIR_PANDOC'], __dir__)

  # Load required dependencies from aspera-cli
  aspera_cli_build = File.expand_path('../aspera-cli/build', __dir__)
  $LOAD_PATH.unshift(File.join(aspera_cli_build, 'lib'))

  require 'pathname'
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
  require File.join(aspera_cli_build, 'lib', 'pandoc.rb')
end

# working folder
def build_main_dir
  "build/#{ENV['VERSION']}/"
end

def build_src_dir
  "#{build_main_dir}src/"
end

def build_out_dir
  "#{build_main_dir}out/"
end

desc 'Build all documentation (HTML + PDF)'
task default: [:pdf]

desc 'Generate HTML documentation'
task html: "#{build_out_dir}doc.html"

desc 'Generate PDF documentation'
task pdf: "#{build_out_dir}doc.created"

# Generate PDFs from HTML files
file "#{build_out_dir}doc.created" => ["#{build_out_dir}doc.html"] do
  version = ENV['VERSION']
  PdfGenerator.generate_all(out_dir: build_out_dir, version: version)
  touch "#{build_out_dir}doc.created"
end

# build doc (create latest link)
file "#{build_out_dir}doc.html" => [build_main_dir] do
  version = ENV['VERSION']
  AsperaOrchestratorDocGenerator.new.build_doc(version, build_src_dir, build_out_dir)
end

directory build_main_dir do
  puts 'do: VERSION=xxx RPM=/path/to/rpm rake extract_rpm  or  rake extract_remote'
  exit 1
end

desc 'Extract RPM package'
task :extract_rpm do
  rpm = ENV['RPM']
  version = ENV['VERSION']

  raise 'set RPM env var' if rpm.nil? || rpm.empty?
  raise 'set VERSION env var' if version.nil? || version.empty?

  puts "Version: #{version}"

  mkdir_p build_main_dir
  mkdir_p build_out_dir
  mkdir_p "#{build_src_dir}lib"
  mkdir_p "#{build_main_dir}rpmout"

  sh "rpm2cpio #{rpm} | (cd #{build_main_dir}rpmout && cpio -idv \"*\" \"*/actions/*\" \"*/lib/action_tools.rb\")"
  sh "mv #{build_main_dir}rpmout/opt/aspera/orchestrator*/actions #{build_src_dir}"
  sh "mv #{build_main_dir}rpmout/opt/aspera/orchestrator*/lib/action_tools.rb #{build_src_dir}lib"
  # sh "rm -fr #{build_main_dir}rpmout"
end

desc 'Extract from remote server'
task :extract_remote do
  rpm = ENV['RPM']
  version = ENV['VERSION']
  ascp = ENV['ASCP']
  keys = ENV['KEYS']
  remote_host = ENV['REMOTE_HOST']
  remote_user = ENV['REMOTE_USER']

  raise 'set RPM env var' if rpm.nil? || rpm.empty?
  raise 'set VERSION env var' if version.nil? || version.empty?

  puts "Version: #{version}"

  mkdir_p build_main_dir
  mkdir_p build_out_dir
  mkdir_p "#{build_src_dir}lib"

  sh "#{ascp} -l 100m #{keys} -d --mode=recv --host=#{remote_host} --user=#{remote_user} --src-base=/opt/aspera/orchestrator/actions /opt/aspera/orchestrator/actions #{build_src_dir}actions"
  sh "#{ascp} -l 100m #{keys} -d --mode=recv --host=#{remote_host} --user=#{remote_user} /opt/aspera/orchestrator/lib/action_tools.rb #{build_src_dir}lib"
end

desc 'Clean generated files'
task :clean do
  rm_f Dir.glob("#{build_out_dir}*.{html,pdf,created}")
  rm_f 'docs/plugin-development-guide.pdf'
end

# Generate PDF from Markdown documentation
namespace :doc do
  desc 'Generate PDF from plugin development guide'
  task :guide do
    if ENV['DIR_PANDOC']
      markdown_to_pdf(
        md: 'docs/plugin-development-guide.md',
        pdf: 'docs/plugin-development-guide.pdf'
      )
    else
      puts 'Warning: DIR_PANDOC not set. Install aspera-cli or set DIR_PANDOC environment variable.'
      puts 'Example: DIR_PANDOC=../aspera-cli/build/doc/pandoc rake doc:guide'
    end
  end
end
