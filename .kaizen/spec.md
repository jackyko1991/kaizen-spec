# Spec: Index homepage redesign - Lean-first

**Date:** 2026-05-15
**Status:** Agreed

## Intent
The current homepage uses VitePress default feature cards with generic descriptions.
It does not lead with Lean/TPS identity, buries the install command below a long features
grid, and has no visual demonstration of the kanban board. The redesign makes the Lean
philosophy first-class, simplifies the install path, and adds an interactive kanban mock.

## Target Output
Refactor of docs pages across all 3 locales:
- `docs/index.md` - English homepage
- `docs/zh-TW/index.md` - Traditional Chinese homepage
- `docs/ja/index.md` - Japanese homepage
- `docs/guide/kanban.md` - English kanban guide (add column hover tooltips)
- `docs/zh-TW/guide/kanban.md` - zh-TW kanban guide
- `docs/ja/guide/kanban.md` - Japanese kanban guide

## In Scope
- Hero text changed to "Lean-first agentic development" with TPS tagline
- YAML features array replaced with 6 custom HTML feature cards:
  1. Spec before code (Decide Late)
  2. Tests red before green (Jidoka)
  3. WIP limits + one-piece flow
  4. Lean Development / TPS mapping
  5. Kanban workflow (live board, Andon, drag to columns)
  6. Standard Work + fresh-context resilient
- Install section: curl one-liner only; dev-mode hidden behind "Full install guide" link
- Install section positioned right of feature cards (sidebar on desktop)
- HTML kanban mock at bottom of homepage: 4 columns, mock cards, CSS hover tooltip on
  each column header explaining the kaizen concept + Japanese term
- CSS hover tooltips added to kanban column descriptions in guide/kanban.md pages
- All internal links use explicit locale prefix (/zh-TW/..., /ja/...) in locale pages
- All 3 locales updated with translated content

## Out of Scope
- No new npm packages beyond what is already installed
- No backend or server changes
- No changes to board.html rendering logic
- No authentication or security changes
- No changes to the bats test suite structure

## Risks / Unknowns
No known risks. All changes are VitePress markdown/HTML - no build tooling changes required.

## Acceptance Criterion
All tests in `.kaizen/test-strategy.md` pass. No manual exceptions.
