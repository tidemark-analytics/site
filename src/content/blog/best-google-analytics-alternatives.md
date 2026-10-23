---
title: "10 best Google Analytics alternatives in 2026"
description: "Ten Google Analytics alternatives compared by what they are good at: privacy, simplicity, self-hosting, depth and price. Pick the one that fits your site."
date: 2026-10-23
order: 1
tag: Comparison
readingMinutes: 9
---

Google Analytics 4 is powerful, free and everywhere. It is also a lot to learn, it sets cookies that usually mean a consent banner, and your visitors' data ends up in Google's hands. If you only want to know how many people visit, where they come from and what they read, there are lighter tools that answer those questions on one page.

This guide lists ten alternatives, what each is good at, and who should pick it. They are in no particular order, and we put ourselves last. Features and prices change often, so treat this as a map and check each tool's own site before you decide. We last reviewed it in October 2026.

## What to look for

Before the list, five questions that separate these tools more than any feature table does:

- **How does it count visitors?** Some tools use cookies and long-lived identifiers. Others use a short-lived hash that changes every day, which means no cookie and no profile of a person across days.
- **Where does the data live?** On the vendor's servers, on your own server, or both?
- **How deep do you need to go?** A single dashboard of traffic, or funnels, session replay, experiments and feature flags?
- **Can you leave?** Can you export your data, and is the software open source?
- **What does it cost at your traffic?** Many tools price by pageviews or events, so a spike matters.

## Quick picks

| If you want | Look at |
| --- | --- |
| A simple, hosted, privacy-first dashboard | Plausible, Fathom, Simple Analytics, Pirsch |
| Open source you can run yourself | Plausible Community Edition, Umami, Matomo, GoatCounter, Tidemark |
| The closest thing to a full Google Analytics replacement | Matomo |
| Free and nothing to install if you already use Cloudflare | Cloudflare Web Analytics |
| Product analytics with funnels and session replay | PostHog |
| Self-hosting on ordinary PHP hosting or Docker | Matomo, Tidemark |

## 1. Plausible

[Plausible](https://plausible.io) is the tool most people mean when they say "privacy-friendly analytics". It has a single-page dashboard, a tiny script and no cookies. It is available as a paid hosted service priced by monthly pageviews, and as an open-source Community Edition (AGPL) you can host yourself. Self-hosting means running a ClickHouse and a Postgres database, usually with Docker, so it suits people comfortable with containers.

**Good for:** a mature, simple, hosted dashboard. **Watch for:** the self-hosted edition is not identical to the hosted one, and pricing grows with traffic.

## 2. Fathom

[Fathom](https://usefathom.com) is a hosted, paid, privacy-first service with a clean dashboard and a focus on simplicity. As far as we know it is hosted only, so there is no self-hosting option.

**Good for:** people who want a polished hosted tool and no servers to think about. **Watch for:** no self-hosting or open-source edition.

## 3. Simple Analytics

[Simple Analytics](https://www.simpleanalytics.com) is another hosted, paid, privacy-focused service with an easy dashboard and readable reports. Like Fathom, it is a hosted product rather than something you run yourself.

**Good for:** teams who want plain reports without setup. **Watch for:** hosted only, so your data lives with the vendor.

## 4. Umami

[Umami](https://umami.is) is open source (MIT) and can be self-hosted or used as a hosted service, which includes a free tier for small sites. It is cookieless, popular with developers, and has events and more detailed reports than the simplest tools.

**Good for:** developers who want open source with a hosted option. **Watch for:** self-hosting needs Node.js and a database, so it is a step up from a shared host.

## 5. Matomo

[Matomo](https://matomo.org) is the most complete open-source answer to Google Analytics. It can be self-hosted on a typical PHP and MySQL host or used as a paid hosted service, and it covers funnels, goals, ecommerce, and heatmaps and session recordings through its own features and plugins. It can be configured to run without cookies, but it ships with more options on by default than the minimalist tools, so how privacy-friendly it is depends on how you set it up.

**Good for:** teams that need depth and want to own their data. **Watch for:** more to configure, and a bigger interface to learn.

## 6. GoatCounter

[GoatCounter](https://www.goatcounter.com) is a small, open-source, cookieless analytics tool. It is free to use as a hosted service for non-commercial sites and can be self-hosted as a single program. It is deliberately minimal.

**Good for:** personal sites, blogs and small projects. **Watch for:** a basic feature set, and the free hosted plan is for non-commercial use.

## 7. Pirsch

[Pirsch](https://pirsch.io) is a cookie-free, privacy-focused analytics service, hosted and paid. It sits in the same space as Plausible and Fathom, with a simple dashboard and an API.

**Good for:** a hosted alternative if the better-known options do not fit. **Watch for:** check the current pricing and hosting details on their site.

## 8. Cloudflare Web Analytics

If your site already runs through Cloudflare, [Cloudflare Web Analytics](https://www.cloudflare.com/web-analytics/) is free, cookieless and takes almost no setup, because it can measure traffic at the edge without a script. It is proprietary and cannot be self-hosted, and it is far more basic than the tools above: you get the headline numbers, not custom events or goals.

**Good for:** a free baseline if you are on Cloudflare. **Watch for:** limited depth, and it only exists inside Cloudflare.

## 9. PostHog

[PostHog](https://posthog.com) is a product analytics platform, not just web analytics. It offers funnels, retention, session replay, feature flags and experiments, and it is open source with both cloud and self-hosted options. That depth comes with weight: it collects more by default, and self-hosting it is a bigger job.

**Good for:** product teams who need to understand what users do inside an app. **Watch for:** overkill if you only want traffic numbers.

## 10. Tidemark

[Tidemark](/) is ours. It counts visitors without cookies or stored IP addresses, using a hash that changes every day, and shows everything on one page: visitors, pageviews, bounce rate, visit duration, sources, pages, locations, devices, goals and custom events. It runs as [Tidemark Cloud](/cloud/) (free to start, with a paid plan for more events and sites) or as a [self-hosted install](/self-host/) on ordinary PHP shared hosting or in Docker, under the MIT license. The tracking script and events API follow Plausible's conventions, and it can import a [Plausible export](https://docs.tidemarkanalytics.com/article/140-import-from-plausible).

**Good for:** a calm one-page dashboard you can host anywhere, including cheap shared hosting. **Watch for:** it is young, and it does not have funnels, session replay or imports from tools other than Plausible. If you need those, Matomo or PostHog are the better fit, and we say so on our [compare page](/compare/).

## How to choose

A short way through the list:

1. **Want zero maintenance?** Pick a hosted tool: Plausible, Fathom, Simple Analytics, Pirsch, Tidemark Cloud or Umami Cloud.
2. **Want to own the server and the data?** Pick open source: Matomo, Umami, GoatCounter, Plausible Community Edition or Tidemark.
3. **Only have shared hosting?** Matomo and Tidemark are built for PHP hosts.
4. **Need funnels, replay or experiments?** Matomo or PostHog.
5. **Just need a free baseline?** Cloudflare Web Analytics if you use Cloudflare, otherwise GoatCounter or a free tier.

Whichever you choose, run it next to Google Analytics for a few weeks before you switch off the old tag, so you can compare the numbers and recreate your goals. Our guide to [switching from Google Analytics](/blog/switch-from-google-analytics/) walks through it.
