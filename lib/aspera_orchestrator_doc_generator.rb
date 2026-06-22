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

  def initialize(logger: nil)
    # NOTE: category is returned by method category() in the main plugin ruby file (plugin_name.rb)
    # the category in metadata.yml is not always good.
    # categories are listed in: lib/action_tools.rb, like this: CATEGORY_<CONST_NAME> = '<Display Name>'
    @cat_const_to_name = {}
  end

  # finds the category of plugin
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

  def erb_to_html(file)
    return '<p class="coming-soon">Documentation coming soon...</p>' unless file.exist?

    plugin_folder = file.parent
    plugin_name = plugin_folder.basename.to_s.gsub(/s$/, '')

    begin
      src_file = plugin_folder / "#{plugin_name}.rb"
      ERB.new(file.read).result(ErbHelpers.new.get_binding(src_file)).gsub(/\sstyle="[^"]*"/, '')
      # rescue SyntaxError => e
      #  Log.log.error "Ignoring: #{file} due to syntax error: #{e}"
      #  e.to_s
      # rescue StandardError => e
      #  Log.log.error "Ignoring: #{file} due to exception: #{e}"
      #  e.to_s
    end
  end

  # Render an ERB template with the given binding
  def render_template(template_name, binding_context)
    template_path = Pathname.new(DIRNAME_TEMPLATES) / template_name
    raise "Template not found: #{template_path}" unless template_path.exist?

    template_content = template_path.read
    ERB.new(template_content).result(binding_context)
  end

  def build_doc(orch_version, source_folder, out_folder)
    raise 'version must not be empty' if orch_version.empty?

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
    ################################################################################################
    # 2: build doc
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

    ################################################################################################
    # 3: generate doc
    sections = plugin_data.each.map { |p| p[:meta][:category] }.sort.uniq
    (out_folder / 'doc.html').open('w') do |tmpdocfile|
      Log.log.info("Generating: #{tmpdocfile.path}")
      doctitle = "Aspera Orchestrator v#{orch_version} Plugins Manuals"

      html_content = render_template('doc.html.erb', binding)
      tmpdocfile.write(html_content)
    end

    ################################################################################################
    # 4: generate summary
    (out_folder / 'summary.html').open('w') do |tmpsumfile|
      doctitle = "Aspera Orchestrator v#{orch_version} Plugin Summary"
      plugin_count = plugin_data.length

      html_content = render_template('summary.html.erb', binding)
      tmpsumfile.write(html_content)
    end
    ################################################################################################
    # 5: generate condensed summary (banner)
    (out_folder / 'banner.html').open('w') do |tmpsumfile|
      doctitle = "Aspera Orchestrator v#{orch_version} Plugins"
      plugin_count = plugin_data.length

      html_content = render_template('banner.html.erb', binding)
      tmpsumfile.write(html_content)
    end
  end
end
