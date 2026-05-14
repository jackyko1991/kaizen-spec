/**
 * Regression test: GET /users/:id must return 404 when user does not exist.
 *
 * These tests are written BEFORE the fix is applied.
 * They reproduce the original bug (200 + empty body) and specify correct behaviour.
 *
 * Framework: Jest + Supertest
 * Run: npx jest tests/e2e/users-404.spec.js
 */

const request = require('supertest');
const app = require('../../src/app'); // Express app (not listening — supertest handles this)

describe('GET /users/:id — not-found handling', () => {
  /**
   * Test 1: Reproduce the bug.
   * Before the fix, this endpoint returns 200 with an empty body.
   * After the fix, it must return 404.
   * This test is written to FAIL on the unfixed code.
   */
  test('returns 404 when user ID does not exist', async () => {
    const nonExistentId = '99999999-does-not-exist';
    const response = await request(app).get(`/users/${nonExistentId}`);

    expect(response.status).toBe(404);
  });

  /**
   * Test 2: The 404 response must have a structured error body, not empty.
   * Confirms the fix provides meaningful feedback to API consumers.
   */
  test('returns a JSON error body with message when user not found', async () => {
    const nonExistentId = '99999999-does-not-exist';
    const response = await request(app).get(`/users/${nonExistentId}`);

    expect(response.headers['content-type']).toMatch(/json/);
    expect(response.body).toHaveProperty('error');
    expect(typeof response.body.error).toBe('string');
    expect(response.body.error.length).toBeGreaterThan(0);
  });

  /**
   * Test 3: Existing (found) users still return 200.
   * Guard against regressions in the happy path.
   */
  test('returns 200 with user data when user ID exists', async () => {
    // Assumes a seed user with id '1' exists in the test data store.
    const existingId = '1';
    const response = await request(app).get(`/users/${existingId}`);

    expect(response.status).toBe(200);
    expect(response.body).toHaveProperty('id');
  });

  /**
   * Test 4: Numeric IDs that look plausible but don't exist also get 404.
   * Ensures the fix is not accidentally gated on string format.
   */
  test('returns 404 for a plausible numeric ID that does not exist', async () => {
    const response = await request(app).get('/users/999');

    expect(response.status).toBe(404);
  });
});
