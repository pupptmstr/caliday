import 'package:hive_ce/hive_ce.dart';

import 'enums.dart';
import '../static/course_catalog.dart';

part 'user_profile.g.dart';

/// Singleton document stored in Hive under key "profile".
///
/// Contains gamification state (rank, SP, streak) and notification settings.
@HiveType(typeId: 0)
class UserProfile extends HiveObject {
  UserProfile({
    this.rank = Rank.beginner,
    this.totalSP = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.streakFreezeCount = 0,
    this.lastWorkoutDate,
    this.notificationHour = 9,
    this.notificationMinute = 0,
    this.notificationsEnabled = true,
    this.eveningReminderEnabled = true,
    this.streakThreatEnabled = true,
    this.locale,
    this.preferredWorkoutMinutes,
    this.fitnessGoal,
    this.themeModeName,
    this.hasPullUpBar,
    this.soundEnabled,
    this.hapticEnabled,
    this.healthWorkoutsEnabled,
    this.healthWeightEnabled,
    this.displayName,
    this.activeCourseIds,
    this.activeCourseIndex,
    this.lastSeenReleaseVersion,
    this.activeCustomCourseId,
  });

  @HiveField(0)
  Rank rank;

  @HiveField(1)
  int totalSP;

  @HiveField(2)
  int currentStreak;

  @HiveField(3)
  int longestStreak;

  @HiveField(4)
  int streakFreezeCount;

  /// The calendar date (time zeroed) of the most recent completed workout.
  @HiveField(5)
  DateTime? lastWorkoutDate;

  /// Hour for the morning notification (0–23).
  @HiveField(6)
  int notificationHour;

  /// Minute for the morning notification (0–59).
  @HiveField(7)
  int notificationMinute;

  /// Master switch: if false, no notifications are sent.
  @HiveField(8)
  bool notificationsEnabled;

  /// Whether to send an evening reminder if no workout was logged today.
  @HiveField(9)
  bool eveningReminderEnabled;

  /// Whether to send a late-night "streak at risk" notification.
  @HiveField(10)
  bool streakThreatEnabled;

  /// BCP-47 language code for the UI locale. null means 'ru' (default).
  @HiveField(11)
  String? locale;

  /// Preferred workout duration in minutes, chosen during onboarding (5/10/15).
  /// null means the user skipped onboarding or the value was not yet recorded;
  /// the generator treats null as 10 (standard).
  @HiveField(12)
  int? preferredWorkoutMinutes;

  /// Fitness goal chosen during onboarding. null for legacy profiles.
  /// Stored for future use (branch selection, personalised tips).
  @HiveField(13)
  FitnessGoal? fitnessGoal;

  /// User-selected theme mode. null means follow the system setting.
  /// Stored as a string key: 'light' | 'dark' | null (system).
  @HiveField(14)
  String? themeModeName;

  /// Whether the user has a pull-up bar at home.
  /// null means the question was not yet asked (treated as false).
  @HiveField(15)
  bool? hasPullUpBar;

  /// Whether workout sound effects are enabled. null → true (default on).
  @HiveField(19)
  bool? soundEnabled;

  /// Whether haptic feedback is enabled during workouts. null → true (default on).
  @HiveField(20)
  bool? hapticEnabled;

  /// Whether CaliDay writes workouts to Apple Health / Health Connect.
  /// null → false (opt-in feature).
  @HiveField(21)
  bool? healthWorkoutsEnabled;

  /// Whether CaliDay reads body weight from Health for calorie calculations.
  /// null → false (opt-in feature).
  @HiveField(22)
  bool? healthWeightEnabled;

  // HiveFields 17 (peerId) and 23 (bleDiscoverable) belonged to Friends,
  // removed in 0.9.5: never reuse them (older profiles still hold them).

  /// The user's name: the host greets with it on Home, the Profile and the
  /// summary show it. null or empty = not set.
  @HiveField(18)
  String? displayName;

  /// Indices of enrolled [CourseId]s. null → [0] (calisthenics, legacy users);
  /// empty → none: the user trains only their own courses (0.9.6).
  @HiveField(24)
  List<int>? activeCourseIds;

  /// Index within [enrolledCourses] that is currently active on the Home screen.
  /// null → 0 (first enrolled course).
  @HiveField(25)
  int? activeCourseIndex;

  /// The version of the newest "What's new" entry the user has opened (null:
  /// none yet; a new user starts at the current version). Drives the dot on the
  /// bell in the profile.
  @HiveField(26)
  String? lastSeenReleaseVersion;

  /// `CustomCourse.id` of the user's own course shown now; null → the
  /// built-in [activeCourse]. Set when an own course is picked, cleared when a
  /// built-in one is.
  @HiveField(27)
  String? activeCustomCourseId;

  // ── Computed helpers ────────────────────────────────────────────────────────

  List<CourseId> get enrolledCourses {
    final ids = activeCourseIds;
    if (ids == null) return [CourseId.calisthenics];
    return ids
        .where((i) => i >= 0 && i < CourseId.values.length)
        .map((i) => CourseId.values[i])
        .toList();
  }

  /// The built-in course shown now; calisthenics when none is enrolled.
  CourseId get activeCourse {
    final courses = enrolledCourses;
    if (courses.isEmpty) return CourseId.calisthenics;
    final idx = activeCourseIndex ?? 0;
    if (idx < 0 || idx >= courses.length) return courses.first;
    return courses[idx];
  }

  List<BranchId> branchesForCourse(CourseId course) {
    final branches = CourseCatalog.branchesFor(course);
    if (hasPullUpBar != true) {
      return branches.where((b) => !b.requiresEquipment).toList();
    }
    return branches;
  }

  /// All active branches across all enrolled courses (deduped), for QR/stats.
  List<BranchId> get activeBranches {
    final result = <BranchId>[];
    for (final course in enrolledCourses) {
      for (final b in branchesForCourse(course)) {
        if (!result.contains(b)) result.add(b);
      }
    }
    return result;
  }
}