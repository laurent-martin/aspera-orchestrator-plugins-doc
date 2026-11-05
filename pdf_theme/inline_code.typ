// Background of inline code, lighter than the luma(222) of the toolchain (typst/report.typ), see README.md.
// Same gray as with LaTeX (cover.tex), and darker than the luma(245) of the shaded table rows, where inline code must show.
// The template sets the highlight in `conf`, after this file: a `show raw` rule here would not apply.
// This rule matches the highlight of the template by its fill, and replaces it by one with the same edges.
#show highlight.where(fill: luma(222)): it => highlight(fill: luma(230), top-edge: it.top-edge, bottom-edge: it.bottom-edge, it.body)
