import 'package:timezone/timezone.dart' as tz;

import '../../data/models/user_profile.dart';
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
    final strings = stringsFor(profile.locale);

    PlannedNotification daily(NotificationKind kind, int hour, int minute,
            String titleKey, String bodyKey) =>
        PlannedNotification(
          kind: kind,
          title: strings[titleKey]!,
          body: strings[bodyKey]!,
          when: nextInstanceOf(now, hour, minute),
          repeatsDaily: true,
        );

    return [
      daily(NotificationKind.morning, profile.notificationHour,
          profile.notificationMinute, 'morningTitle', 'morningBody'),
      if (profile.eveningReminderEnabled)
        daily(NotificationKind.evening, eveningHour, 0, 'eveningTitle',
            'eveningBody'),
      if (profile.streakThreatEnabled)
        daily(NotificationKind.streakThreat, streakThreatHour, 0,
            'streakTitle', 'streakBody'),
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

    final strings = stringsFor(profile.locale);
    return PlannedNotification(
      kind: NotificationKind.streakLost,
      title: strings['streakLostTitle']!,
      body: strings['streakLostBody']!
          .replaceAll('{days}', '${profile.currentStreak}'),
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

    final strings = stringsFor(profile.locale);
    return PlannedNotification(
      kind: NotificationKind.rankAtRisk,
      title: strings['rankAtRiskTitle']!,
      body: strings['rankAtRiskBody']!,
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

  /// The texts for [locale]; anything but 'en' and 'ru' (and null) gets Russian.
  static Map<String, String> stringsFor(String? locale) =>
      notificationStrings[locale ?? 'ru'] ?? notificationStrings['ru']!;
}

/// Notification texts. They live here, not in the .arb files, because a
/// notification is scheduled without a BuildContext.
const notificationStrings = {
  'ru': {
    'morningTitle': 'Время тренироваться! 💪',
    'morningBody': 'Твоя ежедневная тренировка ждёт. Не прерывай серию!',
    'eveningTitle': 'Ещё не поздно! 🏃',
    'eveningBody': 'Ты сегодня ещё не тренировался. Займёт всего 10 минут.',
    'streakTitle': 'Серия под угрозой! 🔥',
    'streakBody': 'Успей потренироваться до полуночи — иначе серия прервётся.',
    'streakLostTitle': 'Серия прервалась 😔',
    'streakLostBody': 'Твой стрик {days} дней пропал. Начни новую серию — первый шаг всегда самый важный!',
    'rankAtRiskTitle': 'Ранг под угрозой! ⚠️',
    'rankAtRiskBody': '14 дней без тренировок — ранг начнёт снижаться через неделю. Вернись!',
  },
  'en': {
    'morningTitle': 'Time to work out! 💪',
    'morningBody': 'Your daily workout is waiting. Keep the streak alive!',
    'eveningTitle': 'Still time! 🏃',
    'eveningBody': "You haven't trained today yet. It only takes 10 minutes.",
    'streakTitle': 'Streak at risk! 🔥',
    'streakBody': 'Work out before midnight or your streak will end.',
    'streakLostTitle': 'Streak is gone 😔',
    'streakLostBody': 'Your {days}-day streak is gone. Start a new one — the first step is always the hardest!',
    'rankAtRiskTitle': 'Rank at risk! ⚠️',
    'rankAtRiskBody': '14 days without training — your rank will start dropping soon. Come back!',
  },
};
