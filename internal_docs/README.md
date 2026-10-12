# CaliDay — project notes: read this first

CaliDay is a Flutter app for short home workouts with a game around them: courses of skill branches with staged progression, SP, streaks, ranks, achievements and Goro the gorilla (plus a host per course). Everything stays on the device (Hive), no backend, free, no ads. iOS first, Android second, the web as a PWA on GitHub Pages.

## Rules that must not break

1. **Hive typeIds and field numbers never change and are never reused**; enum values are appended — [data-hive.md](reference/data-hive.md).
2. **Day arithmetic only through `lib/core/utils/calendar_days.dart`** — never `difference().inDays` or `add / subtract(Duration(days: n))` on local dates (DST).
3. **Every UI text comes from the ARB files** (`l10n/app_<code>.arb`, four languages), the native widgets' texts too; tests guard against Cyrillic and English literals.
4. **No promises of minutes**: only "≈ N min" estimated from the real plan — [decisions](decisions/README.md#no-promises-of-minutes-owner-2026-10-07).
5. **The workout stays hands-free**: holds start by themselves, Pause is opt-in.
6. **Every new `NotificationService` scheduler needs `if (kIsWeb) return;`**, and a one-off alert must be re-created in `scheduleAll()` (it starts with `cancelAll()`).
7. **Generated files are edited through their scripts** (`tools/lottie`, `tools/characters`, `tools/sounds`, `thumb_crops.py`, `export_widget_art.py`, `build_runner`, `gen-l10n`).
8. **New logic gets a test**, decisions as pure functions with an injectable `now`; `flutter analyze` stays at zero.
9. **One branch per session** (`session/<date>-<topic>` from `main`), **the version bumped once per branch** with its "What's new" entry in every ARB file, **squash merge only when the owner says so**.

## Where things are

| File | What it holds |
|------|---------------|
| [STATUS.md](STATUS.md) | the version, what the app has, what waits for the owner, the open ideas |
| [CHANGELOG.md](CHANGELOG.md) | one entry per version: what changed, the owner's decisions, the non-obvious problems and their fixes |
| [reference/overview.md](reference/overview.md) | the stack, the `lib/` structure, code conventions and key patterns, the commands |
| [reference/data-hive.md](reference/data-hive.md) | typeIds, the fields of every model, the boxes, the exercise model |
| [reference/courses.md](reference/courses.md) | courses, own courses, branches, the whole exercise catalog |
| [reference/progression.md](reference/progression.md) | in-stage progression, SP, streaks, ranks, achievements, workout size and pace, the domain services |
| [reference/workout.md](reference/workout.md) | the workout flow, the get-ready countdown, holds on each side, challenges, the sound cues |
| [reference/screens.md](reference/screens.md) | navigation and deep links, the onboarding, Home, "What's new", the design system in the app (Goro, Skala, theme, icons) |
| [reference/platform.md](reference/platform.md) | notifications, the home-screen widgets, Health, iOS and Android specifics, the web build, CI and release builds |
| [reference/testing.md](reference/testing.md) | what the tests protect and how to write them |
| [reference/tooling.md](reference/tooling.md) | the Lottie rigs, the character and sound generators, a local Flutter |
| [decisions/README.md](decisions/README.md) | short records of why things are the way they are |
| [specs/](specs/) | one file per active idea; [specs/done/](specs/done/) keeps the finished ones |
| [research/](research/) | researched and parked or not started: the Telegram Mini App, "Support the author" |

Design and product, outside this folder: `design-system/caliday/BRAND.md` (the brand and characters — **read before any UI task**), `design-system/caliday/MASTER.md` and `pages/` (UX rules per screen), `internal_docs/CaliDay_Design_Document.md` (the product design document), `internal_docs/design-concept/` (Goro's design), `internal_docs/tz_designer.md` (the animation brief). `site/` is the landing page (rendered by `tools/site/build_site.py`) and `docs/` the legal pages (privacy policy, terms); both are public on GitHub Pages — never internal notes.

## Working on the project

**At the start of a session:** this file, then [STATUS.md](STATUS.md), then the reference files the task touches (and BRAND.md for UI).

**Before a commit** (the `pre-commit` skill):
1. [CHANGELOG.md](CHANGELOG.md) — the entry of the branch's version: add what changed, the decisions and the non-obvious problems; one entry per version, not per session.
2. The reference files the change affects (models and Hive fields, services, routes, platform setup, tests); [decisions/](decisions/README.md) when a decision is taken; [STATUS.md](STATUS.md) when an idea starts, finishes or is parked (a finished spec moves to `specs/done/`).
3. Claude's memory (`MEMORY.md` in the user's Claude project folder).

**A new idea** (the `document-idea` skill): a row in STATUS § Ideas and, when it needs planning, a file in `specs/`.

**Commands:** [overview.md § Commands](reference/overview.md#commands) and `CLAUDE.md`.
