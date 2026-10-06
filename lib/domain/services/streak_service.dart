import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/calendar_days.dart';
import '../../data/models/user_profile.dart';
import '../../data/repositories/user_repository.dart';

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
      final daysSince = calendarDaysBetween(lastDate, today);

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
  ///
  /// [now] is injectable for tests; defaults to the current time.
  int daysSinceLastWorkout(UserProfile profile, {DateTime? now}) {
    final lastDate = profile.lastWorkoutDate;
    if (lastDate == null) return -1;
    return calendarDaysBetween(lastDate, now ?? DateTime.now());
  }

  /// The calendar day on which the current streak is actually gone if the user
  /// does not train again, or null if there is no workout on record.
  ///
  /// Mirrors [applyWorkout] / [displayStreakProvider]: after a workout on day D
  /// the streak survives a workout on D+1, and also on D+2 when a freeze is
  /// available. So it is lost once D+1 (D+2 with a freeze) has passed without
  /// training, i.e. on D+2 (D+3). Returned as a local-midnight date.
  DateTime? streakLostDate(UserProfile profile) {
    final last = profile.lastWorkoutDate;
    if (last == null) return null;
    return addCalendarDays(last, profile.streakFreezeCount > 0 ? 3 : 2);
  }

  static DateTime _dateOnly(DateTime dt) => DateTime(dt.year, dt.month, dt.day);
}

final streakServiceProvider = Provider<StreakService>((_) => const StreakService());

/// Streak value to display in the UI, computed without mutating Hive.
///
/// Rules (Variant A):
/// - days since last workout ≤ 1              → stored streak (all good)
/// - days == 2 and a freeze is available      → stored streak (freeze will
///                                              save it on the next workout)
/// - otherwise                                → 0 (streak is already lost)
final displayStreakProvider = Provider.autoDispose<int>((ref) {
  final profile = ref.read(userRepositoryProvider).getProfile();
  final service = ref.read(streakServiceProvider);
  final days = service.daysSinceLastWorkout(profile);
  if (days <= 1) return profile.currentStreak;
  if (days == 2 && profile.streakFreezeCount > 0) return profile.currentStreak;
  return 0;
});