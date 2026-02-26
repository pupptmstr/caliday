import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/user_profile.dart';

/// Manages workout streak logic.
///
/// All methods that mutate [UserProfile] do so in place.
/// The caller is responsible for persisting via [UserRepository].
class StreakService {
  const StreakService();

  /// Updates streak fields on [profile] based on the date a workout occurred.
  ///
  /// - Same day as last workout → no-op (streak already counted).
  /// - Consecutive day → streak increments.
  /// - 1-day gap and a streak freeze available → freeze consumed, streak kept.
  /// - Otherwise → streak resets to 1.
  ///
  /// Returns true if a streak freeze was consumed to preserve the streak.
  bool applyWorkout(UserProfile profile, DateTime workoutDate) {
    final today = _dateOnly(workoutDate);
    final lastDate = profile.lastWorkoutDate != null
        ? _dateOnly(profile.lastWorkoutDate!)
        : null;

    if (lastDate == today) return false; // already counted today

    bool freezeUsed = false;

    if (lastDate == null) {
      // First workout ever
      profile.currentStreak = 1;
    } else {
      final daysSince = today.difference(lastDate).inDays;

      if (daysSince == 1) {
        // Consecutive day
        profile.currentStreak++;
      } else if (daysSince == 2 && profile.streakFreezeCount > 0) {
        // Exactly one day skipped — use a streak freeze
        profile.streakFreezeCount--;
        profile.currentStreak++;
        freezeUsed = true;
      } else {
        // Gap too large or no freeze available
        profile.currentStreak = 1;
      }
    }

    if (profile.currentStreak > profile.longestStreak) {
      profile.longestStreak = profile.currentStreak;
    }

    profile.lastWorkoutDate = today;
    return freezeUsed;
  }

  /// True when the user has an active streak but hasn't trained today yet.
  ///
  /// Used by the notification system to decide whether to fire a reminder.
  bool isStreakAtRisk(UserProfile profile) {
    if (profile.currentStreak == 0) return false;
    final lastDate = profile.lastWorkoutDate;
    if (lastDate == null) return false;
    return _dateOnly(lastDate) != _dateOnly(DateTime.now());
  }

  /// Awards 1 freeze token if the streak just hit a multiple of 7 and the
  /// current freeze count is below the cap of 3.
  ///
  /// Must be called **after** [applyWorkout] so the streak is already updated.
  /// Returns true if a freeze was awarded (caller should persist the profile).
  bool tryAwardFreeze(UserProfile profile) {
    const maxFreezes = 3;
    if (profile.currentStreak > 0 &&
        profile.currentStreak % 7 == 0 &&
        profile.streakFreezeCount < maxFreezes) {
      profile.streakFreezeCount++;
      return true;
    }
    return false;
  }

  /// Number of full calendar days since the last workout, or -1 if never.
  int daysSinceLastWorkout(UserProfile profile) {
    final lastDate = profile.lastWorkoutDate;
    if (lastDate == null) return -1;
    return _dateOnly(DateTime.now()).difference(_dateOnly(lastDate)).inDays;
  }

  static DateTime _dateOnly(DateTime dt) => DateTime(dt.year, dt.month, dt.day);
}

final streakServiceProvider = Provider<StreakService>((_) => const StreakService());