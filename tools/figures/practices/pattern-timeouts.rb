# Workflow "Pattern - timeouts": a schedule trigger in parallel limits a wait or the duration of several steps.
# Variants: cumulative (timeout of 3 steps), escalation (reminder, then failure), receipt (published: timeout of a search).
timer = ->(id, name, at, from, rule) { {id: id, name: name, type: 'ScheduleTrigger', at: at, from: from, attrs: {schedule_rules: rule}} }
ruby_op = ->(id, name, at, from) { {id: id, name: name, type: 'CustomRuby', at: at, from: from, attrs: {execute_code: "# the operation\nsleep 1\n"}} }
watcher = ->(id, name, at, from, dir, pattern) {
  {id: id, name: name, type: 'LocalFileWatcher', at: at, from: from, attrs: {directory: dir, file_name: pattern, remove_file: 0, trigger_type: 'none'}}
}
{
  name: 'Pattern - timeouts',
  description: 'Waits for a receipt at most 30 minutes; the timer is cancelled when the receipt is found.',
  start: [60, 131], end: [900, 129], fail: [900, 349], error: [900, 500],
  end_from: %w[email timer:Failed/bezier], end_or: [1, 780, 124], # curves here and in the OR of the alert: Manhattan lines would cross the steps
  fail_from: 'alert',
  steps: [
    watcher.call('find', 'find receipt', [250, 110], 'start', '/data/ingest/receipts/', '*.receipt'),
    {id: 'email', name: 'email on success', type: 'EmailNotification', at: [500, 110], from: 'find',
     attrs: {subject_line: 'Receipt found', destinations: '<OPERATOR_EMAIL>'}},
    timer.call('timer', 'timeout on find receipt', [250, 330], 'start', '30___min'),
    {id: 'alert', name: 'alert on failure', type: 'OrchestratorAlertEntry', at: [620, 330], or: [1, 500, 344],
     from: %w[timer find:Failed/bezier find:Error/bezier],
     attrs: {category_type: 2, header: 'Receipt', alert_message: 'No receipt after 30 minutes'}}
  ],
  variants: {
    cumulative: {
      steps: [ruby_op.call('op', 'do operation', [250, 110], 'start'), ruby_op.call('op1', 'do operation 1', [450, 110], 'op'),
              ruby_op.call('op2', 'do operation 2', [650, 110], 'op1'), timer.call('timer', 'wait 2 minutes', [250, 330], 'start', '2___min')],
      end_from: 'op2', end_or: nil, fail_from: 'timer'
    },
    escalation: {
      steps: [watcher.call('detect', 'detect new xml file', [210, 110], 'start', '/data/ingest/incoming/', '*.xml'),
              watcher.call('wait', 'wait for media file', [560, 110], %w[detect notify], '/data/ingest/incoming/', '*.mxf').merge(or: [1, 440, 124]),
              timer.call('remind', 'wait 2 minutes', [300, 300], 'detect', '2___min'),
              {id: 'notify', name: 'notify missing media file', type: 'EmailNotification', at: [520, 300], from: 'remind',
               attrs: {subject_line: 'Media file missing', destinations: '<OPERATOR_EMAIL>'}},
              timer.call('giveup', 'wait 1 hour', [440, 480], 'detect', '1___hour')],
      end: [800, 129], fail: [800, 499], error: [800, 640], end_from: 'wait', end_or: nil, fail_from: 'giveup'
    },
    receipt: {}
  }
}
