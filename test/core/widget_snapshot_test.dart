import 'package:caliday/core/services/widget_snapshot.dart';
import 'package:caliday/data/models/branch_growth.dart';
import 'package:caliday/data/models/enums.dart';
import 'package:caliday/data/models/user_profile.dart';
import 'package:caliday/data/models/workout_log.dart';
import 'package:caliday/data/static/exercise_catalog.dart';
import 'package:caliday/domain/models/workout_plan.dart';
import 'package:caliday/l10n/app_localizations_en.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../helpers/all_translations.dart';

final _now = DateTime(2026, 10, 15, 18, 30); // a Thursday

WorkoutLog _log(DateTime date, {int sp = 40, List<BranchGrowth>? growth}) =>
    WorkoutLog(
      date: date,
      setType: SetType.daily,
      exercises: const [],
      spEarned: sp,
      durationSec: 600,
      growth: growth,
    );

PlannedExercise _planned(String id, int amount, int sets) => PlannedExercise(
      exercise: ExerciseCatalog.byId(id)!,
      targetAmount: amount,
      sets: sets,
      restSec: 60,
    );

final _plan = WorkoutPlan(setType: SetType.daily, exercises: [
  _planned('push_s2_knee_pushup', 10, 3),
  _planned('core_s2_plank', 30, 3),
  _planned('flex_s1_hip_flexor_stretch', 20, 2),
]);

Map<String, Object> _build({
  UserProfile? profile,
  List<WorkoutLog> logs = const [],
  WorkoutPlan? plan,
  String locale = 'en',
  DateTime? now,
}) =>
    WidgetSnapshot.build(
      profile: profile ?? UserProfile(),
      logs: logs,
      plan: plan,
      pace: 1.0,
      courseName: 'Calisthenics',
      ownBranches: const [],
      now: now ?? _now,
      locale: locale,
    );

