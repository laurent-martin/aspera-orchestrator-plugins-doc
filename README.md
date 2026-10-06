# IBM Aspera Orchestrator plugin documentation

This repository generates the plugin (action) documentation for IBM Aspera Orchestrator, and holds the guides for plugin developers and workflow authors.

The plugin documentation is generated from the Orchestrator RPM: the `actions` folder and two library files are extracted from it, then the metadata, source and help page of each plugin are rendered to HTML, Markdown and PDF.

## Documents

Generated documents and guides are in folder `docs`:

| Document                                                                                       | Content                                                       | Rake task                     |
|------------------------------------------------------------------------------------------------|---------------------------------------------------------------|-------------------------------|
| [`Orchestrator_Plugin_Manual.md`](docs/Orchestrator_Plugin_Manual.md) and `.pdf`               | Help page of each plugin, by category                         | `md_manual`, `pdf_manual`     |
| [`Orchestrator_Plugin_List.pdf`](docs/Orchestrator_Plugin_List.pdf)                            | Table of plugins: icon, name, version, description            | `pdf_list`                    |
| [`Orchestrator_Plugin_Banner.pdf`](docs/Orchestrator_Plugin_Banner.pdf)                        | Icons and names of plugins, by category (landscape)           | `pdf_banner`                  |
| [`action-template-reference.md`](docs/action-template-reference.md)                            | Template attributes, inputs and outputs of each action plugin | `doc:template_reference`      |
| [`plugin-development-guide.md`](docs/plugin-development-guide.md) and `.pdf`                   | How to develop a plugin                                       | `doc:guide` (PDF only)        |
| [`workflow-authoring-guide.md`](docs/workflow-authoring-guide.md) and `.pdf`                   | How to write workflows                                        | `doc:authoring` (PDF only)    |

The two guides are written by hand (the task generates their PDF), the other documents are generated: do not edit them.

Intermediate HTML files (`rake html`) are in `build/<VERSION>/out`.

## Prerequisites

- Ruby
- A clone of the `aspera-cli` repository, <https://github.com/IBM/aspera-cli>, with its gems installed (`bundle install` in that folder).
  Its build library is used: logging, PDF generation from Markdown with `pandoc`.
- Tools:

| Tool          | Used for                                          |
|---------------|---------------------------------------------------|
| `rpm2cpio`    | Extract the RPM (`extract_rpm`)                   |
| `wkhtmltopdf` | Generate the plugin list and banner PDF from HTML |
| `qpdf`        | Make PDF files reproducible (document ID)         |
| `exiftool`    | Make PDF files reproducible (dates)               |
| `pandoc`      | Convert HTML to Markdown, and Markdown to PDF     |
| `lualatex`    | PDF engine of `pandoc`                            |

`pandoc` PDF uses fonts IBM Plex Sans and IBM Plex Mono.

On macOS, get them with `brew`:

```bash
brew install rpm2cpio qpdf exiftool pandoc texlive
brew install --cask wkhtmltopdf font-ibm-plex-sans font-ibm-plex-mono
```

## Usage

The `Rakefile` requires these environment variables for any task (including `rake -T`):

```bash
export DIR_ASPERA_CLI=<path to aspera-cli repo>
export DIR_PANDOC=$DIR_ASPERA_CLI/build/doc/pandoc/
export RUBYLIB=$DIR_ASPERA_CLI/lib
export VERSION=4.1.5
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
rake doc:guide
rake doc:authoring
```

`doc:template_reference` reads the extracted `actions` folder, or the folder given in env var `ACTIONS_DIR` (for example an Orchestrator source tree).
`VERSION` must match that folder: it is the version shown in the title.
The reference can also be generated without `rake` and `aspera-cli`:

```bash
ruby lib/action_template_reference.rb <actions_dir> docs/action-template-reference.md <version>
```

`rake -T` lists all tasks.
