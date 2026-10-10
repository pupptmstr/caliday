import 'package:caliday/data/models/branch_growth.dart';
import 'package:caliday/data/models/enums.dart';
import 'package:caliday/data/models/workout_log.dart';
import 'package:caliday/data/static/achievement_catalog.dart';
import 'package:caliday/domain/services/home_digest.dart';
import 'package:flutter_test/flutter_test.dart';

WorkoutLog _log(DateTime date, [List<BranchGrowth>? growth]) => WorkoutLog(
      date: date,
      setType: SetType.daily,
      exercises: const [],
      spEarned: 10,
      durationSec: 300,
      growth: growth,
    );

BranchGrowth _grew(String key) => BranchGrowth(
    branchKey: key, fromStage: 1, toStage: 1, fromAmount: 5, toAmount: 7,
    fromSets: 1, toSets: 1, fromRestSec: 60, toRestSec: 60);

void main() {
  group('the nearest achievement', () {
    AchievementGoal? goal(Set<String> earned, int streak, int total) =>
        HomeDigest.nearestAchievement(
            earned: earned, streak: streak, totalWorkouts: total);

    test('a new user: the first workout', () {
      expect(goal({}, 0, 0), const AchievementGoal('first_workout', 1, GoalUnit.workouts));
    });

    test('the one needing less, the streak on a tie', () {
      expect(goal({'first_workout'}, 1, 1),
          const AchievementGoal('streak_3', 2, GoalUnit.days));
      expect(goal({'first_workout', 'streak_3'}, 4, 8),
          const AchievementGoal('workouts_10', 2, GoalUnit.workouts));
      expect(goal({'first_workout', 'streak_3'}, 5, 8),
          const AchievementGoal('streak_7', 2, GoalUnit.days));
    });

    test('a broken streak counts from zero; earned ones are skipped', () {
      expect(goal({'first_workout', 'streak_3', 'streak_7', 'workouts_10'}, 0, 12),
          const AchievementGoal('streak_30', 30, GoalUnit.days));
    });

    test('a reached but not yet awarded goal is passed over', () {
      expect(goal({'first_workout'}, 3, 2),
          const AchievementGoal('streak_7', 4, GoalUnit.days));
    });

    test('none when every count is done', () {
      final all = {...HomeDigest.streakGoals.keys, ...HomeDigest.workoutGoals.keys};
      expect(goal(all, 120, 150), isNull);
    });

    test('every goal is a real achievement', () {
      final ids = AchievementCatalog.all.map((a) => a.id).toSet();
      expect(ids, containsAll([...HomeDigest.streakGoals.keys, ...HomeDigest.workoutGoals.keys]));
    });
  });

  group('the next rank', () {
    test('the SP missing and the way into the current rank', () {
      final g = HomeDigest.nextRank(1250)!;
      expect(g.rank, Rank.sportsman);
      expect(g.missingSP, 750);
      expect(g.progress, closeTo(0.5, 1e-9));
      expect(HomeDigest.nextRank(0)!.rank, Rank.amateur);
    });

    test('none at the top', () {
      expect(HomeDigest.nextRank(Rank.legend.spThreshold), isNull);
    });
  });

  test('the growth of a day, in the order of its workouts, old logs without it', () {
    final logs = [
      _log(DateTime(2026, 10, 10, 19), [_grew('core')]),
      _log(DateTime(2026, 10, 9, 8), [_grew('legs')]),
      _log(DateTime(2026, 10, 10, 7), [_grew('push'), _grew('custom_b1')]),
      _log(DateTime(2026, 10, 10, 12)),
    ];
    expect(HomeDigest.growthOn(logs, DateTime(2026, 10, 10, 21)).map((g) => g.branchKey),
        ['push', 'custom_b1', 'core']);
    expect(HomeDigest.growthOn(logs, DateTime(2026, 10, 8)), isEmpty);
  });

  test('the host keeps a line all day and says the next one tomorrow, across DST', () {
    for (final (a, b) in [
      (DateTime(2026, 10, 24, 0, 5), DateTime(2026, 10, 24, 23, 55)),
      (DateTime(2026, 10, 25, 0, 5), DateTime(2026, 10, 25, 23, 55)),
      (DateTime(2026, 3, 29, 0, 5), DateTime(2026, 3, 29, 23, 55)),
    ]) {
      expect(HomeDigest.lineIndex(a, 4), HomeDigest.lineIndex(b, 4));
    }
    final today = HomeDigest.lineIndex(DateTime(2026, 10, 25, 12), 4);
    expect(HomeDigest.lineIndex(DateTime(2026, 10, 26, 12), 4), (today + 1) % 4);
  });
}
