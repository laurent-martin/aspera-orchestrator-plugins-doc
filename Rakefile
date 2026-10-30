# Build plugin doc for IBM Aspera Orchestrator
# Laurent Martin

require 'rake/clean'
require 'pathname'

ENV_VAR_ASPERA_CLI = 'ASPERA_CLI_HOME'
ENV_VAR_DOC_TOOL   = 'GFM2PDF_HOME'

# aspera-cli library (aspera/log, ...)
raise "Missing environment variable #{ENV_VAR_ASPERA_CLI}" unless ENV[ENV_VAR_ASPERA_CLI]

$LOAD_PATH.unshift(Pathname.new(ENV[ENV_VAR_ASPERA_CLI]) / 'lib')

require_relative 'lib/aspera_orchestrator_doc_generator'

# gfm2pdf-toolchain library (pandoc/PDF generation)
raise "Missing environment variable #{ENV_VAR_DOC_TOOL}" unless ENV[ENV_VAR_DOC_TOOL]

$LOAD_PATH.unshift(Pathname.new(ENV[ENV_VAR_DOC_TOOL]) / 'lib')

require 'pandoc'
include Gfm2Pdf

# Toolchain with themes and options of documents in a comment `<!-- gfm2pdf`
Gfm2Pdf.check_version('>= 1.0.0.pre, < 2')
# IBM look of the PDF documents: theme of aspera-cli, unless env var GFM2PDF_THEME is set
PDF_THEME = ENV.fetch('GFM2PDF_THEME') { (Pathname.new(ENV[ENV_VAR_ASPERA_CLI]) / 'build' / 'doc' / 'pdf_theme').to_s }

raise 'Set env var VERSION' unless ENV.key?('VERSION')

BUILD_VERSION = ENV['VERSION']

TOP = Pathname.new(__dir__)
PATH_DOCS = TOP / 'docs'
PATH_MANUAL_MD = PATH_DOCS / 'Orchestrator_Plugin_Manual.md'
PATH_MANUAL_PDF = PATH_DOCS / 'Orchestrator_Plugin_Manual.pdf'
PATH_LIST_PDF = PATH_DOCS / 'Orchestrator_Plugin_List.pdf'
PATH_BANNER_PDF = PATH_DOCS / 'Orchestrator_Plugin_Banner.pdf'
PATH_BUILD_MAIN = TOP / 'build' / BUILD_VERSION
# Created by task extract_rpm
PATH_BUILD_SRC = PATH_BUILD_MAIN / 'src'
PATH_BUILD_ACTIONS = PATH_BUILD_SRC / 'actions'
PATH_BUILD_OUT = (PATH_BUILD_MAIN / 'out').mkpath
PATH_MANUAL_MD_TMP = PATH_BUILD_OUT / 'Orchestrator_Plugin_Manual.md'
PATH_BUILD_LIB = PATH_BUILD_SRC / 'lib'
PATH_RPM_OUT = (PATH_BUILD_MAIN / 'rpmout').mkpath

$LOAD_PATH.unshift(PATH_BUILD_LIB)

# Output file paths
PATH_HTML_DOC = PATH_BUILD_OUT / 'doc.html'
PATH_HTML_SUMMARY = PATH_BUILD_OUT / 'summary.html'
HTML_BANNER_PATH = PATH_BUILD_OUT / 'banner.html'
PATH_PLUGIN_DATA = PATH_BUILD_OUT / 'plugin_data.marshal'
PATH_PROBE_JSON = PATH_BUILD_OUT / 'plugin_probe.json'
PATH_PLUGINS_YML = PATH_DOCS / 'plugins.yml'

# Orchestrator files needed to evaluate plugin code, moved to PATH_BUILD_LIB (see PluginProbe::CORE_FILES)
PROBE_CORE_FILES = %w[
  lib/action.rb lib/multi_type.rb lib/payload.rb
  app/models/abstract.rb app/models/module_trigger_tools.rb app/models/module_ssh_tools.rb app/models/module_soap_tools.rb
].freeze

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
    pdf: PATH_MANUAL_PDF,
    theme: PDF_THEME
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
file PATH_PLUGIN_DATA => PATH_BUILD_ACTIONS do
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

file PATH_BUILD_ACTIONS do
  raise "Not found: #{PATH_BUILD_ACTIONS}, do first: RPM=/path/to/rpm rake extract_rpm"
end

