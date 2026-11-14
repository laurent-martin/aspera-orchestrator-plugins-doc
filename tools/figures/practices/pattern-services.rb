# Pattern - services: a command on a remote node, a payload built from a template, then a job started and checked by REST
# (start request, then a check request that polls until the job ends). Not run: transcoder.example.com is a placeholder service.
# Figures: see tools/figures/README.md
{
  name: 'Pattern - services',
  description: 'Computes the checksum of a file, builds a job request, starts the job on a REST service and waits for its end.',
  start: [160, 131], end: [1090, 129], fail: [1090, 299], error: [1090, 441],
  end_from: 'check',
  params: [
    {id: 'p_file', name: 'file_path', type: 'string', value: '', runtime: true, at: [30, 230], link: 'start'},
    {id: 'p_priority', name: 'priority', type: 'string', value: '', runtime: true, optional: true, at: [30, 330], link: 'start'}
  ],
  steps: [
    {id: 'checksum', name: 'Checksum', type: 'RemoteExecution', at: [270, 110], from: 'start',
     attrs: {command: 'md5sum "<%= file_path %>"', execution_node: 'localhost', script_timeout: 600, mandatory_inputs: "{'file_path'=>'string'}",
             formatted_outputs: "{'md5'=>'string'}", formatted_outputs_processing_code: "outputs['md5'] = outputs[VARIABLE_STDIO].to_s.split.first"},
     inputs: {'file_path' => [:param, 'file_path']}},
    {id: 'request', name: 'Job request', type: 'FileGenerator', at: [470, 110], from: 'checksum',
     # Ruby tags not indented, ending with %>\ (linefeed suppressed): no blank line when there is no priority.
     # Input names must not be method names: md5 is a global method of Orchestrator ("wrong number of arguments")
     attrs: {file_body_template: <<~'JSON', return_file_as_output: 1, suppress_linefeeds: 1,
               {
                 "source": "<%= file_path %>",
                 "md5": "<%= file_md5 %>",
               <% unless job_priority.empty? %>\
                 "priority": <%= job_priority %>,
               <% end %>\
                 "profile": "proxy"
               }
             JSON
             required_inputs: "{'file_path'=>'string','file_md5'=>'string','job_priority'=>'string'}"},
     inputs: {'file_path' => [:param, 'file_path'], 'file_md5' => [:output, 'checksum', 'md5'], 'job_priority' => [:param, 'priority']}},
    {id: 'start_job', name: 'Start job', type: 'RestRequest', at: [670, 110], from: 'request',
     attrs: {service_url: 'https://transcoder.example.com/api/v1/jobs', rest_method: 'post', content_type: 'application/json', response_type: 'json',
             post_body: '<%= job_request %>', processed_outputs: "{'job_id'=>'string'}",
             processed_outputs_code: <<~'RUBY'},
               outputs['job_id'] = json_result['id'].to_s rescue ''
               if outputs['job_id'].empty?
                 @status = STATUS_FAILED
                 @status_details = "No job id: #{@result.to_s[0, 200]}"
               end
             RUBY
     inputs: {'job_request' => [:output, 'request', 'Generated_file_content']}},
    {id: 'check', name: 'Check job status', type: 'RestRequest', at: [870, 110], from: 'start_job',
     attrs: {service_url: 'https://transcoder.example.com/api/v1/jobs/<%= job_id %>', rest_method: 'get', response_type: 'json', polling_frequency: 10,
             polling_stop_condition: "%w[complete failed].include?(json_result['status'])",
             processed_outputs_code: "if json_result['status'] == 'failed'\n  @status = STATUS_FAILED\n  @status_details = json_result['message'].to_s\nend"},
     inputs: {'job_id' => [:output, 'start_job', 'job_id']}}
  ]
}
