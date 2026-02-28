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
  /// [preferredMinutes] comes from [UserProfile.preferredWorkoutMinutes] and
  /// controls workout volume:
  /// - ≤ 5 min  → 1 set per exercise (quick session)
  /// - 10 min   → standard (sets as stored in progress)
  /// - ≥ 15 min → +1 set per exercise, capped at 3
  WorkoutPlan generateDaily({
    List<BranchId> branches = const [BranchId.push, BranchId.core],
    int preferredMinutes = 10,
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

      final int sets;
      if (preferredMinutes <= 5) {
        sets = 1;
      } else if (preferredMinutes >= 15) {
        sets = (progress.currentSets + 1).clamp(1, 3);
      } else {
        sets = progress.currentSets;
      }

      exercises.add(PlannedExercise(
        exercise: exercise,
        targetAmount: progress.currentReps,
        sets: sets,
        restSec: progress.currentRestSec,
      ));
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

  /// Generates a [SetType.challenge] plan for [branch].
  ///
  /// Structure: warmup → current stage (1 light set) → next stage
  /// (challengeTargetReps) → cooldown.
  /// Returns a daily plan as fallback if challenge is not available.
  WorkoutPlan generateChallenge(BranchId branch) {
    final progress = _progressRepo.getProgress(branch);
    final current = ExerciseCatalog.forStage(branch, progress.currentStage);
    final next = ExerciseCatalog.forStage(branch, progress.currentStage + 1);
    if (current == null || next == null) return generateDaily(branches: [branch]);

    final exercises = <PlannedExercise>[];

    // 1. Warmup
    final warmup = branch == BranchId.push
        ? ExerciseCatalog.warmupArmRotations
        : ExerciseCatalog.warmupJumpingJacks;
    exercises.add(PlannedExercise(
      exercise: warmup,
      targetAmount: warmup.startReps,
      sets: 1,
      restSec: 0,
    ));

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

    // 4. Cooldown
    if (branch == BranchId.push) {
      exercises.add(PlannedExercise(
        exercise: ExerciseCatalog.cooldownShoulderStretch,
        targetAmount: ExerciseCatalog.cooldownShoulderStretch.startReps,
        sets: 1,
        restSec: 0,
      ));
    }
    if (branch == BranchId.core) {
      exercises.add(PlannedExercise(
        exercise: ExerciseCatalog.cooldownCatCow,
        targetAmount: ExerciseCatalog.cooldownCatCow.startReps,
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