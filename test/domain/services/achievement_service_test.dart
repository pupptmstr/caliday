import 'package:caliday/data/models/enums.dart';
import 'package:caliday/data/models/skill_progress.dart';
import 'package:caliday/data/models/user_profile.dart';
import 'package:caliday/data/static/achievement_catalog.dart';
import 'package:caliday/domain/services/achievement_service.dart';
import 'package:flutter_test/flutter_test.dart';

Map<BranchId, SkillProgress> _progressAt(int Function(BranchId) stage) => {
      for (final b in BranchId.values)
        b: SkillProgress(branchId: b, currentStage: stage(b)),
    };

void main() {
  const service = AchievementService();

  group('checkAfterWorkout', () {
    List<String> check({
      int workouts = 1,
      int streak = 0,
      Rank rank = Rank.beginner,
      Set<String>? earned,
    }) =>
        service.checkAfterWorkout(
          profile: UserProfile(currentStreak: streak, rank: rank),
          totalWorkouts: workouts,
          alreadyEarned: earned ?? <String>{},
        );

    test('the first workout earns first_workout and nothing else', () {
      expect(check(), ['first_workout']);
    });

    test('volume milestones at 10 / 50 / 100 workouts', () {
      expect(check(workouts: 9), isNot(contains('workouts_10')));
      expect(check(workouts: 10), contains('workouts_10'));
      expect(check(workouts: 49), isNot(contains('workouts_50')));
      expect(check(workouts: 50), contains('workouts_50'));
      expect(check(workouts: 100), contains('workouts_100'));
    });

    test('streak milestones at 3 / 7 / 30 / 100 days', () {
      expect(check(streak: 2), isNot(contains('streak_3')));
      expect(check(streak: 3), contains('streak_3'));
      expect(check(streak: 7), containsAll(['streak_3', 'streak_7']));
      expect(check(streak: 30), contains('streak_30'));
      expect(check(streak: 100), contains('streak_100'));
    });

    test('a rank earns that rank achievement and every one below it', () {
      expect(check(rank: Rank.beginner), isNot(contains('rank_amateur')));
      expect(check(rank: Rank.sportsman),
          containsAll(['rank_amateur', 'rank_sportsman']));
      expect(check(rank: Rank.legend), contains('rank_legend'));
    });

    test('already earned achievements are not awarded twice', () {
      final earned = <String>{'first_workout'};
      expect(check(earned: earned), isEmpty);
    });

    test('newly earned ids are added to the set that was passed in', () {
      final earned = <String>{};
      final first = check(workouts: 10, earned: earned);
      expect(earned, first.toSet());
      expect(check(workouts: 10, earned: earned), isEmpty);
    });
  });

  group('checkAfterStageAdvance', () {
    List<String> advance(
      BranchId branch,
      int newStage, {
      Map<BranchId, SkillProgress>? progress,
      Set<String>? earned,
    }) =>
        service.checkAfterStageAdvance(
          branch: branch,
          newStage: newStage,
          allProgress: progress ?? _progressAt((_) => 1),
          alreadyEarned: earned ?? <String>{},
        );

    test('the first stage advance of any branch earns first_challenge', () {
      expect(advance(BranchId.push, 2), ['first_challenge']);
      expect(advance(BranchId.posture, 2), ['first_challenge']);
    });

    test('stage milestones fire at their stage, not before', () {
      expect(advance(BranchId.push, 2), isNot(contains('push_s3')));
      expect(advance(BranchId.push, 3), contains('push_s3'));
      expect(advance(BranchId.push, 6), containsAll(['push_s3', 'push_s6']));
      expect(advance(BranchId.core, 5), containsAll(['core_s2', 'core_s5']));
      expect(advance(BranchId.balance, 4), contains('balance_s4'));
    });

    test('completing a branch earns its _complete achievement', () {
      for (final branch in [
        BranchId.push, BranchId.core, BranchId.pull,
        BranchId.legs, BranchId.balance, BranchId.flex,
      ]) {
        expect(advance(branch, branch.stageCount - 1),
            isNot(contains('${branch.name}_complete')),
            reason: branch.name);
        expect(advance(branch, branch.stageCount),
            contains('${branch.name}_complete'),
            reason: branch.name);
      }
    });

    test('completing an Evening Stretch branch earns its achievement', () {
      const ids = {
        BranchId.eveningBack: 'evening_back_complete',
        BranchId.eveningHips: 'evening_hips_complete',
        BranchId.eveningFolds: 'evening_folds_complete',
        BranchId.eveningShoulders: 'evening_shoulders_complete',
      };
      ids.forEach((branch, id) {
        expect(advance(branch, branch.stageCount - 1), isNot(contains(id)),
            reason: branch.name);
        expect(advance(branch, branch.stageCount), contains(id), reason: branch.name);
      });
    });

    test('Healthy Body branches have no achievements of their own yet', () {
      expect(advance(BranchId.posture, 6), ['first_challenge']);
      expect(advance(BranchId.neck, 5), ['first_challenge']);
    });

    test('all_complete needs every branch at its last stage', () {
      final almost = _progressAt((b) => b.stageCount)
        ..[BranchId.neck] =
            SkillProgress(branchId: BranchId.neck, currentStage: 4);
      expect(advance(BranchId.push, 7, progress: almost),
          isNot(contains('all_complete')));

      final done = _progressAt((b) => b.stageCount);
      expect(advance(BranchId.push, 7, progress: done), contains('all_complete'));
    });

    test('already earned achievements are not awarded twice', () {
      final earned = <String>{'first_challenge', 'push_s3'};
      expect(advance(BranchId.push, 3, earned: earned), isEmpty);
    });
  });

  group('service and catalog agree', () {
    // Every id the service can award, by feeding it the most advanced state.
    final awardable = <String>{
      ...service.checkAfterWorkout(
        profile: UserProfile(currentStreak: 100, rank: Rank.legend),
        totalWorkouts: 100,
        alreadyEarned: <String>{},
      ),
      for (final branch in BranchId.values)
        ...service.checkAfterStageAdvance(
          branch: branch,
          newStage: branch.stageCount,
          allProgress: _progressAt((b) => b.stageCount),
          alreadyEarned: <String>{},
        ),
    };
    final catalogIds = AchievementCatalog.all.map((a) => a.id).toSet();

    test('every awardable id exists in the catalog (the UI looks it up)', () {
      // achievements_screen.dart does AchievementCatalog.byId(id)! for every
      // earned id; an id missing here crashes that screen.
      expect(awardable.difference(catalogIds), isEmpty);
    });

    test('every catalog achievement can actually be earned', () {
      expect(catalogIds.difference(awardable), isEmpty);
    });

    test('catalog ids are unique and byId finds each one', () {
      expect(catalogIds, hasLength(AchievementCatalog.all.length));
      for (final a in AchievementCatalog.all) {
        expect(AchievementCatalog.byId(a.id), same(a));
      }
      expect(AchievementCatalog.byId('nope'), isNull);
    });

    test('only all_complete is secret', () {
      final secret = AchievementCatalog.all.where((a) => a.isSecret);
      expect(secret.map((a) => a.id), ['all_complete']);
    });
  });
}
