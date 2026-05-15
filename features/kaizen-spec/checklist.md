# Checklist: kaizen-spec Skill

**Feature ID:** kaizen-spec  
**Status:** Ready for implementation  
**Date:** 2026-05-14  
**Depends on:** [design.md](design.md)

---

## How to Use This Checklist

Work through tasks in order within each phase. A phase must be complete before the next begins. Mark tasks `[x]` as they are done. Each task should be completable in a single focused subagent session (target: 2–5 minutes of agent work).

The self-hosting acceptance criterion: **all phases below must pass when `/kaizen-spec` is run on this repo itself.**

---

## Phase 0 - Repo Scaffold

- [ ] **0.1** Create `.claude/commands/` directory
- [ ] **0.2** Create `templates/` directory
- [ ] **0.3** Create `docs/.vitepress/` directory structure
- [ ] **0.4** Create `.github/workflows/` directory
- [ ] **0.5** Write `README.md` - project overview, quick-start, one-line install
- [ ] **0.6** Initial git commit: `init: repo scaffold`

---

## Phase 1 - Skill Entrypoint

- [ ] **1.1** Write `.claude/commands/kaizen-spec.md` - system prompt section
  - Persona: orchestrator, spec-first, kaizen-informed
  - Hard constraints: no code before spec committed, tests must be red before impl
  - Phase gating rules: each phase listed, each gates the next
- [ ] **1.2** Write Phase 1 (Spec Alignment) instructions in the skill
  - `AskUserQuestion` sequence: intent → target output → scope → out-of-scope → risks
  - Instruction to write agreed spec to `.kaizen/spec.md`
  - Instruction to git commit before proceeding
- [ ] **1.3** Write Phase 2 (Test Strategy) instructions in the skill
  - Stack detection logic (scan `package.json`, `pyproject.toml`, `go.mod`, `Cargo.toml`)
  - `AskUserQuestion`: confirm detected framework or choose alternative
  - Instruction to spawn test-writer subagent
  - Instruction to verify all tests fail before proceeding
- [ ] **1.4** Write Phase 3 (Implementation) instructions in the skill
  - Task decomposition: read spec, generate task list, write to `.kaizen/tasks.json`
  - Subagent spawn instructions (Agent tool, `isolation: "worktree"`)
  - Impl agent prompt template (read spec → claim task → implement → update board → log)
  - WIP limit enforcement: check `tasks.json` wip_limits before spawning
  - Andon cord instructions: blocked agent writes log WARN + board flag
- [ ] **1.5** Write Phase 4 (Acceptance) instructions in the skill
  - Run full test suite
  - Block on any failure: log ERROR, notify user
  - Manual verification prompt (AskUserQuestion) when needed
  - Log acceptance result + cycle time
- [ ] **1.6** Write Phase 5 (Docs) instructions in the skill
  - Doc agent prompt template (read spec → write VitePress page → update sidebar)
  - Parallel execution: doc agent starts at same time as first impl agent
  - Commit instruction
- [ ] **1.7** Commit: `feat: skill entrypoint complete`

---

## Phase 2 - Board Template

- [ ] **2.1** Write `templates/board.html`
  - Bootstrap 5 CDN link (CSS + JS bundle)
  - SortableJS CDN link
  - Four columns: Backlog, In Progress (WIP 3), Review (WIP 2), Done
  - `data-wip-limit` attribute on each capped column
  - `data-status` attribute on each column (matches `tasks.json` status values)
  - Bootstrap card structure for task cards with `data-task-id`, `data-blocked` attributes
  - WIP enforcement JS function (~20 lines, see design.md)
  - Andon badge render logic (if `data-blocked="true"` → add `⚠` badge + `border-danger`)
  - 5-second auto-reload script
  - Feature name + last-updated timestamp in page header
- [ ] **2.2** Verify board renders correctly in a browser with sample data
- [ ] **2.3** Verify WIP limit triggers correctly (drag card into full column → card reverts + header turns red)
- [ ] **2.4** Verify Andon badge appears when `data-blocked="true"` is set on a card
- [ ] **2.5** Commit: `feat: kanban board template`

---

