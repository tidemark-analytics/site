// Single place for facts that appear on several pages. Edit here, rebuild.
export const site = {
  name: 'Tidemark',
  tagline: 'Measure the tide, not the footprints.',
  description:
    'Privacy-first web analytics that runs on any PHP host — or on ours. No cookies, no stored IP addresses, one light dashboard.',
  repoUrl: 'https://github.com/tidemark-analytics/tidemark',
  downloadUrl: 'https://github.com/tidemark-analytics/tidemark/releases/latest',
  demoUrl: 'https://analytics.foggymtndrifter.com/tidemarkanalytics.com', // this site's own public Tidemark dashboard; empty hides the demo button
  docsUrl: 'https://docs.tidemarkanalytics.com',
  installDocsUrl: 'https://docs.tidemarkanalytics.com/install/shared-hosting/',
  waitlistAction: '/waitlist.php', // PHP endpoint shipped in /public (see README)
  version: '0.9.2',
  requirements: 'PHP 8.3+',
};

export const nav = [
  { href: '/features/', label: 'Features' },
  { href: site.docsUrl, label: 'Docs' },
  { href: '/privacy/', label: 'Privacy' },
  { href: '/compare/', label: 'Compare' },
  { href: '/cloud/', label: 'Cloud', badge: 'Soon' },
];
