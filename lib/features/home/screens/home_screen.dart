import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/extensions/build_context_l10n.dart';
import '../../../core/providers/goro_expression_provider.dart';
import '../../../data/models/enums.dart';
import '../providers/home_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(homeDataProvider);
    final expression = ref.watch(goroExpressionProvider);
    final scheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;

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
              Text(
                'CaliDay',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: scheme.primary,
                    ),
              ),

              const SizedBox(height: 16),

              // ── Stats row ─────────────────────────────────────────────
              Row(
                children: [
                  Flexible(
                    child: _StatChip(
                      icon: Icons.local_fire_department,
                      value: '${data.displayStreak}',
                      label: l10n.homeDays,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: _StatChip(
                      icon: Icons.bolt,
                      value: '${data.profile.totalSP}',
                      label: 'SP',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: _StatChip(
                      icon: Icons.military_tech,
                      value: data.profile.rank.localizedName(l10n),
                      label: '',
                    ),
                  ),
                ],
              ),

              // ── Goro hero ─────────────────────────────────────────────
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        child: SvgPicture.asset(
                          expression.assetPath,
                          key: ValueKey(expression),
                          height: 180,
                        ),
                      ),
                      if (data.hasWorkoutToday) ...[
                        const SizedBox(height: 12),
                        Text(
                          l10n.homeWorkoutDone,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              // ── Workout button ─────────────────────────────────────────
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
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
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
          Icon(icon, size: 18, color: scheme.onPrimaryContainer),
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

// ── Workout button ─────────────────────────────────────────────────────────────

class _WorkoutButton extends StatelessWidget {
  const _WorkoutButton({required this.done, required this.onTap});

  final bool done;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: double.infinity,
      height: 64,
      child: FilledButton.icon(
        icon: Icon(done ? Icons.check_circle_outline : Icons.fitness_center),
        label: Text(
          done ? l10n.homeWorkoutAgain : l10n.homeWorkoutStart,
          style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
        ),
        style: FilledButton.styleFrom(
          backgroundColor: done ? scheme.secondaryContainer : scheme.primary,
          foregroundColor:
              done ? scheme.onSecondaryContainer : scheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: onTap,
      ),
    );
  }
}
