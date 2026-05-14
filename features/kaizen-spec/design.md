# Design: kaizen-spec Skill

**Feature ID:** kaizen-spec  
**Status:** Approved — proceed to checklist  
**Date:** 2026-05-14  
**Depends on:** [spec.md](spec.md)

---

## Repository Structure

```
kaizen-spec/
├── .claude/
│   └── commands/
│       └── kaizen-spec.md          ← skill entrypoint (Claude Code slash command)
├── features/
│   └── kaizen-spec/                ← OpenSpec feature folder (this document)
│       ├── proposal.md
│       ├── spec.md
│       ├── design.md
│       └── checklist.md
├── templates/
│   ├── board.html                  ← Bootstrap 5 kanban board template
│   ├── tasks.json                  ← empty tasks.json schema
│   └── test-strategy.md            ← test strategy document template
├── docs/                           ← VitePress documentation site
│   ├── .vitepress/
│   │   └── config.ts               ← VitePress config (dark + light theme)
│   ├── index.md                    ← docs home
│   ├── guide/
│   │   ├── getting-started.md
│   │   ├── phases.md
│   │   └── kanban.md
│   └── reference/
│       ├── state-schema.md
│       └── kaizen-log.md
├── .github/
│   └── workflows/
│       └── docs.yml                ← VitePress build + GitHub Pages deploy
├── HANDOVER.md
└── README.md
```

---

## Skill Entrypoint: `.claude/commands/kaizen-spec.md`

The skill is a single markdown file loaded by Claude Code as a slash command. It contains:

1. **System prompt** — persona, constraints, phase gating rules
2. **Phase instructions** — one section per phase, each with the exact `AskUserQuestion` calls to make
3. **File templates** — inline templates for `board.html`, `tasks.json`, `kaizen.log` format
4. **Subagent prompts** — template prompts for each subagent type (impl agent, doc agent)

The skill is self-contained: no imports, no external scripts. An agent reads the file and follows the instructions.

### Skill Invocation Flow

```
User: /kaizen-spec [optional: feature description]
  │
  ├─ Phase 1: Spec Alignment
  │    AskUserQuestion × 4-6 questions (intent, output, scope, risks)
  │    → writes .kaizen/spec.md
  │    → git commit "kaizen: spec aligned for <feature>"
  │
  ├─ Phase 2: Test Strategy
  │    detect project stack (scan package.json / pyproject.toml / go.mod)
  │    AskUserQuestion: confirm test framework
  │    spawn test-writer subagent → writes failing tests
  │    → writes .kaizen/test-strategy.md
  │    → git commit "kaizen: failing tests written for <feature>"
  │    verify all tests fail (if any pass: warn user, do not proceed)
  │
  ├─ Phase 3: Implementation
  │    read .kaizen/tasks.json → decompose into parallel tasks
  │    for each task: spawn impl subagent in git worktree
  │    each subagent:
  │      → reads .kaizen/spec.md + .kaizen/test-strategy.md
  │      → claims task in .kaizen/tasks.json (status: in-progress)
  │      → updates .kaizen/board.html
  │      → writes .kaizen/kaizen.log entry (started)
  │      → implements until tests pass
  │      → on block: sets status=blocked, Andon flag on board, log entry
  │      → on complete: status=done, log entry (completed, duration)
  │    doc agent runs in parallel (phase 5 overlaps here)
  │
  ├─ Phase 4: Acceptance
  │    run full test suite
  │    if any fail: log WARN, notify user, block acceptance
  │    if manual check needed: AskUserQuestion (not a blocking prompt)
  │    → log INFO acceptance result + total cycle time
  │    → git commit "kaizen: acceptance passed for <feature>"
  │
  └─ Phase 5: Docs (parallel with phase 3)
       doc agent reads .kaizen/spec.md
       writes docs/<feature>.md in VitePress format
       updates docs/.vitepress/config.ts sidebar
       → git commit "kaizen: docs written for <feature>"
```

---

## Kanban Board: `templates/board.html`

**Tech stack:** Bootstrap 5 CDN + SortableJS CDN. No build step.

### Column Structure

```
┌──────────────┬──────────────────┬──────────────┬──────────────┐
│   Backlog    │   In Progress    │   Review     │     Done     │
│              │   WIP max: 3     │  WIP max: 2  │              │
├──────────────┼──────────────────┼──────────────┼──────────────┤
│  [card]      │  [card]          │  [card]      │  [card]      │
│  [card]      │  [card] ⚠ BLOCK │              │  [card]      │
│              │  [card]          │              │              │
└──────────────┴──────────────────┴──────────────┴──────────────┘
```

### WIP Limit Enforcement (client-side JS, ~20 lines)

```javascript
// On SortableJS drop event:
function onCardDrop(col, card) {
  const limit = parseInt(col.dataset.wipLimit, 10);
  const current = col.querySelectorAll('.kaizen-card').length;
  if (limit && current >= limit) {
    col.classList.add('wip-exceeded');  // → Bootstrap bg-danger header
    card.revert();                       // move card back
    return;
  }
  col.classList.remove('wip-exceeded');
  updateTasksJson(card.dataset.taskId, col.dataset.status);
}
```

### Andon Flag (blocked state)

