# Workflow "Asset ingest - L2 transcoding". Adds the file to a queue, reserves a transcoder, transcodes, releases on every exit.
# Variants (successive revisions, the last one is published):
#   legacy:   the same pattern with ResourceManager (ad hoc pool: ResourceManager needs resources of capacity 1)
#   fallback: on failure of the reserved transcoder, transcodes on a spare; if the spare fails too: release, alert, Failed
#   current:  the published workflow, run by Asset ingest - L1 processing
# Figures: see tools/figures/README.md
enqueue = {id: 'enqueue', name: 'Add to queue', type: 'QueueStager', at: [270, 110], from: 'start',
           attrs: {operation: 'Add', queue_name: 'Transcoding', lifetime: 'WorkOrder', item_description: 'Transcoding <%= File.basename(media_file_path) %>'},
           inputs: {'Queued_item' => [:param, 'media_file_path'], 'media_file_path' => [:param, 'media_file_path']}}
reserve = {id: 'reserve', name: 'Reserve transcoder', type: 'LoadManager', at: [470, 110], from: 'enqueue', template: 'Reserve transcoder',
           # pool: the designer saves the pool name with the suffix __a (value of the select)
           attrs: {comments: 'Reserves a slot of the Transcoders pool, in queue order', manager_action: 'Reserve', is_adhoc: 0, pool_name: 'Transcoders__a',
                   allocation_policy: 'Fair Distribution', queue_id: '-RT-', allocation_label: 'Transcoding <%= File.basename(media_file_path) %>'},
           # queue at runtime: map the queue and the expected queued item to the outputs of the add step
           inputs: {'Queue' => [:output, 'enqueue', 'Queue_ID'], 'Expected_queued_item' => [:output, 'enqueue', 'Queued_item'],
                    'media_file_path' => [:param, 'media_file_path']}}
transcode = {id: 'transcode', name: 'Transcode', type: 'FfmpgTranscoding', at: [670, 110], from: 'reserve',
             attrs: {options: '-vf scale=1280:720 -c:v libx264', overwrite_output: 1},
             inputs: {'Input_file_path' => [:param, 'media_file_path'],
                      'Output_file_path' => [:param, 'media_file_path', "input_value = '/data/proxies/' + File.basename(input_value)"],
                      'Execution_node' => [:value, 'localhost']},
             carry: [%w[reserve Allocation_token]]}
release_ok = {id: 'release_ok', name: 'Release if OK', type: 'LoadManager', at: [920, 110], from: 'transcode', template: 'Release transcoder',
              attrs: {comments: 'Releases the slot of the Transcoders pool', manager_action: 'Release', is_adhoc: 0, pool_name: 'Transcoders__a'},
              inputs: {'Allocation_token_to_release' => [:output, 'reserve', 'Allocation_token']}}
release_nok = {id: 'release_nok', name: 'Release if not OK', type: 'LoadManager', at: [920, 280], from: %w[transcode:Failed transcode:Error], or: [1, 820, 294],
               template: 'Release transcoder',
               inputs: {'Allocation_token_to_release' => [:output, 'reserve', 'Allocation_token']}}
legacy_pool = {is_adhoc: 1, unique_id: 'Legacy transcoders', resource_list: 'transcoder1,transcoder2'}
{
  name: 'Asset ingest - L2 transcoding',
  description: 'Transcodes one media file, at most as many at a time as the Transcoders pool allows.',
  start: [160, 131], end: [1140, 129], fail: [1140, 299], error: [1140, 441],
  end_from: 'release_ok',
  fail_from: 'release_nok',
  params: [
    {id: 'p_media', name: 'media_file_path', type: 'string', value: '', runtime: true, at: [30, 230], link: 'start'}
  ],
  steps: [enqueue, reserve, transcode, release_ok, release_nok],
  variants: {
    legacy: {steps: [
      enqueue,
      {id: 'reserve', name: 'Wait for transcoder', type: 'ResourceManager', at: [470, 110], from: 'enqueue',
       attrs: legacy_pool.merge(operation: 'Reserve', queue_id: 'Transcoding'),
       inputs: {'Expected_queued_item' => [:output, 'enqueue', 'Queued_item']}},
      transcode.merge(carry: [%w[reserve Resource_ID]]),
      {id: 'release_ok', name: 'Release transcoder', type: 'ResourceManager', at: [920, 110], from: 'transcode',
       attrs: legacy_pool.merge(operation: 'Release by resource ID'),
       inputs: {'Resource_to_release' => [:output, 'reserve', 'Resource_ID']}},
      {id: 'release_nok', name: 'Release if errors', type: 'ResourceManager', at: [920, 280], from: %w[transcode:Failed transcode:Error], or: [1, 820, 294],
       attrs: legacy_pool.merge(operation: 'Release by resource ID'),
       inputs: {'Resource_to_release' => [:output, 'reserve', 'Resource_ID']}}
    ]},
    fallback: {
      end: [1550, 129], fail: [1550, 469], error: [1550, 600], fail_from: 'alert',
      steps: [
        enqueue, reserve,
        # on the reserved transcoder (remote node named like the resource)
        transcode.merge(inputs: transcode[:inputs].merge('Execution_node' => [:output, 'reserve', 'Resource_reserved'])),
        transcode.merge(id: 'spare', name: 'Transcode on spare', at: [860, 280], from: %w[transcode:Failed transcode:Error], or: [1, 760, 294]),
        release_ok.merge(at: [1110, 110], from: %w[transcode spare], or: [1, 1010, 124]),
        release_nok.merge(at: [1110, 450], from: %w[spare:Failed spare:Error], or: [1, 1010, 464]),
        {id: 'alert', name: 'Alert operators', type: 'EmailNotification', at: [1330, 450], from: 'release_nok',
         attrs: {subject_line: 'Transcoding failed on the reserved transcoder and on the spare', destinations: '<OPERATOR_EMAIL>'}}
      ]
    },
    current: {}
  }
}
