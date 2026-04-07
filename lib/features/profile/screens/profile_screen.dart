import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../../core/extensions/achievement_l10n.dart';
import '../../../core/extensions/build_context_l10n.dart';
import '../../friends/providers/friends_provider.dart';
import '../../../core/extensions/exercise_l10n.dart';
import '../../../data/models/enums.dart';
import '../../../data/models/workout_log.dart';
import '../../../data/static/exercise_tags_catalog.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/repositories/achievement_repository.dart';
import '../../../data/static/achievement_catalog.dart';
import '../providers/profile_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  static void _showStatSheet(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String body,
  }) {
    final scheme = Theme.of(context).colorScheme;
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      backgroundColor: scheme.surface,
      builder: (sheetCtx) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Icon(icon, size: 32, color: iconColor),
            const SizedBox(height: 12),
            Text(
              title,
              style: Theme.of(sheetCtx).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              body,
              style: Theme.of(sheetCtx).textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(profileDataProvider);
    final achievementRepo = ref.watch(achievementRepositoryProvider);
    final friendsCount = ref.watch(friendsCountProvider);
    final profile = data.profile;
    final scheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;

    // Rank progress
    final nextRank = profile.rank.next;
    final double rankProgress;
    final String rankProgressLabel;
    if (nextRank == null) {
      rankProgress = 1.0;
      rankProgressLabel = l10n.profileMaxRank;
    } else {
      final earned = profile.totalSP - profile.rank.spThreshold;
      final needed = nextRank.spThreshold - profile.rank.spThreshold;
      rankProgress = (earned / needed).clamp(0.0, 1.0);
      final remaining = nextRank.spThreshold - profile.totalSP;
      rankProgressLabel = l10n.profileRankProgress(remaining, nextRank.localizedName(l10n));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profileTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: l10n.settingsTitle,
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Goro mascot ───────────────────────────────────────────
              Center(
                child: SvgPicture.asset(
                  'assets/goro/goro_idle_v2.svg',
                  height: 100,
                ),
              ),
              const SizedBox(height: 16),

              // ── Rank card ──────────────────────────────────────────────
              _RankCard(
                rank: profile.rank,
                totalSP: profile.totalSP,
                rankProgress: rankProgress,
                rankProgressLabel: rankProgressLabel,
                onTap: () => _showStatSheet(
                  context,
                  icon: Icons.workspace_premium,
                  iconColor: scheme.primary,
                  title: l10n.tooltipRankTitle,
                  body: l10n.tooltipRankBody,
                ),
              ),

              const SizedBox(height: 20),

              // ── Stats grid ─────────────────────────────────────────────
              _StatsGrid(
                currentStreak: data.displayStreak,
                longestStreak: profile.longestStreak,
                totalWorkouts: data.totalWorkouts,
                streakFreezes: profile.streakFreezeCount,
                onTapStreak: () => _showStatSheet(
                  context,
                  icon: Icons.local_fire_department,
                  iconColor: AppTheme.energy,
                  title: l10n.tooltipStreakTitle,
                  body: l10n.tooltipStreakBody,
                ),
                onTapLongestStreak: () => _showStatSheet(
                  context,
                  icon: Icons.emoji_events,
                  iconColor: scheme.primary,
                  title: l10n.tooltipLongestStreakTitle,
                  body: l10n.tooltipLongestStreakBody,
                ),
                onTapTotalWorkouts: () => _showStatSheet(
                  context,
                  icon: Icons.fitness_center,
                  iconColor: scheme.primary,
                  title: l10n.tooltipTotalWorkoutsTitle,
                  body: l10n.tooltipTotalWorkoutsBody,
                ),
                onTapFreezes: () => _showStatSheet(
                  context,
                  icon: Icons.ac_unit,
                  iconColor: scheme.primary,
                  title: l10n.tooltipFreezesTitle,
                  body: l10n.tooltipFreezesBody,
                ),
              ),

              const SizedBox(height: 24),

              // ── Friends ────────────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.profileFriendsTitle,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  TextButton(
                    onPressed: () => context.push('/friends'),
                    child: Text(l10n.profileFriendsAll),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                friendsCount == 0
                    ? l10n.profileFriendsEmpty
                    : l10n.profileFriendsCount(friendsCount),
                style: TextStyle(color: scheme.onSurfaceVariant),
              ),

              const SizedBox(height: 24),

              // ── Achievements ───────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.profileAchievementsTitle,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  TextButton(
                    onPressed: () => context.push('/achievements'),
                    child: Text(l10n.profileAchievementsAll),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (data.recentAchievementIds.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    l10n.profileNoAchievements,
                    style: TextStyle(color: scheme.onSurfaceVariant),
                  ),
                )
              else
                _AchievementBadgeRow(
                  ids: data.recentAchievementIds,
                  achievementRepo: achievementRepo,
                ),

              const SizedBox(height: 24),

              // ── Recent workouts ────────────────────────────────────────
              Text(
                l10n.profileHistoryTitle,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),

              if (data.recentLogs.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    l10n.profileNoHistory,
                    style: TextStyle(color: scheme.onSurfaceVariant),
                    textAlign: TextAlign.center,
                  ),
                )
              else
                ...data.recentLogs.map((log) => _WorkoutLogTile(log: log)),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Rank card ─────────────────────────────────────────────────────────────────

