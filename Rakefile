# Build plugin doc for IBM Aspera Orchestrator
# Laurent Martin

require 'rake/clean'
require 'pathname'
require_relative 'lib/aspera_orchestrator_doc_generator'

ENV_VAR_PANDOC = 'DIR_PANDOC'

# Use the build system of aspera-cli
# DIR_PANDOC is <aspera-cli>/build/doc/pandoc
raise "Missing environment variable #{ENV_VAR_PANDOC}" unless ENV[ENV_VAR_PANDOC]

aspera_cli_build_lib = Pathname.new(ENV[ENV_VAR_PANDOC]).parent.parent.parent / 'build' / 'lib'
$LOAD_PATH.unshift(aspera_cli_build_lib)

require 'pandoc'
require 'build_tools'
include BuildTools

raise 'Set env var VERSION' unless ENV.key?('VERSION')

BUILD_VERSION = ENV['VERSION']

TOP = Pathname.new(__dir__)
PATH_DOCS = TOP / 'docs'
PATH_MANUAL_MD = PATH_DOCS / 'Orchestrator_Plugin_Manual.md'
PATH_MANUAL_PDF = PATH_DOCS / 'Orchestrator_Plugin_Manual.pdf'
PATH_LIST_PDF = PATH_DOCS / 'Orchestrator_Plugin_List.pdf'
PATH_BANNER_PDF = PATH_DOCS / 'Orchestrator_Plugin_Banner.pdf'
PATH_BUILD_MAIN = TOP / 'build' / BUILD_VERSION
PATH_BUILD_SRC = (PATH_BUILD_MAIN / 'src').mkpath
PATH_BUILD_OUT = (PATH_BUILD_MAIN / 'out').mkpath
PATH_MANUAL_MD_TMP = PATH_BUILD_OUT / 'Orchestrator_Plugin_Manual.md'
PATH_BUILD_LIB = (PATH_BUILD_SRC / 'lib').mkpath
PATH_RPM_OUT = (PATH_BUILD_MAIN / 'rpmout').mkpath

$LOAD_PATH.unshift(PATH_BUILD_LIB)

# Output file paths
PATH_HTML_DOC = PATH_BUILD_OUT / 'doc.html'
PATH_HTML_SUMMARY = PATH_BUILD_OUT / 'summary.html'
HTML_BANNER_PATH = PATH_BUILD_OUT / 'banner.html'
PATH_PLUGIN_DATA = PATH_BUILD_OUT / 'plugin_data.marshal'

desc 'Build all documentation (HTML + PDF)'
task default: :pdf

desc 'Generate HTML documentation'
task html: PATH_HTML_DOC

desc 'Generate all PDF documentation'
task pdf: %i[pdf_manual pdf_list pdf_banner]

desc 'Generate Plugin Manual PDF'
task pdf_manual: PATH_MANUAL_PDF

desc 'Generate Plugin Manual Markdown'
task md_manual: PATH_MANUAL_MD

desc 'Generate Plugin List PDF'
task pdf_list: PATH_LIST_PDF

desc 'Generate Plugin Banner PDF'
task pdf_banner: PATH_BANNER_PDF

# Generate Plugin Manual Markdown from HTML
file PATH_MANUAL_MD => PATH_HTML_DOC do
  generator = AsperaOrchestratorDocGenerator.new
  generator.generate_markdown_from_html(
    html_path: PATH_HTML_DOC,
    md_path: PATH_MANUAL_MD,
    temp_md_path: PATH_MANUAL_MD_TMP
  )
end

# Generate Plugin Manual PDF from Markdown using pandoc
file PATH_MANUAL_PDF => PATH_MANUAL_MD do
  markdown_to_pdf(
    md: PATH_MANUAL_MD_TMP,
    pdf: PATH_MANUAL_PDF
  )
end

# Generate Plugin List PDF (portrait)
file PATH_LIST_PDF => PATH_HTML_SUMMARY do
  generator = AsperaOrchestratorDocGenerator.new
  generator.html_to_pdf(
    html_file: PATH_HTML_SUMMARY,
    pdf_file: PATH_LIST_PDF
  )
end

# Generate Plugin Banner PDF (landscape)
file PATH_BANNER_PDF => HTML_BANNER_PATH do
  generator = AsperaOrchestratorDocGenerator.new
  generator.html_to_pdf(
    html_file: HTML_BANNER_PATH,
    pdf_file: PATH_BANNER_PDF,
    options: { orientation: 'landscape' }
  )
