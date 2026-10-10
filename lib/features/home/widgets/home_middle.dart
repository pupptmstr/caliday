import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/extensions/achievement_l10n.dart';
import '../../../core/extensions/build_context_l10n.dart';
import '../../../core/extensions/exercise_l10n.dart';
import '../../../core/providers/goro_expression_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/branch_growth.dart';
import '../../../data/models/enums.dart';
import '../../../data/models/exercise.dart';
import '../../../data/repositories/achievement_repository.dart';
import '../../../data/repositories/custom_course_repository.dart';
import '../../../data/repositories/workout_repository.dart';
import '../../../data/static/achievement_catalog.dart';
import '../../../domain/models/branch.dart';
import '../../../domain/services/home_digest.dart';
import '../../../domain/services/progression_service.dart';
import '../../../l10n/app_localizations.dart';
import '../../library/widgets/exercise_thumb.dart';
import '../../profile/widgets/achievement_sheet.dart';
import '../../profile/widgets/workout_log_tile.dart';
import '../../workout/providers/workout_provider.dart';
import '../providers/home_provider.dart';

/// The middle of Home before the first workout of the day: the host's line,
/// the next goals and the course's branches (owner, 2026-10-10).
class HomeBeforeWorkout extends ConsumerWidget {
  const HomeBeforeWorkout({super.key, required this.data, required this.now});

  final HomeData data;
  final DateTime now;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expression = ref.watch(goroExpressionProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
HostLineCard(host: data.activeCourse.host, mood: expression),
        const SizedBox(height: 20),
        _NextGoals(data: data),
        const SizedBox(height: 20),
        _CourseBranches(data: data),
      ],
    );
  }
}

/// The middle of Home after the first workout of the day: the recent
/// workouts and how the branches grew today.
class HomeAfterWorkout extends ConsumerWidget {
  const HomeAfterWorkout({
    super.key,
    required this.now,
    required this.onSeeAllHistory,
  });

  final DateTime now;
  final VoidCallback onSeeAllHistory;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final repo = ref.watch(workoutRepositoryProvider);
    final recent = repo.getRecent(3);
    final growth = HomeDigest.growthOn(repo.getAllForDate(now), now);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionTitle(
          l10n.profileHistoryTitle,
          action: TextButton(
            onPressed: onSeeAllHistory,
            child: Text(l10n.homeHistoryAll),
          ),
        ),
        for (final log in recent)
          WorkoutLogTile(log: log, compact: true, now: now),
        const SizedBox(height: 12),
        _SectionTitle(l10n.homeGrowthTitle),
        _TodayGrowth(growth: growth),
      ],
    );
  }
}

// ── The host's line ───────────────────────────────────────────────────────────

/// What the active course's host (in the hero zone above) says, in its own
/// voice and for its mood: four lines each (`hostLines<Host><Mood>`, one per
/// line of the ARB text). Another one each time Home is built anew or the app
/// comes back, and on a tap; never the same twice in a row.
class HostLineCard extends StatefulWidget {
  const HostLineCard({super.key, required this.host, required this.mood});

  final CourseId host;
  final GoroExpression mood;

  static List<String> linesFor(
      AppLocalizations l, CourseId host, GoroExpression mood) {
    final (happy, sad, angry, supportive, sleeping) = switch (host) {
      CourseId.calisthenics => (
          l.hostLinesGoroHappy,
          l.hostLinesGoroSad,
          l.hostLinesGoroAngry,
          l.hostLinesGoroSupportive,
          l.hostLinesGoroSleeping,
        ),
      CourseId.healthyBody => (
          l.hostLinesRaffiHappy,
          l.hostLinesRaffiSad,
          l.hostLinesRaffiAngry,
          l.hostLinesRaffiSupportive,
          l.hostLinesRaffiSleeping,
        ),
      CourseId.eveningStretch => (
          l.hostLinesLunaHappy,
          l.hostLinesLunaSad,
          l.hostLinesLunaAngry,
          l.hostLinesLunaSupportive,
          l.hostLinesLunaSleeping,
        ),
      CourseId.morningRoutine => (
          l.hostLinesAuroraHappy,
          l.hostLinesAuroraSad,
          l.hostLinesAuroraAngry,
          l.hostLinesAuroraSupportive,
          l.hostLinesAuroraSleeping,
        ),
      CourseId.yoga => (
          l.hostLinesMisoHappy,
          l.hostLinesMisoSad,
          l.hostLinesMisoAngry,
          l.hostLinesMisoSupportive,
          l.hostLinesMisoSleeping,
        ),
    };
    final text = switch (mood) {
      GoroExpression.sad => sad,
      GoroExpression.angry => angry,
      GoroExpression.supportive => supportive,
      GoroExpression.sleeping => sleeping,
      GoroExpression.happy || GoroExpression.excited => happy,
    };
    return text.split('\n');
  }

  @override
  State<HostLineCard> createState() => _HostLineCardState();
}

