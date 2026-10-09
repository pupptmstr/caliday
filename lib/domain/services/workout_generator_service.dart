import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/enums.dart';
import '../../data/models/exercise.dart';
import '../../data/repositories/skill_progress_repository.dart';
import '../../data/static/course_catalog.dart';
import '../../data/static/exercise_catalog.dart';
import '../../data/static/exercise_tags_catalog.dart';
import '../../data/static/supplementary_exercise_catalog.dart';
import '../models/branch.dart';
import '../models/workout_plan.dart';

/// Assembles a [WorkoutPlan] for the current user state.
///
/// Daily set structure:
///   1. Warmup   (1 exercise, stage 0, from the first today-branch)
///   2. Main block (one exercise per today-branch, rotated by day index)
///   3. Cooldown (max 2 distinct cooldowns from today-branches, stage 0)
class WorkoutGeneratorService {
  const WorkoutGeneratorService(this._progressRepo);

  final SkillProgressRepository _progressRepo;

  /// Generates a [SetType.daily] plan for the given [course] and its branches.
  /// The built-in form of [generateDailyFor].
  WorkoutPlan generateDailyForCourse({
    required CourseId course,
    required List<BranchId> courseBranches,
    int preferredMinutes = 10,
    int? dayIndexOverride,
    bool isPrimary = true,
    bool hasPullUpBar = false,
    Random? random,
  }) =>
      generateDailyFor(
        branches: [for (final b in courseBranches) BuiltInBranch(b)],
        addsSupplementary: CourseCatalog.addsSupplementary(course),
        preferredMinutes: preferredMinutes,
        dayIndexOverride: dayIndexOverride,
        isPrimary: isPrimary,
        hasPullUpBar: hasPullUpBar,
        random: random,
      );

