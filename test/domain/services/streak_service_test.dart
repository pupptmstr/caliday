import 'package:caliday/data/models/user_profile.dart';
import 'package:caliday/domain/services/streak_service.dart';
import 'package:flutter_test/flutter_test.dart';

/// The DST cases are about Europe/Berlin (clocks go forward on 2026-03-29,
/// back on 2026-10-25). On a machine in a zone without DST they pass trivially.
void main() {
  const service = StreakService();

  UserProfile profile({
    DateTime? last,
    int streak = 0,
    int longest = 0,
    int freezes = 0,
  }) =>
      UserProfile(
        lastWorkoutDate: last,
        currentStreak: streak,
        longestStreak: longest,
        streakFreezeCount: freezes,
      );

  group('applyWorkout', () {
    test('first workout ever starts the streak at 1', () {
      final p = profile();
      final freezeUsed = service.applyWorkout(p, DateTime(2026, 6, 10, 18, 30));
      expect(freezeUsed, isFalse);
      expect(p.currentStreak, 1);
      expect(p.longestStreak, 1);
      expect(p.lastWorkoutDate, DateTime(2026, 6, 10));
    });

    test('a second workout on the same day changes nothing', () {
      final p = profile(last: DateTime(2026, 6, 10), streak: 4, longest: 4);
      expect(service.applyWorkout(p, DateTime(2026, 6, 10, 21, 5)), isFalse);
      expect(p.currentStreak, 4);
    });

    test('the next day extends the streak and updates the record', () {
      final p = profile(last: DateTime(2026, 6, 10), streak: 4, longest: 4);
      service.applyWorkout(p, DateTime(2026, 6, 11, 8));
      expect(p.currentStreak, 5);
      expect(p.longestStreak, 5);
      expect(p.lastWorkoutDate, DateTime(2026, 6, 11));
    });

    test('a one-day gap without a freeze resets the streak', () {
      final p = profile(last: DateTime(2026, 6, 10), streak: 4, longest: 9);
      service.applyWorkout(p, DateTime(2026, 6, 12, 8));
      expect(p.currentStreak, 1);
      expect(p.longestStreak, 9);
    });

    test('a one-day gap with a freeze consumes it and keeps the streak', () {
      final p = profile(
          last: DateTime(2026, 6, 10), streak: 4, longest: 4, freezes: 2);
      final freezeUsed = service.applyWorkout(p, DateTime(2026, 6, 12, 8));
      expect(freezeUsed, isTrue);
      expect(p.streakFreezeCount, 1);
      expect(p.currentStreak, 5);
    });

    test('a two-day gap resets even with a freeze, and keeps the freeze', () {
      final p = profile(last: DateTime(2026, 6, 10), streak: 4, freezes: 2);
      final freezeUsed = service.applyWorkout(p, DateTime(2026, 6, 13, 8));
      expect(freezeUsed, isFalse);
      expect(p.streakFreezeCount, 2);
      expect(p.currentStreak, 1);
    });

    group('across a DST change', () {
      // Elapsed time between two local midnights is 23 h / 25 h on these days.
      test('training on the spring DST day and the day after keeps the streak',
          () {
        // 2026-03-29 has 23 hours; the two local midnights are not 24 h apart.
        final p = profile(last: DateTime(2026, 3, 29), streak: 5, longest: 5);
        service.applyWorkout(p, DateTime(2026, 3, 30, 7));
        expect(p.currentStreak, 6);
      });

      test('a one-day gap over the spring DST day still uses the freeze', () {
        final p = profile(last: DateTime(2026, 3, 28), streak: 5, freezes: 1);
        final freezeUsed = service.applyWorkout(p, DateTime(2026, 3, 30, 7));
        expect(freezeUsed, isTrue);
        expect(p.streakFreezeCount, 0);
        expect(p.currentStreak, 6);
      });

      test('a one-day gap that ends on the spring DST day uses the freeze', () {
        final p = profile(last: DateTime(2026, 3, 27), streak: 5, freezes: 1);
        final freezeUsed = service.applyWorkout(p, DateTime(2026, 3, 29, 20));
        expect(freezeUsed, isTrue);
        expect(p.currentStreak, 6);
      });

      test('the autumn DST day and the day after keep the streak', () {
        final p = profile(last: DateTime(2026, 10, 25), streak: 5, longest: 5);
        service.applyWorkout(p, DateTime(2026, 10, 26, 7));
        expect(p.currentStreak, 6);
      });
    });
  });

  group('daysSinceLastWorkout', () {
    int daysBetween(DateTime last, DateTime now) =>
        service.daysSinceLastWorkout(profile(last: last), now: now);

    test('is -1 when the user has never trained', () {
      expect(service.daysSinceLastWorkout(profile()), -1);
    });

    test('counts calendar days, also across the DST changes', () {
      expect(daysBetween(DateTime(2026, 6, 10), DateTime(2026, 6, 10, 23)), 0);
      expect(daysBetween(DateTime(2026, 3, 29), DateTime(2026, 3, 30, 8)), 1);
      expect(daysBetween(DateTime(2026, 3, 20), DateTime(2026, 4, 3, 8)), 14);
      expect(daysBetween(DateTime(2026, 10, 20), DateTime(2026, 11, 3, 8)), 14);
    });
  });

  group('streakLostDate', () {
    test('is null when there is no workout on record', () {
      expect(service.streakLostDate(profile()), isNull);
    });

    test('without a freeze the streak is gone two days after the workout', () {
      // Trained on the 10th: the 11th can still save it, the 12th is too late.
      expect(service.streakLostDate(profile(last: DateTime(2026, 6, 10))),
          DateTime(2026, 6, 12));
    });

    test('with a freeze it survives one more day', () {
      expect(
          service
              .streakLostDate(profile(last: DateTime(2026, 6, 10), freezes: 1)),
          DateTime(2026, 6, 13));
    });

    test('crosses month ends and the DST change without drifting', () {
      expect(service.streakLostDate(profile(last: DateTime(2026, 6, 29))),
          DateTime(2026, 7, 1));
      expect(service.streakLostDate(profile(last: DateTime(2026, 3, 28))),
          DateTime(2026, 3, 30));
      expect(
          service
              .streakLostDate(profile(last: DateTime(2026, 3, 28), freezes: 2)),
          DateTime(2026, 3, 31));
    });

    test('agrees with applyWorkout: a workout on that day no longer saves it',
        () {
      for (final freezes in [0, 1]) {
        final last = DateTime(2026, 3, 27);
        final p = profile(last: last, streak: 5, freezes: freezes);
        final lost = service.streakLostDate(p)!;
        // The day before the loss date still keeps the streak ...
        final saved = profile(last: last, streak: 5, freezes: freezes);
        service.applyWorkout(saved, DateTime(lost.year, lost.month, lost.day - 1));
        expect(saved.currentStreak, 6, reason: 'freezes=$freezes');
        // ... and on the loss date it is reset.
        final reset = profile(last: last, streak: 5, freezes: freezes);
        service.applyWorkout(reset, lost);
        expect(reset.currentStreak, 1, reason: 'freezes=$freezes');
      }
    });
  });

  group('tryAwardFreeze', () {
    test('awards a freeze on every 7th day of the streak', () {
      final p = profile(streak: 7);
      expect(service.tryAwardFreeze(p), isTrue);
      expect(p.streakFreezeCount, 1);
      final q = profile(streak: 6);
      expect(service.tryAwardFreeze(q), isFalse);
    });

    test('never exceeds three freezes', () {
      final p = profile(streak: 14, freezes: 3);
      expect(service.tryAwardFreeze(p), isFalse);
      expect(p.streakFreezeCount, 3);
    });
  });
}
