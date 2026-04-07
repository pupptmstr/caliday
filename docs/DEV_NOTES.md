# CaliDay — Developer Notes

A living document. Contains current status, active feature specs in progress, and change history.
**Stable decisions and architecture → `docs/ARCHITECTURE.md`**

---

## Current Status

**Version:** v1.4 (implemented)
**Next priority:** TBD — see Active Specs below

Latest APK build: `build/app/outputs/flutter-apk/caliday.apk` (~57 MB)

| Layer | Status |
|-------|--------|
| Data models + Hive | ✅ |
| ExerciseCatalog (all 5 branches) | ✅ |
| Repositories (User, SkillProgress, Workout, Achievement) | ✅ |
| Domain services | ✅ |
| Navigation (GoRouter + bottom nav) | ✅ |
| Onboarding (8 steps) | ✅ |
| Home / Progress / Profile / Settings | ✅ |
| Workout / Summary | ✅ |
| BranchJourney / Achievements / About / DevOptions | ✅ |
| Notifications (4 types) | ✅ |
| Dark theme | ✅ |
| Goro (6 expressions) + Skala | ✅ |
| Lottie animations (Push, 7/7) | ✅ |
| Sound + haptics | ✅ |
| Home Screen Widget (iOS + Android) | ✅ |
| Health Integration (iOS + Android) | ✅ |
| Friends (BLE/QR, v1.4) | ✅ |
| L10n (RU + EN) | ✅ |

---

## Active Specs (ideas in progress)

### v1.4 — Friends — нужно протестировать на реальных устройствах

Фича реализована, но **не тестировалась на физических устройствах**. Требует проверки вдвоём (два телефона).

#### Чеклист тестирования

**QR (iOS + Android):**
- [ ] Открыть экран Friends → появляется QR-код своего профиля
- [ ] Сканировать QR другого человека → диалог подтверждения показывает имя + SP + streak
- [ ] Подтвердить → друг появляется в списке
- [ ] Повторно сканировать того же человека → обновляет данные (не дублирует)
- [ ] Открыть карточку друга → показывает ранг, ветки, дату синхронизации
- [ ] Удалить друга → исчезает из списка
- [ ] Невалидный QR → показывает snackbar с ошибкой (не крашится)

**BLE — сканирование (требует двух устройств):**
- [ ] iOS → iOS: обнаружение работает
- [ ] Android → Android: обнаружение работает
- [ ] iOS → Android: обнаружение работает (и наоборот)
- [ ] BLE выключен → секция "Nearby" показывает сообщение "Bluetooth выключен"
- [ ] Кнопка Refresh → запускает повторное сканирование
- [ ] Tile "Connect" → открывает QR-сканер (GATT-обмен не реализован, QR — основной путь)

**BLE — разрешения:**
- [ ] Android: при первом открытии Friends появляется запрос `BLUETOOTH_SCAN` + `BLUETOOTH_CONNECT`
- [ ] iOS: при первом открытии появляется запрос `NSBluetoothAlwaysUsageDescription`
- [ ] Отказ от разрешений → приложение не крашится, показывает "Bluetooth выключен"

**Специфично для iOS:**
- [ ] BLE-сканирование работает на iOS 14+ (минимальная поддерживаемая версия)
- [ ] QR-сканер запрашивает разрешение камеры при первом использовании

**Специфично для Android:**
- [ ] BLE-разрешения правильно запрашиваются на Android 12+ (API 31+) через `BLUETOOTH_SCAN` (neverForLocation)
- [ ] На Android 11 и ниже — legacy разрешения `BLUETOOTH` + `BLUETOOTH_ADMIN` работают

#### Известные ограничения (не баги)
- **BLE advertising не реализован** — устройство не рекламирует себя в BLE. Соседи не обнаружат твоё устройство, пока не реализован peripheral-режим (TODO: platform channel). Основной путь обмена — QR.
- **GATT-обмен не реализован** — кнопка "Connect" у BLE-устройства открывает QR-сканер (это задуманное поведение до реализации GATT-сервера).

---

---

### ? — Privacy Policy — designed

#### Concept

App Store и Google Play оба **требуют** ссылку на Privacy Policy при публикации (особенно если приложение собирает любые данные или имеет health-интеграцию).

Хостинг на GitHub в виде Markdown-файла — стандартная практика для инди-приложений. Apple и Google принимают любой публично доступный URL.

#### Что писать в политике

Ключевые тезисы для CaliDay:
- Все данные хранятся **локально** на устройстве (Hive)
- Никаких серверов, никакой передачи данных третьим сторонам
- Health-данные (Apple Health / Google Health Connect) — только read/write на устройстве, не передаются
- Камера — только для сканирования QR, фото не сохраняются
- Bluetooth — только для обнаружения устройств в локальной сети, ничего не отправляется в интернет

#### Реализация

1. Создать `PRIVACY_POLICY.md` в репозитории (в корне или `/docs/`)
2. Включить GitHub Pages для repo ИЛИ использовать raw-ссылку: `https://raw.githubusercontent.com/...`
   - Лучше GitHub Pages (`https://username.github.io/caliday/privacy`) — выглядит профессиональнее
   - raw-ссылка тоже принимается обоими сторонами
3. Добавить ссылку в `AboutScreen` (уже есть `url_launcher`)
4. Добавить ссылку в метаданные App Store Connect и Google Play Console при публикации

#### Technical Tasks

| # | Task |
|---|------|
| 1 | Написать `PRIVACY_POLICY.md` (EN + RU секции или отдельные файлы) |
| 2 | Настроить GitHub Pages или использовать raw URL |
| 3 | Добавить `privacyPolicyUrl` константу в `about_screen.dart` |
| 4 | Добавить плашку «Privacy Policy» в `AboutScreen` рядом с существующими ссылками |

#### When to tackle

До первой публикации в App Store / Google Play. Блокирует публикацию.

---

### "Support the Author" Button — idea

IAP via StoreKit 2 (iOS) and Google Play Billing (Android).
Package: `in_app_purchase` (official Flutter).

Products (consumable):
- `tip_small` — ~99₽ / $0.99
- `tip_medium` — ~249₽ / $2.99
- `tip_large` — ~499₽ / $4.99

Placement: Settings → About.
To be tackled after the first real release.

#### ⚠️ Tax / Legal Prerequisite (Germany)

Before implementing, the author must resolve the legal/tax setup for receiving income.
Key points for Germany (discussed 2026-03-23, not a substitute for professional advice):

- **Gewerbe registration** — file Gewerbeanmeldung at local Ordnungsamt (~€26).
  Finanzamt will send a tax questionnaire (Fragebogen zur steuerlichen Erfassung) → get Steuernummer.
- **Kleinunternehmerregelung** — if annual revenue < €25 000, no VAT obligations.
  Apple/Google already act as marketplace facilitators and remit EU VAT themselves.
- **Income tax (Einkommensteuer)** — profit (revenue − expenses) added to personal income.
  Tax-free up to ~€12 000/year (Grundfreibetrag), then progressive 14–45%.
  Filed annually via Einkommensteuererklärung (deadline: July 31 of following year).
- **Gewerbesteuer** — only applies above ~€24 500 profit/year; unlikely at launch.
- **Deductible expenses**: Apple/Google developer fees, hardware, courses, Steuerberater fees.
- **Recommendation**: consult a Steuerberater before publishing paid features.

---

### Lottie Animations for Core Branch — waiting for designer assets

6 animations (core_s1..s6). Format: Lottie JSON in `assets/animations/`.
Integration is analogous to the Push branch — `Exercise.animationPath` already exists.

---