class _HostLineCardState extends State<HostLineCard>
    with WidgetsBindingObserver {
  static final _random = Random();

  /// The line last shown per host and mood in this run, so that the next
  /// visit says another one.
  static final Map<String, int> _last = {};

  int? _index;

  String get _key => '${widget.host.name}/${widget.mood.name}';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didUpdateWidget(HostLineCard old) {
    super.didUpdateWidget(old);
    if (old.host != widget.host || old.mood != widget.mood) _index = null;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) setState(() => _index = null);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lines =
        HostLineCard.linesFor(context.l10n, widget.host, widget.mood);
    if (_index == null || _index! >= lines.length) {
      _index = HomeDigest.nextLine(lines.length, _last[_key], _random);
      _last[_key] = _index!;
    }
    // A speech bubble whose tail points up at the host in the hero zone
    // (a portrait of its own here would repeat the big one above).
    return GestureDetector(
      onTap: () => setState(() => _index = null),
      child: Column(
        children: [
          CustomPaint(
            size: const Size(22, 10),
            painter: _BubbleTail(scheme.surfaceContainerHighest),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(18),
              boxShadow:
                  isDark ? AppTheme.cardShadowDark : AppTheme.cardShadowLight,
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: Text(
                lines[_index!],
                key: ValueKey(lines[_index!]),
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w600, height: 1.3),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BubbleTail extends CustomPainter {
  _BubbleTail(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_BubbleTail old) => old.color != color;
}

// ── Next goals ────────────────────────────────────────────────────────────────

class _NextGoals extends ConsumerWidget {
  const _NextGoals({required this.data});

  final HomeData data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final rank = HomeDigest.nextRank(data.profile.totalSP);
    final goal = HomeDigest.nearestAchievement(
      earned: ref
          .watch(achievementRepositoryProvider)
          .getAllEarnedIds()
          .toSet(),
      streak: data.displayStreak,
      totalWorkouts: ref.watch(workoutRepositoryProvider).totalCount,
    );
    final achievement = goal == null ? null : AchievementCatalog.byId(goal.id);
    final challenges = [
      for (final MapEntry(key: branch, value: p) in data.progressMap.entries)
        if (p.isChallengeUnlocked) branch,
    ];
    if (rank == null && achievement == null && challenges.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // An unlocked challenge comes first: it is the next big step.
        for (final branch in challenges)
          if (branch.stage(data.progressMap[branch]!.currentStage + 1)
              case final next?) ...[
            _ChallengeCard(branch: branch, next: next),
            const SizedBox(height: 16),
          ],
        if (rank != null || achievement != null) ...[
          _SectionTitle(l10n.homeGoalsTitle),
          _Card(
            children: [
              if (rank != null)
                _GoalRow(
                  leading: Icon(
                    Icons.military_tech_rounded,
                    size: 30,
                    color: scheme.primary,
                  ),
                  title: l10n.homeGoalRank(
                    rank.rank.localizedName(l10n),
                    rank.missingSP,
                  ),
                  bottom: ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                      value: rank.progress,
                      minHeight: 6,
                      backgroundColor: scheme.outlineVariant,
                    ),
                  ),
                ),
              if (goal != null && achievement != null)
                _GoalRow(
                  leading: SizedBox(
                    width: 36,
                    child: AchievementEmoji(achievement.emoji, size: 26),
                  ),
                  title: AchievementL10n.name(l10n, achievement.id),
                  subtitle: switch (goal.unit) {
                    GoalUnit.days => l10n.homeGoalDays(goal.remaining),
                    GoalUnit.workouts => l10n.homeGoalWorkouts(goal.remaining),
                  },
                  onTap: () => context.push('/achievements'),
                ),
            ],
          ),
        ],
      ],
    );
  }
}

/// An unlocked challenge on Home: the next stage's exercise, its norm,
/// Skala (the judge of every challenge) and a button that starts it, like
/// the challenge card of the Courses tab.
class _ChallengeCard extends ConsumerWidget {
  const _ChallengeCard({required this.branch, required this.next});

  final Branch branch;
  final Exercise next;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final norm = next.type == ExerciseType.timed
        ? (next.holdsPerSet > 1
              ? l10n.homeChallengeNormSecPerSide
              : l10n.homeChallengeNormSec)(next.challengeTargetReps)
        : l10n.homeChallengeNormReps(next.challengeTargetReps);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              ExerciseThumb(next, size: 56),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.homeGoalChallenge(branch.name(l10n)),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: scheme.onTertiaryContainer,
                      ),
                    ),
                    Text(
                      ExerciseL10n.name(l10n, next.id),
                      style: TextStyle(
                        fontSize: 13,
                        color: scheme.onTertiaryContainer,
                      ),
                    ),
                    Text(
                      norm,
                      style: TextStyle(
                        fontSize: 12,
                        color: scheme.onTertiaryContainer.withAlpha(180),
                      ),
                    ),
                  ],
                ),
              ),
              SvgPicture.asset(
                'assets/skala/skala_neutral.svg',
                width: 40,
                height: 40,
              ),
            ],
          ),
          const SizedBox(height: 12),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: scheme.tertiary,
              foregroundColor: scheme.onTertiary,
              minimumSize: const Size.fromHeight(44),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              ref.read(challengeBranchProvider.notifier).set(branch);
              context.push('/workout');
            },
            child: Text(
              l10n.homeChallengeButton,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class _GoalRow extends StatelessWidget {
  const _GoalRow({
    required this.leading,
    required this.title,
    this.subtitle,
    this.bottom,
    this.onTap,
  });

  final Widget leading;
  final String title;
  final String? subtitle;
  final Widget? bottom;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            SizedBox(width: 36, child: Center(child: leading)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: TextStyle(
                        fontSize: 12,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  if (bottom != null) ...[const SizedBox(height: 6), bottom!],
                ],
              ),
            ),
            if (onTap != null)
              Icon(
                Icons.chevron_right,
                size: 18,
                color: scheme.onSurfaceVariant,
              ),
          ],
        ),
      ),
    );
  }
}

