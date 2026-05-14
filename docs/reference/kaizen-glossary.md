# Kaizen & Kanban Terminology
# 改善・看板 — 用語集

kaizen-spec is built on Toyota Production System philosophy. This page explains the terms
used throughout the skill and documentation, in English and Japanese.

---

## Kanban (看板) — The Science of Flow

Kanban (看板, "signboard") is a scheduling system for managing work flow. It is not just
cards on a board — it is a discipline for making work visible and limiting overload.

### WIP Limit — Work In Progress Limit (在製品限制)

**The soul of Kanban.** Limits how many tasks can be active at the same time. Prevents
the system from overloading itself. When a column is full, no new work enters — existing
work must finish first.

> "Stop starting, start finishing."

In kaizen-spec: the `wip_limits` field in `.kaizen/tasks.json` caps concurrent agents.
Exceeding the limit turns the board column red (安燈 — Andon signal).

---

### Lead Time — 交付周期時間

Total time from when a task is **created** to when it is **delivered**.

```
Lead Time = completed_at − created_at
```

Includes: time waiting in backlog + active work time. A long Lead Time means tasks are
sitting idle before an agent picks them up. Visible on each board card as **LT**.

---

### Cycle Time — 週期時間

Time from when work **starts** to when it is **done**.

```
Cycle Time = completed_at − started_at
```

Measures execution efficiency. `Lead Time − Cycle Time` = queue wait time (Muda of Waiting).
Visible on each board card as **CT**.

---

### Pull System — 引き取り / 拉式生産

Work is **pulled** by agents when they have capacity — never pushed at them regardless of
load. An agent picks the next backlog task only when its current task is done and a WIP
slot is free.

---

### Takt Time — タクト時間

The rate at which work must be delivered to meet demand.

```
Takt Time = Available time ÷ Number of user requests
```

Use kaizen.log Lead Time data to check whether your agent parallelism meets Takt Time.

---

### Heijunka — 平準化 (Level Loading)

Smoothing uneven work volume (Mura). kaizen-spec achieves this automatically through
WIP limits + the pull system: tasks process steadily at `wip_limits` tasks at a time
rather than in bursts.

---

### Bottleneck — ボトルネック

The slowest stage, which limits total throughput. If the Review column is always full
while Backlog grows, Review is the bottleneck — add capacity there before anywhere else.

---

## Kaizen (改善) — Eliminating Waste

Kaizen (改善, "change for the better") is continuous, incremental improvement. Not a
one-time event — a permanent operating mode.

---

### Muda — 無駄 (Waste)

Any activity that consumes resources without adding value. Seven types, mapped to
agentic development:

| Toyota Muda | Agentic equivalent | kaizen-spec mitigation |
|---|---|---|
| 過剰生産 Over-production | Code not in the spec | Phase 1 spec gate |
| 待機 Waiting | Agent idle waiting for input | Andon cord — surface blockers fast |
| 欠陥 Defects | Code failing tests or mismatching spec | TDD — Jidoka detects defects |
| 動作 Motion | Agent re-reading context it processed before | State in `.kaizen/` files |
| 運搬 Transport | Too many agents passing outputs between each other | Worktree isolation |
| 在庫 Inventory | Tasks piling up in backlog | WIP limits |
| 過剰処理 Over-processing | Full 5-phase ceremony for a trivial rename | SKIP guard |

The **5S cleanup** in Phase 4 removes Muda from code: dead code, redundant comments,
unused imports. Less code = less context to load = lower token cost for future agents.

---

### Mura — 斑 (Unevenness)

Irregular flow — 100 tasks one day, nothing the next. Heijunka (WIP limits + pull
system) is the remedy.

---

### Muri — 無理 (Overburden)

Pushing agents beyond capacity. Spawning 20 parallel agents when resources support 3
causes thrashing and degraded output. WIP limits prevent Muri directly.

---

## Combined & Advanced Terms

### Andon — 安燈 (Signal Light)

A visual stop signal. In Toyota factories, any worker pulls the Andon cord to halt
the production line when they detect a problem.

In kaizen-spec: a blocked agent sets `data-blocked="true"` on its board card, logs
a `WARN` to `kaizen.log`, and **stops**. The board shows a red **安燈 ⚠ BLOCKED** badge.
The Andon cord is also pulled automatically by the test suite when tests fail (Jidoka).

---

### Jidoka — 自働化 (Autonomation)

