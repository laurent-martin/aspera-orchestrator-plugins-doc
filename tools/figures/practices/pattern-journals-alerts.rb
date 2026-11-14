# Pattern - journals and alerts: a journal entry when the file is received, then a final entry on success and on failure
# (the later entries append to the same file entry: file id and package id mapped from the first one), and an alert for
# the operators on failure. Journal book "Media ingest": server-setup.rb (an import creates only the books of inline journals).
# OrchestratorAlertEntry 4.1.6 does not store the header: none set.
# Runs (tools/figures/README.md): clip1.mp4 (Complete), clip9.mp4 (missing: Failed).
# Figures: see tools/figures/README.md
journal = lambda do |extra|
  {journal_book: 'Media ingest', file: '<%= File.basename(file_path) %>', file_path: '<%= file_path %>',
   package: '<%= File.basename(File.dirname(file_path)) %>'}.merge(extra)
end
same_entry = {'file_path' => [:param, 'file_path'], 'file_ID' => [:output, 'received', 'journal_file_ID'],
              'package_ID' => [:output, 'received', 'actual_package_ID']}
{
  name: 'Pattern - journals and alerts',
  description: 'Writes the progress of a media file in a journal, and alerts the operators when its check fails.',
  start: [160, 131], end: [1090, 129], fail: [1090, 299], error: [1090, 441],
  end_from: 'checked', fail_from: 'alert',
  params: [
    {id: 'p_file', name: 'file_path', type: 'string', value: '', runtime: true, at: [30, 230], link: 'start'}
  ],
  steps: [
    {id: 'received', name: 'Journal received', type: 'FileJournalLogEntry', at: [270, 110], from: 'start',
     attrs: journal.call(event: 'Received', processing_status: 'In Progress', milestone: 10, new_file: true),
     inputs: {'file_path' => [:param, 'file_path']}},
    {id: 'probe', name: 'Probe media file', type: 'FfprobeInfo', at: [470, 110], from: 'received',
     attrs: {execution_node: 'localhost', options: '-v error -show_format', input_file_path: '<%= file_path %>'},
     inputs: {'file_path' => [:param, 'file_path']}},
    {id: 'checked', name: 'Journal checked', type: 'FileJournalLogEntry', at: [870, 110], from: 'probe',
     attrs: journal.call(event: 'Checked', processing_status: 'Complete', milestone: 100),
     inputs: same_entry},
    {id: 'failed', name: 'Journal failed', type: 'FileJournalLogEntry', at: [670, 280], from: ['probe:Failed', 'probe:Error'],
     or: [1, 590, 294],
     attrs: journal.call(event: 'Check failed: missing file or not a media file', processing_status: 'Failed', milestone: 100),
     inputs: same_entry},
    {id: 'alert', name: 'Alert operators', type: 'OrchestratorAlertEntry', at: [870, 280], from: 'failed',
     attrs: {category_type: 1, alert_message: 'File <%= File.basename(file_path) %> could not be checked: see journal Media ingest'},
     inputs: {'file_path' => [:param, 'file_path']}}
  ]
}
