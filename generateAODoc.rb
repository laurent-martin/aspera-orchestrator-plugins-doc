#!/usr/bin/env ruby
# Laurent/Aspera
# generate pdf doc for Orchestrator
# look at Makefile for details to generate pdf from the html

require 'yaml'
require 'fileutils'
require 'date'

Encoding.default_internal = Encoding::UTF_8
Encoding.default_external = Encoding::UTF_8

DIRNAME_ACTIONS = 'actions'
DIRNAME_ICONS = 'icons'
ACTION_TOOLS = 'lib/action_tools.rb'
FILENAME_METADATA = 'metadata.yml'
FILENAME_HELP = 'help.html.erb'
EXTENSION_ICON = '.png'

# NOTE: category is returned by method category() in the main plugin ruby file (plugin_name.rb)
# the category in metadata.yml is not always good.
# categories are listed in: lib/action_tools.rb, like this: CATEGORY_<CONST_NAME> = '<Display Name>'
$cat_const_to_name = {}

# regex to represent a string (inside quotes, could be : /[^'"]+/)
RE_STRING_BODY = /.+?/
RE_STRING_ARGUMENT = /['"](#{RE_STRING_BODY})['"]\s*/

# finds the category of plugin
def set_plugin_category(thispl)
  # get first category from source file
  match_cat_method = File.read(thispl[:source_path]).match(/def\s+category.*?end/m)
  raise "ERROR: category method not found in #{thispl[:source_path]}" if match_cat_method.nil?

  match_categories = match_cat_method[0].match(/CATEGORY_([A-Z_]+)/)
  raise "ERROR: category name not found in #{thispl[:source_path]}" if match_categories.nil?

  # take first match
  category_alias = match_categories[1]
  # save category read from meta file
  category_meta = thispl[:meta][:category]
  # replace with category from plugin source
  thispl[:meta][:category] = $cat_const_to_name[category_alias]
  raise 'no category found' if thispl[:meta][:category].nil?

  return if category_meta.eql?(thispl[:meta][:category])

  puts "Warning: category mismatch: #{thispl[:long_name]}: src=#{thispl[:meta][:category]},meta=#{category_meta}"
end

# loads plugin metadata
def set_metadata(thispl)
  filepath_metadata = File.join(thispl[:folder], FILENAME_METADATA)
  if File.exist?(filepath_metadata)
    $stdout.puts("---->[#{filepath_metadata}]\n")
    thispl[:meta] = YAML.load_file(filepath_metadata, permitted_classes: [Date, Symbol])
    # $stdout.puts("---->[#{thispl}]\n")
    thispl[:meta][:category] = 'No Category' if thispl[:meta][:category].empty?
  else
    thispl[:meta] = {
      category: 'No Category',
      display_name: thispl[:long_name].split('_').map(&:capitalize).join(' '),
      description: 'No Description.',
      release_version: 'No version.',
      plugin_name: thispl[:ShortName]
    }
  end
  nil
end

def erb_to_html(file)
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

def build_doc(oavers, aSourceFolder, aFolderOut)
  raise 'version must not be empty' if oavers.empty?
  raise 'source folder must exist' unless Dir.exist?(aSourceFolder)
  raise 'dest folder must exist' unless Dir.exist?(aFolderOut)

  actions_folder = File.join(aSourceFolder, DIRNAME_ACTIONS)
  icons_folder = File.join(aFolderOut, DIRNAME_ICONS)
  FileUtils.mkdir_p(icons_folder)
  # read category names
  File.read(File.join(aSourceFolder, ACTION_TOOLS))
      .scan(/\bCATEGORY_(\S+) = ["']([^"']+)["']/) do |aliasname, value|
    $cat_const_to_name[aliasname] = value
  end
  puts "Categories: #{$cat_const_to_name.values.sort.join(',')}"
  puts "Plugin folder: #{actions_folder}"
  plugin_data = []
  ################################################################################################
  # 2: build doc
  Dir.entries(actions_folder).each do |entry|
    # skip pseudo folders
    next if entry.eql?('.') or entry.eql?('..')

    # init plugin data
    thispl = {
      folder: File.join(actions_folder, entry),
      long_name: entry.gsub(/s$/, '')
    }
    # plugin entry is a folder
    next unless File.directory?(thispl[:folder])

    # check source code
    thispl[:source_path] = File.join(thispl[:folder], thispl[:long_name] + '.rb')
    next unless File.exist?(thispl[:source_path])

    thispl[:ShortName] = thispl[:long_name].split('_').map(&:capitalize).join('')
    # puts "plugin: #{thispl}"

    set_metadata(thispl)

    set_plugin_category(thispl)

    icon_filename = thispl[:ShortName] + EXTENSION_ICON
    icon_src_file = File.join(thispl[:folder], icon_filename)
    thispl[:html_icon_path] = File.join(DIRNAME_ICONS, icon_filename)
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
    thispl[:doc] = ''
    thispl[:doc] << "<table width=\"100%\" bgcolor=\"#DDDDDD\"><tr><td><h2>#{thispl[:meta][:display_name]}</h2></td></tr></table>\n"
    thispl[:doc] << "<img src=\"#{thispl[:html_icon_path]}\"/><br/>#{thispl[:meta][:description]}<br/>\n"

    if thispl[:meta].has_key?(:revision_history)
      thispl[:doc] << '<table border="1px"><tr><th>Version</th><th>Comment</th></tr>'
      thispl[:meta][:revision_history].reverse_each do |v|
        thispl[:doc] << "<tr><td>#{v[:version]}</td><td>#{v[:change_description]}</td></tr>"
      end
      thispl[:doc] << '</table>'
    end

    thispl[:doc] << erb_to_html(File.join(thispl[:folder], FILENAME_HELP))
    plugin_data.push(thispl)
  end
  # sort list of plugins by name
  plugin_data.sort! { |a, b| a[:ShortName] <=> b[:ShortName] }

  ################################################################################################
  # 3: generate doc
  sections = plugin_data.each.map { |p| p[:meta][:category] }.sort.uniq
  File.open(File.join(aFolderOut, '/doc.html'), 'w') do |tmpdocfile|
    puts("Generating: #{tmpdocfile.path}")
    doctitle = "Aspera Orchestrator v#{oavers} Plugins Manuals"
    tmpdocfile.write("<html>
<head>
<style>
.doctitle {
    align:center;
    font-size:160%;
}
h1 {
    color: white;
}
pre{
    background-color: EEEEEE;
    font-family: monospace;
    white-space: pre;
    line-height: 1;
}
table {
    border-collapse: collapse;
    background-color: #111111;
    width: 100%;
}
th, td { padding: 0px; border-spacing:0px;}
</style>
<title>#{doctitle}</title>
</head>
    <body><p class=\"doctitle\">#{doctitle}</p>
")
    sections.each do |section|
      tmpdocfile.write("<table><tr><td><h1>#{section}</h1></td></tr></table>")
      plugin_data.each do |thispl|
        next unless section.eql?(thispl[:meta][:category])

        tmpdocfile.write(thispl[:doc])
      end
    end
    tmpdocfile.write('</body></html>')
  end

  ################################################################################################
  # 4: generate summary
  File.open(File.join(aFolderOut, 'summary.html'), 'w') do |tmpsumfile|
    doctitle = "Aspera Orchestrator v#{oavers} Plugin Summary"
    tmpsumfile.write('<html>')
    tmpsumfile.write("<head>
<style>
h1 {
    #color: white;
    #margin-left: 40px;
}
table {
    border-collapse: collapse;
}
table, th, td {
   border: 1px solid black;
   vertical-align : top;
}
.category {
    background-color: #CCCCCC;
    font-size:160%;
}
.icon {
    width: 40px;
}
.plugin_name {
    white-space: nowrap;
}
</style>
<title>#{doctitle}</title>
</head>
    <body><h1>#{doctitle}</h1><p>Count: #{plugin_data.length}</p>
")
    tmpsumfile.write('<table>')
    sections.each do |section|
      tmpsumfile.write("<tr><td colspan=\"4\" class=\"category\">#{section}</td></tr>")
      plugin_data.each do |thispl|
        next unless section.eql?(thispl[:meta][:category])

        tmpsumfile.write("<tr><td><img src=\"#{thispl[:html_icon_path]}\" class=\"icon\"></td><td class=\"plugin_name\">#{thispl[:meta][:display_name]}</td><td>#{thispl[:meta][:release_version]}</td><td>#{thispl[:meta][:description]}</td></tr>")
      end
    end
    tmpsumfile.write('</table>')
    tmpsumfile.write('</body></html>')
  end
  ################################################################################################
  # 4: generate condensed summary
  File.open(File.join(aFolderOut, 'banner.html'), 'w') do |tmpsumfile|
    doctitle = "Aspera Orchestrator v#{oavers} Plugins"
    tmpsumfile.write('<html>')
    tmpsumfile.write("<head>
<style>
.doc_title {
    #color: white;
    #margin-left: 40px;
    font-size:200%;
}
.plugin {
    vertical-align : top;
    text-align: center;
    border: 0px;
    font-family: sans-serif;
    font-size:60%;
    width: 70px;
    display:inline;
    white-space:wrap;
}
.category {
    background-color: #CCCCCC;
    font-size:100%;
    display:inline;
    height: 70px;
}
.icon {
    width: 48px;
}
</style>
<title>#{doctitle}</title>
</head>
    <body><p class=\"doc_title\">#{doctitle}</p><p>Count: #{plugin_data.length}</p>
")
    # max_columns = 16
    sections.each do |section|
      # cur_column = 1
      tmpsumfile.write("<div class=\"category\">#{section}</div>")
      plugin_data.each do |thispl|
        next unless section.eql?(thispl[:meta][:category])

        simplified_name = thispl[:meta][:display_name]
        simplified_name.gsub!(/ operation$/i, '')
        simplified_name.gsub!(/ trigger$/i, '')
        simplified_name.gsub!(/ transcoding$/i, '')
        simplified_name.gsub!(/ watcher$/i, '')
        tmpsumfile.write("<table class=\"plugin\"><tr><td><img src=\"#{thispl[:html_icon_path]}\" class=\"icon\"><br/>#{simplified_name}</td></tr></table>")
      end
      # tmpsumfile.write("</li>")
    end
    # tmpsumfile.write("</tr></table>")
    # tmpsumfile.write("</ul>")
    tmpsumfile.write('</body></html>')
  end
end

unless ARGV.length.eql?(3)
  puts("Usage: #{$0} <version> <main folder> <out folder>")
  puts('Example: 4.0.0 /opt/aspera/orchestrator .')
  Process.exit(1)
end

build_doc(ARGV[0], ARGV[1], ARGV[2])
