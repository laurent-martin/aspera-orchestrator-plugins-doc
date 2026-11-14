#!/usr/bin/env node
// Captures figures of the documentation from the Orchestrator web UI.
//
// Usage: node tools/figures/capture.js <recipes file> <figure> [<figure>...]   (or: all)
//   e.g. node tools/figures/capture.js tools/figures/practices/shots.js launcher-in-fanout
//
// Each recipe (see tools/figures/practices/shots.js) opens a page and returns the area to capture
// (or { clip, after }: an action run after the screenshot, e.g. create the object shown in the dialog).
// The image is written to <out dir of the recipes file>/<version>/<figure>.png,
// and the Orchestrator version (footer of the web UI) is written in the PNG metadata.
// Credentials: preset ORCH_PRESET of ascli (~/.aspera/ascli/config.yaml), or ORCH_URL, ORCH_USER, ORCH_PASSWORD.
const fs = require('fs');
const path = require('path');
const { execFileSync } = require('child_process');
const { chromium } = require('playwright-core');

const ASCLI = process.env.ASCLI || 'ascli';
// default viewport: wide enough for the designer canvas; recipes of list pages set a narrower one
const VIEWPORT = { width: 2200, height: 1300 };

function credentials() {
  if (process.env.ORCH_URL) return { url: process.env.ORCH_URL, user: process.env.ORCH_USER, pass: process.env.ORCH_PASSWORD };
  const y = fs.readFileSync(path.join(process.env.HOME, '.aspera/ascli/config.yaml'), 'utf8');
  const preset = process.env.ORCH_PRESET;
  if (!preset) throw new Error('set ORCH_PRESET (preset of ascli) or ORCH_URL, ORCH_USER and ORCH_PASSWORD');
  const block = y.match(new RegExp(`^${preset}:\\n((?: {2}.*\\n)+)`, 'm'))[1];
  const get = k => block.match(new RegExp(`^  ${k}: (.*)$`, 'm'))[1].trim().replace(/^["']|["']$/g, '');
  return { url: get('url'), user: get('username'), pass: get('password') };
}

// Centers of the ports of the nodes of the designer, from the position [x, y] of the node (spec coordinates)
const PORT = {
  stepIn: ([x, y]) => [x + 7, y + 52],
  stepOut: ([x, y]) => [x + 121, y + 52],
  stepFailed: ([x, y]) => [x + 47, y + 107],
  stepError: ([x, y]) => [x + 23, y + 107],
  startOut: ([x, y]) => [x + 81, y + 31],
  endIn: ([x, y]) => [x - 6, y + 33],
  orIn: ([x, y]) => [x + 7, y + 38],
  orOut: ([x, y]) => [x + 71, y + 38],
};

let workflows;
function workflow(name) {
  workflows ||= Object.fromEntries(JSON.parse(execFileSync(ASCLI, ['orchestrator', 'workflows', 'list', '--format=json', '--fields=id,name,folder_id'])).map(w => [w.name, w]));
  if (!(name in workflows)) throw new Error(`workflow not found: ${name}`);
  return workflows[name];
}
const workflowId = name => workflow(name).id;

// Helpers given to recipes
class Tools {
  constructor(page, base) { this.page = page; this.base = base; this.PORT = PORT; }
  async viewport(width, height = 1000) { await this.page.setViewportSize({ width, height }); }
  // Id of the last work order of a workflow (optionally with this status)
  lastWorkOrder(name, status) {
    const list = JSON.parse(execFileSync(ASCLI, ['orchestrator', 'workflows', 'workorders', String(workflowId(name)), '--format=json', '--fields=id,status']));
    const ids = list.filter(w => !status || w.status === status).map(w => Number(w.id));
    if (ids.length === 0) throw new Error(`no work order of ${name}: run it first (see tools/figures/README.md)`);
    return Math.max(...ids);
  }
  // Opens a work order in the Work Orders page (right pane); returns the area of the pane down to the end of its steps
  async workOrder(id) {
    await this.goto('/work_orders');
    await this.page.evaluate(url => wojs.selectWorkOrder(url), `${new URL(this.base).pathname}/work_orders/${id}`);
    await this.page.waitForSelector(`#work_order_viewer_${id} .wo-steps-section`);
    await this.page.mouse.move(5, 5);
    await this.page.waitForTimeout(1000);
    return this.elements([`#work_order_viewer_${id} .wrap_preview_fixed`, `#work_order_viewer_${id} .wo-steps-section`], { margin: 4 });
  }
  workflowId(name) { return workflowId(name); }
  folderId(name) { return workflow(name).folder_id; }
  // Area covering the elements matched by the selectors (all matches), cut at the right or bottom edge of element `right`, `bottom`
  async elements(selectors, { margin = 8, right, bottom } = {}) {
    let b = null;
    for (const sel of [].concat(selectors)) {
      for (const el of await this.page.locator(sel).all()) {
        const r = await el.boundingBox();
        if (!r || !r.width) continue;
        b = b ? { l: Math.min(b.l, r.x), t: Math.min(b.t, r.y), r: Math.max(b.r, r.x + r.width), b: Math.max(b.b, r.y + r.height) } : { l: r.x, t: r.y, r: r.x + r.width, b: r.y + r.height };
      }
    }
    if (!b) throw new Error(`no element for ${selectors}`);
    if (right) { const r = await this.page.locator(right).first().boundingBox(); b.r = r.x + r.width; }
    if (bottom) { const r = await this.page.locator(bottom).first().boundingBox(); b.b = r.y + r.height; }
    return { x: b.l - margin, y: b.t - margin, width: b.r - b.l + 2 * margin, height: b.b - b.t + 2 * margin };
  }
  async goto(p) { await this.page.goto(this.base + p); await this.page.waitForLoadState('networkidle'); }
  // Opens a workflow in the designer
  // (the plugin panel is not collapsed: draw2d keeps the position of the canvas, clicks on links would be shifted)
  async designer(name) {
    await this.goto(`/workflows/${workflowId(name)}/edit`);
    await this.page.waitForSelector('#paintarea > div[id]:not(#exception_div)');
    await this.page.waitForTimeout(1000);
  }
  // Opens a revision of a workflow, read-only, drawn like the designer: back = 0 for the last revision, 1 for the one before...
  // (workflows with variants: variant k of n is the revision n - 1 - k from the last)
  async revision(name, back = 0) {
    await this.goto(`/workflows/${workflowId(name)}/list_all_versions`);
    const links = await this.page.evaluate(() => [...document.querySelectorAll('a')]
      .map(a => a.getAttribute('href') || '').filter(h => /\/whiteboards\/\d+$/.test(h)));
    // listed from the last revision to the first
    if (back >= links.length) throw new Error(`workflow ${name} has ${links.length} revisions`);
    await this.page.goto(new URL(links[back], this.page.url()).href);
    await this.page.waitForSelector('#paintarea > div[id]:not(#exception_div)');
    await this.page.waitForTimeout(1500);
  }
  // Scrolls the body of the modal dialog so that the element with this text (a section title) is at the top (no text: the end)
  async scrollDialogTo(text) {
    await this.page.evaluate(text => {
      const body = document.querySelector('#modal_dialog .modal-body');
      if (!text) { body.scrollTop = body.scrollHeight; return; } // no text: to the end
      const el = [...body.querySelectorAll('*')].find(e => e.children.length === 0 && e.textContent.trim() === text);
      if (!el) throw new Error(`no ${text} in dialog`);
      body.scrollTop += el.getBoundingClientRect().top - body.getBoundingClientRect().top - 16;
    }, text);
    await this.page.waitForTimeout(300);
  }
  // Shows the whole body of the modal dialog, without scroll bar (its maximum height is fixed): taller viewport, no maximum height
  async expandDialog() {
    const h = await this.page.evaluate(() => document.querySelector('#modal_dialog .modal-body').scrollHeight);
    await this.page.setViewportSize({ width: VIEWPORT.width, height: Math.max(VIEWPORT.height, h + 600) });
    await this.page.evaluate(() => { document.querySelector('#modal_dialog .modal-body').style.maxHeight = 'none'; });
    await this.page.waitForTimeout(500);
  }
  // Selects a tab of the step dialog: edit_template, map_inputs, map_outputs, set_timeout, set_failed_retry, set_error_retry,
  // set_journals, document_template, set_milestone
  async dialogTab(name) {
    await this.page.click(`#modal_dialog a[href="#${name}"]`);
    await this.page.waitForTimeout(800);
  }
  // Area of the modal dialog, with its close button and the tooltip shown, if any
  async dialog({ bottom } = {}) {
    return this.elements(['#wrap_modal_dialog', '#wrap_modal_dialog .close_button', '.tooltip'], { margin: 2, bottom });
  }
  // Sets the width of the modal dialog (CSS pixels), e.g. to fit wider selects
  async widenDialog(width) {
    await this.page.evaluate(width => ['#wrap_modal_dialog', '#modal_dialog'].forEach(s => { document.querySelector(s).style.setProperty('width', `${width}px`, 'important'); }), width);
    await this.page.waitForTimeout(300);
  }
  // Widens the selects matched by the selector (width in CSS pixels; default: the width of their selected text)
  async fitSelects(selector, width) {
    await this.page.locator(selector).evaluateAll((list, width) => list.forEach(e => { e.style.width = width ? `${width}px` : 'auto'; e.style.maxWidth = 'none'; }), width);
    await this.page.waitForTimeout(300);
  }
  // Resizes the text areas matched by the selector to show all their text (like the resize handle)
  async fitTextareas(selector) {
    await this.page.locator(selector).evaluateAll(list => list.forEach(e => { e.style.height = `${e.scrollHeight + 4}px`; }));
  }
  // Screen box of the node of a step in the designer (the node is the div at the position of its label, below it)
  async stepBox(stepName) {
    return this.page.evaluate(name => {
      const tops = [...document.querySelectorAll('#paintarea > div[id]')];
      const label = tops.find(e => e.innerText.trim() === name);
      if (!label) throw new Error(`step not found: ${name}`);
      // the node is just below its label; a long label may be shifted left
      const below = tops.filter(e => e !== label && e.offsetWidth > 30 && parseInt(e.style.top) - parseInt(label.style.top) === 3);
      const node = below.sort((a, b) => Math.abs(parseInt(a.style.left) - parseInt(label.style.left)) - Math.abs(parseInt(b.style.left) - parseInt(label.style.left)))[0];
      const r = node.getBoundingClientRect();
      return { x: r.left, y: r.top, width: r.width, height: r.height };
    }, stepName);
  }
  // Screen box of the node of the designer at canvas position x, y (spec coordinates): terminal node, OR, parameter
  async nodeBox(x, y) {
    return this.page.evaluate(([x, y]) => {
      const node = [...document.querySelectorAll('#paintarea > div[id]')].find(e => parseInt(e.style.left) === x && parseInt(e.style.top) === y && e.offsetWidth > 30);
      if (!node) throw new Error(`no node at ${x}, ${y}`);
      const r = node.getBoundingClientRect();
      return { x: r.left, y: r.top, width: r.width, height: r.height };
    }, [x, y]);
  }
  // Screen point of a canvas point (spec coordinates)
  async toScreen([x, y]) {
    const off = await this.page.evaluate(() => {
      const n = [...document.querySelectorAll('#paintarea > div[id]')].find(e => e.style.left && e.style.left !== '0px' && e.offsetWidth > 30);
      const r = n.getBoundingClientRect();
      return { x: r.left - parseInt(n.style.left), y: r.top - parseInt(n.style.top) };
    });
    return { x: x + off.x, y: y + off.y };
  }
  // Deletes the link whose ends are at the canvas points from and to (ports, see PORT), as a user: click on it, key Delete
  async deleteLink(from, to) {
    const [a, b] = [await this.toScreen(from), await this.toScreen(to)];
    const point = await this.page.evaluate(([a, b]) => {
      const near = (p, q) => Math.abs(p.x - q.x) < 14 && Math.abs(p.y - q.y) < 14;
      for (const link of document.querySelectorAll('#paintarea > div[id]')) {
        if (link.style.width !== '0px') continue;
        const segs = [...link.querySelectorAll('div div')].map(d => d.getBoundingClientRect()).filter(r => r.width || r.height);
        if (segs.length === 0) continue;
        const ends = segs.flatMap(r => [{ x: r.left, y: r.top + r.height / 2 }, { x: r.right, y: r.top + r.height / 2 }, { x: r.left + r.width / 2, y: r.top }, { x: r.left + r.width / 2, y: r.bottom }]);
        if (!ends.some(p => near(p, a)) || !ends.some(p => near(p, b))) continue;
        // click on the segment at the source end: the middle of a link can be taken for another one (hit test of draw2d)
        const touches = (r, p) => [{ x: r.left, y: r.top + r.height / 2 }, { x: r.right, y: r.top + r.height / 2 }, { x: r.left + r.width / 2, y: r.top }, { x: r.left + r.width / 2, y: r.bottom }].some(q => near(q, p));
        const s = segs.find(r => touches(r, a));
        return { x: s.left + s.width / 2, y: s.top + s.height / 2 };
      }
      return null;
    }, [a, b]);
    if (!point) throw new Error(`no link from ${from} to ${to}`);
    if (process.env.DEBUG) console.log("deleteLink", a, b, point);
    await this.page.mouse.click(point.x, point.y);
    await this.page.waitForTimeout(300);
    if (process.env.DEBUG) await this.page.screenshot({ path: `${process.env.DEBUG}/deletelink.png` });
    await this.page.keyboard.press('Delete');
    await this.page.waitForTimeout(500);
  }
  // Draws a link from a port to a port (canvas points), as a user: drag
  async drawLink(from, to) {
    const [a, b] = [await this.toScreen(from), await this.toScreen(to)];
    await this.page.mouse.move(a.x, a.y);
    await this.page.mouse.down();
    await this.page.mouse.move((a.x + b.x) / 2, (a.y + b.y) / 2 + 5, { steps: 10 });
    await this.page.mouse.move(b.x, b.y, { steps: 10 });
    await this.page.mouse.up();
    await this.page.waitForTimeout(500);
  }
  // Drags an item of the plugin palette (left panel) to the canvas point; returns the canvas position [x, y] of the new node
  async dropFromPalette(label, to) {
    const positions = () => this.page.evaluate(() => [...document.querySelectorAll('#paintarea > div[id]')]
      .filter(e => e.offsetWidth > 30 && e.style.left).map(e => `${parseInt(e.style.left)},${parseInt(e.style.top)}`));
    const before = await positions();
    const item = this.page.locator(`text="${label}"`).first();
    const r = await item.boundingBox();
    const b = await this.toScreen(to);
    await this.page.mouse.move(r.x + r.width / 2, r.y + r.height / 2);
    await this.page.mouse.down();
    await this.page.mouse.move(b.x, b.y, { steps: 15 });
    await this.page.mouse.up();
    await this.page.waitForTimeout(800);
    const added = (await positions()).filter(p => !before.includes(p));
    if (added.length !== 1) throw new Error(`dropped ${label}: ${added.length} new nodes`);
    return added[0].split(',').map(Number);
  }
  // Drags the node at canvas position from to canvas position to, as a user; returns the new position
  async moveNode(from, to) {
    const b = await this.nodeBox(...from);
    const [x, y] = [b.x + b.width / 2, b.y + b.height / 2];
    await this.page.mouse.move(x, y);
    await this.page.mouse.down();
    await this.page.mouse.move(x + to[0] - from[0], y + to[1] - from[1], { steps: 15 });
    await this.page.mouse.up();
    await this.page.waitForTimeout(500);
    const positions = await this.page.evaluate(() => [...document.querySelectorAll('#paintarea > div[id]')]
      .filter(e => e.offsetWidth > 30 && e.style.left).map(e => [parseInt(e.style.left), parseInt(e.style.top)]));
    if (!positions.some(p => p[0] === to[0] && p[1] === to[1])) throw new Error(`moved ${from} to ${to}: nodes at ${positions.join(' ')}`);
    return to;
  }
  // Double-click on the OR at canvas position, and sets its value ("n of m")
  async setOperator(position, value) {
    const b = await this.nodeBox(...position);
    await this.page.mouse.click(b.x + 12, b.y + 12);
    await this.page.waitForTimeout(300);
    await this.page.mouse.dblclick(b.x + 12, b.y + 12);
    await this.page.waitForSelector('.swal2-popup');
    await this.page.fill('.swal2-popup input', String(value));
    await this.page.click('.swal2-confirm');
    await this.page.waitForTimeout(500);
  }
  // Click on an empty point of the canvas: no selection
  async deselect(point = [10, 10]) {
    const p = await this.toScreen(point);
    await this.page.mouse.click(p.x, p.y);
    await this.page.waitForTimeout(300);
  }
  // Right-click on a step and select an item of its menu
  async stepMenu(stepName, item) {
    const b = await this.stepBox(stepName);
    await this.page.mouse.click(b.x + 40, b.y + 40, { button: 'right' });
    await this.page.locator(`text=${item}`).first().click();
    await this.page.waitForTimeout(1500);
  }
  // Area covering the nodes and links of the designer whose canvas position (spec coordinates) is in
  // region [x0, y0, x1, y1] (default: all), and in none of the exclude regions.
  // hide: terminal nodes to hide, e.g. ['Fail', 'Error'] when they are not linked.
  async nodes({ region = [-1e6, -1e6, 1e6, 1e6], exclude = [], hide = [], margin = 16 } = {}) {
    const box = await this.page.evaluate(([region, exclude, hide]) => {
      const inside = (x, y, [x0, y0, x1, y1]) => x >= x0 && x <= x1 && y >= y0 && y <= y1;
      const keep = (x, y) => inside(x, y, region) && !exclude.some(r => inside(x, y, r));
      const tops = [...document.querySelectorAll('#paintarea > div[id]')].filter(e => e.id !== 'exception_div');
      // a link is a div at 0,0 of size 0 holding its line segments
      const isLink = e => e.style.left === '0px' && e.style.top === '0px' && e.style.width === '0px';
      const ref = tops.find(e => e.style.left && !isLink(e));
      const ox = ref.getBoundingClientRect().left - parseInt(ref.style.left);
      const oy = ref.getBoundingClientRect().top - parseInt(ref.style.top);
      let b = null;
      const add = r => {
        if (r.width === 0 || r.height === 0) return;
        b = b ? { l: Math.min(b.l, r.left), t: Math.min(b.t, r.top), r: Math.max(b.r, r.right), b: Math.max(b.b, r.bottom) } : { l: r.left, t: r.top, r: r.right, b: r.bottom };
      };
      for (const e of tops) {
        if (hide.some(k => e.style.backgroundImage.includes(`/${k}-modern`))) { e.style.visibility = 'hidden'; continue; }
        if (isLink(e)) {
          for (const d of e.querySelectorAll('div')) {
            const r = d.getBoundingClientRect();
            if (keep((r.left + r.right) / 2 - ox, (r.top + r.bottom) / 2 - oy)) add(r);
          }
          continue;
        }
        const x = parseInt(e.style.left), y = parseInt(e.style.top);
        if (isNaN(x) || !keep(x, y)) continue;
        // include the descendants: labels and icons may overflow the node
        for (const d of [e, ...e.querySelectorAll('*')]) add(d.getBoundingClientRect());
      }
      return b;
    }, [region, exclude, hide]);
    if (!box) throw new Error('no node in region');
    return { x: box.l - margin, y: box.t - margin, width: box.r - box.l + 2 * margin, height: box.b - box.t + 2 * margin };
  }
}

(async () => {
  const [recipesFile, ...figures] = process.argv.slice(2);
  const recipes = require(path.resolve(recipesFile));
  const outRoot = path.resolve(path.dirname(recipesFile), recipes.outDir);
  const c = credentials();
  const browser = await chromium.launch({ channel: 'chrome', headless: true });
  const context = await browser.newContext({ viewport: VIEWPORT, deviceScaleFactor: 2, ignoreHTTPSErrors: true });
  const page = await context.newPage();
  await page.goto(c.url + '/logon');
  await page.fill('input[name="login"]', c.user);
  await page.fill('input[name="password"]', c.pass);
  await Promise.all([page.waitForNavigation(), page.press('input[name="password"]', 'Enter')]);
  const footer = await page.textContent('body');
  const version = footer.match(/v(\d+\.\d+\.\d+)\.(\d+)/);
  if (!version) throw new Error('Orchestrator version not found in footer');
  const outDir = path.join(outRoot, version[1]);
  fs.mkdirSync(outDir, { recursive: true });
  for (const fig of figures[0] === 'all' ? Object.keys(recipes.shots) : figures) {
    if (!recipes.shots[fig]) throw new Error(`no recipe for ${fig}`);
    await page.setViewportSize(VIEWPORT);
    // a recipe returns the area, or { clip, after }: after is run once the screenshot is taken (e.g. save the dialog shown)
    const result = await recipes.shots[fig](new Tools(page, c.url));
    const { clip, after } = result.clip ? result : { clip: result };
    const file = path.join(outDir, `${fig}.png`);
    await page.screenshot({ path: file, clip });
    if (after) await after();
    execFileSync('exiftool', ['-q', '-overwrite_original',
      `-PNG:Software=IBM Aspera Orchestrator ${version[1]}.${version[2]}`,
      `-PNG:Source=${recipesFile} ${fig}`,
      // 400 DPI (15748 pixels per meter): size of the picture in the PDF documents, 2x captures at 60% of their natural size
      '-PNG:PixelsPerUnitX=15748', '-PNG:PixelsPerUnitY=15748', '-PNG:PixelUnits=meters', file]);
    console.log(`${file} (${Math.round(clip.width)}x${Math.round(clip.height)})`);
  }
  await browser.close();
})().catch(e => { console.error(e); process.exit(1); });
