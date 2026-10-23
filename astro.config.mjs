import { defineConfig } from 'astro/config';
import sitemap from '@astrojs/sitemap';

// Set SITE_URL at build time (e.g. SITE_URL=https://tidemarkanalytics.com npm run build)
const site = process.env.SITE_URL || 'https://tidemarkanalytics.com';

export default defineConfig({
  site,
  output: 'static',
  trailingSlash: 'always',
  build: { format: 'directory', inlineStylesheets: 'auto' },
  integrations: [sitemap({ filter: (page) => !page.includes('/cloud/thanks/') })],
  compressHTML: true,
  markdown: { syntaxHighlight: false },
});
