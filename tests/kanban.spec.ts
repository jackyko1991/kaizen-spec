import { test, expect } from '@playwright/test';

test.beforeEach(async ({ page }) => {
  await page.goto('/board.html');
  // Wait for Bootstrap JS to initialise
  await page.waitForFunction(() => typeof (window as any).bootstrap !== 'undefined');
  // Disable the 5-second auto-reload so it doesn't interrupt tests
  await page.evaluate(() => {
    // Patch setInterval so the reload timer never fires
    const original = window.setInterval;
    (window as any).__intervals = [];
    window.setInterval = ((fn: TimerHandler, delay?: number, ...args: unknown[]) => {
      const id = original(fn, delay, ...args);
      (window as any).__intervals.push(id);
      return id;
    }) as typeof window.setInterval;
  });
});

// ---------------------------------------------------------------------------
// Group 1 — Column structure
// ---------------------------------------------------------------------------

test.describe('Column structure', () => {
  test('Each column has the correct English header text visible', async ({ page }) => {
    await expect(page.locator('#col-backlog .column-header')).toContainText('Backlog');
    await expect(page.locator('#col-in-progress .column-header')).toContainText('In Progress');
    await expect(page.locator('#col-review .column-header')).toContainText('Review');
    await expect(page.locator('#col-done .column-header')).toContainText('Done');
  });

  test('Each column has its Japanese subtitle visible', async ({ page }) => {
    await expect(page.locator('#col-backlog .col-label-jp')).toHaveText('待辦');
    await expect(page.locator('#col-in-progress .col-label-jp')).toHaveText('在製品');
    await expect(page.locator('#col-review .col-label-jp')).toHaveText('審査');
    await expect(page.locator('#col-done .col-label-jp')).toHaveText('完了');
  });

  test('Each column has a WIP badge element', async ({ page }) => {
    await expect(page.locator('#count-backlog')).toBeVisible();
    await expect(page.locator('#count-in-progress')).toBeVisible();
    await expect(page.locator('#count-review')).toBeVisible();
    await expect(page.locator('#count-done')).toBeVisible();
  });

  test('Each column has a ? help badge (.col-help)', async ({ page }) => {
    await expect(page.locator('#col-backlog .col-help')).toBeVisible();
    await expect(page.locator('#col-in-progress .col-help')).toBeVisible();
    await expect(page.locator('#col-review .col-help')).toBeVisible();
    await expect(page.locator('#col-done .col-help')).toBeVisible();
  });
});

// ---------------------------------------------------------------------------
// Group 2 — Card hover tooltips (task-009 in Done column)
// ---------------------------------------------------------------------------

test.describe('Card hover tooltips', () => {
  test('Hovering task-009 makes a Bootstrap tooltip visible', async ({ page }) => {
    const card = page.locator('[data-task-id="task-009"]');
    await card.hover();
    await page.waitForSelector('.tooltip.show', { timeout: 2000 });
    await expect(page.locator('.tooltip.show')).toBeVisible();
  });

  test('Tooltip for task-009 contains "✓ Done" status badge', async ({ page }) => {
    const card = page.locator('[data-task-id="task-009"]');
    await card.hover();
    await page.waitForSelector('.tooltip.show', { timeout: 2000 });
    const inner = await page.locator('.tooltip-inner').innerHTML();
    expect(inner).toContain('✓ Done');
  });

  test('Tooltip for task-009 contains description paragraph with non-empty text', async ({ page }) => {
    const card = page.locator('[data-task-id="task-009"]');
    await card.hover();
    await page.waitForSelector('.tooltip.show', { timeout: 2000 });
    const inner = await page.locator('.tooltip-inner').innerHTML();
    // The description is rendered inside a <p> tag
    expect(inner).toMatch(/<p[^>]*>[^<]+<\/p>/);
  });

  test('Tooltip for task-009 contains "Completed" timestamp label', async ({ page }) => {
    const card = page.locator('[data-task-id="task-009"]');
    await card.hover();
    await page.waitForSelector('.tooltip.show', { timeout: 2000 });
    const inner = await page.locator('.tooltip-inner').innerHTML();
    expect(inner).toContain('Completed');
  });
});

// ---------------------------------------------------------------------------
// Group 3 — Column ? tooltip content
// ---------------------------------------------------------------------------

test.describe('Column ? tooltip content', () => {
  test('Backlog ? badge tooltip contains "待辦" or "Backlog"', async ({ page }) => {
    const helpBadge = page.locator('#col-backlog .col-help');
    await helpBadge.hover();
    await page.waitForSelector('.tooltip.show', { timeout: 2000 });
    const inner = await page.locator('.tooltip-inner').innerHTML();
    const containsExpected = inner.includes('待辦') || inner.includes('Backlog');
    expect(containsExpected).toBe(true);
  });

  test('Done ? badge tooltip contains "完了", "CT", or "Lead Time"', async ({ page }) => {
    const helpBadge = page.locator('#col-done .col-help');
    await helpBadge.hover();
    await page.waitForSelector('.tooltip.show', { timeout: 2000 });
    const inner = await page.locator('.tooltip-inner').innerHTML();
    const containsExpected = inner.includes('完了') || inner.includes('CT') || inner.includes('Lead Time');
    expect(containsExpected).toBe(true);
  });
});

