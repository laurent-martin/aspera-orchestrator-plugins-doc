# Workflow "Pattern - parallel branches": two operations in parallel, joined with AND, OR, then OR 2 of 4 and a consolidation.
# In the variants and, or, the schedule trigger stands for any operation.
op = ->(id, name, y) { {id: id, name: name, type: 'CustomRuby', at: [300, y], from: 'start', attrs: {execute_code: "# the operation\nsleep 1\n"}} }
timer_op = ->(id, name, y) { {id: id, name: name, type: 'ScheduleTrigger', at: [300, y], from: 'start', attrs: {schedule_rules: '1___min'}} }
{
  name: 'Pattern - parallel branches',
  description: 'Two operations in parallel: wait for both whatever their result, then consolidate their status.',
  start: [60, 131], end: [1000, 129], fail: [1000, 299], error: [1000, 450],
  end_from: 'consolidate', fail_from: 'consolidate:Failed',
  steps: [
    op.call('op1', 'operation 1', 110),
    op.call('op2', 'operation 2', 330),
    {id: 'consolidate', name: 'consolidate status', type: 'CustomRuby', at: [760, 110], or: [2, 620, 124],
     from: %w[op1 op1:Failed/bezier op2 op2:Failed/bezier], # curves: Manhattan lines would cross the operations
     attrs: {mandatory_inputs: "{'op1_info'=>'hash','op2_info'=>'hash'}", execute_code: <<~RUBY},
       # fails if one of the operations failed
       failed = [inputs['op1_info'], inputs['op2_info']].reject { |info| info['step_status'] == 'Complete' }
       return STATUS_FAILED, "\#{failed.size} operation(s) failed", outputs unless failed.empty?
     RUBY
     inputs: {'op1_info' => [:output, 'op1', 'Step_information'], 'op2_info' => [:output, 'op2', 'Step_information']}}
  ],
  variants: {
    and: {steps: [timer_op.call('op1', 'operation 1', 110), timer_op.call('op2', 'operation 2', 330)],
          end: [700, 129], fail: [700, 299], end_from: %w[op1 op2], fail_from: nil},
    or: {steps: [timer_op.call('op1', 'operation 1', 110), timer_op.call('op2', 'operation 2', 330)],
         end: [700, 129], fail: [700, 299], end_from: %w[op1 op2], end_or: [1, 580, 124], fail_from: nil},
    or2: {}
  }
}
