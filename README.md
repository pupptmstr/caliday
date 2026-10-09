# CaliDay

**Gamified Home Workouts**

CaliDay is a mobile home-workout app with a progression game mechanic.
It guides the user from absolute zero (wall push-ups, a first plank, a gentle
stretch) to advanced skills (handstand push-ups, L-sit, free handstand, the
wheel) through short daily workouts. Five courses, and courses of your own.
No equipment for most branches, no subscriptions, no ads, no internet, no account.

---

> **Disclaimer**
>
> This project is developed primarily in collaboration with [Claude](https://claude.ai)
> (Anthropic) — an AI assistant that helps design architecture, write code, and
> documentation. All technical decisions are reviewed and approved by a human;
> Claude acts as a co-author, not an autopilot.

---

## Concept

The app is built on proven game-based learning mechanics:

| Mechanic          | How it works in CaliDay                                        |
|-------------------|----------------------------------------------------------------|
| Course            | A set of skill branches with its own host character             |
| Skill / branch    | A ladder of exercises (Push, Pull, Backbends…), easy to hard    |
| Session           | A short daily workout drawn from the course's branches          |
| Experience points | Strength Points (SP)                                            |
| Streak            | Consecutive training days, protected by freezes                 |
| Player levels     | Ranks: Beginner → Legend                                        |

## Courses

| Course | Host | Branches |
|--------|------|----------|
| **Calisthenics** | Goro the gorilla | Push (7 stages), Pull (6, needs a pull-up bar), Core (6), Legs (5), Balance (6), Flexibility (6) |
| **Healthy Body** | Raffi the giraffe | Posture (6), Neck (5), Flexibility (shared) |
| **Evening Stretch** | Luna the owl | Back (5), Hips (5), Folds (4), Shoulders (5) — calm stretching before sleep |
| **Morning Routine** | Aurora the lark | Spine (5), Joints (5), Arms (5), Energy (5) — standing, quiet, no jumps |
| **Yoga** | Miso the cat | Standing poses (5), Equilibrium (5), Backbends (6), Flow (5), Balance (shared) |
| **Your own** | one of the five, your pick | built-in branches (their progress is shared) and branches you make from any exercises in your order |

20 built-in branches with over 100 stages; 133 exercises in total with the
warm-ups, cool-downs and the supplementary set. Progress belongs to the branch,
so a branch shared by two courses moves once for both. The full catalog with
every stage, amount and challenge norm is in [ARCHITECTURE § Exercise Catalog](internal_docs/ARCHITECTURE.md#exercise-catalog).

## Features

- **Smooth progression:** reps ↑ → sets ↑ → rest ↓ → a Challenge (judged by Skala the bull) → the next stage; each branch moves on once a day, in any workout
- **Daily workout generation:** the branches take turns day by day; the size is Short, Standard or Full, and the Home button shows an honest time estimate that learns your pace
- **Hands-free workouts:** timed holds start after a get-ready countdown (pause if you need more time), holds on one side run on both with a switch-sides countdown, sounds and vibration for every phase
- **Course builder:** put a course together from any built-in branches, or make a branch of your own — pick exercises, put them in order, and the app sets the reps, sets, rests and challenges
- **Goro's animations for every exercise** — 126 Lottie files, most of them generated in-house with `tools/lottie`
- **Course hosts:** each course has its host with six moods on Home and in the Profile, cheering on the summary and presenting the course's achievements
- **Gamification:** Strength Points, streaks and freezes, ranks with a display-only decay after long breaks, 41 achievements, bonus workouts
- **History:** a workout calendar with a heatmap, tappable streak / SP / rank stats
- **Exercise library** with search in every language and tag filters; **custom routines** (a quick one by focus, or saved ones)
- **"What's new"** under the bell in the profile: the latest updates in full and the whole version history, folded
- **Friends** — peer-to-peer over QR or Bluetooth (no server): rank, SP and streak
- **Notifications:** morning reminder, evening nudge, streak at risk, streak lost, rank at risk
- **Home screen widget** (iOS + Android): small and medium, in the app's language
- **Health integration:** Apple Health and Health Connect — the workout and its calories, if you want
- **Languages:** English, Russian, German and Spanish (German and Spanish are drafts awaiting native proofreading)
- **Dark theme**, onboarding with a push-up calibration and course choice
- **Web version** at https://pupptmstr.github.io/caliday/app/ (installable as a PWA; data stays in the browser — no notifications, Health, widget or Bluetooth there)
- **100% offline** — no server, all data on the device (Hive)

## Tech Stack

| Layer              | Technology                  |
|--------------------|-----------------------------|
| Platform           | Flutter (Dart)              |
| State management   | Riverpod 3.x                |
| Local storage      | Hive CE                     |
| Navigation         | go_router                   |
| Animations         | Lottie (generated by `tools/lottie`) |
| Notifications      | flutter_local_notifications |
| Target platforms   | iOS (primary), Android, Web (PWA) |

## Project Structure

```
lib/
├── main.dart                  # Entry point, Hive init, migrations
├── core/                      # Router, theme, services (notifications, sound, Health, widget, BLE), l10n helpers, DST-safe date utils
├── data/
│   ├── models/                # Hive models: UserProfile, SkillProgress, WorkoutLog, FriendProfile, CustomRoutine, CustomBranch, CustomCourse…
│   ├── repositories/          # Hive access: user, progress, workouts, achievements, friends, custom routines, own branches and courses
│   └── static/                # Catalogs: exercises, supplementary set, tags, courses, achievements, release notes
├── domain/
│   ├── models/                # WorkoutPlan, Branch / Course (built-in or the user's own)
│   └── services/              # SP, streak, rank decay, progression, workout generator, own-branch stages, achievements, notification plan
└── features/
    ├── onboarding/
    ├── home/                  # Home, Branch Journey
    ├── workout/               # Workout screen, summary
    ├── library/               # Courses tab, exercise library, routine / course / branch builders
    ├── profile/               # Profile, achievements, calendar, "What's new"
    ├── settings/
    └── friends/               # QR / BLE peer-to-peer

test/                          # 1000+ tests: services, catalog integrity, Hive repositories, ARB files, notification plan, QR / BLE payloads, router, workflows
assets/animations/             # Lottie exercise animations (126 files)
assets/goro, assets/skala, assets/hosts   # Mascot, judge and course hosts (SVG)
tools/lottie/                  # Animation rigs and generators (gen_*.py per branch or course), checks, preview stands
tools/characters/              # Generators of Skala and the course hosts
web/                           # Web shell (index.html, manifest, icons); deployed by .github/workflows/web.yml
.github/workflows/             # web.yml (Pages deploy), ci.yml (l10n, analyze, test, Android debug build on push / PR), release.yml (release builds, disabled)
```

## Quick Start

**Requirements:** Flutter 3.41.9 (stable, the version CI uses), Dart ≥ 3.11

```bash
# Install dependencies
flutter pub get

# Generate Hive adapters (required on first clone or after model changes)
dart run build_runner build --delete-conflicting-outputs

# Generate localizations
flutter gen-l10n

# Run
flutter run

# Tests
flutter test

# Linter
flutter analyze
```

## Gamification

**Strength Points (SP)** — awarded for each completed exercise.
+50% for the first workout of the day, +10% for completing every set; a bonus workout the same day earns half.

**Ranks:**

| Rank      | SP      |
|-----------|---------|
| Beginner  | 0       |
| Amateur   | 500     |
| Athlete   | 2,000   |
| Champion  | 5,000   |
| Master    | 15,000  |
| Legend    | 50,000  |

A rank that is not trained for 21 days is *shown* one tier lower (further tiers at 35, 45, 53 and 59 days); the earned rank is never lost and returns with the next workout. A warning notification comes after 14 days.

**Streak freezes:** one every 7 streak days (up to 3); a freeze saves the streak after one missed day.

## Documentation

- [Architecture](internal_docs/ARCHITECTURE.md) — tech decisions, data models, service APIs, the exercise catalog, testing, feature backlog
- [Dev Notes](internal_docs/DEV_NOTES.md) — current status, active feature specs and ideas, change history
- [Design system](design-system/caliday/BRAND.md) — brand, mascot and hosts, colours, UX rules
- [Privacy Policy](docs/PRIVACY_POLICY.md) · [Terms of Use](docs/TERMS_OF_USE.md)

## Roadmap

- **0.1 – 0.7 ✅** (numbered 1.x until April 2026): the first branches and gamification, sound, widget, Health, Friends, courses, the exercise library, custom routines
- **0.8 ✅:** calendar and interactive stats, rank decay, the web version, animations for the exercises of the first courses, the get-ready countdown and holds on each side, workout sizes with a learned estimate, German and Spanish, Evening Stretch and the course hosts
- **0.9 ✅:** Morning Routine, Yoga, an animation for every exercise, the course builder, "What's new" with the whole history
- **Next ideas:** many more exercises and branches outside the courses; sounds redone for every action of a workout; a fuller Home screen (today's plan, today so far, the week); richer native widgets; exercise animations wherever an exercise is named — see [DEV_NOTES § Next ideas](internal_docs/DEV_NOTES.md#next-ideas-owner-2026-10-10--not-ordered-yet-the-owner-picks)
- **v1.0:** the first store release — Friends tested on real phones, store accounts, proofread German and Spanish
- **Later:** "Support the author" (in-app tips)

## License

© 2026 CaliDay. All rights reserved.
