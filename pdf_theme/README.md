# PDF theme

Theme of [gfm2pdf-toolchain](https://github.com/laurent-martin/gfm2pdf-toolchain) for the PDF documents of this repository: pictures of the cover and last pages, logo and text of the cover, and fonts IBM Plex Sans and IBM Plex Mono.

The `Rakefile` always uses this theme.

The cover is the vector picture `cover.svg`, with no text or logo.
On top of it, the theme places the IBM logo (`ibm_logo.svg`, the 8-bar positive logo of the [IBM Design Language](https://www.ibm.com/brand/experience-guides/developer/b1db1ae501d522a1a4b49613fe07c9f1/01_8-bar-positive.svg), with its white background removed and cropped to the logo), and `IBM Aspera®` as text, above and under the gradient rule of the picture.
Then come the bold words `Aspera Orchestrator`, the title of the document without these words, its author and its date.
Typst uses the SVG files as they are. LaTeX cannot, it uses PDF files generated from the SVG files, see below.

The view box of `cover.svg` is 3:4, 1086 × 1448, but the file declares the size of a Letter page and stretches its view box to it (`preserveAspectRatio="none"`).
The theme stretches it to 3:4 again, as wide as the page: it goes past the bottom of the page, and the positions of the text, in pixels of the view box, follow the picture.

The pictures of the last page, `back_top.svg` and `back_bottom.svg`, are parts of `cover.svg`, placed at the top and at the bottom of the page, with the same logo and text as the cover at the top left.
`make_back.rb` makes them:

- `back_top.svg`: the rows 0 to 420 of the cover, fading to white over their last 90 rows, without the gradient rule, which is only for the cover.
- `back_bottom.svg`: the rows 1110 to the end, fading from white over their first 90 rows, without the globe and the workflow, which would be cut.
- In both, only what the part shows: no element outside of its rows, no unused definition, no comment and no settings of the Inkscape window. Their size is the one of their view box, they need no stretch.

To make them again after any change of `cover.svg`, then the PDF files for LaTeX, from the root of the repository:

```shell
ruby pdf_theme/make_back.rb
for f in cover ibm_logo back_top back_bottom; do rsvg-convert -f pdf pdf_theme/$f.svg -o pdf_theme/$f.pdf; done
```

All pictures are vector: `cover.svg` has no filter, as a PDF document cannot contain one, and the PDF writers would turn it into a bitmap.
