# Tidemark marketing site

Marketing site for [Tidemark](https://github.com/tidemark-analytics/tidemark), built with Astro. Builds to plain HTML/CSS in `dist/` — no Node process in production.

```bash
npm install
npm run dev        # http://localhost:4321
SITE_URL=https://your-domain.com npm run build   # → dist/
npm run package    # build + tidemark-site.zip, ready to upload
```

## Deploy to shared hosting

Install instructions live in the docs site, not here: `src/data/site.ts` holds the docs URLs.

Upload the **contents** of `dist/` to the web root (FTP, cPanel File Manager, or unzip `tidemark-site.zip`). `dist/.htaccess` (Apache) adds HTTPS redirect, gzip, caching and security headers.

## Facts that change

Everything that repeats across pages lives in `src/data/site.ts`: the repository and download URLs, `demoUrl` (the live demo dashboard; empty hides the demo button) and the `version` shown on download buttons. Update `version` when a new Tidemark release ships. Set `SITE_URL` at build time for canonical URLs, the sitemap and Open Graph tags (default `https://tidemarkanalytics.com`).

The feature, privacy, comparison and cloud pages describe the product. When Tidemark's behaviour changes, update the matching page, and re-check the [comparison table](src/pages/compare.astro) against each competitor's own site now and then.

## Analytics

The site measures itself with a Tidemark install: the script tag is in `src/layouts/Base.astro`, and the public dashboard is linked as the live demo. If you fork the site, replace both, and update the privacy page and footer wording.

## Waitlist

`public/waitlist.php` appends emails to `../waitlist/emails.csv` (one level above the web root if writable, otherwise `_waitlist/` with a deny-all `.htaccess`; duplicates are ignored). It needs PHP only on the host. Download the CSV via FTP. Replace it with your mailing-list provider's form action if you prefer.

## Brand

Tokens, logos, contour motif and Inter come from the app's brand guide (`tidemark/resources/brand/index.html`). To refresh assets, re-copy `resources/brand/{logo,pattern}`, `public/assets/fonts`, favicons and `png/social-card.png` into `public/`.

## Contributing

Corrections are welcome, especially where a claim here no longer matches the product or a competitor. Please check statements against the code or the source you cite.

## License

MIT
