# Example Toolbox extension: install as <config_dir>/toolbox/folder_tree.rb on the Orchestrator server.
# Runs inside the "Admin - Orchestrator toolbox" step: `function` registers a function,
# and the helpers folder_h, workflow_h, root_id, need, parent_filter are available.
function('folder_tree', '[root_id]: folders as a nested tree, with the workflows of each') do |a|
  build = lambda do |folder|
    h = folder_h(folder)
    h['children'] = Folder.where(is_in_folder: folder.id).order(:id).map { |c| build.call(c) }
    h['workflow_names'] = Workflow.where(folder_id: folder.id).order(:id).pluck(:name)
    h
  end
  roots = a['root_id'] ? Folder.where(id: a['root_id'].to_i) : Folder.where(is_in_folder: [nil, 0]).order(:id)
  roots.map { |f| build.call(f) }
end
