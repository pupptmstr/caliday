---
name: pre-commit
description: Pre-commit workflow for CaliDay project. Use before every git commit — updates project documentation and Claude's memory to reflect the changes being committed.
---

# Pre-Commit Workflow

Perform the following steps in order before every commit.

## Step 0 — Verify

`flutter analyze` (zero issues) and `flutter test` must pass. If the change touches the UI, run the app and look at it.

## Step 0.5 — Release note (once per branch)

The version is bumped once per session branch (CLAUDE.md § Branches and Versions). The version in `pubspec.yaml` and the newest entry of `lib/data/static/release_notes_catalog.dart` (the "What's new" under the bell in the profile) must be the same: a test checks it. First user-visible change on the branch: new entry on top, texts `releaseNotes<version without dots>` in every ARB file, then `flutter gen-l10n`. Later changes on the same branch: add a line to that same text instead of a new version. Write what the user sees, one change per line.

## Step 1 — Update the version's entry in CHANGELOG.md

`internal_docs/CHANGELOG.md` has **one entry per version** (one session branch = one version), newest first. The first commit of a branch that bumps the version adds the entry; later commits on the branch extend it — never a new entry per session or per commit.

Entry format:
```
## 0.9.8 — YYYY-MM-DD — <the release in a few words>

Branch `session/<date>-<topic>`.

**<A change, bold>** (the owner's decision or the idea it came from): what the user gets, with a link to the reference section that now describes it.
- The non-obvious problems and how they were solved (the most valuable part).
```

Rules:
- Record only what is not obvious from the code or the diff: decisions, reasons, traps, lessons.
- No lists of modified files (git has them).

## Step 2 — Update the reference files (if needed)

Update the files of `internal_docs/reference/` the change affects:
- `data-hive.md` — models, typeIds, HiveFields, boxes (critical!)
- `progression.md`, `workout.md`, `courses.md` — services, rules, the catalog
- `screens.md` — routes, deep links, the onboarding, Home, the design system in the app
- `platform.md` — notifications, widgets, Health, iOS / Android / web specifics, CI
- `overview.md` — the stack, the structure tree, conventions, commands; `testing.md` — what the tests protect; `tooling.md` — the generators

Also: `decisions/README.md` for a new decision of the owner (what, why, since when); `STATUS.md` when an idea starts, finishes or is parked; a finished spec moves from `specs/` to `specs/done/`.

Skip if the changes are UI-only (texts, styles) with no lasting implications.

## Step 4 — Update MEMORY.md

Update auto-memory (`.claude/projects/.../memory/MEMORY.md` and memory files) if there are:
- New architectural patterns or key decisions
- Critical technical constraints (especially Android/iOS specifics)
- New HiveField numbers or typeIds
- Backlog changes (what was implemented)

Do not duplicate what is already in `internal_docs/` — memory is for quick access to the most important things. `MEMORY.md` is an index (one line per entry, under 200 lines); the facts live in the topic files next to it.

## Step 5 — Create the commit

Only after updating documentation, create the commit **on the session branch** (never on `main`, which is protected and takes pull requests only; the branch's PR is squash-merged when the owner says it is done):
- Message in English
- Format: `feat:` / `fix:` / `refactor:` / `docs:` / `chore:` + short description