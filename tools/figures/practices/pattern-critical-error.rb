# Workflow "Pattern - critical error": called as a sub-workflow; decides whether an error is critical (stop) or not (the caller retries).
{
  name: 'Pattern - critical error',
  description: 'Sub-workflow: ends Error on a critical error (the caller stops), Failed otherwise (the caller retries).',
  start: [160, 131], end: [800, 129], fail: [800, 469], error: [800, 299],
  end_from: 'transcode', error_from: 'critical', fail_from: 'critical:Failed',
  params: [{id: 'p_media', name: 'media_file_path', type: 'string', value: '', runtime: true, at: [30, 230], link: 'start'}],
  notes: [{text: "stop on error\nretry on failure", at: [980, 280]}],
  steps: [
    {id: 'transcode', name: 'Transcode', type: 'FfmpgTranscoding', at: [300, 110], from: 'start',
     attrs: {options: '-vf scale=1280:720 -c:v libx264', overwrite_output: 1},
     inputs: {'Input_file_path' => [:param, 'media_file_path'], 'Output_file_path' => [:value, '/data/proxies/'], 'Execution_node' => [:value, 'localhost']}},
    {id: 'critical', name: 'if critical error', type: 'Filter', at: [540, 280], or: [1, 420, 294],
     from: %w[transcode:Failed transcode:Error],
     attrs: {command: "# critical: the transcoder reported an error, not a failure of the file\ninputs['transcode_info']['step_status'] == 'Error'\n",
             mandatory_inputs: "{'transcode_info'=>'hash'}"},
     inputs: {'transcode_info' => [:output, 'transcode', 'Step_information']}}
  ]
}
