---
title: "Self-hosted analytics on shared hosting: what you need and how to set it up"
description: "Run your own web analytics on ordinary PHP shared hosting: the requirements, a step-by-step install, a cron job, updates and backups, with no server skills needed."
date: 2026-10-23
order: 6
tag: Self-hosting
readingMinutes: 7
---

Most guides to self-hosted analytics assume you have a server, a container runtime and a free evening. But plenty of sites live on cheap shared hosting, with a control panel, an FTP login and nothing else. The good news is that you can run your own analytics there too, as long as you pick a tool built for it.

This guide walks through a typical setup with [Tidemark](/self-host/), which is designed for PHP shared hosting, but the checklist applies to any PHP-based analytics tool.

## What you need

- **PHP 8.3 or newer** on the hosting account. Most hosts let you pick the PHP version in the control panel.
- **A few common PHP extensions:** mbstring, openssl, PDO with one database driver, fileinfo, ctype, tokenizer and XML. These are enabled by default almost everywhere.
- **A place for the database.** SQLite needs nothing at all (it is a file). Otherwise a MySQL, MariaDB or PostgreSQL database from your host works too.
- **A domain or subdomain** for the dashboard, for example `stats.yourdomain.com`.
- **HTTPS,** which most hosts provide for free with Let's Encrypt.

You do not need SSH, Node.js, Docker or Composer.

## Step 1: Create a subdomain

In your hosting control panel, add a subdomain such as `stats.yourdomain.com` and note its document root folder. If your host lets you, point the document root at the `public` folder of the app after you upload it. If it does not, the release includes a root `.htaccess` that forwards requests to `public/` and blocks the internal folders, so uploading to the web root as-is still works.

## Step 2: Upload the release

Download the latest `tidemark-x.y.z.zip` from the [releases page](https://github.com/tidemark-analytics/tidemark/releases/latest) (dependencies are already bundled), upload it with the file manager or FTP, and unzip it in the subdomain's folder.

## Step 3: Run the installer

Open `https://stats.yourdomain.com/install`. The installer checks your server, connects a database (choose SQLite if you want zero setup), runs the migrations and creates your admin account. When it finishes you are signed in.

## Step 4: Add your site and paste the snippet

Add the domain you want to measure and copy the snippet into the `<head>` of every page:

```html
<script defer data-domain="yourdomain.com"
  src="https://stats.yourdomain.com/js/script.js"></script>
```

The dashboard waits for the first page view and then opens by itself. If you use a CDN or proxy, real visitor addresses and countries are read from its headers.

## Step 5: Add the cron job (optional)

Two features need a scheduled task: buffering events through a queue, and automatic deletion of old data. In your host's cron settings add one entry that runs every minute:

```
* * * * * php /home/you/stats/artisan schedule:run >> /dev/null 2>&1
```

If you do not use those features, you can skip it. The [cron guide](https://docs.tidemarkanalytics.com/article/102-install-cron) has the details.

## Step 6: Set up email (optional)

Password resets and invitations need working outgoing mail. Add your host's SMTP settings as described in the [email guide](https://docs.tidemarkanalytics.com/article/103-install-email). Without it the app still works, it just cannot send emails.

## Updating

Administrators can update from Account settings, which downloads the release, makes a backup of the current files, applies it and runs the database migrations the first time you open the dashboard afterwards. If your host blocks the updater from writing files, upload the new release over FTP instead. See the [updating guide](https://docs.tidemarkanalytics.com/article/104-install-updating).

## Backups

With SQLite, your whole database is one file, so backing up is a copy. Back up the `.env` file as well, because it holds the app key. With MySQL, MariaDB or PostgreSQL, use your host's backup tool or a database dump. The [backups guide](https://docs.tidemarkanalytics.com/article/105-install-backups) lists exactly what to keep.

## A few tips for shared hosting

- **Pick SQLite for small sites.** It is usually fast enough for small and medium sites and removes a moving part. Move to MySQL or MariaDB if traffic grows a lot.
- **Keep PHP updated.** Choose a supported PHP version in your control panel.
- **Use a subdomain,** not the main site's folder, so analytics files never mix with your site.
- **Check the file permissions** if the installer says `storage` is not writable. The `storage` and `bootstrap/cache` folders must be writable by PHP.

## If you would rather not run it

Self-hosting is one option, not the only one. You can [start free on Tidemark Cloud](/cloud/) with the same dashboard and move to your own server later: exporting a site from one and importing it into the other is a download and an upload. The [self-hosted tools guide](/blog/best-self-hosted-web-analytics/) compares the alternatives if you want to look at other options first.