A blocked card gets:
- `data-blocked="true"` attribute
- Bootstrap `border-danger` class + `⚠` badge
- Column header does not change (blocker is card-level, not column-level)

### Live Reload

Agents rewrite `board.html` on each state change. The board includes:

```html
<script>
  // Poll for file modification — works with VS Code Live Server or Python http.server
  setInterval(() => location.reload(), 5000);
</script>
```

---

## State Files

### `.kaizen/tasks.json`

Agents read this to claim work and write back status updates. The file is the single source of truth for task state. No two agents may write simultaneously — each agent reads, mutates one task, and writes back atomically (write to `.kaizen/tasks.json.tmp`, then rename).

### `.kaizen/kaizen.log`

Append-only. Agents never overwrite existing lines. Each agent appends one line per state transition. Format:

```
YYYY-MM-DDTHH:MM:SSZ SEVERITY [kaizen] key=value key="quoted value"
```

Standard events:
| Event | Severity | Keys |
|---|---|---|
| Task claimed | INFO | phase, task, agent, status=started |
| Task complete | INFO | phase, task, agent, status=done, duration |
| Task blocked | WARN | phase, task, agent, status=blocked, reason |
| Task unblocked | INFO | phase, task, agent, status=unblocked, duration |
| WIP limit hit | WARN | column, limit, attempted_task |
| Tests all red | INFO | phase=test, count, framework |
| Tests all green | INFO | phase=acceptance, count, duration |
| Acceptance failed | ERROR | phase=acceptance, failed_count, reason |

---

## Subagent Design

### Implementation Agent (per task)

Spawned by the orchestrator via the `Agent` tool with `isolation: "worktree"`.

Prompt template (written into the skill entrypoint):
```
You are an implementation agent for the kaizen-spec skill.

Your task: {task.title}

Read these files first:
- .kaizen/spec.md       — what you are building
- .kaizen/test-strategy.md — what "done" means (tests that must pass)
- .kaizen/tasks.json    — claim task {task.id} by setting status=in-progress

Implement until the tests for your task pass.
On any blocker: set status=blocked in tasks.json, add ⚠ badge to your card in board.html,
append a WARN line to kaizen.log with reason="{reason}".
On completion: set status=done, append INFO line to kaizen.log with duration.
```

### Doc Agent (parallel with impl)

Reads `.kaizen/spec.md` and writes a VitePress page to `docs/guide/{feature}.md`. Updates `docs/.vitepress/config.ts` sidebar. Commits on completion.

### Test Writer Agent (phase 2)

Reads `.kaizen/spec.md`, detects stack, writes failing tests. Reports back to orchestrator: "N tests written, all failing." Orchestrator verifies before proceeding.

---

## VitePress Configuration

```typescript
// docs/.vitepress/config.ts
import { defineConfig } from 'vitepress'

export default defineConfig({
  title: 'kaizen-spec',
  description: 'Spec-driven, kaizen-informed agentic development',
  appearance: 'auto',        // respects OS dark/light preference; user can toggle
  themeConfig: {
    nav: [
      { text: 'Guide', link: '/guide/getting-started' },
      { text: 'Reference', link: '/reference/state-schema' }
    ],
    sidebar: {
      '/guide/': [
        { text: 'Getting Started', link: '/guide/getting-started' },
        { text: 'Phases', link: '/guide/phases' },
        { text: 'Kanban Board', link: '/guide/kanban' }
      ],
      '/reference/': [
        { text: 'State Schema', link: '/reference/state-schema' },
        { text: 'Kaizen Log', link: '/reference/kaizen-log' }
      ]
    },
    socialLinks: [
      { icon: 'github', link: 'https://github.com/jackyko/kaizen-spec' }
    ]
  }
})
```

---

## CI/CD: `.github/workflows/docs.yml`

```yaml
name: Docs
on:
  push:
    branches: [main]
    paths: ['docs/**']
jobs:
  build-deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with: { node-version: '20' }
      - run: npm install -g vitepress
      - run: vitepress build docs
      - uses: peaceiris/actions-gh-pages@v4
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: docs/.vitepress/dist
```

---

## Self-Hosting Test Plan

The skill is complete when this sequence works end-to-end:

1. Check out `kaizen-spec` repo
2. Open in Claude Code
3. Run `/kaizen-spec "add a new kaizen-log viewer command"`
4. Verify:
   - Phase 1 produces `.kaizen/spec.md` (committed)
   - Phase 2 produces `.kaizen/test-strategy.md` + failing Playwright tests (committed)
   - Phase 3 updates `board.html` in real time; all tests go green
   - Phase 4 passes acceptance without manual intervention
   - Phase 5 produces `docs/guide/kaizen-log-viewer.md`
5. Open `.kaizen/board.html` in a browser — board must reflect final state with all cards in Done
6. Read `.kaizen/kaizen.log` — must contain INFO lines for every state transition

---

## Key Design Constraints

| Constraint | Reason |
|---|---|
| Board is plain HTML + Bootstrap CDN | Minimum agent token cost per update; no build step |
| All state in `.kaizen/` files | Fresh agents resume without human in the loop |
| No agent writes code before spec committed | Enforced by skill phase gate (F-02) |
| Tests must be red before impl starts | Verified by test-writer agent report (F-03) |
| `kaizen.log` is append-only syslog | Machine-readable, grep-able, never conflicts on concurrent writes |
