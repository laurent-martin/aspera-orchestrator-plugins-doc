# Workflow "Pattern - two ORs": two bypasses joined before operation 3 with one OR, 2 of 4 entries.
{
  name: 'Pattern - two ORs',
  description: 'Two bypasses join before operation 3 in one OR: 2 of its 4 entries.',
  start: [60, 81], end: [1080, 79], fail: [1080, 400], error: [1080, 540],
  end_from: 'op3',
  steps: [
    {id: 'filter', name: 'filter', type: 'Filter', at: [230, 60], from: 'start',
     attrs: {command: "# true: run operation 1\ntrue\n"}},
    {id: 'op1', name: 'operation 1', type: 'CustomRuby', at: [450, 60], from: 'filter',
     attrs: {execute_code: "# the operation\nsleep 1\n"}},
    {id: 'filter2', name: 'filter 2', type: 'Filter', at: [230, 260], from: 'start',
     attrs: {command: "# true: run operation 2\ntrue\n"}},
    {id: 'op2', name: 'operation 2', type: 'CustomRuby', at: [450, 260], from: 'filter2',
     attrs: {execute_code: "# the operation\nsleep 1\n"}},
    # curves: Manhattan lines from the failed exits would cross the operations
    {id: 'op3', name: 'operation 3', type: 'CustomRuby', at: [850, 60], from: %w[filter:Failed/bezier op1 filter2:Failed/bezier op2], or: [2, 700, 74],
     attrs: {execute_code: "# the operation\nsleep 1\n"}}
  ]
}
