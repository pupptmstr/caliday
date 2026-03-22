---
name: implement-feature
description: Step-by-step workflow for implementing a new feature or fixing a bug in CaliDay. Use when starting work on any non-trivial change — ensures correct context loading, architecture alignment, and proper documentation at the end.
---

# Implement Feature Workflow

## Step 1 — Load context

Read in this order:
1. `docs/ARCHITECTURE.md` — architecture, Hive typeIds, service APIs, patterns
2. `docs/DEV_NOTES.md` — current status and the feature spec (if it exists in "Active Specs")
3. Relevant code files (find via Glob/Grep)

**Key patterns from ARCHITECTURE.md** to keep in mind:
- Hive typeIds cannot be changed after release
- UserProfile HiveField numbers are occupied up to @22
- Services mutate objects in place; saving is the caller's responsibility
- `homeDataProvider` and `profileDataProvider` must be invalidated after a workout
- `context.canPop() ? context.pop() : context.go('/home')` when exiting workout

## Step 2 — Plan the implementation

Before writing code, formulate a plan:
- Which files will be modified / created
- If adding Hive fields — what is the next free `@HiveField` number
- Is code generation needed (`dart run build_runner build`)
- Are new l10n keys needed
- Are changes to `app_router.dart` needed
- Any Android/iOS specifics

Align the plan with the user if changes affect architecture.

## Step 3 — Implement

Principles:
- Minimum changes to solve the task — don't refactor code you're not touching
- Don't add docstrings/comments to existing code
- UI strings via l10n (don't hardcode in code)
- Follow emoji policy: UI chrome → Material Icons, content (achievements) → emoji OK
- New HiveFields: add strictly in order, document in ARCHITECTURE.md

## Step 4 — Verify

```bash
flutter analyze          # Required — fix all warnings
flutter test             # If tests exist
```

For Hive model changes:
```bash
dart run build_runner build   # Regenerate .g.dart files
```

## Step 5 — Document and commit

Use the `pre-commit` skill:
- History in DEV_NOTES
- Update ARCHITECTURE.md (final decisions, backlog status → ✅)
- Update MEMORY.md
- Commit in English

## Checklist for features with Hive changes

- [ ] Next free @HiveField number verified
- [ ] typeId not changed for existing classes
- [ ] `.g.dart` file regenerated
- [ ] New fields documented in ARCHITECTURE.md → UserProfile HiveFields
- [ ] `main.dart`: if new Hive box — added `await Hive.openBox<T>('name')`

## Checklist for features with navigation changes

- [ ] Route added to `app_router.dart`
- [ ] On exit from workout: `context.canPop() ? context.pop() : context.go('/home')`
- [ ] Deep link guard in RouterNotifier if needed
- [ ] Route added to the navigation table in ARCHITECTURE.md

## Checklist for Android specifics

- [ ] New permissions added to `AndroidManifest.xml`
- [ ] Proguard rules updated if needed (for Kotlin/Java classes without Flutter)
- [ ] `postFrameCallback` for services that cannot be initialized in `main()` before `runApp()`