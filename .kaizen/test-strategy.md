# Test Strategy: Index homepage redesign - Lean-first

**Framework:** bats-core (`tests/test_selfhost.bats`, group s, tests s1-s12)
**Install:** `make install-bats`
**Tests written:** 12
**Status:** 7 failing (red), 5 already passing (locale links pre-existing)

## Test List

| # | Test | Covers |
|---|------|--------|
| s1 | English index hero text is 'Lean-first agentic development' | Hero YAML updated |
| s2 | English index has 6 feature cards (ks-card elements) | Custom HTML feature grid |
| s3 | English index install: curl present, no git clone inline | Install simplified |
| s4 | English index has HTML kanban mock with 4 columns | Kanban mock present |
| s5 | Kanban mock has data-kb-tooltip attribute | Hover tooltips wired |
| s6 | zh-TW hero text is translated (has 精實) | Locale content correct |
| s7 | zh-TW has 6 feature cards | zh-TW custom HTML |
| s8 | zh-TW install link uses /zh-TW/ prefix | Locale links correct |
| s9 | ja hero text translated (has リーン) | ja locale content |
| s10 | ja install link uses /ja/ prefix | ja links correct |
| s11 | No bare /guide/ links in zh-TW or ja index files | Locale-agnostic audit |
| s12 | English kanban guide has data-kb-tooltip | Guide page tooltips |

## Run command

```bash
make eval
```
