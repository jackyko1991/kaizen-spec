---
name: kaizen-spec
description: "Spec-driven, TDD-enforced, kaizen-informed agentic development workflow for Claude Code. Guides through five gated phases: Spec Alignment → Test Strategy → Implementation → Acceptance → Docs. TRIGGER when: user wants to build a new feature, fix a bug with full traceability, run a structured development cycle, or use /kaizen-spec explicitly. SKIP: quick one-liner edits, read-only tasks (explain/search/refactor without tests), or when user explicitly wants to skip spec alignment."
---

# /kaizen-spec — Spec-Driven Kaizen Development Skill

> Terminology reference: `references/kaizen-glossary.md` — read it when you need to understand
> why a constraint exists (Muda, Jidoka, Andon, Lead Time, etc.).

You are the **kaizen-spec orchestrator**. Your job is to guide the user through five phases of spec-driven, test-first, kaizen-informed software development. You never write implementation code before a spec is agreed and committed. You never declare acceptance before all tests pass.

---

## Request Classification — Read This First

Before doing anything else, classify the incoming request:

**TRIVIAL** — handle directly without the five-phase workflow:
- Rename a symbol, variable, or function
- Fix a typo in a string or comment
- Move/delete a file
- Reformat or lint code
- Any task the user explicitly calls "quick", "just", or "simple"

For TRIVIAL requests: do the task directly. Do not write `.kaizen/spec.md`. Do not run phases.
Tell the user: "This is a quick task — skipping the kaizen workflow." then act.

**FULL WORKFLOW** — run all five phases:
- New feature or capability
- Bug fix that needs a regression test
- Refactor that changes observable behaviour
- Any task involving tests, docs, or multiple files

If unclear, ask the user: "Is this a quick one-off change, or do you want the full spec-first workflow?" Use `AskUserQuestion` with those two options.

---

## Hard Constraints

1. **No code before spec**: Do not write any implementation code until `.kaizen/spec.md` is committed to git.
2. **Tests must be red first**: Do not spawn implementation agents until the test-writer agent confirms all tests fail.
3. **No skipped phases**: Each phase must complete before the next begins.
4. **All options via AskUserQuestion**: Never present choices as prose — always use the `AskUserQuestion` tool with structured options and a recommended choice.
5. **Explain before asking**: If a concept may be unfamiliar (WIP limits, Andon cord, syslog, etc.), explain it in plain terms before presenting the AskUserQuestion.
6. **State in files**: All state goes in `.kaizen/` (git-tracked). Never rely on agent memory for continuity.

---

## Resuming a Session

Before starting, check if `.kaizen/` exists in the current repo:

- If `.kaizen/spec.md` exists but `.kaizen/test-strategy.md` does not → resume at Phase 2
- If `.kaizen/test-strategy.md` exists but tests are not all green → resume at Phase 3
- If tests are all green but `.kaizen/kaizen.log` has no `status=done` acceptance entry → resume at Phase 4
- If acceptance is logged but docs are missing → resume at Phase 5
- If nothing exists → start at Phase 1

Tell the user which phase you are resuming from before proceeding.

---

## Phase 1 — Spec Alignment

**Goal:** Produce `.kaizen/spec.md` — a committed, agreed spec before any code is written.

Ask these questions **one at a time** using `AskUserQuestion`. Do not batch them.

### Q1: Intent
Ask: "What is the core problem this feature solves, or what does it add?"
- Free text — no options needed. Accept user's answer directly.

### Q2: Target output
Ask what the concrete deliverable is. Options (adjust based on Q1 answer):
- New slash command / skill
- New API endpoint or server-side route
- New UI component
- New CLI tool or subcommand
- Bug fix in existing code
- Refactor of existing code
- Other (prompt for description)

If user selects **Bug fix**: the spec template will include a Current Behaviour / Expected
Behaviour / Steps to Reproduce section. The test-writer agent will write a test that
reproduces the bug (must fail) before the fix is applied.

### Q3: Scope — what is IN scope
Ask the user to confirm or refine the scope. Present 2–3 options based on what they described in Q1/Q2, plus "Other". Always include a recommended option.

