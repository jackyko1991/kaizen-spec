# Spec: kaizen-spec Skill

**Feature ID:** kaizen-spec  
**Status:** Approved — proceed to design  
**Date:** 2026-05-14  
**Depends on:** [proposal.md](proposal.md)

---

## Overview

`kaizen-spec` is a Claude Code skill (slash command) that enforces a five-phase, spec-first, TDD-enforced, kaizen-informed development workflow. It is self-hosting: the primary acceptance criterion is that the skill can be used to develop itself.

---

## User Stories

### Phase 1 — Spec Alignment
- **As a developer**, I run `/kaizen-spec` and am asked a series of structured questions (via `AskUserQuestion`) about my intent, target output, scope, and out-of-scope boundaries — so that I never write code against the wrong problem.
- **As a developer**, I can answer questions one at a time, with a recommended option always surfaced — so that I can accept defaults quickly or override them deliberately.
- **As a developer**, unfamiliar technical terms are explained in plain language before I am asked to choose — so that I am never forced to pick between options I don't understand.
- **As a developer**, the agreed spec is written to `.kaizen/spec.md` and committed to git before phase 2 begins — so that future agents can read the spec without needing me in the loop.

### Phase 2 — Test Strategy
- **As a developer**, I am asked to choose a test framework based on my project's detected stack (TypeScript → Playwright, Python → pytest+Playwright, etc.) — so that the recommendation is relevant to my project.
- **As a developer**, the skill writes initial tests that all fail (red) before any implementation begins — so that I can verify the tests are real, not vacuous.
- **As a developer**, the test plan is written to `.kaizen/test-strategy.md` and committed to git — so that implementation agents know exactly what "done" means.

### Phase 3 — Implementation
- **As a developer**, the skill spawns subagents in parallel across independent tasks — so that implementation is faster than a single-agent loop.
- **As a developer**, each subagent operates in a git worktree — so that agents don't conflict on shared files.
- **As a developer**, the kanban board at `.kaizen/board.html` updates as agents claim and complete tasks — so that I can see real-time progress without asking the skill for a status update.
- **As a developer**, WIP limits per column prevent agents from overloading any single phase — so that throughput is sustained, not burst-then-stall.
- **As a developer**, if an agent becomes blocked, it sets an Andon flag on its board card and logs to `.kaizen/kaizen.log` — so that I am notified and can unblock it.

### Phase 4 — Acceptance
- **As a developer**, the skill runs the full test suite and does not declare success until all tests pass — so that I never receive a "done" notification for broken code.
- **As a developer**, when manual verification is needed (e.g. visual UI checks), I am notified with specific instructions — so that I know exactly what to do, not just that something needs doing.
- **As a developer**, the skill logs the acceptance result and cycle time to `.kaizen/kaizen.log` — so that I can track how long acceptance takes across cycles.

### Phase 5 — Docs in Parallel
- **As a developer**, a VitePress doc page is written for the feature while implementation is running — so that docs are never a deferred chore.
- **As a developer**, the doc site supports dark and light themes out of the box — so that I don't need to configure it.
- **As a developer**, docs are deployed to GitHub Pages via CI when changes merge — so that the doc site is always up to date.

### Self-Hosting (Acceptance Criterion)
- **As the skill author**, I can run `/kaizen-spec` on the `kaizen-spec` repository itself to add a new feature — so that the skill is proven to work on real, non-trivial projects.
- **As the skill author**, every phase of the skill leaves git-tracked state in `.kaizen/` — so that the development of the skill is itself transparent and auditable.

---

## Functional Requirements

| ID | Requirement |
|---|---|
| F-01 | The skill MUST surface all options via `AskUserQuestion` with a recommended option |
| F-02 | The skill MUST NOT write any implementation code before a spec is committed to `.kaizen/spec.md` |
| F-03 | The skill MUST write failing tests before spawning implementation agents |
| F-04 | The skill MUST update `.kaizen/board.html` when task status changes |
| F-05 | WIP limits MUST be enforced: agents cannot move a card into a full column |
| F-06 | Blocked agents MUST write an Andon entry to `.kaizen/kaizen.log` and update their board card |
| F-07 | The skill MUST NOT declare acceptance until all tests in `.kaizen/test-strategy.md` pass |
| F-08 | `.kaizen/kaizen.log` MUST use syslog format (RFC 5424-inspired, not markdown) |
| F-09 | All `.kaizen/` files MUST be git-tracked so fresh agents can resume from file state alone |
| F-10 | The skill MUST work on the `kaizen-spec` repo itself (self-hosting) |

---

## Non-Functional Requirements

| ID | Requirement |
|---|---|
| N-01 | Board HTML must be writable by an agent in a single file patch (no build step) |
| N-02 | Agent token cost per board update must be minimised (Bootstrap CDN, no framework) |
| N-03 | The skill entrypoint must be a single markdown file loadable by Claude Code |
| N-04 | No external services required at runtime (no hosted backends, no auth) |
| N-05 | VitePress doc site must build with `vitepress build` and zero manual config |

---

## State Schema

### `.kaizen/tasks.json`
```json
{
  "feature": "string",
  "spec_committed": "ISO8601 timestamp | null",
  "tasks": [
    {
      "id": "string",
      "title": "string",
      "phase": "spec | test | impl | acceptance | docs",
      "status": "backlog | in-progress | blocked | done",
      "agent": "string | null",
      "wip_column": "string",
      "blocked_reason": "string | null",
      "started_at": "ISO8601 | null",
      "completed_at": "ISO8601 | null"
    }
  ],
  "wip_limits": {
    "in-progress": 3,
    "review": 2
  }
}
```

### `.kaizen/kaizen.log` (syslog format)
```
YYYY-MM-DDTHH:MM:SSZ SEVERITY [kaizen] key=value key="quoted value" ...
```

Severity levels: `INFO`, `WARN`, `ERROR`  
Standard keys: `phase`, `task`, `agent`, `status`, `reason`, `duration`

Example:
```
2026-05-14T10:23:45Z INFO [kaizen] phase=implementation task=board-html agent=subagent-1 status=started
2026-05-14T10:31:02Z WARN [kaizen] phase=implementation task=board-html agent=subagent-1 status=blocked reason="SortableJS CDN unreachable"
2026-05-14T10:35:18Z INFO [kaizen] phase=implementation task=board-html agent=subagent-1 status=unblocked duration=256s
```

---

## Out of Scope

- Human team project management features
- Real-time multi-user collaboration on the board
- Integration with external issue trackers (GitHub Issues, Linear, Jira)
- Authentication or access control
- Mobile-responsive board (desktop-first is sufficient)
