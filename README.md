# Generate HTML and PDF plugin doc for IBM Aspera Orchestrator

This tool generates Plugin documentation for IBM Aspera Orchestrator.

It extracts relevant files from the RPM, and generate the Markdown and PDF documentation.

## Prerequisites

The `Rakefile` uses the tool: [`wkhtmltopdf`](https://wkhtmltopdf.org/)

on macOS, get it from `brew`:

```bash
brew install wkhtmltopdf
```

It also uses tools from the `aspera-cli` repository: <https://github.com/IBM/aspera-CLI>

## Usage

```bash
export DIR_ASPERA_CLI=<path to aspera-cli repo>
export DIR_PANDOC=$DIR_ASPERA_CLI/build/doc/pandoc/
export RPM=private/ibm-aspera-orchestrator-4.1.5.1917-1df786b.x86_64.rpm
export VERSION=4.1.5
rake extract_rpm
rake
```
