# Kaizen-Spec Terminology Reference
# 改善仕様 - 用語集

This file is loaded by agents when they need to understand the philosophy behind
kaizen-spec's design decisions. Terms are given in English, Japanese romanisation,
and kanji where applicable.

---

## Part 1 - Kanban (看板): The Science of Flow

Kanban (看板) means "signboard" or "visual card." It is a scheduling system for
managing the flow of work. kaizen-spec uses it to manage agent workloads.

---

### WIP Limit - Work In Progress Limit (在製品限制)

**The soul of Kanban.** Limits the number of tasks that can be simultaneously
active. Prevents the system from overloading itself.

In kaizen-spec: the `wip_limits` field in `tasks.json` caps how many implementation
agents run concurrently. Exceeding the limit turns the board column red.

> "Stop starting, start finishing." - core Kanban principle

| Context | WIP Limit applies to |
|---|---|
| Toyota factory | Machines per station |
| Software team | Stories in progress |
| kaizen-spec | Concurrent LLM agent instances |

---

### Lead Time - 交付周期時間

**Total time from task creation to delivery.**

- Starts when: task enters `tasks.json` with status `backlog` (`created_at` timestamp)
- Ends when: task reaches status `done` (`completed_at` timestamp)
- Includes: waiting time in backlog + active work time

Formula: `Lead Time = completed_at − created_at`

In kaizen.log: logged as `lead_time` on the task-done event.

Long Lead Time indicates: too many tasks queued, WIP limits too high, or blocked
agents not being unblocked quickly enough.

---

### Cycle Time - 週期時間

**Time from work started to work done.**

- Starts when: agent claims task (`started_at` timestamp, status → in-progress)
- Ends when: task done (`completed_at`)

Formula: `Cycle Time = completed_at − started_at`

In kaizen.log: logged as `duration` on the task-done event.

Cycle Time measures agent execution efficiency. Lead Time − Cycle Time = queue
wait time (Muda of Waiting, see Part 2).

---

### Pull System - 拉式生産 (Hikitsuke)

Work is pulled by agents when they have capacity, not pushed to agents
regardless of capacity. An agent picks up the next backlog task only when its
current slot is free (WIP limit not exceeded).

In kaizen-spec: agents read `tasks.json`, find the first `backlog` task whose
dependencies are met and whose target column has WIP capacity, and claim it.
No central dispatcher assigns work.

---

### Backlog - 待辦清單

The pool of work not yet started. In `tasks.json`, all tasks with
`status: "backlog"`. Items in the backlog accumulate Lead Time silently —
they are already "on the clock" even though no agent has touched them.

---

### Bottleneck - ボトルネック