Automation with built-in defect intelligence. The machine detects anomalies and stops
rather than continuing to produce defective output.

**In kaizen-spec, Jidoka = the TDD cycle:**

| TDD phase | Jidoka role |
|---|---|
| Write failing test (Red) | Define what "defect" means |
| Run test suite | Machine autonomously detects defects |
| Test fails → CI stops | Andon pulled automatically |
| Implement (Green) | Fix under machine supervision |
| Refactor → retest | Confirm no regression |

A test that was never red has never proven it can detect the defect — and cannot be
trusted as a Jidoka sensor.

---

### Poka-Yoke — ポカヨケ (Mistake-Proofing)

Designing the system so errors are **impossible**, not just unlikely.

In kaizen-spec: `tasks.json` has a required schema; phase gates prevent code before
spec commit; WIP enforcement is structural (not advisory). These constraints are
Poka-Yoke — agents cannot accidentally bypass them.

In software: static typing, schema validation, and linting are Poka-Yoke.

---

### Genchi Genbutsu — 現地現物 (Go and See)

"Go to the actual place, see the actual thing." Never rely on summaries when
diagnosing a problem.

**Skill rule:** when a task is blocked or a test fails, agents must read the raw
stack trace / log line directly — not ask another agent to summarise it. The
**Gemba** (現場) is the actual error output, not a description of it.

---

### Gemba — 現場 (The Real Place)

Where value is actually created. For software: the running environment, the actual
test suite output, the actual `.kaizen/` state files. Not the agent's memory of events.

---

### Standard Work — 標準作業

The documented, agreed baseline for how work is done. Kaizen cannot improve an
unstandardised process. The `.kaizen/` directory structure is kaizen-spec's Standard Work.

---

### PDCA → TDD — 計画・実行・評価・改善

The Deming improvement cycle maps directly to TDD:

| PDCA | TDD |
|---|---|
| Plan (計画) | Write the failing test — define success |
| Do (実行) | Implement the code |
| Check (評価) | Run the test suite |
| Act (改善) | Refactor if green; fix and repeat if red |

---

### 5S — 職場環境整備

Workplace organisation discipline. Applied to code and agent context:

| 5S step | Japanese | Code / agent meaning |
|---|---|---|
| Sort | 整理 Seiri | Remove dead code, unused imports, stale comments |
| Set in order | 整頓 Seiton | Consistent naming, logical file organisation |
| Shine | 清掃 Seiso | Remove temp files, test artifacts, `.kaizen/*.tmp` |
| Standardize | 清潔 Seiketsu | Linting, type checking, schema validation |
| Sustain | 躾 Shitsuke | CI/CD enforces 5S on every merge |

kaizen-spec runs a 5S cleanup agent in Phase 4 after acceptance. Goal: remove Muda
from the codebase so future agent sessions load less context and cost fewer tokens.

---

## Quick Reference (術語対照表)

| Term | Kanji | kaizen-spec mapping |
|---|---|---|
| Andon | 安燈 | Blocked card badge + WARN log + agent stops |
| Poka-Yoke | ポカヨケ | Phase gates, tasks.json schema, WIP enforcement |
| Jidoka | 自働化 | TDD cycle — test suite auto-detects defects |
| Takt Time | タクト時間 | Delivery rate target (from kaizen.log Lead Times) |
| Genchi Genbutsu | 現地現物 | Read raw logs/stack traces directly |
| Gemba | 現場 | Running test suite + `.kaizen/` state files |
| Muda | 無駄 | Any work outside spec or dead code (removed by 5S) |
| Mura | 斑 | Uneven agent load — prevented by WIP limits |
| Muri | 無理 | Agent overload — prevented by WIP limits |
| Heijunka | 平準化 | Level loading — WIP limits + pull system |
| Standard Work | 標準作業 | The `.kaizen/` directory structure and schemas |
| Lead Time | 交付周期 | `created_at` → `completed_at` (shown on board as LT) |
| Cycle Time | 週期時間 | `started_at` → `completed_at` (shown on board as CT) |
| Bottleneck | ボトルネック | Column at WIP limit while backlog grows |
| Pull System | 引き取り | Agents self-assign from backlog when capacity exists |
| PDCA | 計画・実行・評価・改善 | TDD red→green→refactor cycle |
| 5S | 職場環境整備 | Post-acceptance cleanup: remove code Muda |
