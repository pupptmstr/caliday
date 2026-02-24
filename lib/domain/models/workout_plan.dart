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

  /// Rough estimated duration in seconds (sets × ~30s per set + rest).
  int get estimatedDurationSec {
    return exercises.fold(0, (total, e) {
      final workSec = e.sets * 30; // rough average
      final restSec = e.sets > 1 ? (e.sets - 1) * e.restSec : 0;
      return total + workSec + restSec;
    });
  }
}