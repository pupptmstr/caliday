import 'package:caliday/data/models/enums.dart';
import 'package:caliday/data/models/user_profile.dart';
import 'package:caliday/domain/services/rank_decay_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const service = RankDecayService();

  group('decayTiers', () {
    test('no decay before the first threshold', () {
      expect(service.decayTiers(0), 0);
      expect(service.decayTiers(20), 0);
    });

    test('negative input (never trained) means no decay', () {
      expect(service.decayTiers(-1), 0);
    });

    test('each threshold adds exactly one tier (21 / 35 / 45 / 53 / 59)', () {
      const expected = {
        21: 1, 34: 1,
        35: 2, 44: 2,
        45: 3, 52: 3,
        53: 4, 58: 4,
        59: 5, 365: 5,
      };
      expected.forEach((days, tiers) {
        expect(service.decayTiers(days), tiers, reason: '$days days');
      });
    });
  });

  group('effectiveRank', () {
    test('returns the earned rank while inactive for less than 21 days', () {
      for (final rank in Rank.values) {
        expect(service.effectiveRank(rank, 20), rank);
      }
    });

    test('drops one tier at 21 days and two at 35 days', () {
      expect(service.effectiveRank(Rank.legend, 21), Rank.master);
      expect(service.effectiveRank(Rank.athlete, 35), Rank.amateur);
    });

    test('a legend decays all the way to beginner after 59 days', () {
      expect(service.effectiveRank(Rank.legend, 59), Rank.beginner);
    });

    test('never goes below beginner', () {
      for (final rank in Rank.values) {
        for (final days in [0, 21, 35, 45, 53, 59, 1000]) {
          final shown = service.effectiveRank(rank, days);
          expect(shown.index, greaterThanOrEqualTo(0));
          expect(shown.index, lessThanOrEqualTo(rank.index));
        }
      }
      expect(service.effectiveRank(Rank.beginner, 1000), Rank.beginner);
      expect(service.effectiveRank(Rank.amateur, 1000), Rank.beginner);
    });
  });

  group('warning / decayed windows', () {
    test('isWarning covers days 14..20 only', () {
      expect(service.isWarning(13), isFalse);
      expect(service.isWarning(14), isTrue);
      expect(service.isWarning(20), isTrue);
      expect(service.isWarning(21), isFalse);
      expect(service.isWarning(-1), isFalse);
    });

    test('isDecayed starts at day 21', () {
      expect(service.isDecayed(20), isFalse);
      expect(service.isDecayed(21), isTrue);
      expect(service.isDecayed(-1), isFalse);
    });

    test('warning and decayed never overlap', () {
      for (var d = -1; d < 100; d++) {
        expect(service.isWarning(d) && service.isDecayed(d), isFalse,
            reason: '$d days');
      }
    });

    test('daysUntilFirstDecay counts down to 0 and stays there', () {
      expect(service.daysUntilFirstDecay(0), 21);
      expect(service.daysUntilFirstDecay(14), 7);
      expect(service.daysUntilFirstDecay(21), 0);
      expect(service.daysUntilFirstDecay(40), 0);
    });
  });

  group('daysSinceLastWorkout', () {
    int daysBetween(DateTime last, DateTime now) => service.daysSinceLastWorkout(
          UserProfile(lastWorkoutDate: last),
          now: now,
        );

    test('is -1 when the user has never trained', () {
      expect(service.daysSinceLastWorkout(UserProfile()), -1);
    });

    test('counts calendar days, ignoring the time of day', () {
      // 23:59 yesterday vs 00:01 today is one day, not zero.
      expect(
        daysBetween(DateTime(2026, 6, 9, 23, 59), DateTime(2026, 6, 10, 0, 1)),
        1,
      );
      // Early morning then late evening of the same day is zero.
      expect(
        daysBetween(DateTime(2026, 6, 10, 6), DateTime(2026, 6, 10, 23, 59)),
        0,
      );
    });

    test('14 days is 14 even when the span crosses the spring DST change', () {
      // Europe: clocks go forward on 2026-03-29, so that day has 23 hours.
      // Subtracting two local midnights and truncating to days gives 13 here.
      expect(
        daysBetween(DateTime(2026, 3, 20, 14), DateTime(2026, 4, 3, 8)),
        14,
      );
    });

    test('14 days is 14 even when the span crosses the autumn DST change', () {
      expect(
        daysBetween(DateTime(2026, 10, 20, 14), DateTime(2026, 11, 3, 8)),
        14,
      );
    });

    test('the 21-day threshold is hit on the 21st calendar day across DST',
        () {
      final days = daysBetween(
        DateTime(2026, 3, 15, 18),
        DateTime(2026, 4, 5, 7),
      );
      expect(days, 21);
      expect(service.isDecayed(days), isTrue);
    });
  });
}
