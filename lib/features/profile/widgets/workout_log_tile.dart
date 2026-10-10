import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/extensions/build_context_l10n.dart';
import '../../../core/extensions/exercise_l10n.dart';
import '../../../data/models/enums.dart';
import '../../../core/utils/calendar_days.dart';
import '../../../data/models/workout_log.dart';
import '../../../data/static/exercise_tags_catalog.dart';
import '../../../domain/models/branch.dart';
import '../../library/widgets/exercise_thumb.dart';
import '../../../l10n/app_localizations.dart';

class WorkoutLogTile extends StatelessWidget {
  const WorkoutLogTile({
    super.key,
    required this.log,
    this.compact = false,
    this.now,
  });

  final WorkoutLog log;

  /// Home: no tags, "Today, 08:40" / "Yesterday, 19:10" instead of the date.
  final bool compact;

  /// What "today" is for [compact]; DateTime.now() when null.
  final DateTime? now;

  static const _skipSummaryTags = {
    ExerciseTag.floorOnly,
    ExerciseTag.requiresBar,
    ExerciseTag.beginner,
    ExerciseTag.sittingRecovery,
    ExerciseTag.postureFocus,
    ExerciseTag.warmup,
    ExerciseTag.cooldown,
  };

  static const _skipDetailTags = {
    ExerciseTag.floorOnly,
    ExerciseTag.requiresBar,
    ExerciseTag.beginner,
  };

  List<ExerciseTag> _summaryTags({int limit = 4}) {
    final seen = <ExerciseTag>{};
    final result = <ExerciseTag>[];
    for (final ex in log.exercises) {
      for (final tag in ExerciseTagsCatalog.forId(ex.exerciseId)) {
        if (!_skipSummaryTags.contains(tag) && seen.add(tag)) {
          result.add(tag);
        }
      }
    }
    return result.take(limit).toList();
  }

  String _typeLabel(AppLocalizations l10n) {
    if (!log.isPrimary) return l10n.historyTypeBonus;
    if (log.setType == SetType.challenge) return l10n.historyTypeChallenge;
    return l10n.historyTypeDaily;
  }

  void showDetail(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final locale = Localizations.localeOf(context).languageCode;
    final dateStr = DateFormat('d MMMM yyyy', locale).format(log.date);
    final m = log.durationSec ~/ 60;
    final s = log.durationSec % 60;
    final durationStr = m > 0 ? l10n.durationMin(m, s) : l10n.durationSec(s);

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (_, scrollController) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: scheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 4),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dateStr,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            _InfoChip(
                              label: _typeLabel(l10n),
                              color: scheme.primaryContainer,
                              textColor: scheme.onPrimaryContainer,
                            ),
                            const SizedBox(width: 8),
                            _InfoChip(
                              label: '+${log.spEarned} SP',
                              color: scheme.secondaryContainer,
                              textColor: scheme.onSecondaryContainer,
                            ),
                            const SizedBox(width: 8),
                            _InfoChip(
                              label: durationStr,
                              color: scheme.surfaceContainerHighest,
                              textColor: scheme.onSurfaceVariant,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 24),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  l10n.historyDetailExercises,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                itemCount: log.exercises.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (_, i) {
                  final ex = log.exercises[i];
                  final name = ExerciseL10n.name(l10n, ex.exerciseId);
                  final String resultStr;
                  if (ex.targetDurationSec != null &&
                      ex.targetDurationSec! > 0) {
                    resultStr = l10n.historyDetailSec(
                      ex.actualDurationSec ?? 0,
                      ex.targetDurationSec!,
                    );
                  } else if (ex.targetReps > 0) {
                    resultStr = l10n.historyDetailReps(
                      ex.completedReps,
                      ex.targetReps,
                    );
                  } else {
                    resultStr = '—';
                  }
                  final exTags = ExerciseTagsCatalog.forId(ex.exerciseId)
                      .where((t) => !_skipDetailTags.contains(t))
                      .take(2)
                      .toList();
                  final exercise = OwnBranch.exerciseById(ex.exerciseId);
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (exercise != null) ...[
                        ExerciseThumb(exercise, size: 44),
                        const SizedBox(width: 12),
                      ],
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(name, style: const TextStyle(fontSize: 14)),
                            if (exTags.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Wrap(
                                spacing: 4,
                                runSpacing: 4,
                                children: exTags
                                    .map((tag) =>
                                        ExerciseTagChip(tag: tag, l10n: l10n))
                                    .toList(),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Padding(
                        padding: const EdgeInsets.only(top: 1),
                        child: Text(
                          resultStr,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).languageCode;

    final days = calendarDaysBetween(log.date, now ?? DateTime.now());
    final time = DateFormat.Hm(locale).format(log.date);
    final dateStr = !compact
        ? DateFormat('d MMMM', locale).format(log.date)
        : days == 0
            ? l10n.homeLogToday(time)
            : days == 1
                ? l10n.homeLogYesterday(time)
                : DateFormat('d MMMM', locale).format(log.date);
    final m = log.durationSec ~/ 60;
    final s = log.durationSec % 60;
    final durationStr = m > 0 ? l10n.durationMin(m, s) : l10n.durationSec(s);
    final typeLabel = _typeLabel(l10n);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => showDetail(context),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 16, vertical: compact ? 10 : 14),
            child: Row(
              children: [
                SizedBox(
                  width: 26,
                  height: 26,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Icon(Icons.fitness_center,
                          size: 22, color: scheme.onSurfaceVariant),
                      if (!log.isPrimary)
                        Positioned(
                          right: -4,
                          top: -4,
                          child: Container(
                            width: 13,
                            height: 13,
                            decoration: BoxDecoration(
                              color: scheme.primary,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.add,
                                size: 9, color: scheme.onPrimary),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dateStr,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$typeLabel · $durationStr',
                        maxLines: compact ? 1 : null,
                        overflow: compact ? TextOverflow.ellipsis : null,
                        style: TextStyle(
                          fontSize: 13,
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                      () {
                        final tags = compact ? const <ExerciseTag>[] : _summaryTags();
                        if (tags.isEmpty) return const SizedBox.shrink();
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Wrap(
                            spacing: 4,
                            runSpacing: 4,
                            children: tags
                                .map((tag) =>
                                    ExerciseTagChip(tag: tag, l10n: l10n))
                                .toList(),
                          ),
                        );
                      }(),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: scheme.primaryContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '+${log.spEarned} SP',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: scheme.onPrimaryContainer,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: scheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Exercise tag chip ─────────────────────────────────────────────────────────

class ExerciseTagChip extends StatelessWidget {
  const ExerciseTagChip({super.key, required this.tag, required this.l10n});

  final ExerciseTag tag;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final color = tag.color;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        tag.localizedName(l10n),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }
}

// ── Info chip (used in detail sheet) ─────────────────────────────────────────

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.label,
    required this.color,
    required this.textColor,
  });

  final String label;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}