# kaizen-spec — Design Handover

**Status:** Pre-design discussion. No code written. Continue this conversation inside this repo.

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

## Decisions Made So Far

1. **Repo name:** `kaizen-spec` — chosen by user
2. **Interaction pattern:** All design alignment, brainstorming, and option-presenting MUST use `AskUserQuestion` tool with structured options + a recommendation. This applies both in this design conversation AND inside the generated skill itself.

---

## Decisions Still Pending (continue here)

Work through these in order using `AskUserQuestion` for each:

### A. Web-based Kanban Framework
- Must use existing common frameworks (not raw HTML/JS/CSS)
- Must be spec-driven and work with the agentic skill loop
- Toyota Kanban / Kaizen philosophy must inform the board design (WIP limits, pull-not-push, continuous flow, visual management)
- Options to evaluate: React + shadcn/ui, SvelteKit, Next.js, Nuxt, or a headless board library (e.g. dnd-kit, @hello-pangea/dnd) + Tailwind

### B. Skill Architecture / Phase Design
The skill loop phases (draft, to be confirmed with user):
1. **Spec Alignment** — AskUserQuestion-driven: intention, target output, scope, out-of-scope warnings, optional questions one at a time with recommendations
2. **Test Strategy** — Help user choose optimal E2E + integration test framework; ALL initial tests must fail first (red), then implementation drives them green
3. **Implementation** — Subagent-parallelised code writing
4. **Acceptance** — Constrained by passing tests (not just unit tests — real-world / E2E). Notify user when manual verification needed.
5. **Docs in Parallel** — Doc writing runs alongside code writing; framework TBD (options: Docusaurus, VitePress, MkDocs); includes GitHub wiki, CI/CD for doc build/serve, machine + human readable outputs

### C. Test Framework Selection
- Must support automated E2E (not just unit tests)
- Must integrate with CI/CD
- Candidates: Playwright (recommended), Cypress, Vitest + Testing Library, pytest + Playwright (if Python)

### D. Kanban Kaizen Design Details
- WIP limits per column (Toyota: never exceed capacity)
- Pull-not-push: agents pick up next ticket only when capacity exists
- Andon cord equivalent: agent flags blockers visually on board
- Kaizen log: persistent record of process improvements per cycle
- Live update: kanban reflects real-time agent state (not manual updates)

### E. Subagent Orchestration Pattern
- Based on Superpowers' worktree-per-ticket + Ralph's fresh-context loops
- State persisted in files (git-tracked), not agent memory
- Options: OpenSpec slash-command interface vs custom CLAUDE.md hooks vs both

### F. Doc Framework
- Must cover: GitHub README, GitHub Wiki, CI-built docs site, machine-readable spec outputs
- Candidates: Docusaurus (recommended), VitePress, MkDocs, or Mintlify

---

## How to Continue

Open this repo in Claude Code and say:

> "Continue the kaizen-spec skill design from HANDOVER.md — pick up from section A (Web-based Kanban Framework) and work through each pending decision using AskUserQuestion."

---

## Reference Summaries (from initial research)

**OpenSpec:** Pre-implementation alignment framework. Feature folders: proposal → spec → design → checklist. Slash-command driven. 98.9% TypeScript. Integrates with 25+ AI assistants.

**Superpowers:** Seven-phase workflow (Brainstorm → Worktrees → Plan → Dev → Test → Review → Complete). Enforced TDD, 2–5 min granular tasks, subagent coordination, batch processing. Plugin-based for Claude Code, Cursor, Gemini.

**Ralph:** Fresh context per iteration. Long-running autonomous cycle until all PRD items complete. Continuity via git history + progress log + task status file. Prevents context bloat via fresh spawns.

**OpenKanban:** TUI kanban for managing multiple agents across repos simultaneously. Worktree-per-ticket isolation. Embedded agent execution. Vim-style modal navigation. Go-based, AGPL-3.0.
