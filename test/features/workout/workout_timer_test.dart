import 'package:caliday/data/models/enums.dart';
import 'package:caliday/data/models/exercise.dart';
import 'package:caliday/data/static/exercise_catalog.dart';
import 'package:caliday/domain/models/workout_plan.dart';
import 'package:caliday/features/workout/providers/workout_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// The hold of a timed exercise (plank, dead hang...) must not start counting
/// until the user taps Start: after a rest there is time to read what to do.

final Exercise _timed =
    ExerciseCatalog.libraryAll.firstWhere((e) => e.type == ExerciseType.timed);
final Exercise _reps =
    ExerciseCatalog.libraryAll.firstWhere((e) => e.type == ExerciseType.reps);

PlannedExercise _slot(Exercise e, {int amount = 5, int sets = 2, int rest = 3}) =>
    PlannedExercise(exercise: e, targetAmount: amount, sets: sets, restSec: rest);

/// A container whose workout runs [slots]; nothing touches Hive until the last
/// set of the last exercise, which these tests never reach.
({ProviderContainer container, WorkoutNotifier notifier}) _start(
    List<PlannedExercise> slots) {
  final container = ProviderContainer();
  addTearDown(container.dispose);
  container
      .read(customWorkoutPlanProvider.notifier)
      .set(WorkoutPlan(setType: SetType.daily, exercises: slots));
  // The provider is auto-disposed: keep it alive for the test.
  container.listen(workoutProvider, (_, _) {});
  return (container: container, notifier: container.read(workoutProvider.notifier));
}

void tick(WorkoutNotifier n, [int times = 1]) {
  for (var i = 0; i < times; i++) {
    n.tick();
  }
}

void main() {
  WorkoutState read(ProviderContainer c) => c.read(workoutProvider);

  group('a timed exercise waits for Start', () {
    test('it begins with a full timer that does not run', () {
      final (:container, :notifier) = _start([_slot(_timed)]);
      expect(read(container).timerStarted, isFalse);
      expect(read(container).timerSec, 5);

      tick(notifier, 30);
      expect(read(container).timerSec, 5, reason: 'no countdown before Start');
      expect(read(container).phase, WorkoutPhase.exercise);
    });

    test('after Start it counts down', () {
      final (:container, :notifier) = _start([_slot(_timed)]);
      notifier.startTimer();
      expect(read(container).timerStarted, isTrue);

      tick(notifier, 2);
      expect(read(container).timerSec, 3);
    });

    test('a second tap on Start changes nothing', () {
      final (:container, :notifier) = _start([_slot(_timed)]);
      notifier.startTimer();
      tick(notifier, 2);
      notifier.startTimer();
      expect(read(container).timerSec, 3, reason: 'not restarted');
    });

    test('the full hold confirms the set by itself and goes to rest', () {
      final (:container, :notifier) = _start([_slot(_timed)]);
      notifier.startTimer();
      tick(notifier, 5);

      final s = read(container);
      expect(s.phase, WorkoutPhase.rest);
      expect(s.setIndex, 0);
      expect(s.timerStarted, isFalse);
      expect(s.timerSec, 3, reason: 'the rest, not the hold');
    });

    test('stopping early leaves the Start button for the next set', () {
      final (:container, :notifier) = _start([_slot(_timed)]);
      notifier.startTimer();
      tick(notifier, 2);
      notifier.confirmSet(actualDurationSec: 2);
      expect(read(container).phase, WorkoutPhase.rest);
      expect(read(container).timerStarted, isFalse);
    });

    test('after the rest the next set waits for Start again', () {
      final (:container, :notifier) = _start([_slot(_timed)]);
      notifier.startTimer();
      tick(notifier, 5); // set 1 done, rest begins
      tick(notifier, 3); // the rest runs out

      var s = read(container);
      expect(s.phase, WorkoutPhase.exercise);
      expect(s.setIndex, 1);
      expect(s.timerSec, 5, reason: 'a full hold again');
      expect(s.timerStarted, isFalse);

      tick(notifier, 20);
      expect(read(container).timerSec, 5, reason: 'still waiting for Start');

      notifier.skipRest(); // no effect outside the rest
      notifier.startTimer();
      tick(notifier);
      s = read(container);
      expect(s.timerSec, 4);
    });

    test('skipping the rest also leaves the exercise waiting', () {
      final (:container, :notifier) = _start([_slot(_timed)]);
      notifier.startTimer();
      tick(notifier, 5);
      notifier.skipRest();

      expect(read(container).phase, WorkoutPhase.exercise);
      expect(read(container).timerStarted, isFalse);
      tick(notifier, 10);
      expect(read(container).timerSec, 5);
    });

    test('the next exercise waits for Start too, with and without rest', () {
      for (final rest in [3, 0]) {
        final (:container, :notifier) = _start([
          _slot(_timed, sets: 1, rest: rest),
          _slot(_timed, amount: 7, sets: 1, rest: rest),
        ]);
        notifier.startTimer();
        tick(notifier, 5);
        if (rest > 0) tick(notifier, rest); // the rest between exercises

        final s = read(container);
        expect(s.exerciseIndex, 1, reason: 'rest $rest');
        expect(s.phase, WorkoutPhase.exercise, reason: 'rest $rest');
        expect(s.timerSec, 7, reason: 'rest $rest');
        expect(s.timerStarted, isFalse, reason: 'rest $rest');
        tick(notifier, 10);
        expect(read(container).timerSec, 7, reason: 'rest $rest: no countdown');
      }
    });

    test('without any rest the next set of the same exercise waits too', () {
      final (:container, :notifier) = _start([_slot(_timed, sets: 2, rest: 0)]);
      notifier.startTimer();
      tick(notifier, 5);

      final s = read(container);
      expect(s.phase, WorkoutPhase.exercise);
      expect(s.setIndex, 1);
      expect(s.timerSec, 5, reason: 'a full hold, not what was left');
      expect(s.timerStarted, isFalse);
    });
  });

  group('everything else is unchanged', () {
    test('Start does nothing for a reps exercise', () {
      final (:container, :notifier) = _start([_slot(_reps, amount: 8)]);
      notifier.startTimer();
      expect(read(container).timerStarted, isFalse);
      tick(notifier, 5);
      expect(read(container).phase, WorkoutPhase.exercise);
      expect(read(container).repsInput, 8);
    });

    test('Start does nothing during the rest', () {
      final (:container, :notifier) = _start([_slot(_timed)]);
      notifier.startTimer();
      tick(notifier, 5); // into the rest
      notifier.startTimer();
      expect(read(container).timerStarted, isFalse);
      expect(read(container).phase, WorkoutPhase.rest);
    });

    test('the rest counts down on its own, no Start needed', () {
      final (:container, :notifier) = _start([_slot(_reps, amount: 8)]);
      notifier.confirmSet();
      expect(read(container).phase, WorkoutPhase.rest);
      tick(notifier);
      expect(read(container).timerSec, 2);
    });

    test('a reps set followed by a timed exercise: the hold waits for Start', () {
      final (:container, :notifier) = _start([
        _slot(_reps, amount: 8, sets: 1),
        _slot(_timed, amount: 6, sets: 1),
      ]);
      notifier.confirmSet();
      tick(notifier, 3); // the rest between exercises
      final s = read(container);
      expect(s.exerciseIndex, 1);
      expect(s.timerSec, 6);
      expect(s.timerStarted, isFalse);
    });
  });
}
