# Workflow "Pattern - fan-out": the same step for each file of a list, then a funnel-in.
# Variants: onestep_no (two steps between fan-out and funnel-in), basic, or (published: all exits of the step join in an OR).
list = {id: 'list', name: 'list files', type: 'LocalFileWatcher', at: [210, 110], from: 'start',
        attrs: {directory: '/data/ingest/fanout/', file_name: '*.mxf', return_all: 1, remove_file: 0, trigger_type: 'none', cool_off: 1}}
each = {id: 'each', name: 'for each file', type: 'ArrayFanout', at: [420, 110], from: 'list',
        attrs: {fanout_variable: 'files', fanned_as: 'file_path', variable_type: 'string'},
        inputs: {'files' => [:output, 'list', 'FileName']}}
info = {id: 'info', name: 'get info', type: 'FileInfo', at: [630, 110], from: 'each',
        inputs: {'File_path' => [:output, 'each', 'file_path']}, carry: [%w[each file_path]]}
merge = ->(from, synch = nil) {
  {id: 'merge', name: 'merge', type: 'Funnelin', at: [960, 110], from: from, or: synch,
   attrs: {funnel_variable: 'file_path', funnel_type: 'string', return_status: 1, fail_if_failures: 1},
   inputs: {'file_path' => [:output, 'each', 'file_path']}}
}
{
  name: 'Pattern - fan-out',
  description: 'Gets the information of each file of a folder, in parallel, and waits for all.',
  start: [60, 131], end: [1180, 129], fail: [1180, 299], error: [1180, 450],
  end_from: 'merge',
  steps: [list, each, info, merge.call(%w[info info:Failed/bezier info:Error/bezier], [1, 840, 124])], # curves: Manhattan lines would cross the step
  variants: {
    onestep_no: {
      steps: [list, each,
              {id: 'media', name: 'get media info', type: 'MediaInfo', at: [630, 110], from: 'each',
               inputs: {'Media_file_path' => [:output, 'each', 'file_path'], 'Execution_node' => [:value, 'localhost']}},
              {id: 'md5', name: 'compute md5', type: 'Md5Checksum', at: [800, 110], from: 'media',
               inputs: {'File_path' => [:output, 'each', 'file_path']}},
              merge.call('md5')]
    },
    basic: {steps: [list, each, info, merge.call('info')]},
    or: {}
  }
}
