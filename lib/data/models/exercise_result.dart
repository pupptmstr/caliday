import 'package:hive/hive.dart';

part 'exercise_result.g.dart';

/// Records the outcome of a single exercise within a [WorkoutLog].
@HiveType(typeId: 3)
class ExerciseResult {
  ExerciseResult({
    required this.exerciseId,
    required this.targetReps,
    required this.completedReps,
    this.targetDurationSec,
    this.actualDurationSec,
  });

  @HiveField(0)
  final String exerciseId;

  /// Target reps for a [ExerciseType.reps] exercise; 0 for timed.
  @HiveField(1)
  final int targetReps;

  /// Completed reps for a [ExerciseType.reps] exercise; 0 for timed.
  @HiveField(2)
  final int completedReps;

  /// Target duration in seconds for a [ExerciseType.timed] exercise.
  @HiveField(3)
  final int? targetDurationSec;

  /// Actual duration held in seconds for a [ExerciseType.timed] exercise.
  @HiveField(4)
  final int? actualDurationSec;
}