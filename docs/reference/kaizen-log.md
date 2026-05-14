# Kaizen Log Format

`.kaizen/kaizen.log` is an append-only, syslog-inspired structured log. Every state transition during a skill run is recorded here.

---

## Format

```
YYYY-MM-DDTHH:MM:SSZ SEVERITY [kaizen] key=value key="quoted value if spaces"
```

- **Timestamp**: ISO 8601, UTC, second precision
- **Severity**: `INFO`, `WARN`, or `ERROR` (uppercase)
- **Tag**: always `[kaizen]`
- **Key-value pairs**: space-separated, values with spaces must be double-quoted

---

## Severity Levels

| Level | When to use |
|---|---|
| `INFO` | Normal state transitions: task started, task done, tests passing |
| `WARN` | Recoverable problems: task blocked, WIP limit hit, test unexpectedly passing |
| `ERROR` | Unrecoverable failures: acceptance failed, spec missing |

---

## Standard Events

### Task started
```
2026-05-14T10:23:45Z INFO [kaizen] phase=implementation task=task-001 agent=subagent-1 status=started
```

### Task done
```
2026-05-14T10:48:33Z INFO [kaizen] phase=implementation task=task-001 agent=subagent-1 status=done duration=1488s
```

### Task blocked (Andon cord)
```
2026-05-14T10:31:02Z WARN [kaizen] phase=implementation task=task-001 agent=subagent-1 status=blocked reason="SortableJS CDN unreachable"
```

### Task unblocked
```
2026-05-14T10:35:18Z INFO [kaizen] phase=implementation task=task-001 agent=subagent-1 status=unblocked duration=256s
```

### WIP limit hit
```
2026-05-14T10:25:00Z WARN [kaizen] column=in-progress limit=3 attempted_task=task-004 status=queued
```

### Tests all red (Phase 2 complete)
```
2026-05-14T09:55:12Z INFO [kaizen] phase=test count=8 framework=playwright status=all-failing
```

### Tests all green (Phase 4 start)
```
2026-05-14T11:02:44Z INFO [kaizen] phase=acceptance count=8 framework=playwright status=all-passing duration=4972s
```

### Acceptance failed
```
2026-05-14T11:02:44Z ERROR [kaizen] phase=acceptance failed_count=2 reason="board WIP limit not enforced in Firefox"
```

### Spec aligned (Phase 1 complete)
```
2026-05-14T09:42:18Z INFO [kaizen] phase=spec feature="kanban-log-viewer" status=committed
```

### Doc written (Phase 5 complete)
```
2026-05-14T10:55:33Z INFO [kaizen] phase=docs feature="kanban-log-viewer" file="docs/guide/kanban-log-viewer.md" status=done
```

---

## Standard Keys

| Key | Type | Description |
|---|---|---|
| `phase` | string | `spec`, `test`, `implementation`, `acceptance`, `docs` |
| `task` | string | Task ID from `tasks.json` |
| `agent` | string | Agent identifier |
| `status` | string | `started`, `done`, `blocked`, `unblocked`, `failed`, `committed`, `all-failing`, `all-passing` |
| `duration` | string | Elapsed seconds, e.g. `1488s` |
| `reason` | string | Human-readable explanation (quote if contains spaces) |
| `count` | integer | Number of tests |
| `failed_count` | integer | Number of failing tests |
| `framework` | string | e.g. `playwright`, `pytest`, `vitest` |
| `column` | string | Kanban column name |
| `limit` | integer | WIP limit value |
| `attempted_task` | string | Task ID that was blocked by WIP limit |
| `feature` | string | Feature name (quote if contains spaces) |
| `file` | string | File path |

---

## Reading the Log

### Find all blockers in a run
```bash
grep 'status=blocked' .kaizen/kaizen.log
```

### Calculate total cycle time (spec to acceptance)
```bash
head -1 .kaizen/kaizen.log   # first entry timestamp
grep 'phase=acceptance.*status=all-passing' .kaizen/kaizen.log  # acceptance timestamp
```

### Count tasks completed per agent
```bash
grep 'status=done' .kaizen/kaizen.log | awk -F'agent=' '{print $2}' | awk '{print $1}' | sort | uniq -c
```

### View all errors
```bash
grep '^.*ERROR' .kaizen/kaizen.log
```

---

## Append-Only Rule

Agents **never** modify or delete existing lines. They only append. This means the log is a complete, immutable record of the run — safe to commit, safe to `git blame`, safe to pipe into log aggregators.
