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

| Column | Meaning | WIP limit |
|---|---|---|
| Backlog | Tasks not yet started | None |
| In Progress | Agents actively working | **3** |
| Review | Awaiting review or merge | **2** |
| Done | Complete and tests passing | None |

Cards move left-to-right as agents progress. You can also drag cards manually — the WIP limit is enforced client-side.

---

## WIP Limits (Toyota Kanban)

WIP stands for "Work In Progress." Limiting WIP is a core Toyota Kanban principle: doing fewer things simultaneously means each thing gets done faster and with fewer mistakes.

**What you see:** When a column reaches its limit, the column header turns **red**. No new cards can be dragged in. Agents check `tasks.json` before claiming a new task — if the limit is reached, they wait.

**Why 3 for In Progress?** Three parallel agents is the default balance between parallelism and coordination overhead. You can change `wip_limits` in `.kaizen/tasks.json` to adjust.

---

## Andon Cord — Blocked Agents

In Toyota factories, any worker can pull an "Andon cord" to stop the production line when they spot a problem. kaizen-spec has an equivalent.

**What you see:** A blocked card displays a **⚠ BLOCKED** badge in red and a `border-danger` outline.

**What happened:** The agent hit a problem it cannot solve alone — a missing dependency, an unclear spec, an external API that is unreachable. It has:
1. Written its `blocked_reason` to `.kaizen/tasks.json`
2. Set the Andon flag on its board card
3. Logged a `WARN` entry to `.kaizen/kaizen.log`
4. Stopped working and is waiting

**What you do:** Read the `blocked_reason` in `tasks.json` or `kaizen.log`, resolve the issue, then update the task status back to `in-progress`. The skill will notify you when a blocker is set.

---

## Kaizen Log

The kaizen log at `.kaizen/kaizen.log` is an append-only record of everything that happened during the skill run. It uses syslog format — one structured line per event.

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
