import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './tests',
  timeout: 10000,
  use: {
    baseURL: 'http://localhost:9999',
    headless: true,
  },
  projects: [
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] },
    },
  ],
  webServer: {
    command: 'python3 -m http.server --directory .kaizen 9999',
    url: 'http://localhost:9999',
    reuseExistingServer: !process.env.CI,
    timeout: 10000,
  },
});
