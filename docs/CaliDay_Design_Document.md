# CALIDAY

_Gamified Home Workouts_

**Design Document v1.0** | February 2026

---

## 1. Vision & Overview

CaliDay is a mobile app for home workouts with game-like progression mechanics. The app guides the
user from absolute zero to advanced calisthenics skills through short daily sessions, gradually
increasing difficulty and load.

### 1.1 Core Game Mechanics

| Mechanic          | How it works in CaliDay                                    |
| ----------------- | ---------------------------------------------------------- |
| Skill / Branch    | Muscle group / skill (push-ups, core, balance)             |
| Session           | Set (short workout: 5–15 minutes)                          |
| Progression Stage | Exercise level (knee → full → diamond push-ups)            |
| Streak            | Consecutive days of at least one completed set             |
| XP                | Strength Points (SP)                                       |
| Player Levels     | Ranks (Beginner → Athlete → Master)                        |
| Progression Map   | Exercise tree with stage unlocking                         |

### 1.2 Principles

- **Low barrier to entry:** anyone can start with no experience or equipment
- **Micro-workouts:** a single session takes 5–15 minutes
- **Gradual progression:** load increases smoothly, almost imperceptibly
- **Gamification:** streaks, points, ranks, achievements — all to sustain motivation
- **100% offline:** no server, all data stored locally
- **Free:** no subscriptions, no ads, no purchases

---

## 2. Target Audience

The app targets people who want to start exercising at home but don't know where to begin or struggle
with consistency:

- **Complete beginners** — those who can't yet do a single full push-up
- **Office workers and developers** — sedentary lifestyle, no time for a gym
- **People who need a system and gamification** to stay motivated
- **Those who want to learn calisthenics skills** but don't know the right progression

---

## 3. Core Game Loop

### 3.1 Daily Flow

1. User opens the app (or receives a push notification)
2. Sees the home screen with the progression map and a "Today's Workout" button
3. Taps "Start" — the app shows exercises one by one
4. Each exercise: animation/illustration + timer/rep counter
5. After completion — results screen: SP, streak, progress
6. Optionally: pick an additional set or a free workout

### 3.2 Set (Session) Structure

Each set consists of 3–6 exercises and takes 5–15 minutes:

- **Warm-up (30–60 sec)** — light movement to prepare the body
- **Main block (3–5 exercises)** — target exercises at the current level
- **Cool-down/stretch (30–60 sec)** — light stretching for the worked muscle groups

**Example set for a beginner (level 1):**

| # | Exercise                    | Reps / Time         | Rest   |
|---|-----------------------------|---------------------|--------|
| 1 | Arm circles                 | 10 each direction   | —      |
| 2 | Knee push-ups               | 5 reps              | 30 sec |
| 3 | Full push-up (attempt)      | 1 rep               | 30 sec |
| 4 | Plank                       | 15 sec              | 20 sec |
| 5 | Crunches                    | 8 reps              | 20 sec |
| 6 | Shoulder and chest stretch  | 30 sec              | —      |

### 3.3 Set Types

**Daily Set** — generated automatically based on the current level. Mixes exercises from different
progression branches. This is the primary mode.

**Skill Set** — tied to a specific skill branch. The user chooses what to focus on (e.g. push-ups only).

**Challenge Set** — tests readiness to advance to the next stage. Example: "Do 10 full push-ups without stopping."

---

## 4. Progression System

### 4.1 Skill Map

The Skill Map is the main screen of the app. Each branch is a progression ladder from simple to
advanced. Branches can have prerequisites: for example, handstand push-ups require a certain level
in Push and Balance.

### 4.2 Progression Branches

The main branches with stages from beginner to advanced level:

#### 4.2.1 Push

| Stage | Exercise                              | Goal to advance     |
|-------|---------------------------------------|---------------------|
| 1     | Wall push-ups                         | 3×10                |
| 2     | Knee push-ups                         | 3×15                |
| 3     | Full push-ups                         | 3×20                |
| 4     | Diamond push-ups                      | 3×15                |
| 5     | Archer push-ups                       | 3×10 per side       |
| 6     | One-arm push-ups                      | 3×5 per side        |
| 7     | Handstand push-ups (against the wall) | 3×10                |

#### 4.2.2 Pull

