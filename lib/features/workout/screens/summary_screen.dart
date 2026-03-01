import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/extensions/achievement_l10n.dart';
import '../../../core/extensions/build_context_l10n.dart';
import '../../../core/extensions/exercise_l10n.dart';
import '../../../data/static/achievement_catalog.dart';

/// Post-workout summary screen.
///
/// Expects a [Map<String, dynamic>] via [GoRouterState.extra] with:
///   - `spEarned`      — [int]
///   - `durationSec`   — [int]
///   - `exerciseCount` — [int]
class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key, required this.extras});

  final Map<String, dynamic> extras;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final spEarned = extras['spEarned'] as int? ?? 0;
    final durationSec = extras['durationSec'] as int? ?? 0;
    final exerciseCount = extras['exerciseCount'] as int? ?? 0;
    final freezeEarned = extras['freezeEarned'] as bool? ?? false;
    final freezeUsed = extras['freezeUsed'] as bool? ?? false;
    final challengeUnlocked = extras['challengeUnlocked'] as bool? ?? false;
    final challengePassed = extras['challengePassed'] as bool? ?? false;
    final newStageExerciseId = extras['newStageExerciseId'] as String?;
    final isBonus = !(extras['isPrimary'] as bool? ?? true);
    final workoutsToday = extras['workoutsToday'] as int? ?? 1;
    final rawIds = extras['newAchievementIds'];
    final newAchievementIds =
        rawIds is List ? rawIds.cast<String>() : <String>[];

    final mins = durationSec ~/ 60;
    final secs = durationSec % 60;
    final durationStr = mins > 0
        ? l10n.durationMin(mins, secs)
        : l10n.durationSec(secs);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: SvgPicture.asset(
                  'assets/goro/goro_flex_v2.svg',
                  height: 120,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.summaryTitle,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.summarySubtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              // Stats row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _StatTile(value: '+$spEarned', label: 'SP'),
                  _StatTile(value: durationStr, label: l10n.summaryLabelTime),
                  _StatTile(value: '$exerciseCount', label: l10n.summaryLabelExercises),
                ],
              ),

              const SizedBox(height: 24),

              if (newAchievementIds.isNotEmpty) ...[
                _AchievementsEarnedBanner(ids: newAchievementIds),
                const SizedBox(height: 10),
              ],
              if (isBonus) _BonusWorkoutBanner(workoutsToday: workoutsToday),
              if (isBonus && (freezeUsed || freezeEarned || challengeUnlocked))
                const SizedBox(height: 10),
              if (freezeUsed) const _FreezeUsedBanner(),
              if (freezeUsed && freezeEarned) const SizedBox(height: 10),
              if (freezeEarned) const _FreezeEarnedBanner(),
              if ((freezeUsed || freezeEarned) && challengeUnlocked)
                const SizedBox(height: 10),
              if (challengeUnlocked) const _ChallengeUnlockedBanner(),
              if (challengeUnlocked && challengePassed)
                const SizedBox(height: 10),
              if (challengePassed && newStageExerciseId != null)
                _ChallengePassedBanner(exerciseId: newStageExerciseId),

              const SizedBox(height: 28),

              FilledButton(
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () => context.go('/home'),
                child: Text(
                  l10n.summaryHome,
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FreezeUsedBanner extends StatelessWidget {
  const _FreezeUsedBanner();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l = context.l10n;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Text('❄️', style: TextStyle(fontSize: 28)),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l.summaryFreezeUsedTitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              Text(
                l.summaryFreezeUsedBody,
                style: TextStyle(
                  fontSize: 12,
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FreezeEarnedBanner extends StatelessWidget {
  const _FreezeEarnedBanner();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l = context.l10n;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Text('❄️', style: TextStyle(fontSize: 28)),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l.summaryFreezeEarnedTitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              Text(
                l.summaryFreezeEarnedBody,
                style: TextStyle(
                  fontSize: 12,
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChallengeUnlockedBanner extends StatelessWidget {
  const _ChallengeUnlockedBanner();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l = context.l10n;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: scheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Text('🏆', style: TextStyle(fontSize: 28)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.summaryChallengeUnlockedTitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: scheme.onTertiaryContainer,
                      ),
                ),
                Text(
                  l.summaryChallengeUnlockedBody,
                  style: TextStyle(
                    fontSize: 12,
                    color: scheme.onTertiaryContainer.withAlpha(180),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AchievementsEarnedBanner extends StatelessWidget {
  const _AchievementsEarnedBanner({required this.ids});

  final List<String> ids;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l = context.l10n;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.summaryAchievementsTitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: scheme.onPrimaryContainer,
                ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ids.map((id) {
              final a = AchievementCatalog.byId(id);
              return GestureDetector(
                onTap: () => _showSheet(context, id),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: scheme.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(a?.emoji ?? '🏅',
                          style: const TextStyle(fontSize: 16)),
                      const SizedBox(width: 6),
                      Text(
                        AchievementL10n.name(l, id),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: scheme.onPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void _showSheet(BuildContext context, String id) {
    final l = context.l10n;
    final a = AchievementCatalog.byId(id);
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
            Text(a?.emoji ?? '🏅', style: const TextStyle(fontSize: 48)),
            const SizedBox(height: 12),
            Text(
              AchievementL10n.name(l, id),
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w800),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              AchievementL10n.desc(l, id),
              style: TextStyle(
                  fontSize: 15,
                  color: Theme.of(context).colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _BonusWorkoutBanner extends StatelessWidget {
  const _BonusWorkoutBanner({required this.workoutsToday});

  final int workoutsToday;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l = context.l10n;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: scheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Text('💪', style: TextStyle(fontSize: 28)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.summaryBonusTitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: scheme.onTertiaryContainer,
                      ),
                ),
                Text(
                  l.summaryBonusBody,
                  style: TextStyle(
                    fontSize: 12,
                    color: scheme.onTertiaryContainer.withAlpha(180),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  l.summaryBonusCount(workoutsToday),
                  style: TextStyle(
                    fontSize: 12,
                    color: scheme.onTertiaryContainer.withAlpha(180),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChallengePassedBanner extends StatelessWidget {
  const _ChallengePassedBanner({required this.exerciseId});

  final String exerciseId;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l = context.l10n;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: scheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Text('🎉', style: TextStyle(fontSize: 28)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.summaryChallengePassedTitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: scheme.onTertiaryContainer,
                      ),
                ),
                Text(
                  l.summaryChallengePassedBody(ExerciseL10n.name(l, exerciseId)),
                  style: TextStyle(
                    fontSize: 12,
                    color: scheme.onTertiaryContainer.withAlpha(180),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: scheme.primary,
              ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: scheme.onSurfaceVariant,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
