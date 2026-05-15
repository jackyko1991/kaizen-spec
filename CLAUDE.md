# CLAUDE.md - kaizen-spec repo

## This repo IS the kaizen-spec skill

The canonical skill file is `.claude/commands/kaizen-spec.md` in this repo.
When you open this repo in Claude Code, `/kaizen-spec` automatically picks up
that local version - no install step needed. Edit the skill, invoke it
immediately, and see the result.

This is the self-hosting loop:
1. Edit `.claude/commands/kaizen-spec.md`
2. Invoke `/kaizen-spec` in this repo
3. The change is live - no reinstall, no copy step

## Developing and testing the skill

Run the trigger-accuracy eval suite:

```bash
make eval
```

This runs `tests/test_selfhost.bats` via bats-core. If bats is not on your
PATH, install it first:

```bash
make install-bats
```

Then re-run `make eval`.

## Repo structure

```
.claude/commands/       # kaizen-spec skill (canonical source)
.claude/hooks/          # Claude Code hooks (e.g. board auto-update)
references/             # Skill reference files (glossary, prompts)
templates/              # board.html template
docs/                   # User-facing guides
  guide/getting-started.md
tests/                  # bats acceptance tests
  test_selfhost.bats
evals/                  # Trigger-eval JSON and results
.kaizen/                # This repo's own kaizen board + log
  spec.md               # Feature spec
  test-strategy.md      # Test strategy
  tasks.json            # Task tracking
  board.html            # Live kanban board
  kaizen.log            # Append-only event log
```

## Dev process

kaizen-spec uses kaizen-spec to develop itself:

1. **Spec** - agree on intent in `.kaizen/spec.md`
2. **Tests red** - write failing tests in `tests/`
3. **Implement** - write code until tests go green
4. **Acceptance** - all tests pass, no exceptions
5. **Docs** - update `docs/` if user-facing behaviour changed

Gate rule: never move to the next phase until the current phase is complete.

## Writing style

- **No em-dashes** (`—`, U+2014). Use a regular hyphen-dash (` - `) instead.
  Em-dashes render inconsistently across terminals and some markdown renderers.
  This applies to all files in this repo: docs, skill, CLAUDE.md, commit messages.

## Board auto-update (live kanban)

`.claude/settings.json` registers PostToolUse hooks that re-render the kanban board
whenever `.kaizen/tasks.json` changes. **Every tool that touches tasks.json fires the hook:**

| Tool | When it fires |
|---|---|
| `Write` | tasks.json written from scratch |
| `Edit` | tasks.json patched in place |
| `Bash` | Python/shell script that writes tasks.json |
| `Agent` | Subagent completes and may have updated tasks.json |

The hook (`update-board.sh`) reads the tool's JSON from stdin, checks if `tasks.json`
appears anywhere in the tool input, and if so runs `python3 scripts/render_board.py`.
The board auto-reloads every 5 seconds while `make board` is running.

**Rule for this repo:** always update `.kaizen/tasks.json` (not board.html directly)
and the board will update itself. Never hand-edit board.html.
