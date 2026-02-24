import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/enums.dart';
import '../../data/models/exercise.dart';
import '../../data/models/exercise_result.dart';
import '../../data/models/user_profile.dart';

/// Calculates Strength Points (SP) and applies them to a [UserProfile].
///
/// SP rules:
///   - [ExerciseType.reps]  → [Exercise.spBase] × completedReps
///   - [ExerciseType.timed] → [Exercise.spBase] × (actualDurationSec / 10), floored
///   - +50% bonus when it is the user's first workout of the day
///   - +10% completion bonus when every exercise was fully completed
class SPService {
  const SPService();

  /// SP earned for a single exercise result.
  int forExercise(ExerciseResult result, Exercise exercise) {
    if (exercise.stage == 0) return 0; // warmup / cooldown never award SP

    if (exercise.type == ExerciseType.reps) {
      return result.completedReps * exercise.spBase;
    } else {
      final secs = result.actualDurationSec ?? 0;
      return (secs / 10 * exercise.spBase).floor();
    }
  }

  /// Total SP for a completed workout session, including bonuses.
  ///
  /// [results] and [exercises] must correspond by index.
  int forWorkout({
    required List<ExerciseResult> results,
    required List<Exercise> exercises,
    required bool isFirstToday,
  }) {
    var total = 0;
    final len = results.length < exercises.length ? results.length : exercises.length;
    for (var i = 0; i < len; i++) {
      total += forExercise(results[i], exercises[i]);
    }

    if (total == 0) return 0;

    // +50% for first workout of the day
    if (isFirstToday) total = (total * 1.5).round();

    // +10% if every exercise was fully completed
    if (_allCompleted(results)) total = (total * 1.1).round();

    return total;
  }

  /// Adds [earnedSP] to [profile] and recalculates the rank.
  ///
  /// Mutates [profile] in place; caller must persist via [UserRepository].
  void applyToProfile(UserProfile profile, int earnedSP) {
    profile.totalSP += earnedSP;
    profile.rank = RankExtension.fromSP(profile.totalSP);
  }

  bool _allCompleted(List<ExerciseResult> results) {
    return results.every((r) {
      if (r.targetDurationSec != null) {
        return (r.actualDurationSec ?? 0) >= r.targetDurationSec!;
      }
      return r.completedReps >= r.targetReps;
    });
  }
}

final spServiceProvider = Provider<SPService>((_) => const SPService());