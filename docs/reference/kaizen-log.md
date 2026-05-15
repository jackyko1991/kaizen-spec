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

## Compliance Mode

When a project is subject to a regulatory standard (ISO 13485, IEC 62443, ISO 9001, FDA 21 CFR Part 11, DO-178C, IEC 61508, or similar), set `"compliance_mode": true` in `.kaizen/tasks.json`. Every log line then carries additional structured fields required for traceability audits.

### Activating compliance mode

In Phase 1 Q5, select **"Regulatory / compliance requirements"** and name the applicable standard(s) and clauses. The orchestrator records them in the spec and sets the flag.

### Additional fields (compliance mode only)

| Key | Description | Example |
|---|---|---|
| `requirement_id` | Standard clause this event satisfies | `ISO13485-7.3.2`, `IEC62443-4-1-SD-2`, `DO178C-A.5` |
| `change_type` | Nature of the change | `design-input`, `design-output`, `verification`, `validation`, `review`, `code-change` |
| `actor` | Agent ID performing the work; append `review:human` when human oversight occurred | `agent:subagent-1`, `agent:subagent-1 review:human` |
| `artifact` | File path and git commit hash of the affected output | `spec.md@abc1234`, `src/auth.ts@def5678` |
| `justification` | Pointer to the requirement that motivated the change | `spec.md#intent`, `tasks.json#task-003` |

### Standard mapping reference

| Standard | Domain | Key phases that need logging |
|---|---|---|
| ISO 13485 | Medical device software | Design input (§7.3.2), Design output (§7.3.3), Verification (§7.3.5), Validation (§7.3.6), Review (§7.3.4) |
| IEC 62443-4-1 | Industrial cybersecurity | Security requirements (SR), Design (SD), Implementation (SI), Verification (SV) |
| ISO 9001 | General quality management | Design planning (§8.3.2), Design review (§8.3.4), Design verification (§8.3.5) |
| FDA 21 CFR Part 11 | Electronic records (pharma/medical) | All audit trail events with actor identity and timestamp |
| DO-178C | Airborne software | Software Development Plan activities, each verification activity |
| IEC 61508 | Functional safety | Safety lifecycle phases - each must be traceable to a SIL requirement |

### Compliance log examples

**ISO 13485 - medical device design verification:**
```
2026-05-14T10:48:33Z INFO [kaizen] phase=implementation task=task-003 agent=subagent-1 status=done cycle_time=1488s lead_time=1531s change_type=design-output requirement_id=ISO13485-7.3.3 actor="agent:subagent-1 review:human" artifact="src/device_driver.py@def5678" justification="spec.md#in-scope"
2026-05-14T11:02:44Z INFO [kaizen] phase=acceptance count=14 status=done change_type=verification requirement_id=ISO13485-7.3.5 actor="agent:orchestrator review:human" artifact="tests/device.spec.ts@ghi9012" justification="spec.md#acceptance-criterion"
```

**IEC 62443-4-1 - industrial control system security:**
```
2026-05-14T09:42:18Z INFO [kaizen] phase=spec feature="auth-hardening" status=committed change_type=design-input requirement_id=IEC62443-4-1-SR-1 actor="agent:orchestrator review:human" artifact="spec.md@abc1234" justification="threat-model#SR-1"
```

**FDA 21 CFR Part 11 - electronic records audit trail:**
```
2026-05-14T10:23:45Z INFO [kaizen] phase=implementation task=task-001 agent=subagent-1 status=started change_type=code-change requirement_id=21CFR11-11.10e actor="agent:subagent-1" artifact="src/audit_trail.py@abc1234" justification="spec.md#intent"
```

### Compliance fields are additive

Standard log consumers ignore unknown keys - the base format is unchanged. Tools that parse `kaizen.log` without compliance awareness continue to work; compliance-aware tools gain the additional fields for traceability reports.

---

## Append-Only Rule

Agents **never** modify or delete existing lines. They only append. This means the log is a complete, immutable record of the run - safe to commit, safe to `git blame`, safe to pipe into log aggregators, and suitable as a regulatory audit trail.
