import 'dart:math' show max;

import '../../data/models/enums.dart';
import '../../data/models/exercise.dart';

/// A single exercise slot in a generated workout.
///
/// [targetAmount] means reps for [ExerciseType.reps] exercises,
/// or seconds for [ExerciseType.timed] exercises — mirrors
/// the convention used in [SkillProgress.currentReps].
class PlannedExercise {
  const PlannedExercise({
    required this.exercise,
    required this.targetAmount,
    required this.sets,
    required this.restSec,
  });

  final Exercise exercise;

  /// Reps or seconds to perform per set.
  final int targetAmount;

  /// Number of sets.
  final int sets;

  /// Rest in seconds after each set (0 = no rest, e.g. warmup/cooldown).
  final int restSec;
}

/// Seconds of "get ready" before the hold of a timed exercise that has just
/// begun: time to take position and skim the description.
const int kPrepNewExerciseSec = 10;

/// The same before the next set of the same exercise: the position is known.
const int kPrepNextSetSec = 5;

/// Get-ready seconds before set [setIndex] of [planned]. A reps exercise has
/// nothing that counts down by itself, so it gets none.
int prepSecFor(PlannedExercise planned, int setIndex) {
  if (planned.exercise.type != ExerciseType.timed) return 0;
  return setIndex == 0 ? kPrepNewExerciseSec : kPrepNextSetSec;
}

/// A calm pace of one rep (down and up), used only for the time estimate:
/// nothing in the app times reps, the user taps Done.
const int kSecondsPerRep = 3;

/// A fully generated, ready-to-execute workout.
class WorkoutPlan {
  const WorkoutPlan({
    required this.setType,
    required this.exercises,
  });

  final SetType setType;
  final List<PlannedExercise> exercises;

  /// Total number of sets across all exercises.
  int get totalSets => exercises.fold(0, (sum, e) => sum + e.sets);

  /// Estimated duration in seconds, following what the workout screen does:
  /// a timed set takes its hold plus the get-ready countdown before it
  /// ([prepSecFor]), a reps set takes [kSecondsPerRep] per rep, and the rest
  /// after a set runs everywhere except after the last set of the workout.
  /// For a plan of timed exercises only, this is exactly the number of ticks
  /// the run takes (a test steps the real state machine to prove it); reps
  /// are a guess at the user's pace.
  int get estimatedDurationSec {
    var total = 0;
    for (var i = 0; i < exercises.length; i++) {
      final e = exercises[i];
      final timed = e.exercise.type == ExerciseType.timed;
      for (var set = 0; set < e.sets; set++) {
        total += timed ? e.targetAmount : e.targetAmount * kSecondsPerRep;
        total += prepSecFor(e, set);
        final isLastSet = i == exercises.length - 1 && set == e.sets - 1;
        if (!isLastSet) total += e.restSec;
      }
    }
    return total;
  }

  /// [estimatedDurationSec] in whole minutes for display: at least 1, and 0
  /// for an empty plan.
  int get estimatedMinutes => estimatedMinutesAt(1.0);

  /// The same scaled by the user's pace (`WorkoutPace.factorFrom`: 1.25 means
  /// workouts take a quarter longer than estimated).
  int estimatedMinutesAt(double pace) => exercises.isEmpty
      ? 0
      : max(1, (estimatedDurationSec * pace / 60).round());
}