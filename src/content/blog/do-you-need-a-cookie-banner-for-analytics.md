---
title: "Do you need a cookie banner for website analytics?"
description: "When analytics needs consent and when it may not: what cookies, identifiers and regulators' guidance mean for your site. A plain-language overview, not legal advice."
date: 2026-10-23
order: 4
tag: Privacy
readingMinutes: 7
---

Almost every site with Google Analytics ends up with a cookie banner, and many site owners assume analytics always needs one. The real answer is "it depends", and the dependencies are worth understanding because they decide whether you can have a clean, banner-free site.

This is a general overview to help you ask better questions. **It is not legal advice**, the rules differ by country and change over time, and a banner is often driven by other things on your site besides analytics. If the stakes matter, ask a qualified adviser.

## Why analytics usually triggers a banner

Two sets of rules matter in Europe and the UK:

- **The ePrivacy rules** (the "cookie law") require consent before storing or reading information on a visitor's device, such as a cookie, unless it is strictly necessary to provide the service they asked for.
- **Data protection law** (the GDPR and the UK GDPR) governs personal data: identifiers like cookie IDs and IP addresses count, and processing them needs a legal basis.

A tool that sets a long-lived cookie, builds a profile of a person across visits, or shares the data with the vendor for its own purposes is hard to justify without consent. That is the case for many default analytics setups, which is why the banner appeared.

## Can analytics ever be exempt?

Some regulators have said yes, under conditions. France's data protection authority, the CNIL, publishes [guidance on analytics](https://www.cnil.fr/en/sheet-ndeg16-use-analytics-your-websites-and-applications) saying that audience measurement can be exempt from consent if, among other conditions:

- visitors are informed and can object,
- the data is used only to produce anonymous statistics for the site itself, and is not combined with other processing,
- the tracker is limited to a single site or app,
- identifiers have a limited lifetime and the data is not kept longer than needed, and
- the vendor does not reuse the data for its own purposes.

The older EU working-party guidance reached a similar position for strictly first-party, aggregated statistics. Other countries have their own views, some stricter, and the EU's rules are under review, so a tool that is fine in one country is not automatically fine in another.

## What makes a tool "banner-friendly"

Regardless of the exact rules, these design choices make exemption easier to argue and the privacy risk lower:

- **No cookies and no local storage** on the visitor's device for analytics.
- **No persistent identifier.** A visitor id that is a hash which changes every day cannot be followed from one day to the next, so there is no profile to build.
- **No raw IP addresses or user agents stored.** They can be used briefly to compute the hash and then discarded.
- **Data stays with you,** not sent to a vendor that can use it for advertising or its own purposes.
- **Aggregate reporting only.** You see counts, not individual people.

[Tidemark](/privacy/) is built this way: it sets no cookies, uses no local storage for visitors, stores no IP addresses, and uses a daily-rotating salted hash for the visitor id. We still do not tell you that you do not need a banner, because that depends on your jurisdiction and everything else your site does. We tell you what the tool does so you or your adviser can decide.

## The banner often has other causes

Removing analytics from the consent banner rarely removes the banner itself. Check what else sets or reads data on a visitor's device:

- advertising and remarketing tags,
- embedded video, maps and social widgets,
- chat widgets and A/B testing tools,
- fonts or scripts loaded from third parties that receive the visitor's IP address.

If you keep any of those, you probably still need a banner for them, even if analytics no longer asks for consent.

## A practical way to decide

1. **List everything that runs on your pages** that stores or reads something on a visitor's device, or sends data to a third party.
2. **Check how your analytics tool counts visitors:** cookies? local storage? raw IPs? a persistent id?
3. **Read your regulator's guidance** for the countries where your visitors are, or ask an adviser.
4. **Be transparent either way.** Say what you measure in your privacy notice, even if you do not need consent.
5. **Revisit it** when you add or remove a tool, or when the rules change.

## What we promise and what we do not

We make no promise that using any tool, including ours, makes you "compliant". We do promise a short, checkable description of what Tidemark does and does not collect: see [privacy by construction](/privacy/). If you are moving off Google Analytics, our [switching guide](/blog/switch-from-google-analytics/) includes a step for updating your banner and privacy policy.
