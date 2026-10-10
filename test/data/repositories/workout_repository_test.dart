import 'package:caliday/data/models/branch_growth.dart';
import 'package:caliday/data/models/enums.dart';
import 'package:caliday/data/models/exercise_result.dart';
import 'package:caliday/data/models/workout_log.dart';
import 'package:caliday/data/repositories/workout_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/hive_test_env.dart';

WorkoutLog _log(
  DateTime date, {
  bool primary = true,
  int sp = 10,
  List<ExerciseResult> exercises = const [],
  bool freezeUsed = false,
  bool freezeEarned = false,
  int? courseIdIndex,
}) =>
    WorkoutLog(
      date: date,
      setType: SetType.daily,
      exercises: exercises,
      spEarned: sp,
      durationSec: 300,
      isPrimary: primary,
      courseIdIndex: courseIdIndex,
      freezeUsed: freezeUsed,
      freezeEarned: freezeEarned,
    );

void main() {
  late HiveTestEnv env;
  late WorkoutRepository repo;

  setUp(() async {
    env = await HiveTestEnv.open();
    repo = WorkoutRepository();
  });
  tearDown(() => env.dispose());

  test('starts empty', () {
    expect(repo.totalCount, 0);
    expect(repo.getAll(), isEmpty);
    expect(repo.hasWorkoutToday(), isFalse);
    expect(repo.hasPrimaryWorkoutToday(), isFalse);
  });

  test('the growth of a workout goes through its adapter; an old log has none',
      () async {
    await repo.addLog(_log(DateTime(2026, 6, 1)));
    await repo.addLog(WorkoutLog(
      date: DateTime(2026, 6, 2),
      setType: SetType.daily,
      exercises: const [],
      spEarned: 10,
      durationSec: 300,
      growth: [
        BranchGrowth(branchKey: 'push', fromStage: 2, toStage: 2, fromAmount: 10,
            toAmount: 12, fromSets: 2, toSets: 2, fromRestSec: 60, toRestSec: 60),
        BranchGrowth(branchKey: 'custom_b1', fromStage: 1, toStage: 1, fromAmount: 20,
            toAmount: 20, fromSets: 3, toSets: 3, fromRestSec: 20, toRestSec: 20,
            challengeUnlocked: true),
      ],
    ));
    await env.reopen();

    final logs = WorkoutRepository().getAll();
    expect(logs.last.growth, isNull);
    final growth = logs.first.growth!;
    expect(growth.map((g) => g.branchKey), ['push', 'custom_b1']);
    expect(growth.map((g) => g.kind), [GrowthKind.amount, GrowthKind.challenge]);
    expect([growth.first.fromAmount, growth.first.toAmount], [10, 12]);
  });

  test('getAll and getRecent are newest-first', () async {
    await repo.addLog(_log(DateTime(2026, 6, 1)));
    await repo.addLog(_log(DateTime(2026, 6, 3)));
    await repo.addLog(_log(DateTime(2026, 6, 2)));

    expect(repo.totalCount, 3);
    expect(repo.getAll().map((l) => l.date.day), [3, 2, 1]);
    expect(repo.getRecent(2).map((l) => l.date.day), [3, 2]);
    expect(repo.getRecent(10), hasLength(3));
  });

  group('by date (the time of day is ignored)', () {
    setUp(() async {
      await repo.addLog(_log(DateTime(2026, 6, 10, 7, 30)));
      await repo.addLog(_log(DateTime(2026, 6, 10, 20, 15), primary: false));
      await repo.addLog(_log(DateTime(2026, 6, 11, 0, 5)));
    });

    test('getAllForDate returns that day only, newest first', () {
      final logs = repo.getAllForDate(DateTime(2026, 6, 10, 12));
      expect(logs, hasLength(2));
      expect(logs.first.date.hour, 20);
      expect(repo.getAllForDate(DateTime(2026, 6, 12)), isEmpty);
    });

    test('getForDate and getCountForDate agree', () {
      expect(repo.getForDate(DateTime(2026, 6, 11, 23)), isNotNull);
      expect(repo.getForDate(DateTime(2026, 6, 9)), isNull);
      expect(repo.getCountForDate(DateTime(2026, 6, 10)), 2);
      expect(repo.getCountForDate(DateTime(2026, 6, 11)), 1);
      expect(repo.getCountForDate(DateTime(2026, 6, 12)), 0);
    });

    test('getInRange includes both end days, whatever their time', () {
      final logs = repo.getInRange(
          DateTime(2026, 6, 10, 23, 59), DateTime(2026, 6, 11, 0, 1));
      expect(logs, hasLength(3));
      expect(repo.getInRange(DateTime(2026, 6, 11), DateTime(2026, 6, 20)),
          hasLength(1));
      expect(repo.getInRange(DateTime(2026, 5, 1), DateTime(2026, 6, 9)),
          isEmpty);
    });
  });

  group('today', () {
    test('a primary workout today counts as both', () async {
      await repo.addLog(_log(DateTime.now()));
      expect(repo.hasWorkoutToday(), isTrue);
      expect(repo.hasPrimaryWorkoutToday(), isTrue);
    });

    test('a bonus workout alone is a workout but not a primary one', () async {
      await repo.addLog(_log(DateTime.now(), primary: false));
      expect(repo.hasWorkoutToday(), isTrue);
      expect(repo.hasPrimaryWorkoutToday(), isFalse);
    });

    test('yesterday\'s primary workout does not count for today', () async {
      final now = DateTime.now();
      await repo.addLog(_log(DateTime(now.year, now.month, now.day - 1, 12)));
      expect(repo.hasWorkoutToday(), isFalse);
      expect(repo.hasPrimaryWorkoutToday(), isFalse);
    });
  });

  group('deleting', () {
    test('deleteForDate removes one workout of that day', () async {
      await repo.addLog(_log(DateTime(2026, 6, 10)));
      await repo.addLog(_log(DateTime(2026, 6, 11)));
      await repo.deleteForDate(DateTime(2026, 6, 10, 18));
      expect(repo.totalCount, 1);
      expect(repo.getForDate(DateTime(2026, 6, 10)), isNull);
      expect(repo.getForDate(DateTime(2026, 6, 11)), isNotNull);
    });

    test('deleteForDate on an empty day is a no-op', () async {
      await repo.addLog(_log(DateTime(2026, 6, 10)));
      await repo.deleteForDate(DateTime(2026, 6, 20));
      expect(repo.totalCount, 1);
    });

    test('deleteAll empties the history', () async {
      await repo.addLog(_log(DateTime(2026, 6, 10)));
      await repo.addLog(_log(DateTime(2026, 6, 11)));
      await repo.deleteAll();
      expect(repo.totalCount, 0);
    });
  });

  test('every field survives a write / close / reopen cycle', () async {
    final date = DateTime(2026, 3, 30, 18, 45);
    await repo.addLog(_log(
      date,
      primary: false,
      sp: 77,
      freezeUsed: true,
      freezeEarned: true,
      courseIdIndex: 1,
      exercises: [
        ExerciseResult(exerciseId: 'push_s1_wall_pushup', targetReps: 8, completedReps: 7),
        ExerciseResult(
          exerciseId: 'core_s2_plank',
          targetReps: 30,
          completedReps: 0,
          targetDurationSec: 30,
          actualDurationSec: 32,
        ),
      ],
    ));

    await env.reopen();
    final log = WorkoutRepository().getAll().single;

    expect(log.date, date);
    expect(log.setType, SetType.daily);
    expect(log.spEarned, 77);
    expect(log.durationSec, 300);
    expect(log.isPrimary, isFalse);
    expect(log.courseIdIndex, 1);
    expect(log.freezeUsed, isTrue);
    expect(log.freezeEarned, isTrue);
    expect(log.exercises, hasLength(2));
    expect(log.exercises[0].exerciseId, 'push_s1_wall_pushup');
    expect(log.exercises[0].completedReps, 7);
    expect(log.exercises[0].targetDurationSec, isNull);
    expect(log.exercises[1].actualDurationSec, 32);
    expect(log.exercises[1].targetDurationSec, 30);
  });

  test('the raw estimate of the plan is kept, and its absence reads as null', () async {
    await repo.addLog(WorkoutLog(
      date: DateTime(2026, 6, 10),
      setType: SetType.daily,
      exercises: const [],
      spEarned: 0,
      durationSec: 540,
      estimatedDurationSec: 480,
    ));
    await repo.addLog(_log(DateTime(2026, 6, 11))); // as logs of older builds
    await env.reopen();

    final logs = WorkoutRepository().getAll();
    expect(logs.map((l) => l.estimatedDurationSec), [null, 480]);
    expect(logs.last.durationSec, 540);
  });

  test('defaults: primary, no course, no freeze markers', () async {
    await repo.addLog(WorkoutLog(
      date: DateTime(2026, 6, 10),
      setType: SetType.daily,
      exercises: const [],
      spEarned: 0,
      durationSec: 0,
    ));
    await env.reopen();
    final log = WorkoutRepository().getAll().single;
    expect(log.isPrimary, isTrue);
    expect(log.courseIdIndex, isNull);
    expect(log.freezeUsed, isFalse);
    expect(log.freezeEarned, isFalse);
  });
}