class _RankCard extends StatelessWidget {
  const _RankCard({
    required this.rank,
    required this.totalSP,
    required this.rankProgress,
    required this.rankProgressLabel,
    this.onTap,
  });

  final Rank rank;
  final int totalSP;
  final double rankProgress;
  final String rankProgressLabel;
  final VoidCallback? onTap;

  static IconData _icon(Rank r) => switch (r) {
        Rank.beginner => Icons.eco,
        Rank.amateur => Icons.fitness_center,
        Rank.sportsman => Icons.directions_run,
        Rank.athlete => Icons.bolt,
        Rank.master => Icons.local_fire_department,
        Rank.legend => Icons.workspace_premium,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          gradient: AppTheme.rankGradient,
          borderRadius: BorderRadius.circular(22),
          boxShadow: isDark ? AppTheme.cardShadowDark : AppTheme.cardShadowLight,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(35),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(_icon(rank), size: 28, color: Colors.white),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        rank.localizedName(l10n),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$totalSP SP',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withAlpha(200),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: rankProgress,
                minHeight: 8,
                backgroundColor: Colors.white.withAlpha(45),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),

            const SizedBox(height: 8),

            Text(
              rankProgressLabel,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withAlpha(200),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Stats grid ────────────────────────────────────────────────────────────────

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({
    required this.currentStreak,
    required this.longestStreak,
    required this.totalWorkouts,
    required this.streakFreezes,
    this.onTapStreak,
    this.onTapLongestStreak,
    this.onTapTotalWorkouts,
    this.onTapFreezes,
  });

  final int currentStreak;
  final int longestStreak;
  final int totalWorkouts;
  final int streakFreezes;
  final VoidCallback? onTapStreak;
  final VoidCallback? onTapLongestStreak;
  final VoidCallback? onTapTotalWorkouts;
  final VoidCallback? onTapFreezes;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Row(
      children: [
        Expanded(child: _StatCell(icon: Icons.local_fire_department, value: '$currentStreak', label: l10n.profileStatDays, isStreak: true, onTap: onTapStreak)),
        const SizedBox(width: 10),
        Expanded(child: _StatCell(icon: Icons.emoji_events, value: '$longestStreak', label: l10n.profileStatRecord, onTap: onTapLongestStreak)),
        const SizedBox(width: 10),
        Expanded(child: _StatCell(icon: Icons.fitness_center, value: '$totalWorkouts', label: l10n.profileStatWorkouts, onTap: onTapTotalWorkouts)),
        const SizedBox(width: 10),
        Expanded(child: _StatCell(icon: Icons.ac_unit, value: '$streakFreezes', label: l10n.profileStatFreezes, onTap: onTapFreezes)),
      ],
    );
  }
}

class _StatCell extends StatelessWidget {
  const _StatCell({
    required this.icon,
    required this.value,
    required this.label,
    this.isStreak = false,
    this.onTap,
  });

  final IconData icon;
  final String value;
  final String label;
  final bool isStreak;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bgColor;
    final Color iconColor;
    final Color valueColor;

    if (isStreak) {
      bgColor = isDark ? AppTheme.energyContainerDark : AppTheme.energyContainer;
      iconColor = AppTheme.energy;
      valueColor = AppTheme.energy;
    } else {
      bgColor = scheme.surfaceContainerHighest;
      iconColor = scheme.primary;
      valueColor = scheme.onSurface;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isDark ? AppTheme.cardShadowDark : AppTheme.cardShadowLight,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 22, color: iconColor),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w900,
                color: valueColor,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: scheme.onSurfaceVariant,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Workout log tile ──────────────────────────────────────────────────────────

class _WorkoutLogTile extends StatelessWidget {
  const _WorkoutLogTile({required this.log});

