# CaliDay — Instructions for Claude

## Project Description

Mobile Flutter app for home workouts with gamification.
All data is stored locally (Hive), no backend, free, no ads.

## Documentation

| Document | Contents |
|----------|----------|
| **`internal_docs/README.md`** | The index of the project notes and the rules that must not break. **Read at session start**, then `STATUS.md` and the `reference/` files the task touches. |
| `internal_docs/STATUS.md` | The version, what the app has, what waits for the owner, the open ideas |
| `internal_docs/CHANGELOG.md` | One entry per version: what changed, decisions, non-obvious problems and fixes |
| `internal_docs/reference/` | overview (stack, structure, conventions, commands), data-hive, courses, progression, workout, screens, platform (notifications, widgets, Health, iOS, Android, web, CI), testing, tooling |
| `internal_docs/decisions/`, `specs/`, `research/` | Why things are so; one file per active idea (`specs/done/` for finished ones); parked research |
| **`design-system/caliday/BRAND.md`** | Brand & character reference — Goro, Skala, colors, gradients, animations, anti-patterns. **Read before any UI task.** |
| `design-system/caliday/MASTER.md` | UX style rules (Vibrant & Block-based), spacing, component specs |
| `design-system/caliday/pages/` | Per-screen design rules (home.md, profile.md) |
| `internal_docs/CaliDay_Design_Document.md` | Product design document |
| `internal_docs/tz_designer.md` | Brief for the Lottie animations (status per branch, how they are generated) |
| `site/` | The public landing page (template + strings per language), rendered by `tools/site/build_site.py` into the root of the GitHub Pages site |
| `docs/` | Public legal pages (Privacy Policy, Terms of Use) published to GitHub Pages — URLs are referenced from the app and store listings |
| `internal_docs/design-concept/caliday_design_concept.md` | Goro mascot design, colors, icons |

## Tech Stack (brief)

Flutter + Riverpod 3.x + Hive CE + go_router. iOS primary, Android secondary, Web (PWA on GitHub Pages).

## Library Research — Context7 (mandatory)

**Before using any library or framework API — check Context7 first.**

```
1. resolve-library-id  — find the correct library ID
2. query-docs          — fetch current API docs for the specific question
```

Required for: new packages, recently upgraded packages, initialization patterns,
method signatures, platform setup, migration guides. Do NOT rely on training data
for library APIs — it may be outdated.

## Commands

```bash
flutter run                       # Run
flutter test                      # Tests (1160+, no device needed — see internal_docs/reference/testing.md)
flutter analyze                   # Linter
dart run build_runner build       # Code generation (Hive adapters)
dart run flutter_launcher_icons   # Icons
flutter gen-l10n                  # L10n
flutter build web --release --base-href /caliday/app/   # Web build (CI deploys it to GitHub Pages)
python3 tools/lottie/gen_flex.py  # Regenerate Flex Lottie animations (also gen_supp.py, gen_posture.py, gen_neck.py, gen_cooldown.py, gen_pull.py, gen_push.py, gen_evening.py, gen_morning.py, gen_yoga.py, gen_extra.py; enliven.py / patch_old.py fix designer files in place)
python3 tools/lottie/check_anim.py NAME ...   # Jump / loop-seam check of generated animations
python3 tools/lottie/build_preview.py --preset flex|supp|posture|neck|cooldown|pull|push|refresh|evening|morning|yoga|extra   # Page to watch generated animations
python3 tools/lottie/frame_sheet.py build/sheet.html --count 8 FILE.json   # Still frames side by side (open via the lottie-sheets preview server)
python3 tools/lottie/thumb_crops.py   # Re-crop the exercise thumbnails after adding or redrawing an animation (a test fails otherwise)
python3 tools/characters/gen_goro.py  # Goro's fun poses (About) and his locked-achievement pose; gen_hosts.py / gen_skala.py for the hosts and Skala
python3 tools/sounds/gen_sounds.py   # Regenerate the workout cues (assets/sounds); build_preview.py makes a page to listen to them
python3 tools/characters/export_widget_art.py   # Goro's faces and poses as PNG for the native home-screen widgets (iOS assets + Android drawable-nodpi)
python3 tools/site/build_site.py build/site_preview   # Render the landing page (site/, four languages); the caliday-site launch config serves it; CI renders it into the Pages site
python3 tools/site/make_og.py   # Redraw the landing page's link-preview cards (site/og-<lang>.png)
```

## Code Style

- **Commit messages — always in English**
- Dart style guide, snake_case files, PascalCase classes
- Widgets: StatelessWidget + ConsumerWidget
- API comments in English, UI strings via l10n
- **Day arithmetic only through `lib/core/utils/calendar_days.dart`** — never `DateTime.difference().inDays` or `subtract/add(Duration(days: n))` on local dates (DST: a day can be 23 / 25 h)
- **Every new `NotificationService` scheduler needs an `if (kIsWeb) return;` guard**, and a one-off alert has to be re-created in `scheduleAll()` (it starts with `cancelAll()`)
- New logic gets a test (`test/`); keep decisions in pure functions with an injectable `now`. `flutter analyze` must stay at zero issues
- Check the UI by running it: `flutter run -d web-server` + the in-app browser (dev options are debug-only)

## Agent Skills (recurring operations)

Agent Skills in `.claude/skills/`. Auto-triggered by context.

| Skill | When to use |
|-------|-------------|
| `pre-commit` | Before every commit — update documentation and memory |
| `implement-feature` | When starting a new feature or bug fix |
| `document-idea` | When a new product idea or proposal appears |

## Branches and Versions (owner's rule, 2026-10-08)

- **Every session works on its own branch** (`session/<date>-<topic>`), never directly on `main`. Create it at the start of the session from an up-to-date `main`.
- **The version is bumped once per branch**, with the first change that the user sees. Everything else on the branch (more fixes, animations, a feature) goes under that same version: extend its `releaseNotes<version>` text instead of adding a new entry, so one merge gives one "What's new" entry.
- **The branch is merged into `main` when the owner says it is done.** A push to `main` deploys the web build (`web.yml`); CI also runs on pull requests.
- **Always a squash merge** (owner, 2026-10-10): `gh pr merge <n> --squash`, never a merge commit or a rebase, so `main` gets one commit per branch. The PR title becomes that commit's subject — make it read as the release summary.

## Required Pre-Commit Process

Use the `/pre-commit` skill or do manually:

1. **Update `internal_docs/CHANGELOG.md`** — the entry of the branch's version: what changed, the owner's decisions, non-trivial issues and how they were resolved (one entry per version, not per session)
2. **Update the `internal_docs/reference/` files** the change affects (models and Hive fields, services, routes, platform setup, tests), `decisions/` for a new decision, `STATUS.md` when an idea starts, finishes or is parked
3. **Update auto-memory** (`MEMORY.md` in `.claude/projects/.../memory/`) — new patterns, key decisions
4. Only then create the commit