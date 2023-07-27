# Generate HTML and PDF plugin doc for IBM Aspera Orchestrator

The main tool is `generateAODoc.rb`.
It can be used standalone to generate HTML only.
For PDF, use the Makefile.

The Makefile provides ways to get Orchestrator sources in case there is no local install.

The main target (`all`) generates files under: `./build/current/out`

if ./build/current/out/doc.html does not exist, it is generated from sources under: ./build/current/src

## Prerequisites

The Makefile uses the tool: [wkhtmltopd](https://wkhtmltopdf.org/)

on mac, get it from "brew":

```bash
brew install wkhtmltopdf
```

## 1- with local Orchestrator install

```bash
mkdir -p build/current/out
./generateAODoc.rb 4.0.0 /opt/aspera/orchestrator build/current/out
make
```

## 2- with Orchestrator RPM

```bash
export RPM=private/aspera-orchestrator-4.0.1.2b9681-0.x86_64.rpm
export VERSION=$(echo $RPM|sed -n -Ee 's/.*orchestrator-([0-9]*\.[0-9]*\.[0-9]*)\..*/\1/p')
make extract_rpm
make
```

## 3- with remote Orchestrator install with HSTS

It uses ssh and ascp to list and retrieve files.
requires ~/.ssh/id_rsa to be allowed on the remote node

```bash
REMOTE_USER=laurent REMOTE_HOST=testchris5.aspera.cloud ASCP=ascp KEYS="-i $HOME/.ssh/id_rsa" make extract_remote
make
```
