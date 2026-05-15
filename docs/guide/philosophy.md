# Philosophy

kaizen-spec is grounded in the **Toyota Production System (TPS)** as translated to software by Mary and Tom Poppendieck in *Lean Software Development*. Each Toyota concept maps directly to a software practice that the skill enforces.

---

## Why TPS?

Toyota spent decades eliminating waste, defects, and overburden from physical production lines. The same problems appear in software: code accumulates before it ships, defects compound downstream, agents get overloaded, context is lost between sessions. TPS gives us proven vocabulary and proven remedies.

The core insight: **waste in software is unshipped code**. Every line of code that exists but has not delivered value is inventory - it costs maintenance, carries obsolescence risk, and adds context load for every future agent that reads it.

---

## TPS → Software Mapping

| Toyota / TPS | JP | Software equivalent | What breaks without it |
|---|---|---|---|
| Muda - waste elimination | 無駄 | Unshipped code is inventory waste | Code accrues maintenance cost and obsolescence risk before it reaches users |
| Just-in-Time (JIT) | ジャスト・イン・タイム | CI/CD - pull-based delivery | Big-batch releases accumulate risk; defects compound before detection |
| Jidoka - autonomation | 自働化 | TDD - tests pull the Andon cord | Defects flow downstream into production; no sensor to stop the line |
| Poka-Yoke - mistake-proofing | 防呆 | Static typing, linting, schema validation | Errors are caught at runtime or by users instead of at the point of writing |
| Kaizen - continuous improvement | 改善 | Spec Kaizen - test failures feed back into the spec | Specs drift from reality; agents repeatedly solve the wrong problem |
| One-piece flow | 一個流 | Atomic Specs - one agent, one task, one responsibility | Large context windows reduce agent accuracy; long tasks can't be parallelised |
| Decide late | - | Lean Spec - Just-in-Time design | Big-upfront specs become stale before implementation; over-engineering is baked in |
| Standard Work | 標準作業 | State in `.kaizen/` files, not agent memory | Fresh-context agents cannot resume; users must re-explain context from scratch |

---

## The Five Principles in Practice

### 1. Spec before code (Decide late)

Agents that start coding immediately solve the wrong problem half the time. A 5-minute spec alignment saves hours of rework. The spec gate is Lean's "decide at the last responsible moment" - commit to a solution only once enough information exists to make the right decision.

### 2. Tests red before green (Jidoka)

A test that was never red has never proved it can catch the defect. Jidoka means the machine detects anomalies and stops - in TDD, the failing test is the sensor. If the sensor was never tested, it cannot be trusted.

### 3. WIP limits (One-piece flow + Heijunka)

Parallelism is not free. Running 20 agents concurrently on one feature causes thrashing, merge conflicts, and degraded output quality. WIP limits enforce one-piece flow: a small number of tasks move completely through the system before the next batch starts.

### 4. Visible work (Andon + Standard Work)

Work that isn't on the board doesn't exist. Every task - trivial or complex - gets a kanban card. If an agent is blocked, it pulls the Andon cord (sets `data-blocked="true"`) and stops rather than continuing to produce defective output.

### 5. State in files, not memory (Standard Work)

Agents restart. Sessions end. Memory is ephemeral. The `.kaizen/` directory is Standard Work - the single source of truth that any fresh-context agent can read to understand exactly where the project stands without being told.

---

## Lean Development - The Seven Principles

Lean Development originates from the Toyota Production System's philosophy of **Lean Production**. Its core idea is **eliminating waste** - maximising efficiency and value so that every minute and every line of code in the development process creates value for the customer.

Lean was translated into software by Mary and Tom Poppendieck in *Lean Software Development* (2003), where they identified seven principles:

### 1. Eliminate Waste

Remove unnecessary features, reduce waiting time, avoid over-processing (redundant tests, excessive documentation). If it doesn't directly serve the customer, it's Muda.

### 2. Build Quality In

Automated testing and continuous integration ensure problems are fixed at the moment they occur - not patched later. Quality is not inspected in at the end; it is built in at every step (Jidoka).

### 3. Create Knowledge

Encourage teams to learn, document experiment results, and share experience. The `.kaizen/` log and spec files are a form of institutionalised knowledge creation.

### 4. Defer Commitment

Don't make irreversible decisions before you have enough information. Preserve flexibility - the spec gate enforces this: no implementation until the scope is clear.

### 5. Deliver Fast

Shorten feedback cycles. Get the product to users quickly to validate ideas. Long cycle times mean long waits before you learn whether you built the right thing.

### 6. Respect People

Give front-line developers decision-making authority. Trust expertise. In kaizen-spec: agents are given clear context and authority within their task scope; the orchestrator doesn't micro-manage implementation details.

### 7. Optimise the Whole

Focus on the flow of the entire value chain, not just a single department or step. A fast implementation team that produces defects which slow down review is not an optimised system - it has just moved the bottleneck.

---

## Lean vs. Agile

Both Lean and Agile are frequently discussed together and both emphasise flexibility and rapid iteration - but their focus is different:

| Characteristic | Agile | Lean |
|---|---|---|
| Core goal | Respond to changing requirements through iteration | Improve efficiency by eliminating waste and optimising flow |
| Approach | Small steps, continuous delivery, customer communication | Focus on value stream flow; find bottlenecks in the process |
| Management style | Scrum: fixed-length sprints, defined roles | Kanban: visualise process flow, limit WIP |
| View of people | Cross-functional, self-organising teams | Systematic process improvement and continuous Kaizen |
| Failure stance | Fail fast - learn through frequent failure | Reduce errors and waiting to lower cost |

**They are not mutually exclusive.** High-performing modern teams typically adopt a Lean-Agile hybrid:

- Use the **Agile mindset** to face uncertain market requirements and frequent customer interaction.
- Use **Lean tools** (value stream maps, kanban) to examine whether the development process has too much WIP or unnecessary administrative overhead.

In short: Agile tells you *how to do the right things effectively*. Lean tells you *how to do things right efficiently*.

For projects requiring high stability and resource optimisation - such as infrastructure work or regulated systems (medical imaging, IEC 62443, DO-178C) - Lean principles deliver the greatest advantage in reducing wasted effort.

---

## Further Reading

- *Lean Software Development* - Mary & Tom Poppendieck (2003)
- *The Toyota Way* - Jeffrey Liker (2004)
- [Kaizen & Kanban Glossary](/reference/kaizen-glossary) - full term definitions used in this skill
