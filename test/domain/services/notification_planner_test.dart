import 'package:caliday/data/models/user_profile.dart';
import 'package:caliday/domain/services/notification_planner.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

late tz.Location berlin;

/// A moment on the Berlin wall clock (Europe/Berlin: DST starts 2026-03-29,
/// ends 2026-10-25).
tz.TZDateTime at(int y, int m, int d, [int h = 0, int min = 0]) =>
    tz.TZDateTime(berlin, y, m, d, h, min);

/// Checks the wall-clock reading of [actual] rather than the instant, which is
/// what a "9 o'clock reminder" is about.
void expectWall(tz.TZDateTime actual, int y, int m, int d, int h, int min,
    {String? reason}) {
  expect(
    [actual.year, actual.month, actual.day, actual.hour, actual.minute],
    [y, m, d, h, min],
    reason: reason ?? 'wall clock of $actual',
  );
}

UserProfile profile({
  bool enabled = true,
  bool evening = true,
  bool threat = true,
  int hour = 9,
  int minute = 0,
  String? locale,
  int streak = 0,
  int freezes = 0,
  DateTime? last,
}) =>
    UserProfile(
      notificationsEnabled: enabled,
      eveningReminderEnabled: evening,
      streakThreatEnabled: threat,
      notificationHour: hour,
      notificationMinute: minute,
      locale: locale,
      currentStreak: streak,
      streakFreezeCount: freezes,
      lastWorkoutDate: last,
    );

