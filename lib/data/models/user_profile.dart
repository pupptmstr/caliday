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
}