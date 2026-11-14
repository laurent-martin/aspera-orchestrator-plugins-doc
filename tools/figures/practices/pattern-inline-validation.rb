# Pattern - inline validation: called by an Aspera transfer server for each file (aspera.conf validation_uri set to
# <orchestrator>/aspera/orchestrator/external_calls/validate?id=<id of this workflow>), at start, at the threshold and at the end.
# Orchestrator 4.1.6 starts a work order with runtime parameters File (the JSON of ascp, startstop: start, running, stop)
# and File_path, and returns its status message: the ExitStatus of each rejection is the message shown to the user.
# Start: file type; threshold: video codec of the first bytes (ffprobe); end: antivirus (ClamAV, not installed on the test server).
# Figures: see tools/figures/README.md
event = ->(value) { {command: "inputs['File']['startstop'] == '#{value}'\n", mandatory_inputs: "{'File'=>'hash'}"} }
{
  name: 'Pattern - inline validation',
  description: 'Validates each file of an Aspera transfer: its type at start, its video codec at the threshold, viruses at the end.',
  # accepts of rows 2 and 3, rejects of rows 1 and 3 as curves: Manhattan lines would cross the steps
  start: [160, 81], end: [1270, 79], fail: [1270, 469], error: [1270, 700],
  end_from: ['check_type', 'check_format/bezier', 'scan/bezier'], end_or: [1, 1180, 74],
  fail_from: ['reject_type/bezier', 'reject_format', 'reject_virus/bezier'], fail_or: [1, 1180, 464],
  params: [
    {id: 'p_file', name: 'File', type: 'hash', value: '', runtime: true, at: [30, 180], link: 'start'},
    {id: 'p_path', name: 'File_path', type: 'string', value: '', runtime: true, at: [30, 280], link: 'start'}
  ],
  steps: [
    {id: 'is_start', name: 'Transfer start?', type: 'Filter', at: [270, 60], from: 'start',
     attrs: event.call('start'), inputs: {'File' => [:param, 'File']}},
    {id: 'check_type', name: 'Accepted file type?', type: 'Filter', at: [470, 60], from: 'is_start',
     attrs: {command: "%w[.mp4 .mov .mxf].include?(File.extname(inputs['File_path']).downcase)\n", mandatory_inputs: "{'File_path'=>'string'}"},
     inputs: {'File_path' => [:param, 'File_path']}},
    {id: 'reject_type', name: 'Reject file type', type: 'ExitStatus', at: [670, 190], from: 'check_type:Failed',
     attrs: {failed_status: 'File type <%= File.extname(File_path) %> not accepted: send MP4, MOV or MXF files'},
     inputs: {'File_path' => [:param, 'File_path']}},
    {id: 'is_threshold', name: 'Threshold?', type: 'Filter', at: [270, 320], from: 'is_start:Failed',
     attrs: event.call('running'), inputs: {'File' => [:param, 'File']}},
    {id: 'probe', name: 'Probe first bytes', type: 'FfprobeInfo', at: [470, 320], from: 'is_threshold',
     attrs: {execution_node: 'localhost', options: '-v error -select_streams v:0 -show_entries stream=codec_name', input_file_path: '<%= File_path %>'},
     inputs: {'File_path' => [:param, 'File_path']}},
    {id: 'check_format', name: 'Accepted video codec?', type: 'Filter', at: [670, 320], from: 'probe',
     attrs: {command: "inputs['Report'].include?('codec_name=h264')\n", mandatory_inputs: "{'Report'=>'string'}"},
     inputs: {'Report' => [:output, 'probe', 'Report']}},
    {id: 'reject_format', name: 'Reject video codec', type: 'ExitStatus', at: [870, 450], from: 'check_format:Failed',
     attrs: {failed_status: 'Video codec not accepted: send H.264 video'}},
    {id: 'scan', name: 'Antivirus scan', type: 'ClamavCheck', at: [470, 580], from: 'is_threshold:Failed',
     attrs: {execution_node: 'localhost', fail_on_infection: true, single_file_mode: true, input_file_path: '<%= File_path %>'},
     inputs: {'File_path' => [:param, 'File_path']}},
    {id: 'reject_virus', name: 'Reject infected file', type: 'ExitStatus', at: [670, 710], from: 'scan:Failed',
     attrs: {failed_status: 'File <%= File.basename(File_path) %> rejected: a virus was found'},
     inputs: {'File_path' => [:param, 'File_path']}}
  ]
}
