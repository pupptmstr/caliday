import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/build_context_l10n.dart';
import '../../../core/extensions/exercise_l10n.dart';
import '../../../data/models/enums.dart';
import '../../../data/models/exercise.dart';
import '../../../data/models/skill_progress.dart';
import '../../../data/repositories/skill_progress_repository.dart';
import '../../../data/static/exercise_catalog.dart';

// ── Stage state ───────────────────────────────────────────────────────────────

enum _StageState { completed, current, locked }

// ── Provider ─────────────────────────────────────────────────────────────────

final _branchProgressProvider =
    Provider.family.autoDispose<SkillProgress, BranchId>(
  (ref, branchId) =>
      ref.watch(skillProgressRepositoryProvider).getProgress(branchId),
);

// ── Screen ───────────────────────────────────────────────────────────────────

class BranchJourneyScreen extends ConsumerWidget {
  const BranchJourneyScreen({required this.branchId, super.key});

  final BranchId branchId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(_branchProgressProvider(branchId));
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;

    final stages = ExerciseCatalog.progressionFor(branchId);
    final completedCount = (progress.currentStage - 1).clamp(0, branchId.stageCount);

    return Scaffold(
      appBar: AppBar(
        title: Text('${branchId.emoji}  ${branchId.localizedName(l10n)}'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
            child: Text(
              l10n.branchJourneyProgress(completedCount, branchId.stageCount),
              style: TextStyle(
                fontSize: 13,
                color: scheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: stages.length,
              itemBuilder: (ctx, i) {
                final exercise = stages[i];
                final stageState = exercise.stage < progress.currentStage
                    ? _StageState.completed
                    : exercise.stage == progress.currentStage
                        ? _StageState.current
                        : _StageState.locked;
                return _StageRow(
                  exercise: exercise,
                  stageState: stageState,
                  progress: stageState == _StageState.current ? progress : null,
                  isLast: i == stages.length - 1,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Stage row ─────────────────────────────────────────────────────────────────

class _StageRow extends StatelessWidget {
  const _StageRow({
    required this.exercise,
    required this.stageState,
    required this.isLast,
    this.progress,
  });

  final Exercise exercise;
  final _StageState stageState;
  final bool isLast;
  final SkillProgress? progress;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;

    final isCompleted = stageState == _StageState.completed;
    final isCurrent = stageState == _StageState.current;
    final isLocked = stageState == _StageState.locked;

    final Color cardColor = isCurrent
        ? scheme.primaryContainer
        : isCompleted
            ? scheme.surfaceContainerHighest
            : scheme.surfaceContainerLow;

    final p = progress;
    String? paramsLabel;
    double stageProgress = 0;
    if (isCurrent && p != null) {
      final isTimed = exercise.type == ExerciseType.timed;
      paramsLabel = isTimed
          ? l10n.branchJourneyParamsTimed(
              p.currentReps, p.currentSets, p.currentRestSec)
          : l10n.branchJourneyParams(
              p.currentReps, p.currentSets, p.currentRestSec);

      final range = exercise.targetReps - exercise.startReps;
      stageProgress = range <= 0
          ? 1.0
          : ((p.currentReps - exercise.startReps) / range).clamp(0.0, 1.0);
    }

    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Timeline column ──────────────────────────────────────────
          SizedBox(
            width: 44,
            child: Column(
              children: [
                _StageCircle(
                  stage: exercise.stage,
                  stageState: stageState,
                  scheme: scheme,
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 20,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    color: isCompleted
                        ? scheme.primary.withAlpha(120)
                        : scheme.outlineVariant,
                  ),
              ],
            ),
          ),

          // ── Card ────────────────────────────────────────────────────
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 0),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(14),
                border: isCurrent
                    ? Border.all(color: scheme.primary, width: 1.5)
                    : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Exercise name
                  Text(
                    ExerciseL10n.name(l10n, exercise.id),
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: isLocked
                          ? scheme.onSurface.withAlpha(80)
                          : scheme.onSurface,
                    ),
                  ),

                  // Status badge
                  const SizedBox(height: 4),
                  if (isCompleted)
                    Text(
                      l10n.branchJourneyStageCompleted,
                      style: TextStyle(
                        fontSize: 12,
                        color: scheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  else if (isCurrent && paramsLabel != null) ...[
                    Text(
                      l10n.branchJourneyStageCurrent,
                      style: TextStyle(
                        fontSize: 12,
                        color: scheme.onPrimaryContainer,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      paramsLabel,
                      style: TextStyle(
                        fontSize: 12,
                        color: scheme.onPrimaryContainer.withAlpha(200),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: LinearProgressIndicator(
                        value: stageProgress,
                        minHeight: 5,
                        backgroundColor:
                            scheme.primary.withAlpha(40),
                        valueColor:
                            AlwaysStoppedAnimation<Color>(scheme.primary),
                      ),
                    ),
                  ] else if (isLocked)
                    Text(
                      l10n.branchJourneyStageLocked,
                      style: TextStyle(
                        fontSize: 12,
                        color: scheme.onSurface.withAlpha(60),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Stage circle ──────────────────────────────────────────────────────────────

class _StageCircle extends StatelessWidget {
  const _StageCircle({
    required this.stage,
    required this.stageState,
    required this.scheme,
  });

  final int stage;
  final _StageState stageState;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    final isCompleted = stageState == _StageState.completed;
    final isCurrent = stageState == _StageState.current;

    final Color bg = isCompleted
        ? scheme.primary
        : isCurrent
            ? scheme.primary
            : scheme.surfaceContainerHighest;

    final Color fg = isCompleted || isCurrent
        ? scheme.onPrimary
        : scheme.onSurface.withAlpha(80);

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
        border: !isCompleted && !isCurrent
            ? Border.all(color: scheme.outlineVariant)
            : null,
      ),
      child: Center(
        child: isCompleted
            ? Icon(Icons.check_rounded, size: 18, color: fg)
            : Text(
                '$stage',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: fg,
                ),
              ),
      ),
    );
  }
}