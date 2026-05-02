import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../data/models/workout_log.dart';

/// GitHub-style compact heatmap showing last 13 weeks of workout activity.
/// Tapping navigates to the full calendar screen (caller provides [onTap]).
class CompactHeatmap extends StatelessWidget {
  const CompactHeatmap({
    super.key,
    required this.logs,
    required this.onTap,
  });

  final List<WorkoutLog> logs;
  final VoidCallback onTap;

  static const _cellSize = 11.0;
  static const _gap = 2.0;
  static const _numWeeks = 13;

  Map<DateTime, int> _buildCountMap() {
    final map = <DateTime, int>{};
    for (final log in logs) {
      final key =
          DateTime(log.date.year, log.date.month, log.date.day);
      map[key] = (map[key] ?? 0) + 1;
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final countMap = _buildCountMap();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Start from the Monday of the week (_numWeeks - 1) weeks ago
    final currentMonday =
        today.subtract(Duration(days: today.weekday - 1));
    final startMonday = currentMonday
        .subtract(Duration(days: 7 * (_numWeeks - 1)));

    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(_numWeeks, (w) {
          final weekStart = startMonday.add(Duration(days: w * 7));
          return Padding(
            padding: EdgeInsets.only(right: w < _numWeeks - 1 ? _gap : 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(7, (d) {
                final date = weekStart.add(Duration(days: d));
                final isFuture = date.isAfter(today);
                final count = isFuture ? 0 : (countMap[date] ?? 0);
                return Padding(
                  padding: EdgeInsets.only(bottom: d < 6 ? _gap : 0),
                  child: _HeatCell(count: count, isFuture: isFuture),
                );
              }),
            ),
          );
        }),
      ),
    );
  }
}

class _HeatCell extends StatelessWidget {
  const _HeatCell({required this.count, required this.isFuture});

  final int count;
  final bool isFuture;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color color;
    if (isFuture || count == 0) {
      color = isDark
          ? Colors.white.withAlpha(18)
          : Colors.black.withAlpha(14);
    } else if (count == 1) {
      color = AppTheme.brandBlue.withAlpha(110);
    } else {
      color = AppTheme.brandBlue.withAlpha(210);
    }

    return SizedBox(
      width: CompactHeatmap._cellSize,
      height: CompactHeatmap._cellSize,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}