import 'package:timezone/timezone.dart' as tz;

import '../../core/l10n/app_languages.dart';
import '../../data/models/user_profile.dart';
import '../../l10n/app_localizations.dart';
import 'rank_decay_service.dart';
import 'streak_service.dart';

/// The notifications CaliDay can schedule. The ids are stable (they identify a
/// notification to cancel or replace) — never renumber them.
enum NotificationKind {
  morning(1, 'morning', 'Morning reminder'),
  evening(2, 'evening', 'Evening reminder'),
  streakThreat(3, 'streak', 'Streak threat'),
  streakLost(4, 'streak_lost', 'Streak lost'),
  rankAtRisk(5, 'rank_risk', 'Rank at risk');

  const NotificationKind(this.id, this.channelId, this.channelName);

  final int id;
  final String channelId;
  final String channelName;
}

/// One notification to hand to the OS.
class PlannedNotification {
  const PlannedNotification({
    required this.kind,
    required this.title,
    required this.body,
    required this.when,
    this.repeatsDaily = false,
  });

  final NotificationKind kind;
  final String title;
  final String body;

  /// The first time it fires, in the zone it was planned in.
  final tz.TZDateTime when;

  /// True: it fires every day at this time of day (the date only says where to
  /// start). False: it fires once.
  final bool repeatsDaily;
}

/// Decides what to schedule and when. Pure: the current time (with its time
/// zone) comes in as a parameter, so every case — time zones, DST, flags — can
/// be tested without a device. NotificationService only hands the result to the
/// plugin.
class NotificationPlanner {
  const NotificationPlanner();

  static const eveningHour = 20;
  static const streakThreatHour = 22;

  /// The streak-lost alert comes this long after the morning reminder.
  static const streakLostDelayMinutes = 30;

  /// Everything that should be scheduled for [profile] as of [now]. Empty when
  /// notifications are switched off.
  List<PlannedNotification> planAll(UserProfile profile, tz.TZDateTime now) {
    if (!profile.notificationsEnabled) return const [];
    final texts = textsFor(profile.locale);

    PlannedNotification daily(NotificationKind kind, int hour, int minute,
            String title, String body) =>
        PlannedNotification(
          kind: kind,
          title: title,
          body: body,
          when: nextInstanceOf(now, hour, minute),
          repeatsDaily: true,
        );

    return [
      daily(NotificationKind.morning, profile.notificationHour,
          profile.notificationMinute, texts.notificationMorningTitle,
          texts.notificationMorningBody),
      if (profile.eveningReminderEnabled)
        daily(NotificationKind.evening, eveningHour, 0,
            texts.notificationEveningTitle, texts.notificationEveningBody),
      if (profile.streakThreatEnabled)
        daily(NotificationKind.streakThreat, streakThreatHour, 0,
            texts.notificationStreakTitle, texts.notificationStreakBody),
      ?streakLost(profile, now),
      ?rankAtRisk(profile, now),
    ];
  }

  /// "Your streak is gone", once, on the morning of the day the streak is
  /// really lost ([StreakService.streakLostDate]), [streakLostDelayMinutes]
  /// after the morning reminder. Null when notifications are off, the streak is
  /// shorter than 2 (losing a 1-day streak is not worth an alert), there is no
  /// workout on record, or that moment has already passed.
  PlannedNotification? streakLost(UserProfile profile, tz.TZDateTime now) {
    if (!profile.notificationsEnabled) return null;
    if (profile.currentStreak < 2) return null;
    final lostOn = const StreakService().streakLostDate(profile);
    if (lostOn == null) return null;

    var hour = profile.notificationHour;
    var minute = profile.notificationMinute + streakLostDelayMinutes;
    if (minute >= 60) {
      hour += 1;
      minute -= 60;
    }
    // A reminder late in the evening would push this past midnight; fall back
    // to a fixed morning time instead of landing on the next day.
    if (hour >= 24) {
      hour = 9;
      minute = 30;
    }

    final fireAt = tz.TZDateTime(
        now.location, lostOn.year, lostOn.month, lostOn.day, hour, minute);
    if (!fireAt.isAfter(now)) return null;

    final texts = textsFor(profile.locale);
    return PlannedNotification(
      kind: NotificationKind.streakLost,
      title: texts.notificationStreakLostTitle,
      body: texts.notificationStreakLostBody(profile.currentStreak),
      when: fireAt,
    );
  }

  /// "Your rank is about to drop", once, [RankDecayService.warningDays] after
  /// the last workout, at the morning reminder time. Null when notifications
  /// are off, there is no workout on record, or that day has already come.
  PlannedNotification? rankAtRisk(UserProfile profile, tz.TZDateTime now) {
    if (!profile.notificationsEnabled) return null;
    if (profile.lastWorkoutDate == null) return null;

    final daysSince =
        const RankDecayService().daysSinceLastWorkout(profile, now: now);
    final daysUntilRisk = RankDecayService.warningDays - daysSince;
    if (daysUntilRisk <= 0) return null;

    final texts = textsFor(profile.locale);
    return PlannedNotification(
      kind: NotificationKind.rankAtRisk,
      title: texts.notificationRankAtRiskTitle,
      body: texts.notificationRankAtRiskBody,
      when: tz.TZDateTime(
        now.location,
        now.year,
        now.month,
        now.day + daysUntilRisk,
        profile.notificationHour,
        profile.notificationMinute,
      ),
    );
  }

  /// The next moment it is [hour]:[minute] on the wall clock of [now]'s zone:
  /// today if that is still ahead, otherwise tomorrow.
  ///
  /// Tomorrow is a calendar date, not "24 hours later": on a DST change a day
  /// is 23 or 25 hours long, and a repeating reminder planned with `+ 24 h`
  /// would land an hour off and stay there.
  static tz.TZDateTime nextInstanceOf(tz.TZDateTime now, int hour, int minute) {
    final today =
        tz.TZDateTime(now.location, now.year, now.month, now.day, hour, minute);
    if (!today.isBefore(now)) return today;
    return tz.TZDateTime(
        now.location, now.year, now.month, now.day + 1, hour, minute);
  }

  /// The notification texts (the ARB files) for [locale]: Russian when the
  /// profile has none (the default of [UserProfile.locale]), English for a
  /// language the app is not translated into.
  static AppLocalizations textsFor(String? locale) => l10nFor(locale ?? 'ru');
}
