# The Five Phases

kaizen-spec enforces five phases in order. No phase can be skipped. Each phase gates the next.

---

## Phase 1 - Spec Alignment

**What happens:** The skill asks you a series of structured questions - one at a time - about what you want to build, what the output should be, what is in scope, what is explicitly out of scope, and what risks exist.

**What gets written:** `.kaizen/spec.md` - a committed, agreed specification.

**Gate:** Nothing in Phase 2 starts until `.kaizen/spec.md` is committed to git.

**Why:** Agents that write code without a spec solve the wrong problem. This phase costs 2–5 minutes and saves hours of rework.

---

## Phase 2 - Test Strategy

**What happens:** The skill detects your project stack (TypeScript, Python, Go, etc.) and recommends a test framework. You confirm or choose an alternative. A test-writer agent then writes tests for every acceptance criterion in the spec - and verifies they all **fail** before proceeding.

**What gets written:**
- `.kaizen/test-strategy.md` - the framework, install command, test file paths, and a list of every test
- `tests/` - the actual test files (all failing)

**Gate:** If any test passes at this stage, the skill stops and asks you to investigate - a passing test before implementation means either the test is wrong or the feature already exists.

**Why:** Tests written after the code tend to test the code as written, not the spec as agreed. Writing them first forces honest coverage.

---

## Phase 3 - Implementation

**What happens:** The skill decomposes the spec into independent tasks, writes them to `.kaizen/tasks.json`, and spawns subagents in parallel - one per task, each in a git worktree. Agents implement until their tests pass, then mark themselves done.

**What gets written:**
- `.kaizen/tasks.json` - task list with status, agent assignments, and timestamps
- `.kaizen/board.html` - live kanban board (open in a browser to watch)
- `.kaizen/kaizen.log` - one syslog entry per state transition
- Implementation code (in git worktrees, merged on completion)

**WIP limits:** At most 3 tasks can be "in progress" simultaneously. At most 2 can be in "review". Exceeding a limit turns the column header red and blocks the move.

**Andon cord:** If an agent gets stuck, it sets a blocked flag on its board card and logs a `WARN` entry to `kaizen.log`. You are notified and can unblock it.

**Gate:** All tests must pass before Phase 4 begins.

---

## Phase 4 - Acceptance

**What happens:** The skill runs the full test suite. If anything fails, it does not declare done - it returns to Phase 3 to fix the failures. If manual verification is needed (e.g. visual UI checks), you are asked to confirm specific items.

**What gets written:**
- `.kaizen/kaizen.log` - acceptance result and total cycle time

**Gate:** All tests green + any required manual confirmations.

**Why:** "Done" means working software, not working-on-my-machine.

---

## Phase 5 - Docs (parallel with Phase 3)

**What happens:** A doc agent starts at the same time as the first implementation agent. It reads `.kaizen/spec.md` and writes a VitePress page for the feature. It updates the sidebar config. It commits when done.

**What gets written:**
- `docs/guide/{feature}.md`
- Updated `docs/.vitepress/config.ts`

**Why:** Docs written after the fact are always deferred. Running them in parallel means they are done before acceptance.

---

## Resuming After a Restart

Because all state lives in `.kaizen/` files (git-tracked), the skill can resume at any phase:

| State of `.kaizen/` | Resumes at |
|---|---|
| No `.kaizen/` directory | Phase 1 |
| `spec.md` exists, no `test-strategy.md` | Phase 2 |
| `test-strategy.md` exists, tests not all green | Phase 3 |
| Tests all green, no acceptance log entry | Phase 4 |
| Acceptance logged, docs missing | Phase 5 |
