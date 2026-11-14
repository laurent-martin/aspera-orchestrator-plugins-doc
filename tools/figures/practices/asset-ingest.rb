# Asset ingest: trigger workflow, detects XML side files and starts one L1 work order per file.
# Figures: see tools/figures/README.md
{
  name: 'Asset ingest',
  description: 'Watches the ingest folders, and starts Asset ingest - L1 processing for each new XML side file.',
  start: [60, 131], end: [1310, 129], fail: [1310, 291], error: [1310, 441],
  end_from: 'funnel',
  steps: [
    {id: 'config', name: 'Configuration', type: 'MassParameterSetter', at: [170, 110], from: 'start',
     template: 'Asset ingest configuration',
     attrs: {parameters: "{'INGEST_ROOT'=>['/data/ingest/','string'],'FILE_PATTERN'=>['*.xml','string']}"}},
    {id: 'folders', name: 'Watched folders', type: 'SimpleParameterLookup', at: [360, 110], from: 'config',
     # no key input: without return_array_of_rows the step fails (No configuration match), 4.1.6
     attrs: {parameters_associations: "SOURCE:::FOLDER\r\npartner_a:::/data/ingest/partner_a/\r\npartner_b:::/data/ingest/partner_b/\r\nstudio:::/data/ingest/studio/", return_array_of_rows: 1},
     inputs: {'ColumnToListValueFrom' => [:value, 'FOLDER']},
     carry: [%w[config FILE_PATTERN]]},
    {id: 'detect', name: 'Detect new files', type: 'LocalFileWatcher', at: [550, 110], from: 'folders',
     attrs: {comments: 'XML side files in the folders of the lookup table', allow_multiple: 1, return_all: 1, multi_folders: 1, remove_file: 0, polling_frequency: 10},
     inputs: {'directory' => [:output, 'folders', 'ColumnValues'], 'File_name' => [:output, 'config', 'FILE_PATTERN']}},
    {id: 'each', name: 'Each file', type: 'ArrayFanout', at: [740, 110], from: 'detect',
     attrs: {fanout_variable: 'xml_files', fanned_as: 'xml_file_path', variable_type: 'string'},
     inputs: {'xml_files' => [:output, 'detect', 'FileName']}},
    {id: 'launch', name: 'Process file', type: 'WorkflowLauncher', at: [930, 110], from: 'each',
     attrs: {workflow_id: wf_id('Asset ingest - L1 processing'), use_true_name: 1, master_id: '-1'},
     inputs: {'xml_file_path' => [:output, 'each', 'xml_file_path'],
              'WorkOrder_Description' => [:output, 'each', 'xml_file_path', 'input_value = File.basename(input_value)']},
     carry: [%w[each xml_file_path]]},
    {id: 'funnel', name: 'All launched', type: 'Funnelin', at: [1120, 110], from: 'launch',
     attrs: {funnel_variable: 'xml_file_path', funnel_type: 'string'},
     inputs: {'xml_file_path' => [:output, 'each', 'xml_file_path']}}
  ]
}
