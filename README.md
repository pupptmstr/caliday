# CaliDay

**Gamified Home Workouts**

CaliDay is a mobile calisthenics app with a progression game mechanic.
It guides the user from absolute zero (wall push-ups) to advanced skills
(handstand push-ups, L-sit, free handstand, dragon flag) through short daily
sets of 5–15 minutes. No equipment required for most branches, no subscriptions, no internet.

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

| Mechanic         | How it works in CaliDay            |
|------------------|------------------------------------|
| Skill / branch   | Muscle group (Push, Pull, Core…)   |
| Session          | Set — 5–15 min workout             |
| Progression map  | Linear stage ladder, easy to hard  |
| Experience points| Strength Points (SP)               |
| Streak           | Consecutive training days          |
| Player levels    | Ranks: Beginner → Legend           |

## Features

- **2 courses, 8 progression branches:** Calisthenics (Push, Pull, Core, Legs, Balance, Flex) and Healthy Body (Posture, Neck, Flex)
- **Daily set auto-generation** based on current level and preferred duration
- **Smooth progression:** reps ↑ → sets ↑ → rest ↓ → Challenge test → next stage
- **Gamification:** Strength Points, streaks, ranks, streak freezes, rank decay after long breaks, 29 achievements
- **Goro mascot** — gorilla with 6 expressions + Lottie animations for 68 of the 70 exercises (no animation, by design: 90/90 hip mobility and the pigeon pose)
- **History:** workout calendar with a heatmap, tappable streak / SP / rank stats on the home screen
- **Web version** — runs in the browser at https://pupptmstr.github.io/caliday/app/ (installable as a PWA); data stays in the browser (IndexedDB). No notifications, Health, widget or BLE on the web
- **Exercise Library** — browsable catalog of all exercises with tags and filtering
- **Custom Workouts** — Quick Routine (tag-based) and Saved Routines (manual builder)
- **Friends** — peer-to-peer via BLE/QR (no server); share profile, view friend stats
- **Notifications:** morning reminder, evening nudge, streak at risk, streak lost, rank at risk
- **Dark theme** — follows system or manual override
- **Onboarding survey** for calibrating starting level (8 steps incl. course choice, pull-up bar, health; 6 on the web)
- **Home screen widget** (iOS + Android): Goro + streak + SP — small (2×2) and medium (4×2)
- **Health integration:** Apple Health (HealthKit) and Google Health Connect — writes strength workout + calories after each session
- **Localization:** English (primary) + Russian
- **100% offline** — no server, all data local (Hive)

## Tech Stack

| Layer              | Technology                  |
|--------------------|-----------------------------|
| Platform           | Flutter (Dart)              |
| State management   | Riverpod 3.x                |
| Local storage      | Hive CE                     |
| Navigation         | go_router                   |
| Animations         | Lottie                      |
| Notifications      | flutter_local_notifications |
| Target platforms   | iOS (primary), Android, Web (PWA) |

## Project Structure

