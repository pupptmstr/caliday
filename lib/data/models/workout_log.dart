import 'package:hive/hive.dart';

import 'enums.dart';
import 'exercise_result.dart';

part 'workout_log.g.dart';

/// Immutable record of a completed workout session.
@HiveType(typeId: 2)
class WorkoutLog extends HiveObject {
  WorkoutLog({
    required this.date,
    required this.setType,
    required this.exercises,
    required this.spEarned,
    required this.durationSec,
    this.isPrimary = true,
  });

  /// The calendar date the workout was performed (time component zeroed).
  @HiveField(0)
  final DateTime date;

  @HiveField(1)
  final SetType setType;

  @HiveField(2)
  final List<ExerciseResult> exercises;

  /// Total SP awarded for this session.
  @HiveField(3)
  final int spEarned;

  /// Total workout duration in seconds.
  @HiveField(4)
  final int durationSec;

  /// True if this is the first (primary) workout of the day.
  /// Bonus workouts earn ×0.5 SP and do not advance progression or streak.
  @HiveField(5)
  final bool isPrimary;
}