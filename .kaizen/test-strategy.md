# Test Strategy: Stabilize kanban live update

**Framework:** bats-core (existing suite - `tests/test_selfhost.bats`)
**Install:** `make install-bats`
**Test files:** `tests/test_selfhost.bats` (group r, tests r1-r6)
**Tests written:** 6
**Status:** All failing (red) - confirmed before implementation

## Test List

| # | Test | Covers |
|---|------|--------|
| r1 | render_board.py writes sentinel with --sentinel flag | Sentinel written when path given explicitly |
| r2 | Sentinel content is ISO8601 timestamp | Format is machine-parseable datetime |
| r3 | render_board.py writes sentinel to default path | Default: same dir as tasks.json, named .render-ts |
| r4 | board.html uses fetch-based smart-poll, not location.reload() | Blind reload removed, fetch() present |
| r5 | board.html smart-poll interval is 1000ms | 1s cadence confirmed in template |
| r6 | hook always re-renders, no elif grep tasks.json guard | Hook decoupled from stdin content grep |

## Run command

```bash
make eval
```
