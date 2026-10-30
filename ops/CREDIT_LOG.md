# Higgsfield credit log — Donnie Does Deals

Source of truth: Higgsfield's own transaction history (`transactions` in the Higgsfield tools), reconciled to the job IDs in the
"Donnie Does Deals" Higgsfield project. Times are UTC, as Higgsfield reports them. Update this file at the end of every
session or scheduled run that spends credits, and commit it.

**How the credits are split:** Higgsfield has one credit balance per account. There are no per-project budgets. This account
is shared with Eddie's other projects. The 500-credit package bought 2026-10-21 03:35 UTC is the DDD budget; 9.4 credits were
left over from before it. DDD spends are identified by job ID in the ledger below; everything else is listed separately.

## Summary

| | Credits |
|---|---|
| DDD budget (credit package, 2026-10-21) | 500.0 |
| Spent by DDD to date | 424.2 |
| **DDD remaining on paper** | **75.8** |
| Spent by other projects since the package (3D, images, Seedance; not DDD) | 221.0 |
| Plan credits granted 2026-10-24 (account-wide, not DDD-specific) | +1000.0 |
| **Actual account balance (2026-10-30)** | **864.2** |

Other projects have spent 221 credits from the shared pool since the DDD package landed. The plan's 1,000-credit grant
on 2026-10-24 covers that for now, so the pool isn't the constraint; the DDD figure on paper (321.4) is what to track.

## Ledger

| UTC time | Model | Credits | What | Job IDs |
|---|---|---|---|---|
| 2026-10-21 03:35 | Credit package | +500.0 | DDD budget purchased | — |
| 03:37–03:41 | Seed Audio ×6 | −15.6 | Voice auditions for Donnie (6 presets, Kevin picked) | not filed in the project |
| 05:02 | Seed Audio | −2.9 | Pilot 1 Donnie take | `7d1943f7` |
| 05:02 | Seed Audio | −1.2 | Sign-off "Donnie does deals." | `1800af26` |
| 05:04 | Seed Audio ×2 | −2.4 | Therapist voice auditions (Linda picked) | `80967ee6`, `a86b1fb0` |
| 05:04 | Nano Banana 2 ×3 | −6.0 | Donnie keyframes A/B, OTS v1 | `0a43c1e0`, `56041129`, `9f3523f7` |
| 05:06 | Nano Banana 2 ×2 | −4.0 | Therapist portraits | `3884a1d7`, `c861f31b` |
| 05:08 | Nano Banana 2 ×2 | −4.0 | Therapist with glasses | `3d87735e`, `b63ce03b` |
| 05:09 | Nano Banana 2 | −2.0 | OTS v2 | `b1a7d7e2` |
| 05:10 | Wan 2.7 12s 720p | −18.0 | Pilot 1 v1 Donnie clip (old office) | `5f4f95e5` |
| 05:26 | Nano Banana 2 ×4 | −8.0 | Short-hair options A/B, brownstone office options A/B | `0b911f13`, `7cf994a4`, `dc5fe7d7`, `f913a7ff` |
| 05:31 | Wan 2.7 12s 720p | −18.0 | Pilot 1 v2 Donnie clip (office A) | `ecdbc9b7` |
| 05:31 | Nano Banana 2 ×2 | −4.0 | Therapist in office A, brick behind | `eb614158`, `9f8340e1` |
| 05:36 | Wan 2.7 2s ×2 | 0.0 | Therapist lip-sync, failed (−6.0 charged, +6.0 refunded) | `fe60deba`, `d3be589f` |
| 05:38–05:39 | Wan 2.7 3s ×2 | −9.0 | Therapist lip-sync reverse shots | `5c298908`, `3ea6623d` |
| 2026-10-22 11:44 | Seed Audio | −3.2 | Pilot 2 VO (Donnie) | `98e0d0bd` |
| 11:45 | Nano Banana 2 ×2 | −3.0 | Pilot 2 diner keyframes | `79e0fe36`, `7ce053ac` (used) |
| 11:48 | Wan 2.7 9s 720p | −13.5 | Pilot 2 diner lip-sync clip | `de93e098` |
| 2026-10-28 21:28 | Seed Audio | −3.3 | Pilot 3 VO | `33b4fb16` |
| 21:28 | Nano Banana 2 ×2 | −3.0 | Pilot 3 desk keyframes (MCU, 3/4 CU) | `74ff3183` (used), `75124de8` |
| 21:31 | Wan 2.7 1080p 5s+5s+3s | −32.5 | Pilot 3 per-line lip-sync clips | `bd0b1d96`, `1ea7a16b`, `3603e699` |
| 21:33 | Wan 2.7 1080p 5s ×2 | −25.0 | Line 2 re-takes, frontal (one used) | `a443317f` (used), `50fd54e6` |
| 22:12–22:15 | Seed Audio ×7 | −11.9 | Therapy Ep. 2 VO: Donnie + therapist lines, incl. re-records of cut-off takes | `d7b4209a`, `deb24f3c` (used), `3bbf757b`, `7696bc03` (used), `62853543` (used), `221968b8`, `331ca59b` |
| 22:12 | Nano Banana 2 ×2 | −3.0 | Donnie on the sofa, MCU + CU | `303cbfb3`, `7a8d200c` |
| 22:16–22:17 | Wan 2.7 ×5 | −41.5 | Per-line clips: Donnie 4s/5s/4s at 1080p, therapist 3s ×2 at 720p | `eb11b9ad`, `b5a002fd` (used), `41d427a1` (used), `faea022e` (used), `1584a202` (used) |
| 22:19 | Wan 2.7 1080p 4s ×2 | −20.0 | Donnie line 1 re-takes, tighter framing | `18d77431` (used), `398bd477` |
| 2026-10-30 18:13 | Seed Audio + Nano Banana 2 ×3 | −7.9 | Open House Weekend: VO, 2 kitchen keyframes, cookie insert | `5b4a9dc3`, `1fd4eaec`, `2dea5ed4`, `c396f666` |
| 18:16 | Wan 2.7 1080p ×4 | −42.5 | Per-line clips (4s/4s/5s/4s) | `be10f9bc`, `67ca1475` (used), `bf7ed08c` (used), `b31b9f16` (used) |
| 18:18 | Wan 2.7 1080p 4s ×2 | −20.0 | Line 1 re-takes (mouth was early) | `1588fdbd` (used), `6a9a4190` |
| 18:21 | Grok Video 1.5 | 0.0 | Lip-sync A/B test, failed and refunded | `c9bab67e` |
| 2026-10-30 19:19–19:21 | Seed Audio ×4 | −7.3 | Therapy Ep. 3 VO: Donnie + 2 therapist lines + 1 re-record (cut-off) | `922df8cf`, `e8e17ecd`, `91baf63c`, `9cc8eb80` (used) |
| 19:22 | Wan 2.7 ×4 | −44.5 | Donnie 6s/5s/5s at 1080p, therapist 3s at 720p (reused sofa keyframes) | `d58f2123`, `c51fec07`, `0ef62586`, `6681cb06` |
| 19:23–19:32 | Wan 2.7 720p 4s ×2 | −12.0 | Therapist line 2 (second take after I clipped "you" in the edit) | `b50b0883`, `db8b1b94` (used) |
| 2026-10-30 20:36 | Wan 2.7 ×3 | −35.0 | Ep. 3 v2 under lip-sync v2 rules: Donnie 6s + 5s at 1080p (slowed VO), therapist listening shot 5s at 720p, no audio | `8a588975` (used), `791efd79` (used), `0a293f96` (used) |
| | | **−424.2** | **Total spent by DDD** | |

