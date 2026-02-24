import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/models/enums.dart';
import '../../../data/models/skill_progress.dart';
import '../../../data/static/exercise_catalog.dart';
import '../providers/home_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(homeDataProvider);
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),

              // ── Header ──────────────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'CaliDay',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: scheme.primary,
                        ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.person_outline_rounded),
                    onPressed: () => context.push('/profile'),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ── Stats row ─────────────────────────────────────────────
              Row(
                children: [
                  Flexible(
                    child: _StatChip(
                      emoji: '🔥',
                      value: '${data.profile.currentStreak}',
                      label: 'дней',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: _StatChip(
                      emoji: '⚡',
                      value: '${data.profile.totalSP}',
                      label: 'SP',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: _StatChip(
                      emoji: '🏅',
                      value: data.profile.rank.displayName,
                      label: '',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // ── Branch cards ──────────────────────────────────────────
              Text(
                'Ветки прогрессии',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),

              _BranchProgressCard(
                emoji: '💪',
                branchName: 'Толкай',
                progress: data.pushProgress,
                totalStages: ExerciseCatalog.pushProgression.length,
                exerciseName: data.pushExerciseName,
              ),
              const SizedBox(height: 10),
              _BranchProgressCard(
                emoji: '🎯',
                branchName: 'Кор',
                progress: data.coreProgress,
                totalStages: ExerciseCatalog.coreProgression.length,
                exerciseName: data.coreExerciseName,
              ),

              const Spacer(),

              // ── Daily workout button ───────────────────────────────────
              _WorkoutButton(
                done: data.hasWorkoutToday,
                onTap: () => context.push('/workout'),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Stat chip ─────────────────────────────────────────────────────────────────

class _StatChip extends StatelessWidget {
  const _StatChip({
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
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label.isNotEmpty ? '$value $label' : value,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: scheme.onPrimaryContainer,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Branch progress card ──────────────────────────────────────────────────────

class _BranchProgressCard extends StatelessWidget {
  const _BranchProgressCard({
    required this.emoji,
    required this.branchName,
    required this.progress,
    required this.totalStages,
    required this.exerciseName,
  });

  final String emoji;
  final String branchName;
  final SkillProgress progress;
  final int totalStages;
  final String exerciseName;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    // Within-stage progress: how far along from startReps to targetReps.
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

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          branchName,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Этап ${progress.currentStage}/$totalStages',
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

          // Progress bar
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

          if (progress.isChallengeUnlocked) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.emoji_events_rounded,
                    size: 14, color: scheme.tertiary),
                const SizedBox(width: 4),
                Text(
                  'Challenge разблокирован!',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: scheme.tertiary,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// ── Daily workout button ───────────────────────────────────────────────────────

class _WorkoutButton extends StatelessWidget {
  const _WorkoutButton({required this.done, required this.onTap});

  final bool done;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: FilledButton.icon(
        icon: Text(
          done ? '✅' : '🏋️',
          style: const TextStyle(fontSize: 22),
        ),
        label: Text(
          done ? 'Тренировка выполнена' : 'Тренировка дня',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        style: FilledButton.styleFrom(
          backgroundColor:
              done ? scheme.secondaryContainer : scheme.primary,
          foregroundColor:
              done ? scheme.onSecondaryContainer : scheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        onPressed: done ? null : onTap,
      ),
    );
  }
}