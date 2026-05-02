import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/enums.dart';
import '../../../data/models/user_profile.dart';
import '../../../data/models/workout_log.dart';
import '../../../data/repositories/achievement_repository.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../data/repositories/workout_repository.dart';
import '../../../domain/services/rank_decay_service.dart';
import '../../../domain/services/streak_service.dart';

/// Snapshot of the data displayed on the Profile screen.
class ProfileData {
  const ProfileData({
    required this.profile,
    required this.totalWorkouts,
    required this.recentLogs,
    required this.displayStreak,
    required this.recentAchievementIds,
    required this.effectiveRank,
    required this.daysSinceLastWorkout,
  });

  final UserProfile profile;
  final int totalWorkouts;

  /// Up to 7 most recent workout logs, newest first.
  final List<WorkoutLog> recentLogs;

  /// Streak value to show in the UI (computed without mutating Hive).
  /// See [displayStreakProvider] for the exact rules.
  final int displayStreak;

  /// Up to 5 most recently earned achievement IDs, newest first.
  final List<String> recentAchievementIds;

  /// Rank to display (may be lower than earned rank due to inactivity decay).
  final Rank effectiveRank;

  /// Days since last workout; -1 if never trained.
  final int daysSinceLastWorkout;

  bool get isRankDecayed => effectiveRank.index < profile.rank.index;
}

final profileDataProvider = Provider.autoDispose<ProfileData>((ref) {
  final userRepo = ref.watch(userRepositoryProvider);
  final workoutRepo = ref.watch(workoutRepositoryProvider);
  final achievementRepo = ref.watch(achievementRepositoryProvider);

  final profile = userRepo.getProfile();
  final allEarned = achievementRepo.getAllEarnedIds();

  final rankDecayService = ref.read(rankDecayServiceProvider);
  final days = rankDecayService.daysSinceLastWorkout(profile);
  final effectiveRank = rankDecayService.effectiveRank(
    profile.rank,
    days.clamp(0, 9999),
  );

  return ProfileData(
    profile: profile,
    totalWorkouts: workoutRepo.totalCount,
    recentLogs: workoutRepo.getRecent(7),
    displayStreak: ref.read(displayStreakProvider),
    recentAchievementIds:
        allEarned.length <= 5 ? allEarned : allEarned.sublist(0, 5),
    effectiveRank: effectiveRank,
    daysSinceLastWorkout: days,
  );
});