| Stage | Exercise                                          | Goal to advance    |
|-------|---------------------------------------------------|--------------------|
| 1     | Australian pull-ups (low bar / table)             | 3×15               |
| 2     | Negative pull-ups                                 | 3×8                |
| 3     | Pull-ups                                          | 3×10               |
| 4     | Close-grip pull-ups                               | 3×10               |
| 5     | Archer pull-ups                                   | 3×6 per side       |
| 6     | One-arm pull-ups                                  | 3×3 per side       |

#### 4.2.3 Core

| Stage | Exercise                       | Goal to advance |
|-------|--------------------------------|-----------------|
| 1     | Crunches                       | 3×20            |
| 2     | Plank                          | 3×60 sec        |
| 3     | Lying leg raises               | 3×15            |
| 4     | Hanging leg raises             | 3×10            |
| 5     | L-sit (on the floor)           | 3×20 sec        |
| 6     | Dragon Flag                    | 3×5             |

#### 4.2.4 Legs

| Stage | Exercise                               | Goal to advance |
|-------|----------------------------------------|-----------------|
| 1     | Squats                                 | 3×20            |
| 2     | Lunges                                 | 3×12 per leg    |
| 3     | Bulgarian split squats                 | 3×10 per leg    |
| 4     | Assisted pistol squats                 | 3×8 per leg     |
| 5     | Pistol squats                          | 3×5 per leg     |

#### 4.2.5 Balance

| Stage | Exercise                                  | Goal to advance      |
|-------|-------------------------------------------|----------------------|
| 1     | One-leg stand                             | 3×60 sec             |
| 2     | One-arm plank                             | 3×30 sec per side    |
| 3     | Crow pose prep (handstand approach)       | 3×30 sec             |
| 4     | Crow pose                                 | 3×15 sec             |
| 5     | Wall handstand                            | 3×30 sec             |
| 6     | Freestanding handstand                    | 30 sec               |

### 4.3 Progression Mechanics

In-stage progression follows this pattern:

1. Increase reps: 5 → 8 → 10 → 12 → 15
2. Increase sets: 1 → 2 → 3
3. Reduce rest: 60s → 45s → 30s
4. When the goal is reached — a Challenge test unlocks
5. After a successful test — the next stage unlocks

Note: if the user skips days, the app slightly rolls back the load to avoid injury. This further
motivates not missing sessions.

---

## 5. Gamification

### 5.1 Strength Points (SP)

Points are awarded for every completed exercise. More difficult exercises yield more SP. Bonus for
completing a full set. Bonus for the first set of the day.

### 5.2 Streak

The number of consecutive days the user completed at least one set. Displayed on the home screen.
A "streak freeze" mechanic is available — a one-time streak shield for a missed day (earned via achievements).

### 5.3 Ranks

| Rank      | Requirement | Reward                   |
|-----------|-------------|--------------------------|
| Beginner  | Start        | —                        |
| Amateur   | 500 SP       | New icons                |
| Athlete   | 2,000 SP     | Streak Freeze ×2         |
| Champion  | 5,000 SP     | New themes               |
| Master    | 15,000 SP    | Gold badge               |
| Legend    | 50,000 SP    | Secret theme             |

### 5.4 Achievements

Example achievements:

- **"First Step"** — complete the first set
- **"One Week Streak"** — 7-day streak
- **"First Full Push-up"** — unlock stage 3 in Push
- **"Iron Core"** — plank for 60 seconds
- **"Marathoner"** — 30 days in a row
- **"On Top"** — unlock freestanding handstand

### 5.5 Activity Calendar

A grid of days in the style of a GitHub contribution graph, where colour intensity reflects the SP
earned on that day. Helps visualise workout consistency.

---

## 6. Notification System

Notifications are a key retention tool:

**Morning reminder** — configurable time (default 9:00). Texts rotate: "Time to work out! Your streak: 12 days 🔥".

**Evening reminder** — if no workout today (20:00): "Don't forget your workout! Just 5 minutes — streak saved."

**Streak threat** — 2 hours before end of day (22:00): "Your 12-day streak is at risk! Beat the clock before midnight!".

**Motivational** — on milestones: "Congratulations! You unlocked full push-ups! 🎉".

The user can configure notification times or disable specific types in Settings.

---

## 7. UI/UX Concept