The slowest stage in the flow. Determines total system throughput
(Goldratt's Theory of Constraints). In kaizen-spec, if the Review column
is always full while Backlog grows, Review is the bottleneck - reduce its
WIP limit or add capacity there first.

---

### Takt Time - タクト時間

The rate at which work must be delivered to meet demand.

Formula: `Takt Time = Available time / Number of user requests`

In agentic terms: if a user expects 10 features delivered per sprint, and there
are 40 working hours available, Takt Time = 4 hours per feature. Agent
parallelism must be sized to meet or beat Takt Time.

kaizen-spec does not measure Takt Time automatically, but the kaizen.log Lead
Time data can be used to calculate it retrospectively.

---

### Heijunka - 平準化 (Level Loading)

Smoothing the unevenness (Mura) in work volume. Rather than processing work in
bursts, distribute it evenly over time.

In kaizen-spec, WIP limits achieve Heijunka implicitly: they prevent burst
processing by capping concurrency. A queue of 20 tasks with WIP=3 processes
smoothly at 3 tasks at a time rather than launching all 20 simultaneously.

---

## Part 2 - Kaizen (改善): Eliminating Waste

Kaizen (改善) means "change for the better" - continuous, incremental improvement.
It is not a one-time event; it is a permanent operating mode.

---

### Muda - 無駄 (Waste)

Any activity that consumes resources without adding value. Toyota's Seven Wastes,
mapped to agentic development:

| Toyota Muda | Agentic equivalent | kaizen-spec mitigation |
|---|---|---|
| 過剰生産 Over-production | Writing code not in the spec | Phase 1 spec gate |
| 待機 Waiting | Agent idle waiting for human input | Andon cord - surface blockers fast |
| 欠陥 Defects | Code that fails tests or mismatches spec | TDD - tests catch defects immediately |
| 動作 Motion | Agent re-reading context it already processed | State in `.kaizen/` files - read once |
| 運搬 Transport | Passing outputs between too many agents | Worktree isolation - agent reads source directly |
| 在庫 Inventory | Unfinished tasks sitting in backlog | WIP limits - limit queue depth |
| 過剰処理 Over-processing | Five-phase ceremony for a trivial rename | SKIP guard - classify request first |

---

### Mura - 斑 (Unevenness)

Irregular or uneven flow. A system that processes 100 tasks one day and 0 the
next is experiencing Mura. Heijunka (WIP limits + pull system) is the remedy.

---

### Muri - 無理 (Overburden)

Pushing agents or infrastructure beyond capacity. Launching 20 parallel
subagents when the machine has resources for 3 is Muri - it causes thrashing,
timeouts, and degraded output quality. WIP limits prevent Muri directly.

---

### Andon - 安燈 (Signal Light)

A visual signal system. In Toyota factories, any worker pulls the Andon cord to
stop the entire production line when they detect a problem.

In kaizen-spec: when an agent cannot proceed, it:
1. Sets `status: "blocked"` + `blocked_reason` in `tasks.json`
2. Sets `data-blocked="true"` on its board card (visual Andon badge)
3. Appends `WARN` to `kaizen.log`
4. **Stops.** Does not continue producing potentially defective work.

The Andon cord is also pulled automatically by the test suite (Jidoka - see below).

---

### Jidoka - 自働化 (Autonomation with Human Intelligence)

Automation with built-in defect detection. The key distinction from plain
automation: the machine/agent detects anomalies and stops, rather than
continuing to produce defects.

**In kaizen-spec, Jidoka = the TDD regression cycle:**

| TDD phase | Jidoka role |
|---|---|
| Write failing test (Red) | Define what "defect-free" means |
| Run test suite | Machine autonomously detects defects |
| Test fails → stop | Andon cord pulled automatically by test runner |
| Implement (Green) | Fix the defect under machine supervision |
| Refactor → test again | Confirm no regression introduced |

The test suite IS the Jidoka mechanism. It requires no human to notice a defect —
it stops the "production line" (CI/CD, acceptance gate) the moment a test fails.
This maps directly to: Phase 4 will not pass until all tests are green.

This is also why tests must be red before implementation starts (Phase 2 gate):
a test that was never red has never been proven capable of detecting the defect.
A Jidoka sensor that was never triggered cannot be trusted.

---

### Poka-Yoke - ポカヨケ (Mistake-Proofing)

Designing the system so that errors are impossible, not just unlikely.

In kaizen-spec:
- `tasks.json` has a required schema - agents cannot write arbitrary fields
- Board HTML uses `data-wip-limit` attributes - WIP enforcement is structural
- Phase gates prevent implementation before spec commit - the workflow itself is Poka-Yoke

In software generally: static typing, schema validation, and linting are Poka-Yoke.

---

### Genchi Genbutsu - 現地現物 (Go and See)

"Go to the actual place, see the actual thing." Do not rely on second-hand reports
or summaries when diagnosing a problem.

**In kaizen-spec (agent instruction):** When a task is blocked or a test fails,
the agent must read the raw error output directly - the actual stack trace, the
actual test output, the actual log line. Do not ask another agent to summarise it.
The Gemba (現場) is the actual error, not a description of it.

> Correct: Read `.kaizen/kaizen.log` directly and find the ERROR line.
> Incorrect: Ask "what did the last agent report?"

---

### Gemba - 現場 (The Real Place)

The place where value is actually created. For manufacturing: the factory floor.
For software: the production/clinical environment where code runs.

In kaizen-spec: the Gemba is the running test suite and the actual `.kaizen/`
state files - not the agent's memory of what it thinks happened.

---

### Standard Work - 標準作業

The documented, agreed baseline for how work is done. Kaizen cannot improve a
process that has not been standardised - you cannot improve what you cannot
measure or repeat.

In kaizen-spec: the `.kaizen/` directory structure IS the Standard Work:
- `spec.md` - standard for capturing intent
- `test-strategy.md` - standard for defining "done"
- `tasks.json` - standard for tracking agent state
- `kaizen.log` - standard for recording what happened
- `board.html` - standard for visualising flow

The checklist in `features/kaizen-spec/checklist.md` is the Standard Work for
building the skill itself.

---

### PDCA - Plan-Do-Check-Act (計画・実行・評価・改善)

The Deming improvement cycle. In kaizen-spec, PDCA maps directly to TDD:

| PDCA | TDD equivalent |
|---|---|
| Plan | Write the failing test - define what success looks like |
| Do | Implement the code |
| Check | Run the test suite - did it work? |
| Act | Refactor if green; fix and repeat if red |

One TDD red→green→refactor cycle = one PDCA loop.
The kaizen.log records every cycle, making improvement history auditable.

---

## Part 3 - Quick Reference (術語対照表)

| Kaizen/Kanban term | Kanji | Agentic / kaizen-spec mapping |
|---|---|---|
| Andon | 安燈 | Blocked card badge + kaizen.log WARN + agent stops |
| Poka-Yoke | ポカヨケ | tasks.json schema, phase gates, WIP enforcement |
| Jidoka | 自働化 | TDD cycle - test suite auto-detects defects |
| Takt Time | タクト時間 | Delivery rate target (derived from kaizen.log Lead Times) |
| Genchi Genbutsu | 現地現物 | Read raw logs/stack traces directly, never summaries |
| Gemba | 現場 | Running test suite + .kaizen/ state files |
| Muda | 無駄 | Any work outside the spec (over-processing, defects, waiting) |
| Mura | 斑 | Uneven agent load - prevented by WIP limits |
| Muri | 無理 | Agent overload - prevented by WIP limits |
| Heijunka | 平準化 | Level loading - achieved by pull system + WIP limits |
| Standard Work | 標準作業 | The .kaizen/ directory structure and file schemas |
| Lead Time | 交付周期 | created_at → completed_at (total time in system) |
| Cycle Time | 週期時間 | started_at → completed_at (active work time) |
| Bottleneck | ボトルネック | Column always at WIP limit while backlog grows |
| Pull System | 拉式/引き取り | Agents self-assign from backlog when capacity exists |
| PDCA | 計画・実行・評価・改善 | TDD red→green→refactor cycle |
| Backlog | 待辦 | tasks.json entries with status=backlog |
| WIP Limit | 在製品限制 | wip_limits in tasks.json, enforced by board + agent logic |
