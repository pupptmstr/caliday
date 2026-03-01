import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/user_profile.dart';
import '../../../data/models/workout_log.dart';
import '../../../data/repositories/achievement_repository.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../data/repositories/workout_repository.dart';
import '../../../domain/services/streak_service.dart';

/// Snapshot of the data displayed on the Profile screen.
class ProfileData {
  const ProfileData({
    required this.profile,
    required this.totalWorkouts,
    required this.recentLogs,
    required this.displayStreak,
    required this.recentAchievementIds,
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
}

final profileDataProvider = Provider.autoDispose<ProfileData>((ref) {
  final userRepo = ref.watch(userRepositoryProvider);
  final workoutRepo = ref.watch(workoutRepositoryProvider);
  final achievementRepo = ref.watch(achievementRepositoryProvider);

  final allEarned = achievementRepo.getAllEarnedIds();
  return ProfileData(
    profile: userRepo.getProfile(),
    totalWorkouts: workoutRepo.totalCount,
    recentLogs: workoutRepo.getRecent(7),
    displayStreak: ref.read(displayStreakProvider),
    recentAchievementIds:
        allEarned.length <= 5 ? allEarned : allEarned.sublist(0, 5),
  );
});