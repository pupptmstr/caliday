import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/extensions/build_context_l10n.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/workout_log.dart';
import '../../../data/repositories/workout_repository.dart';
import '../widgets/workout_log_tile.dart';

class WorkoutCalendarScreen extends ConsumerStatefulWidget {
  const WorkoutCalendarScreen({super.key});

  @override
  ConsumerState<WorkoutCalendarScreen> createState() =>
      _WorkoutCalendarScreenState();
}

class _WorkoutCalendarScreenState
    extends ConsumerState<WorkoutCalendarScreen> {
  late DateTime _month;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _month = DateTime(now.year, now.month, 1);
  }

  void _prevMonth() {
    setState(() => _month = DateTime(_month.year, _month.month - 1, 1));
  }

  void _nextMonth() {
    setState(() => _month = DateTime(_month.year, _month.month + 1, 1));
  }

  bool get _canGoNext {
    final now = DateTime.now();
    return _month.isBefore(DateTime(now.year, now.month, 1));
  }

  Map<DateTime, List<WorkoutLog>> _buildDayMap(List<WorkoutLog> logs) {
    final map = <DateTime, List<WorkoutLog>>{};
    for (final log in logs) {
      final key =
          DateTime(log.date.year, log.date.month, log.date.day);
      map.putIfAbsent(key, () => []).add(log);
    }
    return map;
  }

  static DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  void _showDayDetail(
    DateTime date,
    List<WorkoutLog> logs, {
    bool isFreezeGap = false,
  }) {
    if (logs.isEmpty && !isFreezeGap) return;

    if (logs.isEmpty) {
      _showFreezeGapSheet(date);
      return;
    }

    final scheme = Theme.of(context).colorScheme;
    final locale = Localizations.localeOf(context).languageCode;
    final dateStr = DateFormat('d MMMM', locale).format(date);

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetCtx) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.35,
        maxChildSize: 0.85,
        expand: false,
        builder: (_, scrollCtrl) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: scheme.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: Text(
                dateStr,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Divider(height: 1, color: scheme.outlineVariant),
            Expanded(
              child: ListView.builder(
                controller: scrollCtrl,
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                itemCount: logs.length,
                itemBuilder: (ctx, i) =>
                    WorkoutLogTile(log: logs[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFreezeGapSheet(DateTime date) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final locale = Localizations.localeOf(context).languageCode;
    final dateStr = DateFormat('d MMMM', locale).format(date);

    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetCtx) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: scheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Row(
              children: [
                Icon(Icons.ac_unit, color: Colors.cyan.shade500, size: 22),
                const SizedBox(width: 10),
                Text(
                  dateStr,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              l10n.calendarFreezeUsedTitle,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.cyan.shade600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              l10n.calendarFreezeUsedBody,
              style: TextStyle(
                fontSize: 14,
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final repo = ref.read(workoutRepositoryProvider);
    final lastDay = DateTime(_month.year, _month.month + 1, 0);
    final logs = repo.getInRange(_month, lastDay);

    // Fetch first 3 days of next month to detect freeze gaps at month end
    final nextMonthExtra = repo.getInRange(
      DateTime(_month.year, _month.month + 1, 1),
      DateTime(_month.year, _month.month + 1, 3),
    );

    final dayMap = _buildDayMap(logs);

    // Days where a freeze was consumed (gap day = workout.date − 1 day)
    final freezeGapDays = <DateTime>{};
    for (final log in [...logs, ...nextMonthExtra]) {
      if (log.freezeUsed) {
        freezeGapDays.add(
          _dateOnly(log.date.subtract(const Duration(days: 1))),
        );
      }
    }

    // Days where a freeze was earned
    final freezeEarnedDays = <DateTime>{
      for (final log in logs)
        if (log.freezeEarned) _dateOnly(log.date),
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.calendarTitle),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _MonthNav(
              month: _month,
              onPrev: _prevMonth,
              onNext: _canGoNext ? _nextMonth : null,
            ),
            _WeekDayHeader(),
            _MonthGrid(
              month: _month,
              dayMap: dayMap,
              freezeGapDays: freezeGapDays,
              freezeEarnedDays: freezeEarnedDays,
              onDayTap: _showDayDetail,
            ),
            _CalendarLegend(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// ── Month navigation header ───────────────────────────────────────────────────

class _MonthNav extends StatelessWidget {
  const _MonthNav({
    required this.month,
    required this.onPrev,
    this.onNext,
  });

  final DateTime month;
  final VoidCallback onPrev;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final label = DateFormat.yMMMM(locale).format(month);
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: onPrev,
            icon: const Icon(Icons.chevron_left),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: scheme.onSurface,
            ),
          ),
          IconButton(
            onPressed: onNext,
            icon: Icon(
              Icons.chevron_right,
              color: onNext != null
                  ? scheme.onSurface
                  : scheme.onSurface.withAlpha(60),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Day-of-week header row ────────────────────────────────────────────────────

class _WeekDayHeader extends StatelessWidget {
  const _WeekDayHeader();

  static const _days = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: _days
            .map(
              (d) => Expanded(
                child: Center(
                  child: Text(
                    d,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

// ── Month grid ────────────────────────────────────────────────────────────────

class _MonthGrid extends StatelessWidget {
  const _MonthGrid({
    required this.month,
    required this.dayMap,
    required this.freezeGapDays,
    required this.freezeEarnedDays,
    required this.onDayTap,
  });

  final DateTime month;
  final Map<DateTime, List<WorkoutLog>> dayMap;
  final Set<DateTime> freezeGapDays;
  final Set<DateTime> freezeEarnedDays;
  final void Function(DateTime date, List<WorkoutLog> logs,
      {bool isFreezeGap}) onDayTap;

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final firstWeekday = DateTime(month.year, month.month, 1).weekday; // 1=Mon
    final leadingEmpty = firstWeekday - 1;

    final cells = <Widget>[];

    for (int i = 0; i < leadingEmpty; i++) {
      cells.add(const SizedBox.shrink());
    }

    for (int day = 1; day <= daysInMonth; day++) {
      final cellDate = DateTime(month.year, month.month, day);
      final logs = dayMap[cellDate] ?? [];
      final isFreezeGap = freezeGapDays.contains(cellDate);
      final hasEarnedFreeze = freezeEarnedDays.contains(cellDate);
      cells.add(_DayCell(
        date: cellDate,
        logs: logs,
        isFreezeGap: isFreezeGap,
        hasEarnedFreeze: hasEarnedFreeze,
        onTap: () =>
            onDayTap(cellDate, logs, isFreezeGap: isFreezeGap),
      ));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GridView.count(
        crossAxisCount: 7,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        children: cells,
      ),
    );
  }
}

// ── Day cell ──────────────────────────────────────────────────────────────────

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.date,
    required this.logs,
    required this.isFreezeGap,
    required this.hasEarnedFreeze,
    required this.onTap,
  });

  final DateTime date;
  final List<WorkoutLog> logs;
  final bool isFreezeGap;
  final bool hasEarnedFreeze;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final isToday = date == today;
    final isFuture = date.isAfter(today);
    final hasWorkout = logs.isNotEmpty;
    final hasBonus = logs.length > 1;

    Color bgColor;
    Color textColor;

    if (isFuture) {
      bgColor = Colors.transparent;
      textColor = scheme.onSurface.withAlpha(40);
    } else if (isFreezeGap && !hasWorkout) {
      bgColor = isDark
          ? Colors.cyan.withAlpha(35)
          : Colors.cyan.withAlpha(28);
      textColor = scheme.onSurface.withAlpha(isDark ? 130 : 160);
    } else if (hasBonus) {
      bgColor = AppTheme.brandBlue.withAlpha(210);
      textColor = Colors.white;
    } else if (hasWorkout) {
      bgColor = AppTheme.brandBlue.withAlpha(110);
      textColor = isDark ? Colors.white : AppTheme.brandBlueDeep;
    } else if (isToday) {
      bgColor = scheme.surfaceContainerHighest;
      textColor = scheme.primary;
    } else {
      bgColor = scheme.surfaceContainerHighest.withAlpha(isDark ? 40 : 80);
      textColor = scheme.onSurface.withAlpha(isDark ? 130 : 160);
    }

    return GestureDetector(
      onTap: (hasWorkout || isFreezeGap) ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
          border: isToday
              ? Border.all(
                  color: scheme.primary.withAlpha(hasWorkout ? 0 : 160),
                  width: 1.5,
                )
              : null,
        ),
        child: Stack(
          children: [
            if (isFreezeGap && !hasWorkout)
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.ac_unit,
                      size: 13,
                      color: Colors.cyan.shade500,
                    ),
                    Text(
                      '${date.day}',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              )
            else
              Center(
                child: Text(
                  '${date.day}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isToday || hasWorkout
                        ? FontWeight.w700
                        : FontWeight.w400,
                    color: isToday && !hasWorkout ? scheme.primary : textColor,
                  ),
                ),
              ),
            // Freeze earned badge (small snowflake in top-right corner)
            if (hasEarnedFreeze)
              Positioned(
                top: 2,
                right: 2,
                child: Icon(
                  Icons.ac_unit,
                  size: 9,
                  color: Colors.cyan.shade300,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ── Calendar legend ───────────────────────────────────────────────────────────

class _CalendarLegend extends StatelessWidget {
  const _CalendarLegend();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
      child: Wrap(
        spacing: 16,
        runSpacing: 6,
        children: [
          _LegendItem(
            color: AppTheme.brandBlue.withAlpha(110),
            label: '1 тренировка',
            scheme: scheme,
          ),
          _LegendItem(
            color: AppTheme.brandBlue.withAlpha(210),
            label: '2+ тренировки',
            scheme: scheme,
          ),
          _LegendItem(
            color: isDark ? Colors.cyan.withAlpha(35) : Colors.cyan.withAlpha(28),
            icon: Icons.ac_unit,
            iconColor: Colors.cyan.shade500,
            label: 'Заморозка',
            scheme: scheme,
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.color,
    required this.label,
    required this.scheme,
    this.icon,
    this.iconColor,
  });

  final Color color;
  final String label;
  final ColorScheme scheme;
  final IconData? icon;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
          child: icon != null
              ? Icon(icon, size: 9, color: iconColor)
              : null,
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: scheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}