# Evaluate plugin code: in its own process, as it loads plugin code and changes core classes
file PATH_PROBE_JSON => [PATH_BUILD_ACTIONS, TOP / 'lib/plugin_probe.rb', TOP / 'lib/action_template_reference.rb'] do
  require 'open3'
  json, status = Open3.capture2(RbConfig.ruby, (TOP / 'lib/plugin_probe.rb').to_s, PATH_BUILD_ACTIONS.to_s, PATH_BUILD_LIB.to_s)
  raise "Plugin probe failed: #{status}" unless status.success?
  File.write(PATH_PROBE_JSON, json)
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
  # Clean rpmout fully so no stale symlinks block extraction
  PATH_RPM_OUT.rmtree
  PATH_RPM_OUT.mkpath

  # bsdtar reads RPM directly; rpmout must be empty so symlinks are created before their targets are needed
  sh %(bsdtar -C #{PATH_RPM_OUT} -xf #{rpm})

  # orchestrator may be a symlink (e.g. orchestrator -> orchestrator-4.x.y) — resolve to real path
  path_orchestrator = (PATH_RPM_OUT / 'opt/aspera/orchestrator').realpath

  # Move actions directory
  FileUtils.mv(path_orchestrator / 'actions', PATH_BUILD_SRC)

  # Move used lib files
  PATH_BUILD_LIB.mkpath
  FileUtils.mv(path_orchestrator / 'lib/action_tools.rb', PATH_BUILD_LIB)
  FileUtils.mv(path_orchestrator / 'app/helpers/actions_helper.rb', PATH_BUILD_LIB)
  PROBE_CORE_FILES.each { |file| FileUtils.mv(path_orchestrator / file, PATH_BUILD_LIB) }

  # FileUtils.rm_rf(PATH_RPM_OUT)
end

# Diagrams: one image per tab of the draw.io file, named after the tab, with draw.io desktop (see gfm2pdf-toolchain)
PATH_DRAWIO = PATH_DOCS / 'images' / 'diagrams.drawio'
DRAWIO_TOOL = [RbConfig.ruby, (Pathname.new(ENV[ENV_VAR_DOC_TOOL]) / 'lib' / 'drawio.rb').to_s].freeze
# SVG for GitHub, and PDF used instead of the SVG in PDF documents
DRAWIO_SVGS = IO.popen([*DRAWIO_TOOL, 'list', PATH_DRAWIO.to_s, 'svg'], &:read).split.freeze
DRAWIO_IMAGES = DRAWIO_SVGS.flat_map { |svg| [svg, svg.sub(/\.svg\z/, '.pdf')] }.freeze

# An image is exported again only when older than the draw.io file
DRAWIO_IMAGES.each do |image|
  file image => PATH_DRAWIO do
    sh(*DRAWIO_TOOL, 'export', PATH_DRAWIO.to_s, image, '--scale', '2')
  end
end

# Generate PDF from Markdown documentation
namespace :doc do
  desc 'Export the diagrams of docs/images/diagrams.drawio (SVG and PDF)'
  task diagrams: DRAWIO_IMAGES

  desc 'Generate PDF from plugin development guide'
  task guide: :diagrams do
    markdown_to_pdf(
      md: PATH_DOCS / 'plugin-development-guide.md',
      pdf: PATH_DOCS / 'plugin-development-guide.pdf',
      theme: PDF_THEME
    )
  end

  desc 'Generate PDF from workflow authoring guide'
  task :authoring do
    markdown_to_pdf(
      md: PATH_DOCS / 'workflow-authoring-guide.md',
      pdf: PATH_DOCS / 'workflow-authoring-guide.pdf',
      theme: PDF_THEME
    )
  end

  desc 'Generate PDF from portlet development guide'
  task :portlets do
    markdown_to_pdf(
      md: PATH_DOCS / 'portlet-development-guide.md',
      pdf: PATH_DOCS / 'portlet-development-guide.pdf',
      theme: PDF_THEME
    )
  end

  PATH_OVERLAY = TOP / 'lib' / 'plugins_overlay.yml'

  desc 'Generate action template reference (Markdown) from actions folder (env var ACTIONS_DIR overrides the RPM extract)'
  task template_reference: PATH_PROBE_JSON do
    require 'yaml'
    require_relative 'lib/action_template_reference'
    actions_dir = ENV['ACTIONS_DIR'] || PATH_BUILD_ACTIONS.to_s
    probe = JSON.parse(File.read(PATH_PROBE_JSON))
    overlay = YAML.safe_load_file(PATH_OVERLAY)
    File.write(PATH_DOCS / 'action-template-reference.md', ActionTemplateReference.new(actions_dir, probe).markdown(BUILD_VERSION, overlay))
  end

  desc 'Compare the REST API of Orchestrator (RPM extract) with its OpenAPI description (env var OPENAPI, default: clone of aspera-api-examples next to this one)'
  task :api_check do
    require_relative 'lib/api_check'
    openapi = ENV['OPENAPI'] || (TOP.parent / 'aspera-api-examples' / 'openapi' / 'IBM Aspera Orchestrator API-v1-enhanced.yaml').to_s
    puts ApiCheck.new((PATH_RPM_OUT / 'opt' / 'aspera' / 'orchestrator').to_s, openapi).markdown
  end

  desc 'Generate plugin specifications (YAML): template attributes, inputs and outputs, found by evaluating plugin code'
  task plugin_specs: PATH_PROBE_JSON do
    require 'yaml'
    require_relative 'lib/action_template_reference'
    probe = JSON.parse(File.read(PATH_PROBE_JSON))
    overlay = YAML.safe_load_file(PATH_OVERLAY)
    File.write(PATH_PLUGINS_YML, ActionTemplateReference.new(PATH_BUILD_ACTIONS.to_s, probe).yaml(BUILD_VERSION, overlay))
  end

  desc 'Apply hand-authored enrichments (lib/plugins_overlay.yml) onto the existing docs/plugins.yml without regenerating from the probe'
  task :apply_overlay do
    require 'yaml'
    require 'json'
    require_relative 'lib/action_template_reference'
    overlay = YAML.safe_load_file(PATH_OVERLAY)
    data = YAML.safe_load_file(PATH_PLUGINS_YML)
    ref = ActionTemplateReference.new(PATH_BUILD_ACTIONS.to_s)
    ref.apply_overlay(data, overlay)
    # Preserve the header comment block then re-serialise in flow style
    header = File.read(PATH_PLUGINS_YML).lines.take_while { |l| l.start_with?('#', "\n") }.join
    File.write(PATH_PLUGINS_YML, header + ref.serialize_plugins(data))
    puts "Overlay applied to #{PATH_PLUGINS_YML}"
  end
end

CLEAN.include(PATH_BUILD_OUT)
