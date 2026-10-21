// Single place for facts that appear on several pages. Edit here, rebuild.
const repo = 'tidemark-analytics/tidemark';
const fallbackVersion = '0.9.6'; // only used when GitHub can't be reached at build time

/** The newest published release, read from GitHub every time the site is built. */
async function latestVersion(): Promise<string> {
  try {
    const res = await fetch(`https://api.github.com/repos/${repo}/releases/latest`, {
      headers: { Accept: 'application/vnd.github+json', 'User-Agent': 'tidemark-site-build' },
      signal: AbortSignal.timeout(8000),
    });
    const tag = res.ok ? String((await res.json()).tag_name ?? '') : '';
    return /^v?\d+\.\d+\.\d+/.test(tag) ? tag.replace(/^v/, '') : fallbackVersion;
  } catch {
    return fallbackVersion;
  }
}
const version = await latestVersion();

export const site = {
  name: 'Tidemark',
  tagline: 'Measure the tide, not the footprints.',
  description:
    'Privacy-first web analytics, hosted for you or on any PHP host. No cookies, no stored IP addresses, one light dashboard. Free to start.',
  repoUrl: `https://github.com/${repo}`,
  downloadUrl: `https://github.com/${repo}/releases/latest`,
  zipUrl: `https://github.com/${repo}/releases/download/v${version}/tidemark-${version}.zip`, // the install zip itself, so "Download" starts a download
  repoReleasesUrl: `https://github.com/${repo}/releases`,
  releaseUrl: `https://github.com/${repo}/releases/tag/v${version}`, // this release's notes and downloads
  demoUrl: 'https://app.tidemarkanalytics.com/tidemarkanalytics.com', // this site's own public Tidemark dashboard; empty hides the demo button
  docsUrl: 'https://docs.tidemarkanalytics.com',
  installDocsUrl: 'https://docs.tidemarkanalytics.com/install/shared-hosting/',
  appUrl: 'https://app.tidemarkanalytics.com',
  signupUrl: 'https://app.tidemarkanalytics.com/register',
  operator: 'Michael Kinder',
  supportEmail: 'support@tidemarkanalytics.com',
  legalUpdated: 'October 21, 2026',
  version, // refreshed from GitHub at build time, and in the browser via /latest.php
  latestEndpoint: '/latest.php', // PHP endpoint shipped in /public that proxies the GitHub API (cached)
  requirements: 'PHP 8.3+',
};

export const nav = [
  { href: '/features/', label: 'Features' },
  { href: '/cloud/', label: 'Pricing' },
  { href: '/compare/', label: 'Compare' },
  { href: '/self-host/', label: 'Self-host' },
  { href: site.docsUrl, label: 'Docs' },
  { href: '/privacy/', label: 'Privacy' },
];
