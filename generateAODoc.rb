#!/usr/bin/env ruby
# frozen_string_literal: true

# Laurent/Aspera
# generate pdf doc for Orchestrator
# look at Makefile for details to generate pdf from the html

require 'yaml'
require 'fileutils'
require 'date'
require 'erb'
require 'logger'

Encoding.default_internal = Encoding::UTF_8
Encoding.default_external = Encoding::UTF_8

# Override require to ignore missing gems during documentation generation
module Kernel
  alias original_require require

  def require(name)
    original_require(name)
  rescue LoadError => e
    # Ignore missing gems - they're not needed for documentation
    warn "Warning: Skipping missing gem: #{name}"
    false
  end
end

# Load stub classes and modules for missing dependencies
require_relative 'erb_stubs'

# Load ERB helper methods for template rendering
require_relative 'erb_helpers'

if WorkInput.respond_to?(:clone_for_workstep) == false
  Rails.logger.error 'Plugin not compatible with Orchestrator version < 2.6.0'
  raise Exception.new('Plugin not compatible with Orchestrator version < 2.6.0')
end

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
  ACTION_TOOLS = 'lib/action_tools.rb'
  FILENAME_METADATA = 'metadata.yml'
  FILENAME_HELP = 'help.html.erb'
  EXTENSION_ICON = '.png'

  # regex to represent a string (inside quotes, could be : /[^'"]+/)
  RE_STRING_BODY = /.+?/.freeze
  RE_STRING_ARGUMENT = /['"](#{RE_STRING_BODY})['"]\s*/.freeze

  def initialize
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
    return '<br/>documentation coming soon...' unless File.exist?(file)

    plugin_folder = File.dirname(file)
    plugin_name = File.basename(plugin_folder).gsub(/s$/, '')

    begin
      load(File.join(plugin_folder, "#{plugin_name}.rb"))
      helpers = ErbHelpers.new
      ERB.new(File.read(file)).result(helpers.get_binding)
    rescue LoadError => e
      Rails.logger.warn "Failed to load plugin #{plugin_name}: #{e.message} - using fallback"
      '<br/>documentation coming soon...'
    rescue Exception => e
      Rails.logger.error "Error processing plugin #{plugin_name}: #{e.message}"
      '<br/>documentation coming soon...'
    end
  end

  def erb_to_html_ok(file)
    return '<br/>documentation coming soon...' unless File.exist?(file)

    doc = File.read(file)

    # preformat fix
    doc.gsub!('line-height: 0.5;', '')

    # parameters
    doc.gsub!(/<%=\s*begin_parameters_list\s*%>/, '')
    doc.gsub!(/<%=\s*add_name\(#{RE_STRING_ARGUMENT}\)\s*%>/,
              '<h3>Description</h3><h4>Saved Parameters Description</h4>')
    doc.gsub!(/<%=\s*end_parameters_list\s*%>/, '</ul>')
    doc.gsub!(/<%=\s*add_parameter_help\(#{RE_STRING_ARGUMENT},\s*#{RE_STRING_ARGUMENT}\)\s*%>/,
              '<li><b>\\1</b>: \\2</li>')

    # inputs
    doc.gsub!(/<%=\s*begin_list\s*%>/, '<ul>')
    doc.gsub!(/<%=\s*end_list\s*%>/, '</ul>')
    doc.gsub!(/<%=\s*add_input_help\(#{RE_STRING_ARGUMENT},\s*#{RE_STRING_ARGUMENT}\)\s*%>/,
              '<li><b>\\1</b>: \\2</li>')
    doc.gsub!(/<%=\s*begin_inputs_description\s*%>/, '')
    doc.gsub!(/<%=\s*add_generic_input_help\(#{RE_STRING_ARGUMENT}\)\s*%>/,
              '<h4>Input description</h4>The list of inputs depends on the configuration of the \\1 action template.<br/>')
    doc.gsub!(/<%=\s*end_inputs_description\s*%>/, '')
    doc.gsub!(/<%=\s*add_comments\(\s*#{RE_STRING_ARGUMENT}\)\s*%>/,
              '<li><b>Name</b>: The name used to identify a saved \\2 configured instance.</li><li><b>Comments</b>: Some comments about this saved \\2 configured instance.</li>')

    # outputs
    doc.gsub!(/<%=\s*begin_outputs_description\s*%>/, '<h4>Outputs description</h4>')
    doc.gsub!(/<%=\s*end_outputs_description\s*%>/, '')
    doc.gsub!(/<%=\s*add_output_help\(["'](#{RE_STRING_BODY})["'],\s*#{RE_STRING_ARGUMENT}\s*\)\s*%>/,
              '<li><b>\\1</b>: \\2</li>')
    doc.gsub!(/<%=\s*add_output_help\((#{RE_STRING_BODY}),\s*#{RE_STRING_ARGUMENT}\)\s*%>/,
              '<li><b>\\1</b>: \\2</li>')
    doc.gsub!(/add_output_help/, 'XXXXXXXXXXXXXX')

    # instructions
    doc.gsub!(/<%=\s*operating_instructions_start\s*%>/, '<h4>Operating Instructions</h4>')
    doc.gsub!(/<%=\s*[A-Xa-z]+::([A-Z_]+)\s*%>/, '"\\1 "')
    doc.gsub!(/<%=\s*operating_instructions_end\s*%>/, '')

    # special strings
    doc.gsub!(/<%=\s*supported_actions_help\s*%>/, '')

    # delete other generated stuff
    doc.gsub!(/<%=\s*supported_actions_help\s*%>/, '')
    doc.gsub!(/<%=\s*dependencies_help\s*%>/, '')
    doc.gsub!(%r{<img src="(http://feeds.feedburner.com/)}, '&lt;img src=&quot;\1')
    doc
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
      one_plugin[:doc] << "<table width=\"100%\" bgcolor=\"#DDDDDD\"><tr><td><h2>#{one_plugin[:meta][:display_name]}</h2></td></tr></table>\n"
      one_plugin[:doc] << "<img src=\"#{one_plugin[:html_icon_path]}\" alt=\"#{one_plugin[:meta][:display_name]} icon\"/><br/>#{one_plugin[:meta][:description]}<br/>\n"

      if one_plugin[:meta].has_key?(:revision_history)
        one_plugin[:doc] << '<table border="1px"><tr><th>Version</th><th>Comment</th></tr>'
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
      tmpdocfile.write("<!DOCTYPE html>
<html lang=\"en\">
<head>
<meta charset=\"UTF-8\">
<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">
<style>
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}
body {
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
    line-height: 1.6;
    color: #333;
    background: #f5f5f5;
    padding: 20px;
}
.doctitle {
    text-align: center;
    font-size: 2.5rem;
    font-weight: 700;
    color: #2c3e50;
    margin: 30px 0;
    padding: 20px;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
    border-radius: 8px;
    box-shadow: 0 4px 6px rgba(0,0,0,0.1);
}
h1 {
    color: white;
    font-size: 1.8rem;
    font-weight: 600;
    padding: 15px 20px;
}
h2 {
    color: #2c3e50;
    margin: 20px 0 10px 0;
    font-size: 1.5rem;
}
h3 {
    color: #34495e;
    margin: 15px 0 10px 0;
    font-size: 1.3rem;
}
h4 {
    color: #555;
    margin: 12px 0 8px 0;
    font-size: 1.1rem;
}
p {
    margin: 10px 0;
    line-height: 1.8;
}
pre {
    background-color: #f8f9fa;
    border: 1px solid #e9ecef;
    border-radius: 4px;
    padding: 15px;
    font-family: 'Courier New', Consolas, monospace;
    white-space: pre-wrap;
    line-height: 1.5;
    overflow-x: auto;
    margin: 10px 0;
}
table {
    border-collapse: collapse;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    width: 100%;
    margin: 20px 0;
    border-radius: 8px;
    overflow: hidden;
    box-shadow: 0 4px 6px rgba(0,0,0,0.1);
}
th, td {
    padding: 12px 20px;
    text-align: left;
}
th {
    background-color: rgba(0,0,0,0.2);
    color: white;
    font-weight: 600;
    text-transform: uppercase;
    font-size: 0.9rem;
    letter-spacing: 0.5px;
}
td {
    background-color: white;
    color: #333;
    border-bottom: 1px solid #e9ecef;
}
tr:last-child td {
    border-bottom: none;
}
tr:hover td {
    background-color: #f8f9fa;
}
ul, ol {
    margin: 10px 0 10px 30px;
}
li {
    margin: 5px 0;
    line-height: 1.6;
}
li b {
    color: #667eea;
}
img {
    max-width: 100%;
    height: auto;
    border-radius: 4px;
    margin: 10px 0;
}
.plugin-section {
    background: white;
    padding: 25px;
    margin: 20px 0;
    border-radius: 8px;
    box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}
</style>
<title>#{doctitle}</title>
</head>
<body><p class=\"doctitle\">#{doctitle}</p>
")
      sections.each do |section|
        tmpdocfile.write("<table><tr><td><h1>#{section}</h1></td></tr></table>")
        plugin_data.each do |one_plugin|
          next unless section.eql?(one_plugin[:meta][:category])

          tmpdocfile.write(one_plugin[:doc])
        end
      end
      tmpdocfile.write('</body></html>')
    end

    ################################################################################################
    # 4: generate summary
    File.open(File.join(out_folder, 'summary.html'), 'w') do |tmpsumfile|
      doctitle = "Aspera Orchestrator v#{orch_version} Plugin Summary"
      tmpsumfile.write("<!DOCTYPE html>\n<html lang=\"en\">\n")
      tmpsumfile.write("<head>
<meta charset=\"UTF-8\">
<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">
<style>
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}
body {
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
    line-height: 1.6;
    color: #333;
    background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
    padding: 30px;
    min-height: 100vh;
}
h1 {
    color: #2c3e50;
    font-size: 2.5rem;
    font-weight: 700;
    margin-bottom: 10px;
    text-align: center;
}
p {
    text-align: center;
    color: #555;
    font-size: 1.1rem;
    margin-bottom: 30px;
}
table {
    border-collapse: collapse;
    width: 100%;
    background: white;
    border-radius: 8px;
    overflow: hidden;
    box-shadow: 0 4px 6px rgba(0,0,0,0.1);
    margin-bottom: 20px;
}
table, th, td {
   border: none;
   vertical-align: middle;
}
th {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
    padding: 15px;
    text-align: left;
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 0.5px;
}
td {
    padding: 15px;
    border-bottom: 1px solid #e9ecef;
}
tr:last-child td {
    border-bottom: none;
}
tr:hover {
    background-color: #f8f9fa;
}
.category {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
    font-size: 1.5rem;
    font-weight: 600;
    padding: 15px 20px;
    text-transform: uppercase;
    letter-spacing: 1px;
}
.icon {
    width: 48px;
    height: 48px;
    border-radius: 8px;
    box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}
.plugin_name {
    white-space: nowrap;
    font-weight: 600;
    color: #2c3e50;
    font-size: 1.1rem;
}
td:nth-child(3) {
    color: #667eea;
    font-weight: 500;
}
td:nth-child(4) {
    color: #555;
    line-height: 1.6;
}
</style>
<title>#{doctitle}</title>
</head>
<body><h1>#{doctitle}</h1><p>Count: #{plugin_data.length} plugins</p>
")
      tmpsumfile.write('<table>')
      sections.each do |section|
        tmpsumfile.write("<tr><td colspan=\"4\" class=\"category\">#{section}</td></tr>")
        plugin_data.each do |one_plugin|
          next unless section.eql?(one_plugin[:meta][:category])

          tmpsumfile.write("<tr><td><img src=\"#{one_plugin[:html_icon_path]}\" alt=\"#{one_plugin[:meta][:display_name]} icon\" class=\"icon\"></td><td class=\"plugin_name\">#{one_plugin[:meta][:display_name]}</td><td>#{one_plugin[:meta][:release_version]}</td><td>#{one_plugin[:meta][:description]}</td></tr>")
        end
      end
      tmpsumfile.write('</table>')
      tmpsumfile.write('</body></html>')
    end
    ################################################################################################
    # 4: generate condensed summary
    File.open(File.join(out_folder, 'banner.html'), 'w') do |tmpsumfile|
      doctitle = "Aspera Orchestrator v#{orch_version} Plugins"
      tmpsumfile.write("<!DOCTYPE html>\n<html lang=\"en\">\n")
      tmpsumfile.write("<head>
<meta charset=\"UTF-8\">
<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">
<style>
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}
body {
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    padding: 40px 20px;
    min-height: 100vh;
}
.doc_title {
    color: white;
    font-size: 3rem;
    font-weight: 700;
    text-align: center;
    margin-bottom: 10px;
    text-shadow: 2px 2px 4px rgba(0,0,0,0.2);
}
body > p {
    color: rgba(255,255,255,0.9);
    text-align: center;
    font-size: 1.2rem;
    margin-bottom: 40px;
}
.category {
    background: rgba(255,255,255,0.95);
    color: #2c3e50;
    font-size: 1.5rem;
    font-weight: 600;
    padding: 15px 25px;
    margin: 30px 0 20px 0;
    border-radius: 8px;
    display: block;
    text-transform: uppercase;
    letter-spacing: 1px;
    box-shadow: 0 4px 6px rgba(0,0,0,0.1);
}
.plugin {
    display: inline-block;
    vertical-align: top;
    text-align: center;
    background: white;
    border-radius: 12px;
    padding: 15px;
    margin: 10px;
    width: 120px;
    box-shadow: 0 4px 6px rgba(0,0,0,0.1);
    transition: all 0.3s ease;
    cursor: pointer;
}
.plugin:hover {
    transform: translateY(-5px);
    box-shadow: 0 8px 12px rgba(0,0,0,0.2);
}
.plugin td {
    color: #2c3e50;
    font-size: 0.85rem;
    font-weight: 500;
    line-height: 1.4;
    padding: 8px 0 0 0;
}
.icon {
    width: 64px;
    height: 64px;
    border-radius: 8px;
    margin-bottom: 8px;
    box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}
</style>
<title>#{doctitle}</title>
</head>
<body><p class=\"doc_title\">#{doctitle}</p><p>Count: #{plugin_data.length} plugins</p>
")
      # max_columns = 16
      sections.each do |section|
        # cur_column = 1
        tmpsumfile.write("<div class=\"category\">#{section}</div>")
        plugin_data.each do |one_plugin|
          next unless section.eql?(one_plugin[:meta][:category])

          simplified_name = one_plugin[:meta][:display_name]
          simplified_name.gsub!(/ operation$/i, '')
          simplified_name.gsub!(/ trigger$/i, '')
          simplified_name.gsub!(/ transcoding$/i, '')
          simplified_name.gsub!(/ watcher$/i, '')
          tmpsumfile.write("<table class=\"plugin\"><tr><td><img src=\"#{one_plugin[:html_icon_path]}\" alt=\"#{simplified_name} icon\" class=\"icon\"><br/>#{simplified_name}</td></tr></table>")
        end
        # tmpsumfile.write("</li>")
      end
      # tmpsumfile.write("</tr></table>")
      # tmpsumfile.write("</ul>")
      tmpsumfile.write('</body></html>')
    end
  end
end

unless ARGV.length.eql?(3)
  puts("Usage: #{$0} <version> <main folder> <out folder>")
  puts('Example: 4.0.0 /opt/aspera/orchestrator .')
  Process.exit(1)
end

AsperaOrchestratorDocGenerator.new.build_doc(ARGV[0], ARGV[1], ARGV[2])
