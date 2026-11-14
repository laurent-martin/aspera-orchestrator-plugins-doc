# Figures

Screenshots of the documentation are made on a running Orchestrator, from workflows kept in this folder, so that they can be made again on a new version.

| Path | Content |
|------|---------|
| `wfgen.rb` | Generates a workflow file (`.yml`, plain format) from a compact spec (`.rb`), and optionally imports it. |
| `capture.js` | Logs in to the web UI with a headless Chrome, runs a recipe, and saves the screenshot. |
| `practices/*.rb`, `practices/*.yml` | Workflows of the Workflow development practices chapter of the [Development Guide](../../docs/orchestrator-development-guide.md): spec and generated file. |
| `practices/shots.js` | One recipe per figure of that guide. |

Screenshots are saved in `docs/images/practices/<version>/<figure>.png`, where `<version>` is the version shown in the footer of the web UI.
The full version and the recipe are written in the PNG metadata: `exiftool -PNG:Software -PNG:Source <file>`.

## Requirements

- `ascli` with a default `orchestrator` preset (`ASCLI` to use another path), and Google Chrome.
- `exiftool`.
- `npm install` in this folder (installs `playwright-core`).
- Web UI credentials: preset `ORCH_PRESET` of the `ascli` configuration (name of an `orchestrator` preset with `url`, `username` and `password`), or `ORCH_URL`, `ORCH_USER`, `ORCH_PASSWORD`.

## Deploy the workflows

Workflows refer to each other by name: deploy them in the order of the table below (called workflows first).

```shell
export ORCH_FOLDER_ID=<FOLDER_ID>    # folder of new workflows
export ORCH_SSH=root@<ORCHESTRATOR_HOST>   # to update an existing workflow
ruby tools/figures/wfgen.rb --deploy tools/figures/practices/asset-ingest-l2.rb
```

A new workflow is imported and published.
An existing workflow (same name) gets a new revision: the file is copied to the server and imported with `import_with_constraints`, then published.

A link can have another line style than Manhattan with a suffix, for example `'transcode:Error/bezier'` (`/bezier`, `/null`, `/fan`): use it only where the graph looks better, for example when a Manhattan line would cross a step.
The failed and error exits of a step have the same style: both Manhattan or both curves.

Variants (`variants:` in a spec, for example `no` and `yes`) are graphs of the same workflow, imported in order as successive revisions; the last one is published.
A recipe shows an older variant with `t.revision(name, back)`.
A graph that the designer refuses to save (for example a step fed by an OR and directly by another step) is drawn by mouse in the recipe (`deleteLink`, `drawLink`, `dropFromPalette`, `moveNode`), and not saved.

## Server setup

Some objects of the server are not made by a figure recipe: queue `Bulk transcoding`, dashboard page `Transcoding`, journal book `Media ingest`.
`practices/server-setup.rb` creates the missing ones (rails runner on the Orchestrator host):

```shell
scp tools/figures/practices/server-setup.rb root@<ORCHESTRATOR_HOST>:/tmp/
ssh root@<ORCHESTRATOR_HOST> 'cd /opt/aspera/orchestrator && sudo -u aspweb env PATH=<RUBY_BIN_DIR>:/usr/bin:/bin RAILS_ENV=production bin/rails runner /tmp/server-setup.rb'
```

`<RUBY_BIN_DIR>` is the folder of the Ruby of Orchestrator (for example `/opt/rbenv/versions/3.4.11/bin`): without it, `sudo` picks the system Ruby and the command fails.

Files of the server (copy them with `scp`, owner `aspweb`), in `practices/server/`, relative to the configuration folder `/opt/aspera/var/config/orchestrator/`:

- `user_inputs/_external_delivery.html.erb` → `actions_config/user_inputs/`: form of the task of Pattern - operator decision (its preview is a fixed external video, test-videos.co.uk).
- `workflow_start_views/_start_ID.html.erb` → `workflow_start_views/_start_<id>.html.erb`, with `ID` replaced by the id of Pattern - operator decision.

## Capture

```shell
node tools/figures/capture.js tools/figures/practices/shots.js <figure> [<figure>...]
```

Then change the link in the guide to `images/practices/<version>/<figure>.png`.

## Practices guide: workflows and figures

