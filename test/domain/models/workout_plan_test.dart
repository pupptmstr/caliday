import 'package:caliday/data/models/enums.dart';
import 'package:caliday/data/models/exercise.dart';
import 'package:caliday/data/static/exercise_catalog.dart';
import 'package:caliday/domain/models/workout_plan.dart';
import 'package:flutter_test/flutter_test.dart';

final Exercise _timed =
    ExerciseCatalog.libraryAll.firstWhere((e) => e.type == ExerciseType.timed);
final Exercise _reps =
    ExerciseCatalog.libraryAll.firstWhere((e) => e.type == ExerciseType.reps);

PlannedExercise _slot(Exercise e, {required int amount, int sets = 1, int rest = 0}) =>
    PlannedExercise(exercise: e, targetAmount: amount, sets: sets, restSec: rest);

WorkoutPlan _plan(List<PlannedExercise> slots) =>
    WorkoutPlan(setType: SetType.daily, exercises: slots);

void main() {
  group('estimatedDurationSec', () {
    test('an empty plan takes nothing', () {
      expect(_plan([]).estimatedDurationSec, 0);
      expect(_plan([]).estimatedMinutes, 0);
    });

    test('reps: kSecondsPerRep per rep, a rest between the sets but not after the last', () {
      final plan = _plan([_slot(_reps, amount: 8, sets: 2, rest: 45)]);
      expect(plan.estimatedDurationSec, 2 * 8 * kSecondsPerRep + 45);
    });

    test('timed: the hold plus the get-ready countdown before each set', () {
      final plan = _plan([_slot(_timed, amount: 30, sets: 2, rest: 30)]);
      expect(plan.estimatedDurationSec,
          (kPrepNewExerciseSec + 30) + 30 + (kPrepNextSetSec + 30));
    });

    test('the rest after the last set of an exercise counts when another follows', () {
      final plan = _plan([
        _slot(_reps, amount: 10, rest: 60),
        _slot(_timed, amount: 20, rest: 60),
      ]);
      // reps 30 s, the rest 60 s, the countdown 10 s and the hold 20 s; the
      // 60 s after the final hold are not spent.
      expect(plan.estimatedDurationSec, 30 + 60 + kPrepNewExerciseSec + 20);
    });

    test('a warm-up without rest adds no rest', () {
      final plan = _plan([
        _slot(_timed, amount: 30, rest: 0),
        _slot(_reps, amount: 5, rest: 0),
      ]);
      expect(plan.estimatedDurationSec,
          kPrepNewExerciseSec + 30 + 5 * kSecondsPerRep);
    });
  });

  group('estimatedMinutes', () {
    test('rounds to the nearest minute, never below 1 for a real plan', () {
      expect(_plan([_slot(_timed, amount: 5)]).estimatedMinutes, 1,
          reason: '15 s still shows 1 min, not 0');
      // 8 reps x 3 s = 24 s per set, 6 sets, rests of 5 s between: 174 s -> 3 min
      expect(_plan([_slot(_reps, amount: 8, sets: 6, rest: 6)]).estimatedMinutes, 3);
      // 90 s is 1.5 min: rounds up
      expect(_plan([_slot(_reps, amount: 30)]).estimatedMinutes, 2);
    });
  });
}
