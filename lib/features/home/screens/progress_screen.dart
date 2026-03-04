import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/extensions/build_context_l10n.dart';
import '../../../core/extensions/exercise_l10n.dart';
import '../../../data/models/enums.dart';
import '../../../data/models/skill_progress.dart';
import '../../../data/static/exercise_catalog.dart';
import '../../workout/providers/workout_provider.dart';
import '../providers/home_provider.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(homeDataProvider);
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.progressTitle),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Info banner ───────────────────────────────────────────
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 18,
                      color: Theme.of(context)
                          .colorScheme
                          .onSecondaryContainer,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        l10n.progressInfo,
                        style: TextStyle(
                          fontSize: 13,
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              Text(
                l10n.homeBranchesTitle,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              for (final branch in data.activeBranches) ...[
                if (branch != data.activeBranches.first)
                  const SizedBox(height: 10),
                _BranchProgressCard(
                  branch: branch,
                  progress: data.progressMap[branch]!,
                  exerciseName: ExerciseL10n.name(
                    l10n,
                    ExerciseCatalog.forStage(
                              branch,
                              data.progressMap[branch]!.currentStage,
                            )?.id ??
                        '',
                  ),
                  onTap: () => context.push('/branch/${branch.name}'),
                ),
                if (data.progressMap[branch]!.isChallengeUnlocked) ...[
                  const SizedBox(height: 10),
                  _ChallengeCard(
                    branch: branch,
                    progress: data.progressMap[branch]!,
                  ),
                ],
              ],
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Branch progress card ──────────────────────────────────────────────────────

class _BranchProgressCard extends StatelessWidget {
  const _BranchProgressCard({
    required this.branch,
    required this.progress,
    required this.exerciseName,
    this.onTap,
  });

  final BranchId branch;
  final SkillProgress progress;
  final String exerciseName;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;

    final exercise = ExerciseCatalog.forStage(
      progress.branchId,
      progress.currentStage,
    );

    final double stageProgress;
    if (exercise == null) {
      stageProgress = 1.0;
    } else {
      final range = exercise.targetReps - exercise.startReps;
      stageProgress = range <= 0
          ? 1.0
          : ((progress.currentReps - exercise.startReps) / range)
              .clamp(0.0, 1.0);
    }

    return Material(
      color: scheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(branch.icon, size: 24, color: scheme.primary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              branch.localizedName(l10n),
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              l10n.homeStage(
                                  progress.currentStage, branch.stageCount),
                              style: TextStyle(
                                fontSize: 12,
                                color: scheme.onSurfaceVariant,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          exerciseName,
                          style: TextStyle(
                            fontSize: 13,
                            color: scheme.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: LinearProgressIndicator(
                  value: stageProgress,
                  minHeight: 6,
                  backgroundColor: scheme.outlineVariant,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    progress.isChallengeUnlocked
                        ? scheme.tertiary
                        : scheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Challenge card ────────────────────────────────────────────────────────────

class _ChallengeCard extends ConsumerWidget {
  const _ChallengeCard({required this.branch, required this.progress});

  final BranchId branch;
  final SkillProgress progress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;

    final next = ExerciseCatalog.forStage(branch, progress.currentStage + 1);
    if (next == null) return const SizedBox.shrink();

    final isTimed = next.type == ExerciseType.timed;
    final normLabel = isTimed
        ? l10n.homeChallengeNormSec(next.challengeTargetReps)
        : l10n.homeChallengeNormReps(next.challengeTargetReps);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.homeChallengeUnlocked,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: scheme.onTertiaryContainer,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            ExerciseL10n.name(l10n, next.id),
            style: TextStyle(
              fontSize: 13,
              color: scheme.onTertiaryContainer,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            normLabel,
            style: TextStyle(
              fontSize: 12,
              color: scheme.onTertiaryContainer.withAlpha(180),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: scheme.tertiary,
                foregroundColor: scheme.onTertiary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                ref.read(challengeBranchProvider.notifier).state = branch;
                context.push('/workout');
              },
              child: Text(
                l10n.homeChallengeButton,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
