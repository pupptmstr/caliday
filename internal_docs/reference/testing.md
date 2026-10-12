# Testing

> Part of the project notes — the index is [internal_docs/README.md](../README.md).

## Testing

`flutter test` runs every test on the Dart VM — no device, emulator or network. Hive works there too: tests use a real database in a temp directory.

| Area | Where | What it protects |
|------|-------|------------------|
| Domain services | `test/domain/services/` | SP, progression, streak, rank decay, workout generator (with a Hive-free progress source), achievements |
| Own courses and branches | `test/domain/services/custom_stages_test.dart`, `own_branch_workout_test.dart`, `test/domain/models/branch_course_test.dart`, `test/data/repositories/custom_course_repository_test.dart` | derived amounts and norms for every pickable exercise, remap after an edit, `Branch` / `Course` mirror the catalog, an own stage moves the own branch (not the built-in one), its challenge, adapters, cascading deletes, the active course persisted and falling back |
| Day arithmetic | `test/core/utils/calendar_days_test.dart`, `streak_service_test.dart`, `test/features/profile/compact_heatmap_test.dart` | DST: Berlin dates around 2026-03-29 and 2026-10-25 |
| Catalog integrity | `test/data/exercise_catalog_integrity_test.dart` | unique ids, consecutive stages, start ≤ target, every animation exists, is valid Lottie and belongs to an exercise (no orphans), a name / description / tip for every exercise in every language, tags |
| Enums | `test/data/enums_test.dart` | rank thresholds, `stageCount` = catalog length, frozen Hive indices, course → branch mapping |
| Repositories | `test/data/repositories/` | real Hive via `test/helpers/hive_test_env.dart` (same adapters and box names as `main()`; `reopen()` proves a field really went through its adapter) |
| Localization | `test/l10n/`, `test/core/app_languages_test.dart` | every ARB file has the keys and placeholders of the template, none undeclared, and is a language of the pickers (`appLanguages`); plural forms, and in every language a counted message carries its number; **no Cyrillic text in `lib/` outside a short allow-list** (`no_hardcoded_text_test.dart`: debug screen and the DEBUG tile, the debug test notification, the language list (each language named in itself), the search's "ё" — each with its reason; the test also fails when an allowed file no longer needs its exception) and **no English text in the places where text is shown**: the first argument of `Text(`/`Text.rich(` and the value of `label:`, `title:`, `subtitle:`, `hintText:`, `tooltip:`, `message:`… including a literal inside a ternary or a `+`, but not an argument of a call such as `DateFormat('d MMMM')`; "SP", "CaliDay", "dBm" are the same in every language; paths are compared with `/` on every OS (Windows lists `lib\...`); `lib/data/` (the catalog's source text) is not scanned; the test checks itself on probe snippets so that a scan that matches nothing cannot pass |
| Notification plan | `test/domain/services/notification_planner_test.dart` | which reminders exist for which settings, their times, DST (Berlin) and other zones, the one-off streak-lost / rank-at-risk alerts, the language (none → Russian, unknown → English), every kind with its own text in every language |
| Health energy | `test/domain/services/workout_energy_test.dart` | MET formula, which weight sample is used, implausible weights fall back to 70 kg |
| Router redirect | `test/core/router/app_redirect_test.dart` | onboarding gate, widget deep links, an old friend QR link opens Home, no redirect loops |
| Workout timer | `test/features/workout/workout_timer_test.dart` | a timed exercise waits for Start in every transition (first, after rest, no-rest sets, next exercise), then counts down and confirms itself |
| Home-screen widgets | `test/core/widget_snapshot_test.dart`, `test/core/widget_service_test.dart` | what the widgets show (the days they decide by, DST, the SP of the day, the rank, the plan, the growth, every text in every language); Dart, Swift and Kotlin in step: every key read on both platforms, the same poses and art, every kind / provider declared, each link opens its place, the gallery names in every language, no Russian elsewhere in the native code |
| Repository / CI files | `test/repo/workflows_test.dart` | the three workflows pin one Flutter version, the release workflow stays disabled and tag-only, ci.yml keeps its l10n / build steps |

Conventions:
- Prefer a pure function with an injectable `now` over faking the clock (`RankDecayService.daysSinceLastWorkout`, `StreakService.daysSinceLastWorkout`, `CompactHeatmap.weekGrid`).
- DST tests are written for Europe/Berlin; on a machine in a zone without DST they pass without proving anything.
- If a known data gap ever has to be tolerated, allow-list it **explicitly** in the test with a comment, never skip silently (there is none at the moment).
- Widget tests exist only for Goro's poses on About (`test/features/settings/goro_poses_test.dart`) and the workout button's plan (`test/features/home/workout_plan_button_test.dart`; it pumps a fixed time — the thumbnails' looping Lottie never settles); there are no golden tests. UI is otherwise checked by running the app — `flutter run -d web-server` plus the in-app browser works well (dev options are `kDebugMode` only).
- Plugin-bound code is split: the decision (what, when, which bytes, which number) is a pure function that is tested; the thin wrapper that calls the plugin is not (`NotificationService`, `HealthService`, `WidgetService.update`). Keep new plugin code in that shape.
