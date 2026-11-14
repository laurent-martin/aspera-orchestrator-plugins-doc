# Rails runner script (see tools/figures/README.md): objects of the server used by the workflows of the practices guide
# that are not made by a figure recipe. Creates only what is missing.
# (Pool Transcoders and queue Transcoding: recipes create-resource-pool and queue-auto-purge.)
user = User.find_by!(login: 'admin')

# Queue of Pattern - high volume 1 and 2: no auto-purge (the item is not tied to the work order that queued it)
# Groups Administrator (1) and Scheduler (5), like the queue Transcoding
if ManagedQueue.header('Bulk transcoding')
  puts 'queue Bulk transcoding exists'
else
  queue = ManagedQueue.create_queue('Bulk transcoding', {users: [], groups: [1, 5]}, 'Files of /data/ingest/bulk/ waiting for a transcoder')
  queue.update!(displayed_name: 'Bulk transcoding')
  puts "queue Bulk transcoding: #{queue.id}"
end

# Dashboard page Transcoding of user admin: pool Transcoders (Managed Load Utilization Monitor) above queue Transcoding
# (Queue Manager), both with controls. Same records as the dashboard editor: page, vertical split, portlet selected and
# configured in each part.
if Frame.exists?(name: 'Transcoding', parent: nil, user_id: user.id)
  puts 'dashboard Transcoding exists'
else
  page = Frame.create!(name: 'Transcoding', description: 'Pool and queue of Asset ingest - L2 transcoding', user_id: user.id, active: true)
  parts = [
    ['Managed Load Utilization Monitor', {'refresh' => '10', 'resource_pool' => 'Transcoders__a', 'control' => 'true'}],
    ['Queue Manager', {'refresh' => '10', 'queue_id' => 'Transcoding', 'control' => 'true', 'show_priority' => 'true', 'show_weight' => 'true'}]
  ].map do |portlet, parameters|
    part = Frame.create!(parent: page.id, user_id: user.id, border: 1)
    part.select(portlet)
    part.link_parameters = MultiType.convert_to_string_hash(parameters)
    part.adjust_link
    part.save!
    part
  end
  page.update!(horizontal: false, sub_frames: parts.map(&:id).join(','), sub_division: '40%,60%')
  Frame.re_rank(user.id)
  puts "dashboard Transcoding: frame #{page.id}"
end

# Journal book of Pattern - journals and alerts (the import of a workflow creates only the books of inline journals)
if JournalBook.find_by(name: 'Media ingest')
  puts 'journal book Media ingest exists'
else
  book = JournalBook.create!(name: 'Media ingest', description: 'Media files checked by Pattern - journals and alerts', active: true)
  puts "journal book Media ingest: #{book.id}"
end