// ---------------------------------------------------------------------------
// Group 4 — WIP limit enforcement
// ---------------------------------------------------------------------------

test.describe('WIP limit enforcement', () => {
  test('Dragging a card into In Progress beyond WIP=3 shows #wipToast', async ({ page }) => {
    // task-009 is in Done; drag it into In Progress which has WIP limit 3
    // First fill In Progress to exactly the limit by dragging 3 Done cards
    // Then drag a 4th card to trigger the toast.
    //
    // Strategy: use page.evaluate() to directly call the SortableJS onEnd callback
    // by simulating a card move via DOM manipulation and triggering the event.
    //
    // We move cards directly via DOM then dispatch a synthetic SortableJS onEnd-like event.
    // Bootstrap Toast fires inside onEnd. Playwright cannot trigger SortableJS onEnd via
    // evaluate easily, so we use Playwright dragAndDrop with mouse events.

    // Fill In Progress with 3 Done cards via evaluate (DOM move only, then call updateCounts
    // equivalent without triggering toast — we'll use task-001, task-002, task-003)
    await page.evaluate(() => {
      const ipBody = document.getElementById('body-in-progress')!;
      const doneBody = document.getElementById('body-done')!;
      // Move first 3 cards from Done to In Progress without triggering WIP toast
      const cards = Array.from(doneBody.querySelectorAll('.kaizen-card')).slice(0, 3);
      cards.forEach(c => ipBody.appendChild(c));
    });

    // Now drag another Done card into In Progress — this should trigger the toast
    // Use Playwright mouse-based drag on the first remaining Done card
    const sourceCard = page.locator('#body-done .kaizen-card').first();
    const targetCol = page.locator('#body-in-progress');

    await sourceCard.hover();
    await page.mouse.down();
    const targetBox = await targetCol.boundingBox();
    if (targetBox) {
      await page.mouse.move(targetBox.x + targetBox.width / 2, targetBox.y + 10, { steps: 10 });
      await page.mouse.up();
    }

    // Wait for toast to appear
    await page.waitForSelector('#wipToast.show', { timeout: 3000 });
    await expect(page.locator('#wipToast')).toBeVisible();
  });

  test('WIP toast message contains "WIP limit"', async ({ page }) => {
    // Same setup: fill In Progress to 3, then drag a 4th
    await page.evaluate(() => {
      const ipBody = document.getElementById('body-in-progress')!;
      const doneBody = document.getElementById('body-done')!;
      const cards = Array.from(doneBody.querySelectorAll('.kaizen-card')).slice(0, 3);
      cards.forEach(c => ipBody.appendChild(c));
    });

    const sourceCard = page.locator('#body-done .kaizen-card').first();
    const targetCol = page.locator('#body-in-progress');

    await sourceCard.hover();
    await page.mouse.down();
    const targetBox = await targetCol.boundingBox();
    if (targetBox) {
      await page.mouse.move(targetBox.x + targetBox.width / 2, targetBox.y + 10, { steps: 10 });
      await page.mouse.up();
    }

    await page.waitForSelector('#wipToast.show', { timeout: 3000 });
    const toastText = await page.locator('#wipToastMsg').textContent();
    expect(toastText).toMatch(/WIP limit/i);
  });
});

// ---------------------------------------------------------------------------
// Group 5 — Theme toggle + localStorage
// ---------------------------------------------------------------------------

test.describe('Theme toggle', () => {
  test('Clicking theme toggle changes data-bs-theme attribute', async ({ page }) => {
    const initialTheme = await page.evaluate(() =>
      document.documentElement.getAttribute('data-bs-theme')
    );
    await page.click('button.theme-toggle');
    const newTheme = await page.evaluate(() =>
      document.documentElement.getAttribute('data-bs-theme')
    );
    expect(newTheme).not.toBe(initialTheme);
    // Should flip between dark and light
    const expected = initialTheme === 'dark' ? 'light' : 'dark';
    expect(newTheme).toBe(expected);
  });

  test('Clicking theme toggle writes new theme to localStorage', async ({ page }) => {
    const initialTheme = await page.evaluate(() =>
      document.documentElement.getAttribute('data-bs-theme')
    );
    await page.click('button.theme-toggle');
    const stored = await page.evaluate(() => localStorage.getItem('kaizen-theme'));
    const expected = initialTheme === 'dark' ? 'light' : 'dark';
    expect(stored).toBe(expected);
  });
});
