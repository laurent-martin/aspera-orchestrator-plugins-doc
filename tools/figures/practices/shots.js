// Figures of docs/workflow-development-practices.md: how to capture each one.
// Each recipe opens a page with the tools of tools/figures/capture.js and returns the area to capture.
// Workflows are imported from the .yml files of this folder (see tools/figures/README.md).
module.exports = {
  outDir: '../../../docs/images/practices',
  shots: {
    // Trigger workflow: configuration, lookup, watcher, fan-out with launcher, funnel-in (Fail and Error nodes excluded)
    'launcher-in-fanout': async t => { await t.designer('Asset ingest'); return t.nodes({ hide: ['Fail', 'Error'] }); },
    // Processing workflow with a sub-workflow step "Asset transcoding"
    'subworkflow-step': async t => { await t.designer('Asset ingest - L1 processing'); return t.nodes({ hide: ['Fail', 'Error'] }); },
    // Workflow list: names with level markers, up to the status column
    'naming-levels': async t => {
      await t.viewport(1440);
      await t.goto(`/workflows?id=${t.folderId('Asset ingest')}`);
      const rows = ['Asset ingest', 'Asset ingest - L1 processing', 'Asset ingest - L2 transcoding'].map(n => `#draggable_${t.workflowId(n)}`);
      return t.elements(['table thead tr', ...rows], { margin: 0, right: 'th:has-text("STATUS")' });
    },
    // Workflows > Workflow Actions: global templates of the load manager (configured instances of other workflows excluded)
    'workflow-actions-templates': async t => {
      await t.viewport(1800);
      await t.goto('/actions_directory');
      await t.page.fill('input[placeholder*="Search workflow actions"]', 'Load manager');
      await t.page.waitForTimeout(1500);
      await t.page.locator('text=Load manager').last().click();
      await t.page.waitForSelector('tr.action-row');
      await t.page.waitForTimeout(500);
      return t.elements(['input[placeholder*="Search workflow actions"]', 'tr.action-row:not(.embedded-action)']);
    },
    // Designer, right-click on a step > Change Action Template: the configuration of the step, hover on Make global
    'change-action-template': async t => {
      await t.designer('Asset ingest - L2 transcoding');
      await t.stepMenu('Transcode', 'Change Action Template');
      await t.page.waitForSelector('#modal_dialog tr.action_selected');
      await t.page.locator('#modal_dialog tr.action_selected [data-bs-toggle="tooltip"]').last().hover();
      await t.page.waitForTimeout(800);
      return t.dialog();
    },
    // Designer, right-click on a step > Map Inputs: inputs mapped to outputs of previous steps
    'input-mappings': async t => {
      await t.designer('Asset ingest');
      await t.stepMenu('Detect new files', 'Map Inputs');
      return t.dialog();
    },
    // Designer, right-click on a step > Map Outputs: Carry Thru? of the outputs of the previous step
    'map-outputs-carry-thru': async t => {
      await t.designer('Asset ingest');
      await t.stepMenu('Watched folders', 'Map Outputs');
      return t.dialog();
    },
    // Designer, Map Inputs: pre-processing code on an input (file name from a path)
    'input-preprocessing': async t => {
      await t.designer('Asset ingest - L1 processing');
      await t.stepMenu('Wait for media file', 'Map Inputs');
      const row = '#modal_dialog tr:has-text("File_name")';
      await t.fitTextareas(`${row} textarea`);
      return t.dialog({ bottom: row });
    },
    // Designer, Edit Action Template of a lookup table: key column with glob patterns, value columns
    'lookup-table-config': async t => {
      await t.designer('Asset ingest - L1 processing');
      await t.stepMenu('Target folders', 'Edit Action Template');
      await t.page.locator('#modal_dialog .modal-body').evaluate(e => { e.scrollTop = e.scrollHeight; });
      return t.dialog();
    },
    // Exclusive exits joined without OR (variant no: revision before the last), then with an OR (variant yes: published)
    'exclusive-no': async t => { await t.revision('Pattern - exclusive exits', 1); return t.nodes({ hide: ['Error'] }); },
    'exclusive-yes': async t => { await t.designer('Pattern - exclusive exits'); return t.nodes({ hide: ['Error'] }); },
    // A bypass joined with one OR before Complete
    'bypass-yes': async t => { await t.designer('Pattern - bypass'); return t.nodes({ hide: ['Fail', 'Error'] }); },
    // Two bypasses joined with one OR "2 of 4" before operation 3
    'two-or-yes': async t => { await t.designer('Pattern - two ORs'); return t.nodes({ hide: ['Fail', 'Error'] }); },
    // Double-click on an OR: Set Operator dialog ("n of m")
    'or-set-operator': async t => {
      await t.designer('Pattern - two ORs');
      const b = await t.nodeBox(700, 74); // OR before operation 3, see pattern-two-or.rb
      await t.page.mouse.click(b.x + 12, b.y + 12); // select it first: a double-click on a figure not selected is not seen
      await t.page.waitForTimeout(300);
      await t.page.mouse.dblclick(b.x + 12, b.y + 12);
      await t.page.waitForSelector('.swal2-popup');
      await t.page.waitForTimeout(500);
      return t.elements(['.swal2-popup']);
    },
    // NO: Complete fed by operation 1 directly and by the OR. Drawn from the published graph by mouse, not saved
    // (4.1.6 saves it with errors). Positions from pattern-bypass.rb
    'bypass-no': async t => {
      const { PORT } = t;
      await t.designer('Pattern - bypass');
      await t.deleteLink(PORT.stepOut([470, 110]), PORT.orIn([700, 250]));
      await t.drawLink(PORT.stepOut([470, 110]), PORT.endIn([820, 129]));
      await t.deselect();
      return t.nodes({ hide: ['Fail', 'Error'] });
    },
    // NO: two ORs feeding operation 3. Drawn from the published graph by mouse, not saved (4.1.6 saves it with errors).
    // Positions from pattern-two-or.rb
    'two-or-no': async t => {
      const { PORT } = t;
      await t.designer('Pattern - two ORs');
      await t.setOperator([700, 74], 1);
      // The failed exits are curves in the published graph: drawn again with the default line, and each OR lower than its row, so that they pass below the operations
      await t.deleteLink(PORT.stepFailed([230, 60]), PORT.orIn([700, 74]));
      await t.deleteLink(PORT.stepFailed([230, 260]), PORT.orIn([700, 74]));
      await t.deleteLink(PORT.stepOut([450, 260]), PORT.orIn([700, 74]));
      const or1 = await t.moveNode([700, 74], [700, 150]);
      const or2 = await t.dropFromPalette('Logic Operator', [699, 349]); // the new node is 1 px off
      await t.setOperator(or2, 1);
      await t.drawLink(PORT.stepFailed([230, 60]), PORT.orIn(or1));
      await t.drawLink(PORT.stepFailed([230, 260]), PORT.orIn(or2));
      await t.drawLink(PORT.stepOut([450, 260]), PORT.orIn(or2));
      await t.drawLink(PORT.orOut(or2), PORT.stepIn([850, 60]));
      await t.deselect();
      return t.nodes({ hide: ['Fail', 'Error'] });
    },
    // Filter as if-then-else: true moves the file, false sends an e-mail and fails
    'filter-workflow': async t => { await t.designer('Pattern - filter'); return t.nodes({ hide: ['Error'] }); },
    // Filter configuration: code and required input
    'filter-config': async t => {
      await t.designer('Pattern - filter');
      await t.stepMenu('is file big enough', 'Edit Action Template');
      await t.scrollDialogTo('Command');
      return t.dialog();
    },
    // Filter returning a negated flag (variant negated: revision before the last)
    'filter-negated': async t => {
      await t.revision('Pattern - filter', 1);
      await t.stepMenu('should I fail', 'Edit Action Template');
      await t.scrollDialogTo('Command');
      return t.dialog();
    },
    // Parallel branches joined with AND (variant and), OR (variant or), OR 2 of 4 and consolidation (variant or2, published)
    'parallel-and': async t => { await t.revision('Pattern - parallel branches', 2); return t.nodes({ hide: ['Fail', 'Error'] }); },
    'parallel-or': async t => { await t.revision('Pattern - parallel branches', 1); return t.nodes({ hide: ['Fail', 'Error'] }); },
    'parallel-or-2-consolidate': async t => { await t.designer('Pattern - parallel branches'); return t.nodes({ hide: ['Error'] }); },
    // NO: link back from the condition to the operation (variant loop of Pattern - filter: 2 revisions before the last)
    'loop-back-no': async t => { await t.revision('Pattern - filter', 2); return t.nodes({ hide: ['Fail', 'Error'] }); },
    // Work order of the fan-out: one execution of the step per file (run: ascli orchestrator workflows start <id> @json:'{}')
    'fanout-work-order': async t => { await t.viewport(1600); return t.workOrder(t.lastWorkOrder('Pattern - fan-out', 'Complete')); },
    // Fan-out of a step, the step, funnel-in (variant basic), several steps (variant onestep_no), all exits in an OR (published)
    'fanout-basic': async t => { await t.revision('Pattern - fan-out', 1); return t.nodes({ hide: ['Fail', 'Error'] }); },
    'fanout-one-step-no': async t => { await t.revision('Pattern - fan-out', 2); return t.nodes({ hide: ['Fail', 'Error'] }); },
    'fanout-or': async t => { await t.designer('Pattern - fan-out'); return t.nodes({ hide: ['Fail', 'Error'] }); },
    // Configurations of the fan-out and funnel-in
    'fanout-execute-serial': async t => {
      await t.designer('Pattern - fan-out');
      await t.stepMenu('for each file', 'Edit Action Template');
      await t.scrollDialogTo('Fanned as');
      return t.dialog();
    },
    'funnel-in-config': async t => {
      await t.designer('Pattern - fan-out');
      await t.stepMenu('merge', 'Edit Action Template');
      await t.expandDialog();
      return t.dialog();
    },
    // Timeouts: variants cumulative (2 before the last), escalation (before the last), receipt (published)
    'cumulative-timeout': async t => { await t.revision('Pattern - timeouts', 2); return t.nodes({ hide: ['Error'] }); },
    'reminder-escalation': async t => { await t.revision('Pattern - timeouts', 1); return t.nodes({ hide: ['Error'] }); },
    'schedule-trigger-timeout': async t => { await t.designer('Pattern - timeouts'); return t.nodes({ hide: ['Error'] }); },
    'schedule-trigger-config': async t => {
      await t.designer('Pattern - timeouts');
      await t.stepMenu('timeout on find receipt', 'Edit Action Template');
      await t.scrollDialogTo();
      return t.dialog();
    },
    // Sub-workflow that decides whether an error is critical (stop) or not (the caller retries)
    'error-or-critical-filter': async t => { await t.designer('Pattern - critical error'); return t.nodes(); },
    // Retry tabs of the sub-workflow step of L1: retry on failure, retry on error.
    // From the revision view: the designer opened from the list does not show Retry Duration (4.1.6)
    'retry-settings': async t => {
      await t.revision('Asset ingest - L1 processing', 0);
      await t.stepMenu('Asset transcoding', 'Edit Action Template');
      await t.dialogTab('set_failed_retry');
      return t.dialog();
    },
    'retry-tab': async t => {
      await t.revision('Asset ingest - L1 processing', 0);
      await t.stepMenu('Asset transcoding', 'Edit Action Template');
      await t.dialogTab('set_error_retry');
      return t.dialog();
    },
    // CustomRuby of Pattern - meaningful status: required inputs and outputs with their types; code that returns a status with a message
    'custom-ruby-config': async t => {
      await t.designer('Pattern - meaningful status');
      await t.stepMenu('Check media file', 'Edit Action Template');
      await t.expandDialog();
      return t.dialog({ bottom: '#modal_dialog >> text=Advanced outputs' });
    },
    'custom-ruby-code': async t => {
      await t.designer('Pattern - meaningful status');
      await t.stepMenu('Check media file', 'Edit Action Template');
      await t.expandDialog();
      return t.elements(['#modal_dialog label:text-is("Execute code")', '#modal_dialog iframe', '#modal_dialog label:text-is("Toggle editor")']);
    },
    // Pattern - services: remote command, payload from a template, REST start then check with polling
    'remote-execution-config': async t => {
      await t.designer('Pattern - services');
      await t.stepMenu('Checksum', 'Edit Action Template');
      await t.expandDialog();
      return t.dialog({ bottom: '#modal_dialog >> text=Toggle editor' }); // down to the output processing code
    },
    'file-generator-config': async t => {
      await t.designer('Pattern - services');
      await t.stepMenu('Job request', 'Edit Action Template');
      await t.expandDialog();
      return t.dialog();
    },
    'rest-start-check': async t => { await t.designer('Pattern - services'); return t.nodes({ hide: ['Fail', 'Error'] }); },
    'rest-polling-stop': async t => {
      await t.designer('Pattern - services');
      await t.stepMenu('Check job status', 'Edit Action Template');
      await t.page.click('#modal_dialog [onclick*="advanced_polling_params"]'); // + Trigger and polling settings
      await t.page.waitForTimeout(800);
      await t.expandDialog();
      return t.elements(['#modal_dialog li:has(+ #advanced_polling_params)', '#advanced_polling_params'], { bottom: '#advanced_polling_params >> text=Continue monitoring' });
    },
    // Pattern - operator decision: task with a custom form (server/user_inputs), custom start page (server/workflow_start_views)
    'user-input-config': async t => {
      await t.designer('Pattern - operator decision');
      await t.stepMenu('Choose target', 'Edit Action Template');
      await t.expandDialog();
      return t.dialog();
    },
    // Tasks: the open task of a running work order (start one, see tools/figures/README.md), custom form _external_delivery filled, not submitted.
    // The video is external (test-videos.co.uk): it is shown paused on a frame of the film.
    'user-input-form': async t => {
      await t.viewport(1600, 1400);
      await t.goto('/active_assignments');
      await t.page.locator('tr:has-text("Choose the target of Big_Buck_Bunny")').first().click();
      await t.page.waitForSelector('#modal_dialog input[name="outputs[target]"]');
      await t.page.check('#modal_dialog input[name="outputs[target]"][value="CABLE Distrib"]');
      await t.page.fill('#modal_dialog [name="outputs[description]"]', 'Cable only: rights not cleared for VOD');
      await t.page.selectOption('#modal_dialog [name="outputs[source]"]', 'Archive');
      await t.page.fill('#modal_dialog [name="outputs[date_start]"]', '2026-12-01T08:00');
      await t.page.fill('#modal_dialog [name="outputs[date_stop]"]', '2026-12-31T20:00');
      await t.page.locator('#modal_dialog video').evaluate(v => new Promise((resolve, reject) => {
        v.onerror = () => reject(new Error('video not loaded'));
        const seek = () => { v.onseeked = () => resolve(); v.currentTime = 7; };
        if (v.readyState >= 1) seek(); else v.onloadedmetadata = seek;
      }));
      await t.page.click('#modal_dialog h3'); // no focus ring
      await t.page.waitForTimeout(1000);
      return t.dialog();
    },
    // Direct start page of Pattern - operator decision: standard fields, then the list of media files of _start_<id>.html.erb
    'direct-start-form': async t => {
      await t.viewport(900, 800);
      await t.goto(`/work_orders/direct_start/${t.workflowId('Pattern - operator decision')}`);
      await t.page.selectOption('#id_media_file', { label: 'clip2.mp4' });
      await t.page.waitForTimeout(500);
      return t.elements(['text=Direct Start a Work Order', 'form']);
    },
    // Watcher of Asset ingest: Continue monitoring, multi-folder search, pattern, return all files
    'watcher-keep-ongoing': async t => {
      await t.designer('Asset ingest');
      await t.stepMenu('Detect new files', 'Edit Action Template');
      await t.expandDialog();
      return t.dialog({ bottom: '#modal_dialog [name*="base_dir"]' }); // up to the end of the watch configuration
    },
    // Pattern - triggers (variant monitors: revision before the last): transfer start (Continue monitoring) then end of the same transfer (scope none): left part of the graph
    'trigger-start-end-monitors': async t => {
      await t.revision('Pattern - triggers', 1);
      return t.nodes({ region: [-1e6, -1e6, 520, 1e6], hide: ['Fail', 'Error'] }); // Transfer end at x 380 (pattern-triggers.rb)
    },
    // Variant either (published): one file or another, with DependencyChecker
    'dependency-checker': async t => { await t.designer('Pattern - triggers'); return t.nodes({ hide: ['Error'] }); },
    // Meaningful status (Pattern - meaningful status): label step, exit status step, failures handled in final steps
    'workorder-metadata-config': async t => {
      await t.designer('Pattern - meaningful status');
      await t.stepMenu('Label work order', 'Edit Action Template');
      await t.expandDialog();
      return t.dialog();
    },
    'exit-status-config': async t => {
      await t.designer('Pattern - meaningful status');
      await t.stepMenu('Exit if OK', 'Edit Action Template');
      await t.expandDialog();
      return t.dialog();
    },
    'error-custom-messages': async t => { await t.designer('Pattern - meaningful status'); return t.nodes(); },
    // Work Orders filtered by Title (the label), with the work order that completed open: its label follows the workflow name.
    // Needs the runs of Pattern - meaningful status (see tools/figures/README.md)
    'workorder-label-list': async t => {
      await t.viewport(1600, 1100);
      await t.goto('/work_orders');
      await t.page.locator('text=Filter >> visible=true').first().click();
      await t.page.waitForTimeout(1000);
      await t.page.fill('#filter\\[title\\]', 'Processing');
      await t.page.locator('text=Apply >> visible=true').first().click();
      await t.page.waitForLoadState('networkidle');
      await t.page.waitForTimeout(1500);
      await t.page.locator('text=Filter >> visible=true').first().click(); // close the filter panel
      await t.page.waitForTimeout(800);
      const id = t.lastWorkOrder('Pattern - meaningful status', 'Complete');
      await t.page.evaluate(url => wojs.selectWorkOrder(url), `${new URL(t.base).pathname}/work_orders/${id}`);
      await t.page.waitForSelector(`#work_order_viewer_${id} .wo-steps-section`);
      await t.page.mouse.move(5, 5);
      await t.page.waitForTimeout(1000);
      const clip = await t.elements(['#work_order_list .work-order-card', `#work_order_viewer_${id} .wrap_preview_fixed`, `#work_order_viewer_${id} .wo-steps-section`]);
      // the filter stays in the session: remove it
      return { clip, after: async () => { await t.page.locator('text=Remove Filter >> visible=true').first().click(); await t.page.waitForTimeout(1500); } };
    },
    // Work order view > Edit: Modify Work Order of the failed work order, status Cleared with the resolution in the comment (not saved)
    'change-work-order-status': async t => {
      await t.viewport(1600, 1100);
      const id = t.lastWorkOrder('Pattern - meaningful status', 'Failed');
      await t.workOrder(id);
      await t.page.locator(`#work_order_viewer_${id} >> text=Edit >> visible=true`).first().click();
      await t.page.waitForSelector('#work_order_status');
      await t.page.fill('#work_order_comments', 'clip9.mp4 was never delivered: the partner was informed by e-mail');
      await t.page.selectOption('#work_order_status', 'Cleared');
      await t.page.waitForTimeout(500);
      return t.dialog();
    },
    // Work order list: status messages set by ExitStatus (complete, failed), and a default message (error)
    'work-orders-exit-messages': async t => {
      await t.viewport(1600, 1100);
      await t.goto('/work_orders');
      // a filter of the session (panel open or filter applied) would hide the list
      if (await t.page.locator('text=Remove Filter >> visible=true').count()) {
        await t.page.locator('text=Remove Filter >> visible=true').first().click();
        await t.page.waitForTimeout(1500);
      }
      if (await t.page.locator('#filter_div').isVisible()) {
        await t.page.locator('text=Filter >> visible=true').first().click();
        await t.page.waitForTimeout(800);
      }
      // the list shows the last work orders first: filter by title (label of Pattern - meaningful status) so that its work orders are listed
      await t.page.locator('text=Filter >> visible=true').first().click();
      await t.page.waitForTimeout(1000);
      await t.page.fill('#filter\\[title\\]', 'Processing');
      await t.page.locator('text=Apply >> visible=true').first().click();
      await t.page.waitForLoadState('networkidle');
      await t.page.waitForTimeout(1500);
      await t.page.locator('text=Filter >> visible=true').first().click(); // close the filter panel
      await t.page.waitForTimeout(800);
      const shown = ['Complete', 'Failed', 'Error'].map(status => `wo_${t.lastWorkOrder('Pattern - meaningful status', status)}`);
      // only these three cards (other runs may be listed between them)
      await t.page.evaluate(keep => document.querySelectorAll('[id^="wo_"]').forEach(e => {
        if (/^wo_\d+$/.test(e.id) && !keep.includes(e.id)) e.style.display = 'none';
      }), shown);
      await t.page.waitForTimeout(300);
      const clip = await t.elements(shown.map(id => `#${id}`), { margin: 2 });
      // the filter stays in the session: remove it
      return { clip, after: async () => { await t.page.locator('text=Remove Filter >> visible=true').first().click(); await t.page.waitForTimeout(1500); } };
    },
    // Workflows > Resources > New Pool: pool Transcoders of L2 (custom, 2 resources of capacity 2); creates it if missing
    'create-resource-pool': async t => {
      await t.viewport(1600);
      await t.goto('/managed_resources');
      const exists = await t.page.locator('text="Transcoders"').count() > 0;
      await t.page.click('button:has-text("New Pool")');
      await t.page.waitForSelector('#new_resource_pool_form');
      await t.page.fill('#managed_resource_id', 'Transcoders');
      await t.page.check('#new_resource_pool_form input[value="custom"]');
      await t.page.fill('#managed_resource_resources', 'transcoder1, transcoder2');
      await t.page.fill('#managed_resource_capacity', '2');
      const clip = await t.dialog();
      if (exists) return clip;
      return { clip, after: async () => { await t.page.click('#new_resource_pool_form input[type="submit"]'); await t.page.waitForTimeout(2000); } };
    },
    // Workflows > Resources: pool Transcoders selected (list of pools, resources with capacity, reservations and status)
    'resource-pool-view': async t => {
      await t.viewport(1600);
      await t.goto('/managed_resources');
      await t.page.locator('#pools-list >> text="Transcoders"').click();
      await t.page.waitForSelector('#preview_pane table');
      await t.page.waitForTimeout(1000);
      return t.elements(['text="Resource Manager"', 'button:has-text("New Pool")', '#pools-list', '#preview_pane table']);
    },
    // Pool Transcoders full while L2 runs (start 6 work orders, see tools/figures/README.md): each slot held by a work step
    'pool-fully-reserved': async t => {
      await t.viewport(1600);
      await t.goto('/managed_resources');
      await t.page.locator('#pools-list >> text="Transcoders"').click();
      await t.page.waitForSelector('#preview_pane table');
      await t.page.waitForTimeout(1000);
      return t.elements(['#preview_pane .resources-header', '#preview_pane .resources-stats', '#preview_pane table']);
    },
    // Dashboard page Transcoding (tools/figures/practices/server-setup.rb): pool Transcoders full, items waiting in queue Transcoding.
    // Needs 6 running L2 work orders: pause the queue, start them, resume (see tools/figures/README.md)
    'queue-and-tokens-portlet': async t => {
      await t.viewport(1600, 1500);
      await t.goto('/frames/home?id=0');
      // dashboard page in the left menu (two copies of the menu overlap: follow the link)
      const href = await t.page.locator('#left_secondary_nav a[href*="frames/home?id="]', { hasText: 'Transcoding' }).first().getAttribute('href');
      await t.page.goto(new URL(href, t.page.url()).href);
      await t.page.waitForLoadState('networkidle');
      await t.page.waitForTimeout(6000);
      return t.elements(['div[id*="_subframe_"]'], { margin: 0 });
    },
    // High volume: workflow 1 adds the files to the queue and ends; workflow 2 takes them with a load manager that continues monitoring
    'two-workflows-add': async t => { await t.designer('Pattern - high volume 1 (add to queue)'); return t.nodes({ hide: ['Fail', 'Error'] }); },
    'two-workflows-process': async t => { await t.designer('Pattern - high volume 2 (process queue)'); return t.nodes({ hide: ['Error'] }); },
    // Variants of L2: same pattern with ResourceManager (legacy: 2 revisions before the last), fallback on a spare (before the last)
    'resource-manager-legacy': async t => { await t.revision('Asset ingest - L2 transcoding', 2); return t.nodes({ hide: ['Error'] }); },
    'resource-fallback': async t => { await t.revision('Asset ingest - L2 transcoding', 1); return t.nodes({ hide: ['Error'] }); },
    // Queues > Add New Queue: queue Transcoding of L2 (auto-purge on work order stop); creates it if missing
    'queue-auto-purge': async t => {
      await t.viewport(1600);
      await t.goto('/managed_queues');
      const exists = await t.page.locator('text="Transcoding"').count() > 0;
      await t.page.click('button:has-text("Add New Queue")');
      await t.page.waitForSelector('#managed_queue_name');
      await t.page.fill('#managed_queue_displayed_name', 'Transcoding');
      await t.page.fill('#managed_queue_name', 'Transcoding');
      await t.page.fill('#managed_queue_comments', 'Media files waiting for a transcoder');
      await t.page.click('#modal_dialog label[onclick*="group_selection"]');
      await t.page.waitForTimeout(500);
      for (const g of ['group_1', 'group_5']) await t.page.check(`#modal_dialog input[name="${g}"]`); // Administrator, Scheduler
      await t.page.click('#modal_dialog label[onclick*="group_selection"]'); // fold the list
      await t.page.selectOption('#modal_dialog select[name="managed_queue[originator_type]"]', 'WorkOrder');
      await t.page.waitForTimeout(500);
      const clip = await t.dialog();
      if (exists) return clip;
      return { clip, after: async () => { await t.page.click('#modal_dialog input[type="submit"]'); await t.page.waitForTimeout(2000); } };
    },
    // Load manager pattern of L2: add to queue, reserve, transcode, release if OK; failed and error exits through an OR to release if not OK
    'load-manager-pattern': async t => { await t.designer('Asset ingest - L2 transcoding'); return t.nodes({ hide: ['Error'] }); },
    // Configuration of the reserve step (global template Reserve transcoder)
    'load-manager-config': async t => {
      await t.designer('Asset ingest - L2 transcoding');
      await t.stepMenu('Reserve transcoder', 'Edit Action Template');
      await t.expandDialog();
      return t.dialog();
    },
    // Configuration of the add step: queue, action, queued item, description
    'queue-stager-config': async t => {
      await t.designer('Asset ingest - L2 transcoding');
      await t.stepMenu('Add to queue', 'Edit Action Template');
      await t.expandDialog();
      return t.dialog();
    },
    // Pattern - journals and alerts: first journal entry of the file (book, file, path, package, status, milestone)
    'journal-entry-config': async t => {
      await t.designer('Pattern - journals and alerts');
      await t.stepMenu('Journal received', 'Edit Action Template');
      await t.expandDialog();
      return t.dialog();
    },
    // Work Orders > Journals, book Media ingest, view by files: the failed file opened (information and events), then the next file.
    // Needs the runs of Pattern - journals and alerts (see tools/figures/README.md)
    'journals-view': async t => {
      await t.viewport(1600, 1100);
      await t.goto('/inline_journals');
      const book = await t.page.evaluate(() => [...document.querySelectorAll('option')].find(o => o.textContent.trim() === 'Media ingest').value);
      await t.goto(`/inline_journals?portlet_view=false&id=${book}`);
      await t.page.locator('text=View by Files').first().click();
      await t.page.waitForTimeout(1500);
      const cards = t.page.locator('[id^="accordion_"]');
      const failed = await cards.filter({ hasText: 'clip9.mp4' }).first().getAttribute('id');
      const id = failed.replace('accordion_', '');
      await t.page.locator(`[onclick="showListView('${id}')"]`).first().click();
      await t.page.waitForTimeout(1500);
      await t.page.locator(`[onclick="toggleJournalInfo('#file${id}')"]`).first().click();
      await t.page.waitForTimeout(1000);
      const next = await cards.nth(1).getAttribute('id');
      const clip = await t.elements(['#left_secondary_nav', `#${failed}`, `#${next}`], { margin: 0, bottom: `#${next}` });
      return { ...clip, width: clip.width + 12, height: clip.height + 8 }; // margin right and bottom (the menu starts at x 0)
    },
    // ... alert for the operators when the check fails
    'alert-entry-config': async t => {
      await t.designer('Pattern - journals and alerts');
      await t.stepMenu('Alert operators', 'Edit Action Template');
      await t.expandDialog();
      return t.dialog();
    },
    // Pattern - inline validation: the event of ascp (start, threshold, end) selects the check; each rejection sets the message for the user
    'inline-validation-workflow': async t => { await t.designer('Pattern - inline validation'); return t.nodes({ hide: ['Error'] }); },
    // Monitors: one tile per type of monitor, then the workflow monitors: Asset ingest watcher (workflow-monitor-config) running
    'monitors-view': async t => {
      await t.viewport(1600, 1100);
      await t.goto('/monitors');
      await t.page.waitForTimeout(3000);
      const clip = await t.elements(['#left_secondary_nav', '#main-content'], { margin: 0, bottom: 'text=/Showing \\d+ to \\d+ of/' });
      return { ...clip, height: clip.height + 24 };
    },
    // Monitors > Workflows > New: monitor of the trigger workflow Asset ingest (must run, auto-start with a work order name);
    // creates it if missing (it then starts Asset ingest: watch folders /data/ingest/partner_a, partner_b, studio)
    'workflow-monitor-config': async t => {
      await t.viewport(1600, 1100);
      await t.goto('/monitors');
      await t.page.waitForSelector('text=/Showing \\d+ to \\d+ of/'); // list loaded
      const exists = await t.page.getByText('Asset ingest watcher', { exact: true }).count() > 0;
      await t.page.locator('button:has-text("New") >> visible=true').first().click();
      await t.page.waitForSelector('#monitor_workflow_workflow_id');
      await t.page.fill('#monitor_workflow_workflow_name', 'Asset ingest watcher');
      await t.page.selectOption('#monitor_workflow_workflow_id', { label: 'AI_Demo: Asset ingest' });
      await t.page.waitForTimeout(1500); // runtime parameters of the workflow loaded in the auto-start section
      await t.page.fill('#monitor_workflow_refresh_rate', '60');
      await t.page.check('#monitor_workflow_must_run');
      await t.page.check('#monitor_workflow_auto_start');
      await t.page.waitForTimeout(500);
      await t.page.fill('input[name="auto_start_parameters[work_order_name]"]', 'Asset ingest watcher');
      await t.page.click('#modal_dialog h2'); // no focus ring
      await t.page.setViewportSize({ width: 1600, height: 2600 });
      await t.page.evaluate(() => document.querySelectorAll('#modal_dialog *').forEach(e => {
        if (getComputedStyle(e).overflowY !== 'visible') { e.style.maxHeight = 'none'; e.style.overflowY = 'visible'; }
      }));
      await t.page.waitForTimeout(500);
      const clip = await t.dialog();
      if (exists) return clip;
      return { clip, after: async () => { await t.page.click('#modal_dialog input[type="submit"][value="Save"]'); await t.page.waitForTimeout(2000); } };
    },
    // Inputs of the reserve step: Queue and Expected_queued_item mapped to the outputs of the add step
    'expected-queued-item': async t => {
      await t.designer('Asset ingest - L2 transcoding');
      await t.stepMenu('Reserve transcoder', 'Map Inputs');
      await t.widenDialog(1120);
      await t.expandDialog();
      await t.fitSelects('#map_inputs select', 320);
      return t.dialog({ bottom: '#map_inputs table' });
    },
    // First workflow: built in the designer by hand (see pattern-first-workflow.md), then these four figures
    // New Workflow dialog, filled (cancelled after the screenshot)
    'first-workflow-new': async t => {
      await t.viewport(1800);
      await t.goto(`/workflows?id=${t.folderId('Asset ingest')}`);
      await t.page.click('text=New Workflow');
      await t.page.waitForSelector('#modal_dialog input[name="workflow[name]"]');
      await t.page.fill('input[name="workflow[name]"]', 'Pattern - first workflow');
      await t.page.fill('textarea[name="workflow[description]"]', 'One CustomRuby step that returns a message.');
      await t.page.waitForTimeout(500);
      return { clip: await t.dialog(), after: async () => { await t.page.click('#modal_dialog >> text=Cancel'); } };
    },
    // The finished graph: Start, the step, Complete
    'first-workflow-graph': async t => { await t.designer('Pattern - first workflow'); return t.nodes({ hide: ['Fail', 'Error'] }); },
    // Edit Action Template of the step: output message, code
    'first-workflow-step': async t => {
      await t.designer('Pattern - first workflow');
      await t.stepMenu('Say hello', 'Edit Action Template');
      await t.expandDialog();
      return t.dialog({ bottom: '#modal_dialog label:text-is("Toggle editor")' });
    },
    // Work order Complete (run: Start in the Workflows list, or ascli orchestrator workflows start <id> @json:'{}')
    // (the work order, then a click on its step: status and outputs, message = Hello)
    'first-workflow-work-order': async t => {
      const id = t.lastWorkOrder('Pattern - first workflow', 'Complete');
      await t.workOrder(id);
      await t.page.locator(`#work_order_viewer_${id} .wo-steps-section >> text=Say hello`).first().click();
      await t.page.waitForTimeout(1500);
      return { x: 905, y: 245, width: 1255, height: 660 };
    },
  },
};