  final WorkoutLog log;

  // Tags to skip in the summary line (structural / equipment meta)
  static const _skipSummaryTags = {
    ExerciseTag.floorOnly,
    ExerciseTag.requiresBar,
    ExerciseTag.beginner,
    ExerciseTag.sittingRecovery,
    ExerciseTag.postureFocus,
    ExerciseTag.warmup,
    ExerciseTag.cooldown,
  };

  // Tags to skip per-exercise in the detail sheet
  static const _skipDetailTags = {
    ExerciseTag.floorOnly,
    ExerciseTag.requiresBar,
    ExerciseTag.beginner,
  };

  /// Unique muscle/type tags for the whole workout, max [limit].
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

  void _showDetail(BuildContext context) {
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
            // Drag handle
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
            // Header
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
                            _Chip(
                              label: _typeLabel(l10n),
                              color: scheme.primaryContainer,
                              textColor: scheme.onPrimaryContainer,
                            ),
                            const SizedBox(width: 8),
                            _Chip(
                              label: '+${log.spEarned} SP',
                              color: scheme.secondaryContainer,
                              textColor: scheme.onSecondaryContainer,
                            ),
                            const SizedBox(width: 8),
                            _Chip(
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
            // Exercise list header
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
            // Exercise list
            Expanded(
              child: ListView.separated(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                itemCount: log.exercises.length,
                separatorBuilder: (_, i) => const SizedBox(height: 10),
                itemBuilder: (_, i) {
                  final ex = log.exercises[i];
                  final name = ExerciseL10n.name(l10n, ex.exerciseId);
                  final String resultStr;
                  if (ex.targetDurationSec != null && ex.targetDurationSec! > 0) {
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
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(fontSize: 14),
                            ),
                            if (exTags.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Wrap(
                                spacing: 4,
                                runSpacing: 4,
                                children: exTags
                                    .map((tag) => _ExerciseTagChip(tag: tag, l10n: l10n))
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

    final dateStr = DateFormat('d MMMM', locale).format(log.date);
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
          onTap: () => _showDetail(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                        style: TextStyle(
                          fontSize: 13,
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                      () {
                        final tags = _summaryTags();
                        if (tags.isEmpty) return const SizedBox.shrink();
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Wrap(
                            spacing: 4,
                            runSpacing: 4,
                            children: tags
                                .map((tag) => _ExerciseTagChip(tag: tag, l10n: l10n))
                                .toList(),
                          ),
                        );
                      }(),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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

class _ExerciseTagChip extends StatelessWidget {
  const _ExerciseTagChip({required this.tag, required this.l10n});

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

// ── Small chip ────────────────────────────────────────────────────────────────

class _Chip extends StatelessWidget {
  const _Chip({
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

// ── Achievement badge row ─────────────────────────────────────────────────────

class _AchievementBadgeRow extends StatelessWidget {
  const _AchievementBadgeRow({
    required this.ids,
    required this.achievementRepo,
  });

  final List<String> ids;
  final AchievementRepository achievementRepo;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).languageCode;

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: ids.map((id) {
        final a = AchievementCatalog.byId(id);
        return GestureDetector(
          onTap: () {
            final earnedAt = achievementRepo.earnedAt(id);
            final dateStr = earnedAt != null
                ? DateFormat('d MMMM yyyy', locale).format(earnedAt)
                : null;
            showModalBottomSheet<void>(
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              builder: (_) => Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 36),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(a?.emoji ?? '🏅',
                        style: const TextStyle(fontSize: 48)),
                    const SizedBox(height: 12),
                    Text(
                      AchievementL10n.name(l10n, id),
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w800),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AchievementL10n.desc(l10n, id),
                      style: TextStyle(
                        fontSize: 15,
                        color: scheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (dateStr != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        l10n.achievementsEarnedOn(dateStr),
                        style: TextStyle(
                          fontSize: 13,
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
          child: Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: scheme.primaryContainer,
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: Text(a?.emoji ?? '🏅',
                style: const TextStyle(fontSize: 26)),
          ),
        );
      }).toList(),
    );
  }
}