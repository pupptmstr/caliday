import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/enums.dart';
import '../../../data/models/skill_progress.dart';
import '../../../data/models/user_profile.dart';
import '../../../data/repositories/custom_course_repository.dart';
import '../../../data/repositories/skill_progress_repository.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../data/repositories/workout_repository.dart';
import '../../../domain/models/branch.dart';
import '../../../domain/models/course.dart';
import '../../../domain/services/rank_decay_service.dart';
import '../../../domain/services/streak_service.dart';

/// The courses of the Courses tab, in the order of the pills: the built-in
/// ones the user enrolled in, then their own ones that are shown
/// ([CustomCourse.shown]). Invalidate it after the enrollment changes; own
/// courses follow [customCoursesProvider] by themselves.
final enrolledCoursesProvider = Provider<List<Course>>((ref) {
  final profile = ref.watch(userRepositoryProvider).getProfile();
  final own = ref.watch(customBranchesProvider);
  return [
    for (final c in profile.enrolledCourses) BuiltInCourse(c),
    for (final c in ref.watch(customCoursesProvider))
      if (c.shown) OwnCourse(c, own),
  ];
});

/// Currently active course on the Home screen (last selected by the user):
/// the own course of [UserProfile.activeCustomCourseId] while it exists and
/// is shown, otherwise the built-in [UserProfile.activeCourse]. Rebuilt when the own
/// courses or branches change, so an edited course shows its new branches.
class ActiveCourseNotifier extends Notifier<Course> {
  @override
  Course build() {
    final courses = ref.watch(customCoursesProvider);
    final own = ref.watch(customBranchesProvider);
    final profile = ref.read(userRepositoryProvider).getProfile();
    final ownId = profile.activeCustomCourseId;
    final data = courses.where((c) => c.id == ownId && c.shown).firstOrNull;
    if (data != null) return OwnCourse(data, own);
    return BuiltInCourse(profile.activeCourse);
  }

  /// Shows [course] and remembers it in the profile.
  void select(Course course) {
    final repo = ref.read(userRepositoryProvider);
    final profile = repo.getProfile();
    switch (course) {
      case BuiltInCourse(:final id):
        profile.activeCustomCourseId = null;
        final idx = profile.enrolledCourses.indexOf(id);
        if (idx >= 0) profile.activeCourseIndex = idx;
      case OwnCourse(:final data):
        profile.activeCustomCourseId = data.id;
    }
    repo.saveProfile(profile);
    state = course;
  }
}

final activeCourseProvider =
    NotifierProvider<ActiveCourseNotifier, Course>(ActiveCourseNotifier.new);

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
  final Map<Branch, SkillProgress> progressMap;
  final bool hasWorkoutToday;
  final Course activeCourse;

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
  List<Branch> get activeBranches =>
      activeCourse.branchesFor(hasPullUpBar: profile.hasPullUpBar == true);
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
  final courseBranches =
      course.branchesFor(hasPullUpBar: profile.hasPullUpBar == true);
  final progressMap = <Branch, SkillProgress>{
    for (final branch in courseBranches)
      branch: progressRepo.progressFor(branch),
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
