# Pattern - meaningful status: the work order label tells which file is processed, and an ExitStatus before each end
# tells the outcome in the work order list. The check step (CustomRuby) returns a status with a message.
# Runs: one with an existing file (Complete), one with a missing file (Failed), see tools/figures/README.md.
# Figures: see tools/figures/README.md
{
  name: 'Pattern - meaningful status',
  description: 'Labels the work order with the file name, checks the file, and sets the status message of each end.',
  start: [160, 131], end: [890, 129], fail: [890, 299], error: [890, 469],
  end_from: 'exit_ok', fail_from: 'exit_failed', error_from: 'exit_error',
  params: [
    {id: 'p_file', name: 'file_path', type: 'string', value: '', runtime: true, at: [30, 230], link: 'start'}
  ],
  steps: [
    {id: 'label', name: 'Label work order', type: 'WorkOrderMetaData', at: [270, 110], from: 'start',
     attrs: {label: 'Processing <%= File.basename(file_path) %>'},
     inputs: {'file_path' => [:param, 'file_path']}},
    {id: 'check', name: 'Check media file', type: 'CustomRuby', at: [470, 110], from: 'label',
     # short lines: the code editor of figure custom-ruby-code is narrow
     attrs: {mandatory_inputs: "{'file_path'=>'string'}", typed_outputs: "{'file_size'=>'int'}", execute_code: <<~'RUBY'},
               # size of the media file, or failure with a message
               path = inputs['file_path']
               unless File.exist?(path)
                 return STATUS_FAILED, "File #{File.basename(path)} not found", outputs
               end
               outputs['file_size'] = File.size(path)
             RUBY
     inputs: {'file_path' => [:param, 'file_path']}},
    {id: 'exit_ok', name: 'Exit if OK', type: 'ExitStatus', at: [670, 110], from: 'check',
     attrs: {complete_status: 'Processed <%= File.basename(file_path) %> (<%= file_size %> bytes)'},
     # a placeholder makes a string input: an int output mapped to it fails (Invalid inputs ... expected to be of type string)
     inputs: {'file_path' => [:param, 'file_path'], 'file_size' => [:output, 'check', 'file_size', 'input_value = input_value.to_s']}},
    {id: 'exit_failed', name: 'Exit on missing file', type: 'ExitStatus', at: [670, 280], from: 'check:Failed',
     attrs: {failed_status: 'Media file not found: <%= File.basename(file_path) %>'},
     inputs: {'file_path' => [:param, 'file_path']}},
    {id: 'exit_error', name: 'Exit on other failure', type: 'ExitStatus', at: [670, 450], from: 'check:Error',
     attrs: {error_status: 'Could not check <%= File.basename(file_path) %>: see step Check media file'},
     inputs: {'file_path' => [:param, 'file_path']}}
  ]
}
