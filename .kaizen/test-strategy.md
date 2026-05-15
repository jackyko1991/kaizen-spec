# Test Strategy: Playwright Kanban Regression Tests

**Framework:** Playwright (TypeScript)
**Install:** `npm install -D @playwright/test && npx playwright install chromium --with-deps`
**Test files:** `tests/kanban.spec.ts`
**Config:** `playwright.config.ts` (webServer: python3 serves .kaizen/ on port 9999)
**Tests written:** 14
**Status:** All passing ✓

## Test List

| # | Group | Test | Covers |
|---|-------|------|--------|
| 1 | Column structure | English headers visible | Backlog/In Progress/Review/Done headers render |
| 2 | Column structure | Japanese subtitles visible | 待辦/在製品/審査/完了 labels present |
| 3 | Column structure | WIP badges present | Count badges exist on all 4 columns |
| 4 | Column structure | ? help badges present | `.col-help` on all 4 columns |
| 5 | Card tooltips | Tooltip appears on hover | `.tooltip.show` in DOM after hover |
| 6 | Card tooltips | Tooltip contains ✓ Done status | Status badge matches column position |
| 7 | Card tooltips | Tooltip contains description | `<p>` with task description text |
| 8 | Card tooltips | Tooltip contains "Completed" | Timestamp table rows render (sanitize:false) |
| 9 | Column ? tooltips | Backlog ? shows 待辦/Backlog | Column explanation tooltip |
| 10 | Column ? tooltips | Done ? shows 完了/CT/Lead Time | Done column explanation |
| 11 | WIP enforcement | 4th card into In Progress shows toast | #wipToast visible |
| 12 | WIP enforcement | Toast text contains "WIP limit" | Andon message correct |
| 13 | Theme toggle | data-bs-theme flips on click | ◐ button works |
| 14 | Theme toggle | localStorage written | Preference persists |

## Bugs found and fixed during test writing

1. **`col` declared after use** - `initCardTooltips()` used `col` on line 355 but declared it on line 377, causing a `ReferenceError` that silently aborted all tooltip initialisation.
2. **Bootstrap sanitizer stripping `<table>`** - Bootstrap tooltips strip table elements by default. Fixed with `sanitize: false` in tooltip init (content is internal, not user-generated).

## Run command

```bash
npx playwright test tests/kanban.spec.ts
```