| Workflow | Spec | Figures |
|----------|------|---------|
| Asset ingest - L2 transcoding | `asset-ingest-l2.rb` (variants `legacy`, `fallback`, `current`) | `workflow-actions-templates` (global templates `Reserve transcoder`, `Release transcoder`), `change-action-template`, `load-manager-pattern`, `load-manager-config`, `queue-stager-config`, `expected-queued-item`, `resource-pool-view`, `resource-manager-legacy` (2 revisions before the last), `resource-fallback` (before the last); needs pool `Transcoders` and queue `Transcoding`: `create-resource-pool` and `queue-auto-purge` create them if missing (capture them first); `pool-fully-reserved` needs 4 running work orders (media files `/data/ingest/media/clip<N>.mp4`, `ascli orchestrator workflows start <id> @json:'{"media_file_path":"<file>"}'`) |
| Asset ingest - L1 processing | `asset-ingest-l1.rb` | `subworkflow-step`, `input-preprocessing`, `lookup-table-config`, `retry-tab`, `retry-settings` |
| Asset ingest | `asset-ingest.rb` | `watcher-keep-ongoing`, `launcher-in-fanout`, `naming-levels` (with L1 and L2), `input-mappings`, `map-outputs-carry-thru`; `workflow-monitor-config` creates the workflow monitor `Asset ingest watcher` if missing (it then keeps a work order running: create the empty watch folders `/data/ingest/partner_a`, `partner_b`, `studio` first), `monitors-view` |
| Pattern - first workflow | none: built by hand in the designer (steps in the book, section First workflow in the designer; step rename by right-click, output `message` of type `String/Text`, code `outputs['message'] = 'Hello'`), published, started from the list with **Start**; id 324 on the test server | `first-workflow-new` (cancelled dialog), `first-workflow-graph`, `first-workflow-step`, `first-workflow-work-order` (needs a `Complete` work order: click launch then **Start**, or `ascli orchestrator workflows start <id> @json:'{}'`) |
| Pattern - exclusive exits | `pattern-exclusive.rb` (variants `no`, `yes`) | `exclusive-no` (revision before the last), `exclusive-yes` |
| Pattern - bypass | `pattern-bypass.rb` | `bypass-yes`, `bypass-no` (drawn by mouse from the published graph, not saved: 4.1.6 refuses it) |
| Pattern - two ORs | `pattern-two-or.rb` | `two-or-yes`, `two-or-no` (drawn by mouse, not saved), `or-set-operator` |
| Pattern - filter | `pattern-filter.rb` (variants `loop`, `negated`, `size`) | `filter-workflow`, `filter-config`, `filter-negated` (revision before the last), `loop-back-no` (2 before the last) |
| Pattern - parallel branches | `pattern-parallel.rb` (variants `and`, `or`, `or2`) | `parallel-and`, `parallel-or`, `parallel-or-2-consolidate` |
| Pattern - fan-out | `pattern-fanout.rb` (variants `onestep_no`, `basic`, `or`) | `fanout-basic`, `fanout-one-step-no`, `fanout-or`, `fanout-execute-serial`, `funnel-in-config`, `fanout-work-order` (needs a run: files `/data/ingest/fanout/*.mxf`, then `ascli orchestrator workflows start <id> @json:'{}'`) |
| Pattern - timeouts | `pattern-timeouts.rb` (variants `cumulative`, `escalation`, `receipt`) | `cumulative-timeout`, `reminder-escalation`, `schedule-trigger-timeout`, `schedule-trigger-config` |
| Pattern - critical error | `pattern-critical-error.rb` | `error-or-critical-filter` |
| Pattern - high volume 1 (add to queue) | `pattern-high-volume-add.rb` | `two-workflows-add` (queue `Bulk transcoding`: `server-setup.rb`) |
| Pattern - high volume 2 (process queue) | `pattern-high-volume-process.rb` | `two-workflows-process` |
| Pattern - meaningful status | `pattern-meaningful-status.rb` | `custom-ruby-config`, `custom-ruby-code`, `workorder-metadata-config`, `exit-status-config`, `error-custom-messages`; runs (`ascli orchestrator workflows start <id> @json:'{"file_path":"/data/ingest/media/clip1.mp4"}'`, then `clip9.mp4`, missing): `workorder-label-list`, `work-orders-exit-messages` (also shows an Error work order: optional), `change-work-order-status` |
| Pattern - triggers | `pattern-triggers.rb` (variants `monitors`, `either`) | `trigger-start-end-monitors` (left part, revision before the last), `dependency-checker` (test runs: `first.xml`, `second.xml` or no file in `/data/ingest/dependency/`, then `ascli orchestrator workflows start <id> @json:'{}'`) |
| Pattern - services | `pattern-services.rb` | `remote-execution-config`, `file-generator-config`, `rest-start-check`, `rest-polling-stop` |
| Pattern - operator decision | `pattern-operator-decision.rb` | `user-input-config`; `user-input-form` (needs an open task: start the workflow with `media_file_path` = `/data/ingest/media/Big_Buck_Bunny_360_10s_1MB.mp4`; the recipe finds the task by this name, the file itself is not read), `direct-start-form`; server files in `practices/server/` |
| Pattern - journals and alerts | `pattern-journals-alerts.rb` | `journal-entry-config`, `alert-entry-config`; `journals-view` needs journal book `Media ingest` (`server-setup.rb`) and runs: `ascli orchestrator workflows start <id> @json:'{"file_path":"/data/ingest/media/clip1.mp4"}'`, then `clip2.mp4`, `clip9.mp4` (missing) |
| Pattern - inline validation | `pattern-inline-validation.rb` | `inline-validation-workflow` (test runs: `ascli orchestrator workflows start <id> @json:'{"File":"{\\"startstop\\":\\"start\\",\\"file\\":\\"<path>\\"}","File_path":"<path>"}'`: the hash parameter as a JSON string) |
| (dashboard page `Transcoding`) | `server-setup.rb` | `queue-and-tokens-portlet`: needs 6 running L2 work orders, 2 of them waiting in the queue: pause queue `Transcoding`, start them, wait for the 6 items, resume |
