# Asset ingest - L1 processing: processes one asset, described by an XML side file.
# Figures: see tools/figures/README.md
{
  name: 'Asset ingest - L1 processing',
  description: 'Processes one asset: reads its XML side file, waits for the media file, transcodes and encrypts it.',
  start: [160, 131], end: [1140, 129], fail: [1140, 291], error: [1140, 441],
  end_from: 'encrypt', fail_from: 'notify',
  params: [
    {id: 'p_xml', name: 'xml_file_path', type: 'string', value: '', runtime: true, at: [30, 230], link: 'start'}
  ],
  steps: [
    {id: 'parse', name: 'Parse metadata', type: 'CustomRuby', at: [270, 110], from: 'start',
     attrs: {mandatory_inputs: "{'xml_file_path'=>'string'}",
             typed_outputs: "{'media_file_name'=>'string','profile'=>'string'}",
             execute_code: <<~RUBY},
               # media file name and transcoding profile, from the XML side file
               xml = File.read(inputs['xml_file_path'])
               outputs['media_file_name'] = xml[%r{<file>(.*)</file>}, 1]
               outputs['profile'] = xml[%r{<profile>(.*)</profile>}, 1]
             RUBY
     inputs: {'xml_file_path' => [:param, 'xml_file_path']}},
    {id: 'wait', name: 'Wait for media file', type: 'LocalFileWatcher', at: [470, 110], from: 'parse',
     attrs: {directory: '/data/ingest/media/', remove_file: 0, trigger_type: 'none'},
     inputs: {'File_name' => [:output, 'parse', 'media_file_name', 'input_value = File.basename(input_value)']}},
    {id: 'targets', name: 'Target folders', type: 'SimpleParameterLookup', at: [470, 280], from: 'parse',
     attrs: {parameters_associations: "PROFILE:::TYPE:::DIR:::DO_QC\r\nHD*:::mp4:::/data/hd/:::yes\r\nSD*:::mp4:::/data/sd/:::no\r\n*:::mov:::/data/other/:::yes"},
     inputs: {'PROFILE' => [:output, 'parse', 'profile']}},
    {id: 'transcode', name: 'Asset transcoding', type: 'SubWorkflow', at: [700, 110], from: %w[wait targets],
     attrs: {workflow_id: wf_id('Asset ingest - L2 transcoding'), use_true_name: 1, use_workorder_status: 1},
     inputs: {'media_file_path' => [:output, 'wait', 'FileName']},
     carry: [%w[wait FileName]],
     # retries need a linked exit (here to "notify failure")
     # failure: unlimited attempts for 1 hour, every minute; error: 10 attempts, for 30 seconds, every 10 seconds (3 attempts)
     xml: '<Failed_attempts>0</Failed_attempts><Failed_retryFor>1</Failed_retryFor><Failed_retryForUnit>3600</Failed_retryForUnit>' \
          '<Failed_retryDelay>60</Failed_retryDelay><Error_attempts>10</Error_attempts><Error_retryFor>30</Error_retryFor>' \
          '<Error_retryForUnit>1</Error_retryForUnit><Error_retryDelay>10</Error_retryDelay>'},
    {id: 'encrypt', name: 'Encrypt Hi-Res', type: 'SymantecPgp', at: [920, 110], from: 'transcode',
     attrs: {operation: 'encrypt', gpg_mode: 1},
     inputs: {'source_file_path' => [:output, 'wait', 'FileName'], 'passphrase' => [:value, '<PASSPHRASE>'], 'execution_node' => [:value, 'localhost']}},
    {id: 'notify', name: 'notify failure', type: 'EmailNotification', at: [920, 280], or: [1, 800, 294],
     from: %w[transcode:Failed transcode:Error],
     attrs: {subject_line: 'Transcoding failed', destinations: '<OPERATOR_EMAIL>'}}
  ]
}
