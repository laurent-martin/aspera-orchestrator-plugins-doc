#!/usr/bin/env ruby
# frozen_string_literal: true

# Makes back_top.svg and back_bottom.svg, the pictures of the last page, from parts of cover.svg, see README.md
# Usage, from any folder: ruby pdf_theme/make_back.rb
require 'pathname'
require 'rexml/document'

HERE = Pathname.new(__dir__)
WIDTH = 1086
HEIGHT = 1448
# Rows of the fade to white, at the inner edge of each part
FADE = 90
# Margin around the computed boxes, for strokes and rounding
MARGIN = 20
PARTS = {
  # Rows 0 to 420: the ribbons at the top right, without the gradient rule of the cover
  'back_top.svg' => {from: 0, to: 420, remove: %w[rect41], title: 'top'},
  # Rows 1110 to the end: the bottom waves, without the globe and the workflow, that would be cut:
  # globe, dotted continents, atmosphere, workflow and halos of the transfer points
  'back_bottom.svg' => {from: 1110, to: HEIGHT, remove: %w[g3904 g3879 circle3879 g3898 g3903], title: 'bottom'}
}.freeze
NUMBER = /[-+]?(?:\d+\.?\d*|\.\d+)(?:[eE][-+]?\d+)?/
# Number of arguments of each path command
PATH_ARGS = {'M' => 2, 'L' => 2, 'H' => 1, 'V' => 1, 'C' => 6, 'S' => 4, 'Q' => 4, 'T' => 2, 'A' => 7, 'Z' => 0}.freeze

# Points of a path: end points and control points, a Bézier curve stays within its control points
def path_points(data)
  points = []
  x = y = start_x = start_y = 0.0
  data.scan(/([MmLlHhVvCcSsQqTtAaZz])([^MmLlHhVvCcSsQqTtAaZz]*)/) do |command, args|
    upper = command.upcase
    relative = command != upper
    numbers = args.scan(NUMBER).map(&:to_f)
    if upper == 'Z'
      x, y = start_x, start_y
      next
    end
    numbers.each_slice(PATH_ARGS[upper]).with_index do |values, index|
      case upper
      when 'H' then x = relative ? x + values[0] : values[0]
      when 'V' then y = relative ? y + values[0] : values[0]
      when 'A'
        # End point, and the radii around it and around the start point: more than the arc
        radius = values[0..1].map(&:abs).max
        points.push([x - radius, y - radius], [x + radius, y + radius])
        x, y = relative ? [x + values[5], y + values[6]] : values[5..6]
        points.push([x - radius, y - radius], [x + radius, y + radius])
      else
        values.each_slice(2) { |px, py| points.push(relative ? [x + px, y + py] : [px, py]) }
        x, y = points.last
      end
      points.push([x, y])
      # Points after the first one of a move are lines
      if upper == 'M' && index.zero?
        start_x, start_y = x, y
      end
    end
  end
  points
end

# Box [x_min, y_min, x_max, y_max] of an element, nil if unknown: then the element is kept
def box(element)
  number = ->(name) { Float(element.attributes[name] || 0) }
  points =
    case element.name
    when 'rect'
      [[number['x'], number['y']], [number['x'] + number['width'], number['y'] + number['height']]]
    when 'circle', 'ellipse'
      rx = element.name == 'circle' ? number['r'] : number['rx']
      ry = element.name == 'circle' ? number['r'] : number['ry']
      [[number['cx'] - rx, number['cy'] - ry], [number['cx'] + rx, number['cy'] + ry]]
    when 'path' then path_points(element.attributes['d'].to_s)
    end
  return if points.nil? || points.empty?

  xs, ys = points.transpose
  [xs.min, ys.min, xs.max, ys.max]
end

