---
title: "How to switch from Google Analytics to a privacy-friendly alternative"
description: "A step-by-step plan to move off Google Analytics: audit what you use, pick a tool, run both side by side, recreate goals and remove the old tag safely."
date: 2026-10-23
order: 2
tag: Guide
readingMinutes: 8
---

Moving off Google Analytics is less about technology than about not losing things you rely on. The new tool takes a few minutes to install. The work is deciding what you actually use, keeping the history you care about, and removing the old tag and cookie banner in the right order. This is the plan we would follow.

## 1. Audit what you really use

Open Google Analytics and write down the reports and numbers you looked at in the last three months. For most small sites that is a short list: visitors, top pages, where traffic comes from, countries and devices. Also note anything configured on top:

- **Conversions or key events** you track (signups, purchases, downloads).
- **Audiences or remarketing** that feed ads. Privacy-friendly tools do not do this, so if you depend on it, plan for that separately.
- **Integrations** with Search Console, Google Ads or a dashboard tool.
- **Who else looks at the reports,** so they are not surprised.

If your list is "traffic, sources, pages, a couple of goals", almost any alternative will do. If it includes funnels and audiences, read our [comparison of alternatives](/blog/best-google-analytics-alternatives/) first, because the lightest tools will not cover that.

## 2. Save the history you need

Most alternatives cannot import Google Analytics data, and Google keeps detailed event-level data for a limited time (up to 14 months, depending on your property's retention setting). Before you switch, export what you will want later:

- The yearly and monthly totals you quote (visitors, pageviews, top pages and sources).
- Any report you build reports from, saved as CSV or PDF.
- If you use BigQuery, the raw export tables.

Keep these somewhere you will find them. A year-over-year comparison later is far easier with a spreadsheet of last year's numbers than with nothing.

## 3. Pick the tool

Decide between hosted and self-hosted, and how much depth you need. Hosted tools (Plausible, Fathom, Simple Analytics, Tidemark Cloud and others) need no server. Self-hosted tools (Matomo, Umami, Plausible Community Edition, Tidemark) keep the data on your own hosting. The [alternatives guide](/blog/best-google-analytics-alternatives/) and the [self-hosting guide](/blog/best-self-hosted-web-analytics/) will narrow it down.

## 4. Install it next to Google Analytics

Do not remove Google Analytics yet. Add the new tool's script to the same pages. With Tidemark, for example, it is one line in your `<head>`:

```html
<script defer data-domain="yourdomain.com"
  src="https://app.tidemarkanalytics.com/js/script.js"></script>
```

Run both for at least two to four weeks, long enough to cover a full cycle of your traffic. The numbers will not match exactly, and that is normal: tools define visitors, sessions and bounce rate differently, filter bots differently, and are affected differently by ad blockers. Compare trends over time, not exact totals.

## 5. Recreate your goals and events

List the conversions you tracked and recreate them. In most privacy-friendly tools a goal is either a page visit (for example `/thank-you`) or a custom event you send from your code. Tools that follow Plausible's conventions, including Tidemark, share the same pattern:

```js
window.plausible('Signup')
```

Add the matching goal in the new tool's settings. Outbound link clicks, file downloads and form submissions can usually be turned on with a script option instead of code. See our guide to [tracking links and downloads without cookies](/blog/track-outbound-links-and-downloads/).

## 6. Bring over history where you can

If you are moving between privacy-friendly tools, imports are often possible. Tidemark can [import a Plausible export](https://docs.tidemarkanalytics.com/article/140-import-from-plausible), for example. Google Analytics history cannot generally be imported, which is why step 2 matters.

## 7. Check your cookie banner and privacy policy

Once Google Analytics is gone, your site may no longer need the analytics part of its consent banner, but that depends on what else you run (ads, embedded video, chat widgets) and on the rules where you operate. Read [our note on cookie banners](/blog/do-you-need-a-cookie-banner-for-analytics/), then update your privacy policy to describe what you use now. Ask a qualified adviser if you are unsure.

## 8. Remove the Google Analytics tag

When the new numbers look right and your goals are firing:

1. Remove the Google Analytics script or tag manager tag from your pages.
2. Remove it from any plugin or theme setting that also adds it.
3. Disconnect it from Search Console and Google Ads if you linked them.
4. Keep the Google Analytics property for a while without collecting, so you can still open the old reports.

## 9. Tell the people who read the reports

Send teammates a short note: where the dashboard is, which numbers will look different, and that history before the switch lives in the exports you saved. Set a calendar reminder for a month out to review whether the new tool answers the questions you actually ask.

## A quick checklist

- [ ] Listed the reports and goals you use
- [ ] Exported the history you will want later
- [ ] Chosen hosted or self-hosted
- [ ] Installed the new script alongside Google Analytics
- [ ] Compared trends for two to four weeks
- [ ] Recreated goals and events
- [ ] Updated the cookie banner and privacy policy
- [ ] Removed the Google Analytics tag

Most people finish in a weekend and spend the following month mostly checking that nothing is missing.
