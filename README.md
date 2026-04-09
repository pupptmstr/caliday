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

## Features (v1.7)

- **6 progression branches:** Push, Pull, Core, Legs, Balance, Flex
- **Daily set auto-generation** based on current level and preferred duration
- **Smooth progression:** reps ↑ → sets ↑ → rest ↓ → Challenge test → next stage
- **Gamification:** Strength Points, streaks, ranks, streak freezes, 27 achievements
- **Goro mascot** — gorilla with 6 animated expressions + Lottie exercise animations (all 6 branches)
- **Exercise Library** — browsable catalog of all exercises with tags and filtering
- **Custom Workouts** — Quick Routine (tag-based) and Saved Routines (manual builder)
- **Friends** — peer-to-peer via BLE/QR (no server); share profile, view friend stats
- **Push notifications:** morning reminder, evening nudge, streak threat
- **Dark theme** — follows system or manual override
- **Onboarding survey** for calibrating starting level (8 steps incl. pull-up bar, health)
- **Home screen widget** (iOS + Android): Goro + streak + SP — small (2×2) and medium (4×2)
- **Health integration:** Apple Health (HealthKit) and Google Health Connect — writes strength workout + calories after each session
- **Localization:** English (primary) + Russian
- **100% offline** — no server, all data local (Hive)

## Tech Stack

| Layer              | Technology                  |
|--------------------|-----------------------------|
| Platform           | Flutter (Dart)              |
| State management   | Riverpod                    |
| Local storage      | Hive                        |
| Navigation         | go_router                   |
| Animations         | Lottie                      |
| Notifications      | flutter_local_notifications |
| Target platforms   | iOS (primary), Android      |

## Project Structure

```
lib/
├── main.dart                  # Entry point, Hive init, migrations
├── core/                      # Theme, constants, shared widgets, services
├── data/
│   ├── models/                # Hive models: UserProfile, SkillProgress, WorkoutLog…
│   ├── repositories/          # UserRepository, SkillProgressRepository, WorkoutRepository
│   └── static/                # Exercise catalog (60+ exercises across 6 branches + accessories)
├── domain/
│   ├── models/                # WorkoutPlan, PlannedExercise
│   └── services/              # SPService, StreakService, ProgressionService, WorkoutGeneratorService
└── features/
    ├── onboarding/
    ├── home/
    ├── workout/
    ├── library/               # Exercise Library + Custom Workout builder
    ├── profile/
    ├── settings/
    ├── friends/               # BLE/QR peer-to-peer
    └── achievements/
```

## Quick Start

**Requirements:** Flutter SDK ≥ 3.11, Dart SDK ≥ 3.11

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

## Documentation

- [Architecture](internal_docs/ARCHITECTURE.md) — tech decisions, data models, service APIs, feature backlog
- [Dev Notes](internal_docs/DEV_NOTES.md) — current status, active feature specs, session history

## Roadmap

- **v1.3 ✅:** Home screen widget, Health Connect / HealthKit integration
- **v1.4 ✅:** Friends (BLE/QR peer-to-peer, no server)
- **v1.5 ✅:** Balance branch + Lottie animations
- **v1.6 ✅:** Exercise Library
- **v1.7 ✅:** Custom Workouts (Quick Routine + Saved Routines)
- **Next:** Privacy Policy page, "Support the Author" IAP

## License

© 2026 CaliDay. All rights reserved.
