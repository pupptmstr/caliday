import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../core/extensions/build_context_l10n.dart';
import '../../../core/extensions/exercise_l10n.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/enums.dart';
import '../../../data/models/exercise.dart';
import '../../../data/static/exercise_tags_catalog.dart';

class ExerciseDetailSheet extends StatelessWidget {
  const ExerciseDetailSheet({super.key, required this.exercise});

  final Exercise exercise;

  static void show(BuildContext context, Exercise exercise) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => ExerciseDetailSheet(exercise: exercise),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tags = ExerciseTagsCatalog.forId(exercise.id);

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (_, controller) {
        return Column(
          children: [
            // Handle
            const SizedBox(height: 12),
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
            const SizedBox(height: 8),

            Expanded(
              child: SingleChildScrollView(
                controller: controller,
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Animation or placeholder
                    _AnimationBox(
                      exercise: exercise,
                      isDark: isDark,
                      scheme: scheme,
                    ),
                    const SizedBox(height: 20),

                    // Branch badge + stage
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: scheme.primaryContainer,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(exercise.branch.icon,
                                  size: 14, color: scheme.onPrimaryContainer),
                              const SizedBox(width: 5),
                              Text(
                                exercise.branch.localizedName(l10n),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: scheme.onPrimaryContainer,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (exercise.stage > 0) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: scheme.secondaryContainer,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              l10n.exerciseDetailStageLabel(exercise.stage),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: scheme.onSecondaryContainer,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Exercise name
                    Text(
                      ExerciseL10n.name(l10n, exercise.id),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: 12),

                    // Tags
                    if (tags.isNotEmpty) ...[
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: tags
                            .map((tag) => _TagChip(tag: tag))
                            .toList(),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Description
                    Text(
                      ExerciseL10n.description(l10n, exercise.id),
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.5,
                        color: scheme.onSurface,
                      ),
                    ),

                    // Technique tip
                    if (ExerciseL10n.tip(l10n, exercise.id) != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppTheme.brandBlueDeep.withAlpha(60)
                              : AppTheme.brandBlue.withAlpha(20),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppTheme.brandBlue.withAlpha(60),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.tips_and_updates_outlined,
                                size: 18, color: AppTheme.brandBlue),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l10n.exerciseDetailTipLabel,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: AppTheme.brandBlue,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    ExerciseL10n.tip(l10n, exercise.id)!,
                                    style: TextStyle(
                                      fontSize: 14,
                                      height: 1.4,
                                      color: scheme.onSurface,
                                    ),
                                  ),
                                ],
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
          ],
        );
      },
    );
  }
}

class _AnimationBox extends StatelessWidget {
  const _AnimationBox({
    required this.exercise,
    required this.isDark,
    required this.scheme,
  });

  final Exercise exercise;
  final bool isDark;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    final animPath = exercise.animationPath;

    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
        boxShadow:
            isDark ? AppTheme.cardShadowDark : AppTheme.cardShadowLight,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: animPath != null
            ? Lottie.asset(
                animPath,
                fit: BoxFit.contain,
                repeat: true,
              )
            : Center(
                child: Icon(
                  exercise.branch.icon,
                  size: 64,
                  color: scheme.onSurfaceVariant.withAlpha(80),
                ),
              ),
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({required this.tag});

  final ExerciseTag tag;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final color = tag.color;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withAlpha(80)),
      ),
      child: Text(
        tag.localizedName(l10n),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }
}