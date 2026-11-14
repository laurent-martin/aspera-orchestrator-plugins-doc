# Workflow "Pattern - exclusive exits": the failed and error exits of a step joined without OR (never ends), then with an OR.
# The schedule trigger stands for any operation.
{
  name: 'Pattern - exclusive exits',
  description: 'The failed and error exits of a step are exclusive: they join through an OR.',
  start: [60, 131], end: [700, 129], fail: [700, 280], error: [700, 450],
  end_from: 'op1',
  fail_from: %w[op1:Failed op1:Error],
  steps: [
    {id: 'op1', name: 'operation 1', type: 'ScheduleTrigger', at: [300, 110], from: 'start',
     attrs: {schedule_rules: '1___min'}}
  ],
  variants: {
    no: {},
    yes: {fail_or: [1, 560, 275]}
  }
}
