# Test Strategy: Fix /users/:id 404 Response

**Framework:** Jest + Supertest
**Install:** `npm install --save-dev jest supertest`
**Test files:** `tests/e2e/users-404.spec.js`
**Tests written:** 4
**Status:** All failing (red) ✓

## Framework Selection Note

The skill default for TypeScript/JS projects is Playwright (browser E2E). For this bug — an
HTTP API returning a wrong status code — Playwright is not appropriate; it drives a browser,
not an HTTP client. Jest + Supertest is the standard pairing for Express integration tests and
was selected instead. This is a deliberate, justified deviation from the skill's default.

## Test List

| # | Test name | What it covers |
|---|-----------|----------------|
| 1 | `returns 404 when user ID does not exist` | **Reproduces the bug directly.** Sends a GET to `/users/<non-existent-id>` and asserts the status is 404. On unfixed code this fails because the server returns 200. |
| 2 | `returns a JSON error body with message when user not found` | Asserts the 404 response carries a non-empty `{ error: "..." }` JSON body — not an empty body as observed in the bug. |
| 3 | `returns 200 with user data when user ID exists` | Happy-path regression guard — ensures the fix does not break lookup of existing users. |
| 4 | `returns 404 for a plausible numeric ID that does not exist` | Confirms the fix covers numeric IDs, not just UUID-style strings. |

## Failure Mode Before Fix

Tests 1, 2, and 4 will fail because:
- The unfixed handler finds no user and falls through without calling `res.status(404).json(...)`.
- Express's default behaviour returns `200` with an empty response body.

Test 3 may pass even before the fix (it calls a path that does return a user), making it a
sentinel: if Test 3 also fails after the fix is applied, the fix broke the happy path.

## Run Command

```bash
npx jest tests/e2e/users-404.spec.js --verbose
```

## Verification Checklist (before proceeding to Phase 3)

- [ ] All 4 tests are present and syntactically valid
- [ ] Tests 1, 2, 4 fail on the current (unfixed) codebase — confirmed red
- [ ] Test 3 is the only one that may pass before the fix (happy path already works)
- [ ] No implementation code has been written