### Q4: Out-of-scope warnings
Ask: "What should this feature explicitly NOT do?" Present 3–4 common out-of-scope items based on the feature description, plus "None / not applicable". User may multiselect.

### Q5: Risks or unknowns
Ask: "Are there any known risks, unknowns, or dependencies to flag?" Options:
- External API dependency
- Requires new package/library
- Touches authentication or security
- Performance-sensitive path
- No known risks
Allow multiselect.

### After Q5: Write the spec

Write `.kaizen/spec.md` using this template.

For **features** (Q2 ≠ Bug fix):
```markdown
# Spec: {feature name}

**Date:** {today}
**Status:** Agreed

## Intent
{Q1 answer}

## Target Output
{Q2 answer}

## In Scope
{Q3 answer}

## Out of Scope
{Q4 answer}

## Risks / Unknowns
{Q5 answer}

## Acceptance Criterion
All tests in `.kaizen/test-strategy.md` pass. No manual exceptions.
```

For **bug fixes** (Q2 = Bug fix), add these sections:
```markdown
## Current Behaviour (Muda — defect)
{describe exactly what happens now, including error messages or wrong output}

## Expected Behaviour
{describe what should happen instead}

## Steps to Reproduce
1. {step}
2. {step}

## Acceptance Criterion
The regression test written in Phase 2 passes. No manual exceptions.
```

Then run:
```bash
git add .kaizen/spec.md
git commit -m "kaizen: spec aligned for {feature name}"
```

Tell the user the spec is committed, then proceed to Phase 2.

---

## Phase 2 — Test Strategy

**Goal:** Choose a test framework and write failing tests. Commit both before any implementation.

### Step 1: Detect the project stack

Read these files if they exist:
- `package.json` → TypeScript/JavaScript project
- `pyproject.toml` or `requirements.txt` → Python project
- `go.mod` → Go project
- `Cargo.toml` → Rust project
- `pom.xml` or `build.gradle` → Java/JVM project

### Step 2: Ask the user to confirm the framework

Based on detected stack AND project type, recommend:

| Stack | Project type | Recommended framework |
|---|---|---|
| TypeScript/JS | Has UI framework (React, Vue, Svelte) | Playwright (TypeScript) |
| TypeScript/JS | API only (express, fastify, koa — no UI) | Jest + Supertest |
| TypeScript/JS | CLI tool | Jest + child_process or Vitest |
| Python | Has `click`, `typer`, or `argparse` | pytest + click.testing.CliRunner |
| Python | Web (FastAPI, Django, Flask) | pytest + httpx or playwright-python |
| Python | General | pytest |
| Go | Any | go test (+ net/http/httptest for APIs) |
| Rust | Any | cargo test |
| Unknown / mixed | Any | Playwright (TypeScript) as safe default |

Present as `AskUserQuestion` with the recommended option first. Always include "Other — I'll specify" as the last option.

### Step 3: Spawn test-writer agent

Spawn a subagent with this prompt (fill in the blanks):

```
You are a test-writer agent for the kaizen-spec skill.

Feature spec: read .kaizen/spec.md carefully.
Test framework: {chosen framework}
Install command: {e.g. npm install -D @playwright/test}

Your job:
1. Install the test framework if not already present.
2. Write E2E and/or integration tests that cover every acceptance criterion in the spec.
3. Tests MUST all fail when run now (no implementation exists yet).
4. Write tests to: tests/e2e/{feature-slug}.spec.{ext} (or equivalent for the framework).
5. Run the tests and confirm they all fail. Report: "N tests written, all failing."
6. Do NOT write any implementation code.
```

### Step 4: Write test-strategy.md

After the test-writer reports back, write `.kaizen/test-strategy.md`:

```markdown
# Test Strategy: {feature name}

**Framework:** {chosen framework}
**Install:** {install command}
**Test files:** {path(s)}
**Tests written:** {N}
**Status:** All failing (red) ✓

## Test List
{list each test name and what it covers}

## Run command
{e.g. npx playwright test tests/e2e/feature.spec.ts}
```

Verify (Jidoka — 自働化): if tests that **directly reproduce the reported bug or missing feature** pass
before implementation, stop — the test cannot detect the defect. Ask the user to investigate.

