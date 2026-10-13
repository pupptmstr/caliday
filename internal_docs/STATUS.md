# TreniDay — Status

> Part of the project notes — the index is [README.md](README.md). Updated with every branch.

**Version:** 0.9.9 on `main` (CaliDay renamed to TreniDay everywhere, the repository too; 2026-10-13). The owner keeps the version at 0.9.x until they call it 1.0.

## What the app has

| Area | State |
|------|-------|
| Courses | Calisthenics, Healthy Body, Evening Stretch, Morning Routine, Yoga, own courses; 24 branches (4 outside the courses) — [courses.md](reference/courses.md) |
| Exercises | 155 animated (`tools/lottie`) — [tooling.md](reference/tooling.md) |
| Game | SP, streaks and freezes, ranks with decay, 45 achievements, challenges with Skala, five course hosts — [progression.md](reference/progression.md) |
| Workout | hands-free holds (get-ready, sides), 21 sound cues, time estimate at the user's pace — [workout.md](reference/workout.md) |
| Screens | Home (host's line, goals, plan in the button), Courses, Profile, What's new, calendar — [screens.md](reference/screens.md) |
| Platforms | iOS (primary), Android, web (PWA); notifications, Apple Health / Health Connect, four home-screen widgets + iOS lock screen — [platform.md](reference/platform.md) |
| Website | landing page at `pupptmstr.github.io/treniday/` in the app's four languages — [platform.md](reference/platform.md#landing-page-098) |
| Languages | Russian, English; German and Spanish as drafts |
| Quality | 1160+ tests, analyze clean, CI on every push and PR — [testing.md](reference/testing.md) |

## Waiting for the owner (v1.0 blockers)

- **Apple ID in Xcode** (Settings → Accounts) so automatic signing registers the App IDs, the App Group and HealthKit for a real device; then the paid Apple Developer Program and the Google Play Console for the stores. A new personal Play account must run a **closed test with at least 12 testers opted in for 14 days in a row** before it may apply for production access — the longest step. **Plan (owner, 2026-10-13):** iOS and the web first; Android once 12 testers gather by themselves (a call on the site and in the web version on Android phones; no paid testers, no advertising) — [decisions](decisions/README.md#ios-and-the-web-first-android-when-the-testers-gather-owner-2026-10-13). The release CI is drafted and disabled until then ([platform.md § Release builds](reference/platform.md#release-builds-ci--drafted-disabled)).
- **Native proofreading** of German and Spanish — the app and the site (`site/strings/de.json`, `es.json`) — and the store listings (the legal pages stay English only).
- **The name, optionally:** a word mark "TreniDay" in classes 9 and 41 (DPMA or EUIPO) — [specs/done/new-name.md](specs/done/new-name.md). Own domain later, if the owner wants (`treniday.com` / `.app` were free on 2026-10-13).

## Ideas, open (the owner picks)

| Idea | Where |
|------|-------|
| App performance — measure, agree a budget, fix (owner, 2026-10-12) | [specs/performance.md](specs/performance.md) |
| "Support the author" (in-app purchase) — tax / legal set-up first | [research/support-the-author.md](research/support-the-author.md) |
| Rounded / oval frames for the exercise animations (owner: later) | — |
| Progress export / import through a file, **merged** into what the device has — a new phone, web → app (owner, 2026-10-13) | [specs/progress-export.md](specs/progress-export.md) |

**Parked or declined, do not propose:** the Telegram Mini App + bot ([research/telegram-mini-app.md](research/telegram-mini-app.md)); iPhone Safari haptics through the switch-checkbox trick; vibration patterns of our own ([research/vibration-patterns.md](research/vibration-patterns.md)); Rex, the streak monkey; a visit counter on the site (Search Console is enough); a redirect from the old `/caliday/` address — all the owner's, 2026-10-13 for the last four.

## Done ideas

The owner's big features (German / Spanish, three new courses, the course builder with many more exercises) — [specs/done/big-features-roadmap.md](specs/done/big-features-roadmap.md); the ideas of 2026-10-10 (new branches, sounds, the Home middle, widgets, animations everywhere, the notes rework) — [specs/done/next-ideas-2026-10-10.md](specs/done/next-ideas-2026-10-10.md); the new name, TreniDay — [specs/done/new-name.md](specs/done/new-name.md). What changed in each version — [CHANGELOG.md](CHANGELOG.md).
