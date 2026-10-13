# TreniDay — Status

> Part of the project notes — the index is [README.md](README.md). Updated with every branch.

**Version:** 0.9.9 on branch `session/2026-10-13-treniday` (CaliDay renamed to TreniDay everywhere, the repository too), waiting for the owner's go. `main` has 0.9.8. The owner keeps the version at 0.9.x until they call it 1.0.

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

- **Apple ID in Xcode** (Settings → Accounts) so automatic signing registers the App IDs, the App Group and HealthKit for a real device; then the paid Apple Developer Program and the Google Play Console for the stores. The release CI is drafted and disabled until then ([platform.md § Release builds](reference/platform.md#release-builds-ci--drafted-disabled)).
- **Native proofreading** of German and Spanish — the app and the site (`site/strings/de.json`, `es.json`) — and the store listings (`fastlane/metadata/de-DE`, `es-ES`, `android/de-DE`, `android/es-ES`; the legal pages stay English only).
- **The store listings — ready for review** (branch `session/2026-10-13-store-listing`): the texts of both stores in four languages in `fastlane/metadata/` (within every limit: `tools/store/check_listing.py`), the answers for App Privacy, Data safety, the age ratings, the Health declarations and export compliance, and the screenshot plan — [specs/store-listing.md](specs/store-listing.md). Before the first upload: the owner's iPad decision (the app shows its phone layout stretched on an iPad; iPhone only for 1.0 is recommended) and a native follow-up (English Health purpose strings, `ITSAppUsesNonExemptEncryption`, a privacy manifest, no `USE_EXACT_ALARM`, the privacy policy from Health Connect); the screenshots are not made yet.
- **To check on an iPhone after the deploy:** every workout sound in the web version (0.9.8). With the silent switch on they keep quiet — decided.
- **Google Search Console:** the property `https://pupptmstr.github.io/treniday/` is created and its HTML tag is in `site/template.html` (2026-10-13); once that is deployed: "Verify", then `sitemap.xml` and "Request indexing" for the four language pages (the owner's Google account).
- **The name, optionally:** a word mark "TreniDay" in classes 9 and 41 (DPMA or EUIPO) — [specs/done/new-name.md](specs/done/new-name.md). Own domain later, if the owner wants (`treniday.com` / `.app` were free on 2026-10-13).

## Ideas, open (the owner picks)

| Idea | Where |
|------|-------|
| App performance — measure, agree a budget, fix (owner, 2026-10-12) | [specs/performance.md](specs/performance.md) |
| Vibration patterns of our own per cue | [specs/vibration-patterns.md](specs/vibration-patterns.md) |
| "Support the author" (in-app purchase) — tax / legal set-up first | [research/support-the-author.md](research/support-the-author.md) |
| Rounded / oval frames for the exercise animations | — |
| Progress export / import through a file, **merged** into what the device has — a new phone, web → app (owner, 2026-10-13) | [specs/progress-export.md](specs/progress-export.md) |
| Rex, the streak monkey | deferred |

**Parked, do not propose:** the Telegram Mini App + bot ([research/telegram-mini-app.md](research/telegram-mini-app.md)); iPhone Safari haptics through the switch-checkbox trick.

## Done ideas

The owner's big features (German / Spanish, three new courses, the course builder with many more exercises) — [specs/done/big-features-roadmap.md](specs/done/big-features-roadmap.md); the ideas of 2026-10-10 (new branches, sounds, the Home middle, widgets, animations everywhere, the notes rework) — [specs/done/next-ideas-2026-10-10.md](specs/done/next-ideas-2026-10-10.md); the new name, TreniDay — [specs/done/new-name.md](specs/done/new-name.md). What changed in each version — [CHANGELOG.md](CHANGELOG.md).
