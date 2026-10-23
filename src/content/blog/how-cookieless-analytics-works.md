---
title: "How cookieless analytics works (and what it can't tell you)"
description: "How a tool can count visitors without cookies: daily-rotating hashes, what is stored, why returning visitors are harder to spot, and the trade-offs you accept."
date: 2026-10-23
order: 5
tag: Explainer
readingMinutes: 6
---

"Cookieless analytics" sounds like a contradiction: how do you count people without remembering them? The answer is that you count them just well enough to be useful, and deliberately not well enough to follow anyone around the web. This article explains the mechanism, using Tidemark as the worked example, and is honest about what you give up.

## The problem cookies solve

A cookie lets a site tell that two requests came from the same browser. Analytics tools used that to separate "100 visits from 80 people" from "100 visits from 1 person", and to recognize returning visitors across days and weeks. The same ability is what makes cookies a privacy concern, because a stable identifier can be combined with other data to build a profile.

## Counting without a stored identifier

A cookieless tool needs a way to say "this request and that request are probably the same visitor today" without leaving anything on the visitor's device. The usual approach is a hash:

1. A visitor loads a page. A small script sends the page address, the referrer and the screen width to the analytics server.
2. The server already sees the visitor's IP address and browser string (user agent) as part of any web request.
3. It combines the site, the IP address and the user agent with a secret value called a salt, and runs them through a one-way hash function. The result is a short string, the visitor id.
4. It stores the visitor id with the page view, and **throws away the IP address and user agent.**

Two requests from the same browser on the same day produce the same hash, so they count as one visitor. Nothing was written to the visitor's device, and the stored id cannot be turned back into an IP address.

## Why the salt changes every day

If the salt were fixed, the same person would get the same id every day, and you would have rebuilt a persistent identifier with extra steps. So the salt is combined with the date and rotates daily. Tomorrow the same person produces a completely different id.

That is the privacy property: the tool can say how many people visited today, but it cannot say that today's visitor 4F2A is the same person as last Tuesday's visitor 9C71. In Tidemark, the visitor id is an HMAC of the site, IP address and user agent, keyed by a salt that includes the current date, and the raw IP address and user agent never reach the database.

## How visits are stitched together

Within a day, the tool also groups page views into visits. Tidemark ends a visit after 30 minutes of inactivity, which is a common convention. A visit that has only one page view or event counts as a bounce, and the visit duration is the time between its first and last event. Because the id is the same all day, "unique visitors" for a week is the number of distinct daily ids, which counts someone who came on three days as three visitors.

## What you give up

Be clear about the trade-offs before you rely on the numbers:

- **No returning-visitor tracking across days.** You cannot measure loyalty, cohorts or "users who came back next week".
- **Shared networks can merge people.** Two visitors behind the same IP address with the same browser look identical for that day. For most sites this is a small effect.
- **One person on two devices counts twice,** and a visitor whose IP address changes mid-day (moving from Wi-Fi to mobile data) can count twice.
- **Multi-day visitor counts add up daily visitors,** so they run a bit higher than a count of distinct people.
- **No user-level journeys.** You see which pages are popular and where traffic comes from, not the path of an individual.

For content sites, documentation, marketing pages and most small businesses, these limits cost very little, because the questions you ask are about volume and sources, not individuals. For products where you need to follow users through a funnel over weeks, you need a different kind of tool.

## What gets stored

For each page view a cookieless tool like Tidemark keeps aggregate-friendly fields: the page, the referrer and its source category, the country (and region or city when your CDN provides them), the browser, the operating system, the device type and the day-rotating id. It does not store the IP address, the raw user agent, or anything it could use to recognise a person later. You can read the exact list on our [privacy page](/privacy/).

## Does "cookieless" mean "consent-free"?

Not automatically. Whether you need a consent banner depends on the rules in your country and on everything else your site does. We cover that in [Do you need a cookie banner for analytics?](/blog/do-you-need-a-cookie-banner-for-analytics/). What cookieless counting does is make the analytics part easy to describe and low risk.

## Want to see it?

You can [open the live Tidemark dashboard](https://app.tidemarkanalytics.com/tidemarkanalytics.com) that measures this site and see exactly what is collected, or read how the [metrics are defined](/blog/web-analytics-metrics-explained/).
