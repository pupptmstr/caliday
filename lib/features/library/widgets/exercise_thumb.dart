import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../data/models/enums.dart';
import '../../../data/models/exercise.dart';
import '../../../data/static/animation_crops.dart';
import 'exercise_detail_sheet.dart';

/// Goro's animation of [exercise] in a small rounded tile, wherever an
/// exercise is named (0.9.4, owner: "where possible, the exercise
/// animations"); its branch icon when it has none. A tap opens the exercise
/// sheet unless [onTap] says otherwise. The lottie package caches each
/// composition, so a list of thumbs parses every file once.
class ExerciseThumb extends StatelessWidget {
  const ExerciseThumb(
    this.exercise, {
    super.key,
    this.size = 48,
    this.animate = true,
    this.onTap,
    this.tappable = true,
  });

  final Exercise exercise;
  final double size;

  /// false: the first frame only.
  final bool animate;

  /// Instead of the exercise sheet.
  final VoidCallback? onTap;

  /// false: the tap goes to the parent (a row that has its own action).
  final bool tappable;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final path = exercise.animationPath;
    final tile = ClipRRect(
      borderRadius: BorderRadius.circular(size * 0.24),
      child: Container(
        width: size,
        height: size,
        // A shade lighter than the cards in the dark theme, so that Goro's
        // dark fur stands out.
        color: isDark
            ? Color.alphaBlend(
                scheme.onSurface.withAlpha(38), scheme.surfaceContainerHighest)
            : scheme.surfaceContainerHighest,
        child: path != null
            ? _Cropped(
                crop: kAnimationCrops[path] ?? (0, 0, 400),
                size: size,
                child: Lottie.asset(path, animate: animate, fit: BoxFit.fill),
              )
            : Icon(exercise.branch.icon,
                size: size * 0.5, color: scheme.onSurfaceVariant.withAlpha(120)),
      ),
    );
    if (!tappable) return tile;
    return GestureDetector(
      onTap: onTap ?? () => ExerciseDetailSheet.show(context, exercise),
      child: tile,
    );
  }
}

/// [child] with [exercise]'s [ExerciseThumb] on its left (the stage cards of
/// the Branch Journey, the challenge card of the Courses tab).
class ThumbRow extends StatelessWidget {
  const ThumbRow({
    super.key,
    required this.exercise,
    required this.child,
    this.size = 56,
    this.dimmed = false,
  });

  final Exercise exercise;
  final Widget child;
  final double size;

  /// A stage still locked: the animation is shown, but faded.
  final bool dimmed;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Opacity(
            opacity: dimmed ? 0.45 : 1,
            child: ExerciseThumb(exercise, size: size),
          ),
          const SizedBox(width: 12),
          Expanded(child: child),
        ],
      );
}

/// [child] (a 400 x 400 animation canvas) scaled so that the square [crop]
/// fills [size] ([kAnimationCrops]: the figure, not the empty canvas).
class _Cropped extends StatelessWidget {
  const _Cropped({required this.crop, required this.size, required this.child});

  final (int, int, int) crop;
  final double size;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final (left, top, side) = crop;
    final k = size / side;
    return ClipRect(
      child: OverflowBox(
        alignment: Alignment.topLeft,
        minWidth: 0,
        minHeight: 0,
        maxWidth: double.infinity,
        maxHeight: double.infinity,
        child: Transform.translate(
          offset: Offset(-left * k, -top * k),
          child: SizedBox(width: 400 * k, height: 400 * k, child: child),
        ),
      ),
    );
  }
}
