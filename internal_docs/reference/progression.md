# Progression, SP, streaks, ranks and achievements

> Part of the project notes — the index is [internal_docs/README.md](../README.md).

## In-Stage Progression
Reps ↑ → Sets ↑ (with reps reset) → Rest ↓ → Challenge test → Next stage.

A stage's target can be lowered in the catalog without migration code of its own: `SkillProgressRepository.runMigrations()` (at start-up) brings stored reps above the current stage's target down to it. Used in 0.9.2, when the three longest per-side holds (single-leg stand, hip flexor stretch, 90/90: 3 sets of 60 s on each side, ~7 min) were halved to 10 → 30 s per side (owner); the onboarding and default start values of Balance and Flex follow (10 s).

## Gamification
- **SP (Strength Points)** — points earned for exercises
- **Streak** — consecutive days; freezes (max 3, earned every 7 streak days)
- **Ranks (English UI names):** Beginner → Amateur → Athlete → Champion → Master → Legend — enum values `beginner, amateur, sportsman, athlete, master, legend` (see § Rank SP Thresholds). A rank that is not trained for 21+ days is shown lower, see RankDecayService
- **Achievements** — 45 total (one is secret; the four of each new course are `<course>_<branch>_complete`, the branches outside the courses have `<branch>_complete`: `strong_back_complete`, `glutes_complete`, `arms_shoulders_complete`, `cardio_complete` — Goro presents them; `all_complete` needs only the branches of the courses), checked after each workout and stage advance. A branch achievement names its branch (`Achievement.branch`, a test checks it against what `AchievementService` awards for that branch); the host of the branch's course presents it (0.9.2): a 22 px portrait on the tile of the Achievements screen and, in the sheet (`showAchievementSheet`, `features/profile/widgets/achievement_sheet.dart`, shared with the Profile badges), the host cheering when earned or, while still ahead, holding a grey medal with a padlock (`CourseId.hostLocked`, 0.9.4; before, only its supportive face — "Goro doesn't hold it, just his head", owner). The app's own achievements (streaks, ranks, volume, `first_challenge`, `all_complete`) get no badge and Goro in the sheet. A shared branch belongs to the active course when that course holds it, otherwise to the first course listing it (`CourseCatalog.courseOf(branch, active:)`: Balance is Miso's while Yoga is active, else Goro's)
- **Bonus workouts** — multiple workouts per day are allowed (50% SP; each branch still moves on once a day, see § Primary vs Bonus Workout)

## Rank SP Thresholds
| Rank (English UI) | Rank (Russian UI) | Enum | SP |
|-------------------|-------------------|------|----|
| Beginner | Новичок | `beginner` | 0 |
| Amateur | Любитель | `amateur` | 500 |
| Athlete | Спортсмен | `sportsman` | 2,000 |
| Champion | Атлет | `athlete` | 5,000 |
| Master | Мастер | `master` | 15,000 |
| Legend | Легенда | `legend` | 50,000 |

The two middle ranks are **not** translations of each other: the enum values follow the Russian names, so `Rank.sportsman` is shown as "Athlete" in English and `Rank.athlete` as "Champion" (`rankSportsman` / `rankAthlete` in the ARB files; the home screen widget reads the same keys). German and Spanish follow the Russian names: Anfänger, Amateur, Sportler, Athlet, Meister, Legende / Principiante, Aficionado, Deportista, Atleta, Maestro, Leyenda.

## Workout size
The user picks how big the daily workout is: **Short** (2 skill branches), **Standard** (3) or **Full** (all branches of the course), `WorkoutSize` in `data/models/enums.dart`. It used to be presented as "5 / 10 / 15 minutes", which promised a duration the app never computed: the real time follows reps, sets and rests and roughly doubles as the user progresses (about 6 / 8 / 15 min at the start for Calisthenics, about 10 / 15 / 29 min with 12×3 reps and 60 s rests). So the names describe the volume, not the time, and no text may promise minutes (a test checks the names).

