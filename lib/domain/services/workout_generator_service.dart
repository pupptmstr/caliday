import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/enums.dart';
import '../../data/models/exercise.dart';
import '../../data/repositories/skill_progress_repository.dart';
import '../../data/static/exercise_catalog.dart';
import '../../data/static/supplementary_exercise_catalog.dart';
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
  ///
  /// Branch rotation is deterministic: based on the number of days since
  /// 2020-01-01. [preferredMinutes] controls how many branches to train today:
  /// - ≤ 5 min  → min(2, total) branches
  /// - 10 min   → min(3, total) branches
  /// - ≥ 15 min → all branches
  WorkoutPlan generateDailyForCourse({
    required CourseId course,
    required List<BranchId> courseBranches,
    int preferredMinutes = 10,
    int? dayIndexOverride,
    bool isPrimary = true,
    bool hasPullUpBar = false,
  }) {
    if (courseBranches.isEmpty) {
      return WorkoutPlan(setType: SetType.daily, exercises: const []);
    }

    final dayIdx = dayIndexOverride ??
        DateTime.now().toUtc().difference(DateTime.utc(2020, 1, 1)).inDays;
    final total = courseBranches.length;
    final n = preferredMinutes <= 5
        ? min(2, total)
        : preferredMinutes >= 15
            ? total
            : min(3, total);
    final startIdx = dayIdx % total;
    final todayBranches =
        List.generate(n, (i) => courseBranches[(startIdx + i) % total]);

    final exercises = <PlannedExercise>[];

    // ── 1. Warmup (from the first branch) ────────────────────────────────────
    final warmup = ExerciseCatalog.warmupFor(todayBranches.first);
    if (warmup != null) {
      exercises.add(PlannedExercise(
        exercise: warmup,
        targetAmount: warmup.startReps,
        sets: 1,
        restSec: 0,
      ));
    }

    // ── 2. Main block (one exercise per branch) ───────────────────────────────
    for (final branch in todayBranches) {
      final progress = _progressRepo.getProgress(branch);
      var exercise = ExerciseCatalog.forStage(branch, progress.currentStage);
      if (exercise == null) continue;

      if (exercise.requiresEquipment && !hasPullUpBar) {
        exercise =
            ExerciseCatalog.equipmentFreeForStage(branch, progress.currentStage) ??
                exercise;
      }

      exercises.add(PlannedExercise(
        exercise: exercise,
        targetAmount: progress.currentReps,
        sets: progress.currentSets,
        restSec: progress.currentRestSec,
      ));
    }

    // ── 3. Cooldowns (max 2, from different branches) ─────────────────────────
    final addedIds = <String>{};
    for (final branch in todayBranches) {
      for (final c in ExerciseCatalog.cooldownsFor(branch)) {
        if (addedIds.add(c.id)) {
          exercises.add(PlannedExercise(
            exercise: c,
            targetAmount: c.startReps,
            sets: 1,
            restSec: 0,
          ));
        }
        if (addedIds.length >= 2) break;
      }
      if (addedIds.length >= 2) break;
    }

    // ── 4. Supplementary block (bonus workouts only) ──────────────────────────
    if (!isPrimary && SupplementaryExerciseCatalog.all.isNotEmpty) {
      final pool = [...SupplementaryExerciseCatalog.all]..shuffle(Random());
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
  WorkoutPlan fromExerciseIds(List<String> ids) {
    final exercises = <PlannedExercise>[];
    for (final id in ids) {
      // byId searches ExerciseCatalog.all (excludes coreS4FlutterKicks);
      // fall back to libraryAll to cover equipment-free alternatives.
      final exercise = ExerciseCatalog.byId(id) ??
          ExerciseCatalog.libraryAll.where((e) => e.id == id).firstOrNull;
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

  /// Generates a [SetType.challenge] plan for [branch].
  ///
  /// Structure: warmup → current stage (1 light set) → next stage
  /// (challengeTargetReps) → cooldown.
  /// Returns a daily plan as fallback if challenge is not available.
  WorkoutPlan generateChallenge(BranchId branch, {bool hasPullUpBar = false}) {
    final progress = _progressRepo.getProgress(branch);
    Exercise? resolve(Exercise? e) {
      if (e == null) return null;
      if (e.requiresEquipment && !hasPullUpBar) {
        return ExerciseCatalog.equipmentFreeForStage(branch, e.stage) ?? e;
      }
      return e;
    }

    final current = resolve(ExerciseCatalog.forStage(branch, progress.currentStage));
    final next = resolve(ExerciseCatalog.forStage(branch, progress.currentStage + 1));
    if (current == null || next == null) {
      return generateDaily(activeBranches: [branch], hasPullUpBar: hasPullUpBar);
    }

    final exercises = <PlannedExercise>[];

    // 1. Warmup
    final warmup = ExerciseCatalog.warmupFor(branch);
    if (warmup != null) {
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
    ));

    // 3. Challenge exercise — next stage, challengeTargetReps as target
    exercises.add(PlannedExercise(
      exercise: next,
      targetAmount: next.challengeTargetReps,
      sets: 1,
      restSec: next.startRestSec,
    ));

    // 4. Cooldown (first cooldown for this branch)
    final cooldowns = ExerciseCatalog.cooldownsFor(branch);
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
