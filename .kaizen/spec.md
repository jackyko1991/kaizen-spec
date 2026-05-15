# Spec: Stabilize kanban live update

**Date:** 2026-05-15
**Status:** Agreed

## Intent
The kanban board reloads every 5 seconds via `location.reload()`, causing a full-page flash
even when nothing has changed. The PostToolUse hook also relies solely on grepping stdin for
the string "tasks.json", which misses edge cases (e.g. tool inputs that touch tasks.json
indirectly). Both issues reduce the reliability and polish of the live board experience.

## Target Output
Refactor of existing code across three files:
- `templates/board.html` - replace blind reload with 1s smart-poll (fetch + timestamp diff)
- `scripts/render_board.py` - write `.kaizen/.render-ts` sentinel file on every render
- `.claude/hooks/update-board.sh` - trigger on sentinel file presence/change, not stdin grep

## In Scope
- 1s smart-poll: fetch board.html every 1s, extract rendered timestamp, reload only if changed
- Sentinel file `.kaizen/.render-ts` written by render_board.py on every successful render
- Hook updated to always re-render (sentinel approach decouples from stdin format)
- Bats regression tests (group r): sentinel write verified, smart-poll logic documented

## Out of Scope
- No WebSocket or SSE server - stays file-based, no persistent process
- No React or JS build step - board remains a single self-contained HTML file
- No changes to tasks.json schema - sentinel is a separate file
- No changes to board visual design - only reload behaviour changes

## Risks / Unknowns
No known risks. All changes are local file I/O and browser fetch with no external dependencies.

## Acceptance Criterion
All tests in `.kaizen/test-strategy.md` pass. No manual exceptions.
