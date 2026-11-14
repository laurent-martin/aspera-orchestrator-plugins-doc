# Workflow "Pattern - bypass": the filter skips operation 1 on failure; both paths join in one OR before Complete.
# The schedule trigger stands for any operation.
{
  name: 'Pattern - bypass',
  description: 'A bypass: operation 1 runs only if the filter passes; both paths join in one OR.',
  start: [60, 131], end: [820, 129], fail: [820, 450], error: [820, 590],
  end_from: %w[op1 filter:Failed], end_or: [1, 700, 250],
  steps: [
    {id: 'filter', name: 'filter', type: 'Filter', at: [230, 110], from: 'start',
     attrs: {command: "# true: run operation 1\ntrue\n"}},
    {id: 'op1', name: 'operation 1', type: 'ScheduleTrigger', at: [470, 110], from: 'filter',
     attrs: {schedule_rules: '1___min'}}
  ]
}
