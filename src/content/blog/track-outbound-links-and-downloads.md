---
title: "How to track outbound links, downloads and signups without cookies"
description: "Count clicks on outbound links, file downloads, form submissions and custom events like signups, with a cookieless script and no extra tag manager."
date: 2026-10-23
order: 8
tag: Guide
readingMinutes: 6
---

Page views tell you what people read. The questions that matter more are usually about what they did: did they click through to a partner, download the PDF, submit the form, sign up? Those are events, and you can measure them without cookies and without a tag manager.

This guide shows the three ways to do it, using Tidemark's script as the example. The same pattern works with Plausible and other tools that follow its conventions.

## Option 1: Turn on the built-in extras

The simplest route is to ask the script to watch for common actions automatically. The tracking script comes in variants selected by its file name:

- `script.outbound-links.js` counts clicks on links that leave your site.
- `script.file-downloads.js` counts clicks on links to files such as PDFs, archives and installers.
- `script.form-submissions.js` counts submitted forms.

You can combine them in one file name:

```html
<script defer data-domain="yourdomain.com"
  src="https://app.tidemarkanalytics.com/js/script.outbound-links.file-downloads.form-submissions.js"></script>
```

In Tidemark you do not have to edit the file name by hand: in a site's settings, under the tracking extras, switch on outbound link clicks, file downloads and form submissions, and the snippet it shows you updates. Each one also creates a matching goal so the events show up in your dashboard.

Outbound clicks appear as an event named **Outbound Link: Click**, with the destination address stored with it, so you can see which links people actually follow. Downloads appear as **File Download** (with the file's address) and form submissions as **Form: Submission** (with the page the form was on).

## Option 2: Send a custom event from your code

For anything specific to your product, send an event yourself with one line of JavaScript:

```js
window.plausible('Signup')
```

Call it where the action happens: after a successful signup, when someone adds an item to a cart, when a calculator is used. You can attach properties so one event can be broken down later:

```js
window.plausible('Download', { props: { file: 'whitepaper.pdf' } })
```

Properties let you ask questions like "which file gets downloaded most?" without creating a separate event for each.

## Option 3: Use a page as a goal

If the action ends on its own page, you do not need code at all. Create a goal for that page, such as `/thank-you` or `/order-complete`, and every visit to it counts as a conversion. Page goals support wildcards, so `/blog/*` covers every post.

## Create the goal

Events show up in the dashboard's goals section once a goal with the same name exists. In Tidemark, open the site's settings, choose Goals, and add either a **custom event** (type the exact event name, such as `Signup`) or a **page goal** (type the path).

## Read the results

Open the Goals report to see unique conversions, total conversions and the **conversion rate**. Click a goal to switch the whole dashboard into conversion mode: every report then shows which sources, pages, countries and devices produced the conversions, so you can see not just that people signed up but where they came from.

## Do these need cookies?

No. The events use the same cookieless, daily-rotating visitor id as page views, so a "unique conversion" means one visitor completing the action in the period. Nothing is stored on the visitor's device. If you care about what is collected, read our notes on [how cookieless analytics works](/blog/how-cookieless-analytics-works/).

## Tips

- **Name events consistently.** `Signup` and `signup` are different events.
- **Keep the list short.** Track the handful of actions you will actually look at.
- **Test it.** Open your site, perform the action, and watch the realtime view or the goal count to confirm it fires once.
- **Single-page apps** are covered automatically, because the script records a page view on every route change.

The [tracking docs](https://docs.tidemarkanalytics.com/article/115-tracking-custom-events) go into more detail on custom events, and [the script variants guide](https://docs.tidemarkanalytics.com/article/114-tracking-script-variants) lists every option.
