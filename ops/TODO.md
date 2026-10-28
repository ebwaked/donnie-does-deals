# Donnie Does Deals — open items

Check items off in place and commit, so the history shows who closed what and when.

## Eddie
- [ ] **Instagram bio link → `donniedeals.com/ig`** (in the IG app). Do this before pilot 1 posts; the caption says "link in bio".
- [ ] Delete the 3 test rows in the Leads sheet (Test Lead, Endpoint Test, Site Test). Optional.
- [ ] Meta pixel ID + ad account ID → `_secrets/SECRETS.env`. Needed before any ad spend.
- [ ] TikTok: when the account is ready, connect it on the DDD row in Upload-Post (API profile name `default`).
- [ ] Final consent wording for the quiz. Placeholder text is live in `site/config.js`.

## PZ
- [ ] Tell Donnie leads are live. Emails come from "Donnie Does Deals" with the subject "New first-time buyer: Name (State)", or "[HOT] …" for buyers within 6 months with 620+ credit.
- [ ] Decide who answers Instagram comments and DMs (default: PZ).

## Donnie
- [ ] Add the sender "Donnie Does Deals" (ebwaked87@gmail.com) to contacts so lead emails don't land in spam.
- [ ] Call **[HOT]** leads the same day. Hitting reply on a lead email goes straight to the lead.

## Claude
- [ ] Next episodes follow `ops/PRODUCTION_RULES.md` (tight framing, one line per clip, 1080p, sync gate). Expect ~35–45 credits each.
- [ ] After pilot 1 posts: set up the weekly scheduled run. It builds the next episodes and sends them for approval; nothing posts without "post it".
- [ ] Keep `ops/CREDIT_LOG.md` current from Higgsfield's transaction history after every session that spends credits.

## Done
- [x] 2026-10-28 Pilot 3 "The New Car" posted: https://www.instagram.com/reel/DfDa2zxCCXQ/ (new lip-sync rules applied).
- [x] 2026-10-23 Pilot 2 posted: https://www.instagram.com/reel/De1L7LkCPQ7/
- [x] 2026-10-22 Pilot 1 v2 posted to Instagram: https://www.instagram.com/reel/Dey5yk6CEr5/ (AI-generated label on).
- [x] 2026-10-22 Pilot 2 "Money Nobody Asks For" built and scheduled for Fri 2026-10-23 5:00 AM ET (Upload-Post job `f8a26fa170bb48dc80b716b0b2684eaa`).
- [x] 2026-10-21 Lead capture live: quiz → Apps Script "DDD Leads" → Leads sheet + email to Donnie, PZ, Eddie. Tested from the live site.
- [x] 2026-10-21 Upload-Post connected to Instagram @donniedoesdeals; key in `_secrets/SECRETS.env`, verified read-only.
- [x] 2026-10-21 Pilot 1 v2 cut in the brownstone office (Higgsfield project → Videos, media `434aeea4`).

## Posting

**Time: 5:00 AM ET.** Later's analysis of 6M+ Instagram posts (including ~975K Reels) found posts published 3–6 AM in the
audience's local time get above-average engagement, with 5 AM the best overall slot. For Reels alone the peak was even
earlier, around midnight. 5 AM ET puts the post up fresh as the East Coast wakes up, with a few hours to collect early
views before the lunch scroll. The data is from 2024 and covers all kinds of accounts, so treat it as a starting point:
once there are ~10 posts, switch to the account's own Insights.

**Cadence:** one Reel per publish day, same time, so the account trains a habit.

**Pilot 1 caption:**

> Doc, every first-timer thinks they need 20% down.
> A lot of 'em put down way less. Some get help from the state.
>
> Take the 60-second first-time buyer check, link in bio.
>
> #firsttimehomebuyer #homebuying #downpayment #mortgage #firsthome
