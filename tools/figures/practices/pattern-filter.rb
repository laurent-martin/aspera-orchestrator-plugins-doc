# Workflow "Pattern - filter": a filter is the if-then-else of a workflow.
# Variant loop: a link back (NO). Variant negated: a filter returns a negated flag. Variant size (published): a condition on the size of the file.
{
  name: 'Pattern - filter',
  description: 'If the file is big enough, move it; otherwise send an e-mail and fail.',
  start: [60, 131], end: [1000, 129], fail: [1000, 299], error: [1000, 450],
  end_from: 'move', fail_from: 'email',
  steps: [
    {id: 'watch', name: 'watch folder', type: 'LocalFileWatcher', at: [210, 110], from: 'start',
     attrs: {directory: '/data/ingest/incoming/', file_name: '*.mxf', remove_file: 0, trigger_type: 'none'}},
    {id: 'filter', name: 'is file big enough', type: 'Filter', at: [440, 110], from: 'watch',
     attrs: {command: "File.size(inputs['filename']) > 100\n", mandatory_inputs: "{'filename'=>'string'}"},
     inputs: {'filename' => [:output, 'watch', 'FileName']}},
    {id: 'move', name: 'move file', type: 'LocalFileOperation', at: [700, 110], from: 'filter',
     attrs: {operation: 'move', target: '/data/ingest/accepted/'},
     inputs: {'source' => [:output, 'watch', 'FileName']}, carry: [%w[watch FileName]]},
    {id: 'email', name: 'email on error', type: 'EmailNotification', at: [700, 280], from: 'filter:Failed',
     attrs: {subject_line: 'File too small', destinations: '<OPERATOR_EMAIL>'},
     carry: [%w[watch FileName]]}
  ],
  variants: {
    # NO: a link back from the condition to the operation (a step runs once in a work order); the schedule trigger stands for any operation
    loop: {
      steps: [
        {id: 'op', name: 'an operation', type: 'ScheduleTrigger', at: [250, 110], from: %w[start cond:Failed],
         attrs: {schedule_rules: '1___min'}},
        {id: 'cond', name: 'if condition', type: 'Filter', at: [500, 110], from: 'op',
         attrs: {command: "# true: done\ntrue\n"}}
      ],
      end: [760, 129], end_from: 'cond', fail_from: nil
    },
    negated: {
      steps: [
        {id: 'filter', name: 'should I fail', type: 'Filter', at: [440, 110], from: 'start',
         attrs: {command: "return !inputs['should_fail']\n", mandatory_inputs: "{'should_fail'=>'flag'}"},
         inputs: {'should_fail' => [:param, 'should_fail']}},
        {id: 'move', name: 'move file', type: 'LocalFileOperation', at: [700, 110], from: 'filter',
         attrs: {operation: 'move', target: '/data/ingest/accepted/'},
         inputs: {'source' => [:value, '/data/ingest/incoming/file.mxf']}},
        {id: 'email', name: 'email on error', type: 'EmailNotification', at: [700, 280], from: 'filter:Failed',
         attrs: {subject_line: 'Asked to fail', destinations: '<OPERATOR_EMAIL>'}}
      ],
      params: [{id: 'p_fail', name: 'should_fail', type: 'flag', value: 'false', runtime: true, optional: true, at: [60, 260], link: 'start'}]
    },
    size: {}
  }
}
