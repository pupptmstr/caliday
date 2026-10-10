import 'package:flutter/material.dart';

import '../../../core/extensions/build_context_l10n.dart';
import '../../../core/extensions/exercise_l10n.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/enums.dart';
import '../../../domain/models/workout_plan.dart';
import '../../library/widgets/exercise_detail_sheet.dart';
import '../../library/widgets/exercise_thumb.dart';

/// The workout button of Home with the plan folded into it (owner,
/// 2026-10-10): the arrow at its right end unfolds the exercises of [plan]
/// above the label, each with Goro's animation; a tap on one opens its sheet.
/// Always folded when Home opens. [done]: the secondary "Again" style.
class WorkoutPlanButton extends StatefulWidget {
  const WorkoutPlanButton({
    super.key,
    required this.done,
    required this.plan,
    required this.onStart,
    required this.maxPlanHeight,
    this.estimatedMinutes,
  });

  final bool done;

  /// How tall the unfolded plan may grow: the room Home has left above the
  /// buttons (it scrolls inside when longer).

  /// The plan the button starts (the day's own, or the bonus one).
  final WorkoutPlan plan;
  final VoidCallback onStart;
  final double maxPlanHeight;

  /// About how long it takes; null when there is nothing to say.
  final int? estimatedMinutes;

  @override
  State<WorkoutPlanButton> createState() => _WorkoutPlanButtonState();
}

class _WorkoutPlanButtonState extends State<WorkoutPlanButton> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final done = widget.done;
    final fg = done ? scheme.onSecondaryContainer : Colors.white;
    final minutes = widget.estimatedMinutes;
    final label = done
        ? (minutes != null && minutes > 0
              ? l10n.homeWorkoutAgainEstimate(minutes)
              : l10n.homeWorkoutAgain)
        : (minutes != null && minutes > 0
              ? l10n.homeWorkoutStartEstimate(minutes)
              : l10n.homeWorkoutStart);
    const radius = BorderRadius.all(Radius.circular(20));

    return DecoratedBox(
      decoration: done
          ? BoxDecoration(
              color: scheme.secondaryContainer,
              borderRadius: radius,
            )
          : BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.brandBlue, AppTheme.brandBlueDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: radius,
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
        borderRadius: radius,
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSize(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              alignment: Alignment.bottomCenter,
              child: _open && widget.plan.exercises.isNotEmpty
                  ? _PlanList(
                      plan: widget.plan,
                      maxHeight: widget.maxPlanHeight,
                    )
                  : const SizedBox(width: double.infinity),
            ),
            SizedBox(
              height: 64,
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        setState(() => _open = false);
                        widget.onStart();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _ButtonIcon(done: done, color: fg),
                              const SizedBox(width: 10),
                              Flexible(
                                child: Text(
                                  label,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                    color: fg,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(width: 1, height: 30, color: fg.withAlpha(70)),
                  // A narrow strip: the label is the button, the arrow a
                  // side door (owner: "not half of the button").
                  SizedBox(
                    width: 52,
                    height: 64,
                    child: InkWell(
                      onTap: () => setState(() => _open = !_open),
                      child: Tooltip(
                        message: _open ? l10n.homePlanHide : l10n.homePlanShow,
                        child: AnimatedRotation(
                          turns: _open ? 0.5 : 0,
                          duration: const Duration(milliseconds: 220),
                          child: Icon(
                            Icons.keyboard_arrow_up_rounded,
                            size: 28,
                            color: fg,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ButtonIcon extends StatelessWidget {
  const _ButtonIcon({required this.done, required this.color});

  final bool done;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    if (!done) return Icon(Icons.fitness_center, size: 22, color: color);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(Icons.fitness_center, size: 22, color: color),
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
    );
  }
}

/// The exercises of the plan on a card inside the button.
class _PlanList extends StatelessWidget {
  const _PlanList({required this.plan, required this.maxHeight});

  final WorkoutPlan plan;
  final double maxHeight;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      constraints: BoxConstraints(maxHeight: maxHeight),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(vertical: 6),
        children: [for (final e in plan.exercises) PlanExerciseRow(e)],
      ),
    );
  }
}

/// One exercise of a plan: Goro's animation, the name and the amount.
class PlanExerciseRow extends StatelessWidget {
  const PlanExerciseRow(this.planned, {super.key});

  final PlannedExercise planned;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final e = planned.exercise;
    final amount = e.type == ExerciseType.timed
        ? (e.holdsPerSet == 2
              ? l10n.homePlanSecondsPerSide(planned.sets, planned.targetAmount)
              : l10n.homePlanSeconds(planned.sets, planned.targetAmount))
        : l10n.homePlanReps(planned.sets, planned.targetAmount);
    return InkWell(
      onTap: () => ExerciseDetailSheet.show(context, e),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            ExerciseThumb(e, size: 44, tappable: false),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ExerciseL10n.name(l10n, e.id),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: scheme.onSurface,
                    ),
                  ),
                  Text(
                    amount,
                    style: TextStyle(
                      fontSize: 12,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