# Translation of a transform attribute, nil if it is another transform
def translation(element)
  transform = element.attributes['transform']
  return [0, 0] if transform.nil?

  match = /\A\s*translate\(\s*(#{NUMBER})(?:[\s,]+(#{NUMBER}))?\s*\)\s*\z/o.match(transform)
  match && [match[1].to_f, match[2].to_f]
end

def remove_element(element)
  # With the white space before it, so that no empty lines remain
  previous = element.previous_sibling_node
  previous.remove if previous.is_a?(REXML::Text) && previous.to_s.strip.empty?
  element.remove
end

# Removes the elements outside of rows from to to, in the coordinates of the parent
def remove_outside(parent, from, to, dy = 0.0)
  parent.elements.to_a.each do |element|
    next if %w[defs title desc].include?(element.name)

    offset = translation(element)
    next if offset.nil?

    if element.name == 'g'
      remove_outside(element, from, to, dy + offset[1])
      remove_element(element) if element.elements.empty?
      next
    end
    bounds = box(element)
    next if bounds.nil?

    remove_element(element) if bounds[3] + dy + offset[1] < from - MARGIN || bounds[1] + dy + offset[1] > to + MARGIN
  end
end

# Removes the definitions that nothing refers to, until none is left: a gradient may refer to another one
def remove_unused_definitions(doc)
  loop do
    references = []
    doc.root.each_recursive { |element| element.attributes.each_attribute { |attribute| references.concat(attribute.value.scan(/#([\w.-]+)/).flatten) } }
    unused = REXML::XPath.match(doc, '//*[local-name()="defs"]/*').reject { |definition| references.include?(definition.attributes['id']) }
    break if unused.empty?

    unused.each { |definition| remove_element(definition) }
  end
  REXML::XPath.match(doc, '//*[local-name()="defs"]').each { |defs| remove_element(defs) if defs.elements.empty? }
end

def part(from:, to:, remove:, title:)
  doc = REXML::Document.new((HERE / 'cover.svg').read)
  svg = doc.root
  rows = to - from
  # Same scale in both directions: cover.svg stretches its view box to a Letter page, the theme does not
  svg.attributes['height'] = "#{(215.9 * rows / WIDTH).round(2)}mm"
  svg.attributes['viewBox'] = "0 #{from} #{WIDTH} #{rows}"
  svg.attributes['sodipodi:docname'] = nil
  # Settings of the Inkscape window and comments of the cover
  REXML::XPath.match(doc, '//sodipodi:namedview').each { |element| remove_element(element) }
  REXML::XPath.match(doc, '//comment()').each(&:remove)
  REXML::XPath.first(doc, '//*[local-name()="title"]')&.text = "Aspera Orchestrator — vector background of the last page, #{title}"
  REXML::XPath.first(doc, '//*[local-name()="desc"]')&.text = "Rows #{from} to #{to} of cover.svg, made by make_back.rb. No text or logos."
  # Elements that the part would cut
  remove.each do |id|
    element = REXML::XPath.first(doc, "//*[@id='#{id}']") or raise "No element #{id} in cover.svg"
    remove_element(element)
  end
  remove_outside(svg, from, to)
  remove_unused_definitions(doc)
  fade_at_top = from.positive?
  y1, y2 = fade_at_top ? [from, from + FADE] : [to - FADE, to]
  opacity = fade_at_top ? [1, 0] : [0, 1]
  gradient = svg.add_element('defs').add_element('linearGradient', 'id' => 'fadeToWhite', 'gradientUnits' => 'userSpaceOnUse', 'x1' => '0', 'y1' => y1.to_s, 'x2' => '0', 'y2' => y2.to_s)
  opacity.each_with_index { |o, i| gradient.add_element('stop', 'offset' => i.to_s, 'stop-color' => '#ffffff', 'stop-opacity' => o.to_s) }
  svg.add_element('rect', 'x' => '0', 'y' => y1.to_s, 'width' => WIDTH.to_s, 'height' => FADE.to_s, 'fill' => 'url(#fadeToWhite)')
  doc.to_s
end

PARTS.each { |name, params| (HERE / name).write(part(**params)) }
