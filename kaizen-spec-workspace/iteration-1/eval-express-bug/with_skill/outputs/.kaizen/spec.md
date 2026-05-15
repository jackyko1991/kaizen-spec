# Spec: Fix /users/:id 404 Response

**Date:** 2026-05-14
**Status:** Agreed

## Intent
Fix the /users/:id endpoint which returns 200 with empty body instead of 404 when user not found

## Target Output
Bug fix in existing code - the `/users/:id` Express route must return HTTP 404 with a structured error body when the requested user ID does not exist in the data store.

## In Scope
- Fix the 404 response only - add proper not-found handling and a test to prevent regression
- The fix is limited to the single route handler responsible for `GET /users/:id`
- A regression test that reproduces the original bug behaviour and confirms the fix

## Out of Scope
- No changes to other endpoints
- No auth changes
- No changes to the data model or database schema
- No changes to response format of successful (200) responses

## Risks / Unknowns
No known risks

## Acceptance Criterion
All tests in `.kaizen/test-strategy.md` pass. No manual exceptions.