  /// Generates a [SetType.daily] plan from [branches] (a course's, built-in
  /// or the user's own).
  ///
  /// Branch rotation is deterministic: based on the number of days since
  /// 2020-01-01. [preferredMinutes] is the workout size code (`WorkoutSize`:
  /// 5 short, 10 standard, 15 full). The name is historical: it is not a
  /// duration, how long the day takes depends on reps, sets and rests. It
  /// controls how many branches to train today:
  /// - ≤ 5  → min(2, total) branches
  /// - 10   → min(3, total) branches
  /// - ≥ 15 → all branches
  ///
  /// A bonus workout ([isPrimary] false) adds two supplementary exercises
  /// when [addsSupplementary], picked with [random] (a fresh `Random()` when
  /// null; pass a seeded one, see [supplementarySeed], to build the same plan
  /// twice).
  WorkoutPlan generateDailyFor({
    required List<Branch> branches,
    bool addsSupplementary = true,
    int preferredMinutes = 10,
    int? dayIndexOverride,
    bool isPrimary = true,
    bool hasPullUpBar = false,
    Random? random,
  }) {
    if (branches.isEmpty) {
      return WorkoutPlan(setType: SetType.daily, exercises: const []);
    }

    final dayIdx = dayIndexOverride ??
        DateTime.now().toUtc().difference(DateTime.utc(2020, 1, 1)).inDays;
    final total = branches.length;
    final n = preferredMinutes <= 5
        ? min(2, total)
        : preferredMinutes >= 15
            ? total
            : min(3, total);
    final startIdx = dayIdx % total;
    final todayBranches =
        List.generate(n, (i) => branches[(startIdx + i) % total]);

    // ── Main block (one exercise per branch) ──────────────────────────────────
    final main = <PlannedExercise>[];
    final stageOf = <Branch, int>{};
    for (final branch in todayBranches) {
      final progress = _progressRepo.progressFor(branch);
      stageOf[branch] = progress.currentStage;
      var exercise = branch.stage(progress.currentStage);
      if (exercise == null) continue;

      if (exercise.requiresEquipment && !hasPullUpBar) {
        exercise = branch.equipmentFreeStage(progress.currentStage) ?? exercise;
      }

      main.add(PlannedExercise(
        exercise: exercise,
        targetAmount: progress.currentReps,
        sets: progress.currentSets,
        restSec: progress.currentRestSec,
        branchKey: branch.key,
      ));
    }
    // An own branch may hold a warm-up or a cool-down as a stage: it is not
    // added a second time around it.
    final mainIds = {for (final p in main) p.exercise.id};

    final exercises = <PlannedExercise>[];

    // ── 1. Warmup (from the first branch) ────────────────────────────────────
    final first = todayBranches.first;
    final warmup = first.warmupAt(stageOf[first] ?? 1);
    if (warmup != null && !mainIds.contains(warmup.id)) {
      exercises.add(PlannedExercise(
        exercise: warmup,
        targetAmount: warmup.startReps,
        sets: 1,
        restSec: 0,
      ));
    }

    // ── 2. Main block ─────────────────────────────────────────────────────────
    exercises.addAll(main);

    // ── 3. Cooldowns (max 2, from different branches) ─────────────────────────
    final cooldowns = <Exercise>[];
    final addedIds = <String>{};
    for (final branch in todayBranches) {
      for (final c in branch.cooldownsAt(stageOf[branch] ?? 1)) {
        if (mainIds.contains(c.id)) continue;
        if (addedIds.add(c.id)) cooldowns.add(c);
        if (addedIds.length >= 2) break;
      }
      if (addedIds.length >= 2) break;
    }
    // The lying relaxation always closes the workout (Yoga mixes it with the
    // downward dog of the shared Balance branch).
    cooldowns.sort((a, b) => (a == ExerciseCatalog.cooldownLyingRelaxation ? 1 : 0)
        .compareTo(b == ExerciseCatalog.cooldownLyingRelaxation ? 1 : 0));
    for (final c in cooldowns) {
      exercises.add(PlannedExercise(
        exercise: c,
        targetAmount: c.startReps,
        sets: 1,
        restSec: 0,
      ));
    }

    // ── 4. Supplementary block (bonus workouts only, not in every course) ─────
    if (!isPrimary &&
        addsSupplementary &&
        SupplementaryExerciseCatalog.all.isNotEmpty) {
      final pool = [...SupplementaryExerciseCatalog.all]..shuffle(random ?? Random());
      for (final supp in pool.take(2)) {
        exercises.add(PlannedExercise(
          exercise: supp,
          targetAmount: supp.startReps,
          sets: supp.startSets,
          restSec: supp.startRestSec,
        ));
      }
    }

    return WorkoutPlan(setType: SetType.daily, exercises: exercises);
  }

  /// The seed for the supplementary exercises of a bonus workout: the same
  /// for one calendar day and one count of workouts already done that day, a
  /// different one for the next bonus workout. The Home button and the
  /// workout screen both build the day's plan on their own, and with this seed
  /// they build the same one, so the time shown on "Again" is the time of the
  /// workout that starts.
  static int supplementarySeed(DateTime date, int workoutsToday) =>
      (date.year * 10000 + date.month * 100 + date.day) * 100 + workoutsToday;

  /// Legacy wrapper that defaults to [CourseId.calisthenics].
  WorkoutPlan generateDaily({
    required List<BranchId> activeBranches,
    int preferredMinutes = 10,
    int? dayIndexOverride,
    bool isPrimary = true,
    bool hasPullUpBar = false,
  }) =>
      generateDailyForCourse(
        course: CourseId.calisthenics,
        courseBranches: activeBranches,
        preferredMinutes: preferredMinutes,
        dayIndexOverride: dayIndexOverride,
        isPrimary: isPrimary,
        hasPullUpBar: hasPullUpBar,
      );

  /// Builds a [WorkoutPlan] from an explicit list of exercise IDs.
  ///
  /// Used for custom routines. Each exercise is loaded at its [startReps] /
  /// [startSets] / [startRestSec] values — no progression state involved.
  /// Search order: ExerciseCatalog.all → libraryAll (warmup/cooldown) → supplementary.
  WorkoutPlan fromExerciseIds(List<String> ids) {
    final exercises = <PlannedExercise>[];
    for (final id in ids) {
      final exercise = ExerciseCatalog.byId(id) ??
          ExerciseCatalog.libraryAll.where((e) => e.id == id).firstOrNull ??
          SupplementaryExerciseCatalog.all.where((e) => e.id == id).firstOrNull;
      if (exercise == null) continue;
      exercises.add(PlannedExercise(
        exercise: exercise,
        targetAmount: exercise.startReps,
        sets: exercise.startSets,
        restSec: exercise.startRestSec,
      ));
    }
    return WorkoutPlan(setType: SetType.daily, exercises: exercises);
  }

