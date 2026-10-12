import 'package:caliday/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

import '../../data/models/custom_branch.dart';
import '../../data/models/enums.dart';
import '../../data/models/user_profile.dart';
import '../../data/models/workout_log.dart';
import '../../domain/models/branch.dart';
import '../../domain/models/workout_plan.dart';
import '../../domain/services/home_digest.dart';
import '../extensions/exercise_l10n.dart';
import '../extensions/growth_l10n.dart';
import '../l10n/app_languages.dart';
import '../utils/calendar_days.dart';

/// Everything the native home-screen widgets show, as the key → value pairs
/// they read (`ios/CaliDayWidget/WidgetState.swift`,
/// `android/.../WidgetState.kt`).
///
/// A widget renders without the app, often hours or days after the snapshot,
/// so the values carry the day they belong to and the widget decides by the
/// moment it renders, with the app's own rules (mirrored in both native
/// files):
/// - done today: `trainedDays` holds the render day;
/// - the streak shown: `streak` while `lastWorkoutDay` is today or yesterday,
///   or two days ago with a freeze left, else 0 (`HomeData.displayStreak`);
/// - Goro's face by the hour (`goroExpressionProvider`);
/// - the plan, the SP and the growth of `day` only while it is the render day;
/// - Goro's pose of the day: the day's number since 1970 modulo the poses.
///
/// Every text comes from the ARB files of the app's language (native
/// resources would follow the system language); only the widget gallery
/// names, shown before the app has ever run, are native.
abstract final class WidgetSnapshot {
  /// The last days whose workouts the week strip can need (a week back from
  /// any render day within a week of the snapshot).
  static const trainedDaysKept = 14;

  /// Plan and growth lines handed over; the large widget shows what fits.
  static const lineLimit = 8;

  static Map<String, Object> build({
    required UserProfile profile,
    required Iterable<WorkoutLog> logs,
    required WorkoutPlan? plan,
    required double pace,
    required String courseName,
    required Iterable<CustomBranch> ownBranches,
    required DateTime now,
    required String locale,
  }) {
    final l10n = l10nFor(locale);
    final today = DateTime(now.year, now.month, now.day);
    final recent = logs
        .where((l) {
          final d = calendarDaysBetween(l.date, today);
          return d >= 0 && d < trainedDaysKept;
        })
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
    final ofToday =
        recent.where((l) => calendarDaysBetween(l.date, today) == 0).toList();
    final trained = {for (final l in recent) dayKey(l.date)}.toList()..sort();

    final goal = HomeDigest.nextRank(profile.totalSP);
    final exercises = plan?.exercises ?? const <PlannedExercise>[];

    final growth = [
      for (final g in HomeDigest.growthOn(ofToday, today))
        if (Branch.resolve(g.branchKey, ownBranches) case final branch?)
          '${branch.name(l10n)}\t${GrowthL10n.change(l10n, g, branch)}',
    ];

    return {
      'day': dayKey(today),
      // Streak.
      'streak': profile.currentStreak,
      'freezes': profile.streakFreezeCount,
      'lastWorkoutDay':
          profile.lastWorkoutDate == null ? '' : dayKey(profile.lastWorkoutDate!),
      'trainedDays': trained.join(','),
      'streakText': l10n.homeStreakDays(profile.currentStreak),
      'streakZeroText': l10n.homeStreakDays(0),
      'weekdays': weekdayLetters(locale).join(','),
      // SP and rank.
      'totalSP': profile.totalSP,
      'spToday': ofToday.fold<int>(0, (sum, l) => sum + l.spEarned),
      'rankName': profile.rank.localizedName(l10n),
      'rankProgress': goal == null ? 1000 : (goal.progress * 1000).round(),
      'rankGoal': goal == null
          ? l10n.widgetRankTop
          : l10n.homeGoalRank(goal.rank.localizedName(l10n), goal.missingSP),
      // The day's plan.
      'courseName': courseName,
      'planCount': exercises.length,
      'planSummary': exercises.isEmpty
          ? ''
          : l10n.widgetPlanSummary(
              exercises.length, plan!.estimatedMinutesAt(pace)),
      'planLines': [
        for (final p in exercises.take(lineLimit))
          '${ExerciseL10n.name(l10n, p.exercise.id)}\t${_amount(l10n, p)}',
      ].join('\n'),
      'growthLines': growth.take(lineLimit).join('\n'),
      // Labels.
      'todayTitle': l10n.widgetTodayTitle,
      'streakTitle': l10n.widgetStreakTitle,
      'rankTitle': l10n.widgetRankTitle,
      'growthTitle': l10n.homeGrowthTitle,
      'trainLabel': l10n.widgetTimeToTrain,
      'doneLabel': l10n.widgetDoneLabel,
      'doneTitle': l10n.homeWorkoutDone,
      'spTodayText': l10n.widgetSpToday(
          ofToday.fold<int>(0, (sum, l) => sum + l.spEarned)),
    };
  }

  /// "2026-10-12": how a day travels to the widgets (they compare it with
  /// their own calendar date, never with a time).
  static String dayKey(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';

  /// One letter per weekday, Monday first like the app's calendar.
  static List<String> weekdayLetters(String locale) {
    final monday = DateTime(2024, 1, 1); // a Monday
    final format = DateFormat('EEEEE', supportedLanguageCode(locale));
    return [
      for (var i = 0; i < 7; i++)
        format.format(addCalendarDays(monday, i)).toUpperCase(),
    ];
  }

  /// "3 × 12", "2 × 30 s each side": as the plan on the Home button.
  static String _amount(AppLocalizations l10n, PlannedExercise p) {
    final e = p.exercise;
    if (e.type != ExerciseType.timed) {
      return l10n.homePlanReps(p.sets, p.targetAmount);
    }
    return e.holdsPerSet == 2
        ? l10n.homePlanSecondsPerSide(p.sets, p.targetAmount)
        : l10n.homePlanSeconds(p.sets, p.targetAmount);
  }
}
