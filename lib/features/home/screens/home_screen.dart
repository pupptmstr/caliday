import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/extensions/build_context_l10n.dart';
import '../../../core/providers/goro_expression_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/enums.dart';
import '../../../data/repositories/custom_routine_repository.dart';
import '../../../data/static/exercise_catalog.dart';
import '../../../data/static/exercise_tags_catalog.dart';
import '../../../domain/services/workout_generator_service.dart';
import '../../workout/providers/workout_provider.dart';
import '../providers/home_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(homeDataProvider);
    final expression = ref.watch(goroExpressionProvider);
    final scheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: scheme.surface,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Hero zone ─────────────────────────────────────────────────────
          _HeroZone(
            expression: expression,
            streak: data.displayStreak,
            totalSP: data.profile.totalSP,
            rank: data.profile.rank,
            isDark: isDark,
          ),

          // ── Bottom section ────────────────────────────────────────────────
          Expanded(
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (data.hasWorkoutToday) ...[
                      _DoneMessage(scheme: scheme, l10n: l10n),
                      const SizedBox(height: 16),
                    ],
                    const Spacer(),
                    _WorkoutButton(
                      done: data.hasWorkoutToday,
                      onTap: () => context.push('/workout'),
                    ),
                    const SizedBox(height: 10),
                    _CustomWorkoutButton(scheme: scheme),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Hero zone ──────────────────────────────────────────────────────────────────

class _HeroZone extends StatelessWidget {
  const _HeroZone({
    required this.expression,
    required this.streak,
    required this.totalSP,
    required this.rank,
    required this.isDark,
  });

  final GoroExpression expression;
  final int streak;
  final int totalSP;
  final Rank rank;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final topPadding = MediaQuery.of(context).padding.top;

    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.heroGradient,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.brandBlue.withAlpha(isDark ? 60 : 50),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(24, topPadding + 16, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── App name ──────────────────────────────────────────────────
            const Text(
              'CaliDay',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 16),

            // ── Stats row ─────────────────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: _HeroStat(
                    icon: Icons.local_fire_department,
                    value: '$streak',
                    label: l10n.homeDays,
                    accentColor: AppTheme.energy,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _HeroStat(
                    icon: Icons.bolt,
                    value: '$totalSP',
                    label: 'SP',
                    accentColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _HeroStat(
                    icon: Icons.military_tech,
                    value: rank.localizedName(l10n),
                    label: '',
                    accentColor: Colors.white,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // ── Goro ──────────────────────────────────────────────────────
            Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: SvgPicture.asset(
                  expression.assetPath,
                  key: ValueKey(expression),
                  height: 200,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Hero stat chip ─────────────────────────────────────────────────────────────

class _HeroStat extends StatelessWidget {
  const _HeroStat({
    required this.icon,
    required this.value,
    required this.label,
    required this.accentColor,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(30),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withAlpha(50), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: accentColor),
          const SizedBox(width: 6),
          Text(
            label.isNotEmpty ? '$value $label' : value,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 14,
              color: accentColor == Colors.white ? Colors.white : accentColor,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ── Done message ───────────────────────────────────────────────────────────────

class _DoneMessage extends StatelessWidget {
  const _DoneMessage({required this.scheme, required this.l10n});

  final ColorScheme scheme;
  final dynamic l10n;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.success.withAlpha(20),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.success.withAlpha(60), width: 1),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle_rounded, color: AppTheme.success, size: 20),
          const SizedBox(width: 10),
          Text(
            l10n.homeWorkoutDone,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.success,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Workout button ─────────────────────────────────────────────────────────────

class _WorkoutButton extends StatelessWidget {
  const _WorkoutButton({required this.done, required this.onTap});

  final bool done;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;

    if (done) {
      return SizedBox(
        width: double.infinity,
        height: 64,
        child: FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: scheme.secondaryContainer,
            foregroundColor: scheme.onSecondaryContainer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          onPressed: onTap,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.fitness_center, size: 22),
                  Positioned(
                    right: -6,
                    top: -6,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: scheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.add, size: 9, color: scheme.onPrimary),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 10),
              Text(
                l10n.homeWorkoutAgain,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Primary CTA — gradient button
    return SizedBox(
      width: double.infinity,
      height: 64,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppTheme.brandBlue, AppTheme.brandBlueDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppTheme.brandBlue.withAlpha(80),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: onTap,
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.fitness_center, size: 22, color: Colors.white),
                  const SizedBox(width: 10),
                  Text(
                    l10n.homeWorkoutStart,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Custom Workout secondary button ───────────────────────────────────────────

class _CustomWorkoutButton extends ConsumerWidget {
  const _CustomWorkoutButton({required this.scheme});

  final ColorScheme scheme;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final label = context.l10n.customWorkoutButtonLabel;
    return GestureDetector(
      onTap: () => _showQuickSheet(context, ref),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.tune, size: 18, color: scheme.onSurfaceVariant),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showQuickSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _HomeCustomSheet(),
    );
  }
}

class _HomeCustomSheet extends ConsumerWidget {
  const _HomeCustomSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routines = ref.watch(customRoutinesProvider);

    if (routines.isEmpty) {
      return _QuickRoutineTagPicker(onLaunch: (tag) {
        Navigator.of(context).pop();
        _launchQuick(context, ref, tag);
      });
    }

    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;

    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.4,
      maxChildSize: 0.85,
      expand: false,
      builder: (ctx, scrollCtrl) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Handle + title ─────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: scheme.outlineVariant,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  l10n.customWorkoutMyRoutines,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
                Divider(height: 1, color: scheme.outlineVariant),
              ],
            ),
          ),

          // ── Saved routines list ────────────────────────────────────────
          Expanded(
            child: ListView(
              controller: scrollCtrl,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                for (final routine in routines)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Material(
                      color: scheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(14),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () {
                          Navigator.of(context).pop();
                          _launchRoutine(context, ref, routine.id);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      routine.name,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      l10n.customWorkoutExerciseCount(
                                          routine.exerciseIds.length),
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: scheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(Icons.play_arrow_rounded,
                                  color: scheme.primary),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                // ── Quick Routine at the bottom ──────────────────────────
                const SizedBox(height: 4),
                Divider(height: 1, color: scheme.outlineVariant),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    _showQuickPicker(context, ref);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: scheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.bolt,
                            size: 20, color: scheme.onSecondaryContainer),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.customWorkoutQuickRoutine,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: scheme.onSecondaryContainer,
                                ),
                              ),
                              Text(
                                l10n.customWorkoutQuickRoutineDesc,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: scheme.onSecondaryContainer
                                      .withAlpha(180),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.chevron_right,
                            color: scheme.onSecondaryContainer),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _launchRoutine(BuildContext context, WidgetRef ref, String routineId) {
    final routines = ref.read(customRoutinesProvider);
    final routine = routines.firstWhere((r) => r.id == routineId);
    final generator = ref.read(workoutGeneratorServiceProvider);
    final plan = generator.fromExerciseIds(routine.exerciseIds);
    ref.read(customWorkoutPlanProvider.notifier).set(plan);
    ref.read(customRoutinesProvider.notifier).markRun(routineId);
    context.push('/workout');
  }

  void _showQuickPicker(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _QuickRoutineTagPicker(
        onLaunch: (tag) {
          Navigator.of(context).pop();
          _launchQuick(context, ref, tag);
        },
      ),
    );
  }

  void _launchQuick(BuildContext context, WidgetRef ref, ExerciseTag tag) {
    final tagged = ExerciseCatalog.libraryAll.where((e) {
      final tags = ExerciseTagsCatalog.forId(e.id);
      return tags.contains(tag) &&
          !tags.contains(ExerciseTag.warmup) &&
          !tags.contains(ExerciseTag.cooldown);
    }).toList()
      ..shuffle();
    final count = tagged.length.clamp(4, 6);
    var ids = tagged.take(count).map((e) => e.id).toList();
    if (ids.isEmpty) return;
    ids = WorkoutGeneratorService.addGenericWarmupCooldown(ids);
    final generator = ref.read(workoutGeneratorServiceProvider);
    final plan = generator.fromExerciseIds(ids);
    ref.read(customWorkoutPlanProvider.notifier).set(plan);
    context.push('/workout');
  }
}

// ── Quick Routine tag picker (reused in home sheet) ───────────────────────────

class _QuickRoutineTagPicker extends StatelessWidget {
  const _QuickRoutineTagPicker({required this.onLaunch});

  final void Function(ExerciseTag tag) onLaunch;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: scheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.customWorkoutPickFocus,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.customWorkoutQuickRoutineDesc,
            style: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ExerciseTag.values.map((tag) {
              return GestureDetector(
                onTap: () => onLaunch(tag),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: tag.color.withAlpha(30),
                    borderRadius: BorderRadius.circular(20),
                    border:
                        Border.all(color: tag.color.withAlpha(80), width: 1),
                  ),
                  child: Text(
                    tag.localizedName(l10n),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: tag.color,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}