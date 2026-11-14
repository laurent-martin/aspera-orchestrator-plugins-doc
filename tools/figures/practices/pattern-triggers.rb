# Pattern - triggers.
# Variant monitors: one trigger with Continue monitoring at the start; the triggers after it wait once.
# Transfer start (Continue monitoring, scope by workorder group), then the end of the same transfer (scope none: the
# two triggers share the history of the work order group), then the XML side files of the transferred files (DependencyChecker).
# Not run (Node API of remote node orch).
# Variant either (published): one file or another. A check fails only on its timeout: without one it waits for ever.
# Runs: first.xml, second.xml or no file in /data/ingest/dependency/, then ascli orchestrator workflows start <id> @json:'{}'
# Figures: see tools/figures/README.md
check = ->(id, name, at, from, file) {
  {id: id, name: name, type: 'DependencyChecker', at: at, from: from,
   attrs: {dependency_paths: %(["/data/ingest/dependency/#{file}"]), timeout_in_sec: 30, polling_frequency: 5, stability_period: 5}}
}
{
  name: 'Pattern - triggers',
  description: 'For each upload received on the node: waits for its end, then for the XML side files of its files.',
  start: [60, 131], end: [810, 129], fail: [810, 299], error: [810, 441],
  end_from: 'side_files', fail_from: 'side_files:Failed',
  steps: [
    {id: 'xfer_start', name: 'Transfer start', type: 'AsperaNodeApiTransferMonitor', at: [170, 110], from: 'start',
     attrs: {remote_node: 'orch', keep_ongoing: 1, trigger_type: 'by workorder group', filter_direction: 'receive', transfer_type: 'download.started'}},
    {id: 'xfer_end', name: 'Transfer end', type: 'AsperaNodeApiTransferMonitor', at: [380, 110], from: 'xfer_start',
     attrs: {remote_node: 'orch', keep_ongoing: 0, trigger_type: 'none', filter_direction: 'receive', transfer_type: 'download.ended'},
     inputs: {'Transfer_id' => [:output, 'xfer_start', 'Transfer_id_list', 'input_value = input_value.first']}},
    {id: 'side_files', name: 'Wait for XML side files', type: 'DependencyChecker', at: [590, 110], from: 'xfer_end',
     attrs: {timeout_in_sec: 3600},
     inputs: {'Dependency_paths' => [:output, 'xfer_end', 'File_list', "input_value = input_value.map { |f| f.sub(/\\.[^.]*\\z/, '.xml') }"]}}
  ],
  variants: {
    monitors: {},
    either: {
      description: 'Waits for one file or another; fails if both are absent.',
      start: [60, 131], end: [880, 129], fail: [880, 410], error: [880, 550],
      end_from: %w[first second], end_or: [1, 760, 124], fail_from: 'second:Failed',
      steps: [check.call('first', 'Check first file', [230, 110], 'start', 'first.xml'),
              check.call('second', 'Check second file', [500, 280], 'first:Failed', 'second.xml')]
    }
  }
}
