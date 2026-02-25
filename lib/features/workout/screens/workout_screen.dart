import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/models/enums.dart';
import '../providers/workout_provider.dart';

class WorkoutScreen extends ConsumerStatefulWidget {
  const WorkoutScreen({super.key});

  @override
  ConsumerState<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends ConsumerState<WorkoutScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => ref.read(workoutProvider.notifier).tick(),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _confirmExit(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Прервать тренировку?'),
        content: const Text('Прогресс текущей тренировки не сохранится.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Продолжить'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Прервать'),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      _timer?.cancel();
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(workoutProvider);
    final notifier = ref.read(workoutProvider.notifier);

    // Navigate to summary when workout is finished.
    ref.listen<WorkoutPhase>(
      workoutProvider.select((s) => s.phase),
      (_, phase) {
        if (phase == WorkoutPhase.done) {
          _timer?.cancel();
          final s = ref.read(workoutProvider);
          final mainCount =
              s.plan.exercises.where((e) => e.exercise.stage > 0).length;
          context.pushReplacement('/summary', extra: {
            'spEarned': s.spEarned,
            'durationSec': s.durationSec,
            'exerciseCount': mainCount,
          });
        }
      },
    );

    if (state.phase == WorkoutPhase.done) {
      return const Scaffold(body: SizedBox.shrink());
    }

    final overallProgress =
        (state.exerciseIndex + 1) / state.plan.exercises.length;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _confirmExit(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Тренировка'),
          leading: IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: () => _confirmExit(context),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4),
            child: LinearProgressIndicator(
              value: overallProgress,
              minHeight: 4,
            ),
          ),
        ),
        body: SafeArea(
          child: state.phase == WorkoutPhase.rest
              ? _RestView(state: state, notifier: notifier)
              : _ExerciseView(state: state, notifier: notifier),
        ),
      ),
    );
  }
}

// ── Exercise phase ────────────────────────────────────────────────────────────

class _ExerciseView extends StatelessWidget {
  const _ExerciseView({required this.state, required this.notifier});

  final WorkoutState state;
  final WorkoutNotifier notifier;

  @override
  Widget build(BuildContext context) {
    final planned = state.currentPlanned;
    final exercise = planned.exercise;
    final isTimed = exercise.type == ExerciseType.timed;
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Scrollable content (name, description, tip) ──────────────
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Set indicator
                Text(
                  'Подход ${state.setIndex + 1} из ${planned.sets}',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: scheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                ),

                const SizedBox(height: 8),

                // Exercise name
                Text(
                  exercise.name,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w800),
                ),

                const SizedBox(height: 8),

                // Description
                Text(
                  exercise.description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                ),

                // Technique tip
                if (exercise.techniqueTip != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: scheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('💡', style: TextStyle(fontSize: 14)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            exercise.techniqueTip!,
                            style: TextStyle(
                              fontSize: 13,
                              color: scheme.onPrimaryContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),

        // ── Fixed bottom: interactive element + button ────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (isTimed)
                _TimedDisplay(
                  timerSec: state.timerSec,
                  targetSec: planned.targetAmount,
                )
              else
                _RepsDisplay(
                  repsInput: state.repsInput,
                  onAdjust: notifier.adjustReps,
                ),

              const SizedBox(height: 24),

              FilledButton(
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: isTimed
                    ? () {
                        final elapsed = planned.targetAmount - state.timerSec;
                        notifier.confirmSet(actualDurationSec: elapsed);
                      }
                    : () => notifier.confirmSet(),
                child: Text(
                  isTimed ? '⏹  Стоп' : '✓  Готово',
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Timed display (circular countdown) ───────────────────────────────────────

class _TimedDisplay extends StatelessWidget {
  const _TimedDisplay({required this.timerSec, required this.targetSec});

  final int timerSec;
  final int targetSec;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final progress = targetSec > 0 ? timerSec / targetSec : 0.0;
    final mins = timerSec ~/ 60;
    final secs = timerSec % 60;
    final timeStr =
        mins > 0 ? '$mins:${secs.toString().padLeft(2, '0')}' : '$timerSec';

    return Center(
      child: SizedBox(
        width: 148,
        height: 148,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 148,
              height: 148,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 8,
                backgroundColor: scheme.outlineVariant,
                color: scheme.primary,
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  timeStr,
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                Text('сек',
                    style: TextStyle(color: scheme.onSurfaceVariant)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Reps display (+/- counter) ────────────────────────────────────────────────

class _RepsDisplay extends StatelessWidget {
  const _RepsDisplay({required this.repsInput, required this.onAdjust});

  final int repsInput;
  final void Function(int delta) onAdjust;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Text(
          'Повторения',
          style: TextStyle(
            fontSize: 14,
            color: scheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _CounterButton(
              icon: Icons.remove_rounded,
              onTap: () => onAdjust(-1),
            ),
            const SizedBox(width: 28),
            Text(
              '$repsInput',
              style: Theme.of(context)
                  .textTheme
                  .displaySmall
                  ?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(width: 28),
            _CounterButton(
              icon: Icons.add_rounded,
              onTap: () => onAdjust(1),
            ),
          ],
        ),
      ],
    );
  }
}

class _CounterButton extends StatelessWidget {
  const _CounterButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 28, color: scheme.onSurface),
      ),
    );
  }
}

// ── Rest phase ────────────────────────────────────────────────────────────────

class _RestView extends StatelessWidget {
  const _RestView({required this.state, required this.notifier});

  final WorkoutState state;
  final WorkoutNotifier notifier;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final restSec = state.currentPlanned.restSec;
    final progress = restSec > 0 ? state.timerSec / restSec : 0.0;

    // Title and upcoming label differ between inter-set and inter-exercise rest.
    final String title;
    final String upcomingLabel;

    if (state.isInterExerciseRest) {
      final nextPlanned = state.plan.exercises[state.exerciseIndex + 1];
      final nextExercise = nextPlanned.exercise;
      final isTimed = nextExercise.type == ExerciseType.timed;
      final amount = nextPlanned.targetAmount;
      final unit = isTimed ? 'сек' : 'повт.';
      title = '✅  Упражнение выполнено!';
      upcomingLabel =
          'Следующее: ${nextExercise.name} • $amount $unit';
    } else {
      final planned = state.currentPlanned;
      final isTimed = planned.exercise.type == ExerciseType.timed;
      final unit = isTimed ? 'сек' : 'повт.';
      title = '✅  Подход выполнен!';
      upcomingLabel =
          'Следующий: подход ${state.setIndex + 2} • ${planned.targetAmount} $unit';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Scrollable content ────────────────────────────────────────
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 16),
            child: Column(
              children: [
                Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 32),

                // Countdown ring
                Center(
                  child: SizedBox(
                    width: 148,
                    height: 148,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 148,
                          height: 148,
                          child: CircularProgressIndicator(
                            value: progress,
                            strokeWidth: 8,
                            backgroundColor: scheme.outlineVariant,
                            color: scheme.secondary,
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${state.timerSec}',
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            Text(
                              'отдых',
                              style:
                                  TextStyle(color: scheme.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                Text(
                  upcomingLabel,
                  style: TextStyle(
                    color: scheme.onSurfaceVariant,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),

        // ── Fixed bottom: skip button ─────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onPressed: notifier.skipRest,
            child: const Text(
              'Пропустить',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }
}