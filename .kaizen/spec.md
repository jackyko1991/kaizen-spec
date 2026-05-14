# Spec: kaizen-spec Self-Hosting & Developer Experience

**Date:** 2026-05-14
**Status:** Agreed

## Intent

Four improvements that close the gap between using kaizen-spec and developing it:

1. **Self-hosting loop** — wire this repo so `/kaizen-spec` always picks up the local `.claude/commands/kaizen-spec.md`. Changes to the skill are immediately testable without reinstalling. Add a `Makefile` target that runs trigger-evals against the local skill in one command.

2. **curl install** — an `install.sh` script so users can onboard with one command (`curl | bash`) without needing git. Update `getting-started.md` to feature curl as the primary install path.

3. **Live kanban board for this repo** — bootstrap `.kaizen/board.html` and `tasks.json` so this repo's own development backlog is visible in a browser. kaizen-spec uses kaizen-spec to manage itself.

4. **Philosophy section rewrite** — rewrite the README philosophy in plain language grounded in the TPS → Lean Software Development → Agentic AI mapping (Poppendieck). Drop internal jargon ("Ralph-style"). Map Toyota concepts to their software equivalents:
   - Inventory → Unshipped code / undeployed features
   - JIT → CI/CD (pull, don't push)
   - Jidoka → TDD (tests stop the line when defects appear)
   - Poka-Yoke → Static typing, linting, schema validation
   - Kaizen → Refinement loops and Spec Kaizen (test failures feed back into spec)
   - One-piece flow → Atomic Specs per agent task (reduce cognitive load, increase accuracy)

## Target Output

New and updated files in this repo:
- `CLAUDE.md` (new) — self-hosting declaration and dev instructions
- `install.sh` (new) — curl-installable setup script
- `Makefile` (new or updated) — `make eval` target for running trigger-evals locally
- `README.md` — philosophy section rewrite
- `docs/guide/getting-started.md` — curl as Option A (promoted above git clone)
- `.kaizen/board.html` — live kanban for this repo's backlog
- `.kaizen/tasks.json` — seeded with current feature tasks

## In Scope

- Self-hosting: CLAUDE.md + Makefile eval target
- curl install script (bash + curl, Unix/Mac/WSL)
- Philosophy rewrite using Poppendieck TPS→Software mapping
- Live `.kaizen/` board seeded with backlog for this repo

## Out of Scope

- Five-phase workflow logic (Phases 1–5 structure and gate conditions)
- Board HTML visual redesign
- Test framework detection table (Phase 2)

## Risks / Unknowns

No known risks identified. install.sh will note Windows-without-WSL limitation in its header.

## Acceptance Criterion

All tests in `.kaizen/test-strategy.md` pass. No manual exceptions.
