import 'package:caliday/core/utils/calendar_days.dart';
import 'package:flutter_test/flutter_test.dart';

/// The DST cases are about Europe/Berlin (clocks go forward on 2026-03-29,
/// back on 2026-10-25). On a machine in a zone without DST they pass trivially.
void main() {
  group('calendarDaysBetween', () {
    test('ignores the time of day', () {
      expect(
          calendarDaysBetween(
              DateTime(2026, 6, 9, 23, 59), DateTime(2026, 6, 10, 0, 1)),
          1);
      expect(
          calendarDaysBetween(
              DateTime(2026, 6, 10, 6), DateTime(2026, 6, 10, 23, 59)),
          0);
    });

    test('is negative when the second date is earlier', () {
      expect(calendarDaysBetween(DateTime(2026, 6, 10), DateTime(2026, 6, 7)),
          -3);
    });

    test('counts every day across a month and a year boundary', () {
      expect(calendarDaysBetween(DateTime(2025, 12, 30), DateTime(2026, 1, 2)),
          3);
      expect(calendarDaysBetween(DateTime(2026, 2, 27), DateTime(2026, 3, 1)),
          2);
    });

    test('is exact across the spring and autumn DST changes', () {
      expect(calendarDaysBetween(DateTime(2026, 3, 29), DateTime(2026, 3, 30)),
          1);
      expect(calendarDaysBetween(DateTime(2026, 3, 20), DateTime(2026, 4, 3)),
          14);
      expect(calendarDaysBetween(DateTime(2026, 10, 25), DateTime(2026, 10, 26)),
          1);
      expect(calendarDaysBetween(DateTime(2026, 10, 20), DateTime(2026, 11, 3)),
          14);
    });
  });

  group('addCalendarDays', () {
    test('returns local midnight and drops the time of day', () {
      expect(addCalendarDays(DateTime(2026, 6, 10, 18, 30), 1),
          DateTime(2026, 6, 11));
      expect(addCalendarDays(DateTime(2026, 6, 10, 18, 30), 0),
          DateTime(2026, 6, 10));
    });

    test('moves backwards and over month / year ends', () {
      expect(addCalendarDays(DateTime(2026, 3, 1), -1), DateTime(2026, 2, 28));
      expect(addCalendarDays(DateTime(2026, 1, 1), -1), DateTime(2025, 12, 31));
      expect(addCalendarDays(DateTime(2026, 12, 30), 3), DateTime(2027, 1, 2));
    });

    test('stays at midnight across the DST changes', () {
      // Duration-based arithmetic would land on 23:00 / 01:00 here.
      expect(addCalendarDays(DateTime(2026, 3, 30), -1), DateTime(2026, 3, 29));
      expect(addCalendarDays(DateTime(2026, 4, 20), -84), DateTime(2026, 1, 26));
      expect(addCalendarDays(DateTime(2026, 10, 26), -84), DateTime(2026, 8, 3));
    });
  });
}
