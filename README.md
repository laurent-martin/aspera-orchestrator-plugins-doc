# Generate HTML and PDF plugin doc for IBM Aspera Orchestrator

This tool generates Plugin documentation for IBM Aspera Orchestrator.

It uses the `actions` folder where plugins live.

The orchestrator RPM can be provided, or a copy of the `actions` folder.

To generate the documentation:

```bash
rake
```

## Prerequisites

The Rakefile uses the tool: [wkhtmltopd](https://wkhtmltopdf.org/)

on macOS, get it from `brew`:

```bash
brew install wkhtmltopdf
```

## With Orchestrator RPM

```bash
export RPM=private/aspera-orchestrator-4.0.1.2b9681-0.x86_64.rpm
export VERSION=$(echo $RPM|sed -n -Ee 's/.*orchestrator-([0-9]*\.[0-9]*\.[0-9]*)\..*/\1/p')
rake extract_rpm
rake
```

## With remote Orchestrator install with HSTS

It uses `ssh` and `ascp` to list and retrieve files.
Requires `~/.ssh/id_rsa` to be allowed on the remote node.

```bash
REMOTE_USER=laurent REMOTE_HOST=testchris5.aspera.cloud ASCP=ascp KEYS="-i $HOME/.ssh/id_rsa" rake extract_remote
rake
```
