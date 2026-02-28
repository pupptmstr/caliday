import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../../core/extensions/build_context_l10n.dart';
import '../../../data/models/enums.dart';
import '../../../data/models/workout_log.dart';
import '../providers/profile_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(profileDataProvider);
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
              ),

              const SizedBox(height: 20),

              // ── Stats grid ─────────────────────────────────────────────
              _StatsGrid(
                currentStreak: data.displayStreak,
                longestStreak: profile.longestStreak,
                totalWorkouts: data.totalWorkouts,
                streakFreezes: profile.streakFreezeCount,
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
  });

  final Rank rank;
  final int totalSP;
  final double rankProgress;
  final String rankProgressLabel;

  static String _emoji(Rank r) => switch (r) {
        Rank.beginner => '🌱',
        Rank.amateur => '💪',
        Rank.sportsman => '🏃',
        Rank.athlete => '⚡',
        Rank.master => '🔥',
        Rank.legend => '👑',
      };

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                _emoji(rank),
                style: const TextStyle(fontSize: 40),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    rank.localizedName(l10n),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: scheme.onPrimaryContainer,
                        ),
                  ),
                  Text(
                    '$totalSP SP',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: scheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: rankProgress,
              minHeight: 8,
              backgroundColor: scheme.primary.withAlpha(40),
              valueColor:
                  AlwaysStoppedAnimation<Color>(scheme.onPrimaryContainer),
            ),
          ),

          const SizedBox(height: 6),

          Text(
            rankProgressLabel,
            style: TextStyle(
              fontSize: 12,
              color: scheme.onPrimaryContainer,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
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
  });

  final int currentStreak;
  final int longestStreak;
  final int totalWorkouts;
  final int streakFreezes;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Row(
      children: [
        Expanded(child: _StatCell(emoji: '🔥', value: '$currentStreak', label: l10n.profileStatDays)),
        const SizedBox(width: 10),
        Expanded(child: _StatCell(emoji: '🏆', value: '$longestStreak', label: l10n.profileStatRecord)),
        const SizedBox(width: 10),
        Expanded(child: _StatCell(emoji: '💪', value: '$totalWorkouts', label: l10n.profileStatWorkouts)),
        const SizedBox(width: 10),
        Expanded(child: _StatCell(emoji: '❄️', value: '$streakFreezes', label: l10n.profileStatFreezes)),
      ],
    );
  }
}

class _StatCell extends StatelessWidget {
  const _StatCell({
    required this.emoji,
    required this.value,
    required this.label,
  });

  final String emoji;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: scheme.onSurfaceVariant,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ── Workout log tile ──────────────────────────────────────────────────────────

class _WorkoutLogTile extends StatelessWidget {
  const _WorkoutLogTile({required this.log});

  final WorkoutLog log;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).languageCode;

    final dateStr = DateFormat('d MMMM', locale).format(log.date);

    final m = log.durationSec ~/ 60;
    final s = log.durationSec % 60;
    final durationStr = m > 0 ? l10n.durationMin(m, s) : l10n.durationSec(s);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Text('🏋️', style: TextStyle(fontSize: 22)),
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
                  durationStr,
                  style: TextStyle(
                    fontSize: 13,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
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
        ],
      ),
    );
  }
}