void main() {
  setUpAll(() async {
    for (final l10n in allTranslations) {
      await initializeDateFormatting(l10n.localeName);
    }
  });

  group('the days the widgets decide by', () {
    test('the snapshot carries its own day, the last workout and the trained days', () {
      final s = _build(
        profile: UserProfile()
          ..currentStreak = 4
          ..streakFreezeCount = 2
          ..lastWorkoutDate = DateTime(2026, 10, 14),
        logs: [
          _log(DateTime(2026, 10, 14, 7)),
          _log(DateTime(2026, 10, 14, 19)), // a bonus workout: one day
          _log(DateTime(2026, 10, 12, 8)),
          _log(DateTime(2026, 9, 30, 8)), // more than two weeks back
        ],
      );
      expect(s['day'], '2026-10-15');
      expect(s['streak'], 4);
      expect(s['freezes'], 2);
      expect(s['lastWorkoutDay'], '2026-10-14');
      expect(s['trainedDays'], '2026-10-12,2026-10-14');
    });

    test('no workout yet: an empty last day and no trained days', () {
      final s = _build();
      expect(s['lastWorkoutDay'], '');
      expect(s['trainedDays'], '');
      expect(s['spToday'], 0);
    });

    test('a workout in the future of the snapshot is not a trained day', () {
      final s = _build(logs: [_log(DateTime(2026, 10, 16, 7))]);
      expect(s['trainedDays'], '');
    });

    test('days across the autumn DST change stay calendar days', () {
      // Berlin leaves summer time on 2026-10-25: that Sunday has 25 hours.
      final s = _build(
        now: DateTime(2026, 10, 26, 0, 30),
        logs: [_log(DateTime(2026, 10, 25, 23, 50)), _log(DateTime(2026, 10, 13, 0, 10))],
      );
      expect(s['day'], '2026-10-26');
      expect(s['trainedDays'], '2026-10-13,2026-10-25');
    });

    test('the SP of the day add up its workouts only', () {
      final s = _build(logs: [
        _log(DateTime(2026, 10, 15, 7), sp: 45),
        _log(DateTime(2026, 10, 15, 20), sp: 12),
        _log(DateTime(2026, 10, 14, 7), sp: 100),
      ]);
      expect(s['spToday'], 57);
      expect(s['spTodayText'], '+57 SP today');
    });
  });

  group('the rank', () {
    test('progress in thousandths and the SP to the next rank', () {
      final s = _build(profile: UserProfile()
        ..totalSP = 1240
        ..rank = Rank.amateur);
      // Amateur 500 → Athlete (sportsman) 2000: 740 of 1500.
      expect(s['rankProgress'], 493);
      expect(s['rankName'], 'Amateur');
      expect(s['rankGoal'], AppLocalizationsEn().homeGoalRank('Athlete', 760));
    });

    test('at the top rank the bar is full and the goal says so', () {
      final s = _build(profile: UserProfile()
        ..totalSP = 60000
        ..rank = Rank.legend);
      expect(s['rankProgress'], 1000);
      expect(s['rankGoal'], 'Top rank');
    });
  });

  group('the day\'s plan', () {
    test('a summary with the count and the estimate, a line per exercise', () {
      final s = _build(plan: _plan);
      expect(s['planCount'], 3);
      expect(s['planSummary'], startsWith('3 exercises · ≈ '));
      expect((s['planLines'] as String).split('\n'), [
        'Knee Push-up\t3 × 10',
        'Plank\t3 × 30 s',
        'Hip Flexor Stretch\t2 × 20 s each side',
      ]);
    });

    test('a long plan hands over the first lines and the full count', () {
      final s = _build(plan: WorkoutPlan(setType: SetType.daily, exercises: [
        for (var i = 0; i < 11; i++) _planned('legs_s1_squat', 10 + i, 3),
      ]));
      expect(s['planCount'], 11);
      expect((s['planLines'] as String).split('\n'), hasLength(WidgetSnapshot.lineLimit));
    });

    test('no plan: nothing to show', () {
      final s = _build();
      expect(s['planCount'], 0);
      expect(s['planSummary'], '');
      expect(s['planLines'], '');
    });
  });

  test('today\'s growth names the branch and what moved, in the order done', () {
    BranchGrowth grew(String key, int from, int to) => BranchGrowth(
          branchKey: key,
          fromStage: 2,
          toStage: 2,
          fromAmount: from,
          toAmount: to,
          fromSets: 3,
          toSets: 3,
          fromRestSec: 60,
          toRestSec: 60,
        );
    final s = _build(logs: [
      _log(DateTime(2026, 10, 15, 19), growth: [grew('core', 30, 35)]),
      _log(DateTime(2026, 10, 15, 7), growth: [grew('push', 10, 12)]),
      _log(DateTime(2026, 10, 14, 7), growth: [grew('legs', 8, 10)]),
      _log(DateTime(2026, 10, 15, 8), growth: [grew('custom_gone', 1, 2)]),
    ]);
    final lines = (s['growthLines'] as String).split('\n');
    expect(lines, hasLength(2), reason: 'yesterday and a deleted own branch are left out');
    expect(lines.first, startsWith('Push\t'));
    expect(lines.last, startsWith('Core\t'));
  });

  group('every language', () {
    test('the texts are the app\'s, the weekdays one letter each, Monday first', () {
      for (final l10n in allTranslations) {
        final s = _build(
          locale: l10n.localeName,
          plan: _plan,
          profile: UserProfile()..currentStreak = 5,
        );
        final why = l10n.localeName;
        expect(s['doneLabel'], l10n.widgetDoneLabel, reason: why);
        expect(s['doneTitle'], l10n.homeWorkoutDone, reason: why);
        expect(s['trainLabel'], l10n.widgetTimeToTrain, reason: why);
        expect(s['todayTitle'], l10n.widgetTodayTitle, reason: why);
        expect(s['streakTitle'], l10n.widgetStreakTitle, reason: why);
        expect(s['rankTitle'], l10n.widgetRankTitle, reason: why);
        expect(s['growthTitle'], l10n.homeGrowthTitle, reason: why);
        expect(s['streakText'], l10n.homeStreakDays(5), reason: why);
        expect(s['streakZeroText'], l10n.homeStreakDays(0), reason: why);
        expect(s['rankName'], Rank.beginner.localizedName(l10n), reason: why);
        expect(s['planSummary'], contains('3'), reason: why);
        final days = (s['weekdays'] as String).split(',');
        expect(days, hasLength(7), reason: why);
        expect(days.every((d) => d.isNotEmpty && d.length <= 2), isTrue, reason: '$why: $days');
      }
    });

    test('Russian weekdays start on Monday', () {
      expect(_build(locale: 'ru')['weekdays'], 'П,В,С,Ч,П,С,В');
    });

    test('a language the app does not have gets English', () {
      final s = _build(locale: 'fr', plan: _plan);
      expect(s['doneLabel'], 'Done');
      expect(s['trainLabel'], 'Time to train');
      expect(s['weekdays'], 'M,T,W,T,F,S,S');
    });
  });
}
