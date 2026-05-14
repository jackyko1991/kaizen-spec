import { test, expect } from '@playwright/test';

const DOCS_URL = 'https://jackyko1991.github.io/kaizen-spec/';

test.describe('GitHub Pages docs site', () => {
  test('Homepage loads with 200 status', async ({ page }) => {
    const response = await page.goto(DOCS_URL);
    expect(response?.status()).toBe(200);
  });

  test('Homepage contains VitePress content', async ({ page }) => {
    await page.goto(DOCS_URL);
    // VitePress renders a #app root; title or h1 must be present
    await expect(page.locator('h1, .VPHero h1, .vp-doc h1')).toBeVisible({ timeout: 10000 });
  });

  test('Navigation sidebar is present', async ({ page }) => {
    await page.goto(DOCS_URL);
    await expect(page.locator('.VPSidebar, nav')).toBeVisible({ timeout: 10000 });
  });

  test('Getting Started page loads', async ({ page }) => {
    const response = await page.goto(DOCS_URL + 'guide/getting-started');
    expect(response?.status()).toBe(200);
    await expect(page.locator('h1')).toBeVisible({ timeout: 10000 });
  });
});
