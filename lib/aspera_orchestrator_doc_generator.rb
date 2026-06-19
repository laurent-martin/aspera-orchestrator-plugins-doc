# frozen_string_literal: true

# Laurent/Aspera
# generate pdf doc for Orchestrator
# look at Rakefile for details to generate pdf from the html

require 'yaml'
require 'json'
require 'net/http'
require 'net/http/request'
require 'fileutils'
require 'date'
require 'erb'
require 'logger'
require 'set'

Encoding.default_internal = Encoding::UTF_8
Encoding.default_external = Encoding::UTF_8

# Load stub classes and modules for missing dependencies
require_relative 'erb_stubs'

# Load ERB helper methods for template rendering
require_relative 'erb_helpers'

# generate documentation for Aspera Orchestrator plugins
# 1. read metadata from metadata.yml
# 2. read help.html.erb and convert erb to html
# 3. generate doc.html
# 4. generate summary.html
# 5. generate banner.html
# 6. copy icons
# 7. copy pdfs
class AsperaOrchestratorDocGenerator
  DIRNAME_ACTIONS = 'actions'
  DIRNAME_ICONS = 'icons'
  DIRNAME_TEMPLATES = 'templates'
  ACTION_TOOLS = 'lib/action_tools.rb'
  FILENAME_METADATA = 'metadata.yml'
  FILENAME_HELP = 'help.html.erb'
  EXTENSION_ICON = '.png'

  # regex to represent a string (inside quotes, could be : /[^'"]+/)
  RE_STRING_BODY = /.+?/.freeze
  RE_STRING_ARGUMENT = /['"](#{RE_STRING_BODY})['"]\s*/.freeze

  attr_reader :logger

  def initialize(logger: nil)
    @logger = logger || Logger.new(STDOUT)
    # NOTE: category is returned by method category() in the main plugin ruby file (plugin_name.rb)
    # the category in metadata.yml is not always good.
    # categories are listed in: lib/action_tools.rb, like this: CATEGORY_<CONST_NAME> = '<Display Name>'
    @cat_const_to_name = {}
  end

  # finds the category of plugin
  def set_plugin_category(one_plugin)
    # get first category from source file
    match_cat_method = File.read(one_plugin[:source_path]).match(/def\s+category.*?end/m)
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

    puts "Warning: category mismatch: #{one_plugin[:long_name]}: src=#{one_plugin[:meta][:category]},meta=#{category_meta}"
  end

  # loads plugin metadata
  def set_metadata(one_plugin)
    filepath_metadata = File.join(one_plugin[:folder], FILENAME_METADATA)
    if File.exist?(filepath_metadata)
      $stdout.puts("---->[#{filepath_metadata}]\n")
      one_plugin[:meta] = YAML.load_file(filepath_metadata, permitted_classes: [Date, Symbol])
      # $stdout.puts("---->[#{one_plugin}]\n")
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

  def erb_to_html(file)
    return '<p class="coming-soon">Documentation coming soon...</p>' unless File.exist?(file)

    plugin_folder = File.dirname(file)
    plugin_name = File.basename(plugin_folder).gsub(/s$/, '')

    begin
      source = File.read(File.join(plugin_folder, "#{plugin_name}.rb"))
      source = source.gsub(/require(_relative)?\s+['"]([^'"]+)['"]/, '')
      ERB.new(File.read(file)).result(ErbHelpers.new.get_binding(source)).gsub('line-height: 0.5;', '')
    rescue SyntaxError => e
      @logger.warn "Ignoring: #{file} due to syntax error: #{e}"
      e.to_s
    rescue StandardError => e
      @logger.warn "Ignoring: #{file} due to exception: #{e}"
      e.to_s
    end
  end

  # Render an ERB template with the given binding
  def render_template(template_name, binding_context)
    template_path = File.join(DIRNAME_TEMPLATES, template_name)
    raise "Template not found: #{template_path}" unless File.exist?(template_path)

    template_content = File.read(template_path)
    ERB.new(template_content).result(binding_context)
  end

  def build_doc(orch_version, source_folder, out_folder)
    raise 'version must not be empty' if orch_version.empty?
    raise 'source folder must exist' unless Dir.exist?(source_folder)
    raise 'dest folder must exist' unless Dir.exist?(out_folder)

    actions_folder = File.join(source_folder, DIRNAME_ACTIONS)
    icons_folder = File.join(out_folder, DIRNAME_ICONS)
    FileUtils.mkdir_p(icons_folder)
    # read category names
    File.read(File.join(source_folder, ACTION_TOOLS))
        .scan(/\bCATEGORY_(\S+) = ["']([^"']+)["']/) do |alias_name, value|
      @cat_const_to_name[alias_name] = value
    end
    puts "Categories: #{@cat_const_to_name.values.sort.join(',')}"
    puts "Plugin folder: #{actions_folder}"
    plugin_data = []
    ################################################################################################
    # 2: build doc
    Dir.entries(actions_folder).each do |entry|
      # skip pseudo folders
      next if entry.eql?('.') || entry.eql?('..')

      # init plugin data
      one_plugin = {
        folder: File.join(actions_folder, entry),
        long_name: entry.gsub(/s$/, '')
      }
      # plugin entry is a folder
      next unless File.directory?(one_plugin[:folder])

      # check source code
      one_plugin[:source_path] = File.join(one_plugin[:folder], one_plugin[:long_name] + '.rb')
      next unless File.exist?(one_plugin[:source_path])

      one_plugin[:ShortName] = one_plugin[:long_name].split('_').map(&:capitalize).join('')
      # puts "plugin: #{one_plugin}"

      set_metadata(one_plugin)

      set_plugin_category(one_plugin)

      icon_filename = one_plugin[:ShortName] + EXTENSION_ICON
      icon_src_file = File.join(one_plugin[:folder], icon_filename)
      one_plugin[:html_icon_path] = File.join(DIRNAME_ICONS, icon_filename)
      if File.exist?(icon_src_file)
        FileUtils.cp(icon_src_file, icons_folder)
      else
        puts "Warning: no icon for #{icon_filename}"
        # patch a la mano
        if icon_filename.eql?('FfprobeInfo.png')
          FileUtils.cp(File.join(actions_folder, 'ffmpg_transcodings/FfmpgTranscoding.png'),
                       File.join(icons_folder, icon_filename))
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

      one_plugin[:doc] << erb_to_html(File.join(one_plugin[:folder], FILENAME_HELP))
      plugin_data.push(one_plugin)
    end
    # sort list of plugins by name
    plugin_data.sort! { |a, b| a[:ShortName] <=> b[:ShortName] }

    ################################################################################################
    # 3: generate doc
    sections = plugin_data.each.map { |p| p[:meta][:category] }.sort.uniq
    File.open(File.join(out_folder, '/doc.html'), 'w') do |tmpdocfile|
      puts("Generating: #{tmpdocfile.path}")
      doctitle = "Aspera Orchestrator v#{orch_version} Plugins Manuals"

      html_content = render_template('doc.html.erb', binding)
      tmpdocfile.write(html_content)
    end

    ################################################################################################
    # 4: generate summary
    File.open(File.join(out_folder, 'summary.html'), 'w') do |tmpsumfile|
      doctitle = "Aspera Orchestrator v#{orch_version} Plugin Summary"
      plugin_count = plugin_data.length

      html_content = render_template('summary.html.erb', binding)
      tmpsumfile.write(html_content)
    end
    ################################################################################################
    # 5: generate condensed summary (banner)
    File.open(File.join(out_folder, 'banner.html'), 'w') do |tmpsumfile|
      doctitle = "Aspera Orchestrator v#{orch_version} Plugins"
      plugin_count = plugin_data.length

      html_content = render_template('banner.html.erb', binding)
      tmpsumfile.write(html_content)
    end
  end
end
