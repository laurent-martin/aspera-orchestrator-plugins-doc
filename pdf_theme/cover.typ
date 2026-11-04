// Cover and last pages, for PDF with Typst, see README.md
// Positions are in pixels of cover.jpg, 1086 pixels wide, so that they follow the picture.
// The picture is 3:4, it goes past the bottom of a Letter page: with only its width, it would be centered on the page
// and cropped at the top too
#let cover-background = context place(top, image("cover.jpg", width: page.width, height: page.width * 1448 / 1086))
#let last-background = {
  place(top, image("back_top.jpg", width: 100%))
  place(bottom, image("back_bottom.jpg", width: 100%))
}
#let cover-text(title: none, subtitle: none, authors: (), date: none) = context {
  let px = page.width / 1086
  // Top of the text at its first baseline, leading from baseline to baseline
  set text(fill: rgb("#00000E"), top-edge: "baseline", bottom-edge: "baseline")
  place(top + left, dx: 75 * px, dy: 465 * px, block(width: 745 * px, stack(
    spacing: 53pt,
    {
      set text(size: 38pt)
      set par(leading: 44pt)
      text(weight: "bold")[Aspera Orchestrator]
      linebreak()
      // Title of the document without the first words, shown apart in bold
      show "Aspera Orchestrator ": none
      title
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
