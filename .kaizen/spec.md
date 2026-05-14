# Spec: Playwright Kanban Regression Tests

**Date:** 2026-05-14
**Status:** Agreed

## Intent

Write a Playwright regression test suite that verifies all four kanban board column functions work correctly. This prevents regressions when board.html is updated during future kaizen cycles — the board is the primary visual management tool for this project.

## Target Output

`tests/kanban.spec.ts` — Playwright test file that can be run with `npx playwright test` against a locally served `.kaizen/board.html`.

## In Scope

1. **All 4 columns render correctly** — Backlog (待辦), In Progress (在製品), Review (審査), Done (完了): headers present, Japanese subtitle labels visible, WIP badges present, ? help badges present.
2. **Card hover tooltips** — hovering a card shows a tooltip containing: status badge (✓ Done / ⚙ In Progress / ○ Backlog), description text, and timestamp rows (Created / Started / Completed / Cycle Time / Lead Time).
3. **Column ? tooltip content** — hovering each ? badge shows an HTML tooltip containing the column's kaizen explanation and Japanese term.
4. **WIP limit enforcement** — dragging a card past In Progress WIP=3 or Review WIP=2 shows the toast warning.
5. **Theme toggle + localStorage** — clicking ◐ Theme flips `data-bs-theme` attribute and writes to localStorage.

## Out of Scope

Nothing excluded — full coverage requested.

## Risks / Unknowns

- board.html must be served via HTTP (not file://) for Bootstrap tooltips and SortableJS to initialise correctly — a local HTTP server fixture is required in playwright.config.ts
- Drag-and-drop in Playwright requires `dragAndDrop` or mouse event simulation — SortableJS uses pointer events, need to verify compatibility
- Tooltip hover timing: Bootstrap tooltips have a 150ms show delay — tests must wait for tooltip visibility

## Acceptance Criterion

All tests in `.kaizen/test-strategy.md` pass. No manual exceptions.
