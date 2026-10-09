import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/enums.dart';
import '../../data/models/skill_progress.dart';
import '../../data/models/user_profile.dart';

/// Pure service that computes which achievements are newly earned.
///
/// Methods are side-effect free: they only read state and return IDs.
/// Persistence (calling [AchievementRepository.markEarned]) is the caller's
/// responsibility.
class AchievementService {
  const AchievementService();

  /// Returns IDs of achievements newly earned after a workout.
  ///
  /// [totalWorkouts] must reflect the count AFTER the current workout is logged.
  /// [alreadyEarned] is a snapshot of previously earned IDs (mutated in place
  /// so duplicate awards are avoided if this method is called repeatedly).
  List<String> checkAfterWorkout({
    required UserProfile profile,
    required int totalWorkouts,
    required Set<String> alreadyEarned,
  }) {
    final earned = <String>[];

    void check(String id, bool condition) {
      if (condition && !alreadyEarned.contains(id)) {
        alreadyEarned.add(id);
        earned.add(id);
      }
    }

    // Volume
    check('first_workout', totalWorkouts >= 1);
    check('workouts_10', totalWorkouts >= 10);
    check('workouts_50', totalWorkouts >= 50);
    check('workouts_100', totalWorkouts >= 100);

    // Streak
    check('streak_3', profile.currentStreak >= 3);
    check('streak_7', profile.currentStreak >= 7);
    check('streak_30', profile.currentStreak >= 30);
    check('streak_100', profile.currentStreak >= 100);

    // Ranks (index order: beginner=0, amateur=1, sportsman=2, athlete=3, master=4, legend=5)
    check('rank_amateur', profile.rank.index >= Rank.amateur.index);
    check('rank_sportsman', profile.rank.index >= Rank.sportsman.index);
    check('rank_athlete', profile.rank.index >= Rank.athlete.index);
    check('rank_master', profile.rank.index >= Rank.master.index);
    check('rank_legend', profile.rank.index >= Rank.legend.index);

    return earned;
  }

  /// Returns IDs of achievements newly earned after a stage advance in a
  /// branch the user made: it has no milestones of its own, only the first
  /// challenge counts.
  List<String> checkAfterOwnStageAdvance({required Set<String> alreadyEarned}) =>
      alreadyEarned.add('first_challenge') ? const ['first_challenge'] : const [];

  /// Returns IDs of achievements newly earned after a stage advance.
  ///
  /// [newStage] is [SkillProgress.currentStage] after [advanceStage].
  /// [allProgress] must contain an entry for every [BranchId].
  List<String> checkAfterStageAdvance({
    required BranchId branch,
    required int newStage,
    required Map<BranchId, SkillProgress> allProgress,
    required Set<String> alreadyEarned,
  }) {
    final earned = <String>[];

    void check(String id, bool condition) {
      if (condition && !alreadyEarned.contains(id)) {
        alreadyEarned.add(id);
        earned.add(id);
      }
    }

    // Any first stage advance → first_challenge
    check('first_challenge', true);

    switch (branch) {
      case BranchId.push:
        check('push_s3', newStage >= 3);
        check('push_s6', newStage >= 6);
        check('push_complete', newStage >= BranchId.push.stageCount);
      case BranchId.core:
        check('core_s2', newStage >= 2);
        check('core_s5', newStage >= 5);
        check('core_complete', newStage >= BranchId.core.stageCount);
      case BranchId.pull:
        check('pull_s3', newStage >= 3);
        check('pull_complete', newStage >= BranchId.pull.stageCount);
      case BranchId.legs:
        check('legs_s5', newStage >= 5);
        check('legs_complete', newStage >= BranchId.legs.stageCount);
      case BranchId.balance:
        check('balance_s4', newStage >= 4);
        check('balance_s6', newStage >= 6);
        check('balance_complete', newStage >= BranchId.balance.stageCount);
      case BranchId.flex:
        check('flex_complete', newStage >= BranchId.flex.stageCount);
      case BranchId.posture:
      case BranchId.neck:
        // No achievements defined yet for Healthy Body branches.
        break;
      case BranchId.eveningBack:
        check('evening_back_complete', newStage >= BranchId.eveningBack.stageCount);
      case BranchId.eveningHips:
        check('evening_hips_complete', newStage >= BranchId.eveningHips.stageCount);
      case BranchId.eveningFolds:
        check('evening_folds_complete', newStage >= BranchId.eveningFolds.stageCount);
      case BranchId.eveningShoulders:
        check('evening_shoulders_complete', newStage >= BranchId.eveningShoulders.stageCount);
      case BranchId.morningSpine:
        check('morning_spine_complete', newStage >= BranchId.morningSpine.stageCount);
      case BranchId.morningJoints:
        check('morning_joints_complete', newStage >= BranchId.morningJoints.stageCount);
      case BranchId.morningArms:
        check('morning_arms_complete', newStage >= BranchId.morningArms.stageCount);
      case BranchId.morningEnergy:
        check('morning_energy_complete', newStage >= BranchId.morningEnergy.stageCount);
      case BranchId.yogaStanding:
        check('yoga_standing_complete', newStage >= BranchId.yogaStanding.stageCount);
      case BranchId.yogaOneLeg:
        check('yoga_one_leg_complete', newStage >= BranchId.yogaOneLeg.stageCount);
      case BranchId.yogaBackbends:
        check('yoga_backbends_complete', newStage >= BranchId.yogaBackbends.stageCount);
      case BranchId.yogaFlow:
        check('yoga_flow_complete', newStage >= BranchId.yogaFlow.stageCount);
    }

    // all_complete: every branch at max stage
    final allDone = BranchId.values.every((b) {
      final p = allProgress[b];
      return p != null && p.currentStage >= b.stageCount;
    });
    check('all_complete', allDone);

    return earned;
  }
}

final achievementServiceProvider =
    Provider<AchievementService>((_) => const AchievementService());
