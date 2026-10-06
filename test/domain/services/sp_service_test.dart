import 'package:caliday/data/models/enums.dart';
import 'package:caliday/data/models/exercise.dart';
import 'package:caliday/data/models/exercise_result.dart';
import 'package:caliday/data/models/user_profile.dart';
import 'package:caliday/domain/services/sp_service.dart';
import 'package:flutter_test/flutter_test.dart';

Exercise _exercise({
  ExerciseType type = ExerciseType.reps,
  int stage = 1,
  int spBase = 2,
}) =>
    Exercise(
      id: 'test',
      name: 'Test',
      description: 'Test',
      branch: BranchId.push,
      stage: stage,
      type: type,
      startReps: 5,
      targetReps: 10,
      startSets: 1,
      targetSets: 3,
      startRestSec: 60,
      targetRestSec: 30,
      spBase: spBase,
    );

/// A reps result: [done] of [target].
ExerciseResult _reps(int done, {int target = 10}) =>
    ExerciseResult(exerciseId: 'test', targetReps: target, completedReps: done);

/// A timed result as the workout provider builds it: the target seconds are
/// stored in both targetReps and targetDurationSec.
ExerciseResult _timed(int actual, {int target = 30}) => ExerciseResult(
      exerciseId: 'test',
      targetReps: target,
      completedReps: 0,
      targetDurationSec: target,
      actualDurationSec: actual,
    );

void main() {
  const service = SPService();

  group('forExercise', () {
    test('reps exercises give spBase per completed rep', () {
      expect(service.forExercise(_reps(10), _exercise(spBase: 2)), 20);
      expect(service.forExercise(_reps(0), _exercise(spBase: 2)), 0);
      expect(service.forExercise(_reps(7), _exercise(spBase: 3)), 21);
    });

    test('timed exercises give spBase per 10 s, rounded down', () {
      final plank = _exercise(type: ExerciseType.timed, spBase: 2);
      expect(service.forExercise(_timed(45), plank), 9); // 4.5 * 2
      expect(service.forExercise(_timed(9), plank), 1); // 0.9 * 2 = 1.8
      expect(service.forExercise(_timed(0), plank), 0);
    });

    test('a timed result without a duration gives nothing', () {
      final plank = _exercise(type: ExerciseType.timed);
      final noDuration = ExerciseResult(
          exerciseId: 'test', targetReps: 30, completedReps: 0);
      expect(service.forExercise(noDuration, plank), 0);
    });

    test('warm-ups and cool-downs (stage 0) never award SP', () {
      expect(service.forExercise(_reps(10), _exercise(stage: 0)), 0);
      expect(
          service.forExercise(
              _timed(60), _exercise(stage: 0, type: ExerciseType.timed)),
          0);
    });
  });

  group('forWorkout', () {
    int total(
      List<ExerciseResult> results,
      List<Exercise> exercises, {
      bool first = false,
    }) =>
        service.forWorkout(
            results: results, exercises: exercises, isFirstToday: first);

    test('a full set gets the +10 % completion bonus', () {
      expect(total([_reps(10)], [_exercise()]), 22); // 20 * 1.1
    });

    test('an incomplete set gets no completion bonus', () {
      expect(total([_reps(5)], [_exercise()]), 10);
    });

    test('the first workout of the day gets +50 %', () {
      expect(total([_reps(5)], [_exercise()], first: true), 15); // 10 * 1.5
    });

    test('both bonuses stack: first +50 %, then completion +10 %', () {
      expect(total([_reps(10)], [_exercise()], first: true), 33); // 20 -> 30 -> 33
    });

    test('each bonus is rounded', () {
      // 25 * 1.5 = 37.5 -> 38; 38 * 1.1 = 41.8 -> 42
      expect(total([_reps(5, target: 5)], [_exercise(spBase: 5)], first: true),
          42);
    });

    test('a timed exercise counts as complete only when the target is held',
        () {
      final plank = _exercise(type: ExerciseType.timed, spBase: 1);
      expect(total([_timed(30)], [plank]), 3); // 3 * 1.1 = 3.3 -> 3
      expect(total([_timed(60)], [plank]), 7); // 6 * 1.1 = 6.6 -> 7
      expect(total([_timed(29)], [plank]), 2); // 2.9 floored; not complete
    });

    test('a workout without any SP-earning work gives 0 even with bonuses',
        () {
      final warmup = _exercise(stage: 0);
      expect(total([_reps(10)], [warmup], first: true), 0);
      expect(total([], [], first: true), 0);
    });

    test('sums several exercises and ignores surplus results', () {
      final results = [_reps(10), _reps(10), _reps(10)];
      final exercises = [_exercise(), _exercise()];
      // Only the first two pair up: 20 + 20 = 40, all three complete -> 44.
      expect(total(results, exercises), 44);
    });
  });

  group('applyToProfile', () {
    test('adds SP and recalculates the rank at each threshold', () {
      final profile = UserProfile();
      service.applyToProfile(profile, 499);
      expect(profile.totalSP, 499);
      expect(profile.rank, Rank.beginner);

      service.applyToProfile(profile, 1);
      expect(profile.rank, Rank.amateur);

      service.applyToProfile(profile, 1500);
      expect(profile.totalSP, 2000);
      expect(profile.rank, Rank.sportsman);
    });

    test('recomputes the rank from SP, discarding a manually set rank', () {
      // Decay is display-only; the stored rank must always be the SP-earned one.
      final profile = UserProfile(rank: Rank.legend, totalSP: 10);
      service.applyToProfile(profile, 5);
      expect(profile.rank, Rank.beginner);
    });
  });
}
