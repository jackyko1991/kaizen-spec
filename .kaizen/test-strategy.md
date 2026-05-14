# Test Strategy: kaizen-spec Self-Hosting & Developer Experience

**Framework:** bats-core (installed from source at /tmp/bats-install)
**Install:** `git clone https://github.com/bats-core/bats-core /tmp/bats-install && /tmp/bats-install/install.sh /tmp/bats-install`
**Test files:** `tests/test_selfhost.bats`
**Tests written:** 13
**Status:** 11 failing (red) ✓ — 2 passing on pre-existing files (correct)

## Test List

| Test | What it covers |
|------|---------------|
| a1: CLAUDE.md exists | Self-hosting: CLAUDE.md present at repo root |
| a2: CLAUDE.md references .claude/commands | Self-hosting: CLAUDE.md tells Claude to use local skill |
| b1: install.sh exists | curl install: script present |
| b2: install.sh is executable | curl install: chmod +x applied |
| b3: install.sh contains curl/wget | curl install: script uses curl or wget to download |
| c1: install.sh installs kaizen-spec.md | curl install: running install.sh (with INSTALL_DIR override) creates the file |
| d1: Makefile exists | Self-hosting: Makefile present |
| d2: Makefile has `eval` target | Self-hosting: `make eval` entry point exists |
| e1: README no "Ralph-style" | Philosophy: jargon removed |
| f1: README has 2+ TPS concepts | Philosophy: Jidoka/Muda/Poka-Yoke/JIT/TPS present |
| g1: getting-started.md exists | Pre-existing — must not break |
| g2: curl before git clone | curl install: docs promote curl as Option A |
| h1: templates/board.html exists | Pre-existing — must not break |

## Jidoka verification

Tests a1–f1 and g2 all fail on current code — they correctly cannot detect features that don't exist yet. ✓

Tests g1 and h1 pass on pre-existing files — these are NOT defect-targeting tests, so they do NOT trigger the stop rule.

## Run command

```bash
/tmp/bats-install/bin/bats tests/test_selfhost.bats
```

Or after installing bats globally:
```bash
bats tests/test_selfhost.bats
```