  /// Returns true if the given exercise IDs contain at least one warmup
  /// and at least one cooldown (based on [ExerciseTag]).
  static bool hasWarmupAndCooldown(List<String> ids) {
    final hasWarmup = ids.any(
      (id) => ExerciseTagsCatalog.forId(id).contains(ExerciseTag.warmup),
    );
    final hasCooldown = ids.any(
      (id) => ExerciseTagsCatalog.forId(id).contains(ExerciseTag.cooldown),
    );
    return hasWarmup && hasCooldown;
  }

  /// Prepends a generic warmup and appends a generic cooldown to [ids].
  static List<String> addGenericWarmupCooldown(List<String> ids) {
    return [
      'warmup_arm_rotations',
      ...ids,
      'cooldown_shoulder_stretch',
    ];
  }

  /// Generates a [SetType.challenge] plan for [branch]; the built-in form of
  /// [generateChallengeFor].
  WorkoutPlan generateChallenge(BranchId branch, {bool hasPullUpBar = false}) =>
      generateChallengeFor(BuiltInBranch(branch), hasPullUpBar: hasPullUpBar);

  /// Generates a [SetType.challenge] plan for [branch].
  ///
  /// Structure: warmup → current stage (1 light set) → next stage
  /// (challengeTargetReps) → cooldown.
  /// Returns a daily plan as fallback if challenge is not available.
  WorkoutPlan generateChallengeFor(Branch branch, {bool hasPullUpBar = false}) {
    final progress = _progressRepo.progressFor(branch);
    Exercise? resolve(Exercise? e) {
      if (e == null) return null;
      if (e.requiresEquipment && !hasPullUpBar) {
        return branch.equipmentFreeStage(e.stage) ?? e;
      }
      return e;
    }

    final current = resolve(branch.stage(progress.currentStage));
    final next = resolve(branch.stage(progress.currentStage + 1));
    if (current == null || next == null) {
      return generateDailyFor(branches: [branch], hasPullUpBar: hasPullUpBar);
    }

    final exercises = <PlannedExercise>[];

    // 1. Warmup
    final warmup = branch.warmupAt(progress.currentStage);
    if (warmup != null && warmup.id != current.id && warmup.id != next.id) {
      exercises.add(PlannedExercise(
        exercise: warmup,
        targetAmount: warmup.startReps,
        sets: 1,
        restSec: 0,
      ));
    }

    // 2. Current stage — 1 light set as movement warm-up
    exercises.add(PlannedExercise(
      exercise: current,
      targetAmount: current.startReps,
      sets: 1,
      restSec: progress.currentRestSec,
      branchKey: branch.key,
    ));

    // 3. Challenge exercise — next stage, challengeTargetReps as target
    exercises.add(PlannedExercise(
      exercise: next,
      targetAmount: next.challengeTargetReps,
      sets: 1,
      restSec: next.startRestSec,
      branchKey: branch.key,
    ));

    // 4. Cooldown (first cooldown for this branch)
    final cooldowns = [
      for (final c in branch.cooldownsAt(progress.currentStage))
        if (c.id != current.id && c.id != next.id) c,
    ];
    if (cooldowns.isNotEmpty) {
      final cooldown = cooldowns.first;
      exercises.add(PlannedExercise(
        exercise: cooldown,
        targetAmount: cooldown.startReps,
        sets: 1,
        restSec: 0,
      ));
    }

    return WorkoutPlan(setType: SetType.challenge, exercises: exercises);
  }
}

final workoutGeneratorServiceProvider = Provider<WorkoutGeneratorService>((ref) {
  return WorkoutGeneratorService(
    ref.watch(skillProgressRepositoryProvider),
  );
});
