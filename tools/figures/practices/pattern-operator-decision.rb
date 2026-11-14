# Pattern - operator decision: a task asks an operator where to deliver a media file (custom form), the workflow has a
# custom start page that lists the media files. A canceled task ends the step with Failed.
# Server files (tools/figures/README.md): user_inputs/_external_delivery.html.erb, workflow_start_views/_start_ID.html.erb (ID of this workflow).
# Figures: see tools/figures/README.md
{
  name: 'Pattern - operator decision',
  description: 'Asks an operator where to deliver a media file.',
  start: [160, 131], end: [600, 129], fail: [600, 299], error: [600, 441],
  end_from: 'choose', fail_from: 'choose:Failed',
  params: [
    {id: 'p_media', name: 'media_file_path', type: 'string', value: '', runtime: true, at: [30, 230], link: 'start'}
  ],
  steps: [
    {id: 'choose', name: 'Choose target', type: 'UserInput', at: [270, 110], from: 'start',
     attrs: {event_description: 'Choose the target of <%= File.basename(media_file_path) %>', view_template: '_external_delivery.html.erb',
             assigned_roles_logins: 'Operator, Administrator', mandatory_inputs: "{'media_file_path'=>'string'}",
             required_requested_data: "{'target'=>'string'}",
             user_outputs: "{'description'=>'string','profile'=>'string','source'=>'string','final_media_path'=>'string','final_proxy_path'=>'string','final_metadata_path'=>'string','date_start'=>'string','date_stop'=>'string'}"},
     inputs: {'media_file_path' => [:param, 'media_file_path']}}
  ]
}
