import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../../core/extensions/build_context_l10n.dart';
import '../../friends/providers/friends_provider.dart';
import '../../home/providers/home_provider.dart' show activeCourseProvider;
import '../../../data/models/enums.dart';
import '../../../data/repositories/achievement_repository.dart';
import '../../../data/repositories/workout_repository.dart';
import '../../../data/static/achievement_catalog.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/profile_provider.dart';
import '../widgets/achievement_sheet.dart';
import '../widgets/compact_heatmap.dart';
import '../widgets/rank_info_sheet.dart';
import '../widgets/whats_new_bell.dart';
import '../widgets/workout_log_tile.dart';

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
      rankProgressLabel =
          l10n.profileRankProgress(remaining, nextRank.localizedName(l10n));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profileTitle),
        actions: [
          const WhatsNewBell(),
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
              // ── The active course's host ──────────────────────────────
              Center(
                child: SvgPicture.asset(
                  ref.watch(activeCourseProvider).host.hostIdle,
                  height: 100,
                ),
              ),
              const SizedBox(height: 16),

              // ── Rank card ──────────────────────────────────────────────
              _RankCard(
                rank: profile.rank,
                effectiveRank: data.effectiveRank,
                totalSP: profile.totalSP,
                rankProgress: rankProgress,
                rankProgressLabel: rankProgressLabel,
                isDecayed: data.isRankDecayed,
                onTap: () => showRankInfoSheet(
                  context,
                  earnedRank: profile.rank,
                  effectiveRank: data.effectiveRank,
                  totalSP: profile.totalSP,
                  daysSinceLastWorkout:
                      data.daysSinceLastWorkout.clamp(0, 9999),
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
                  activeCourse: ref.watch(activeCourseProvider).builtIn,
                ),

              const SizedBox(height: 24),

              // ── Workout history ────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.profileHistoryTitle,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  TextButton(
                    onPressed: () => context.push('/calendar'),
                    child: Text(l10n.calendarSeeAll),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              CompactHeatmap(
                logs: ref.read(workoutRepositoryProvider).getInRange(
                      DateTime.now().subtract(const Duration(days: 90)),
                      DateTime.now(),
                    ),
                onTap: () => context.push('/calendar'),
              ),
              const SizedBox(height: 16),

              if (data.recentLogs.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    l10n.profileNoHistory,
                    style: TextStyle(color: scheme.onSurfaceVariant),
                    textAlign: TextAlign.center,
                  ),
                )
              else
                ...data.recentLogs
                    .take(5)
                    .map((log) => WorkoutLogTile(log: log)),
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
    required this.effectiveRank,
    required this.totalSP,
    required this.rankProgress,
    required this.rankProgressLabel,
    this.isDecayed = false,
    this.onTap,
  });

  final Rank rank;
  final Rank effectiveRank;
  final int totalSP;
  final double rankProgress;
  final String rankProgressLabel;
  final bool isDecayed;
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
          boxShadow:
              isDark ? AppTheme.cardShadowDark : AppTheme.cardShadowLight,
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
                  child: Icon(
                    _icon(effectiveRank),
                    size: 28,
                    color: isDecayed
                        ? Colors.amber.shade200
                        : Colors.white,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              effectiveRank.localizedName(l10n),
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                color: isDecayed
                                    ? Colors.amber.shade200
                                    : Colors.white,
                                letterSpacing: -0.3,
                              ),
                            ),
                          ),
                          if (isDecayed)
                            Icon(Icons.warning_amber_rounded,
                                size: 20,
                                color: Colors.amber.shade200),
                        ],
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
                valueColor:
                    const AlwaysStoppedAnimation<Color>(Colors.white),
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
        Expanded(
          child: _StatCell(
            icon: Icons.local_fire_department,
            value: '$currentStreak',
            label: l10n.profileStatDays,
            isStreak: true,
            onTap: onTapStreak,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCell(
            icon: Icons.emoji_events,
            value: '$longestStreak',
            label: l10n.profileStatRecord,
            onTap: onTapLongestStreak,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCell(
            icon: Icons.fitness_center,
            value: '$totalWorkouts',
            label: l10n.profileStatWorkouts,
            onTap: onTapTotalWorkouts,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCell(
            icon: Icons.ac_unit,
            value: '$streakFreezes',
            label: l10n.profileStatFreezes,
            onTap: onTapFreezes,
          ),
        ),
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
      bgColor =
          isDark ? AppTheme.energyContainerDark : AppTheme.energyContainer;
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
          boxShadow:
              isDark ? AppTheme.cardShadowDark : AppTheme.cardShadowLight,
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

// ── Achievement badge row ─────────────────────────────────────────────────────

class _AchievementBadgeRow extends StatelessWidget {
  const _AchievementBadgeRow({
    required this.ids,
    required this.achievementRepo,
    required this.activeCourse,
  });

  final List<String> ids;
  final AchievementRepository achievementRepo;
  final CourseId? activeCourse;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final locale = Localizations.localeOf(context).languageCode;

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: ids.map((id) {
        final a = AchievementCatalog.byId(id);
        return GestureDetector(
          onTap: () {
            final earnedAt = achievementRepo.earnedAt(id);
            if (a == null) return;
            showAchievementSheet(
              context,
              a,
              active: activeCourse,
              earnedOn: earnedAt != null
                  ? DateFormat('d MMMM yyyy', locale).format(earnedAt)
                  : null,
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
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: AchievementEmoji(a?.emoji ?? '🏅', size: 26),
            ),
          ),
        );
      }).toList(),
    );
  }
}