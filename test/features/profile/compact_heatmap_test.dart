import 'package:caliday/features/profile/widgets/compact_heatmap.dart';
import 'package:flutter_test/flutter_test.dart';

/// The DST cases are about Europe/Berlin (clocks go forward on 2026-03-29).
/// On a machine in a zone without DST they pass trivially.
void main() {
  group('CompactHeatmap.weekGrid', () {
    void expectWellFormedGrid(DateTime today) {
      final grid = CompactHeatmap.weekGrid(today);
      expect(grid, hasLength(13));
      DateTime? previous;
      for (final week in grid) {
        expect(week, hasLength(7));
        for (final date in week) {
          // Cells are looked up by date-only keys, so every cell must be
          // exactly local midnight and exactly one calendar day after the
          // previous one.
          expect(date, DateTime(date.year, date.month, date.day),
              reason: '$date is not local midnight');
          if (previous != null) {
            expect(date, DateTime(previous.year, previous.month, previous.day + 1),
                reason: '$date does not follow $previous');
          }
          previous = date;
        }
        expect(week.first.weekday, DateTime.monday);
      }
    }

    test('ends with the week that contains today', () {
      final grid = CompactHeatmap.weekGrid(DateTime(2026, 6, 10)); // Wednesday
      expect(grid.last.first, DateTime(2026, 6, 8));
      expect(grid.last.last, DateTime(2026, 6, 14));
      expect(grid.first.first, DateTime(2026, 3, 16));
    });

    test('is well-formed in summer (no DST change inside the window)', () {
      expectWellFormedGrid(DateTime(2026, 8, 20));
    });

    test('is well-formed when the window starts before the spring DST change',
        () {
      // Window = 2026-01-26 .. 2026-04-26, spring change on 2026-03-29.
      expectWellFormedGrid(DateTime(2026, 4, 20));
    });

    test('is well-formed when the window starts before the autumn DST change',
        () {
      // Window = 2026-08-03 .. 2026-11-01, autumn change on 2026-10-25.
      expectWellFormedGrid(DateTime(2026, 10, 28));
    });
  });
}
