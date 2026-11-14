# Pattern - high volume 1 (add to queue): only detects the files and adds them to the queue Bulk transcoding, then ends.
# Pattern - high volume 2 (process queue) starts a work order for each file when a slot of the pool is free.
# Queue Bulk transcoding: tools/figures/practices/server-setup.rb. Figures: see tools/figures/README.md
{
  name: 'Pattern - high volume 1 (add to queue)',
  description: 'Adds each new media file of /data/ingest/bulk/ to the queue Bulk transcoding, and ends.',
  start: [60, 131], end: [600, 129], fail: [600, 291], error: [600, 441],
  end_from: 'enqueue',
  steps: [
    {id: 'detect', name: 'Detect new files', type: 'LocalFileWatcher', at: [170, 110], from: 'start',
     attrs: {directory: '/data/ingest/bulk/', file_name: '*.mp4', allow_multiple: 1, trigger_type: 'by workflow', remove_file: 0, polling_frequency: 10}},
    {id: 'enqueue', name: 'Add to queue', type: 'QueueStager', at: [380, 110], from: 'detect',
     attrs: {operation: 'Add', queue_name: 'Bulk transcoding', item_description: '<%= File.basename(file_path) %>'},
     inputs: {'Queued_item' => [:output, 'detect', 'FileName'], 'file_path' => [:output, 'detect', 'FileName']}}
  ]
}
