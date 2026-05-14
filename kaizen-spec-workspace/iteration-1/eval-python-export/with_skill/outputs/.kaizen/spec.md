# Spec: /export command for Python CLI

**Date:** 2026-05-14
**Status:** Agreed

## Intent
Add an /export command that lets users export their stored data to CSV or JSON format.

## Target Output
New CLI command (Click-based, integrating with existing SQLite data store)

## In Scope
- The `export` Click command accessible via the CLI
- CSV output format
- JSON output format
- `--format` option to choose between csv and json (default: json)
- `--output` / `-o` option to specify a file path (default: stdout)
- Error handling for empty data (exit with informative message, non-zero exit code)
- Error handling for unwritable file path

## Out of Scope
- No UI (no interactive prompts beyond the CLI flags)
- No streaming export (full in-memory export only)
- No compression (no gzip, zip, or other archive formats)

## Risks / Unknowns
- Requires new package/library: csv module is stdlib and sufficient for basic exports, but if complex
  type coercion or large dataset support is needed, pandas may be required. Decision: start with
  stdlib csv; escalate to pandas only if tests reveal a gap.

## Acceptance Criterion
All tests in `.kaizen/test-strategy.md` pass. No manual exceptions.
