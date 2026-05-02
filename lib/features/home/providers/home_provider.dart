import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/enums.dart';
import '../../../data/models/skill_progress.dart';
import '../../../data/models/user_profile.dart';
import '../../../data/repositories/skill_progress_repository.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../data/repositories/workout_repository.dart';
import '../../../domain/services/rank_decay_service.dart';
import '../../../domain/services/streak_service.dart';

/// Currently active course on the Home screen (last selected by the user).
/// Initialized from [UserProfile.activeCourse] and persisted on change.
class ActiveCourseNotifier extends Notifier<CourseId> {
  @override
  CourseId build() => ref.read(userRepositoryProvider).getProfile().activeCourse;

  void set(CourseId course) => state = course;
}

final activeCourseProvider =
    NotifierProvider<ActiveCourseNotifier, CourseId>(ActiveCourseNotifier.new);

/// Snapshot of the data the Home / Library screen needs.
class HomeData {
  const HomeData({
    required this.profile,
    required this.progressMap,
    required this.hasWorkoutToday,
    required this.displayStreak,
    required this.activeCourse,
    required this.effectiveRank,
    required this.daysSinceLastWorkout,
  });

  final UserProfile profile;
  final Map<BranchId, SkillProgress> progressMap;
  final bool hasWorkoutToday;
  final CourseId activeCourse;

  /// Streak value to show in the UI.
  ///
  /// Computed on the fly so we don't mutate Hive when the user simply opens
  /// the app after missing days. Rules (Variant A):
  /// - days since last workout ≤ 1            → stored streak (fine)
  /// - days == 2 and freeze available         → stored streak (freeze will
  ///                                            save it on the next workout)
  /// - otherwise                              → 0 (streak is already gone)
  final int displayStreak;

  /// Rank to display (may be lower than earned rank due to inactivity decay).
  final Rank effectiveRank;

  /// Days since last workout; -1 if never trained.
  final int daysSinceLastWorkout;

  /// Whether the rank is actively decayed (lower than earned).
  bool get isRankDecayed => effectiveRank.index < profile.rank.index;

  /// Branches for the currently active course.
  List<BranchId> get activeBranches =>
      profile.branchesForCourse(activeCourse);
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
  final course = ref.watch(activeCourseProvider);

  final profile = userRepo.getProfile();
  final courseBranches = profile.branchesForCourse(course);
  final progressMap = <BranchId, SkillProgress>{
    for (final branch in courseBranches)
      branch: progressRepo.getProgress(branch),
  };

  final rankDecayService = ref.read(rankDecayServiceProvider);
  final days = rankDecayService.daysSinceLastWorkout(profile);
  final effectiveRank = rankDecayService.effectiveRank(
    profile.rank,
    days.clamp(0, 9999),
  );

  return HomeData(
    profile: profile,
    progressMap: progressMap,
    hasWorkoutToday: workoutRepo.hasPrimaryWorkoutToday(),
    displayStreak: ref.read(displayStreakProvider),
    activeCourse: course,
    effectiveRank: effectiveRank,
    daysSinceLastWorkout: days,
  );
});
