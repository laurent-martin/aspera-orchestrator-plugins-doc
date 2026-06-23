# Build plugin doc for IBM Aspera Orchestrator
# Laurent Martin

require 'rake/clean'
require 'pathname'
require_relative 'lib/aspera_orchestrator_doc_generator'
require_relative 'lib/pdf_generator'

# Use the build system of aspera-cli
# DIR_PANDOC is <aspera-cli>/build/doc/pandoc
raise 'Missing environment variable DIR_PANDOC' unless ENV['DIR_PANDOC']

aspera_cli_gem_path = Pathname.new(ENV['DIR_PANDOC']).parent.parent / 'lib'
$LOAD_PATH.unshift(aspera_cli_gem_path)

require 'pandoc'
require 'build_tools'
include BuildTools

raise 'Set env var VERSION' unless ENV.key?('VERSION')

BUILD_VERSION = ENV['VERSION']
PATH_DOCS = Pathname.new('docs')
PATH_MANUAL_MD = PATH_DOCS / 'Orchestrator_Plugin_Manual.md'
PATH_MANUAL_PDF = PATH_DOCS / 'Orchestrator_Plugin_Manual.pdf'
PATH_LIST_PDF = PATH_DOCS / 'Orchestrator_Plugin_List.pdf'
PATH_BANNER_PDF = PATH_DOCS / 'Orchestrator_Plugin_Banner.pdf'

# Working folder
PATH_BUILD_MAIN = Pathname.new('build') / BUILD_VERSION
PATH_BUILD_SRC = (PATH_BUILD_MAIN / 'src').mkpath
PATH_BUILD_OUT = (PATH_BUILD_MAIN / 'out').mkpath

# Output file paths
HTML_DOC_PATH = PATH_BUILD_OUT / 'doc.html'
HTML_SUMMARY_PATH = PATH_BUILD_OUT / 'summary.html'
HTML_BANNER_PATH = PATH_BUILD_OUT / 'banner.html'
PLUGIN_DATA_PATH = PATH_BUILD_OUT / 'plugin_data.marshal'

desc 'Build all documentation (HTML + PDF)'
task default: [:pdf]

desc 'Generate HTML documentation'
task html: HTML_DOC_PATH

desc 'Generate all PDF documentation'
task pdf: %i[pdf_manual pdf_list pdf_banner]

desc 'Generate Plugin Manual PDF'
task pdf_manual: PATH_MANUAL_PDF

desc 'Generate Plugin List PDF'
task pdf_list: PATH_LIST_PDF

desc 'Generate Plugin Banner PDF'
task pdf_banner: PATH_BANNER_PDF