Non-DDD spends in the same window (excluded above): Text to 3D ×19 (−102.5), GPT Image ×17 (−25.5), Tripo 3D (−9.0), Seedance 2.5 ×2 on 2026-10-27 (−84.0).

## By deliverable

| Deliverable | Credits |
|---|---|
| Voice casting (Donnie + therapist) | 18.0 |
| Look development (Donnie, therapist, office, therapist-in-office keyframes) | 24.0 |
| Pilot 1 VO (Donnie take + sign-off, reused in v2) | 4.1 |
| Pilot 1 v1 (old office, OTS stills; superseded) | 22.0 |
| Pilot 1 v2 (Donnie clip + 2 lip-sync shots) | 27.0 |
| Pilot 2 "Money Nobody Asks For" (VO + keyframes + 9s clip) | 19.7 |
| Pilot 3 "The New Car" (1080p per-line clips + 2 re-takes) | 63.8 |
| Therapy Ep. 2 "Perfect Credit" (5 shots + re-takes) | 76.4 |
| Open House Weekend (4 shots + insert + re-takes) | 70.4 |
| Therapy Ep. 3 "Closing Costs" v1 (5 shots + 1 re-take; posted) | 63.8 |
| Therapy Ep. 3 v2 (2 Donnie shots + listening shot; shelved, judged worse) | 35.0 |
| **Total** | **424.2** |

Under the 2026-10-28 production rules (1080p, one clip per line, re-takes when sync is off), expect about 35–45
credits per episode, up from ~20–30.

Correction: the earlier Drive copy of this log said about 70 credits. It undercounted the voice auditions and images. The
figures above come straight from Higgsfield's transaction history.
