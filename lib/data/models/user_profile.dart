import 'package:hive/hive.dart';

import 'enums.dart';

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

  /// Ordered list of branches active for this user.
  List<BranchId> get activeBranches => [
        BranchId.push,
        if (hasPullUpBar == true) BranchId.pull,
        BranchId.core,
        BranchId.legs,
        BranchId.balance,
      ];
}