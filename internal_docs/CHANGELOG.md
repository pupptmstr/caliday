# CaliDay — Changelog

One entry per version, newest first: what changed, what the owner decided, and the problems that were not obvious and how they were solved. What the user reads under the bell is in the ARB files (`releaseNotes<version>`); how things work now is in [reference/](reference/). Since 0.9.0 a version is one session branch, merged into `main` as one squash commit.

> Until 2026-10-12 the history was kept per session in `DEV_NOTES.md` (100+ entries); it was condensed into this file when the notes were reworked (owner: condense, drop the original — it stays in git history before 0.9.7).

---

## 0.9.7 — 2026-10-12 — Widgets with Goro; Flutter 3.47; the notes reworked

Branch `session/2026-10-12-widgets-notes-deps`.

**Home-screen widgets redone** (idea of 2026-10-10; the owner chose the set and the look on an HTML mock-up with Goro's real art: the brand-blue background, a dark ember for the Streak, a new pose every day, a night sky while Goro sleeps): Today (small / medium / large; the day's plan or done, the week, the way to the next rank), Goro (his face by the mood of the day), Streak, Rank; on iOS also four lock-screen widgets (rectangular Today, circular Streak and Rank, the inline line). Each opens its place (`caliday://workout | home | calendar | profile`). See [platform.md § Home-screen widgets](reference/platform.md#home-screen-widgets-097).
- The data is one pure snapshot (`WidgetSnapshot`), every text from the ARB files; the widgets decide by the moment they render with the app's rules mirrored in Swift and Kotlin (done today, the streak after midnight, the mood by the hour, the pose of the day). The old `workoutDoneToday` flag went stale at midnight; now the snapshot carries days.
- Goro's art for the widgets is rendered from the app's SVGs by `tools/characters/export_widget_art.py` (headless Chrome, the tile removed, cropped to the figure). An empty placeholder path (`M0,0`) in the sleeping face pulled the crop box to the corner: the box is measured over visible shapes only.
- iOS: a `WidgetBundle` of four kinds; the old kind `CaliDayWidget` is the Today widget, so a placed widget keeps working. A radial glow with a fixed radius showed a square edge in a smaller frame — it now fades out at the inscribed circle.
- Android: four providers, Today and Rank resizable with a layout per size (`RemoteViews` size map on 12+). `adb` cannot send `APPWIDGET_UPDATE` (protected broadcast), and a force-stopped app shows placeholders; checking states was done through the app (debug options, then leaving the app).
- "Done · +0 SP" for a day without SP became just "Done".

**Flutter 3.41.9 → 3.47.7** (go_router 18 needs Flutter 3.44+), pinned in the three workflows; **major upgrades**: go_router 18, flutter_local_notifications 22, home_widget 0.10, package_info_plus 10, plus minor ones (riverpod 3.4, audioplayers 6.8, app_links 7.2, intl 0.20.3). One deprecation (`SliverReorderableList.onReorder` → `onReorderItem`, which already adjusts the index). intl 0.20.3 (CLDR 47) joins the year and «г.» with a narrow no-break space — a test with the literal failed.
- **Xcode 27 refuses deployment targets below 15**: the app and the widget go to iOS 16, the Podfile raises every pod below it. Flutter 3.47 moved the iOS plugins to Swift Package Manager by itself.
- **HealthKit and the App Group checked in the simulator** (the Health permission sheet, the widget reading what the app writes). A real device needs the owner's Apple ID in Xcode.
- A local Android build needs JDK 17 / 21: Android Studio bundles Java 25, which Gradle 8.14 cannot run, and Flutter prefers it over `JAVA_HOME`.

**The notes reworked** (with the owner: a folder by topic, a changelog by version, English): `ARCHITECTURE.md` and `DEV_NOTES.md` became [README.md](README.md) (index and rules), [STATUS.md](STATUS.md), this file, `reference/` (nine topic files), `decisions/`, `specs/`, `research/`. The session history was condensed here.

**Recorded for later:** performance work on the app as a separate effort (owner) — [specs/performance.md](specs/performance.md).

## 0.9.6 — 2026-10-12 — A sound for every moment; own courses only; full-width sheets

- **Sounds redone** (idea of 2026-10-10): 21 cues synthesised by `tools/sounds/gen_sounds.py` (WAV, one family of timbres in C major), a pure cue chooser over the workout state machine, Settings → Sounds all / key only / off (`UserProfile.soundModeName`, HiveField 28). The owner kept everything as drafted; the countdown has 5 ticks, the last higher.
- **The cues stopped the user's music:** audioplayers' default context asks for audio focus; every player now gets `AudioContextConfig(focus: mixWithOthers)` (on Android the global context only reaches players created after it, so it is set per player).
- **Own courses only:** one ticked course of any kind is enough (before, one built-in course always stayed). `activeCourseIds` may be empty; `enrolledCoursesProvider` falls back to Calisthenics when nothing is left.
- **Bottom sheets span the screen** up to 640 px: Material 3 only caps the width and `BottomSheet` loosens it, so a sheet of short centred lines shrank to its text.
- Haptics: Flutter has only preset impacts; patterns of our own need a package (open idea). iPhone Safari haptics through the hidden switch-checkbox trick were declined by the owner — only real taps tick since iOS 26.5.

## 0.9.5 — 2026-10-11 — Friends removed; the host greets you by name; four branches outside the courses

- **Friends removed** (owner: without a server a one-off QR / Bluetooth swap added little and cost a lot): screens, model, codecs, BLE service, four packages, the camera and Bluetooth permissions, the privacy-policy sections. typeId 9 and UserProfile fields 17 / 23 are retired; the `friends` box is deleted at start-up, not awaited (on the web a database an old tab holds blocks the delete). An old `caliday://friend` link opens Home.
- **The name is used:** a greeting by the part of the day above the host's line on Home, the Profile header, the summary title, Settings → Profile.
- **Strong Back, Glutes, Arms & Shoulders, Cardio** — branches outside every course (BranchId HiveFields 20–23), 22 exercises with animations (`gen_extra.py`), picked in the course builder; `all_complete` counts only the courses' branches. `CourseCatalog.courseOf` threw for a branch no course lists; it returns null (Goro presents those achievements).
- Animation lessons: Goro's proportions (legs 84 px, arms 80 px, torso 100 px) dictated the props (a low sofa, the feet past the door post); the owner allowed other proportions for the pike push-ups (`sc_len`); a leg in line with the body has the angle `br`, not `br + 180`.

## 0.9.4 — 2026-10-10 — The middle of Home; the plan in the workout button; animations everywhere

- **Home** (the owner picked from options A–F on mock-ups): before the first workout the host's line, an open challenge, the next goals, the branches; after it the history and "Progress today". The plan folds into the workout button behind a narrow arrow strip. To show growth, each workout stores how every branch moved (`WorkoutLog.growth`, `BranchGrowth`, typeId 14).
- **Each host speaks in its own voice**, four lines per mood, never the same twice in a row; a host may use its own gender, the user is never gendered.
- **Exercise animations wherever an exercise is named** (`ExerciseThumb`), cropped to the figure by `tools/lottie/thumb_crops.py` (the 400 × 400 canvases leave the figure small; the square may reach past the canvas edge).
- **Owner's feedback on 0.9.3:** own courses in the "+" list (hide / show, edit; `CustomCourse.shown`), an own-course mark on the pill, every host holding a locked medal for an achievement still ahead, Goro's fun poses on About (`gen_goro.py`: the idle's head and torso, IK capsule limbs).
- `main` got a ruleset: PRs only, squash merges only, CI required.

## 0.9.3 — 2026-10-09 — The course builder; "What's new" with the whole history

- **Own courses** from built-in branches (progress shared) and **own branches** made of catalog exercises in the user's order, amounts and norms derived (`CustomStages`). `CourseId` / `BranchId` are Hive enums, so runtime types sit beside them (`Branch`, `Course`, keys `push` / `custom_<id>`); the built-in path keeps its data exactly. `PlannedExercise.branchKey` says which progress an exercise moves (a stage copy keeps its catalog `branch`).
- **"What's new"**: the 6 newest versions in full, a folded history of every minor line 0.1 … 0.9 (versions before 2026-04-22 were numbered 1.x; no footnote, owner).
- Lessons: `SkillProgress extends HiveObject` already has `key` (hence `branchKey`); a `FilledButton` in a `Row` needs its own `minimumSize` (the theme's is infinite width).

## 0.9.2 — 2026-10-09 — The small things; every exercise animated

- The three longest per-side holds halved to 10 → 30 s per side; stored progress above a target is capped at start-up (`runMigrations`).
- The course hosts present the achievements of their branches (`courseOf(branch, active:)` for a shared branch).
- The theme switch: `SegmentedButton` ignores padding on segments with icons (flutter#173944) — the icon moved into the label.
- The pigeon pose from above and 90/90 from the front (legs solved in 3D) — 133 of 133 exercises animated.
- A stale incremental Kotlin build in `build/<plugin>/` reported a plugin's own classes as unresolved: delete that folder, not all of `build/`.

## 0.9.1 — 2026-10-09 — Yoga with Miso the cat

- Standing, Equilibrium, Backbends, Flow and the shared Calisthenics Balance (courses may share branches, owner 2026-10-08); 21 stage exercises, 18 new animations (`gen_yoga.py`: sun salutations as interpolated key poses re-planted by IK every frame); Miso drawn.
- Goro's arm is shorter than his hip-to-shoulder: a hand reaches a foot behind him only with the heel high (dancer, bow searched numerically); lying on the back, a spine bend that lifts the hips is negative.

## 0.9.0 — 2026-10-08 — Morning Routine with Aurora the lark

- Spine, Joints, Arms, Energy — standing, quiet, no jumps; 22 animations (`gen_morning.py`), Aurora drawn (on Luna's template she read as an owl).
- The owner's rule from the review: **never draw a limb segment longer than it is** (an elbow placed at the knee stretched the arm).
- Fast sweeps need angle-driven arms and ≥ 22 frames to stay under the checker's 22 px / frame.

## 0.8.20 — 2026-10-08 — Evening Stretch; holds on each side; a host for every course

- **Evening Stretch** with Luna the owl (Back, Hips, Folds, Shoulders; 19 animations, a seated front view in the rig); a bonus workout of it adds no supplementary exercises.
- **Holds on each side**, hands-free: side 1 → "switch sides" countdown → side 2; the weaker side is the result; SP counts both.
- **Course hosts** (Raffi, Luna; later Aurora and Miso): the active course's host is the face of Home and the Profile; Goro stays the face of the app. **Skala redrawn as a real bull** (a lone digit from the middle of a fist can read as a rude gesture — a rule in BRAND.md).
- Throwaway content tables generate the catalog, ARB keys and lookups together, so ids and languages cannot drift.

## 0.8.19 — 2026-10-07 — Each branch moves on once a day, in any workout

- Owner's rule: a branch progresses at most once per calendar day, on the first successful set of its current stage, in any workout (`ProgressionService.applyDailyResult`, `SkillProgress.lastProgressedOn`). SP and the streak keep their rules. The same gate closed a bug: an exercise of another stage moved the current one.
- Friends stopped carrying branch progress (QR format 3) so a new branch could never break the exchange.

## 0.8.18 — 2026-10-07 — The widget in the app's language

- The widget's "Done" and the iOS gallery text were hard-coded Russian. The app hands over every text (native resources would follow the system language); a test keeps the Swift and Kotlin keys in step. A language change reschedules notifications and refreshes the widget at once.

## 0.8.17 — 2026-10-07 — Numbers agree with their words

- Counted messages became plurals in every language ("1 sets", «5 раза», «1 друзей»); an amount and its unit are one message (`workoutAmountReps(n)`), never a number glued to a separate unit word.

## 0.8.16 — 2026-10-07 — Any number of languages; German and Spanish drafts

- One list of languages (`appLanguages`), `l10nFor` for texts without a context, notification and widget texts moved into the ARB files, tests that loop over every ARB file; `CFBundleLocalizations` declared on iOS. German and Spanish as drafts for native proofreading.
- `no_hardcoded_text_test` failed on Windows (`\` paths); fixed.

## 0.8.10 – 0.8.15 — 2026-10-06 … 07 — Hands-free holds; honest time; "What's new"

- **0.8.15** — the bell in the Profile with "What's new" (`UserProfile.lastSeenReleaseVersion`, a test forces a note for every version bump); the "built with" line removed from About.
- **0.8.14** — the estimate on "Again" too: the bonus workout's supplementary pair is seeded by the day and the count of workouts, so Home and the workout screen build the same plan.
- **0.8.13** — the estimate learns the user's pace: the median of real / estimated over the last 7 workouts, clamped 0.6–1.6 (`WorkoutLog.estimatedDurationSec`).
- **0.8.12** — "Today's workout (≈ N min)" from the real plan; the evening notification no longer promises minutes (a test forbids it).
- **0.8.11** — workout size Short / Standard / Full instead of "5 / 10 / 15 minutes", which was never a duration (the stored code is unchanged).
- **0.8.10** — a get-ready countdown replaces the Start button of timed holds (0.8.9 had added the button; a tap between rest and hold breaks a hands-free workout). Also: hard-coded strings moved to l10n, a guard against hard-coded English, the exercise search in every language.

## 0.8.8 – 0.8.9 — 2026-10-06 — CI; tests; DST

- **CI** on every push and PR (l10n drift, analyze, test, debug Android build); the web deploy waits for the tests; the release workflow drafted and disabled until the store accounts exist.
- **400+ tests** (they found two crashes and two data gaps); plugin-bound decisions extracted into pure functions (`NotificationPlanner` and others).
- **Day arithmetic across DST** was wrong in several places (a local day is 23 / 25 h): everything goes through `core/utils/calendar_days.dart`.
- Challenge norms for the six hardest final stages; the web QR scanner explains camera errors.

## 0.8.0 – 0.8.7 — 2026-05-02 … 10-06 — Calendar, rank decay, the web version, generated animations

- Interactive Home stats (streak → calendar, SP → history, rank → info); a workout calendar with a heatmap.
- Rank decay: display-only, after 21 / 35 / 45 / 53 / 59 days, a warning at 14.
- **The web build** (PWA on GitHub Pages, Hive on IndexedDB, native features guarded by `kIsWeb`), deployed with the legal pages by one workflow.
- **Animations authored in code** (`tools/lottie`: a Goro paper-doll rig with FK / IK, later front, top and back views): Flex, the supplementary pool, Posture, Neck, the cat-cow; the oldest designer files reviewed and Pull / Push s4–s7 redrawn.

## 0.7 (was 1.7) — 2026-04-07 … 09 — Own workouts; the library; legal pages

- Custom routines and the quick routine by focus; the exercise library with tags and search (0.6); the privacy policy and terms of use on GitHub Pages; `docs/` became the public folder, `internal_docs/` the internal one.
- Hive → Hive CE, Riverpod 3 (`Notifier` everywhere), 11 packages upgraded.
- On 2026-04-22 every version was renumbered 1.x → 0.x: v1.0 is the first public release.

## 0.5 (was 1.5) — 2026-04-04 … 06 — Courses

- Calisthenics and Healthy Body (Posture, Neck), the Library tab, course selection in the onboarding; branch progress shared across courses (it was per course at first — a bug, a branch is one skill); Flexibility; the supplementary pool; Legs animations.

## 0.4 (was 1.4) — 2026-03-22 … 28 — Friends (removed in 0.9.5)

- QR and Bluetooth exchange of profiles (the BLE peripheral and GATT server came in March); the onboarding asks the name; HealthKit fixed (the entitlement was missing); the iOS widget target registered in the project; the documentation went English-only.

## 0.3 — 2026-03-05 — Widget and Health

- The first home-screen widget (2×2, then 4×2; Glance crashed without the Compose compiler plugin, so `AppWidgetProvider` + RemoteViews); Apple Health / Health Connect.

## 0.2 — 2026-03-02 … 04 — Sound, history, three tabs

- Sound and haptics, the workout history, the three-tab Home, streak freezes, About.

## 0.1 — 2026-02-25 … 03-01 — The first version

- Short daily workouts with SP, streaks, ranks and reminders; Push, Core, Pull, Legs, Balance with stage progression and the Challenge (Skala); achievements, bonus workouts, the dark theme, Russian and English; Goro's six moods; the first Push animations.
