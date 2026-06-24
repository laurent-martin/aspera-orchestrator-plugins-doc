# frozen_string_literal: true

# Laurent/Aspera
# generate pdf doc for Orchestrator
# look at Rakefile for details to generate pdf from the html

require 'pathname'
require 'yaml'
require 'json'
require 'net/http'
require 'net/http/request'
require 'fileutils'
require 'date'
require 'erb'
require 'logger'
require 'set'
require 'aspera/log'

include Aspera

Encoding.default_internal = Encoding::UTF_8
Encoding.default_external = Encoding::UTF_8

# Load stub classes and modules for missing dependencies
require_relative 'erb_stubs'

# Generate documentation for Aspera Orchestrator plugins
class AsperaOrchestratorDocGenerator
  DIRNAME_ACTIONS = 'actions'
  DIRNAME_ICONS = 'icons'
  DIRNAME_TEMPLATES = 'templates'
  ACTION_TOOLS = 'lib/action_tools.rb'
  FILENAME_METADATA = 'metadata.yml'
  FILENAME_HELP = 'help.html.erb'
  EXTENSION_ICON = '.png'

  # regex to represent a string (inside quotes, could be : /[^'"]+/)
  RE_STRING_BODY = /.+?/
  RE_STRING_ARGUMENT = /['"](#{RE_STRING_BODY})['"]\s*/

  def initialize
    @cat_const_to_name = {}
  end

  # Finds the category of plugin
  # NOTE: category is returned by method category() in the main plugin ruby file (plugin_name.rb)
  # the category in metadata.yml is not always good.
  # categories are listed in: lib/action_tools.rb, like this: CATEGORY_<CONST_NAME> = '<Display Name>'
  def set_plugin_category(one_plugin)
    # get first category from source file
    match_cat_method = one_plugin[:source_path].read.match(/def\s+category.*?end/m)
    raise "ERROR: category method not found in #{one_plugin[:source_path]}" if match_cat_method.nil?

    match_categories = match_cat_method[0].match(/CATEGORY_([A-Z_]+)/)
    raise "ERROR: category name not found in #{one_plugin[:source_path]}" if match_categories.nil?

    # take first match
    category_alias = match_categories[1]
    # save category read from meta file
    category_meta = one_plugin[:meta][:category]
    # replace with category from plugin source
    one_plugin[:meta][:category] = @cat_const_to_name[category_alias]
    raise 'no category found' if one_plugin[:meta][:category].nil?
    return if category_meta.eql?(one_plugin[:meta][:category])

    Log.log.warn "category mismatch: #{one_plugin[:long_name]}: src=#{one_plugin[:meta][:category]},meta=#{category_meta}"
  end

  # loads plugin metadata
  def set_metadata(one_plugin)
    filepath_metadata = one_plugin[:folder] / FILENAME_METADATA
    if filepath_metadata.exist?
      Log.log.info(filepath_metadata.to_s)
      one_plugin[:meta] = YAML.load_file(filepath_metadata.to_s, permitted_classes: [Date, Symbol])
      Log.dump(:plugin, one_plugin)
      one_plugin[:meta][:category] = 'No Category' if one_plugin[:meta][:category].empty?
    else
      one_plugin[:meta] = {
        category: 'No Category',
        display_name: one_plugin[:long_name].split('_').map(&:capitalize).join(' '),
        description: 'No Description.',
        release_version: 'No version.',
        plugin_name: one_plugin[:ShortName]
      }
    end
    nil
  end

  # Returns the binding for ERB evaluation with plugin source code
  # @param src_file [Pathname] Path to plugin source file
  def get_binding(src_file)
    # extracted in `lib` directory
    require 'actions_helper'

    source = src_file.read
    # Load all required files relative to the plugin directory
    source = source.gsub(/^\s*require_relative\s+['"]([^'"]+)['"]\s*$/) do
      file_path = Regexp.last_match(1)
      "load (Pathname.new('#{src_file.dirname}') / '#{file_path}.rb').expand_path.to_s"
    end
    # Remove all require statements to avoid loading external gems
    source = source.gsub(/^\s*require\s+.*$/, '')
    # Replace __FILE__ with the actual file path
    source = source.gsub('__FILE__', "'#{src_file}'")
    # Evaluate plugin source at top-level so constants referenced by ERB remain accessible
    TOPLEVEL_BINDING.eval(source)
    # Create a context object that includes ActionsHelper
    context = Object.new
    context.extend(ActionsHelper)
    # Define the raw method in the context (identity function for HTML strings)
    context.define_singleton_method(:raw, &:itself)
    context.instance_eval { binding }
  end

  # Converts ERB file to HTML using the plugin's context
  # @param file [Pathname] Path to ERB file
  def erb_to_html(file)
    return '<p>No Documentation.</p>' unless file.exist?

    plugin_folder = file.parent
    # TODO: custom_rubies -> custom_ruby ?
    plugin_name = plugin_folder.basename.to_s.gsub(/s$/, '')
    source = file.read
    # Fix errors in doc
    source = source.gsub('<strong>"Continue Monitoring"</strong>', '<strong>Continue Monitoring</strong>')
    source = source.gsub('Select "Continue Monitoring"', 'Select <strong>Continue Monitoring</strong>')
    # Replace dynamic date with fixed date to avoid regeneration of doc
    source = source.gsub('Time.now.iso8601', '"2026-08-07T09:39:54+02:00"')
    source = source.gsub(/\sstyle="[^"]*"/, '')
    ERB.new(source).result(get_binding(plugin_folder / "#{plugin_name}.rb"))
       .gsub('<h4>', '<h3>').gsub('</h4>', '</h3>')
       .gsub('<h2>', '<h3>').gsub('</h2>', '</h3>')
       .gsub('<br>', '<p>').gsub('<br/>', '<p>').gsub('</br>', '')
  end

  # Render an ERB template with the given binding
  def render_template(template_name, binding_context)
    template_path = Pathname.new(DIRNAME_TEMPLATES) / template_name
    raise "Template not found: #{template_path}" unless template_path.exist?

    template_content = template_path.read
    ERB.new(template_content).result(binding_context)
  end

  # Render a template and write it to a file
  # @param output_path [Pathname] The path where to write the rendered template
  # @param template_name [String] The name of the template file (e.g., 'doc.html.erb')
  # @param template_vars [Hash] Hash of variables to make available in the template (as keyword arguments)
  def render_and_write_template(output_path, template_name, **template_vars)
    # Create a binding with the template variables
    template_binding = binding
    template_vars.each do |key, value|
      template_binding.local_variable_set(key, value)
    end

    output_path.open('w') do |file|
      Log.log.info("Generating: #{file.path}")
      html_content = render_template(template_name, template_binding)
      file.write(html_content)
    end
  end

  # Load and parse plugin data from source folder
  # @param source_folder [Pathname] Source folder containing actions
  # @param out_folder [Pathname] Output folder for icons
  # @return [Array<Hash>] Array of plugin data hashes
  def load_plugin_data(source_folder, out_folder)
    source_folder = Pathname.new(source_folder)
    out_folder = Pathname.new(out_folder)
    raise 'source folder must exist' unless source_folder.exist?
    raise 'dest folder must exist' unless out_folder.exist?

    actions_folder = source_folder / DIRNAME_ACTIONS
    icons_folder = out_folder / DIRNAME_ICONS
    icons_folder.mkpath

    # read category names
    (source_folder / ACTION_TOOLS).read
      .scan(/\bCATEGORY_(\S+) = ["']([^"']+)["']/) do |alias_name, value|
      @cat_const_to_name[alias_name] = value
    end
    Log.log.info "Categories: #{@cat_const_to_name.values.sort.join(',')}"
    Log.log.info "Plugin folder: #{actions_folder}"

    plugin_data = []
    actions_folder.children.each do |entry_path|
      # skip non-directories
      next unless entry_path.directory?

      entry = entry_path.basename.to_s
      # init plugin data
      one_plugin = {
        folder: entry_path,
        long_name: entry.gsub(/s$/, '')
      }

      # check source code
      one_plugin[:source_path] = one_plugin[:folder] / "#{one_plugin[:long_name]}.rb"
      next unless one_plugin[:source_path].exist?

      one_plugin[:ShortName] = one_plugin[:long_name].split('_').map(&:capitalize).join('')
      # Log.log.info "plugin: #{one_plugin}"

      set_metadata(one_plugin)

      set_plugin_category(one_plugin)

      icon_filename = one_plugin[:ShortName] + EXTENSION_ICON
      icon_src_file = one_plugin[:folder] / icon_filename
      one_plugin[:html_icon_path] = Pathname.new(DIRNAME_ICONS) / icon_filename
      if icon_src_file.exist?
        FileUtils.cp(icon_src_file.to_s, icons_folder.to_s)
      else
        Log.log.warn "no icon for #{icon_filename}"
        # patch a la mano
        if icon_filename.eql?('FfprobeInfo.png')
          FileUtils.cp((actions_folder / 'ffmpg_transcodings' / 'FfmpgTranscoding.png').to_s,
                       (icons_folder / icon_filename).to_s)
        end
      end
      one_plugin[:doc] = +''
      one_plugin[:doc] << "<div class=\"plugin-section\"><h2>#{one_plugin[:meta][:display_name]}</h2></div>\n"
      one_plugin[:doc] << "<div class=\"plugin-header\"><img src=\"#{one_plugin[:html_icon_path]}\" alt=\"#{one_plugin[:meta][:display_name]} icon\" class=\"plugin-icon\"/><p class=\"plugin-description\">#{one_plugin[:meta][:description]}</p></div>\n"

      if one_plugin[:meta].has_key?(:revision_history)
        one_plugin[:doc] << '<table class="revision-history"><tr><th>Version</th><th>Comment</th></tr>'
        one_plugin[:meta][:revision_history].reverse_each do |v|
          one_plugin[:doc] << "<tr><td>#{v[:version]}</td><td>#{v[:change_description]}</td></tr>"
        end
        one_plugin[:doc] << '</table>'
      end

      one_plugin[:doc] << erb_to_html(one_plugin[:folder] / FILENAME_HELP)
      plugin_data.push(one_plugin)
    end
    # sort list of plugins by name
    plugin_data.sort! { |a, b| a[:ShortName] <=> b[:ShortName] }
    plugin_data
  end

  # Create enriched context for template rendering
  # @param orch_version [String] Orchestrator version
  # @param plugin_data [Array<Hash>] Array of plugin data
  # @param doc_type [String] Type of document ('manual', 'summary', or 'banner')
  # @return [Hash] Context hash with all template variables
  def create_template_context(orch_version, plugin_data, doc_type)
    doc_titles = {
      'manual' => "Aspera Orchestrator v#{orch_version} Plugins Manuals",
      'summary' => "Aspera Orchestrator v#{orch_version} Plugin Summary",
      'banner' => "Aspera Orchestrator v#{orch_version} Plugins"
    }

    {
      orch_version: orch_version,
      doctitle: doc_titles[doc_type],
      sections: plugin_data.map { |p| p[:meta][:category] }.sort.uniq,
      plugin_count: plugin_data.length,
      plugin_data: plugin_data
    }
  end

  # Generate doc.html from plugin data
  # @param orch_version [String] Orchestrator version
  # @param plugin_data [Array<Hash>] Array of plugin data
  # @param out_folder [Pathname] Output folder
  def generate_doc_html(orch_version, plugin_data, out_folder)
    context = create_template_context(orch_version, plugin_data, 'manual')
    render_and_write_template(
      Pathname.new(out_folder) / 'doc.html',
      'doc.html.erb',
      **context
    )
  end

  # Generate summary.html from plugin data
  # @param orch_version [String] Orchestrator version
  # @param plugin_data [Array<Hash>] Array of plugin data
  # @param out_folder [Pathname] Output folder
  def generate_summary_html(orch_version, plugin_data, out_folder)
    context = create_template_context(orch_version, plugin_data, 'summary')
    render_and_write_template(
      Pathname.new(out_folder) / 'summary.html',
      'summary.html.erb',
      **context
    )
  end

  # Generate banner.html from plugin data
  # @param orch_version [String] Orchestrator version
  # @param plugin_data [Array<Hash>] Array of plugin data
  # @param out_folder [Pathname] Output folder
  def generate_banner_html(orch_version, plugin_data, out_folder)
    context = create_template_context(orch_version, plugin_data, 'banner')
    render_and_write_template(
      Pathname.new(out_folder) / 'banner.html',
      'banner.html.erb',
      **context
    )
  end

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

    Log.log.info("Generating PDF: #{pdf_file}")
    system(*cmd) || raise("Failed to generate PDF: #{pdf_file}")
  end

  # Clean up Markdown content generated by Pandoc
  # @param content [String] Raw Markdown content
  # @return [String] Cleaned Markdown content
  def clean_markdown_content(content)
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
    lines.join("\n")
  end

  # Generate Markdown from HTML using Pandoc and clean it up
  # @param html_path [String, Pathname] Path to input HTML file
  # @param md_path [String, Pathname] Path to output Markdown file
  # @param temp_md_path [String, Pathname] Path to temporary Markdown file
  def generate_markdown_from_html(html_path:, md_path:, temp_md_path:)
    run(
      'pandoc',
      '--from=html',
      '--to=gfm',
      '--wrap=none',
      '--shift-heading-level-by=1',
      "--output=#{temp_md_path}",
      html_path
    )
    # Clean up the generated Markdown
    content = File.read(temp_md_path)
    cleaned_content = clean_markdown_content(content)
    File.write(temp_md_path, cleaned_content)
    FileUtils.cp(temp_md_path, md_path)
  end

  # Legacy method for backward compatibility - loads plugin data and generates all HTML files
  # @deprecated Use load_plugin_data and individual generate_*_html methods instead
  def build_doc(orch_version, source_folder, out_folder)
    raise 'version must not be empty' if orch_version.empty?

    plugin_data = load_plugin_data(source_folder, out_folder)
    generate_doc_html(orch_version, plugin_data, out_folder)
    generate_summary_html(orch_version, plugin_data, out_folder)
    generate_banner_html(orch_version, plugin_data, out_folder)
  end
end
