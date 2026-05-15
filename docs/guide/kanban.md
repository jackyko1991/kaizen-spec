# Kanban Board

kaizen-spec generates a live kanban board at `.kaizen/board.html` during Phase 3. It reflects the real-time status of every agent working on your feature.

---

## Opening the Board

Once Phase 3 starts, open `.kaizen/board.html` in any browser. It auto-reloads every 5 seconds as agents update it.

Using VS Code Live Server or Python's built-in HTTP server gives smoother reloads:

```bash
# Option 1: Python
python3 -m http.server 8080 --directory .kaizen
# then open http://localhost:8080/board.html

# Option 2: VS Code Live Server extension
# Right-click board.html → "Open with Live Server"
```

---

## Columns

<div class="kb-guide-cols">
<div class="kb-guide-col" data-kb-tooltip="Backlog: All agreed specs waiting to be started. WIP limit is not enforced here. Tasks sit here until an In Progress slot opens.">
  <strong>Backlog</strong>
  <p>Tasks not yet started. No WIP limit.</p>
</div>
<div class="kb-guide-col" data-kb-tooltip="In Progress (一個流): Active implementation. WIP limit: 3. Exceeding the limit triggers Andon - the line stops until a slot opens. One-piece flow prevents multitasking waste (Muda).">
  <strong>In Progress</strong>
  <p>Agents actively working. WIP limit: <strong>3</strong>.</p>
</div>
<div class="kb-guide-col" data-kb-tooltip="Review (レビュー): Implementation done, tests green. Awaiting acceptance check and 5S cleanup (Seiso - 清掃). WIP limit: 2.">
  <strong>Review</strong>
  <p>Awaiting acceptance or merge. WIP limit: <strong>2</strong>.</p>
</div>
<div class="kb-guide-col" data-kb-tooltip="Done (完了 / 改善): All tests green, acceptance logged, docs written. Merged to main. Kaizen cycle complete.">
  <strong>Done</strong>
  <p>Complete and tests passing. No WIP limit.</p>
</div>
</div>

Cards move left-to-right as agents progress. You can also drag cards manually - the WIP limit is enforced client-side.

<style>
.kb-guide-cols {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 0.75rem;
  margin: 1rem 0;
}
@media (max-width: 640px) {
  .kb-guide-cols { grid-template-columns: repeat(2, 1fr); }
}
.kb-guide-col {
  position: relative;
  padding: 0.75rem 1rem;
  border: 1px solid var(--vp-c-divider);
  border-radius: 8px;
  background: var(--vp-c-bg-soft);
  cursor: help;
}
.kb-guide-col p {
  font-size: 0.82rem;
  color: var(--vp-c-text-2);
  margin: 0.25rem 0 0;
}
.kb-guide-col::after {
  content: attr(data-kb-tooltip);
  position: absolute;
  bottom: calc(100% + 6px);
  left: 0;
  z-index: 100;
  width: 240px;
  padding: 8px 10px;
  border-radius: 6px;
  background: rgba(13,17,23,0.93);
  color: #e6edf3;
  font-size: 11px;
  line-height: 1.5;
  white-space: normal;
  opacity: 0;
  pointer-events: none;
  transition: opacity 0.18s;
  border: 1px solid #30363d;
}
.kb-guide-col:hover::after { opacity: 1; }
</style>

---

## WIP Limits (Toyota Kanban)

WIP stands for "Work In Progress." Limiting WIP is a core Toyota Kanban principle: doing fewer things simultaneously means each thing gets done faster and with fewer mistakes.

**What you see:** When a column reaches its limit, the column header turns **red**. No new cards can be dragged in. Agents check `tasks.json` before claiming a new task - if the limit is reached, they wait.

**Why 3 for In Progress?** Three parallel agents is the default balance between parallelism and coordination overhead. You can change `wip_limits` in `.kaizen/tasks.json` to adjust.

---

## Andon Cord - Blocked Agents

In Toyota factories, any worker can pull an "Andon cord" to stop the production line when they spot a problem. kaizen-spec has an equivalent.

**What you see:** A blocked card displays a **⚠ BLOCKED** badge in red and a `border-danger` outline.

**What happened:** The agent hit a problem it cannot solve alone - a missing dependency, an unclear spec, an external API that is unreachable. It has:
1. Written its `blocked_reason` to `.kaizen/tasks.json`
2. Set the Andon flag on its board card
3. Logged a `WARN` entry to `.kaizen/kaizen.log`
4. Stopped working and is waiting

**What you do:** Read the `blocked_reason` in `tasks.json` or `kaizen.log`, resolve the issue, then update the task status back to `in-progress`. The skill will notify you when a blocker is set.

---

## Kaizen Log

The kaizen log at `.kaizen/kaizen.log` is an append-only record of everything that happened during the skill run. It uses syslog format - one structured line per event.

```
2026-05-14T10:23:45Z INFO [kaizen] phase=implementation task=task-001 agent=subagent-1 status=started
2026-05-14T10:31:02Z WARN [kaizen] phase=implementation task=task-001 agent=subagent-1 status=blocked reason="SortableJS CDN unreachable"
2026-05-14T10:35:18Z INFO [kaizen] phase=implementation task=task-001 agent=subagent-1 status=unblocked duration=256s
2026-05-14T10:48:33Z INFO [kaizen] phase=implementation task=task-001 agent=subagent-1 status=done duration=1488s
```

Read it after a run to spot patterns: where do agents get stuck? Which phases take longest? The log is machine-readable, so you can `grep`, `awk`, or pipe it into any log tool.

See [Kaizen Log Format](/reference/kaizen-log) for the full specification.

---

## Theming

The board respects your OS dark/light preference automatically. Use the **◐ Theme** toggle in the top-right corner to switch manually. Your preference is saved in `localStorage`.
