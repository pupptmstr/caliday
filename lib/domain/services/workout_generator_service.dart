import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/enums.dart';
import '../../data/repositories/skill_progress_repository.dart';
import '../../data/static/exercise_catalog.dart';
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

  /// Generates a [SetType.daily] plan for the given active [activeBranches].
  ///
  /// Branch rotation is deterministic: based on the number of days since
  /// 2020-01-01. [preferredMinutes] controls how many branches to train today:
  /// - ≤ 5 min  → min(2, total) branches
  /// - 10 min   → min(3, total) branches
  /// - ≥ 15 min → all branches
  ///
  /// Sets per exercise always come from [SkillProgress.currentSets].
  WorkoutPlan generateDaily({
    required List<BranchId> activeBranches,
    int preferredMinutes = 10,
    int? dayIndexOverride,
  }) {
    if (activeBranches.isEmpty) {
      return WorkoutPlan(setType: SetType.daily, exercises: const []);
    }

    final dayIdx = dayIndexOverride ??
        DateTime.now().toUtc().difference(DateTime.utc(2020, 1, 1)).inDays;
    final total = activeBranches.length;
    final n = preferredMinutes <= 5
        ? min(2, total)
        : preferredMinutes >= 15
            ? total
            : min(3, total);
    final startIdx = dayIdx % total;
    final todayBranches = List.generate(
        n, (i) => activeBranches[(startIdx + i) % total]);

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
      final exercise = ExerciseCatalog.forStage(branch, progress.currentStage);
      if (exercise == null) continue;

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

    return WorkoutPlan(setType: SetType.daily, exercises: exercises);
  }

  /// Generates a [SetType.challenge] plan for [branch].
  ///
  /// Structure: warmup → current stage (1 light set) → next stage
  /// (challengeTargetReps) → cooldown.
  /// Returns a daily plan as fallback if challenge is not available.
  WorkoutPlan generateChallenge(BranchId branch) {
    final progress = _progressRepo.getProgress(branch);
    final current = ExerciseCatalog.forStage(branch, progress.currentStage);
    final next = ExerciseCatalog.forStage(branch, progress.currentStage + 1);
    if (current == null || next == null) {
      return generateDaily(activeBranches: [branch]);
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
