# frozen_string_literal: true

# Helper class for ERB template rendering
# Provides HTML generation methods used in plugin help.html.erb files
class ErbHelpers
  def populate_list(items, list_type = nil)
    return '' if items.nil? || items.empty?

    tag = list_type == ActionsHelper::ORDERED_LIST ? 'ol' : 'ul'
    content = items.map do |item|
      text = item.is_a?(Hash) ? (item[:text] || '') : item.to_s
      "<li>#{text}</li>"
    end.join("\n")

    "<#{tag}>\n#{content}\n</#{tag}>"
  end

  def add_sub_heading(heading)
    "<h3>#{heading}</h3>"
  end

  def fill_paragraph(content)
    if content.is_a?(Hash)
      bold_part = content[:bold] || ''
      text_part = content[:text] || ''
      "<p><strong>#{bold_part}</strong>#{text_part}</p>"
    else
      "<p>#{content}</p>"
    end
  end

  def populate_table(headers, rows)
    return '' if rows.nil? || rows.empty?

    header_html = "<tr>#{headers.map { |h| "<th>#{h}</th>" }.join}</tr>"
    rows_html = rows.map do |row|
      cells = row.map { |cell| "<td>#{cell}</td>" }.join
      "<tr>#{cells}</tr>"
    end.join("\n")

    "<table class='data-table'>\n#{header_html}\n#{rows_html}\n</table>"
  end

  def raw(a)
    a
  end

  def begin_parameters_list
    ''
  end

  def end_parameters_list
    '</ul>'
  end

  def begin_inputs_description
    ''
  end

  def end_inputs_description
    ''
  end

  def begin_outputs_description
    '<h4>Outputs description</h4>'
  end

  def end_outputs_description
    ''
  end

  def begin_list
    '<ul>'
  end

  def end_list
    '</ul>'
  end

  def add_name(n)
    '<h3>Description</h3><h4>Saved Parameters Description</h4>'
  end

  def add_parameter_help(a, b)
    "<li><b>#{a}</b>: #{b}</li>"
  end

  def add_input_help(a, b)
    "<li><b>#{a}</b>: #{b}</li>"
  end

  def add_output_help(a, b)
    "<li><b>#{a}</b>: #{b}</li>"
  end

  def add_generic_input_help(action_name)
    "<h4>Input description</h4><p>The list of inputs depends on the configuration of the #{action_name} action template.</p>"
  end

  def add_comments(action_name)
    "<li><b>Name</b>: The name used to identify a saved #{action_name} configured instance.</li><li><b>Comments</b>: Some comments about this saved #{action_name} configured instance.</li>"
  end

  def supported_actions_help
    ''
  end

  def dependencies_help
    ''
  end

  def operating_instructions_start
    '<h4>Operating Instructions</h4>'
  end

  def operating_instructions_end
    ''
  end

  # Returns the binding of this instance for ERB evaluation
  def get_binding
    binding
  end
end

# Made with Bob
