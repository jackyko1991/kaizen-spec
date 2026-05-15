# State Schema

All kaizen-spec state is stored in `.kaizen/` at the root of your project. Every file is git-tracked. Agents reconstruct full context from these files alone - no shared memory required.

---

## Directory Layout

```
.kaizen/
  spec.md           - agreed feature spec (written in Phase 1)
  test-strategy.md  - test framework + failing test list (written in Phase 2)
  tasks.json        - task list, status, WIP limits (written in Phase 3)
  board.html        - live kanban board (updated throughout Phase 3)
  kaizen.log        - syslog-format event log (appended throughout)
```

---

## `tasks.json`

```json
{
  "feature": "string - feature name from spec",
  "spec_committed": "ISO8601 timestamp | null",
  "tasks": [
    {
      "id": "string - e.g. task-001",
      "title": "string - short human-readable task title",
      "phase": "spec | test | impl | acceptance | docs",
      "status": "backlog | in-progress | blocked | done",
      "agent": "string | null - agent identifier when claimed",
      "wip_column": "backlog | in-progress | review | done",
      "blocked_reason": "string | null - plain-text reason if status=blocked",
      "started_at": "ISO8601 | null",
      "completed_at": "ISO8601 | null"
    }
  ],
  "wip_limits": {
    "in-progress": 3,
    "review": 2
  }
}
```

### Field notes

| Field | Notes |
|---|---|
| `id` | Stable across the run. Never reuse IDs. |
| `status` | `blocked` is a sub-state of `in-progress` - the agent has claimed the task but cannot proceed. |
| `wip_column` | Mirrors `status` but tracks the board column. Usually the same as `status`. |
| `blocked_reason` | Required when `status=blocked`. Plain text, no length limit. |
| `wip_limits` | Change these to adjust parallelism. Restart Phase 3 after changing. |

### Atomic writes

Agents must write `tasks.json` atomically to avoid corruption under concurrent access:

```bash
# Write to temp file, then rename (atomic on Linux/macOS)
cp .kaizen/tasks.json .kaizen/tasks.json.bak
# ... modify in memory ...
cat > .kaizen/tasks.json.tmp << 'EOF'
{ ... updated content ... }
EOF
mv .kaizen/tasks.json.tmp .kaizen/tasks.json
```

---

## `spec.md`

Written by the orchestrator at the end of Phase 1. Free-form markdown, but must contain these sections:

| Section | Required | Purpose |
|---|---|---|
| `## Intent` | Yes | One paragraph: what problem this solves |
| `## Target Output` | Yes | The concrete deliverable |
| `## In Scope` | Yes | What the feature will do |
| `## Out of Scope` | Yes | What it will explicitly not do |
| `## Risks / Unknowns` | Yes | Known dependencies or unknowns |
| `## Acceptance Criterion` | Yes | Must reference `test-strategy.md` |

---

## `test-strategy.md`

Written by the test-writer agent at the end of Phase 2. Must contain:

| Section | Required | Purpose |
|---|---|---|
| Framework + install command | Yes | Reproducible test setup |
| Run command | Yes | Exact command to run all tests |
| Test list table | Yes | One row per test: name, what it covers, file path |
| Status line | Yes | "All failing (red) ✓" before implementation |

---

## `board.html`

A self-contained HTML file. No build step. Served directly from the filesystem or any static HTTP server.

Key HTML attributes used by agents:

| Attribute | Element | Purpose |
|---|---|---|
| `data-status` | `.column-body` | Identifies the column (backlog, in-progress, review, done) |
| `data-wip-limit` | `.column-body` | WIP cap for this column (0 = unlimited) |
| `data-task-id` | `.kaizen-card` | Links card to `tasks.json` task ID |
| `data-blocked` | `.kaizen-card` | `"true"` triggers Andon badge rendering |

See [Kanban Board](/guide/kanban) for usage details.
