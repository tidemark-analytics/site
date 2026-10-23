---
title: "Web analytics metrics explained: visitors, visits, pageviews, bounce rate and duration"
description: "What each core web analytics metric actually measures, how it is calculated, and which ones to trust when you read your dashboard."
date: 2026-10-23
order: 7
tag: Explainer
readingMinutes: 7
---

Every analytics tool shows a handful of headline numbers, and they are easy to misread because the words are used loosely. "Visitors" and "visits" are not the same thing. A "bounce" does not mean the person disliked your page. This guide defines each metric in plain language, shows how it is usually calculated (with Tidemark's definitions as the worked example), and says what each is good for.

Different tools define these slightly differently, so never compare an exact number between two tools. Compare each tool with itself over time.

## Unique visitors

**What it is:** the number of distinct people who came to your site in the period you are looking at.

**How it is counted:** tools use an identifier to tell visitors apart. Cookie-based tools use a cookie. Cookieless tools like Tidemark use a hash of the visitor's IP address and browser details that changes every day, so a visitor is "one browser, one day". Over a longer period the daily counts are added up, which means someone who visited on three different days counts three times in a 28-day view.

**Good for:** the size of your audience and its trend.
**Watch for:** two people sharing a network and browser can look like one, and one person on two devices counts twice.

## Total visits (sessions)

**What it is:** the number of separate trips to your site. One visitor can make several visits.

**How it is counted:** page views are grouped into a visit. A common rule, used by Tidemark, is that a visit ends after 30 minutes of inactivity, so a return after lunch starts a new visit.

**Good for:** how often people come, compared with how many people there are. If visits are much higher than visitors, people are coming back.

## Total pageviews

**What it is:** how many times pages were loaded.

**How it is counted:** every page load counts once, including repeat views of the same page. Single-page apps count a view when the route changes, which Tidemark's script does automatically.

**Good for:** overall activity and which content is popular.
**Watch for:** refreshes inflate it, and it says nothing about attention.

## Views per visit

**What it is:** pageviews divided by visits: the average number of pages someone looks at in a visit.

**Good for:** whether people explore or leave after one page. A guide site wants it higher than a landing page does.

## Bounce rate

**What it is:** the share of visits that ended after a single page view or event.

**How it is counted:** visits with one page view and nothing else, divided by all visits. In Tidemark, a visit with a single event is a bounce.

**What it does not mean:** a bounce is not a failure. Someone who finds a recipe, reads it and leaves has bounced and was perfectly served. It is most useful when you compare pages with the same purpose, or watch one page over time.
**Watch for:** it differs between tools, because some count short engaged visits as non-bounces.

## Visit duration

**What it is:** how long a visit lasted on average.

**How it is counted:** the time between the first and the last event in a visit. A visit with a single page view has a duration of zero, because there is no second event to measure against, which is why average duration looks shorter than you might expect on content-heavy sites with many one-page visits.

**Good for:** a rough sense of engagement, best read together with bounce rate.

## Traffic sources and channels

**What it is:** where visitors came from. A **source** is a specific site or campaign (Google, Reddit, a newsletter). A **channel** is a group of sources (Organic Search, Social, Email, Referral, Direct).

**How it is counted:** from the page that sent the visitor (the referrer) and any campaign tags (UTM parameters) on the link. Visits with neither are "Direct", which includes typed addresses, bookmarks and links from apps that do not send a referrer.

**Good for:** knowing which channels are worth your time.
**Watch for:** "Direct" is a catch-all, so tag your own links with UTM parameters if you want them classified.

## Goals and conversions

**What it is:** a count of visitors doing something you care about: signing up, downloading, buying, submitting a form.

**How it is counted:** a goal is either a visit to a particular page (for example a thank-you page) or a custom event your site sends. The **conversion rate** is the visitors who completed the goal divided by all visitors. See [how to track links and downloads](/blog/track-outbound-links-and-downloads/).

## Which numbers to trust

- **Trust trends over exact values.** Whether this month beats last month matters more than the absolute count.
- **Read metrics in pairs.** Bounce rate with duration, visits with visitors, pageviews with views per visit.
- **Segment before you conclude.** A site-wide bounce rate hides that your blog and your pricing page behave very differently.
- **Remember what is not measured.** Visitors who block scripts, and traffic that never loads your page, do not appear in any script-based tool.

## Seeing them together

The point of a one-page dashboard is that you can read these numbers side by side without hunting through reports. You can [look at a live one](https://app.tidemarkanalytics.com/tidemarkanalytics.com), click a metric to see it on the graph, and click any row to filter the whole page by it.
