# Data and Hive

> Part of the project notes — the index is [internal_docs/README.md](../README.md).

## Data and Hive

## Hive typeIds (must not change after release)

| typeId | Class |
|--------|-------|
| 0 | `UserProfile` |
| 1 | `SkillProgress` |
| 2 | `WorkoutLog` |
| 3 | `ExerciseResult` |
| 4 | `BranchId` (enum) |
| 5 | `SetType` (enum) |
| 6 | `ExerciseType` (enum) |
| 7 | `Rank` (enum) |
| 8 | `FitnessGoal` (enum) |
| 9 | retired: `FriendProfile` (Friends, removed in 0.9.5) — never reuse |
| 10 | `CourseId` (enum) |
| 11 | `CustomRoutine` |
| 12 | `CustomBranch` |
| 13 | `CustomCourse` |
| 14 | `BranchGrowth` |

## UserProfile HiveFields

| Field | Type | Description |
|-------|------|-------------|
| @0..13 | base | currentStreak, totalSP, rank, lastWorkoutDate, etc. |
| @14 | String? | themeModeName (null=system, 'light', 'dark') |
| @15 | bool? | hasPullUpBar |
| @16 | — | reserved, unused |
| @17 | — | retired: peerId (Friends, removed in 0.9.5) — never reuse; older profiles still hold it, the adapter skips it |
| @18 | String? | displayName — the user's name (onboarding step 1, Settings → Profile): the host's greeting on Home, the Profile header, the summary title; null / empty = none |
| @19 | bool? | soundEnabled (null → true) — replaced by @28 in 0.9.6, still written (off = false) |
| @20 | bool? | hapticEnabled (null → true) |
| @21 | bool? | healthWorkoutsEnabled |
| @22 | bool? | healthWeightEnabled |
| @23 | — | retired: bleDiscoverable (Friends, removed in 0.9.5) — never reuse |
| @24 | List<int>? | activeCourseIds — CourseId indices; null → [0] (calisthenics); empty → no built-in course, only own ones (0.9.6) |
| @25 | int? | activeCourseIndex — index into activeCourseIds; null → 0 |
| @26 | String? | lastSeenReleaseVersion — the newest "What's new" version the user has opened; null → none yet (every entry is new). A new user starts at the current version (set by `completeOnboarding`) |
| @27 | String? | activeCustomCourseId — `CustomCourse.id` of the own course shown now; null → the built-in `activeCourse` |
| @28 | String? | soundModeName — `SoundMode.name` ('all' / 'key' / 'off', 0.9.6); null → from @19 (`SoundMode.from`) |

## SkillProgress HiveFields

| Field | Type | Description |
|-------|------|-------------|
| @0 | BranchId? | branchId — the built-in branch; null for an own branch (nullable since 0.9.3; every older record has it) |
| @1..5 | base | currentStage, currentReps, currentSets, currentRestSec, isChallengeUnlocked |
| @6 | DateTime? | lastProgressedOn — the day of the last daily step |
| @7 | String? | customBranchId — `CustomBranch.id` of an own branch's progress (box key `custom_<id>` = `branchKey`) |

Not `key`: that getter is `HiveObject`'s own (the box key), hence `SkillProgress.branchKey`.

## CustomBranch HiveFields (typeId 12, box `custom_branches`, key = id)

| Field | Type | Description |
|-------|------|-------------|
| @0 | String | id — microsecondsSinceEpoch in base 36 |
| @1 | String | name |
| @2 | List\<String\> | exerciseIds — the stages, stage 1 first (an id once) |
| @3 | DateTime | createdAt — the order of "My branches" |

## CustomCourse HiveFields (typeId 13, box `custom_courses`, key = id)

| Field | Type | Description |
|-------|------|-------------|
| @0 | String | id — microsecondsSinceEpoch in base 36 |
| @1 | String | name |
| @2 | List\<String\> | branchKeys — `Branch.key`s in rotation order (`push`, `custom_<id>`) |
| @3 | int | hostIndex — `CourseId.index` of the host |
| @4 | DateTime | createdAt — the order of the pills |
| @5 | bool | shown — has a pill (default true; 0.9.4, unticked in the course list "+") |

## CustomRoutine HiveFields

| Field | Type | Description |
|-------|------|-------------|
| @0 | String | id — microsecondsSinceEpoch in base-36 (unique) |
| @1 | String | name — user-defined routine name |
| @2 | List\<String\> | exerciseIds — ordered exercise IDs from catalog |
| @3 | DateTime | createdAt |
| @4 | DateTime? | lastRunAt |

## WorkoutLog HiveFields
| Field | Type | Description |
|-------|------|-------------|
| @0..4 | base | date, setType, exercises, spEarned, durationSec |
| @5 | bool | isPrimary — false = bonus workout |
| @6 | int? | courseIdIndex — CourseId.index; null → 0 (calisthenics) |
| @7 | bool | freezeUsed — a streak freeze was consumed for this workout; the skipped day is `date − 1` (default false) |
| @8 | bool | freezeEarned — a freeze was awarded after this workout (default false) |
| @9 | int? | estimatedDurationSec — the raw `WorkoutPlan.estimatedDurationSec` when the workout started (never the pace-corrected figure); null on logs from before it was recorded and on the debug screen's fake logs. Compared with `durationSec` to learn the pace |
| @10 | List\<BranchGrowth\>? | growth — how each branch moved on in this workout (0.9.4; null before): `WorkoutProgression.growth` compares each touched branch before and after. `BranchGrowth` (typeId 14): @0 branchKey, @1/@2 stage, @3/@4 amount (reps or seconds), @5/@6 sets, @7/@8 restSec (from / to), @9 challengeUnlocked; `kind` = the one step taken (amount, sets, rest, challenge, stage — a branch moves once a day, a challenge passed is a stage) |

## Hive boxes
- `'user_profile'` — `Box<UserProfile>` (single record, key `'profile'`)
- `'skill_progress'` — `Box<SkillProgress>` (key = `branch.name`, e.g. `'push'`)
- `'workout_log'` — `Box<WorkoutLog>`
- `'achievements'` — `Box<DateTime>` (key = achievementId, value = when it was earned)
- `'custom_routines'` — `Box<CustomRoutine>` (key = routine.id)
- `'custom_branches'` — `Box<CustomBranch>` (key = branch.id)
- `'custom_courses'` — `Box<CustomCourse>` (key = course.id)
- Retired: `'friends'` (FriendProfile, until 0.9.5) — `deleteRetiredBoxes()` (`data/retired_boxes.dart`) deletes it at start-up, not awaited (on the web, deleting an IndexedDB database that an open tab of an older build holds waits until that tab closes); the name is never used again

## Exercise Model
`Exercise` is a static `const` model, **not stored in Hive**.
Loaded from `ExerciseCatalog`. `stage = 0` = warmup/cooldown.

`challengeTargetReps` is the norm (reps, or seconds for timed) for **entering** a stage through the Challenge: it is read from the *next* stage when a challenge is generated and judged, and is unused for stage 1. Every stage from 2 up has one (a test enforces it); with 0 any result would pass the Challenge. The six hardest stages: handstand push-up, dragon flag, one-arm pull-up and pistol squat 1 rep, free handstand 5 s, pike stretch 30 s.