The stored value is unchanged: `UserProfile.preferredWorkoutMinutes` (HiveField 12) keeps the old code 5 / 10 / 15 (`WorkoutSize.code`), so no migration; the generator parameter `preferredMinutes` keeps its historical name and reads the same code. `WorkoutSize.fromCode` reads any stored int the way the generator does (a test compares them for 0..30). Healthy Body has only 3 branches, so Standard and Full give the same workout there (Evening Stretch has 4, so they differ). Chosen in onboarding (step 3) and in Settings → Workout (a segmented control like the theme one); changing it invalidates `homeDataProvider`.

**How long it takes.** The Home button reads "Today's workout (≈ N min)" on one line (`WorkoutPlan.estimatedMinutes`) — the honest replacement for the old promise. `WorkoutPlan.estimatedDurationSec` follows the workout screen: a timed set is its hold plus the get-ready countdown (twice, the second time the switch-sides one, for a hold on each side), a reps set is `kSecondsPerRep` (3 s) per rep, and the rest after each set runs everywhere but after the last set of the workout. For timed-only plans it equals the ticks of a real run (`workout_timer_test.dart` steps the state machine to prove it); reps are a guess at the user's pace, hence the "≈". Both the Home button and the workout screen build the day's plan with `buildDailyPlan` (`workout_provider.dart`), so the estimate is of the plan that will actually run; `todayPlanProvider` rebuilds with `homeDataProvider`. It is shown on the "Again" button too ("Again (≈ N min)"): a bonus workout adds two supplementary exercises, and `buildDailyPlan` picks them with a seeded `Random` (`WorkoutGeneratorService.supplementarySeed(date, workouts done today)`), so Home and the workout screen, each building the plan on its own, get the same two; the next bonus workout (one more done today) gets others. `daily_plan_test.dart` proves the two sides agree, with real repositories.

**Pace.** The estimate cannot know how fast one user does a rep, how long they read or whether they skip rests, so it learns it: each finished workout stores the raw estimate of its plan (`WorkoutLog.estimatedDurationSec`) beside the real `durationSec`, and `WorkoutPace.factorFrom` takes the **median of real / estimated over the last 7 workouts** that have both (1.0 until there are 3; clamped to 0.6–1.6 so one odd workout, a phone call in the middle, cannot move the figure far). The Home button shows `plan.estimatedMinutesAt(workoutPaceProvider)`. The raw estimate is what is stored, so the correction never feeds on itself; but if the formula of `estimatedDurationSec` is ever changed (`kSecondsPerRep`, the countdowns), the stored ratios of the last seven workouts were measured against the old one and the figure is off until they roll out of the window. Nothing in the UI says the figure is personal; the debug state dump prints `Pace: x1.12 from 5 workouts`. Notification texts promise no duration either (a test checks).

## Primary vs Bonus Workout
`WorkoutLog.isPrimary`: true = first of the day (full SP, counts toward streak); false = 50% SP.

