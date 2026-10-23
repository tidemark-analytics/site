---
title: "Best self-hosted web analytics tools in 2026"
description: "Six self-hosted analytics tools compared by what they need to run: PHP hosting, Docker, a database, or a single binary. Find one that fits your server."
date: 2026-10-23
order: 3
tag: Self-hosting
readingMinutes: 7
---

Running your own analytics keeps visitor data on a server you control, avoids sending your traffic to a third party, and often costs less than a hosted plan. The catch is that each tool asks for something different from your server, and that is what should drive your choice. A tool that needs a container stack is a poor match for a $4 shared host, and a tool that runs anywhere may skip features you want.

This guide compares six self-hosted options by what they need to run, how they upgrade, and who they suit. We build one of them, so we put ourselves in the list and try to be straight about the trade-offs. Details change between releases, so check each project's documentation before you commit.

## What to compare

- **Runtime requirements.** PHP hosting, Docker, Node.js, or a single compiled program.
- **Database.** SQLite (nothing to run), MySQL or MariaDB (common on shared hosts), PostgreSQL, or heavier analytical databases.
- **Upgrades.** One click, a command, or pulling a new container image.
- **Footprint.** How much memory and disk it needs as traffic grows.
- **Privacy defaults.** Whether it uses cookies and what it stores about visitors out of the box.

## At a glance

| Tool | Runs on | Database | License |
| --- | --- | --- | --- |
| Tidemark | PHP 8.3+ host or Docker | SQLite, MySQL, MariaDB, PostgreSQL | MIT |
| Matomo | PHP host | MySQL or MariaDB | GPL |
| Plausible Community Edition | Docker | PostgreSQL and ClickHouse | AGPL |
| Umami | Node.js or Docker | A SQL database such as PostgreSQL | MIT |
| GoatCounter | A single program | SQLite or PostgreSQL | Open source |
| PostHog | Docker and more | Several services | Open source |

## Matomo

[Matomo](https://matomo.org) is the long-standing open-source alternative to Google Analytics. It runs on an ordinary PHP and MySQL or MariaDB host, which is why it has been the default choice for shared hosting for years. It is the deepest tool here: goals, funnels, ecommerce and optional heatmaps and session recordings. The cost of that depth is a large interface and plenty of settings, and its privacy posture depends on how you configure it.

**Choose it if** you need broad features and want to stay on PHP hosting. **Skip it if** you want a single quiet dashboard.

## Plausible Community Edition

[Plausible](https://plausible.io) publishes an open-source (AGPL) Community Edition that you can self-host with Docker. It keeps the same one-page, cookieless approach as the hosted service. It stores events in ClickHouse alongside PostgreSQL, so you need a server with enough memory and comfort running containers, and the self-hosted edition can lag behind the hosted one on features.

**Choose it if** you have a VPS and like Docker. **Skip it if** you only have shared hosting.

## Umami

[Umami](https://umami.is) is open source (MIT), cookieless and aimed at developers. You run it as a Node.js application against a SQL database, commonly in Docker. It offers events and a friendly dashboard, and there is a hosted version if you would rather not run it.

**Choose it if** you are comfortable with Node and containers. **Skip it if** your host only supports PHP.

## GoatCounter

[GoatCounter](https://www.goatcounter.com) is a small open-source analytics program that ships as a single binary and stores data in SQLite or PostgreSQL. It is minimal on purpose: simple counts, no cookies, very light on resources.

**Choose it if** you want something tiny on a VPS you control. **Skip it if** you want goals, filtering depth or a PHP install.

## PostHog

[PostHog](https://posthog.com) is a product analytics platform with funnels, retention, session replay, feature flags and experiments. It can be self-hosted, but it is a multi-service deployment and its scale is meant for products, not brochure sites. It also collects far more than a traffic counter does.

**Choose it if** you are building an app and need product analytics. **Skip it if** you just want to know how many people read your blog.

## Tidemark

[Tidemark](/self-host/) is ours. It is built to run where other tools cannot: on ordinary PHP shared hosting with nothing but a file upload, or in a [single Docker container](https://docs.tidemarkanalytics.com/article/137-install-with-docker) for servers and home labs. You upload a zip, open `/install`, choose SQLite, MySQL, MariaDB or PostgreSQL, and create an account. It needs PHP 8.3 or newer, no Node, no Docker and no SSH on shared hosting. Updates are one click in the dashboard, or a newer image in Docker. It uses no cookies and stores no IP addresses, and it is MIT licensed.

**Choose it if** you want a calm one-page dashboard on cheap hosting. **Skip it if** you need funnels or session replay: it does not have them yet, and Matomo or PostHog do.

## How to choose

1. **Only have shared hosting?** Matomo or Tidemark. They are the two built for PHP.
2. **Have a VPS and like Docker?** Plausible Community Edition, Umami or Tidemark all work.
3. **Want the smallest possible footprint?** GoatCounter or Tidemark with SQLite.
4. **Need deep reporting?** Matomo, or PostHog for product analytics.
5. **Not sure you want to run it yourself?** Most of these have hosted versions, and Tidemark's [free Cloud plan](/cloud/) lets you try the same dashboard first. Moving between hosted and self-hosted is a download and an upload, so the choice is not permanent.

Whatever you pick, plan for [backups and updates](https://docs.tidemarkanalytics.com/article/105-install-backups) from day one. Self-hosting trades a monthly bill for a small, regular amount of attention, and the tool that needs the least of it is usually the one you will still be running in two years.