## Phase 3 - State File Templates

- [ ] **3.1** Write `templates/tasks.json` - empty schema with one example task and WIP limits set
- [ ] **3.2** Write `templates/test-strategy.md` - template with sections: chosen framework, install command, test file locations, failing test list
- [ ] **3.3** Document atomic write pattern for `tasks.json` in a comment in the template (write to `.tmp`, rename)
- [ ] **3.4** Commit: `feat: state file templates`

---

## Phase 4 - VitePress Documentation Site

- [ ] **4.1** Install VitePress: `npm install -D vitepress` (save `package.json` to repo)
- [ ] **4.2** Write `docs/.vitepress/config.ts` - full config as per design.md
  - `appearance: 'auto'` (dark/light toggle)
  - Nav: Guide, Reference
  - Sidebar: guide + reference sections
  - GitHub social link
- [ ] **4.3** Write `docs/index.md` - VitePress home page with hero section
  - Hero: title "kaizen-spec", tagline, action button "Get Started"
  - Features section: 3 key features (Spec-first, TDD-enforced, Self-hosting)
- [ ] **4.4** Write `docs/guide/getting-started.md`
  - Prerequisites, install, first run (`/kaizen-spec`), what to expect
- [ ] **4.5** Write `docs/guide/phases.md`
  - One section per phase, plain-language description + what files are written
- [ ] **4.6** Write `docs/guide/kanban.md`
  - How to open the board, WIP limits explained, Andon cord explained, Kaizen log
- [ ] **4.7** Write `docs/reference/state-schema.md`
  - Full `tasks.json` schema with field descriptions
  - `kaizen.log` format with all standard event types
- [ ] **4.8** Write `docs/reference/kaizen-log.md`
  - Syslog format spec, severity levels, standard keys, example entries
- [ ] **4.9** Run `vitepress build docs` - must succeed with zero errors
- [ ] **4.10** Run `vitepress dev docs` - verify dark/light toggle works in browser
- [ ] **4.11** Commit: `feat: VitePress docs site`

---

## Phase 5 - CI/CD

- [ ] **5.1** Write `.github/workflows/docs.yml` - VitePress build + GitHub Pages deploy (as per design.md)
- [ ] **5.2** Add `.nojekyll` file to `docs/public/` (required for GitHub Pages + VitePress)
- [ ] **5.3** Commit: `feat: docs CI/CD pipeline`

---

## Phase 6 - Self-Hosting Acceptance Test

This phase proves the skill works by using it on itself.

- [ ] **6.1** Open `kaizen-spec` repo in Claude Code
- [ ] **6.2** Run `/kaizen-spec "add a kaizen-log tail command that shows the last N entries from .kaizen/kaizen.log"`
- [ ] **6.3** Verify Phase 1: `.kaizen/spec.md` written and committed
- [ ] **6.4** Verify Phase 2: `.kaizen/test-strategy.md` written; run tests - all must fail
- [ ] **6.5** Verify Phase 3:
  - `.kaizen/tasks.json` populated with decomposed tasks
  - `board.html` updates as agents claim tasks
  - At least one agent completes a task and logs to `kaizen.log`
  - All failing tests turn green
- [ ] **6.6** Verify Phase 4: full test suite passes; acceptance logged to `kaizen.log`
- [ ] **6.7** Verify Phase 5: `docs/guide/kaizen-log-tail.md` written
- [ ] **6.8** Open `.kaizen/board.html` in browser - all cards must be in Done column
- [ ] **6.9** Read `.kaizen/kaizen.log` - must contain INFO entries for every phase transition
- [ ] **6.10** **If all of the above pass: skill is done.** Commit: `feat: self-hosting acceptance test passed`

---

## Definition of Done

The skill is **done** when:

1. `/kaizen-spec` runs end-to-end on this repo (checklist 6.1–6.9 all pass)
2. All Playwright E2E tests written in Phase 2 are green
3. `vitepress build docs` succeeds
4. `.kaizen/kaizen.log` contains a complete, accurate record of the self-hosting run
5. The board at `.kaizen/board.html` shows all tasks in Done with no Andon flags

Not done until all five are true simultaneously.
