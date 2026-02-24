import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/user_profile.dart';
import '../../../data/models/workout_log.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../data/repositories/workout_repository.dart';

/// Snapshot of the data displayed on the Profile screen.
class ProfileData {
  const ProfileData({
    required this.profile,
    required this.totalWorkouts,
    required this.recentLogs,
  });

  final UserProfile profile;
  final int totalWorkouts;

  /// Up to 7 most recent workout logs, newest first.
  final List<WorkoutLog> recentLogs;
}

final profileDataProvider = Provider.autoDispose<ProfileData>((ref) {
  final userRepo = ref.watch(userRepositoryProvider);
  final workoutRepo = ref.watch(workoutRepositoryProvider);

  return ProfileData(
    profile: userRepo.getProfile(),
    totalWorkouts: workoutRepo.totalCount,
    recentLogs: workoutRepo.getRecent(7),
  );
});