import 'package:hive_ce/hive_ce.dart';

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
    this.courseIdIndex,
    this.freezeUsed = false,
    this.freezeEarned = false,
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

  /// Index of [CourseId] this workout belongs to. null → 0 (calisthenics).
  @HiveField(6)
  final int? courseIdIndex;

  /// True if a streak freeze was consumed to preserve the streak for this workout.
  /// The skipped gap day is (date − 1 day).
  @HiveField(7)
  final bool freezeUsed;

  /// True if a streak freeze was awarded after this workout (streak hit a multiple of 7).
  @HiveField(8)
  final bool freezeEarned;
}