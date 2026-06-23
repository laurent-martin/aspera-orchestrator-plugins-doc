# Build plugin doc for IBM Aspera Orchestrator
# Laurent Martin

require 'rake/clean'
require 'pathname'
require_relative 'lib/aspera_orchestrator_doc_generator'

# Use the build system of aspera-cli
# DIR_PANDOC is <aspera-cli>/build/doc/pandoc
raise 'Missing environment variable DIR_PANDOC' unless ENV['DIR_PANDOC']

aspera_cli_gem_path = Pathname.new(ENV['DIR_PANDOC']).parent.parent / 'lib'
$LOAD_PATH.unshift(aspera_cli_gem_path)

require 'pandoc'
require 'build_tools'
include BuildTools

raise 'Set env var VERSION' unless ENV.key?('VERSION')

TOP = Pathname.new(__dir__)
BUILD_VERSION = ENV['VERSION']
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
HTML_DOC_PATH = PATH_BUILD_OUT / 'doc.html'
HTML_SUMMARY_PATH = PATH_BUILD_OUT / 'summary.html'
HTML_BANNER_PATH = PATH_BUILD_OUT / 'banner.html'
PLUGIN_DATA_PATH = PATH_BUILD_OUT / 'plugin_data.marshal'

# Convert HTML file to PDF using wkhtmltopdf
# @param html_file [String, Pathname] Path to input HTML file
# @param pdf_file [String, Pathname] Path to output PDF file
# @param options [Hash] Additional wkhtmltopdf options
# @option options [String] :orientation Page orientation ('Portrait' or 'Landscape')
# @option options [Boolean] :enable_local_file_access Enable local file access (default: true)
def html_to_pdf(html_file:, pdf_file:, options: {})
  html_file = Pathname.new(html_file).expand_path
  pdf_file = Pathname.new(pdf_file).expand_path

  raise "HTML file not found: #{html_file}" unless html_file.exist?

  # Ensure output directory exists
  pdf_file.dirname.mkpath

  # Build wkhtmltopdf command
  cmd = ['wkhtmltopdf']

  # Add enable-local-file-access by default
  cmd << '--enable-local-file-access' if options.fetch(:enable_local_file_access, true)

  # Add orientation if specified
  cmd << '-O' << options[:orientation] if options[:orientation]

  # Add any additional options
  options.each do |key, value|
    next if %i[enable_local_file_access orientation].include?(key)

    cmd << "--#{key.to_s.tr('_', '-')}"
    cmd << value.to_s unless value == true
  end

  # Add input and output files
  cmd << "file://#{html_file}"
  cmd << pdf_file.to_s

  puts "Generating PDF: #{pdf_file}"
  system(*cmd) || raise("Failed to generate PDF: #{pdf_file}")
end

desc 'Build all documentation (HTML + PDF)'
task default: :pdf

desc 'Generate HTML documentation'
task html: HTML_DOC_PATH

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
file PATH_MANUAL_MD => HTML_DOC_PATH do
  run(
    'pandoc',
    '--from=html',
    '--to=gfm',
    '--wrap=none',
    '--shift-heading-level-by=1',
    "--output=#{PATH_MANUAL_MD_TMP}",
    HTML_DOC_PATH
  )
  # Clean up the generated Markdown
  content = File.read(PATH_MANUAL_MD_TMP)
  # Remove lines starting with ::: (Pandoc div markers)
  content.gsub!(/^:::.*$\n?/, '')
  # Remove HTML div tags
  content.gsub!(%r{</?div[^>]*>\n?}, '')
  # Convert HTML img tags to Markdown syntax: <img src="path" class="..." alt="text" /> -> ![text](path)
  content.gsub!(%r{<img\s+src="([^"]+)"[^>]*alt="([^"]*)"[^>]*/?>}, '![\\2](\\1)')
  content.gsub!("\n|----|----|\n",
                "\n|-------|---------------------------------------------------|\n")

  # Fix heading levels: document title should be H1, categories H2, plugin names H3
  lines = content.split("\n")
  if lines.first && !lines.first.start_with?('#')
    lines[0] = "# #{lines[0]}" # Make document title H1
  end
  content = lines.join("\n")
  File.write(PATH_MANUAL_MD_TMP, content)
  FileUtils.cp(PATH_MANUAL_MD_TMP, PATH_MANUAL_MD)
end

# Generate Plugin Manual PDF from Markdown using pandoc
file PATH_MANUAL_PDF => PATH_MANUAL_MD do
  markdown_to_pdf(
    md: PATH_MANUAL_MD_TMP,
    pdf: PATH_MANUAL_PDF
  )
end

# Generate Plugin List PDF (portrait)
file PATH_LIST_PDF => HTML_SUMMARY_PATH do
  html_to_pdf(
    html_file: HTML_SUMMARY_PATH,
    pdf_file: PATH_LIST_PDF
  )
end

# Generate Plugin Banner PDF (landscape)
file PATH_BANNER_PDF => HTML_BANNER_PATH do
  html_to_pdf(
    html_file: HTML_BANNER_PATH,
    pdf_file: PATH_BANNER_PDF,
    options: { orientation: 'landscape' }
  )
end

# Load plugin data (step 1-2: parse plugins and metadata)
file PLUGIN_DATA_PATH => PATH_BUILD_MAIN do
  generator = AsperaOrchestratorDocGenerator.new
  plugin_data = generator.load_plugin_data(PATH_BUILD_SRC, PATH_BUILD_OUT)
  File.open(PLUGIN_DATA_PATH, 'wb') { |f| Marshal.dump(plugin_data, f) }
end

# Generate doc.html (step 3)
file HTML_DOC_PATH => PLUGIN_DATA_PATH do
  generator = AsperaOrchestratorDocGenerator.new
  plugin_data = Marshal.load(File.read(PLUGIN_DATA_PATH))
  generator.render_and_write_template(
    HTML_DOC_PATH,
    'doc.html.erb',
    sections: plugin_data.map { |p| p[:meta][:category] }.sort.uniq,
    doctitle: "Aspera Orchestrator v#{BUILD_VERSION} Plugins Manuals",
    plugin_data: plugin_data
  )
end

# Generate summary.html (step 4)
file HTML_SUMMARY_PATH => PLUGIN_DATA_PATH do
  generator = AsperaOrchestratorDocGenerator.new
  plugin_data = Marshal.load(File.read(PLUGIN_DATA_PATH))
  generator.render_and_write_template(
    HTML_SUMMARY_PATH,
    'summary.html.erb',
    sections: plugin_data.map { |p| p[:meta][:category] }.sort.uniq,
    doctitle: "Aspera Orchestrator v#{BUILD_VERSION} Plugin Summary",
    plugin_count: plugin_data.length,
    plugin_data: plugin_data
  )
end

# Generate banner.html (step 5)
file HTML_BANNER_PATH => PLUGIN_DATA_PATH do
  generator = AsperaOrchestratorDocGenerator.new
  plugin_data = Marshal.load(File.read(PLUGIN_DATA_PATH))

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

  # Move actions directory
  FileUtils.mv(PATH_RPM_OUT / 'opt/aspera/orchestrator/actions', PATH_BUILD_SRC)

  # Move action_tools.rb file
  PATH_BUILD_LIB.mkpath
  FileUtils.mv(PATH_RPM_OUT / 'opt/aspera/orchestrator/lib/action_tools.rb', PATH_BUILD_LIB)
  FileUtils.mv(PATH_RPM_OUT / 'opt/aspera/orchestrator/app/helpers/actions_helper.rb', PATH_BUILD_LIB)

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