```
lib/
├── main.dart                  # Entry point, Hive init, migrations
├── core/                      # Router, theme, services (notifications, sound, Health, widget, BLE), l10n helpers, DST-safe date utils
├── data/
│   ├── models/                # Hive models: UserProfile, SkillProgress, WorkoutLog, FriendProfile, CustomRoutine…
│   ├── repositories/          # Hive access: user, progress, workouts, achievements, friends, custom routines
│   └── static/                # Catalogs: 70 exercises (8 branches + warm-ups, cool-downs, supplementary), tags, courses, achievements
├── domain/
│   ├── models/                # WorkoutPlan, PlannedExercise
│   └── services/              # SP, streak, rank decay, progression, workout generator, achievements
└── features/
    ├── onboarding/
    ├── home/
    ├── workout/
    ├── library/               # Exercise Library + Custom Workout builder
    ├── profile/               # Profile, achievements, workout calendar
    ├── settings/
    └── friends/               # BLE/QR peer-to-peer

test/                          # 550+ tests: services, catalog integrity, Hive repositories, ARB files, notification plan, QR / BLE payloads, router, workflows
assets/animations/             # Lottie exercise animations (65 files)
assets/goro, assets/skala      # Mascot SVGs
tools/lottie/                  # Generators for the Flex, supplementary, Posture, Neck, Pull, Push and cat-cow animations (+ in-place fixes of designer files), preview page builder
web/                           # Web shell (index.html, manifest, icons); deployed by .github/workflows/web.yml
.github/workflows/             # web.yml (Pages deploy), ci.yml (analyze + test + Android debug build on push / PR), release.yml (release builds, disabled)
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

## Progression Branches

### Push
| Stage | Exercise               | Goal   |
|-------|------------------------|--------|
| 1     | Wall Push-up           | 3×10   |
| 2     | Knee Push-up           | 3×15   |
| 3     | Full Push-up           | 3×20   |
| 4     | Diamond Push-up        | 3×15   |
| 5     | Wide Push-up           | 3×15   |
| 6     | Archer Push-up         | 3×10   |
| 7     | Handstand Push-up      | 3×10   |

### Core
| Stage | Exercise               | Goal      |
|-------|------------------------|-----------|
| 1     | Crunches               | 3×20      |
| 2     | Plank                  | 3×60 sec  |
| 3     | Lying Leg Raises       | 3×15      |
| 4     | Hanging Leg Raises     | 3×10      |
| 5     | L-sit                  | 3×20 sec  |
| 6     | Dragon Flag            | 3×5       |

### Pull *(requires pull-up bar)*
| Stage | Exercise               | Goal   |
|-------|------------------------|--------|
| 1     | Australian Pull-up     | 3×15   |
| 2     | Negative Pull-up       | 3×8    |
| 3     | Pull-up                | 3×10   |
| 4     | Close-Grip Pull-up     | 3×10   |
| 5     | Archer Pull-up         | 3×6    |
| 6     | One-Arm Pull-up        | 3×3    |

### Legs
| Stage | Exercise               | Goal   |
|-------|------------------------|--------|
| 1     | Squat                  | 3×20   |
| 2     | Lunge                  | 3×12   |
| 3     | Bulgarian Split Squat  | 3×10   |
| 4     | Assisted Pistol Squat  | 3×8    |
| 5     | Pistol Squat           | 3×5    |

### Balance
| Stage | Exercise               | Goal      |
|-------|------------------------|-----------|
| 1     | Single-Leg Stand       | 3×60 sec  |
| 2     | One-Arm Plank          | 3×30 sec  |
| 3     | Crow Pose Preparation  | 3×20 sec  |
| 4     | Crow Pose (Kakasana)   | 3×15 sec  |
| 5     | Wall Handstand         | 3×30 sec  |
| 6     | Free Handstand         | 3×30 sec  |

### Flex *(mobility & flexibility)*
| Stage | Exercise                    | Goal      |
|-------|-----------------------------|-----------|
| 1     | Hip Flexor Stretch          | 3×60 sec  |
| 2     | World's Greatest Stretch    | 3×8       |
| 3     | 90/90 Hip Mobility          | 3×60 sec  |
| 4     | Thoracic Bridge             | 3×8       |
| 5     | Deep Squat Hold             | 3×90 sec  |
| 6     | Pike Stretch                | 3×60 sec  |

### Posture *(Healthy Body course)*
| Stage | Exercise                    | Goal      |
|-------|-----------------------------|-----------|
| 1     | Posterior Pelvic Tilt       | 3×30 sec  |
| 2     | Dead Bug                    | 3×10      |
| 3     | Glute Bridge                | 3×20      |
| 4     | Standing Hip March          | 3×20      |
| 5     | Kneeling Hip Flexor Stretch | 2×60 sec  |
| 6     | Pigeon Pose                 | 2×60 sec  |

### Neck *(Healthy Body course)*
| Stage | Exercise                    | Goal      |
|-------|-----------------------------|-----------|
| 1     | Neck Tilts                  | 2×45 sec  |
| 2     | Chest Opener                | 2×45 sec  |
| 3     | Shoulder Circles            | 3×20      |
| 4     | Wall Angels                 | 3×15      |
| 5     | Doorway Pec Stretch         | 2×60 sec  |

## Gamification

**Strength Points (SP)** — awarded for each completed exercise.
+50% bonus for the first workout of the day, +10% for completing the full set.

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

## Documentation

- [Architecture](internal_docs/ARCHITECTURE.md) — tech decisions, data models, service APIs, testing, feature backlog
- [Dev Notes](internal_docs/DEV_NOTES.md) — current status, active feature specs, change history
- [Design system](design-system/caliday/BRAND.md) — brand, mascot, colours, UX rules
- [Privacy Policy](docs/PRIVACY_POLICY.md) · [Terms of Use](docs/TERMS_OF_USE.md)

## Roadmap

- **v0.3 ✅:** Home screen widget, Health Connect / HealthKit
- **v0.4 ✅:** Friends (BLE/QR peer-to-peer, no server)
- **v0.5 ✅:** Multi-course system (Calisthenics + Healthy Body), Balance / Flex / Posture / Neck branches
- **v0.6 ✅:** Exercise Library
- **v0.7 ✅:** Custom Workouts, Privacy Policy and Terms, web version
- **v0.8 ✅:** Workout calendar, interactive stats, rank decay
- **v1.0 (target):** additional courses (Yoga, Morning Routine, Evening Stretch)
- **Ideas:** "Support the Author" IAP, custom course builder

## License

© 2026 CaliDay. All rights reserved.
