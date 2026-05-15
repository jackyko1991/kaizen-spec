# Glossary

Quick reference for kaizen and kanban terms used throughout kaizen-spec. For full definitions with examples and skill mappings, see the [full reference glossary](/reference/kaizen-glossary).

---

## Flow terms

| Term | 日本語 | One-line meaning |
|---|---|---|
| **Kanban** | 看板 | Signboard - a system for making work visible and limiting overload |
| **WIP Limit** | 在製品限制 | Max tasks allowed in a column at one time - "stop starting, start finishing" |
| **Lead Time** | 交付周期 | `created_at` → `completed_at` - total time in system (shown as LT on cards) |
| **Cycle Time** | 週期時間 | `started_at` → `completed_at` - active work time only (shown as CT on cards) |
| **Takt Time** | タクト時間 | Required delivery rate to meet demand |
| **Pull System** | 引き取り | Agents self-assign tasks when capacity is free - never pushed at them |
| **Heijunka** | 平準化 | Level loading - WIP limits prevent burst-then-idle patterns |
| **Bottleneck** | ボトルネック | The slowest column - where to add capacity first |

---

## Waste terms

| Term | 日本語 | One-line meaning |
|---|---|---|
| **Muda** | 無駄 | Waste - any activity consuming resources without adding value |
| **Mura** | 斑 | Unevenness - irregular flow (remedy: Heijunka) |
| **Muri** | 無理 | Overburden - pushing agents beyond capacity (remedy: WIP limits) |

---

## Quality terms

| Term | 日本語 | One-line meaning |
|---|---|---|
| **Jidoka** | 自働化 | Autonomation - machine detects defects and stops; in software = TDD |
| **Andon** | 安燈 | Stop signal - blocked card badge + WARN log + agent stops working |
| **Poka-Yoke** | ポカヨケ | Mistake-proofing - phase gates, schema validation, static typing |
| **Genchi Genbutsu** | 現地現物 | Go and see - read raw logs directly, never rely on summaries |
| **Gemba** | 現場 | The real place - the actual test output, the actual `.kaizen/` state |
| **5S** | 職場環境整備 | Workplace organisation - Sort, Set, Shine, Standardise, Sustain |

---

## Improvement terms

| Term | 日本語 | One-line meaning |
|---|---|---|
| **Kaizen** | 改善 | Change for the better - continuous incremental improvement |
| **Standard Work** | 標準作業 | The agreed baseline - `.kaizen/` files are kaizen-spec's Standard Work |
| **PDCA** | 計画・実行・評価・改善 | Plan → Do → Check → Act - maps directly to TDD red→green→refactor |

---

## On the board

Each kanban card shows **CT** (Cycle Time) and **LT** (Lead Time) computed from timestamps in `tasks.json`. Hover a card to see the full breakdown.

The Done column caps at `done_visible_max` visible cards (default 10). Older cards remain in `tasks.json` for metrics and are summarised in a faded archive stub at the bottom of the column.

→ [Full glossary with examples](/reference/kaizen-glossary)
