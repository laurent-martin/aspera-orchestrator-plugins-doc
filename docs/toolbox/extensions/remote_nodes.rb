# Toolbox extension: remote nodes (no REST API exists for them).
# Install as <config_dir>/toolbox/remote_nodes.rb on the Orchestrator server.
# Secrets (password, certificate_passphrase, orch_api_key, node_attributes) are never returned.
# The password argument of create/update is stored encrypted, like the web UI does (OrchCipher).
# Prefer leaving it out and setting it in the UI: arguments are visible in the work order.

def rn_fields
  %w[name displayed_name address secondary_address port fasp_port keepalive_port login node_type os
               comments balancing_type ports_to_scan aspera_dir orchestrator_dir ruby_executable
               certificate_location]
end

def rn_h(n)
  n.attributes.slice('id', 'name', 'displayed_name', 'node_type', 'address', 'secondary_address', 'port', 'fasp_port',
                     'keepalive_port', 'login', 'os', 'platform', 'balancing_type', 'comments', 'updated_at')
end

def rn_find(a)
  if a['id'].present?
    RemoteNode.find(a['id'].to_i)
  elsif a['name'].present?
    RemoteNode.find_by_name(a['name'])
  else
    raise ArgumentError, 'Missing argument: id or name'
  end
end

def rn_values(a)
  vals = a.slice(*rn_fields).compact
  if vals.key?('node_type') && !RemoteNode::NODE_TYPES.include?(vals['node_type'])
    raise ArgumentError, "node_type must be one of: #{RemoteNode::NODE_TYPES.join(', ')}"
  end
  if vals.key?('os') && !RemoteNode::OS_LIST.include?(vals['os'])
    raise ArgumentError, "os must be one of: #{RemoteNode::OS_LIST.join(', ')}"
  end
  vals['password'] = OrchCipher.encrypt(a['password']) if a['password'].present?
  vals['certificate_passphrase'] = OrchCipher.encrypt(a['certificate_passphrase']) if a['certificate_passphrase'].present?
  vals
end

function('list_remote_nodes', '[name] [node_type]: list remote nodes (without secrets)') do |a|
  scope = RemoteNode.order(:id)
  scope = scope.where(name: a['name']) if a['name'].present?
  scope = scope.where(node_type: a['node_type']) if a['node_type'].present?
  scope.map { |n| rn_h(n) }
end

function('get_remote_node', 'id or name: one remote node (without secrets), with the number of workflows, actions and monitors that use it') do |a|
  n = rn_find(a)
  wf, actions, monitors = n.find_dependencies(:all)
  rn_h(n).merge('used_by' => { 'workflows' => wf.size, 'actions' => actions.size,
                               'script_monitors' => monitors[:remote_script].size, 'folder_monitors' => monitors[:folder].size })
end

function('create_remote_node', 'name address [node_type=SSH|IP|"Aspera FASP"|"Aspera Orchestrator"] [port fasp_port login os password comments ...]: create a remote node, or return the existing one with this name (created=false)') do |a|
  need(a, 'name', 'address')
  existing = RemoteNode.where(name: a['name']).first
  if existing
    rn_h(existing).merge('created' => false)
  else
    n = RemoteNode.new
    rn_values(a).each { |k, v| n[k] = v }
    raise "Cannot create remote node: #{n.errors.full_messages.join(', ')}" unless n.save
    Entitlement.set_permission({ user: (a['created_by'] || 1).to_i }, n, :edit)
    rn_h(n).merge('created' => true)
  end
end

function('update_remote_node', 'id or name, plus the fields to change (name address node_type port fasp_port login os password comments ...)') do |a|
  n = rn_find(a)
  vals = rn_values(a.except('id'))
  vals['name'] = a['new_name'] if a['new_name'].present?
  raise ArgumentError, 'Nothing to update' if vals.empty?
  raise "Cannot update remote node: #{n.errors.full_messages.join(', ')}" unless n.update(vals)
  rn_h(n.reload)
end

function('delete_remote_node', 'id or name, confirm=true: delete a remote node. Refused if workflows, actions or monitors use it') do |a|
  raise ArgumentError, 'delete_remote_node needs confirm=true' unless a['confirm'].to_s == 'true'
  n = rn_find(a)
  wf, actions, monitors = n.find_dependencies(:all)
  deps = []
  deps << "#{wf.size} workflow(s)" if wf.size > 0
  deps << "#{actions.size} action(s)" if actions.size > 0
  deps << "#{monitors[:remote_script].size} script monitor(s)" if monitors[:remote_script].size > 0
  deps << "#{monitors[:folder].size} folder monitor(s)" if monitors[:folder].size > 0
  raise "Remote node #{n.name} is used by #{deps.join(', ')}: it cannot be deleted" unless deps.empty?
  info = rn_h(n)
  n.destroy
  info.merge('deleted' => true)
end

function('test_remote_node', 'id or name: test the connection (FASP node API for "Aspera FASP", SSH otherwise)') do |a|
  n = rn_find(a)
  ok = n.node_type == RemoteNode::NODE_FASP ? n.test_fasp_connectivity : n.test_ssh_connectivity
  { 'id' => n.id, 'name' => n.name, 'node_type' => n.node_type, 'connected' => ok == true }
end