void main() {
  const planner = NotificationPlanner();

  setUpAll(() {
    tzdata.initializeTimeZones();
    berlin = tz.getLocation('Europe/Berlin');
  });

  group('planAll: the daily reminders', () {
    test('nothing at all when notifications are off', () {
      expect(planner.planAll(profile(enabled: false), at(2026, 6, 10, 8)), isEmpty);
      // not even the one-off alerts
      final p = profile(enabled: false, streak: 5, last: DateTime(2026, 6, 10));
      expect(planner.planAll(p, at(2026, 6, 10, 12)), isEmpty);
    });

    test('morning, evening and streak threat by default, all repeating', () {
      final plan = planner.planAll(profile(), at(2026, 6, 10, 8));
      expect(plan.map((n) => n.kind), [
        NotificationKind.morning,
        NotificationKind.evening,
        NotificationKind.streakThreat,
      ]);
      expect(plan.every((n) => n.repeatsDaily), isTrue);
      expectWall(plan[0].when, 2026, 6, 10, 9, 0);
      expectWall(plan[1].when, 2026, 6, 10, 20, 0);
      expectWall(plan[2].when, 2026, 6, 10, 22, 0);
    });

    test('the switches for the evening reminder and the streak threat', () {
      final now = at(2026, 6, 10, 8);
      expect(planner.planAll(profile(evening: false), now).map((n) => n.kind),
          [NotificationKind.morning, NotificationKind.streakThreat]);
      expect(planner.planAll(profile(threat: false), now).map((n) => n.kind),
          [NotificationKind.morning, NotificationKind.evening]);
      expect(
          planner
              .planAll(profile(evening: false, threat: false), now)
              .map((n) => n.kind),
          [NotificationKind.morning]);
    });

    test('the morning reminder follows the chosen time', () {
      final plan = planner.planAll(profile(hour: 7, minute: 45), at(2026, 6, 10, 6));
      expectWall(plan.first.when, 2026, 6, 10, 7, 45);
    });

    test('a time that has passed today starts tomorrow, the others today', () {
      final plan = planner.planAll(profile(), at(2026, 6, 10, 21));
      expectWall(plan[0].when, 2026, 6, 11, 9, 0, reason: 'morning');
      expectWall(plan[1].when, 2026, 6, 11, 20, 0, reason: 'evening');
      expectWall(plan[2].when, 2026, 6, 10, 22, 0, reason: 'streak threat');
    });

    test('exactly now counts as still ahead', () {
      final plan = planner.planAll(profile(), at(2026, 6, 10, 9));
      expectWall(plan.first.when, 2026, 6, 10, 9, 0);
    });

    test('at the end of a month tomorrow is the first of the next', () {
      final plan = planner.planAll(profile(), at(2026, 6, 30, 23, 30));
      expectWall(plan.first.when, 2026, 7, 1, 9, 0);
    });
  });

  group('the daily reminders stay on the wall clock across DST', () {
    // A repeating reminder takes its time of day from the first date. Planned
    // as "now + 24 h" it would land an hour off on a DST change and stay there.
    test('spring: the evening before the clocks go forward', () {
      final plan = planner.planAll(profile(), at(2026, 3, 28, 22, 30));
      expectWall(plan[0].when, 2026, 3, 29, 9, 0, reason: 'morning');
      expectWall(plan[1].when, 2026, 3, 29, 20, 0, reason: 'evening');
      expectWall(plan[2].when, 2026, 3, 29, 22, 0, reason: 'streak threat');
    });

    test('autumn: the evening before the clocks go back', () {
      final plan = planner.planAll(profile(), at(2026, 10, 24, 22, 30));
      expectWall(plan[0].when, 2026, 10, 25, 9, 0, reason: 'morning');
      expectWall(plan[1].when, 2026, 10, 25, 20, 0, reason: 'evening');
    });

    test('NotificationPlanner.nextInstanceOf directly', () {
      expectWall(
          NotificationPlanner.nextInstanceOf(at(2026, 3, 28, 12), 9, 0),
          2026, 3, 29, 9, 0);
      expectWall(
          NotificationPlanner.nextInstanceOf(at(2026, 10, 24, 12), 9, 0),
          2026, 10, 25, 9, 0);
    });

    test('a wall time that does not exist (02:30 on the spring change) still works', () {
      final when = NotificationPlanner.nextInstanceOf(at(2026, 3, 28, 12), 2, 30);
      expect(when.isAfter(at(2026, 3, 28, 12)), isTrue);
      expect(when.day, 29);
    });
  });

  group('other time zones', () {
    for (final (name, expected) in [
      ('America/New_York', 'New_York'),
      ('Asia/Kolkata', 'Kolkata'), // +5:30
      ('Pacific/Auckland', 'Auckland'), // the other hemisphere
      ('UTC', 'UTC'),
    ]) {
      test(name, () {
        final zone = tz.getLocation(name);
        final now = tz.TZDateTime(zone, 2026, 6, 10, 21);
        final plan = planner.planAll(profile(), now);
        expect(plan.first.when.location.name, name);
        expect(plan.first.when.location.name, contains(expected));
        expectWall(plan.first.when, 2026, 6, 11, 9, 0);
        expectWall(plan[2].when, 2026, 6, 10, 22, 0);
      });
    }
  });

  group('texts', () {
    test('Russian by default and for an unknown locale, English on request', () {
      final ru = planner.planAll(profile(), at(2026, 6, 10, 8)).first;
      expect(ru.title, notificationStrings['ru']!['morningTitle']);
      expect(planner.planAll(profile(locale: 'fr'), at(2026, 6, 10, 8)).first.title,
          ru.title);
      final en = planner.planAll(profile(locale: 'en'), at(2026, 6, 10, 8)).first;
      expect(en.title, notificationStrings['en']!['morningTitle']);
      expect(en.body, notificationStrings['en']!['morningBody']);
    });

    test('Russian and English have exactly the same keys', () {
      expect(notificationStrings['ru']!.keys.toSet(),
          notificationStrings['en']!.keys.toSet());
    });

    test('no text is empty and the streak text has its {days} placeholder', () {
      for (final locale in notificationStrings.keys) {
        final strings = notificationStrings[locale]!;
        for (final entry in strings.entries) {
          expect(entry.value.trim(), isNotEmpty, reason: '$locale ${entry.key}');
        }
        expect(strings['streakLostBody'], contains('{days}'), reason: locale);
      }
    });

    test('no text promises how long a workout takes', () {
      // The time depends on the size and the progress of the day, and a
      // notification is written long before it (see WorkoutSize). The shown
      // estimate lives on the Home button instead.
      final promise = RegExp(r'\d+\s*(min|мин)', caseSensitive: false);
      for (final locale in notificationStrings.keys) {
        for (final entry in notificationStrings[locale]!.entries) {
          expect(promise.hasMatch(entry.value), isFalse,
              reason: '$locale ${entry.key}: ${entry.value}');
        }
      }
    });

    test('every key the planner reads exists', () {
      // Run every kind of notification through both languages.
      for (final locale in ['ru', 'en']) {
        final p = profile(locale: locale, streak: 5, last: DateTime(2026, 6, 10));
        final plan = planner.planAll(p, at(2026, 6, 10, 12));
        expect(plan.map((n) => n.kind).toSet(), NotificationKind.values.toSet(),
            reason: locale);
      }
    });
  });

  group('the one-off streak-lost alert', () {
    PlannedNotification? alert(UserProfile p, tz.TZDateTime now) =>
        planner.streakLost(p, now);

    test('two days after the last workout, 30 minutes after the reminder', () {
      final n = alert(profile(streak: 5, last: DateTime(2026, 6, 10)),
          at(2026, 6, 10, 12))!;
      expect(n.kind, NotificationKind.streakLost);
      expectWall(n.when, 2026, 6, 12, 9, 30);
      expect(n.repeatsDaily, isFalse);
    });

    test('with a streak freeze the streak lives one day longer', () {
      final n = alert(profile(streak: 5, freezes: 1, last: DateTime(2026, 6, 10)),
          at(2026, 6, 10, 12))!;
      expectWall(n.when, 2026, 6, 13, 9, 30);
    });

    test('the 30 minutes carry into the next hour', () {
      expectWall(
          alert(profile(streak: 5, hour: 9, minute: 45, last: DateTime(2026, 6, 10)),
                  at(2026, 6, 10, 12))!
              .when,
          2026, 6, 12, 10, 15);
    });

    test('a reminder late in the evening falls back to 09:30, not into the next day',
        () {
      // 23:45 + 30 min would be 00:15 tomorrow.
      expectWall(
          alert(profile(streak: 5, hour: 23, minute: 45, last: DateTime(2026, 6, 10)),
                  at(2026, 6, 10, 12))!
              .when,
          2026, 6, 12, 9, 30);
      expectWall(
          alert(profile(streak: 5, hour: 23, minute: 20, last: DateTime(2026, 6, 10)),
                  at(2026, 6, 10, 12))!
              .when,
          2026, 6, 12, 23, 50);
    });

    test('a streak under two days is not worth an alert', () {
      expect(alert(profile(streak: 1, last: DateTime(2026, 6, 10)), at(2026, 6, 10, 12)),
          isNull);
      expect(alert(profile(streak: 0, last: DateTime(2026, 6, 10)), at(2026, 6, 10, 12)),
          isNull);
      expect(alert(profile(streak: 2, last: DateTime(2026, 6, 10)), at(2026, 6, 10, 12)),
          isNotNull);
    });

    test('no workout on record, or notifications off', () {
      expect(alert(profile(streak: 5), at(2026, 6, 10, 12)), isNull);
      expect(
          alert(profile(enabled: false, streak: 5, last: DateTime(2026, 6, 10)),
              at(2026, 6, 10, 12)),
          isNull);
    });

    test('nothing once that moment has passed', () {
      final p = profile(streak: 5, last: DateTime(2026, 6, 10));
      expect(alert(p, at(2026, 6, 12, 9, 29)), isNotNull);
      expect(alert(p, at(2026, 6, 12, 9, 30)), isNull);
      expect(alert(p, at(2026, 6, 20, 8)), isNull);
    });

    test('the text carries the streak length, in both languages', () {
      final ru = alert(profile(streak: 12, last: DateTime(2026, 6, 10)),
          at(2026, 6, 10, 12))!;
      expect(ru.body, contains('12'));
      expect(ru.body, isNot(contains('{days}')));
      final en = alert(profile(locale: 'en', streak: 12, last: DateTime(2026, 6, 10)),
          at(2026, 6, 10, 12))!;
      expect(en.body, contains('12-day'));
    });

    test('across the DST change it still fires at 09:30 local time', () {
      // Trained Fri 2026-03-27 -> lost on Sun 03-29, the day the clocks change.
      final n = alert(profile(streak: 5, last: DateTime(2026, 3, 27)),
          at(2026, 3, 27, 12))!;
      expectWall(n.when, 2026, 3, 29, 9, 30);
    });
  });

  group('the one-off rank-at-risk alert', () {
    PlannedNotification? alert(UserProfile p, tz.TZDateTime now) =>
        planner.rankAtRisk(p, now);

    test('14 days after the last workout, at the reminder time', () {
      final n = alert(profile(last: DateTime(2026, 6, 10)), at(2026, 6, 10, 12))!;
      expect(n.kind, NotificationKind.rankAtRisk);
      expectWall(n.when, 2026, 6, 24, 9, 0);
      expect(n.repeatsDaily, isFalse);
    });

    test('counts from the last workout, not from today', () {
      final n = alert(profile(last: DateTime(2026, 6, 5)), at(2026, 6, 10, 12))!;
      expectWall(n.when, 2026, 6, 19, 9, 0);
    });

    test('the last day before it applies is tomorrow; after that nothing', () {
      expectWall(
          alert(profile(last: DateTime(2026, 6, 10)), at(2026, 6, 23, 12))!.when,
          2026, 6, 24, 9, 0);
      expect(alert(profile(last: DateTime(2026, 6, 10)), at(2026, 6, 24, 12)), isNull);
      expect(alert(profile(last: DateTime(2026, 6, 10)), at(2026, 7, 30, 12)), isNull);
    });

    test('no workout on record, or notifications off', () {
      expect(alert(profile(), at(2026, 6, 10, 12)), isNull);
      expect(alert(profile(enabled: false, last: DateTime(2026, 6, 10)),
              at(2026, 6, 10, 12)),
          isNull);
    });

    test('across a DST change the 14 days are 14 calendar days', () {
      final n = alert(profile(last: DateTime(2026, 3, 20)), at(2026, 3, 20, 12))!;
      expectWall(n.when, 2026, 4, 3, 9, 0);
    });

    test('uses the reminder time and the language of the profile', () {
      final n = alert(profile(hour: 7, minute: 15, locale: 'en', last: DateTime(2026, 6, 10)),
          at(2026, 6, 10, 12))!;
      expectWall(n.when, 2026, 6, 24, 7, 15);
      expect(n.title, notificationStrings['en']!['rankAtRiskTitle']);
    });
  });

  group('the whole plan', () {
    test('contains the one-off alerts when they apply, after the daily ones', () {
      final p = profile(streak: 5, last: DateTime(2026, 6, 10));
      final plan = planner.planAll(p, at(2026, 6, 10, 12));
      expect(plan.map((n) => n.kind), [
        NotificationKind.morning,
        NotificationKind.evening,
        NotificationKind.streakThreat,
        NotificationKind.streakLost,
        NotificationKind.rankAtRisk,
      ]);
    });

    test('notification ids and channels are unique and the ids never change', () {
      expect(NotificationKind.values.map((k) => k.id), [1, 2, 3, 4, 5]);
      expect(NotificationKind.values.map((k) => k.channelId).toSet(), hasLength(5));
      expect(NotificationKind.values.map((k) => k.channelName).toSet(), hasLength(5));
    });

    test('every planned notification is in the future', () {
      final now = at(2026, 6, 10, 12);
      final plan = planner.planAll(
          profile(streak: 5, last: DateTime(2026, 6, 8)), now);
      for (final n in plan) {
        expect(n.when.isBefore(now), isFalse, reason: '${n.kind}');
      }
    });
  });
}
