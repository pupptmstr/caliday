import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/extensions/build_context_l10n.dart';
import '../../../core/extensions/exercise_l10n.dart';
import '../../../data/models/enums.dart';
import '../../../data/models/skill_progress.dart';
import '../../../data/models/user_profile.dart';
import '../../../data/repositories/skill_progress_repository.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../data/static/course_catalog.dart';
import '../../../data/static/exercise_catalog.dart';
import '../../home/providers/home_provider.dart';
import '../../workout/providers/workout_provider.dart';

/// Reactive list of enrolled courses — invalidated after enrollment changes
/// so that LibraryScreen rebuilds immediately.
final enrolledCoursesProvider = Provider<List<CourseId>>((ref) {
  return ref.watch(userRepositoryProvider).getProfile().enrolledCourses;
});

class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    // Watch enrolledCoursesProvider so the screen rebuilds after enrollment changes.
    final enrolledCourses = ref.watch(enrolledCoursesProvider);
    final activeCourse = ref.watch(activeCourseProvider);
    final profile = ref.read(userRepositoryProvider).getProfile();
    final progressRepo = ref.watch(skillProgressRepositoryProvider);

    final courseBranches = profile.branchesForCourse(activeCourse);
    final progressMap = <BranchId, SkillProgress>{
      for (final b in courseBranches)
        b: progressRepo.getProgress(b, course: activeCourse),
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.libraryTitle),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ── Course pills + add button (always visible) ───────────────
            const SizedBox(height: 8),
            _CoursePillsRow(
              courses: enrolledCourses,
              active: activeCourse,
              onSelect: (course) {
                ref.read(activeCourseProvider.notifier).state = course;
                final idx = enrolledCourses.indexOf(course);
                profile.activeCourseIndex = idx;
                ref.read(userRepositoryProvider).saveProfile(profile);
              },
              onAdd: () => _showCourseSheet(context, ref, profile),
            ),
            const SizedBox(height: 4),

            // ── Branch list + challenges ─────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Info banner
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .secondaryContainer,
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

                    for (final branch in courseBranches) ...[
                      if (branch != courseBranches.first)
                        const SizedBox(height: 10),
                      _BranchProgressCard(
                        branch: branch,
                        progress: progressMap[branch]!,
                        exerciseName: ExerciseL10n.name(
                          l10n,
                          ExerciseCatalog.forStage(
                                    branch,
                                    progressMap[branch]!.currentStage,
                                  )?.id ??
                              '',
                        ),
                        onTap: () =>
                            context.push('/branch/${branch.name}'),
                      ),
                      if (progressMap[branch]!.isChallengeUnlocked) ...[
                        const SizedBox(height: 10),
                        _ChallengeCard(
                          branch: branch,
                          progress: progressMap[branch]!,
                        ),
                      ],
                    ],
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCourseSheet(
      BuildContext context, WidgetRef ref, UserProfile profile) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _CourseEnrollSheet(profile: profile),
    );
  }
}

// ── Course enroll bottom sheet ────────────────────────────────────────────────

class _CourseEnrollSheet extends ConsumerStatefulWidget {
  const _CourseEnrollSheet({required this.profile});

  final UserProfile profile;

  @override
  ConsumerState<_CourseEnrollSheet> createState() => _CourseEnrollSheetState();
}

class _CourseEnrollSheetState extends ConsumerState<_CourseEnrollSheet> {
  late Set<CourseId> _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.profile.enrolledCourses.toSet();
  }

  void _toggle(CourseId course) {
    setState(() {
      if (_selected.contains(course)) {
        if (_selected.length > 1) _selected.remove(course);
      } else {
        _selected.add(course);
      }
    });
  }

  Future<void> _save() async {
    final profile = widget.profile;
    final newIds = _selected.map((c) => c.index).toList();
    profile.activeCourseIds = newIds;

    // If the currently active course was removed, reset to first.
    final activeCourse = ref.read(activeCourseProvider);
    if (!_selected.contains(activeCourse)) {
      profile.activeCourseIndex = 0;
      ref.read(activeCourseProvider.notifier).state = _selected.first;
    }

    await ref.read(userRepositoryProvider).saveProfile(profile);
    // Invalidate so LibraryScreen rebuilds with updated enrollment.
    ref.invalidate(enrolledCoursesProvider);
    ref.invalidate(homeDataProvider);

    if (mounted) Navigator.of(context).pop();
  }

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
          // Handle
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
            l10n.onboardingQ4Courses,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.onboardingQ4CoursesBody,
            style: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: 16),
          for (final course in CourseId.values) ...[
            _CourseOptionTile(
              course: course,
              selected: _selected.contains(course),
              onTap: () => _toggle(course),
            ),
            if (course != CourseId.values.last) const SizedBox(height: 8),
          ],
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _save,
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(
                l10n.onboardingContinue,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CourseOptionTile extends StatelessWidget {
  const _CourseOptionTile({
    required this.course,
    required this.selected,
    required this.onTap,
  });

  final CourseId course;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected
              ? scheme.primaryContainer
              : scheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? scheme.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.localizedName(l10n),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: selected
                          ? scheme.onPrimaryContainer
                          : scheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _branchSummary(context, course),
                    style: TextStyle(
                      fontSize: 12,
                      color: selected
                          ? scheme.onPrimaryContainer.withAlpha(180)
                          : scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (selected)
              Icon(Icons.check_circle, color: scheme.primary, size: 22),
          ],
        ),
      ),
    );
  }

  String _branchSummary(BuildContext context, CourseId course) {
    final l10n = context.l10n;
    return CourseCatalog.branchesFor(course)
        .map((b) => b.localizedName(l10n))
        .join(' · ');
  }
}

// ── Course pills row (always visible) ────────────────────────────────────────

class _CoursePillsRow extends StatelessWidget {
  const _CoursePillsRow({
    required this.courses,
    required this.active,
    required this.onSelect,
    required this.onAdd,
  });

  final List<CourseId> courses;
  final CourseId active;
  final void Function(CourseId) onSelect;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          ...courses.map((course) {
            final selected = course == active;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => onSelect(course),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: selected
                        ? scheme.primary
                        : scheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    course.localizedName(l10n),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: selected
                          ? scheme.onPrimary
                          : scheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            );
          }),
          // Add course button
          GestureDetector(
            onTap: onAdd,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(Icons.add, size: 18, color: scheme.onSurfaceVariant),
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
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
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
                                  progress.currentStage,
                                  branch.stageCount),
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

    final next =
        ExerciseCatalog.forStage(branch, progress.currentStage + 1);
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
