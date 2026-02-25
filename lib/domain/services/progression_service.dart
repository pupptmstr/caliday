import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/exercise.dart';
import '../../data/models/exercise_result.dart';
import '../../data/models/skill_progress.dart';
import '../../data/static/exercise_catalog.dart';

/// Advances or regresses a user's [SkillProgress] based on workout results.
///
/// Progression order within a stage (from the design doc):
///   1. Reps ↑  (startReps → targetReps)
///   2. Sets ↑  (startSets → targetSets; reps reset to startReps each time)
///   3. Rest ↓  (startRestSec → targetRestSec in [_restStep]-second steps)
///   4. Challenge unlocked → caller handles stage advance via [advanceStage]
///
/// All methods mutate [SkillProgress] in place.
/// The caller is responsible for persisting via [SkillProgressRepository].
class ProgressionService {
  const ProgressionService();

  static const int _repStep = 2;
  static const int _restStep = 15; // seconds

  /// Call after a workout where the user completed [result] for [exercise].
  ///
  /// Returns true if the stage goal was reached and the Challenge is now
  /// unlocked for the first time.
  bool applyResult(
    SkillProgress progress,
    Exercise exercise,
    ExerciseResult result,
  ) {
    if (progress.isChallengeUnlocked) return false; // nothing more to progress

    final succeeded = _wasSuccessful(result, exercise);
    if (!succeeded) return false; // no progress on a failed set

    if (progress.currentReps < exercise.targetReps) {
      // Phase 1: increase reps
      progress.currentReps =
          min(exercise.targetReps, progress.currentReps + _repStep);
    } else if (progress.currentSets < exercise.targetSets) {
      // Phase 2: add a set, reset reps so the user rebuilds them with more sets
      progress.currentSets++;
      progress.currentReps = exercise.startReps;
    } else if (progress.currentRestSec > exercise.targetRestSec) {
      // Phase 3: reduce rest
      progress.currentRestSec =
          max(exercise.targetRestSec, progress.currentRestSec - _restStep);
    } else {
      // All targets met — unlock the Challenge only if a next stage exists.
      // At the final stage there is nowhere to go, so just stay at peak values.
      final hasNext = ExerciseCatalog.forStage(
            progress.branchId, progress.currentStage + 1) !=
          null;
      if (hasNext) {
        progress.isChallengeUnlocked = true;
        return true;
      }
    }

    return false;
  }

  /// Advances [progress] to the next stage using [nextExercise] as the template.
  ///
  /// Call this after the user passes the Challenge test.
  void advanceStage(SkillProgress progress, Exercise nextExercise) {
    progress.currentStage = nextExercise.stage;
    progress.currentReps = nextExercise.startReps;
    progress.currentSets = nextExercise.startSets;
    progress.currentRestSec = nextExercise.startRestSec;
    progress.isChallengeUnlocked = false;
  }

  /// Slightly reduces reps if the user has been inactive for [daysSkipped] days.
  ///
  /// No regression below [Exercise.startReps]; no stage regression in MVP.
  void applyRegression(
    SkillProgress progress,
    Exercise exercise,
    int daysSkipped,
  ) {
    if (daysSkipped < 3) return;

    // One step back per 3-day block of inactivity (capped at startReps).
    final steps = daysSkipped ~/ 3;
    progress.currentReps =
        max(exercise.startReps, progress.currentReps - _repStep * steps);
  }

  /// Returns the next [Exercise] for [progress], or null if already at max stage.
  Exercise? nextExercise(SkillProgress progress) {
    return ExerciseCatalog.forStage(
      progress.branchId,
      progress.currentStage + 1,
    );
  }

  bool _wasSuccessful(ExerciseResult result, Exercise exercise) {
    if (exercise.type.index == 1) {
      // timed
      return (result.actualDurationSec ?? 0) >= result.targetReps;
    }
    return result.completedReps >= result.targetReps;
  }
}

final progressionServiceProvider =
    Provider<ProgressionService>((_) => const ProgressionService());