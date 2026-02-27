import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/enums.dart';
import '../../../data/models/skill_progress.dart';
import '../../../data/models/user_profile.dart';
import '../../../data/repositories/skill_progress_repository.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../data/repositories/workout_repository.dart';
import '../../../data/static/exercise_catalog.dart';
import '../../../domain/services/streak_service.dart';

/// Snapshot of the data the Home screen needs.
class HomeData {
  const HomeData({
    required this.profile,
    required this.pushProgress,
    required this.coreProgress,
    required this.hasWorkoutToday,
    required this.displayStreak,
  });

  final UserProfile profile;
  final SkillProgress pushProgress;
  final SkillProgress coreProgress;
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

  /// Display name of the current Push exercise.
  String get pushExerciseName =>
      ExerciseCatalog.forStage(BranchId.push, pushProgress.currentStage)
          ?.name ??
      '—';

  /// Display name of the current Core exercise.
  String get coreExerciseName =>
      ExerciseCatalog.forStage(BranchId.core, coreProgress.currentStage)
          ?.name ??
      '—';
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

  return HomeData(
    profile: userRepo.getProfile(),
    pushProgress: progressRepo.getProgress(BranchId.push),
    coreProgress: progressRepo.getProgress(BranchId.core),
    hasWorkoutToday: workoutRepo.hasWorkoutToday(),
    displayStreak: ref.read(displayStreakProvider),
  );
});