# Generate Plugin Manual Markdown from HTML
file PATH_MANUAL_MD.to_s => [HTML_DOC_PATH] do
  run(
    'pandoc',
    '-f', 'html',
    '-t', 'gfm', # Use GitHub Flavored Markdown for better table support
    '--wrap=none', # Don't wrap lines
    '-o', PATH_MANUAL_MD,
    HTML_DOC_PATH
  )
  # Clean up the generated Markdown
  content = File.read(PATH_MANUAL_MD)
  # Remove lines starting with ::: (Pandoc div markers)
  content.gsub!(/^:::.*$\n?/, '')
  # Remove HTML div tags
  content.gsub!(%r{</?div[^>]*>\n?}, '')
  # Convert HTML img tags to Markdown syntax: <img src="path" class="..." alt="text" /> -> ![text](path)
  content.gsub!(%r{<img\s+src="([^"]+)"[^>]*alt="([^"]*)"[^>]*/?>}, '![\\2](\\1){.plugin-icon}')
  # Fix heading levels: document title should be H1, categories H2, plugin names H3
  lines = content.split("\n")
  if lines.first && !lines.first.start_with?('#')
    lines[0] = "# #{lines[0]}" # Make document title H1
  end
  content = lines.join("\n")
  # Adjust heading levels: H1 -> H2 (categories), H2 -> H3 (plugin names), H3 -> H4, H4 -> H5
  content.gsub!(/^#### /, '##### ')  # H4 -> H5
  content.gsub!(/^### /, '#### ')    # H3 -> H4
  content.gsub!(/^## /, '### ')      # H2 -> H3 (plugin names)
  content.gsub!(/^# (?!#{Regexp.escape(lines[0].sub(/^# /, ''))})/, '## ') # H1 -> H2 (categories, except document title)
  # Remove empty lines that result from removed divs (max 2 consecutive empty lines)
  content.gsub!(/\n{3,}/, "\n\n")
  File.write(PATH_MANUAL_MD, content)
end

# Generate Plugin Manual PDF from Markdown using pandoc
file PATH_MANUAL_PDF.to_s => [PATH_MANUAL_MD] do
  if ENV['DIR_PANDOC']
    markdown_to_pdf(
      md: PATH_MANUAL_MD.to_s,
      pdf: PATH_MANUAL_PDF.to_s
    )
  else
    puts 'Warning: DIR_PANDOC not set. Cannot generate PDF with pandoc.'
    puts 'Example: DIR_PANDOC=../aspera-cli/build/doc/pandoc rake pdf_manual'
    exit 1
  end
end

# Generate Plugin List PDF (portrait)
file PATH_LIST_PDF.to_s => [HTML_SUMMARY_PATH] do
  PdfGenerator.html_to_pdf(
    html_file: HTML_SUMMARY_PATH,
    pdf_file: PATH_LIST_PDF
  )
end

# Generate Plugin Banner PDF (landscape)
file PATH_BANNER_PDF => [HTML_BANNER_PATH] do
  PdfGenerator.html_to_pdf(
    html_file: HTML_BANNER_PATH,
    pdf_file: PATH_BANNER_PDF,
    options: { orientation: 'landscape' }
  )
end

# Load plugin data (step 1-2: parse plugins and metadata)
file PLUGIN_DATA_PATH.to_s => [PATH_BUILD_MAIN] do
  generator = AsperaOrchestratorDocGenerator.new
  plugin_data = generator.load_plugin_data(PATH_BUILD_SRC, PATH_BUILD_OUT)
  File.open(PLUGIN_DATA_PATH, 'wb') { |f| Marshal.dump(plugin_data, f) }
end

# Generate doc.html (step 3)
file HTML_DOC_PATH.to_s => [PLUGIN_DATA_PATH] do
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
file HTML_SUMMARY_PATH.to_s => [PLUGIN_DATA_PATH] do
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
file HTML_BANNER_PATH.to_s => [PLUGIN_DATA_PATH] do
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

directory PATH_BUILD_MAIN.to_s do
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
  (PATH_BUILD_SRC / 'lib').mkpath
  rpmout_dir = PATH_BUILD_MAIN / 'rpmout'
  rpmout_dir.mkpath

  sh %(rpm2cpio #{rpm} | (cd #{rpmout_dir} && cpio -idv "*" "*/actions/*" "*/lib/action_tools.rb"))

  # Move actions directory
  actions_src = Dir.glob("#{rpmout_dir}/opt/aspera/orchestrator*/actions").first
  FileUtils.mv(actions_src, PATH_BUILD_SRC.to_s) if actions_src

  # Move action_tools.rb file
  action_tools_src = Dir.glob("#{rpmout_dir}/opt/aspera/orchestrator*/lib/action_tools.rb").first
  FileUtils.mv(action_tools_src, (PATH_BUILD_SRC / 'lib').to_s) if action_tools_src

  # FileUtils.rm_rf(rpmout_dir.to_s)
end

# Generate PDF from Markdown documentation
namespace :doc do
  desc 'Generate PDF from plugin development guide'
  task :guide do
    markdown_to_pdf(
      md: (PATH_DOCS / 'plugin-development-guide.md').to_s,
      pdf: (PATH_DOCS / 'plugin-development-guide.pdf').to_s
    )
  end
end

CLEAN.include(PATH_BUILD_OUT)
raise "Dir not found: #{src}" unless PATH_BUILD_SRC.exist?
