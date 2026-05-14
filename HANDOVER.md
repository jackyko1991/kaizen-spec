# kaizen-spec — Design Handover

**Status:** All architecture decisions locked. Ready for implementation. Continue this conversation inside this repo.

---

## What This Project Is

`kaizen-spec` is a Claude Code skill (slash command) for spec-driven, kaizen-informed, agentic software development. It synthesises four reference projects:

| Reference | Contribution |
|---|---|
| [OpenSpec](https://github.com/Fission-AI/OpenSpec) | Pre-code spec alignment interface — proposal → spec → design → checklist, slash-command driven |
| [Superpowers](https://github.com/obra/superpowers) | 7-phase enforced workflow (Brainstorm → Plan → TDD → Dev → Review), subagent-first |
| [Ralph](https://github.com/snarktank/ralph) | Fresh-context autonomous loops, progress state persisted in git/files not agent memory |
| [OpenKanban](https://github.com/TechDufus/openkanban) | Multi-agent coordination with a live kanban board per worktree/ticket |

---

## All Decisions — Final

### A. Kanban UI Framework
**Decision:** Plain HTML + Bootstrap 5 (CDN, no build step) + SortableJS for drag-and-drop.

Rationale: lowest token cost for agents writing/patching the board. Bootstrap's pre-built components (cards, badges, `bg-danger`/`bg-warning`) map 1-to-1 to Toyota Kanban visual signals. No bundler, no `node_modules`.

Board lives at `.kaizen/board.html`. Agents patch it surgically.

---

### B. Skill Architecture — 5-Phase Structure
**Decision:** Confirmed.

| # | Phase | Description |
|---|---|---|
| 1 | Spec Alignment | AskUserQuestion-driven: intention, target output, scope, out-of-scope warnings |
| 2 | Test Strategy | User chooses test framework; all initial tests must fail first (red), then go green |
| 3 | Implementation | Subagent-parallelised code writing |
| 4 | Acceptance | Constrained by passing tests; user notified when manual verification needed |
| 5 | Docs in Parallel | Doc writing runs alongside phase 3 |

Each phase gates the next.

---

### C. Test Framework
**Decision:** Playwright as the default recommendation. The Test Strategy phase (phase 2) uses `AskUserQuestion` to let the user choose based on their project stack. The skill never hardcodes a framework.

Stack-to-framework mapping the skill presents:
- TypeScript/JS project → Playwright (TS)
- Python project → pytest + Playwright
- React-heavy project → Playwright or Cypress (user's choice)

---

### D. Kaizen Board Features (Day One)
**Decision:** Three features ship from day one:

1. **WIP limits per column** — configurable cap per column; exceeding it turns the column header `bg-danger` (red). Agents cannot move cards in if the column is full.
2. **Andon cord / blocker flag** — agents flag a card as blocked with a red badge + desktop notification. Visual equivalent of Toyota's stop-the-line cord.
3. **Kaizen log** — append-only syslog-format file at `.kaizen/kaizen.log` (NOT markdown). Example entry:
   ```
   2026-05-14T10:23:45Z INFO [kaizen] phase=implementation task=auth-login status=blocked reason="DB timeout"
   ```

Pull-not-push flow is implied by WIP limits — not a separate feature.

---

### E. Subagent State Coordination
**Decision:** Files in git only. No shared agent memory.

State directory `.kaizen/`:
```
.kaizen/
  board.html        — live kanban board (Bootstrap)
  tasks.json        — task list + status + assignments
  kaizen.log        — syslog-format event log
  spec.md           — aligned spec from phase 1
  test-strategy.md  — chosen test framework + plan
```

Fresh-context agents reconstruct full state from these files alone. Inspired by Ralph.

---

### F. Documentation Framework
**Decision:** VitePress with both dark and light themes configured. Deployed to GitHub Pages via CI.

Doc scope: GitHub README, VitePress site, machine-readable spec outputs from `.kaizen/spec.md`.

---

## How to Continue

Open this repo in Claude Code and say:

> "All decisions are locked in HANDOVER.md. Start implementation planning for kaizen-spec."

Next step: create the implementation plan — file structure, skill entrypoint, phase orchestration logic, board template, and VitePress scaffold.

---

## Reference Summaries (from initial research)

**OpenSpec:** Pre-implementation alignment framework. Feature folders: proposal → spec → design → checklist. Slash-command driven. 98.9% TypeScript. Integrates with 25+ AI assistants.

**Superpowers:** Seven-phase workflow (Brainstorm → Worktrees → Plan → Dev → Test → Review → Complete). Enforced TDD, 2–5 min granular tasks, subagent coordination, batch processing. Plugin-based for Claude Code, Cursor, Gemini.

**Ralph:** Fresh context per iteration. Long-running autonomous cycle until all PRD items complete. Continuity via git history + progress log + task status file. Prevents context bloat via fresh spawns.

**OpenKanban:** TUI kanban for managing multiple agents across repos simultaneously. Worktree-per-ticket isolation. Embedded agent execution. Vim-style modal navigation. Go-based, AGPL-3.0.
