---
name: orchestrator-toolbox
description: Administer an IBM Aspera Orchestrator for what its REST API cannot do - folders (create, list, rename, move, delete), moving and deleting workflows, remote nodes (list, get, create, update, delete, test), portlets (list, install) - through the "Admin - Orchestrator toolbox" workflow, started with ascli. Use when asked to organize workflows in folders, delete a workflow, or manage remote nodes, or to add such a missing administration function.
---

# Orchestrator toolbox

The Orchestrator REST API has no endpoint for folders, remote nodes, workflow deletion or moving a workflow.
The workflow `Admin - Orchestrator toolbox` ([orchestrator-toolbox.yml](orchestrator-toolbox.yml)) fills the gap:
it has one CustomRuby step that runs inside the Orchestrator process (full ActiveRecord access) and dispatches to a named function.
New functions are Ruby files on the server: the workflow itself never changes.

Run it as `SYSTEM`: it can delete anything. Restrict who can start it.

## Install

1. Import and publish the workflow (put it in an admin folder), with `ascli`:

   ```bash
   ascli orchestrator workflows import @file:orchestrator-toolbox.yml @json:'{"folder_id":<FOLDER_ID>}'
   ascli orchestrator workflows publish <WORKFLOW_ID>
   ```

   (`--preset <PRESET>` selects the Orchestrator; find the ID with `ascli orchestrator workflows list`.)
2. Optional extensions: copy the files of [extensions/](extensions/) to `<config_dir>/toolbox/` on the server
   (`/opt/aspera/var/config/orchestrator/toolbox/`, readable by the Orchestrator user, for example `aspweb`).
   They are loaded at each run, in alphabetical order.

## Call a function

Runtime parameters: `function` (string) and `args` (a native hash, optional). The result is the JSON text of output `Toolbox:result`.

```bash
ascli orchestrator workflows start <WORKFLOW_ID> @json:'{"function":"list_folders","args":{"parent_id":0}}' @json:'{"step":"Toolbox","variable":"result"}'
```

Start with `list_functions` to see what the server offers (extensions included) and any extension load errors.
A failure sets the step to `Failed`, with a JSON `error` in the result.

| Function | Arguments | Effect |
| --- | --- | --- |
| `list_functions` | | Functions and extension load errors |
| `list_folders` | `[parent_id] [name]` | Folders (`parent_id` 0: root) |
| `create_folder` | `name [parent_id] [comments]` | Create, or return the existing one (`created`: false) |
| `rename_folder` | `id name` | Rename |
| `move_folder` | `id parent_id` | Move (0: root) |
| `delete_folder` | `id [with_content confirm]` | Content moves to the parent; `with_content=true` deletes it and needs `confirm=true` |
| `list_workflows` | `[folder_id] [name]` | Workflows |
| `move_workflow` | `id or ids, folder_id` | Move to a folder (0: root) |
| `delete_workflow` | `id confirm=true` | Delete with its work orders; refused if some are running |
| `list_remote_nodes`, `get_remote_node`, `create_remote_node`, `update_remote_node`, `delete_remote_node`, `test_remote_node` | see `list_functions` | Remote nodes (extension [remote_nodes.rb](extensions/remote_nodes.rb)); secrets are never returned |
| `list_portlets`, `install_portlet` | `name src [confirm]` | Portlets (extension [portlets.rb](extensions/portlets.rb)): `src` is a staged folder on the server; an installed portlet is replaced only with `confirm=true`, after a backup in `<config_dir>/portlets_backup`; then restart Orchestrator (`orchestrator restart`) |
| `folder_tree` | `[root_id]` | Nested folders and workflows (example extension) |

## Rules for the assistant

- Read functions (`list_*`, `get_*`, `test_*`, `folder_tree`) can be run freely.
- Ask the user before any deletion (`delete_*`) or `with_content`, and show the target (id and name) first.
  The functions require `confirm=true`: never set it without the user's agreement.
- Prefer `create_*` (idempotent) to check-then-create.
- Do not pass passwords in `args`: they are visible in the work order. Set them in the Orchestrator UI.
- Update a published workflow without deleting it: import a copy, `import_with_constraints` with `add_as_revision`, `publish`, then `delete_workflow` on the copy.

## Add a function

Write `<config_dir>/toolbox/<name>.rb`: the file is evaluated in the toolbox, which provides:

- `function(name, description) { |args| ... }`: register a function; `args` is a Hash with String keys; return a JSON-serializable value; raise to fail.
- Helpers: `need(args, 'key', ...)` (required arguments), `root_id(v)` (0 or empty is the root), `parent_filter(parent)`, `folder_h(folder)`, `workflow_h(workflow)`.
- Any Orchestrator model: `Folder`, `Workflow`, `RemoteNode`, `Entitlement`, ...

```ruby
function('count_workflows', '[folder_id]: number of workflows in a folder') do |a|
  need(a, 'folder_id')
  { 'count' => Workflow.where(folder_id: a['folder_id'].to_i).count }
end
```

Rules: no secrets in the file or in results; destructive functions need `confirm=true`; be idempotent when possible;
a syntax error only disables that file (see `load_errors` in `list_functions`). Test with `list_functions`, then the function.

For the layout and format of workflows, see [../orchestrator-development-guide.md](../orchestrator-development-guide.md).