### 7.1 Main Screens

**Home** — progression map (vertical scroll), "Today's Workout" button, streak and SP in the header.

**Workout Screen** — sequential display of exercises with animations, timer, progress bar. "Done" button
to advance to the next exercise.

**Summary Screen** — SP earned, current streak, branch progress, achievements. "Another Set" and "Home"
buttons.

**Profile** — stats, activity calendar, achievements, rank, settings.

### 7.2 Design Language

- Bright, friendly colours: green, orange, blue
- Minimalist exercise illustrations (vector shapes with animation)
- Large buttons, easy to tap during a workout
- Dark theme support

---

## 8. Technical Architecture

### 8.1 Platform

Primary target — iOS (App Store). Stack: Flutter (Dart) for cross-platform iOS and Android coverage.

### 8.2 Data Storage

All data is stored locally on the device. No backend.

**Static data (bundled with the app):**

- Exercise catalogue with descriptions, animations, and tips
- Progression tree (branches, stages, advancement goals)
- Set generation logic
- Achievement list

**User data (Hive):**

- User profile
- Progress per stage per branch
- Workout history (workout_log)
- Streaks and SP
- Earned achievements
- Settings (notifications, theme)

### 8.3 Data Model (outline)

**`UserProfile`**

- `currentRank`: String
- `totalSP`: Int
- `currentStreak`: Int
- `longestStreak`: Int
- `streakFreezeCount`: Int

**`SkillProgress`**

- `branchId`: String (push / pull / core / legs / balance)
- `currentStage`: Int
- `currentReps`: Int
- `currentSets`: Int
- `currentRestSec`: Int

**`WorkoutLog`**

- `date`: Date
- `setType`: Enum (daily / skill / challenge)
- `exercises`: [ExerciseResult]
- `spEarned`: Int
- `durationSec`: Int

**`ExerciseResult`**

- `exerciseId`: String
- `targetReps`: Int
- `completedReps`: Int
- `targetDurationSec`: Int?
- `actualDurationSec`: Int?

---

## 9. Onboarding (First Launch)

On the first launch the app runs a short survey to calibrate the starting level:

1. "How often do you exercise?" — Never / Sometimes / Regularly
2. "How many push-ups can you do?" — 0 / 1–5 / 5–15 / 15+
3. "How many minutes per day can you spare?" — 5 / 10 / 15
4. "What is your goal?" — General fitness / Push strength / Calisthenics & skills
5. Notification time selection
6. First trial set (immediately after onboarding!)

---

## 10. MVP

### 10.1 MVP v1.0 — First Release

1. 2 progression branches: Push and Core
2. Daily sets with auto-generation
3. In-stage progression (reps and sets)
4. Streaks and SP
5. Push notifications (morning + evening)
6. Static exercise illustrations
7. Onboarding survey
8. Local data storage

### 10.2 v1.1 — Expansion

1. Branches: Pull, Legs, Balance
2. Animated illustrations (Lottie)
3. Achievements
4. Activity calendar
5. Challenge tests
6. Dark theme
7. Ranks
8. Streak Freeze

### 10.3 v2.0 — Long-term Vision

- Android release
- Custom sets (user-created workouts)
- Apple Health / Google Fit integration
- Apple Watch companion (wrist timer)
- Localisation (Russian, English, and more)
- Video demonstrations of exercises

---

## 11. Risks and Constraints

| Risk                                  | Mitigation                                                                    |
|---------------------------------------|-------------------------------------------------------------------------------|
| User may injure themselves            | Mandatory disclaimer, gradual progression, warm-up/cool-down in every set     |
| Data loss if the app is deleted       | JSON data export, iCloud backup                                               |
| Incorrect exercise technique          | Detailed illustrations and technique tips                                     |
| Monotony sets in                      | Set variety, gamification, new branches in updates                            |
| No equipment for Pull                 | Bar requirement labelled clearly, door/table alternatives suggested           |

---

## 12. Summary

CaliDay fills the gap between "can't get started" and "want to do a handstand." The mechanics of
short sessions, streaks, and skill levelling are applied to physical training with the lowest
possible barrier to entry. The offline architecture eliminates infrastructure costs and simplifies
development.

**Next step:** build the MVP prototype with two branches (Push + Core) and basic gamification.