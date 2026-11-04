# PDF theme

Theme of [gfm2pdf-toolchain](https://github.com/laurent-martin/gfm2pdf-toolchain) for the PDF documents of this repository: pictures of the cover and last pages, text of the cover, and fonts IBM Plex Sans and IBM Plex Mono.

The `Rakefile` always uses this theme.

The cover shows the bold words `Aspera Orchestrator`, then the title of the document without these words, its author and its date.

The picture of the last page is landscape: it is split in two, `back_top.jpg` and `back_bottom.jpg`, placed at the top and at the bottom of the page.
It is cut at row 500, the closest to white, and both pieces fade to white over 80 rows, as this row is not fully white.

The pictures are JPEG, without metadata: a PDF document contains a JPEG file unchanged, it cannot contain WebP, and PNG would take about 7 times more space.
On these saturated blues, no color subsampling (`4:4:4`) gives better quality than a higher JPEG quality with subsampling, for the same size.

To generate the pictures again from the originals, which are not in this repository, from the root of the repository:

```shell
COVER="private/cover_art/IBM Aspera Global Workflow Cover.png"
BACK="private/cover_art/IBM Aspera Waves and Global Network.png"
magick "$COVER" -strip -sampling-factor 4:4:4 -quality 85 pdf_theme/cover.jpg
magick "$BACK" -crop 1536x500+0+0 +repage \( -size 1536x420 xc:white -size 1536x80 gradient:white-black -append \) -alpha off -compose CopyOpacity -composite -compose Over -background white -flatten -strip -sampling-factor 4:4:4 -quality 85 pdf_theme/back_top.jpg
magick "$BACK" -crop 1536x524+0+500 +repage \( -size 1536x80 gradient:black-white -size 1536x444 xc:white -append \) -alpha off -compose CopyOpacity -composite -compose Over -background white -flatten -strip -sampling-factor 4:4:4 -quality 85 pdf_theme/back_bottom.jpg
```
