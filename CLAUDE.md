# CaliDay — Instructions for Claude

## Project Description

Mobile Flutter app for home workouts with gamification.
All data is stored locally (Hive), no backend, free, no ads.

## Documentation

| Document | Contents |
|----------|----------|
| **`docs/ARCHITECTURE.md`** | Tech stack, architecture, data models, Hive typeIds, services, navigation, design system, code style, backlog. **Read at session start.** |
| **`docs/DEV_NOTES.md`** | Current status, active feature specs, session change history |
| **`design-system/caliday/BRAND.md`** | Brand & character reference — Goro, Skala, colors, gradients, animations, anti-patterns. **Read before any UI task.** |
| `design-system/caliday/MASTER.md` | UX style rules (Vibrant & Block-based), spacing, component specs |
| `design-system/caliday/pages/` | Per-screen design rules (home.md, profile.md) |
| `docs/CaliDay_Design_Document.md` | Product design document |
| `docs/design-concept/caliday_design_concept.md` | Goro mascot design, colors, icons |

## Tech Stack (brief)

Flutter + Riverpod + Hive + go_router. iOS primary, Android secondary.

## Commands

```bash
flutter run                       # Run
flutter test                      # Tests
flutter analyze                   # Linter
dart run build_runner build       # Code generation (Hive adapters)
dart run flutter_launcher_icons   # Icons
flutter gen-l10n                  # L10n
```

## Code Style

- **Commit messages — always in English**
- Dart style guide, snake_case files, PascalCase classes
- Widgets: StatelessWidget + ConsumerWidget
- API comments in English, UI strings via l10n

## Agent Skills (recurring operations)

Agent Skills in `.claude/skills/`. Auto-triggered by context.

| Skill | When to use |
|-------|-------------|
| `pre-commit` | Before every commit — update documentation and memory |
| `implement-feature` | When starting a new feature or bug fix |
| `document-idea` | When a new product idea or proposal appears |

## Required Pre-Commit Process

Use the `/pre-commit` skill or do manually:

1. **Update `docs/DEV_NOTES.md`** — add entry to "Change History": what was done, which files changed, any non-trivial issues and how they were resolved
2. **Update `docs/ARCHITECTURE.md`** — if the change affects architectural decisions, models, service APIs, or backlog
3. **Update auto-memory** (`MEMORY.md` in `.claude/projects/.../memory/`) — new patterns, key decisions
4. Only then create the commit