// Cover and last pages, for PDF with Typst, see README.md
// Positions are in pixels of cover.svg, 1086 pixels wide, so that they follow the picture.
// The picture is 3:4, it goes past the bottom of a Letter page: with only its width, it would be centered on the page
// and cropped at the top too.
// cover.svg declares the size of a Letter page and stretches its 3:4 view box to it: stretched to 3:4 again, it has its shape
#let cover-background = context place(top, image("cover.svg", width: page.width, height: page.width * 1448 / 1086, fit: "stretch"))
// IBM logo and product name at the top left, above and under the gradient rule of the picture
#let brand(px) = {
  set text(fill: rgb("#00000E"), top-edge: "baseline", bottom-edge: "baseline")
  place(top + left, dx: 72 * px, dy: 84 * px, image("ibm_logo.svg", width: 190 * px))
  place(top + left, dx: 72 * px, dy: 330 * px, text(size: 72 * px, weight: "light")[IBM #text(weight: "bold")[Aspera]#super(size: 0.3em)[®]])
}
// Pictures made from parts of cover.svg by make_back.rb
#let last-background = context {
  place(top, image("back_top.svg", width: 100%))
  place(bottom, image("back_bottom.svg", width: 100%))
  brand(page.width / 1086)
}
// Product name on the cover: set with `--input product-name=...` (typst compile), default is "Aspera Orchestrator"
#let product-name = sys.inputs.at("product-name", default: "Aspera Orchestrator")
// Plain string of Typst content (pandoc title is content, not str)
#let to-string(it) = {
  if type(it) == str { it }
  else if it.has("text") { it.text }
  else if it.has("children") { it.children.map(to-string).join("") }
  else if it.has("body") { to-string(it.body) }
  else { " " }
}
#let cover-text(title: none, subtitle: none, authors: (), date: none) = context {
  let px = page.width / 1086
  // Title string without the "product-name " prefix, for display on the cover
  let title-str = to-string(title)
  let prefix = product-name + " "
  let short-title = if title-str.starts-with(prefix) { title-str.slice(prefix.len()) } else { title-str }
  // Top of the text at its first baseline, leading from baseline to baseline
  set text(fill: rgb("#00000E"), top-edge: "baseline", bottom-edge: "baseline")
  brand(px)
  place(top + left, dx: 75 * px, dy: 465 * px, block(width: 745 * px, stack(
    spacing: 53pt,
    {
      set text(size: 38pt)
      set par(leading: 44pt)
      text(weight: "bold")[#product-name]
      linebreak()
      // Title without the product name prefix
      short-title
    },
    {
      set text(size: 17pt)
      set par(leading: 30pt)
      for author in authors { author.name; linebreak() }
      date
    },
  )))
  place(top + left, dx: 72 * px, dy: 1296 * px, rect(width: 93 * px, height: 3pt, fill: rgb("#03B8F8")))
  place(top + left, dx: 72 * px, dy: 1344 * px, text(fill: white, size: 11.5pt, tracking: 0.18em)[BUILD#h(1em)•#h(1em)AUTOMATE#h(1em)•#h(1em)ORCHESTRATE])
}