**Progression is per branch and per day, not per workout** (owner's rule, 2026-10-07): a branch moves on at most once per calendar day, on the first *successful* set of its current stage that day, in any workout — primary or bonus, a daily plan or a custom routine (`ProgressionService.applyDailyResult`, the day in `SkillProgress.lastProgressedOn`, HiveField 6). So a morning course and an afternoon course both progress, and a branch they share (Flex) moves once. A failed set does not use the day up; an exercise of another stage than the branch's current one never counts (a custom routine may hold one — before 0.8.19 such an exercise moved the current stage by the other exercise's targets). The Challenge is unchanged: passing it always advances the stage.
Determined in `_finishWorkout`: `isPrimary = !workoutRepo.hasPrimaryWorkoutToday()`. The first workout of the day is always primary — regardless of whether it is a daily plan or a custom routine. Custom-only users can build a streak this way. `courseIdIndex` is still `null` for custom routines (not tied to any course).

## Services (domain layer)

### SPService
- `forExercise(result, exercise)` — SP for an exercise; warmup/cooldown (stage=0) → 0; a hold on each side (`Exercise.perSide`) counts the seconds of both sides
- `forWorkout(results, exercises, isFirstToday)` — totals SP: ×1.5 when it is the first workout of the day, then ×1.1 when every exercise was fully completed (each step rounded). A bonus workout is called with `isFirstToday: false` and `_finishWorkout` halves the result (`× 0.5`).
- `applyToProfile(profile, sp)` — mutates profile: SP + rank (the rank is always recomputed from SP)

### StreakService
- `applyWorkout(profile, date)` → bool — updates streak; on a 1-day gap, uses a freeze. Only called when at least one real exercise (stage > 0, reps > 0 or duration > 0) was performed — warmup-only workouts do not count.
- `tryAwardFreeze(profile)` → bool — +1 freeze every 7 days (max 3)
- `isStreakAtRisk(profile)` — true if no workout today
- `daysSinceLastWorkout(profile, {now})` — counter (-1 if never); `now` injectable for tests
- `streakLostDate(profile)` — the calendar day on which the streak is actually gone if the user does not train: last workout + 2 days, + 3 with a freeze (mirrors `applyWorkout` / `displayStreak`); drives the streak-lost notification
- All day counting goes through `core/utils/calendar_days.dart`. **Never** use `DateTime.difference(...).inDays` or `subtract/add(Duration(days: n))` on local dates: a local day is 23 / 25 h on a DST change, so `inDays` truncates 14 days to 13 and `subtract` lands on 23:00 / 01:00 of the neighbouring day (a 5-day streak reset after training on the DST Sunday and the Monday; the heatmap lost every cell before the change).

**displayStreak (important):** computed on the fly in `homeDataProvider` without mutating Hive:
```
days <= 1                          → profile.currentStreak
days == 2 && freezeCount > 0       → profile.currentStreak  (freeze will save it on next workout)
otherwise                          → 0
```

### RankDecayService
- Pure service (no Hive writes) — decay is display-only; `UserProfile.rank` always holds the SP-earned rank.
- `decayTiers(days)` — tiers to subtract; thresholds: [21, 35, 45, 53, 59] days (gaps: 14/10/8/6)
- `effectiveRank(earnedRank, days)` — rank to display; clamped to Beginner
- `isWarning(days)` — true when 14–20 days inactive (first decay in 7 days)
- `isDecayed(days)` — true when rank is actively lowered (21+ days)
- `daysSinceLastWorkout(profile, {now})` → int (-1 if never trained). Uses `calendarDaysBetween` (DST-safe, see StreakService). `now` is injectable for tests.
- Provider: `rankDecayServiceProvider`
- Tests: `test/domain/services/rank_decay_service_test.dart`
- `HomeData.effectiveRank` and `ProfileData.effectiveRank` expose this for display; computed in providers, not in widgets.

### ProgressionService
- `applyDailyResult(progress, exercise, result, now:)` → bool — what a finished workout calls: the once-a-day gate (current stage only, not yet today, a successful set), then `applyResult`; see § Primary vs Bonus Workout
- `applyResult(progress, exercise, result, {stageCount})` → bool (true = challenge unlocked) — one step, no daily limit; `stageCount` (`Branch.stageCount`) says whether a next stage exists, without it the catalog is asked (built-in branches only); `applyDailyResult` passes it on
- `advanceStage(progress, nextExercise)` — stage transition after challenge
- `applyRegression(progress, exercise, daysSkipped)` — rollback on 3+ days skipped
- `nextExercise(progress)` — next stage from catalog

### CustomStages (own branches)
- `build(exercises)` / `stageOf(e, stage)` — a copy of each catalog exercise (same id, texts, tags, animation, `branch`) with its place as `stage`. An exercise with an in-stage progression of its own (every built-in stage) keeps its start / target reps, sets and rests; one without (warm-ups, cool-downs, the supplementary pool: one fixed amount) starts at it and grows to twice it (`growth`; timed in whole 5 s), 1 → 2 sets, rest 30 → 15 s. The challenge to enter a stage: the exercise's own norm when it is a built-in stage from 2 up (even below its start, the catalog's choice), else 1.5 × its start; stage 1 has none.
- `remap(progress, oldIds, stages)` — after an edit the user stays on their exercise where it moved (amounts kept; no challenge on the last stage); if it was removed, on the stage that took its place (the last one when the list got shorter) from its start.

### WorkoutProgression
- `apply(plan, results, ownBranches, progressFor, now)` — what `_finishWorkout` does to the branches, pure: each stage exercise moves the branch of `PlannedExercise.branchKey` (an own stage is a copy that keeps its catalog `branch`), else its own; a challenge exercise (above the current stage) advances on its norm in any workout, any other goes through `applyDailyResult` with the branch's `stageCount`; each branch's progress is read once; `touched` lists the records to save; a deleted own branch is skipped.

### WorkoutGeneratorService
- `generateDailyFor({branches, addsSupplementary, …})` — the daily plan from any `Branch`es (an own course's too); each main exercise carries `branchKey`. `generateDailyForCourse` (below) wraps it for a `CourseId`. `generateChallengeFor(Branch)` likewise wraps `generateChallenge(BranchId)`.
- `generateDailyForCourse({course, courseBranches, preferredMinutes, dayIndexOverride, isPrimary, hasPullUpBar})` — primary method; progress comes from the injected `SkillProgressRepository`; rotates branches by dayIndex (days since 2020-01-01, overridable for tests). N branches by the workout size code (`WorkoutSize`: 5 short / 10 standard / 15 full): min(2,total) at ≤5, min(3,total) at 10, total at ≥15. Warm-up of the first branch, one main exercise per branch, at most two distinct cool-downs, the lying relaxation always last (Yoga mixes it with the Balance downward dog); a bonus workout (`isPrimary: false`) gets two supplementary exercises on top (not in a course where `CourseCatalog.addsSupplementary` is false: Evening Stretch), shuffled with an injectable `random` (a fresh `Random()` by default; the app passes the seeded one, see § Workout size). Without a pull-up bar an equipment exercise is swapped for its alternative when one exists (core stage 4 → flutter kicks).
- `generateDaily(...)` — legacy wrapper, calls `generateDailyForCourse` with `course: CourseId.calisthenics`.
- `generateChallenge(branch)` — warmup → current stage (1 easy set) → next stage (challengeTargetReps) → cooldown
- `fromExerciseIds(List<String> ids)` → `WorkoutPlan` — builds a plan from explicit exercise IDs; uses `startReps/Sets/RestSec`; search order: `byId` → `libraryAll` → `SupplementaryExerciseCatalog.all`
- `hasWarmupAndCooldown(ids)` → `bool` — checks for `ExerciseTag.warmup` and `ExerciseTag.cooldown` presence
- `addGenericWarmupCooldown(ids)` → prepends `warmup_arm_rotations`, appends `cooldown_shoulder_stretch`

### AchievementService
- `checkAfterWorkout({profile, totalWorkouts, alreadyEarned})` → `List<String>` newly earned ids (volume, streak, rank)
- `checkAfterStageAdvance({branch, newStage, allProgress, alreadyEarned})` → `List<String>` newly earned ids (`first_challenge`, per-branch milestones, `<branch>_complete`, secret `all_complete`)
- Pure: `alreadyEarned` is updated in place, persistence is the caller's job. Every id it can return must exist in `AchievementCatalog` (the achievements screen looks them up); a test enforces that in both directions.

### Mutation Pattern
All services **mutate** the passed objects (`UserProfile`, `SkillProgress`) in place.
Persistence is the responsibility of the calling code via repositories.