// ── The course's branches ─────────────────────────────────────────────────────

class _CourseBranches extends StatelessWidget {
  const _CourseBranches({required this.data});

  final HomeData data;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    if (data.progressMap.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionTitle(l10n.homeBranchesTitle),
        _Card(
          children: [
            for (final MapEntry(key: branch, value: p)
                in data.progressMap.entries)
              () {
                final exercise = branch.stage(p.currentStage);
                return InkWell(
                  onTap: () => context.push('/branch/${branch.key}'),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        if (exercise != null)
                          ExerciseThumb(exercise, size: 44, tappable: false)
                        else
                          SizedBox(
                            width: 44,
                            child: Icon(branch.icon, color: scheme.primary),
                          ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      branch.name(l10n),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    l10n.homeStage(
                                      p.currentStage,
                                      branch.stageCount,
                                    ),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: scheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                              if (exercise != null)
                                Text(
                                  ExerciseL10n.name(l10n, exercise.id),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: scheme.onSurfaceVariant,
                                  ),
                                ),
                              const SizedBox(height: 6),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(3),
                                child: LinearProgressIndicator(
                                  value: ProgressionService.stageFraction(
                                    exercise,
                                    p,
                                  ),
                                  minHeight: 5,
                                  backgroundColor: scheme.outlineVariant,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    p.isChallengeUnlocked
                                        ? scheme.tertiary
                                        : scheme.primary,
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
              }(),
          ],
        ),
      ],
    );
  }
}

// ── Today's growth ────────────────────────────────────────────────────────────

class _TodayGrowth extends ConsumerWidget {
  const _TodayGrowth({required this.growth});

  final List<BranchGrowth> growth;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final own = ref.watch(customBranchesProvider);
    final rows = [
      for (final g in growth)
        if (Branch.resolve(g.branchKey, own) case final branch?) (g, branch),
    ];
    if (rows.isEmpty) {
      return Text(
        l10n.homeGrowthNone,
        style: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant),
      );
    }
    return _Card(
      children: [
        for (final (g, branch) in rows)
          () {
            final exercise = branch.stage(g.toStage);
            final timed = branch.stage(g.fromStage)?.type == ExerciseType.timed;
            final change = switch (g.kind) {
              GrowthKind.stage => l10n.homeGrowthStage(
                exercise == null ? '' : ExerciseL10n.name(l10n, exercise.id),
              ),
              GrowthKind.sets => l10n.homeGrowthSets(g.fromSets, g.toSets),
              GrowthKind.amount =>
                timed
                    ? l10n.homeGrowthSeconds(g.fromAmount, g.toAmount)
                    : l10n.homeGrowthReps(g.fromAmount, g.toAmount),
              GrowthKind.rest => l10n.homeGrowthRest(
                g.fromRestSec,
                g.toRestSec,
              ),
              GrowthKind.challenge => l10n.homeGrowthChallenge,
            };
            return InkWell(
              onTap: () => context.push('/branch/${branch.key}'),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    if (exercise != null)
                      ExerciseThumb(exercise, size: 44, tappable: false),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            branch.name(l10n),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            change,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.success,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      g.kind == GrowthKind.stage
                          ? Icons.keyboard_double_arrow_up_rounded
                          : Icons.trending_up_rounded,
                      color: AppTheme.success,
                    ),
                  ],
                ),
              ),
            );
          }(),
      ],
    );
  }
}

// ── Shared bits ───────────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text, {this.action});

  final String text;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: action == null ? 8 : 0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          ?action,
        ],
      ),
    );
  }
}

/// Rows on one card with a shadow (BRAND: no flat cards).
class _Card extends StatelessWidget {
  const _Card({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isDark ? AppTheme.cardShadowDark : AppTheme.cardShadowLight,
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: Column(
          children: [
            for (var i = 0; i < children.length; i++) ...[
              if (i > 0)
                Divider(
                  height: 1,
                  indent: 14,
                  endIndent: 14,
                  color: scheme.outlineVariant.withAlpha(120),
                ),
              children[i],
            ],
          ],
        ),
      ),
    );
  }
}