end

# Load plugin data (step 1-2: parse plugins and metadata)
file PATH_PLUGIN_DATA => PATH_BUILD_MAIN do
  generator = AsperaOrchestratorDocGenerator.new
  plugin_data = generator.load_plugin_data(PATH_BUILD_SRC, PATH_BUILD_OUT)
  File.open(PATH_PLUGIN_DATA, 'wb') { |f| Marshal.dump(plugin_data, f) }
end

# Generate doc.html (step 3)
file PATH_HTML_DOC => PATH_PLUGIN_DATA do
  generator = AsperaOrchestratorDocGenerator.new
  plugin_data = Marshal.load(File.read(PATH_PLUGIN_DATA))
  generator.render_and_write_template(
    PATH_HTML_DOC,
    'doc.html.erb',
    sections: plugin_data.map { |p| p[:meta][:category] }.sort.uniq,
    doctitle: "Aspera Orchestrator v#{BUILD_VERSION} Plugins Manuals",
    plugin_data: plugin_data
  )
end

# Generate summary.html (step 4)
file PATH_HTML_SUMMARY => PATH_PLUGIN_DATA do
  generator = AsperaOrchestratorDocGenerator.new
  plugin_data = Marshal.load(File.read(PATH_PLUGIN_DATA))
  generator.render_and_write_template(
    PATH_HTML_SUMMARY,
    'summary.html.erb',
    sections: plugin_data.map { |p| p[:meta][:category] }.sort.uniq,
    doctitle: "Aspera Orchestrator v#{BUILD_VERSION} Plugin Summary",
    plugin_count: plugin_data.length,
    plugin_data: plugin_data
  )
end

# Generate banner.html (step 5)
file HTML_BANNER_PATH => PATH_PLUGIN_DATA do
  generator = AsperaOrchestratorDocGenerator.new
  plugin_data = Marshal.load(File.read(PATH_PLUGIN_DATA))

  generator.render_and_write_template(
    HTML_BANNER_PATH,
    'banner.html.erb',
    sections: plugin_data.map { |p| p[:meta][:category] }.sort.uniq,
    doctitle: "Aspera Orchestrator v#{BUILD_VERSION} Plugins",
    plugin_count: plugin_data.length,
    plugin_data: plugin_data
  )
end

directory PATH_BUILD_MAIN do
  puts 'do: VERSION=xxx RPM=/path/to/rpm rake extract_rpm  or  rake extract_remote'
  exit 1
end

desc 'Extract RPM package'
task :extract_rpm do
  rpm = ENV['RPM']
  raise 'set RPM env var' if rpm.nil? || rpm.empty?

  version = BUILD_VERSION
  puts "Version: #{version}"
  PATH_BUILD_MAIN.mkpath
  PATH_BUILD_SRC.rmtree
  PATH_BUILD_SRC.mkpath

  # sh %(rpm2cpio #{rpm} | (cd #{PATH_RPM_OUT} && cpio -idv "*/actions/*" "*/lib/action_tools.rb" "*/app/helpers/action_helper.rb"))
  sh %(rpm2cpio #{rpm} | (cd #{PATH_RPM_OUT} && cpio -idv))

  path_orchestrator = PATH_RPM_OUT / 'opt/aspera/orchestrator'

  # Move actions directory
  FileUtils.mv(path_orchestrator / 'actions', PATH_BUILD_SRC)

  # Move used lib files
  PATH_BUILD_LIB.mkpath
  FileUtils.mv(path_orchestrator / 'lib/action_tools.rb', PATH_BUILD_LIB)
  FileUtils.mv(path_orchestrator / 'app/helpers/actions_helper.rb', PATH_BUILD_LIB)

  # FileUtils.rm_rf(PATH_RPM_OUT)
end

# Generate PDF from Markdown documentation
namespace :doc do
  desc 'Generate PDF from plugin development guide'
  task :guide do
    markdown_to_pdf(
      md: PATH_DOCS / 'plugin-development-guide.md',
      pdf: PATH_DOCS / 'plugin-development-guide.pdf'
    )
  end
end

CLEAN.include(PATH_BUILD_OUT)
raise "Dir not found: #{src}" unless PATH_BUILD_SRC.exist?
