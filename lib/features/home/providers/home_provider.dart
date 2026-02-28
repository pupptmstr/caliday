import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/enums.dart';
import '../../../data/models/skill_progress.dart';
import '../../../data/models/user_profile.dart';
import '../../../data/repositories/skill_progress_repository.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../data/repositories/workout_repository.dart';
import '../../../domain/services/streak_service.dart';

/// Snapshot of the data the Home screen needs.
class HomeData {
  const HomeData({
    required this.profile,
    required this.progressMap,
    required this.hasWorkoutToday,
    required this.displayStreak,
  });

  final UserProfile profile;
  final Map<BranchId, SkillProgress> progressMap;
  final bool hasWorkoutToday;

  /// Streak value to show in the UI.
  ///
  /// Computed on the fly so we don't mutate Hive when the user simply opens
  /// the app after missing days. Rules (Variant A):
  /// - days since last workout ≤ 1            → stored streak (fine)
  /// - days == 2 and freeze available         → stored streak (freeze will
  ///                                            save it on the next workout)
  /// - otherwise                              → 0 (streak is already gone)
  final int displayStreak;

  /// Active branches for this user, from [UserProfile.activeBranches].
  List<BranchId> get activeBranches => profile.activeBranches;
}

/// Reads all home-screen data from repositories in one shot.
///
/// Uses [Provider.autoDispose] so the cache is invalidated when the screen
/// is removed from the tree (e.g. after a workout completes and the user
/// returns via [context.go]).
final homeDataProvider = Provider.autoDispose<HomeData>((ref) {
  final userRepo = ref.watch(userRepositoryProvider);
  final progressRepo = ref.watch(skillProgressRepositoryProvider);
  final workoutRepo = ref.watch(workoutRepositoryProvider);

  final profile = userRepo.getProfile();
  final progressMap = <BranchId, SkillProgress>{
    for (final branch in profile.activeBranches)
      branch: progressRepo.getProgress(branch),
  };

  return HomeData(
    profile: profile,
    progressMap: progressMap,
    hasWorkoutToday: workoutRepo.hasWorkoutToday(),
    displayStreak: ref.read(displayStreakProvider),
  );
});
