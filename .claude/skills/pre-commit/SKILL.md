---
name: pre-commit
description: Pre-commit workflow for CaliDay project. Use before every git commit — updates project documentation and Claude's memory to reflect the changes being committed.
---

# Pre-Commit Workflow

Perform the following steps in order before every commit.

## Step 1 — Update history in DEV_NOTES.md

Add an entry to the "Change History" section (`docs/DEV_NOTES.md`).

Entry format:
```
### YYYY-MM-DD — <short description>

**What was done:** [1-2 sentences]

**New files:**
- `path/file.dart` — purpose

**Modified files:**
- `path/file.dart` — what changed

**Key issues and solutions:** [if there were non-trivial technical decisions]
```

Rules:
- Place new entry at the top of "Change History" (newest first)
- For small fixes, merge with a previous entry from the same day
- Issues and solutions are the most valuable part: record only non-trivial, non-obvious ones

## Step 2 — Update ARCHITECTURE.md (if needed)

Update `docs/ARCHITECTURE.md` if the changes affect:
- Architectural decisions or patterns
- Hive models or typeIds (critical!)
- Service or repository APIs
- Navigation (routes, flows)
- Design system (Goro, colors, icons)
- Feature backlog (implemented feature status → ✅)
- Android/iOS specifics
- Dependencies (pubspec.yaml)

Skip if changes are UI-only (texts, styles) with no architectural implications.

## Step 3 — Clean up implemented specs in DEV_NOTES (if needed)

If a feature is fully implemented and DEV_NOTES has a detailed spec for it:
- Remove the spec from "Active Specs"
- Keep only the entry in "Change History" (what was done, problems)
- Final decisions should already be captured in ARCHITECTURE.md

## Step 4 — Update MEMORY.md

Update auto-memory (`.claude/projects/.../memory/MEMORY.md` and memory files) if there are:
- New architectural patterns or key decisions
- Critical technical constraints (especially Android/iOS specifics)
- New HiveField numbers or typeIds
- Backlog changes (what was implemented)

Do not duplicate what is already in ARCHITECTURE.md — memory is for quick access to the most important things.

## Step 5 — Create the commit

Only after updating documentation, create the commit:
- Message in English
- Format: `feat:` / `fix:` / `refactor:` / `docs:` / `chore:` + short description