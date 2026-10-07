---
name: implement-feature
description: Step-by-step workflow for implementing a new feature or fixing a bug in CaliDay. Use when starting work on any non-trivial change — ensures correct context loading, architecture alignment, and proper documentation at the end.
---

# Implement Feature Workflow

## Step 1 — Load context

Read in this order:
1. `internal_docs/ARCHITECTURE.md` — architecture, storage models, service APIs, patterns
2. `internal_docs/DEV_NOTES.md` — current status and the feature spec (if it exists in "Active Specs")
3. **If the task involves UI:** read `design-system/caliday/BRAND.md` (colors, Goro, gradients, anti-patterns) and the relevant page file in `design-system/caliday/pages/` if it exists
4. Relevant code files (find via Glob/Grep)

**Key patterns from ARCHITECTURE.md** to keep in mind:
- Services mutate objects in place; saving is the caller's responsibility
- `homeDataProvider` and `profileDataProvider` must be invalidated after a workout
- `context.canPop() ? context.pop() : context.go('/home')` when exiting workout

## Step 2 — Research libraries via Context7

**Before writing any code that uses a library or framework API:**

1. Call `resolve-library-id` for each relevant library (Flutter packages, SDKs, etc.)
2. Call `query-docs` with targeted questions about the specific API you need
3. Use the fetched docs to write correct, up-to-date code — do NOT rely on training data for library APIs

**Always check Context7 for:**
- Any new package being added to pubspec.yaml
- Any existing package where the version was recently bumped (APIs may have changed)
- Initialization patterns, method signatures, platform-specific setup
- Migration guides when upgrading major versions

> Skipping Context7 for library code is the leading cause of using deprecated APIs,
> wrong method signatures, and missing required setup steps.

## Step 3 — Plan the implementation

Before writing code, formulate a plan:
- Which files will be modified / created
- If adding Hive CE fields — check ARCHITECTURE.md for the next free `@HiveField` number
- Is code generation needed (`dart run build_runner build`)
- Are new l10n keys needed
- Are changes to `app_router.dart` needed
- Any Android/iOS specifics (permissions, entitlements, Podfile)

Align the plan with the user if changes affect architecture.

## Step 4 — Implement

Principles:
- Minimum changes to solve the task — don't refactor code you're not touching
- Don't add docstrings/comments to existing code
- UI strings via l10n (don't hardcode in code)
- Follow emoji policy: UI chrome → Material Icons, content (achievements) → emoji OK
- **All project documentation (ARCHITECTURE.md, DEV_NOTES.md, skills, memory) is written in English**

## Step 5 — Verify

```bash
flutter analyze          # Required — must stay at zero issues
flutter test             # Required — add or adjust tests for new logic (see ARCHITECTURE.md § Testing)
dart run build_runner build   # If models changed
flutter gen-l10n         # If .arb files changed
```

For UI, also run the app and look at it (`flutter run -d web-server` + the in-app browser; dev options are debug-only). Static checks do not show a screen that renders wrong.

## Step 6 — Bump version in pubspec.yaml

Before committing, update `pubspec.yaml` version to match the backlog milestone:
- `version: X.Y.Z+build` — bump minor (Y) for a new feature milestone (e.g. v0.7 → v0.8), patch (Z) for bugfixes within a milestone
- Always increment the build number (+N) by 1
- **Write the "What's new" entry for the new version** (the bell in the profile): add a `ReleaseNote` to the top of `lib/data/static/release_notes_catalog.dart` and `releaseNotes<version without dots>` to `l10n/app_en.arb` and `app_ru.arb` (one change per line, in the user's words, not the code's). `test/data/release_notes_catalog_test.dart` fails while the newest entry is not the `pubspec.yaml` version. A change that bumps no version needs no entry

## Step 7 — Document and commit

Use the `pre-commit` skill:
- History in DEV_NOTES
- Update ARCHITECTURE.md (final decisions, backlog status → ✅)
- Update MEMORY.md
- Commit in English

---

## Checklist for UI changes

- [ ] Read `design-system/caliday/BRAND.md` before making visual decisions
- [ ] Check `design-system/caliday/pages/[screen].md` for screen-specific rules
- [ ] Streak elements use `AppTheme.energy` (#FF9500) — never grey or blue
- [ ] New cards have `AppTheme.cardShadowLight/Dark` — no flat cards
- [ ] CTA buttons use gradient (`AppTheme.heroGradient` / `AppTheme.rankGradient`) not flat fill
- [ ] Colors only via `AppTheme` tokens — no hardcoded hex in widget code
- [ ] Run `flutter analyze` — no warnings

## Checklist for features with Hive CE changes

- [ ] Next free `@HiveField` number verified (see ARCHITECTURE.md → UserProfile HiveFields)
- [ ] typeId not changed for any existing class
- [ ] `.g.dart` file regenerated (`dart run build_runner build`)
- [ ] New fields documented in ARCHITECTURE.md → UserProfile HiveFields
- [ ] `main.dart`: if new Hive box added — `await Hive.openBox<T>('name')` present

## Checklist for logic with dates or notifications

- [ ] Day counts / day offsets only through `lib/core/utils/calendar_days.dart` (never `difference().inDays` or `Duration(days: n)` arithmetic on local dates — DST)
- [ ] The decision is a pure function with an injectable `now`, covered by a test (DST cases for Europe/Berlin: 2026-03-29, 2026-10-25)
- [ ] New `NotificationService` scheduler: `if (kIsWeb) return;` guard, respects `notificationsEnabled`, and — if it is a one-off alert — is re-created in `scheduleAll()` (it starts with `cancelAll()`)

## Checklist for features using libraries

- [ ] Context7 checked for all library APIs used in this feature
- [ ] No deprecated APIs used (verified against current docs, not training data)
- [ ] Platform-specific setup verified (iOS entitlements, Android manifest, Podfile)
- [ ] If new package added — initialization pattern verified via Context7

## Checklist for features with navigation changes

- [ ] Route added to `app_router.dart`
- [ ] On exit from workout: `context.canPop() ? context.pop() : context.go('/home')`
- [ ] Deep link guard in RouterNotifier if needed
- [ ] Route added to the navigation table in ARCHITECTURE.md

## Checklist for Android specifics

- [ ] New permissions added to `AndroidManifest.xml`
- [ ] Proguard rules updated if needed (for Kotlin/Java classes without Flutter)
- [ ] `postFrameCallback` for services that cannot be initialized in `main()` before `runApp()`