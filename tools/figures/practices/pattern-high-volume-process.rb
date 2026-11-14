# Pattern - high volume 2 (process queue): the load manager with Continue monitoring (keep ongoing) takes the file at the top
# of the queue Bulk transcoding each time a slot of the pool Transcoders is free, and starts a work order for it.
# No expected queued item: the file is not tied to the work order that queued it (Pattern - high volume 1).
# Figures: see tools/figures/README.md
{
  name: 'Pattern - high volume 2 (process queue)',
  description: 'For each file of the queue Bulk transcoding, when a slot of the pool Transcoders is free: transcodes it and releases the slot.',
  start: [60, 131], end: [810, 129], fail: [810, 299], error: [810, 441],
  end_from: 'release_ok', fail_from: 'release_nok',
  steps: [
    {id: 'take', name: 'Take next file', type: 'LoadManager', at: [170, 110], from: 'start',
     attrs: {comments: 'Continue monitoring: a new work order for each file taken from the queue', manager_action: 'Reserve', is_adhoc: 0,
             keep_ongoing: 1, pool_name: 'Transcoders__a', allocation_policy: 'Fair Distribution', queue_id: 'Bulk transcoding'}},
    {id: 'transcode', name: 'Transcode', type: 'FfmpgTranscoding', at: [380, 110], from: 'take',
     attrs: {options: '-vf scale=1280:720 -c:v libx264', overwrite_output: 1},
     inputs: {'Input_file_path' => [:output, 'take', 'Queued_item'],
              'Output_file_path' => [:output, 'take', 'Queued_item', "input_value = '/data/proxies/' + File.basename(input_value)"],
              'Execution_node' => [:value, 'localhost']},
     carry: [%w[take Allocation_token]]},
    {id: 'release_ok', name: 'Release if OK', type: 'LoadManager', at: [590, 110], from: 'transcode',
     attrs: {manager_action: 'Release', is_adhoc: 0, pool_name: 'Transcoders__a'},
     inputs: {'Allocation_token_to_release' => [:output, 'take', 'Allocation_token']}},
    {id: 'release_nok', name: 'Release if not OK', type: 'LoadManager', at: [590, 280], from: %w[transcode:Failed transcode:Error], or: [1, 490, 294],
     attrs: {manager_action: 'Release', is_adhoc: 0, pool_name: 'Transcoders__a'},
     inputs: {'Allocation_token_to_release' => [:output, 'take', 'Allocation_token']}}
  ]
}
