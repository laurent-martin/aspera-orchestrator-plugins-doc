# IBM Aspera Orchestrator plugin documentation

This repository generates the plugin (action) documentation for IBM Aspera Orchestrator, and holds the guides for plugin developers and workflow authors.

The plugin documentation is generated from the Orchestrator RPM: the `actions` folder and some library files are extracted from it, then the metadata, source and help page of each plugin are rendered to HTML, Markdown and PDF.

## Documents

Generated documents and guides are in folder `docs`:

| Document                                                                         | Content                                                       | Rake task                      |
|----------------------------------------------------------------------------------|---------------------------------------------------------------|--------------------------------|
| [`Orchestrator_Plugin_Manual.md`](docs/Orchestrator_Plugin_Manual.md) and `.pdf` | Help page of each plugin, by category                         | `md_manual`, `pdf_manual`      |
| [`Orchestrator_Plugin_List.pdf`](docs/Orchestrator_Plugin_List.pdf)              | Table of plugins: icon, name, version, description            | `pdf_list`                     |
| [`Orchestrator_Plugin_Banner.pdf`](docs/Orchestrator_Plugin_Banner.pdf)          | Icons and names of plugins, by category (landscape)           | `pdf_banner`                   |
| [`action-template-reference.md`](docs/action-template-reference.md)              | Template attributes, inputs and outputs of each action plugin | `doc:template_reference`       |
| [`plugins.yml`](docs/plugins.yml)                                                | Same, as data, with allowed values and conditions             | `doc:plugin_specs`             |
| [`plugin-development-guide.md`](docs/plugin-development-guide.md) and `.pdf`     | How to develop a plugin                                       | `doc:guide` (PDF and diagrams) |
| [`workflow-authoring-guide.md`](docs/workflow-authoring-guide.md) and `.pdf`     | How to write workflows                                        | `doc:authoring` (PDF only)     |
| [`portlet-development-guide.md`](docs/portlet-development-guide.md) and `.pdf`   | How to develop a dashboard portlet                            | `doc:portlets` (PDF only)      |

The three guides are written by hand (the task generates their PDF), the other documents are generated: do not edit them.

Diagrams of the guides are drawn in [`docs/images/diagrams.drawio`](docs/images/diagrams.drawio), one tab per image: `rake doc:diagrams` exports each tab to `docs/images/<tab>.svg` (for GitHub) and `.pdf` (used in the PDF), with draw.io desktop, when the `.drawio` file is newer.

Intermediate HTML files (`rake html`) are in `build/<VERSION>/out`.

## Prerequisites

- Ruby
- A clone of the `aspera-cli` repository, <https://github.com/IBM/aspera-cli>, with its gems installed (`bundle install` in that folder).
  Its library is used for logging (`aspera/log`), and its PDF theme `build/doc/pdf_theme` for the look of the PDF documents
  (cover and fonts): set env var `GFM2PDF_THEME` to use another theme.
- A clone of the `gfm2pdf-toolchain` repository, version 1.x, <https://github.com/laurent-martin/gfm2pdf-toolchain>.
  Its library is used for PDF generation from Markdown with `pandoc`.
  The options of a document for PDF generation are in a comment `<!-- gfm2pdf` at the top of its Markdown file.
- Tools:

| Tool            | Used for                                           |
|-----------------|----------------------------------------------------|
| `rpm2cpio`      | Extract the RPM (`extract_rpm`)                    |
| `wkhtmltopdf`   | Generate the plugin list and banner PDF from HTML  |
| `qpdf`          | Make PDF files reproducible (document ID)          |
| `exiftool`      | Make PDF files reproducible (dates)                |
| `pandoc`        | Convert HTML to Markdown, and Markdown to PDF      |
| `lualatex`      | PDF engine of `pandoc`                             |
| draw.io desktop | Export the diagrams of the guides (`doc:diagrams`) |

The PDF theme of `aspera-cli` uses fonts IBM Plex Sans and IBM Plex Mono.

On macOS, get them with `brew`:

```bash
brew install rpm2cpio qpdf exiftool pandoc texlive
brew install --cask wkhtmltopdf drawio font-ibm-plex-sans font-ibm-plex-mono
```

## Usage

The `Rakefile` requires these environment variables for any task (including `rake -T`):

```bash
export ASPERA_CLI_HOME=<path to aspera-cli repo>
export GFM2PDF_HOME=<path to gfm2pdf-toolchain repo>
export VERSION=4.1.6
```

`VERSION` is the Orchestrator version: it selects the build folder `build/<VERSION>` and appears in document titles.

Extract the RPM once per version (the RPM is not in this repository, place it in folder `private`), then generate the plugin documents:

```bash
export RPM=private/ibm-aspera-orchestrator-4.1.5.1917-1df786b.x86_64.rpm
rake extract_rpm
rake
```

`rake` (task `pdf`) generates the plugin manual (Markdown and PDF), the plugin list and the banner.

Other documents:

```bash
rake doc:template_reference
rake doc:plugin_specs
rake doc:diagrams
rake doc:guide
rake doc:authoring
rake doc:portlets
```

`doc:plugin_specs` generates `plugins.yml`, for tools and AI assistants: for each plugin, the template attributes (label, allowed values, defaults) and the inputs and outputs, with the template settings they depend on.
It reads the edit form of each plugin, and calls methods `inputs_spec` and `outputs_spec` of the plugin on templates with different settings (`lib/plugin_probe.rb`, run in its own process: about 2 minutes).
It needs the library files extracted by `extract_rpm`: re-run `extract_rpm` if `build/<VERSION>/src/lib` contains only `action_tools.rb` and `actions_helper.rb`.
Its intermediate result is `build/<VERSION>/out/plugin_probe.json`, generated again when the `actions` folder or the generator changes.

`doc:template_reference` reads the extracted `actions` folder, or the folder given in env var `ACTIONS_DIR` (for example an Orchestrator source tree).
`VERSION` must match that folder: it is the version shown in the title.
The reference can also be generated without `rake` and `aspera-cli`:

```bash
ruby lib/action_template_reference.rb <actions_dir> docs/action-template-reference.md <version>
```

`doc:api_check` compares the REST API of the extracted Orchestrator (`config/routes.rb` and `ApiController`) with its OpenAPI description, and prints a report in Markdown: endpoints missing or not implemented, HTTP methods, endpoints routed only with an id in the path, default response format, and parameters read by the source and not declared, or declared and not read.
The OpenAPI file is the one of a clone of [aspera-api-examples](https://github.com/laurent-martin/aspera-api-examples) next to this repository, or the file given in env var `OPENAPI`.
It needs the RPM extract of `extract_rpm` (`build/<VERSION>/rpmout`).

```bash
rake doc:api_check
ruby lib/api_check.rb build/<VERSION>/rpmout/opt/aspera/orchestrator <openapi.yaml>
```

`rake -T` lists all tasks.
