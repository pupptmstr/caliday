# Screens, navigation and design

> Part of the project notes — the index is [internal_docs/README.md](../README.md).

## Navigation

### Bottom nav (StatefulShellRoute.indexedStack)
- `/home` — Workout (HomeScreen)
- `/library` — Library (LibraryScreen: course pills + branch progress + challenge cards)
- `/profile` — Profile (ProfileScreen)

### Top-level routes (no bottom nav)
- `/onboarding` — onboarding (redirect if profile exists)
- `/workout` — workout session
- `/summary` — results
- `/branch/:branchId` — branch progression journey, by `Branch.key` (a built-in name or `custom_<id>`)
- `/achievements` — all achievements
- `/calendar` — workout calendar heatmap (month grid + day-detail sheet)
- `/settings` — settings
- `/whats-new` — "What's new": the history of what changed in each version (bell in the Profile app bar, with a dot while an entry is unseen)
- `/about` — about the app
- `/dev-options` — devtools (`kDebugMode` only)

### Library sub-routes (nested under `/library`)
- `/library/exercises` — Exercise Library (search + tag filter)
- `/library/routine-builder` — Custom Routine Builder; pass `CustomRoutine` via `extra` for edit mode
- `/library/course-builder` — the course builder; `extra` = `CustomCourse` to edit (from "Edit" above an own course's branches). Saving selects the course
- `/library/branch-builder` — the branch builder; `extra` = `CustomBranch` to edit; pops with the saved branch (the course builder ticks a new one)

## RouterNotifier
- `isOnboardingCompleteProvider` — `NotifierProvider<OnboardingGateNotifier, bool>`, initialized from `userRepository.hasProfile`
- Redirect logic lives in `appRedirect()` (`core/router/app_redirect.dart`, pure, tested): before onboarding is done everything (deep links too) goes to `/onboarding`; afterwards a `treniday://…` link goes where `deepLinkTarget` says — `workout` (Today widget) → `/workout`, `home` (Goro widget) → `/home`, `calendar` (Streak widget) → `/calendar`, `profile` (Rank widget) → `/profile`, `friend…` (a friend QR code of a build before 0.9.5, opened by the system camera) → `/home`, anything else → `/workout`; the `app_links` listener in `main.dart` uses the same function. The calendar opened straight from a widget has nothing to pop, so its back button goes to the Profile. A finished onboarding is never shown again

## Onboarding (8 steps)

| Step | Content |
|------|---------|
| 0 | Welcome — Goro + description; the language menu (a chip with the current code, top right) lists every language of `appLanguages` |
| 1 | Name (optional) |
| 2 | How many push-ups can you do? (Push calibration) |
| 3 | How big should a workout be? Short / Standard / Full (→ `preferredWorkoutMinutes` as the code 5 / 10 / 15, see § Workout size) |
| 4 | Choose course(s) — multi-select cards (Calisthenics / Healthy Body) |
| 5 | Do you have a pull-up bar? (only shown if calisthenics selected; → `hasPullUpBar`) |
| 6 | Health integration (opt-in) |
| 7 | What time should we remind you? |

**Web:** `OnboardingState.lastStep = kIsWeb ? 5 : 7` — Health and reminder steps are the last two, so the web build simply ends at step 5 (no reindexing).

**Push calibration:** 0 reps → s1 r3; 1–5 → s2 r5; 5–15 → s3 r5; 15+ → s3 r10 sets=2

**Course initialization on completion:**
- Calisthenics selected: push (calibrated) + core s1 + legs s1 + balance s1 + pull s1 (if hasPullUpBar)
- Healthy Body selected: posture s1 + neck s1
- Evening Stretch selected: its four branches at stage 1 (`SkillProgressRepository` defaults = the stage-1 exercise's own start values)

## Home: the middle and the plan (0.9.4, owner 2026-10-10)
The hero zone (host, streak, SP, rank) is unchanged. Below it a scrollable middle and two buttons:
- **Before the first workout of the day** (`HomeBeforeWorkout`): the host's line (a speech bubble whose tail points up at the host in the hero — no second portrait, owner), and above it, when the user gave a name, a greeting by the part of the day (0.9.5: "Good morning, Anna!" / "Hi" / "Good evening" / "Still up?" — `HomeDigest.dayPartOf(hour)`: morning 5–11, day 12–17, evening 18–22, night 23–4; `HostLineCard.greetingFor`, `greeting<Part>` in the ARB files): **each host speaks in its own voice, four lines per mood** (owner: one line hanging on the screen gets annoying; different for different hosts) — `hostLines<Host><Mood>` in the ARB files, one line per text line (`HostLineCard.linesFor`), moods happy / sad / angry / supportive / sleeping; another line each time Home is built anew, when the app comes back and on a tap of the bubble, never the same twice in a row (`HomeDigest.nextLine`, the last one per host and mood kept for the run); a test checks four lines per host and mood in every language, none repeated within a host, ≤ 80 characters; an unlocked challenge as a card with the next stage's animation, its norm, Skala and "Accept challenge" (starts it like the Courses tab); "Next goals" — SP to the next rank with a bar (`HomeDigest.nextRank`) and the nearest streak or workout-count achievement (`nearestAchievement`, "3 more days"); the course's branches with the current stage's animation, stage x/y and the stage bar (`ProgressionService.stageFraction`, shared with the Courses tab). A host may speak of itself in its own gender (Luna and Aurora are she, Goro, Raffi and Miso he); the user is never gendered in any language.
- **After it** (`HomeAfterWorkout`): the last three workouts (`WorkoutLogTile(compact: true)`: "Today, 08:40", no tags) with "See all" (the history sheet of the SP chip), then "Progress today" — `HomeDigest.growthOn(today)` from `WorkoutLog.growth`: "Push 10 → 12 reps", "2 → 3 sets", "rest 60 → 45 s", "the challenge is open", "new stage: …". Logs from before 0.9.4 have no growth.
- **The workout button** (`WorkoutPlanButton`): a narrow arrow strip at its right end (52 px, owner: "not half the button") unfolds the plan that will run (`todayPlanProvider`) above the label, each exercise with its animation, the amount ("3 × 12", "2 × 30 s each side") and a tap to its sheet; always folded when Home opens and after a start (owner); its height is bounded by the free space (`LayoutBuilder`, the list scrolls). The done state ("Again") folds the bonus plan the same way. The old "Workout done" banner is gone (history and growth say it).

## Exercise animations wherever an exercise is named (0.9.4)
`ExerciseThumb(exercise, size)` (`features/library/widgets/exercise_thumb.dart`): Goro's animation in a rounded tile, a tap opens the exercise sheet (`tappable: false` inside a row with its own action). The 400 × 400 canvases leave the figure small in the lower part, so each file is cropped to its figure: `kAnimationCrops` (`data/static/animation_crops.dart`, generated by `tools/lottie/thumb_crops.py` — lottie-web in headless Chrome, 12 frames, the box of what is drawn without rows painted across > 70 % of the width (floors), made a square with 12 % air, at least 180 px, centred even past the canvas edge). A test fails while a file has no square — run the script after adding or redrawing an animation. In the dark theme the tile is a shade lighter than the cards so Goro's dark fur shows. Used on Home (plan, branches, challenge, growth), the Branch Journey stages (`ThumbRow`, locked stages faded), the Courses tab (branch and challenge cards), the routine and branch builders (pickers and stages), saved routines, the workout history sheet, the rest before the next exercise (120 px) and the summary of a passed challenge. Compositions are cached by the lottie package.

## What's new (release notes)
The bell in the Profile app bar opens `/whats-new`: the history of what changed in each version, newest first, in the user's words. **The app has no backend, so this is the history of the versions the installed build contains, not a notice that a newer one exists** (that would need a network check, e.g. the GitHub Releases API, and is not done).

- **Content:** `ReleaseNotesCatalog.all` (`data/static/release_notes_catalog.dart`): `ReleaseNote(version, date, text: (l10n) => …)`. The text is one ARB string, `releaseNotes<version without dots>`, one change per line; an entry without both languages does not compile. The detailed entries start at 0.8.10, when "What's new" came.
- **What the screen shows (owner, 2026-10-09):** "Recent updates" — the newest `recentCount` (6) entries in full, every entry stays in the catalog; under them "Version history", folded until tapped: one card per minor line (`ReleaseNotesCatalog.lines`, `ReleaseLine(version: '0.8', from, to, text)`, ARB `releaseHistory<major><minor>`), 0.9 … 0.1, its main points as dots and its span of months ("May – October 2026"). The lines before 0.8.10 were written from git history and DEV_NOTES; versions before 2026-04-22 were numbered 1.x (1.1 – 1.7 are 0.1 – 0.7; the owner did not want a footnote about it). A new minor version needs its `ReleaseLine` (a test fails without it) and a change worth remembering a point in its line.
- **A rule with a test:** every version bump needs an entry; `test/data/release_notes_catalog_test.dart` fails while the newest entry is not the `pubspec.yaml` version. The step is written into the `implement-feature` and `pre-commit` skills.
- **The dot:** `UserProfile.lastSeenReleaseVersion` (HiveField 26) is the newest version the user opened; `hasUnseenReleaseNotesProvider` is true while an entry is newer (versions compare as numbers: 0.8.10 > 0.8.9). Opening the screen saves the newest version (after the first frame; the NEW tags of that visit stay until it closes). An existing user with null sees every entry as new; a new user is set to the current version by onboarding, so the bell lights up for the next update only.

## Design System

> Full design system (style guide, UX rules, typography, anti-patterns) is in
> `design-system/treniday/MASTER.md`. Page-specific overrides in `design-system/treniday/pages/`.
> **Style:** Vibrant & Block-based — bold, energetic, gamified. No static/flat visuals.

### Mascot Goro
A flat-style gorilla with a blue headband. Assets in `assets/goro/`:
- `goro_face_[happy/sad/angry/sleeping/excited/supportive].svg` — 6 expressions
- `goro_flex_v2.svg` — promo
- `goro_idle_v2.svg` — idle
- `goro_pose_{one_arm_handstand,flag,one_arm_pullup,barbell,lotus,banana}.svg` — fun poses for About (0.9.4)
- `goro_locked.svg` — holding an achievement still ahead (a grey medal with a padlock), like `<host>_locked.svg`

The designer's files (faces, idle, flex) have no source. The poses and `goro_locked` are generated by `tools/characters/gen_goro.py` (edit the script, not the SVGs): a paper doll in the idle's own 1024 frame — the idle's head (with face variants: eyes open / up / closed / happy / wink / squeeze, brows, mouth smile / grin / o / teeth / small) and torso placed by a transform, arms and legs as tapered capsules with the idle's lighter overlay between joints solved by two-bone IK (`Arm.bend` / `Leg.bend` 1 = the elbow or knee out to its own side for a limb hanging down), fists, feet and props (pole, bar, barbell, banana) at the joints; `Pose(scale, anchor)` fits a pose into the tile. The medal is `gen_hosts.locked_badge`, shared with the hosts.

Placement:
- **Home** — AnimatedSwitcher by expression inside gradient hero zone (h=200)
- **Summary** — `goro_flex_v2` (h=120)
- **Profile** — `goro_idle_v2` (h=100)
- **Onboarding welcome** — `goro_face_happy` (h=120)
- **About** — `GoroPoses` (`features/settings/widgets/goro_poses.dart`, h=120): a random one of `kGoroPoses` (the idle and the six fun poses) each time the screen opens, a tap shows the next; the order is shuffled once, so every pose comes up before a repeat (owner, 2026-10-10: "just for fun", e.g. a one-arm handstand)
- **Achievement sheet** — `goro_flex_v2` once earned, `goro_locked` while ahead (the app's own achievements and the Calisthenics branches)

**GoroExpressionProvider logic:**
`sleeping(23–6h)` > `happy(workoutToday)` > `angry(22h+,streak>0)` > `sad(20h+)` > `supportive(daysSince≥2)` > `happy`

### Skala (Bull)
`assets/skala/skala_neutral.svg` + `skala_approve.svg` — shown on WorkoutScreen during the Challenge phase, background `#5C1A1A`. Generated by `tools/characters/gen_skala.py` (redrawn as a real bull in 0.8.20; edit the script, not the SVGs); `test/data/character_svgs_test.dart` decodes every file of `assets/goro` and `assets/skala` with flutter_svg.

### Theme & Color Palette

Brand tokens are centralised in `lib/core/theme/app_theme.dart` (`abstract final class AppTheme`).
`MaterialApp` consumes `AppTheme.light` / `AppTheme.dark` — no inline `ThemeData` in `main.dart`.

| Role | Token | HEX |
|------|-------|-----|
| Primary | `AppTheme.brandBlue` | `#4DA6FF` |
| Primary Dark | `AppTheme.brandBlueDark` | `#2B7DE9` |
| Primary Deep | `AppTheme.brandBlueDeep` | `#1A5FA8` |
| Primary Light (Goro's headband) | — | `#A8D8FF` |
| Energy (streaks) | `AppTheme.energy` | `#FF9500` |
| Success (progress) | `AppTheme.success` | `#34C759` |
| Challenge bg | — | `#5C1A1A` |

Helper constants: `AppTheme.heroGradient`, `AppTheme.rankGradient`, `AppTheme.cardShadowLight/Dark`.

Bottom sheets span the screen up to 640 px (`bottomSheetTheme`, `BoxConstraints.tightFor(width: 640)`, 0.9.6): the Material default only caps the width, so a sheet of short centred lines shrank to its text.

### App Icon
- `assets/icon/icon.png` — 1024×1024 (iOS)
- `assets/icon/icon_foreground.png` — no background (Android adaptive)
- `remove_alpha_ios: true` in `flutter_launcher_icons`
- Notification: `android/app/src/main/res/drawable/ic_goro_notif.xml` (Vector Drawable, white silhouette)

### Emoji Policy
- **UI chrome** → Material Icons in all widgets (consistently replaced)
- `BranchId.icon` getter → `IconData` (in `enums.dart`)
- `BranchId.emoji` — kept for `achievement_catalog.dart` (content)
- Flags in the language pickers (settings dialog, onboarding menu), from `appLanguages` — intentional
- Achievement emojis in tiles — game content, keep as-is
- Toast ✅ — celebratory feedback, keep as-is
