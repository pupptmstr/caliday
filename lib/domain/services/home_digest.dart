import '../../core/utils/calendar_days.dart';
import '../../data/models/branch_growth.dart';
import '../../data/models/enums.dart';
import '../../data/models/workout_log.dart';

/// What the middle of Home says (owner, 2026-10-10): before the first
/// workout of the day the host's line, the course's branches and the next
/// goals; after it the recent workouts and how the branches grew today.
/// Pure, with an injectable `now`.
abstract final class HomeDigest {
  /// The streak and workout-count achievements, in the order they come.
  static const streakGoals = {'streak_3': 3, 'streak_7': 7, 'streak_30': 30, 'streak_100': 100};
  static const workoutGoals = {
    'first_workout': 1,
    'workouts_10': 10,
    'workouts_50': 50,
    'workouts_100': 100,
  };

  /// The achievement closest to being earned that a count can measure: the
  /// next streak one or the next workout-count one, whichever needs fewer
  /// days or workouts (the streak one on a tie); null when both are done.
  static AchievementGoal? nearestAchievement({
    required Set<String> earned,
    required int streak,
    required int totalWorkouts,
  }) {
    AchievementGoal? next(Map<String, int> goals, int value, GoalUnit unit) {
      for (final MapEntry(:key, value: target) in goals.entries) {
        if (earned.contains(key) || target <= value) continue;
        return AchievementGoal(key, target - value, unit);
      }
      return null;
    }

    final byStreak = next(streakGoals, streak, GoalUnit.days);
    final byCount = next(workoutGoals, totalWorkouts, GoalUnit.workouts);
    if (byStreak == null) return byCount;
    if (byCount == null) return byStreak;
    return byCount.remaining < byStreak.remaining ? byCount : byStreak;
  }

  /// The next rank, the SP still missing and how far into the current rank
  /// [totalSP] is (0..1); null at the top rank.
  static RankGoal? nextRank(int totalSP) {
    final current = RankExtension.fromSP(totalSP);
    final next = current.next;
    if (next == null) return null;
    final span = next.spThreshold - current.spThreshold;
    return RankGoal(
      next,
      next.spThreshold - totalSP,
      ((totalSP - current.spThreshold) / span).clamp(0.0, 1.0),
    );
  }

  /// How the branches grew on [day], workout by workout in the order they
  /// were done ([logs] in any order; logs before 0.9.4 have no growth).
  static List<BranchGrowth> growthOn(Iterable<WorkoutLog> logs, DateTime day) {
    final ofDay = logs
        .where((l) => calendarDaysBetween(l.date, day) == 0)
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
    return [for (final l in ofDay) ...?l.growth];
  }

  /// Which of [count] lines the host says on [now]'s day: the same all day,
  /// the next one the day after.
  static int lineIndex(DateTime now, int count) =>
      calendarDaysBetween(DateTime(2026), now) % count;
}

enum GoalUnit { days, workouts }

/// An achievement still ahead and how much is missing.
class AchievementGoal {
  const AchievementGoal(this.id, this.remaining, this.unit);

  final String id;
  final int remaining;
  final GoalUnit unit;

  @override
  bool operator ==(Object other) =>
      other is AchievementGoal &&
      other.id == id &&
      other.remaining == remaining &&
      other.unit == unit;

  @override
  int get hashCode => Object.hash(id, remaining, unit);

  @override
  String toString() => 'AchievementGoal($id, $remaining ${unit.name})';
}

/// The next rank, the SP missing and the progress towards it.
class RankGoal {
  const RankGoal(this.rank, this.missingSP, this.progress);

  final Rank rank;
  final int missingSP;
  final double progress;
}
