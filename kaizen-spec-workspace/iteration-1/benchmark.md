# Benchmark: kaizen-spec - Iteration 1

## Pass Rates

| Assertion | With Skill | Without Skill |
|---|---|---|
| 1.1 spec.md written before implementation | ✅ PASS | ❌ FAIL |
| 1.2 Phase 1 alignment before Phase 3 | ✅ PASS | ❌ FAIL |
| 1.3 tasks.json with ≥2 independent tasks | ✅ PASS | ❌ FAIL |
| 1.4 Correct test framework detected (pytest) | ✅ PASS | ❌ FAIL |
| 1.5 No implementation code before spec committed | ✅ PASS | ❌ FAIL |
| 2.1 Bug fix spec scoped correctly (no feature creep) | ✅ PASS | ❌ FAIL |
| 2.2 Failing test written BEFORE fix implementation | ✅ PASS | ❌ FAIL |
| 2.3 Acceptance criterion tied to test passing | ✅ PASS | ❌ FAIL |
| 3.1 Skill SKIPS full workflow for trivial rename | ❌ FAIL | ✅ PASS |
| 3.2 Rename handled directly or choice offered | ❌ FAIL | ✅ PASS |
| 3.3 No .kaizen/spec.md created for trivial rename | ❌ FAIL | ✅ PASS |

**With-skill pass rate: 8/11 (73%)**
**Without-skill pass rate: 3/11 (27%)** - only passes the SKIP assertions

## Summary

The skill delivers strong value on the core workflow (evals 1 and 2) - 10/10 assertions passed. The critical failure is eval 3: the SKIP condition exists only in the frontmatter description, not in the skill body. Once the skill body runs (for any reason), it has no guard against forcing a full 5-phase ceremony on trivial tasks.

## Gaps Found (ordered by severity)

### CRITICAL
**Gap SKIP** - No runtime SKIP guard in the skill body.
The SKIP instruction is decorative - it only works when the routing layer does not invoke the skill. Once invoked (explicitly via /kaizen-spec, router mis-fire, or simulation), the body has no conditional exit. A guard clause at the very top must classify the incoming request and exit early for trivial tasks.

### IMPORTANT
**Gap B-TEST-EXPRESS** - Playwright recommended for Express API projects.
Playwright is a browser driver; Express API bugs need Jest + Supertest. Detection: if package.json has express/fastify/koa without a UI framework, recommend Jest + Supertest.

**Gap A-TEST-PYTHON** - Playwright recommended for Python CLI projects.
Click CLI projects need pytest + click.testing.CliRunner, not playwright-python. Detection: if pyproject.toml/requirements.txt includes click/typer/argparse, recommend CliRunner approach.

**Gap Q2** - No "Bug fix" option in Q2.
Q2 options are all feature-type deliverables. A "Bug fix in existing code" option enables bug-specific downstream behaviour (different spec template, different stop rule).

**Gap BUGSPEC** - No bug-aware spec template.
Bug fixes need Current Behaviour / Expected Behaviour / Steps to Reproduce. The current generic template reads as a feature spec for both cases.

**Gap STOPRULE** - "Any passing test = stop" is too blunt for bug fixes.
Happy-path tests may already pass before the fix. The stop rule should be: "If tests that directly reproduce the reported bug pass before implementation, stop."

**Gap DEPENDS** - tasks.json has no depends_on field.
Real decompositions have ordering dependencies. Without depends_on, agents may start a task before its prerequisites complete.

### MINOR
**Gap CWDROOT** - .kaizen/ path ambiguity when CWD is not project root.
Skill should instruct agents to use `git rev-parse --show-toplevel` to anchor paths.

**Gap TESTPROOF** - Test red/green state is prose-only.
Introduce a machine-readable `.kaizen/test-results-initial.json` for the orchestrator to read rather than trusting a prose report.

**Gap DOCS** - Phase 5 always targets VitePress regardless of project type.
Detect docs framework before spawning doc agent; skip or adapt for Python/Go/Rust projects.
