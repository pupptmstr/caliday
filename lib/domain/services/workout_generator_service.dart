import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/enums.dart';
import '../../data/repositories/skill_progress_repository.dart';
import '../../data/static/exercise_catalog.dart';
import '../models/workout_plan.dart';

/// Assembles a [WorkoutPlan] for the current user state.
///
/// For MVP v1.0 the daily set structure is:
///   1. Warmup   (1 exercise, stage 0)
///   2. Push     (current stage/reps/sets/rest from SkillProgress)
///   3. Core     (current stage/reps/sets/rest from SkillProgress)
///   4. Cooldown (1–2 exercises, stage 0)
class WorkoutGeneratorService {
  const WorkoutGeneratorService(this._progressRepo);

  final SkillProgressRepository _progressRepo;

  /// Generates a [SetType.daily] plan for the given active [branches].
  ///
  /// For MVP always pass [BranchId.push] and [BranchId.core].
  WorkoutPlan generateDaily({
    List<BranchId> branches = const [BranchId.push, BranchId.core],
  }) {
    final exercises = <PlannedExercise>[];

    // ── 1. Warmup ────────────────────────────────────────────────────────────
    final warmup = branches.contains(BranchId.push)
        ? ExerciseCatalog.warmupArmRotations
        : ExerciseCatalog.warmupJumpingJacks;

    exercises.add(PlannedExercise(
      exercise: warmup,
      targetAmount: warmup.startReps,
      sets: 1,
      restSec: 0,
    ));

    // ── 2. Main block (one exercise per branch) ───────────────────────────────
    for (final branch in branches) {
      final progress = _progressRepo.getProgress(branch);
      final exercise = ExerciseCatalog.forStage(branch, progress.currentStage);
      if (exercise == null) continue; // branch fully completed (all stages done)

      exercises.add(PlannedExercise(
        exercise: exercise,
        targetAmount: progress.currentReps,
        sets: progress.currentSets,
        restSec: progress.currentRestSec,
      ));

      // If challenge is unlocked, add a single-rep preview of the next stage
      // so the user gets a taste of what's coming.
      if (progress.isChallengeUnlocked) {
        final next = ExerciseCatalog.forStage(branch, progress.currentStage + 1);
        if (next != null) {
          exercises.add(PlannedExercise(
            exercise: next,
            targetAmount: next.startReps,
            sets: 1,
            restSec: next.startRestSec,
          ));
        }
      }
    }

    // ── 3. Cooldown ───────────────────────────────────────────────────────────
    if (branches.contains(BranchId.push)) {
      final cooldown = ExerciseCatalog.cooldownShoulderStretch;
      exercises.add(PlannedExercise(
        exercise: cooldown,
        targetAmount: cooldown.startReps,
        sets: 1,
        restSec: 0,
      ));
    }

    if (branches.contains(BranchId.core)) {
      final cooldown = ExerciseCatalog.cooldownCatCow;
      exercises.add(PlannedExercise(
        exercise: cooldown,
        targetAmount: cooldown.startReps,
        sets: 1,
        restSec: 0,
      ));
    }

    return WorkoutPlan(setType: SetType.daily, exercises: exercises);
  }
}

final workoutGeneratorServiceProvider = Provider<WorkoutGeneratorService>((ref) {
  return WorkoutGeneratorService(
    ref.watch(skillProgressRepositoryProvider),
  );
});