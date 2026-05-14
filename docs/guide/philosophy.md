# Philosophy

kaizen-spec is grounded in the **Toyota Production System (TPS)** as translated to software by Mary and Tom Poppendieck in *Lean Software Development*. Each Toyota concept maps directly to a software practice that the skill enforces.

---

## Why TPS?

Toyota spent decades eliminating waste, defects, and overburden from physical production lines. The same problems appear in software: code accumulates before it ships, defects compound downstream, agents get overloaded, context is lost between sessions. TPS gives us proven vocabulary and proven remedies.

The core insight: **waste in software is unshipped code**. Every line of code that exists but has not delivered value is inventory — it costs maintenance, carries obsolescence risk, and adds context load for every future agent that reads it.

---

## TPS → Software Mapping

| Toyota / TPS | JP | Software equivalent | What breaks without it |
|---|---|---|---|
| Muda — waste elimination | 無駄 | Unshipped code is inventory waste | Code accrues maintenance cost and obsolescence risk before it reaches users |
| Just-in-Time (JIT) | ジャスト・イン・タイム | CI/CD — pull-based delivery | Big-batch releases accumulate risk; defects compound before detection |
| Jidoka — autonomation | 自働化 | TDD — tests pull the Andon cord | Defects flow downstream into production; no sensor to stop the line |
| Poka-Yoke — mistake-proofing | 防呆 | Static typing, linting, schema validation | Errors are caught at runtime or by users instead of at the point of writing |
| Kaizen — continuous improvement | 改善 | Spec Kaizen — test failures feed back into the spec | Specs drift from reality; agents repeatedly solve the wrong problem |
| One-piece flow | 一個流 | Atomic Specs — one agent, one task, one responsibility | Large context windows reduce agent accuracy; long tasks can't be parallelised |
| Decide late | — | Lean Spec — Just-in-Time design | Big-upfront specs become stale before implementation; over-engineering is baked in |
| Standard Work | 標準作業 | State in `.kaizen/` files, not agent memory | Fresh-context agents cannot resume; users must re-explain context from scratch |

---

## The Five Principles in Practice

### 1. Spec before code (Decide late)

Agents that start coding immediately solve the wrong problem half the time. A 5-minute spec alignment saves hours of rework. The spec gate is Lean's "decide at the last responsible moment" — commit to a solution only once enough information exists to make the right decision.

### 2. Tests red before green (Jidoka)

A test that was never red has never proved it can catch the defect. Jidoka means the machine detects anomalies and stops — in TDD, the failing test is the sensor. If the sensor was never tested, it cannot be trusted.

### 3. WIP limits (One-piece flow + Heijunka)

Parallelism is not free. Running 20 agents concurrently on one feature causes thrashing, merge conflicts, and degraded output quality. WIP limits enforce one-piece flow: a small number of tasks move completely through the system before the next batch starts.

### 4. Visible work (Andon + Standard Work)

Work that isn't on the board doesn't exist. Every task — trivial or complex — gets a kanban card. If an agent is blocked, it pulls the Andon cord (sets `data-blocked="true"`) and stops rather than continuing to produce defective output.

### 5. State in files, not memory (Standard Work)

Agents restart. Sessions end. Memory is ephemeral. The `.kaizen/` directory is Standard Work — the single source of truth that any fresh-context agent can read to understand exactly where the project stands without being told.

---

## Further Reading

- *Lean Software Development* — Mary & Tom Poppendieck (2003)
- *The Toyota Way* — Jeffrey Liker (2004)
- [Kaizen & Kanban Glossary](/reference/kaizen-glossary) — full term definitions used in this skill