### v2.0 — Design Overhaul: Liquid Glass (iOS) / Frosted Glass (Android) — designed

#### Concept

A full visual refresh of the app to modernize the feel and align with platform design languages.
On iOS: adopt Apple's **Liquid Glass** aesthetic introduced in iOS 26 / WWDC 2025 —
translucent, dynamic, blurred-background surfaces with refraction-like depth.
On Android: a **frosted / opaque glass** variant inspired by Material You — blurred panels
with solid tint instead of full transparency, since Android lacks the system-level blur
compositor that makes iOS Liquid Glass feel native.

The mascot Goro and the color palette (#4DA6FF blue, #FF9500 energy orange) are preserved —
they become anchors of brand identity on top of the new surfaces.

#### UX / Mechanics

**Overall direction:**
- Replace flat `surfaceContainerHighest` cards with glass panels (blur + subtle border + gradient overlay)
- Navigation bar: glass bar floating above content with blur bleed
- App bar: transparent or ultra-thin glass, title large + collapsed state
- Home screen: Goro on a blurred/gradient background, stat widgets as glass chips
- Workout screen: dark immersive with glass overlay for set counter
- Profile: rank card becomes a premium glass hero block
- Modals / bottom sheets: deep glass with strong blur

**iOS (Liquid Glass — full):**
- Use `BackdropFilter(filter: ImageFilter.blur(...))` + semi-transparent `Container` on top of content
- Target: native feel matching iOS 26 system UI
- `ClipRRect` + frosted overlay with `Color(0xFFFFFFFF).withOpacity(0.12–0.18)` for light mode;
  `Color(0xFF000000).withOpacity(0.25–0.35)` for dark mode
- Subtle white border (1px, opacity ~0.3) around glass panels
- Animated shimmer / refraction on hero elements (rank card, streak) — optional, phase 2

**Android (Frosted / opaque glass):**
- Same `BackdropFilter` blur but with higher opacity overlay (~0.55–0.65) so blur is secondary
  and legibility is primary — avoids Android's inconsistent blur compositor across OEMs
- Result: "tinted frosted" look rather than see-through glass
- Fallback: if `BackdropFilter` performance is poor on low-end devices, drop blur entirely
  and use elevated opaque surface with glass-style border + gradient

**Platform branching in theme:**
- `AppTheme` gains `isLiquidGlass` flag derived from `Platform.isIOS`
- All glass widgets accept an `opacity` and `blurStrength` param so iOS/Android values differ
- No conditional platform checks inside individual widgets — handled by theme tokens

#### Technical Tasks

| # | Task |
|---|------|
| 1 | Create `GlassCard` widget: `BackdropFilter` + blur + tint overlay + rounded border |
| 2 | Create `GlassNavBar` / `GlassAppBar` replacements |
| 3 | Define glass theme tokens in `AppTheme`: `glassOpacityLight/Dark`, `glassBlurStrength`, `glassBorderColor` — with iOS/Android presets |
| 4 | Audit and rebuild `HomeScreen` with glass chips for streak/SP widgets |
| 5 | Rebuild `_RankCard` as glass hero block |
| 6 | Rebuild `_StatsGrid` cells as glass tiles |
| 7 | Rebuild `WorkoutScreen` set counter overlay |
| 8 | Rebuild all bottom sheets / modals with glass treatment |
| 9 | Rebuild `SummaryScreen` with glass stat cards |
| 10 | Performance pass: measure frame rate on mid-range Android; tune or disable blur if needed |
| 11 | Design review: test light + dark mode on real devices (iPhone + Android) |

#### Technical Details

- Key Flutter APIs: `BackdropFilter`, `ImageFilter.blur(sigmaX, sigmaY)`, `ClipRRect`
- `BackdropFilter` requires the widget tree below it to be rendered — wrap screen backgrounds
  in `Stack` with a blurred layer on top
- iOS: `sigmaX/Y = 20–30` feels native; Android: `10–15` with higher overlay opacity
- Goro SVGs sit above glass layers — no changes to mascot assets
- Color palette unchanged; glass tint uses existing `primary` with low alpha
- This is a **breaking visual change** — ship as a dedicated release (v2.0), not incremental

#### When to tackle

After v1.4 milestones are complete and the app is stable in markets.
Requires a design prototype pass (Figma or in-code) before full implementation.
iOS Liquid Glass APIs should be confirmed stable in Flutter before starting.

---

## Change History

### 2026-04-07 — v1.7 Custom Workouts

**What was done:** Implemented full Custom Workouts feature. Users can build named routines from any exercises in the catalog, save them to Hive, and run them anytime. Quick Routine allows tapping a focus tag to get an auto-selected 4–6 exercise set immediately. Both flows run as bonus workouts (isPrimary = false, ×0.5 SP, no progression). Secondary "Custom Workout" button added to HomeScreen. "My Routines" section added to LibraryScreen above the Exercise Catalog button.

**New files:**
- `lib/data/models/custom_routine.dart` — `CustomRoutine` Hive model (typeId=11), fields id/name/exerciseIds/createdAt/lastRunAt
- `lib/data/models/custom_routine.g.dart` — generated Hive adapter
- `lib/data/repositories/custom_routine_repository.dart` — `CustomRoutineRepository` + `CustomRoutinesNotifier` (StateNotifier) + `customRoutinesProvider`
- `lib/features/library/screens/custom_routine_builder_screen.dart` — routine builder with exercise checklist, tag filter chips, Save + Start Now buttons

**Modified files:**
- `lib/main.dart` — registered `CustomRoutineAdapter`, opened `custom_routines` Hive box
- `lib/domain/services/workout_generator_service.dart` — added `fromExerciseIds(List<String> ids) → WorkoutPlan`
- `lib/features/workout/providers/workout_provider.dart` — added `customWorkoutPlanProvider`, integrated into `_buildPlan` and `_finishWorkout`; custom workouts always use `isPrimary = false` and `courseIdIndex = null`
- `lib/core/router/app_router.dart` — `/library/routine-builder` nested route
- `lib/features/library/screens/library_screen.dart` — `_MyRoutinesSection` with `_RoutineCard`, `_QuickRoutineSheet`; imports for new providers
- `lib/features/home/screens/home_screen.dart` — `_CustomWorkoutButton` + `_HomeCustomSheet` (tag picker)
- `l10n/app_en.arb`, `l10n/app_ru.arb` — 15 new keys (`customWorkout*`)
- `lib/features/friends/screens/friends_screen.dart` — fixed pre-existing parse error: `?action` (null-aware element syntax)

**Key issues and solutions:**
- `customWorkoutPlanProvider` must be read (not watched) in `_finishWorkout` because the notifier auto-disposes the workout screen after completion — reading it before resetting correctly captures the "was this a custom workout?" flag.
- `fromExerciseIds` uses `ExerciseCatalog.byId` with fallback to `libraryAll` because `byId` searches `all` (a `const` list) which doesn't include `coreS4FlutterKicks`.
- hive_generator rejected Dart 3.8 `?action` null-aware element syntax (valid in the analyzer, but the hive_generator's parser is older) — had to temporarily use `if (action != null) action!` for the build, then revert.

---

### 2026-04-07 — Exercise Library: colored tag chips

**What was done:** Added `ExerciseTag.color` getter to `ExerciseTagExtension` (in `enums.dart`). Applied tag colors consistently: FilterChips in the filter row now show each tag's color (tinted background + colored border + white text when selected); `_TagChip` in the detail sheet now uses colored tinted background + border + colored text. Removed the duplicate `_tagColor()` method from `_TagDots`.

**Modified files:**
- `lib/data/models/enums.dart` — added `Color get color` to `ExerciseTagExtension`
- `lib/features/library/screens/exercise_library_screen.dart` — FilterChip uses `tag.color`; removed `_tagColor()` method
- `lib/features/library/widgets/exercise_detail_sheet.dart` — `_TagChip` uses `tag.color`; removed `scheme` param

---

### 2026-04-07 — v1.6 Exercise Library (Tags + Search)

**What was done:** Implemented the full Exercise Library feature. A searchable, filterable catalog of all progression exercises, accessible via a gradient button at the bottom of the Library tab. Exercises display with Lottie animations, branch badges, and tag chips. Tapping an exercise opens a detail sheet with animation, technique tip, and semantic tags.

**New files:**
- `lib/data/static/exercise_tags_catalog.dart` — static map of exercise ID → `List<ExerciseTag>` (kept separate from exercise_catalog.dart to avoid touching 1500-line file)
- `lib/features/library/providers/exercise_library_provider.dart` — `ExerciseLibraryNotifier` (search + tag filter, autoDispose)
- `lib/features/library/widgets/exercise_detail_sheet.dart` — `ExerciseDetailSheet` bottom sheet with Lottie animation, tags, tip
- `lib/features/library/screens/exercise_library_screen.dart` — 2-column grid with search field + horizontally scrollable FilterChip row

**Modified files:**
- `lib/data/models/enums.dart` — added `ExerciseTag` enum (17 values) + `ExerciseTagExtension.localizedName`
- `lib/data/models/exercise.dart` — added `tags: List<ExerciseTag>` field (default `const []`)
- `lib/data/static/exercise_catalog.dart` — added `libraryAll` getter (all progression exercises incl. `coreS4FlutterKicks`)
- `lib/l10n/app_localizations*.dart` — 23 new keys (library UI + 17 tag names)
- `lib/core/router/app_router.dart` — `/library/exercises` nested route
- `lib/features/library/screens/library_screen.dart` — gradient "Exercise Catalog" button at the bottom

**Key issues and solutions:**
- Tags are NOT stored in `exercise_catalog.dart` inline — would require editing 50+ const Exercise declarations. Instead a separate `ExerciseTagsCatalog` maps exercise IDs to tag lists. The `Exercise.tags` field exists but defaults to `const []`; the library uses `ExerciseTagsCatalog.forId(id)` for filtering.
- `coreS4FlutterKicks` is not in `ExerciseCatalog.all` (it's an alternative, not a main progression entry) — added explicit `libraryAll` getter that includes it.
- Tag filter uses AND logic: all selected tags must be present.
- **l10n Edit tool bug**: The Edit tool reports success when editing large l10n files (>2000 lines) but does NOT write changes to disk. Workaround: use Python `python3 -c` or a heredoc script to do string replacement (`content.replace(old, new)` + `open(path, 'w')`). This affected `app_localizations.dart`, `app_localizations_ru.dart`, and `app_localizations_en.dart`.

### 2026-04-07 — Fix: branch progress is shared across courses

**What was done:** Fixed a bug where branches that appear in multiple courses (e.g., Flex in Calisthenics and Healthy Body) showed independent progress instead of shared progress. Branches represent physical skills and their progress must be global.

**Modified files:**
- `lib/data/repositories/skill_progress_repository.dart` — removed `course` param from all methods; key is now `branch.name` only; migration converts legacy course-scoped keys back to bare keys
- `lib/main.dart` — updated migration call from `migrateToCourseScopedKeys` to `runMigrations`
- `lib/domain/services/workout_generator_service.dart` — removed `course:` param from `getProgress`
- `lib/features/home/providers/home_provider.dart` — removed `course:` param from `getProgress`
- `lib/features/library/screens/library_screen.dart` — removed `course:` param from `getProgress`
- `lib/features/workout/providers/workout_provider.dart` — removed `course:` params from `getProgress` / `saveProgress`
- `lib/features/onboarding/providers/onboarding_provider.dart` — removed `course:` params from `saveProgress`

**Key issues and solutions:** The previous multi-course implementation (v1.5) introduced course-scoped Hive keys (`calisthenics_flex`, `healthyBody_flex`) which caused the same branch to show different progress in different courses. The correct model: branches are physical skills, so `SkillProgress` is keyed by branch name only. `runMigrations()` handles both old bare keys (pre-v1.5) and course-scoped keys (v1.5) — converging everything to bare keys.

### 2026-04-06 — Multi-Course System v1.5 (Calisthenics + Healthy Body)

**What was done:** Implemented the full multi-course system. Added `CourseId` enum (typeId 10), `posture` and `neck` BranchId values (HiveField 6/7), course-scoped SkillProgress keys (`${courseId}_${branchId}`), Library tab replacing Progress tab, updated onboarding with course selection, and new exercise catalog entries for posture (6 stages) and neck (5 stages) branches.

**New files:**
- `lib/data/static/course_catalog.dart` — `CourseCatalog.branchesFor(CourseId)`
- `lib/features/library/screens/library_screen.dart` — Library tab: course pills, branch progress cards, challenge cards

**Modified files:**
- `lib/data/models/enums.dart` — `CourseId` enum + `CourseIdExtension`; `BranchId` gains `posture`/`neck` values; `BranchIdExtension` updated for all 8 branches
- `lib/data/models/enums.g.dart` — manually updated: BranchIdAdapter cases 6/7; new CourseIdAdapter (typeId 10)
- `lib/data/models/user_profile.dart` — `@HiveField(24) activeCourseIds`, `@HiveField(25) activeCourseIndex`; computed `enrolledCourses`, `activeCourse`, `branchesForCourse()`
- `lib/data/models/user_profile.g.dart` — manually updated writeByte 20→22; fields 24/25 added
- `lib/data/models/workout_log.dart` — `@HiveField(6) courseIdIndex`
- `lib/data/models/workout_log.g.dart` — manually updated writeByte 6→7; field 6 added
- `lib/data/repositories/skill_progress_repository.dart` — course-scoped key `_key(branch, course)`; all methods accept `{CourseId course}`; `migrateToCourseScopedKeys()`
- `lib/data/static/exercise_catalog.dart` — posture (6) + neck (5) exercises + `warmupNeckRolls`; updated `progressionFor`, `warmupFor`, `cooldownsFor`
- `lib/domain/services/workout_generator_service.dart` — `generateDailyForCourse()` method
- `lib/features/home/providers/home_provider.dart` — `activeCourseProvider`; `HomeData` includes `activeCourse`
- `lib/features/workout/providers/workout_provider.dart` — reads `activeCourseProvider`, calls `generateDailyForCourse`, saves `courseIdIndex` in WorkoutLog
- `lib/features/onboarding/providers/onboarding_provider.dart` — replaced `FitnessGoal` with `selectedCourseIds`; added course-scoped init
- `lib/features/onboarding/screens/onboarding_screen.dart` — `_CourseStep` replaces `_GoalStep`
- `lib/core/router/app_router.dart` — `/library` route + `navLibrary` label replaces `/progress`
- `lib/core/extensions/exercise_l10n.dart` — posture/neck exercise keys added
- `l10n/app_ru.arb` + `l10n/app_en.arb` — all new keys: navLibrary, libraryTitle, courseNameCalisthenics/healthyBody, onboardingQ4Courses, homeBranchPosture/Neck, all posture/neck exercise keys
- `lib/main.dart` — `CourseIdAdapter` registration; `migrateToCourseScopedKeys()` call
- `lib/domain/services/achievement_service.dart` — posture/neck branch cases added (no-op)
- `lib/features/settings/screens/developer_options_screen.dart` — posture/neck in branch switch expressions

**Key issues and solutions:**
- **SkillProgress key migration:** old keys were bare branch names (`"push"`); new keys are course-scoped (`"calisthenics_push"`). Migration runs at startup (idempotent: skips already-migrated keys). Flex is special — mapped to `"calisthenics_flex"` since it's part of the Calisthenics course.
- **exercise_l10n.dart vs ARB key mismatch:** The previous session wrote `exercise_l10n.dart` with exercise IDs based on the catalog (`posture_s2_dead_bug` → `exercisePostureS2DeadBugName`), but I initially added wrong ARB keys (`exercisePostureS2GluteRaiseName`). Fixed by aligning ARB keys to match catalog IDs.
- **`homeDataProvider` undefined:** `workout_provider.dart` imported only `activeCourseProvider` via `show`. Fixed by adding `homeDataProvider` to the `show` clause.
- **CourseIdAdapter registration:** `CourseId` is a new Hive type (typeId 10) — must be registered before any box is opened. Added to `main.dart` adapter chain.

### 2026-04-06 — Lottie animations: Legs warmup/cooldown accessories (Block E complete)

**What was done:** Integrated 4 new Lottie animations for Legs branch accessories: `warmup_leg_swings`, `warmup_hip_circles`, `cooldown_quad_stretch`, `cooldown_hip_flexor`. Added `warmupHipCircles` and `cooldownHipFlexor` as new exercises in the catalog; added `animationPath` to existing `warmupLegSwings` and `cooldownQuadStretch`. Updated warmup/cooldown routing: Legs now uses `warmupHipCircles` as its warmup (Flex keeps `warmupLegSwings`), and gets two cooldowns `[cooldownQuadStretch, cooldownHipFlexor]`. Updated designer TZ to v1.8 — Block E fully closed, Block F (Balance) is next priority.

**New files:**
- `assets/animations/warmup_leg_swings.json` — leg swings warmup animation
- `assets/animations/warmup_hip_circles.json` — hip circles warmup animation
- `assets/animations/cooldown_quad_stretch.json` — quad stretch cooldown animation
- `assets/animations/cooldown_hip_flexor.json` — hip flexor stretch cooldown animation

**Modified files:**
- `lib/data/static/exercise_catalog.dart` — added `warmupHipCircles` + `cooldownHipFlexor` exercises; added `animationPath` to `warmupLegSwings` + `cooldownQuadStretch`; updated `warmupFor(legs)` → `warmupHipCircles`; updated `cooldownsFor(legs)` → two cooldowns
- `lib/generated/assets.dart` — already registered (auto)
- `docs/tz_designer.md` — bumped to v1.8, Block E marked complete, Block F set as first priority

---

### 2026-04-05 — Lottie animations: Legs s5 (pistol free) + updated existing animation files

**What was done:** Added `legs_s5_pistol_free.json` animation for the free pistol squat (Legs Stage 5) and wired it to `legsS5Pistol` in the exercise catalog. Also updated content of several previously stubbed animation files: `core_s6_dragon_flag`, `legs_s1–s3`, and all six Pull branch animations (`pull_s1–s6`).

**New files:**
- `assets/animations/legs_s5_pistol_free.json` — free pistol squat animation (Legs S5)

**Modified files:**
- `lib/data/static/exercise_catalog.dart` — added `animationPath` to `legsS5Pistol`
- `lib/generated/assets.dart` — registered `legs_s5_pistol_free` asset
- `assets/animations/core_s6_dragon_flag.json` — updated animation content
- `assets/animations/legs_s1_squat.json`, `legs_s2_lunge.json`, `legs_s3_bulgarian.json` — updated animation content
- `assets/animations/pull_s1_australian.json` through `pull_s6_one_arm.json` — updated animation content

---

### 2026-04-04 — Legs branch Lottie animations (s1–s4) + version bump to 1.4.0 + spacing tweak

**What was done:** Added Lottie animation files for Legs branch stages 1–4 (squat, lunge, bulgarian split squat, assisted pistol squat). Updated `pubspec.yaml` version to `1.4.0+5` and set a proper app description. Also increased spacing between the exercise animation and the "set X of Y" label in the workout screen.

**New files:**
- `assets/animations/legs_s1_squat.json`
- `assets/animations/legs_s2_lunge.json`
- `assets/animations/legs_s3_bulgarian.json`
- `assets/animations/legs_s4_pistol.json`

**Modified files:**
- `lib/data/static/exercise_catalog.dart` — added `animationPath` to `legsS1Squat`, `legsS2Lunge`, `legsS3Bulgarian`, `legsS4AssistedPistol`
- `lib/generated/assets.dart` — added `legsS1Squat`, `legsS2Lunge`, `legsS3Bulgarian`, `legsS4Pistol` entries
- `pubspec.yaml` — version `1.1.0+2` → `1.4.0+5`, updated description
- `lib/features/workout/screens/workout_screen.dart` — added `SizedBox(height: 16)` between Lottie animation and set indicator label

**Key issues and solutions:** `legs_s4_pistol.json` is named after the exercise shape (pistol squat), not the exact exercise id (`legs_s4_assisted_pistol`). This is intentional — the animation shows the pistol movement pattern used in both the assisted and full versions.

---

### 2026-03-28 — Lottie animations: cooldown_lat_stretch + core_s4_flutter_kicks

**What was done:** Added animationPath to `cooldownLatStretch` and `coreS4FlutterKicks`. Blocks B and D are now fully covered with Lottie animations. Updated designer TZ to v1.6 reflecting closed blocks.

**New files:**
- `assets/animations/cooldown_lat_stretch.json` — cooldown animation for Pull branch
- `assets/animations/core_s4_flutter_kicks.json` — flutter kicks (Core S4 equipment-free alternative)

**Modified files:**
- `lib/data/static/exercise_catalog.dart` — added animationPath to cooldownLatStretch and coreS4FlutterKicks
- `docs/tz_designer.md` — updated to v1.6: blocks B and D marked complete, next priority is E (Legs)

### 2026-03-27 — Core S4 equipment-free alternative + streak real-work fix

**What was done:** Added flutter kicks (`core_s4_flutter_kicks`) as an equipment-free alternative for Core S4 (hanging leg raises require a pull-up bar). Users without a bar now get flutter kicks instead. Also fixed streak logic: streak no longer increments for warmup-only or all-zero-reps workouts — at least one real exercise (stage > 0, reps > 0 or duration > 0) is required.

**Modified files:**
- `lib/data/static/exercise_catalog.dart` — added `coreS4FlutterKicks`, `requiresEquipment: true` on `coreS4HangingLegRaise`, added `equipmentFreeForStage()` method
- `lib/domain/services/workout_generator_service.dart` — added `hasPullUpBar` param to `generateDaily`; picks equipment-free alternative when user has no bar
- `lib/features/workout/providers/workout_provider.dart` — passes `hasPullUpBar` to generator; added `_hasRealWork()` guard before `streakService.applyWorkout()`

**Key issues and solutions:**
- Flutter kicks are at stage 4 but easier than hanging leg raises. Compensated by higher rep counts (start 10, target 25 vs 3→10 for hanging). `SkillProgress.currentReps` still tracks progression normally since the alternative shares the same stage slot — no Hive changes needed.
- `equipmentFreeForStage()` method keeps the generator logic simple: returns alternative only for the specific branch+stage pair, null otherwise. Easy to extend for future equipment alternatives.

### 2026-03-27 — Pull branch + warmup_dead_hang Lottie animations

**What was done:** Added animationPath to all 6 Pull branch exercises (s1–s6) and warmup_dead_hang. Pull branch now has full Lottie coverage. Animation JSON files were provided by the designer and registered in generated/assets.dart.

**Modified files:**
- `lib/data/static/exercise_catalog.dart` — added animationPath to pullS1Australian, pullS2Negative, pullS3Pullup, pullS4CloseGrip, pullS5Archer, pullS6OneArm, warmupDeadHang

**New files:**
- `assets/animations/pull_s1_australian.json`
- `assets/animations/pull_s2_negative.json`
- `assets/animations/pull_s3_pullup.json`
- `assets/animations/pull_s4_close_grip.json`
- `assets/animations/pull_s5_archer.json`
- `assets/animations/pull_s6_one_arm.json`
- `assets/animations/warmup_dead_hang.json`

---

### 2026-03-26 — Core branch Lottie animations s4–s6

**What was done:** Added animationPath to Core branch exercises s4 (Hanging Leg Raise), s5 (L-sit), and s6 (Dragon Flag). All 6 Core stages now have Lottie animations. Animation JSON files were already present in assets/animations/.

**Modified files:**
- `lib/data/static/exercise_catalog.dart` — added animationPath to coreS4HangingLegRaise, coreS5LSit, coreS6DragonFlag

---

### 2026-03-23 — BLE Peripheral + GATT Server for Friends

**What was done:** Implemented full BLE Peripheral role so that a device running CaliDay advertises itself and serves its profile over GATT, enabling other nearby users to add friends without QR scanning. The "Connect" button on Nearby tiles now attempts a GATT read first and falls back to QR only if the remote has no GATT server.

**New files:** none

**Modified files:**
- `pubspec.yaml` — added `ble_peripheral: ^2.4.0`
- `lib/core/services/ble_service.dart` — replaced stubs: `startAdvertising(profileJson, displayName)` initializes `BlePeripheral`, registers service UUID + READ characteristic, sets read callback, starts advertising; `stopAdvertising()` stops and clears services; `readProfileJson` now returns `Map<String,dynamic>` (decoded JSON) instead of `{'_raw':…}`
- `lib/data/models/friend_profile.dart` — added `fromBleJson()` factory (alias for `fromQrJson`, same JSON structure)
- `lib/features/friends/screens/friends_screen.dart` — `initState` calls `_startAdvertising()`; `dispose` calls `stopAdvertising()`; Nearby tile "Connect" calls `_connectViaBle()` which tries GATT, adds friend on success, falls back to QR on failure; `_buildQrPayload` refactored to use shared `_buildProfileJson()`

**Key issues and solutions:**
- `ble_peripheral` name conflict: the package exports a class also named `BleService`. Resolved by importing the package with prefix `blep` (`import 'package:ble_peripheral/ble_peripheral.dart' as blep`).
- Published version is `2.4.0`, not `0.3.x` as listed in DEV_NOTES — version constraint updated accordingly.
- `ReadRequestCallback` in v2.x is synchronous: `ReadRequestResult? Function(String deviceId, String characteristicId, int offset, Uint8List? value)` — no `async` allowed in the callback.

---

### 2026-03-23 — Fix scheduled notifications (Android) + Core Lottie animations s1–s3

**What was done:** Fixed scheduled notifications never firing on Android by adding missing `flutter_local_notifications` receivers to AndroidManifest. Added `USE_EXACT_ALARM` permission. Integrated Lottie animations for Core branch stages 1–3.

**Modified files:**
- `android/app/src/main/AndroidManifest.xml` — added `ScheduledNotificationReceiver`, `ScheduledNotificationBootReceiver`, `ActionBroadcastReceiver`; added `USE_EXACT_ALARM` permission
- `lib/data/static/exercise_catalog.dart` — added `animationPath` to `coreS1Crunches`, `coreS2Plank`, `coreS3LyingLegRaise`

**New files:**
- `assets/animations/core_s1_crunches.json` — Lottie animation for Core s1
- `assets/animations/core_s2_plank.json` — Lottie animation for Core s2
- `assets/animations/core_s3_lying_leg_raise.json` — Lottie animation for Core s3

**Key issues and solutions:** In `flutter_local_notifications` v17+, the plugin stopped auto-merging its BroadcastReceivers into the app manifest. Without `ScheduledNotificationReceiver`, AlarmManager fired alarms into the void — no notification was ever shown. Instant (test) notifications worked fine because they bypass AlarmManager entirely. Fixed by explicitly declaring all three receivers in the app's `AndroidManifest.xml`. Also added `USE_EXACT_ALARM` (auto-granted on Android 13+) alongside `SCHEDULE_EXACT_ALARM` so exact alarms work without requiring manual user action in system settings.

### 2026-03-23 — Flexibility branch + Supplementary pool + Profile stat tooltips

**What was done:** Added a new BranchId.flex (Flexibility & Mobility, 6 stages of timed/reps stretching), a supplementary exercise pool injected into bonus workouts (2 random picks), and tappable stat chips on the Profile screen that show bottom-sheet explanations.

**New files:**
- `lib/data/static/supplementary_exercise_catalog.dart` — 9 supplementary exercises (obliques, calves, neck, wrists, core stability)

**Modified files:**
- `lib/data/models/enums.dart` — added `BranchId.flex` (@HiveField 5), updated all BranchIdExtension switches
- `lib/data/models/user_profile.dart` — added `BranchId.flex` to `activeBranches`
- `lib/data/static/exercise_catalog.dart` — 6 flex exercises + flexProgression list + updated progressionFor/forStage/warmupFor/cooldownsFor/all
- `lib/core/extensions/exercise_l10n.dart` — added flex + supp exercise ID mappings
- `lib/domain/services/workout_generator_service.dart` — added `isPrimary` param; bonus workouts get 2 random supp exercises
- `lib/features/workout/providers/workout_provider.dart` — `_buildPlan` computes `isPrimary` from repo and passes to generator
- `lib/features/profile/screens/profile_screen.dart` — `_StatCell` and `_RankCard` now accept `onTap`; `_showStatSheet` helper added
- `lib/data/repositories/skill_progress_repository.dart` — added `BranchId.flex` default progress
- `lib/domain/services/achievement_service.dart` — added `BranchId.flex` switch case
- `lib/features/settings/screens/developer_options_screen.dart` — added flex to `_maxStage` / `_branchLabel`
- `l10n/app_en.arb`, `l10n/app_ru.arb` — flex branch name, 6 flex exercises, 9 supp exercises, 5 tooltip strings

**Key issues and solutions:**
- `activeBranches` in `UserProfile` lists branches explicitly — flex was missing, so the branch never appeared in Progress tab. Fixed by adding `BranchId.flex` to the list.
- `_` used as builder parameter name and then referenced in `Theme.of(_)` fails in Dart 3 (discard identifier). Fixed by renaming to `sheetCtx`.
- `build_runner` reported error in `friends_screen.dart:283` (`?action` syntax) — pre-existing bug unrelated to this session; Hive adapter for `BranchId.flex` was still generated correctly.

---

### 2026-03-23 — Onboarding redesign + bugfixes

**What was done:** Replaced the useless "fitness frequency" step with a name input step and a Health integration opt-in step. Fixed a `TextEditingController` use-after-dispose crash in the settings name editor. Fixed a 1.2px RenderFlex overflow in the Home hero stats row.

**Modified files:**
- `lib/features/onboarding/providers/onboarding_provider.dart` — removed `FitnessFrequency` enum and state field; added `displayName` (String) and `healthEnabled` (bool); `lastStep` 6→7; `completeOnboarding` now saves `displayName` + requests Health permissions when opted in
- `lib/features/onboarding/screens/onboarding_screen.dart` — replaced `_FrequencyStep` with `_NameStep` (TextField, step 1) and `_HealthStep` (opt-in step, step 6); updated `_StepScaffold` with optional `body` subtitle; removed `FitnessFrequencyL10n` extension; updated reminder step to `onboardingQ7`
- `l10n/app_en.arb` / `l10n/app_ru.arb` — added `onboardingQ1Hint`, `onboardingQ1Body`, `onboardingQ6Health`, `onboardingHealthBody/Enable/EnableDesc/Skip/SkipDesc`, `onboardingQ7`; removed unused `onboardingQ1` (frequency)
- `lib/features/settings/screens/settings_screen.dart` — removed `controller.dispose()` after `showDialog` in `_showNameEditor` to prevent use-after-dispose crash during closing animation
- `lib/features/home/screens/home_screen.dart` — wrapped each `_HeroStat` in `Expanded` to fix 1.2px overflow on narrow screens

**Key issues and solutions:**
- `TextEditingController` disposed while dialog closing animation was still running → removed explicit `dispose()` call; inline controllers created for one-off dialogs are GC'd when they go out of scope.
- `fitnessFrequency` was collected in onboarding but never written to `UserProfile` → removed entirely.

### 2026-03-23 — Design polish (AppTheme, Home hero zone, Profile stats) + fix mobile_scanner Xcode 26 build

**What was done:** Added `AppTheme` brand token class; redesigned Home screen with gradient hero zone and energetic CTA button; updated Profile stats with orange streak cell and larger display numbers; upgraded `mobile_scanner` 5.x→7.x to fix iOS simulator build failure on Xcode 26.

**New files:**
- `lib/core/theme/app_theme.dart` — brand color tokens, shadow helpers, gradient constants, `ThemeData` factory for light/dark

**Modified files:**
- `lib/main.dart` — replaced inline `ThemeData` with `AppTheme.light` / `AppTheme.dark`
- `lib/features/home/screens/home_screen.dart` — gradient `_HeroZone`, redesigned stat chips, green done-banner, gradient CTA button
- `lib/features/profile/screens/profile_screen.dart` — `_RankCard` with gradient bg; `_StatCell` with 26sp display numbers and orange streak highlight
- `pubspec.yaml` — `mobile_scanner: ^5.2.3` → `^7.2.0`
- `ios/Podfile` — removed obsolete `EXCLUDED_ARCHS[sdk=iphonesimulator*]` workaround
- `ios/Podfile.lock` — updated after pod install

**Key issues and solutions:**
- `CardTheme` vs `CardThemeData`: Flutter renamed the type; using `CardTheme` in `ThemeData.cardTheme` caused a type error → fixed with `CardThemeData`.
- Xcode 26 simulator build failure: `MLImage.framework` (pulled in by `mobile_scanner 5.x` → `GoogleMLKit`) ships only iOS-device arm64 slices; Xcode 26 treats `EXCLUDED_ARCHS` arm64 exclusion as a hard violation. Upgrading to `mobile_scanner 7.x` dropped the `GoogleMLKit` dependency entirely — `MLImage` is no longer in the pod graph, build failure resolved.

### 2026-03-23 — Docs: tax note for IAP feature + English-only convention

**What was done:** Added a tax/legal prerequisite block to the "Support the Author" IAP spec (Germany: Gewerbe, Kleinunternehmerregelung, Einkommensteuer). Updated skills and backlog with a warning to resolve this before implementing the feature. Established English-only rule for all project documentation.

**Modified files:**
- `docs/DEV_NOTES.md` — added Tax / Legal Prerequisite section under "Support the Author"
- `docs/ARCHITECTURE.md` — added ⚠️ note to IAP backlog entry
- `.claude/skills/implement-feature/SKILL.md` — added English-only rule
- `.claude/skills/document-idea/SKILL.md` — added English-only rule

### 2026-03-22 — v1.4 Friends feature (QR + BLE)

**What was done:** Implemented full Friends feature — QR code profile sharing, QR scanning, BLE device discovery, friends list with detail view, friends count in Profile, display name + BLE discoverability in Settings. No server required; all data is local and exchanged peer-to-peer in person.

**New files:**
- `lib/data/models/friend_profile.dart` — `FriendProfile` HiveObject (typeId=9), `fromQrJson` factory
- `lib/data/models/friend_profile.g.dart` — generated Hive adapter
- `lib/data/repositories/friend_repository.dart` — Hive box `'friends'`, keyed by friend.id
- `lib/core/services/ble_service.dart` — BLE Central: scan, GATT read; advertising is a stub (TODO: platform channel)
- `lib/features/friends/providers/friends_provider.dart` — `FriendsNotifier`, `friendsCountProvider`
- `lib/features/friends/screens/friends_screen.dart` — main screen: QR button, BLE nearby, friends list
- `lib/features/friends/screens/qr_scan_screen.dart` — camera QR scanner with confirmation dialog
- `lib/features/friends/widgets/friend_detail_bottom_sheet.dart` — stats + delete confirmation

**Modified files:**
- `pubspec.yaml` — `qr_flutter ^4.1.0`, `mobile_scanner ^5.2.3`, `flutter_blue_plus ^1.35.3`
- `lib/data/models/user_profile.dart` — `@HiveField(23) bool? bleDiscoverable` (peerId @17 and displayName @18 were already present)
- `lib/data/models/user_profile.g.dart` — adapter regenerated
- `lib/features/settings/providers/settings_provider.dart` — `displayName`, `bleDiscoverable` fields + setters
- `lib/features/settings/screens/settings_screen.dart` — FRIENDS section (display name editor + discoverable toggle)
- `lib/features/profile/screens/profile_screen.dart` — Friends section with count and navigation
- `lib/core/router/app_router.dart` — `/friends` route
- `lib/main.dart` — `FriendProfileAdapter` registered, `'friends'` box opened
- `l10n/app_en.arb`, `l10n/app_ru.arb` — 32 new strings for Friends + Settings FRIENDS section
- `ios/Runner/Info.plist` — `NSBluetoothAlwaysUsageDescription`, `NSCameraUsageDescription`
- `android/app/src/main/AndroidManifest.xml` — BLE + CAMERA permissions

**Key issues and solutions:**
1. **BLE advertising not possible via flutter_blue_plus** — the package is Central-only (scanner + GATT client). Peripheral role (advertising) requires a dedicated package or a native platform channel. Advertising is stubbed as empty methods with a TODO comment.
2. **`use_build_context_synchronously`** — after `await addOrUpdate()` in `_openScanner()`, context could be stale. Fixed by capturing `ScaffoldMessenger.of(context)` and `context.l10n` into local variables before the first await.
3. **`advName` vs deprecated `localName`** — `flutter_blue_plus` deprecated `advertisementData.localName`; use `advName` instead.

---

### 2026-03-22 — iOS Widget Extension + bug fixes + doc translations

**What was done:** Registered CaliDayWidget as a proper Xcode target (it existed as Swift code but was never linked to the project). Fixed two state refresh bugs on the home screen. Translated two Russian docs to English.

**New files:**
- `ios/CaliDayWidget/CaliDayWidget.entitlements` — App Group entitlement for the widget
- `ios/CaliDayWidget/Info.plist` — explicit plist (auto-generation failed on simulator)
- `ios/add_widget_target.rb` — one-time script: added CaliDayWidget target via xcodeproj gem
- `ios/fix_widget_*.rb` — follow-up fix scripts (product name, paths, phase order, plist)

**Modified files:**
- `ios/Runner.xcodeproj/project.pbxproj` — CaliDayWidget target added: sources, assets, embed phase, target dependency
- `ios/Runner/Runner.entitlements` — removed `com.apple.developer.healthkit.access` (empty array caused "Personal team does not support Verifiable Health Records" error)
- `ios/CaliDayWidget/CaliDayWidget.swift` — iOS 14 compatibility: `containerBackground` wrapped in `@available`, `#Preview` → `PreviewProvider`, `Date.now` → `Date()`, dark color passed to `containerBackground` to remove white system border
- `lib/features/settings/providers/settings_provider.dart` — `setHasPullUpBar` now invalidates `homeDataProvider` (Pull branch appeared only after restart)
- `lib/features/workout/providers/workout_provider.dart` — added `_ref.invalidate(displayStreakProvider)` before other invalidations (streak showed stale value after workout because `goroExpressionProvider` kept `displayStreakProvider` alive)
- `docs/CaliDay_Design_Document.md` — translated to English
- `docs/design-concept/caliday_design_concept.md` — translated to English; corrected outdated note about GoroExpressionProvider (it IS integrated)

**Key issues and solutions:**
1. **Build cycle** (`Cycle inside Runner`): "Embed Foundation Extensions" phase was placed after CocoaPods' "Thin Binary" script. Thin Binary scans the entire `Runner.app` including PlugIns, creating a circular dependency. Fix: moved embed phase to index 0 (before all script phases).
2. **`ios/ios/` doubled path**: xcodeproj script created the file group with path `ios/CaliDayWidget` but the project is already inside `ios/`, so Xcode resolved it as `ios/ios/...`. Fixed by stripping the `ios/` prefix from the group path.
3. **`Invalid placeholder attributes`** on simulator: auto-generated Info.plist (`GENERATE_INFOPLIST_FILE = YES`) produced a plist missing `CFBundleExecutable`. Fixed by switching to an explicit `Info.plist` with all required keys including `CFBundleExecutable = $(EXECUTABLE_NAME)`.
4. **Stale streak after workout**: `displayStreakProvider` is `Provider.autoDispose` but stays alive because `goroExpressionProvider` watches it. When `homeDataProvider` was invalidated and re-read, `ref.read(displayStreakProvider)` returned the cached old value. Fix: invalidate `displayStreakProvider` first, then `homeDataProvider`.
5. **White border on widget (iOS 17+)**: Was using `.containerBackground(.fill.tertiary, for: .widget)` — system tertiary fill shows as white. Fix: pass `widgetBackground` (our dark color) directly to `containerBackground`.

---

### 2026-03-22 — iOS HealthKit fix: entitlement + wrong activity type

**Fixed two bugs that silently prevented Health data from being written on iOS.**

**Modified files:**
- `ios/Runner/Runner.entitlements` — created; added `com.apple.developer.healthkit` entitlement + App Group
- `ios/Runner.xcodeproj/project.pbxproj` — added `CODE_SIGN_ENTITLEMENTS = Runner/Runner.entitlements` to all 3 build configs (Debug/Profile/Release)
- `ios/Podfile` — uncommented and set `platform :ios, '14.0'` (health package requires iOS 14+)
- `lib/core/services/health_service.dart` — changed `STRENGTH_TRAINING` → `TRADITIONAL_STRENGTH_TRAINING`

**Key issues and solutions:**
1. **Missing entitlement** — `HealthKit` permission dialog never appeared because the app lacked `com.apple.developer.healthkit` entitlement. The entitlements file didn't exist at all; created it and linked via `CODE_SIGN_ENTITLEMENTS` in pbxproj.
2. **Wrong activity type** — `HealthWorkoutActivityType.STRENGTH_TRAINING` is Android-only in health 12.x. On iOS it throws `HealthException("not supported on iOS")` which was silently caught by `catch (_) { return false; }`. Fix: use `TRADITIONAL_STRENGTH_TRAINING` (`HKWorkoutActivityTypeTraditionalStrengthTraining`).

---

### 2026-03-21 — English-first migration + documentation restructure

**Made English the primary language across all project docs and app localization.**

**What was done:**
- `l10n.yaml`: `template-arb-file` changed to `app_en.arb`, `preferred-supported-locales` changed to `[en, ru]`
- `l10n/app_en.arb`: rewritten as full template with all `@key` metadata blocks (14 placeholder blocks previously only in `app_ru.arb`)
- `README.md`: rewritten in English, updated to reflect v1.3 feature state
- `CLAUDE.md`: translated to English
- `docs/ARCHITECTURE.md`, `docs/DEV_NOTES.md`: translated to English
- `.claude/skills/pre-commit/`, `implement-feature/`, `document-idea/`: skills translated to English, moved from `.claude/commands/` to `.claude/skills/` (Anthropic Agent Skills standard)

**Documentation structure split:**
- `docs/ARCHITECTURE.md` — stable architecture reference (tech stack, Hive typeIds, service APIs, navigation, design system, code style, feature backlog)
- `docs/DEV_NOTES.md` — living notes: current status, active feature specs, session history

**Key technical note:** `app_en.arb` is now the l10n template. Russian ARB (`app_ru.arb`) has 6 untranslated strings (new exercises added in session 31) that fall back to English in Russian locale — intentional.

**Modified files:** `l10n.yaml`, `l10n/app_en.arb`, `README.md`, `CLAUDE.md`, `docs/ARCHITECTURE.md`, `docs/DEV_NOTES.md`, `.claude/skills/*/SKILL.md`

---

### 2026-03-05 — session 39 (Health Integration: HealthKit / Health Connect)

**Implemented integration with Apple Health (iOS) and Google Health Connect (Android).**
After a workout is completed, CaliDay writes a strength training session + calories (MET formula).
Opt-in via Settings → HEALTH.

**New files:**
- `lib/core/services/health_service.dart` — `HealthService` singleton

**Modified files:**
- `pubspec.yaml` — `health: ^12.0.0`
- `lib/data/models/user_profile.dart` — `@HiveField(21) healthWorkoutsEnabled`, `@HiveField(22) healthWeightEnabled`
- `lib/data/models/user_profile.g.dart` — adapter updated
- `lib/features/settings/providers/settings_provider.dart` — new fields + setters
- `lib/features/settings/screens/settings_screen.dart` — HEALTH section
- `lib/features/workout/providers/workout_provider.dart` — `healthSaved: bool` + HealthService call
- `lib/features/workout/screens/workout_screen.dart` — `healthSaved` in extras
- `lib/features/workout/screens/summary_screen.dart` — `_HealthSavedBadge`
- `lib/main.dart` — `HealthService.instance.configure()` in postFrameCallback
- `ios/Runner/Info.plist` — NSHealth*UsageDescription
- `android/app/src/main/AndroidManifest.xml` — Health Connect permissions, queries, activity-alias
- `android/app/build.gradle.kts` — `minSdk = 26`
- `android/app/src/main/kotlin/.../MainActivity.kt` — `FlutterActivity` → `FlutterFragmentActivity`
- `l10n/app_ru.arb`, `l10n/app_en.arb` — 6 new strings

**Key issues:**
- `MainActivity` must extend `FlutterFragmentActivity` (→`ComponentActivity`), otherwise `HealthPlugin.onAttachedToActivity` crashes with `ClassCastException`
- `configure()` is wrapped in `.timeout(5s)` — without the timeout it hangs on the splash screen on subsequent launches
- `activity-alias` with `HEALTH_PERMISSIONS` is required for the Health Connect permissions dialog
- iOS: the HealthKit capability must be added manually in Xcode

---

### 2026-03-05 — session 38b (Medium 4×2 widget)

**Added a second widget: 4×2. Layout: Goro on the left + streak + SP + status on the right.**

**New files:**
- `android/.../res/xml/caliday_widget_medium_info.xml`
- `android/.../res/layout/caliday_widget_medium_layout.xml`
- `android/.../kotlin/.../CaliDayWidgetMediumReceiver.kt`

**Modified files:**
- `android/.../AndroidManifest.xml` — medium receiver
- `lib/core/services/widget_service.dart` — `_androidNameMedium`, `update()` calls both widgets, `rankLabel()` helper
- `ios/CaliDayWidget/CaliDayWidget.swift` — `CaliDaySmallView`, `CaliDayMediumView`, dispatcher by `@Environment(\.widgetFamily)`

**Issue:** `HomeWidget.updateWidget(androidName: qualifiedName)` was adding packageName twice → `ClassNotFoundException`. Fix: use `qualifiedAndroidName:` instead of `androidName:`.

---

### 2026-03-05 — session 38 (Android widget: Glance → AppWidgetProvider)

**Fixed Android widget runtime crash. Glance → classic AppWidgetProvider + RemoteViews.**

**Problem:** `NoSuchMethodError: No static method provideContent(GlanceAppWidget, Function0, Continuation)`.
**Cause:** Flutter does not include the Compose Compiler Plugin (`buildFeatures.compose = false`), so the lambda is generated as `Function0` instead of `Function2<Composer, Int, Unit>`.
**Fix:** `AppWidgetProvider` + XML layout — does not require Compose.

Additional fixes:
- `GoException: no routes for location: caliday://workout/` → guard in RouterNotifier redirect
- `GoError: There is nothing to pop` → `context.canPop() ? context.pop() : context.go('/home')`

---

### 2026-03-05 — session 37 (Home Screen Widget: Flutter + Android + iOS)

**Implemented Home Screen Widget Small (2×2): Goro (idle/flex) + streak + SP. Tap → `caliday://workout`.**

**New dependencies:** `home_widget: ^0.9.0`, `app_links: ^6.4.1`

**New files:**
- `lib/core/services/widget_service.dart`
- `android/.../CaliDayWidgetReceiver.kt`
- `android/.../res/xml/caliday_widget_info.xml`
- `android/.../res/layout/caliday_widget_layout.xml`
- `android/.../res/drawable/ic_widget_fire.xml`, `ic_widget_bolt.xml`
- `ios/CaliDayWidget/CaliDayWidget.swift`
- PNG assets: goro_idle/flex in drawable-* and iOS xcassets

**Modified files:**
- `pubspec.yaml` — `home_widget`, `app_links`
- `lib/main.dart` — WidgetService.init() + AppLinks deep link stream
- `lib/features/workout/providers/workout_provider.dart` — WidgetService.update() after workout
- `android/.../AndroidManifest.xml` — deep link intent-filter, widget receiver
- `ios/Runner/Info.plist` — CFBundleURLTypes scheme `caliday`

iOS: requires manual setup in Xcode (Widget Extension target + App Group).

---

### 2026-03-04 — session 36 (info banner on Progress + emoji → Material Icons replacement)

**1.** Hint card at the top of the Progress tab: branches are optional.
**2.** Replaced emoji with Material Icons throughout the UI. `BranchId.icon` getter added to `enums.dart`.

**Modified files:** `l10n/app_ru.arb`, `l10n/app_en.arb`, `lib/data/models/enums.dart`,
`home_screen.dart`, `progress_screen.dart`, `branch_journey_screen.dart`,
`profile_screen.dart`, `achievements_screen.dart`, `summary_screen.dart`,
`workout_screen.dart`, `settings_screen.dart`

---

### 2026-03-04 — session 35 (Android haptics, timer, history, Home redesign)

**1. Haptics fix** — `VIBRATE` permission in AndroidManifest.

**2. Timer** — increased to 5 seconds (was 3). Tick when `timerSec ∈ [2..6]`, also for timed exercises.

**3. Workout history** — tiles became tappable; modal bottom sheet with details (exercises, reps).

**4. Home redesign** — `StatefulShellRoute.indexedStack`, 3 tabs: Workout / Progress / Profile.
Created `progress_screen.dart`. Home simplified to a hero block with Goro.

**Issue:** `profileDataProvider` (autoDispose) was not being invalidated with `indexedStack` — all tabs stay alive.
Fix: `_ref.invalidate(profileDataProvider)` added to `_finishWorkout()`.

**Modified files:**
- `android/.../AndroidManifest.xml` — VIBRATE
- `lib/features/workout/screens/workout_screen.dart`
- `lib/core/services/sound_service.dart`
- `lib/features/profile/screens/profile_screen.dart`
- `lib/core/router/app_router.dart` — StatefulShellRoute.indexedStack
- `lib/features/home/screens/progress_screen.dart` (new)
- `lib/features/home/screens/home_screen.dart`
- `lib/features/workout/providers/workout_provider.dart`
- `l10n/app_ru.arb`, `l10n/app_en.arb`

---

### 2026-03-03 — session 31 (Lottie animations for Push + progression refactor)

**Integrated Lottie animations for all 7 Push stages.**

**Push catalog aligned with assets:**
- Stage 5: Archer Pushup → **Wide Pushup** (`push_s5_wide_pushup`)
- Stage 6: One-Arm Pushup → **Archer Pushup** (`push_s6_archer_pushup`)

**New dependencies:** `lottie: ^3.3.2`
**New assets:** `assets/animations/` (7 JSON files)
**Model field:** `Exercise.animationPath: String?`

**Modified files:**
- `pubspec.yaml`, `lib/data/models/exercise.dart`
- `lib/data/static/exercise_catalog.dart` — Push s5/s6 + animationPath
- `lib/core/extensions/exercise_l10n.dart` — new IDs
- `l10n/app_ru.arb`, `l10n/app_en.arb`
- `lib/features/workout/screens/workout_screen.dart` — Lottie widget

---

### Early Sessions (summary, before session 30)

**Sessions 18-30** — implemented as part of v1.1 and v1.2:
- Achievements (27 total): `AchievementRepository`, `AchievementService`, `achievement_catalog.dart`, `AchievementsScreen`
- Bonus workouts: `WorkoutLog.isPrimary`, `@HiveField(5)`
- Dark theme: `themeProvider`, `UserProfile.themeModeName (@HiveField(14))`
- Goro expressions: `GoroExpressionProvider`, 6 SVG, `AnimatedSwitcher` on Home
- Skala (bull) on Challenge: `skala_neutral/approve.svg`, `_SkalaDisplay`, background `#5C1A1A`
- Challenge redesign: `challengeBranchProvider`, `generateChallenge()`, fail/success split
- Forced Challenge from BranchJourney: button on the current stage
- New branches: Pull (requiresEquipment), Legs, Balance; `activeBranches` computed getter
- Onboarding step 5 (pull-up bar), Settings: Pull branch toggle
- `displayStreakProvider` — computed on the fly without mutating Hive
- Streak loss notification (ID 4)
- Sound + haptics: `SoundService` singleton, `audioplayers ^6.1.0`, 4 assets
- `DeveloperOptionsScreen` (`/dev-options`, debug-only `kDebugMode`)
- `AboutScreen` (`/about`): `url_launcher ^6.3.0`, Goro idle v2
- `BranchJourneyScreen` (`/branch/:branchId`): stage timeline
- Android release build: `keep.xml` + `proguard-rules.pro` + `postFrameCallback` init
- Streak freezes: earned every 7 days, auto-spent on missing 1 day, cap=3
- L10n (RU + EN): ~145 keys
- `StatefulShellRoute.indexedStack`: bottom nav with 3 tabs