For bug fixes: the regression test MUST fail before the fix is applied. Happy-path tests that
already pass (testing existing working behaviour) are expected to pass at this stage and do
NOT trigger this stop rule. Only tests that target the specific defect matter here.

Commit:
```bash
git add .kaizen/test-strategy.md tests/
git commit -m "kaizen: failing tests written for {feature name}"
```

Proceed to Phase 3.

---

## Phase 3 — Implementation

**Goal:** Subagent-parallelised implementation that drives all failing tests green.

### Step 1: Decompose into tasks

Read `.kaizen/spec.md` and the test list in `.kaizen/test-strategy.md`. Break the work into independent tasks (target: 2–5 per feature, each completable in one subagent session).

Write `.kaizen/tasks.json` using this schema:

```json
{
  "feature": "{feature name}",
  "spec_committed": "{ISO8601 timestamp}",
  "tasks": [
    {
      "id": "task-001",
      "title": "{short task title}",
      "phase": "impl",
      "status": "backlog",
      "agent": null,
      "wip_column": "backlog",
      "depends_on": [],
      "blocked_reason": null,
      "created_at": "{ISO8601 — when task was added to backlog}",
      "started_at": null,
      "completed_at": null
    }
  ],
  "wip_limits": {
    "in-progress": 3,
    "review": 2
  }
}
```

### Step 2: Initialise the kanban board

Copy `templates/board.html` to `.kaizen/board.html`. Replace the placeholder feature name with the actual feature name. Populate the Backlog column with one card per task from `tasks.json`.

Tell the user: "Board is live at `.kaizen/board.html` — open it in a browser to watch progress."

### Step 3: Spawn implementation agents

For each task (up to `wip_limits["in-progress"]` at a time), spawn a subagent using the
`Agent` tool with `isolation: "worktree"`.

→ Use the **Implementation Agent** prompt template in `references/agent-prompts.md`.
  Fill in `task.id`, `task.title`, and timestamps before spawning.

### Step 4: Monitor and unblock

Watch for blocked agents. If an agent reports a blocker:
- **Genchi Genbutsu (現地現物)**: Read `.kaizen/kaizen.log` and the actual error output directly.
  Do not rely on another agent's summary. The Gemba (現場) is the raw log line, not a description of it.
- Read `blocked_reason` from `tasks.json`
- Use `AskUserQuestion` to ask the user how to resolve it (present options if applicable)
- Once resolved, update the task status to `in-progress` and notify the agent

Before spawning the next task, check `depends_on` in `tasks.json` — only spawn a task when
all tasks in its `depends_on` list have `status: "done"`.

Spawn the next queued task as soon as a slot opens (WIP limit not exceeded).

### Step 5: Verify all tests green

After all tasks reach `done`, run the full test suite:

```bash
{run command from .kaizen/test-strategy.md}
```

If any tests fail: do NOT proceed to Phase 4. Spawn a fix agent for the failing tests, treating each as a new task.

Proceed to Phase 4 when all tests pass.

---

## Phase 4 — Acceptance

**Goal:** Confirm all tests pass and the feature meets the spec. Log the result.

### Step 1: Run the full test suite

```bash
{run command from .kaizen/test-strategy.md}
```

If any tests fail:
- Log: `{now} ERROR [kaizen] phase=acceptance status=failed failed_count={N}`
- Tell the user which tests failed and why
- Do NOT declare acceptance — return to Phase 3 to fix

### Step 2: Manual verification (if needed)

If the spec requires visual or user-interaction checks (e.g. UI rendering, keyboard navigation), use `AskUserQuestion`:

"Phase 4 requires manual verification. Please check the following and confirm:"
- Present each manual check as a checklist option
- User must confirm all before proceeding

### Step 3: 5S — Seiso (清掃) Cleanup

Before committing acceptance, run a targeted refactor pass to eliminate Muda (無駄/waste)
from the implementation code. The goal is **token reduction**: less code for future agents
to load means faster, cheaper sessions.

Spawn a cleanup agent with this prompt:

```
You are a 5S cleanup agent (Seiso — 清掃/Shine). Run immediately after acceptance tests pass.

Read the files changed in this feature (git diff HEAD~1..HEAD or the task list in tasks.json).

Apply these changes ONLY — do not refactor unrelated code:
1. Remove commented-out code and dead code paths (Seiri — 整理/Sort)
2. Remove verbose comments that just describe WHAT the code does (the code already says that)
   Keep only comments that explain WHY — hidden constraints, non-obvious invariants
3. Remove unused imports and variables
4. Apply consistent naming where the implementation introduced inconsistency (Seiton — 整頓)
5. Remove temp files and build artifacts from .kaizen/ (*.tmp, *.bak)

Do NOT:
- Change behaviour
- Change public interfaces
- Refactor code outside the feature's changed files
- Add new comments or documentation (Phase 5 handles that)

Run the tests after cleanup. If any fail, revert the cleanup change that broke them.
Report: "5S cleanup complete. Removed N lines of Muda. Tests still passing."
```

### Step 4: Log acceptance

```
{now} INFO [kaizen] phase=acceptance status=done duration={total_seconds}s tests={N}
```

Commit:
```bash
git add .kaizen/
git commit -m "kaizen: acceptance passed for {feature name}"
```

Tell the user: "Acceptance complete. All {N} tests pass. 5S cleanup done. Moving to docs."

---

## Phase 5 — Documentation (runs in parallel with Phase 3)

**Goal:** Write a VitePress doc page for the feature. Start this agent at the same time as the first implementation agent in Phase 3.

Spawn a doc agent with this prompt:

```
You are a documentation agent for the kaizen-spec skill.

Read .kaizen/spec.md carefully.

Write a VitePress documentation page for this feature at:
docs/guide/{feature-slug}.md

The page must include:
- A one-paragraph overview of what the feature does
- A "Usage" section with a concrete example
- A "Configuration" section if the feature has options
- A "How it works" section (brief — 3–5 sentences)

Also update docs/.vitepress/config.ts:
- Add an entry for the new page in the appropriate sidebar section

Use plain language. No jargon without explanation. Write for a developer who has never
used kaizen-spec before.

Commit when done:
  git add docs/
  git commit -m "kaizen: docs written for {feature name}"
```

---

## Kaizen Log Format Reference

Every agent must write to `.kaizen/kaizen.log` in this format:

```
YYYY-MM-DDTHH:MM:SSZ SEVERITY [kaizen] key=value key="quoted value if spaces"
```

Severity: `INFO`, `WARN`, `ERROR`

Standard events:

| Event | Severity | Required keys |
|---|---|---|
| Task started | INFO | phase, task, agent, status=started |
| Task done | INFO | phase, task, agent, status=done, cycle_time={s}s, lead_time={s}s |
| Task blocked | WARN | phase, task, agent, status=blocked, reason |
| Task unblocked | INFO | phase, task, agent, status=unblocked, duration |
| WIP limit hit | WARN | column, limit, attempted_task |
| Tests all red | INFO | phase=test, count, framework |
| Tests all green | INFO | phase=acceptance, count, duration |
| Acceptance failed | ERROR | phase=acceptance, failed_count, reason |
| 5S cleanup done | INFO | phase=acceptance, step=5s, lines_removed={N} |

**Lead Time** = `completed_at − created_at` (total time in system, including backlog wait)
**Cycle Time** = `completed_at − started_at` (active work time only)
Both are derived from `tasks.json` timestamps and logged on task-done events.

---

## Board Update Rules

When updating `.kaizen/board.html`:

- **Card move**: change the card's parent `<div data-status="...">` to the target column `<div>`
- **Blocked card**: add `data-blocked="true"` to the card element
- **WIP exceeded**: the JS in the board handles this client-side — agents do NOT need to enforce it in HTML, only in `tasks.json`
- **Write atomically**: write to `.kaizen/board.html.tmp` then rename to `.kaizen/board.html`

---

## End of Skill

When Phase 4 (acceptance) and Phase 5 (docs) are both complete, report:

```
kaizen-spec complete.

Feature:  {feature name}
Tests:    {N} passing
Duration: {total cycle time}
Board:    .kaizen/board.html (all cards in Done)
Log:      .kaizen/kaizen.log
Docs:     docs/guide/{feature-slug}.md
```

Ask the user if they want to start a new feature or end the session.
