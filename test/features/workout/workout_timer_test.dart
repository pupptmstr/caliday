import 'package:caliday/data/models/enums.dart';
import 'package:caliday/data/models/exercise.dart';
import 'package:caliday/data/static/exercise_catalog.dart';
import 'package:caliday/domain/models/workout_plan.dart';
import 'package:caliday/features/workout/providers/workout_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// A timed exercise (plank, dead hang...) does not start its hold at once: a
/// get-ready countdown runs first, so there is time to take position and read.
/// It can be paused and resumed; when it ends the hold begins by itself.

final Exercise _timed = ExerciseCatalog.libraryAll
    .firstWhere((e) => e.type == ExerciseType.timed && !e.perSide);
final Exercise _perSide = ExerciseCatalog.libraryAll
    .firstWhere((e) => e.type == ExerciseType.timed && e.perSide);
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

  group('a timed exercise gets a get-ready countdown first', () {
    test('it begins with the countdown running and a full hold waiting', () {
      final (:container, :notifier) = _start([_slot(_timed)]);
      var s = read(container);
      expect(s.isGettingReady, isTrue);
      expect(s.isHolding, isFalse);
      expect(s.prepSec, kPrepNewExerciseSec);
      expect(s.timerSec, 5);

      tick(notifier, 3);
      s = read(container);
      expect(s.prepSec, kPrepNewExerciseSec - 3);
      expect(s.timerSec, 5, reason: 'the hold has not started');
      expect(s.phase, WorkoutPhase.exercise);
    });

    test('the hold begins by itself when the countdown ends', () {
      final (:container, :notifier) = _start([_slot(_timed)]);
      tick(notifier, kPrepNewExerciseSec - 1);
      expect(read(container).isGettingReady, isTrue);

      tick(notifier);
      var s = read(container);
      expect(s.isGettingReady, isFalse);
      expect(s.isHolding, isTrue);
      expect(s.timerSec, 5, reason: 'the hold starts from its full length');

      tick(notifier, 2);
      s = read(container);
      expect(s.timerSec, 3);
      expect(s.prepSec, 0);
    });

    test('the full hold confirms the set by itself and goes to rest', () {
      final (:container, :notifier) = _start([_slot(_timed)]);
      tick(notifier, kPrepNewExerciseSec + 5);

      final s = read(container);
      expect(s.phase, WorkoutPhase.rest);
      expect(s.setIndex, 0);
      expect(s.prepSec, 0);
      expect(s.timerSec, 3, reason: 'the rest, not the hold');
    });

    test('stopping the hold early goes to rest', () {
      final (:container, :notifier) = _start([_slot(_timed)]);
      tick(notifier, kPrepNewExerciseSec + 2);
      notifier.confirmSet(actualDurationSec: 2);
      expect(read(container).phase, WorkoutPhase.rest);
      expect(read(container).isHolding, isFalse);
    });
  });

  group('Pause and Continue', () {
    test('Pause freezes the countdown, Continue picks it up where it stopped', () {
      final (:container, :notifier) = _start([_slot(_timed)]);
      tick(notifier, 4);
      notifier.pausePrep();

      var s = read(container);
      expect(s.prepPaused, isTrue);
      expect(s.prepSec, kPrepNewExerciseSec - 4);

      tick(notifier, 30);
      s = read(container);
      expect(s.prepSec, kPrepNewExerciseSec - 4, reason: 'frozen while paused');
      expect(s.timerSec, 5, reason: 'the hold has not started');
      expect(s.phase, WorkoutPhase.exercise);

      notifier.resumePrep();
      expect(read(container).prepPaused, isFalse);
      tick(notifier);
      expect(read(container).prepSec, kPrepNewExerciseSec - 5,
          reason: 'not restarted from the full countdown');

      tick(notifier, kPrepNewExerciseSec - 5);
      expect(read(container).isHolding, isTrue);
    });

    test('it can be paused again and again', () {
      final (:container, :notifier) = _start([_slot(_timed)]);
      for (var i = 0; i < 3; i++) {
        tick(notifier, 2);
        notifier.pausePrep();
        tick(notifier, 5);
        notifier.resumePrep();
      }
      expect(read(container).prepSec, kPrepNewExerciseSec - 6);
      expect(read(container).prepPaused, isFalse);
    });

    test('pausing twice or continuing without a pause changes nothing', () {
      final (:container, :notifier) = _start([_slot(_timed)]);
      tick(notifier, 2);
      notifier.resumePrep();
      expect(read(container).prepPaused, isFalse);

      notifier.pausePrep();
      notifier.pausePrep();
      expect(read(container).prepPaused, isTrue);
      expect(read(container).prepSec, kPrepNewExerciseSec - 2);
    });

    test('Pause does nothing once the hold runs', () {
      final (:container, :notifier) = _start([_slot(_timed)]);
      tick(notifier, kPrepNewExerciseSec + 1);
      notifier.pausePrep();
      expect(read(container).prepPaused, isFalse);

      tick(notifier);
      expect(read(container).timerSec, 3, reason: 'the hold keeps counting');
    });

    test('Pause does nothing during the rest', () {
      final (:container, :notifier) = _start([_slot(_timed)]);
      tick(notifier, kPrepNewExerciseSec + 5); // into the rest
      notifier.pausePrep();
      expect(read(container).prepPaused, isFalse);
      tick(notifier);
      expect(read(container).timerSec, 2, reason: 'the rest keeps counting');
    });

    test('a pause does not leak into the next set', () {
      final (:container, :notifier) = _start([_slot(_timed)]);
      notifier.pausePrep();
      notifier.confirmSet(actualDurationSec: 1); // not reachable from the UI
      expect(read(container).phase, WorkoutPhase.rest);
      expect(read(container).prepPaused, isFalse);

      notifier.skipRest();
      final s = read(container);
      expect(s.prepPaused, isFalse);
      tick(notifier);
      expect(read(container).prepSec, s.prepSec - 1, reason: 'it counts');
    });

    test('nor through a hand-over without a rest', () {
      // Same set list twice: the next set, and the next exercise.
      for (final slots in [
        [_slot(_timed, sets: 2, rest: 0)],
        [_slot(_timed, sets: 1, rest: 0), _slot(_timed, sets: 1, rest: 0)],
      ]) {
        final (:container, :notifier) = _start(slots);
        notifier.pausePrep();
        notifier.confirmSet(actualDurationSec: 1); // not reachable from the UI

        final s = read(container);
        expect(s.phase, WorkoutPhase.exercise, reason: '${slots.length} slots');
        expect(s.prepPaused, isFalse, reason: '${slots.length} slots');
        tick(notifier);
        expect(read(container).prepSec, s.prepSec - 1,
            reason: '${slots.length} slots: it counts');
      }
    });
  });

  group('every way into a timed exercise gets a countdown', () {
    test('the next set after a rest gets the short one', () {
      final (:container, :notifier) = _start([_slot(_timed)]);
      tick(notifier, kPrepNewExerciseSec + 5); // set 1 done, rest begins
      tick(notifier, 3); // the rest runs out

      var s = read(container);
      expect(s.phase, WorkoutPhase.exercise);
      expect(s.setIndex, 1);
      expect(s.prepSec, kPrepNextSetSec);
      expect(s.timerSec, 5, reason: 'a full hold again');
      expect(s.isHolding, isFalse);

      tick(notifier, kPrepNextSetSec);
      s = read(container);
      expect(s.isHolding, isTrue);
      expect(s.timerSec, 5);
    });

    test('skipping the rest does not skip the countdown', () {
      final (:container, :notifier) = _start([_slot(_timed)]);
      tick(notifier, kPrepNewExerciseSec + 5);
      notifier.skipRest();

      final s = read(container);
      expect(s.phase, WorkoutPhase.exercise);
      expect(s.prepSec, kPrepNextSetSec);
      tick(notifier, 2);
      expect(read(container).timerSec, 5, reason: 'the hold has not started');
    });

    test('the next exercise gets the long one, with and without a rest', () {
      for (final rest in [3, 0]) {
        final (:container, :notifier) = _start([
          _slot(_timed, sets: 1, rest: rest),
          _slot(_timed, amount: 7, sets: 1, rest: rest),
        ]);
        tick(notifier, kPrepNewExerciseSec + 5);
        if (rest > 0) tick(notifier, rest); // the rest between exercises

        var s = read(container);
        expect(s.exerciseIndex, 1, reason: 'rest $rest');
        expect(s.phase, WorkoutPhase.exercise, reason: 'rest $rest');
        expect(s.prepSec, kPrepNewExerciseSec, reason: 'rest $rest');
        expect(s.timerSec, 7, reason: 'rest $rest');
        expect(s.isHolding, isFalse, reason: 'rest $rest');

        tick(notifier, kPrepNewExerciseSec);
        s = read(container);
        expect(s.isHolding, isTrue, reason: 'rest $rest');
        expect(s.timerSec, 7, reason: 'rest $rest');
      }
    });

    test('without any rest the next set of the same exercise gets the short one', () {
      final (:container, :notifier) = _start([_slot(_timed, sets: 2, rest: 0)]);
      tick(notifier, kPrepNewExerciseSec + 5);

      final s = read(container);
      expect(s.phase, WorkoutPhase.exercise);
      expect(s.setIndex, 1);
      expect(s.prepSec, kPrepNextSetSec);
      expect(s.timerSec, 5, reason: 'a full hold, not what was left');
      expect(s.isHolding, isFalse);
    });

    test('a reps exercise followed by a timed one: the hold waits for its countdown', () {
      final (:container, :notifier) = _start([
        _slot(_reps, amount: 8, sets: 1),
        _slot(_timed, amount: 6, sets: 1),
      ]);
      notifier.confirmSet();
      tick(notifier, 3); // the rest between exercises
      final s = read(container);
      expect(s.exerciseIndex, 1);
      expect(s.prepSec, kPrepNewExerciseSec);
      expect(s.timerSec, 6);
      expect(s.isHolding, isFalse);
    });
  });

  group('reps exercises and rests are unchanged', () {
    test('a reps exercise has no countdown and Pause does nothing', () {
      final (:container, :notifier) = _start([_slot(_reps, amount: 8)]);
      var s = read(container);
      expect(s.prepSec, 0);
      expect(s.isGettingReady, isFalse);
      expect(s.isHolding, isFalse);

      notifier.pausePrep();
      tick(notifier, 30);
      s = read(container);
      expect(s.prepPaused, isFalse);
      expect(s.phase, WorkoutPhase.exercise);
      expect(s.repsInput, 8);
    });

    test('the rest counts down on its own', () {
      final (:container, :notifier) = _start([_slot(_reps, amount: 8)]);
      notifier.confirmSet();
      expect(read(container).phase, WorkoutPhase.rest);
      tick(notifier);
      expect(read(container).timerSec, 2);
    });
  });

  group('the estimate is the length of the real run', () {
    // Ticks a run of timed [slots] takes, counted on the real state machine.
    // The very last tick is not played: it would finish the workout, which
    // writes to Hive; it is the one that ends the final hold (timerSec 1).
    int ticksOfRun(List<PlannedExercise> slots) {
      final (:container, :notifier) = _start(slots);
      var ticks = 0;
      while (true) {
        final s = read(container);
        if (s.isHolding &&
            s.isLastExercise &&
            s.isLastSet &&
            s.isLastSide &&
            s.timerSec <= 1) {
          return ticks + 1;
        }
        notifier.tick();
        ticks++;
        if (ticks > 100000) fail('the run does not end');
      }
    }

    test('countdowns, holds and rests add up to the ticks of the run', () {
      final plans = [
        [_slot(_timed, sets: 1, rest: 0)],
        [_slot(_timed, amount: 30, sets: 3, rest: 20)],
        [
          _slot(_timed, amount: 15, sets: 1, rest: 0), // a warm-up
          _slot(_timed, amount: 40, sets: 2, rest: 45),
          _slot(_timed, amount: 25, sets: 1, rest: 0), // a cool-down
        ],
        [
          _slot(_timed, amount: 20, sets: 2, rest: 30),
          _slot(_timed, amount: 10, sets: 2, rest: 0),
          _slot(_timed, amount: 35, sets: 3, rest: 60),
        ],
        // Holds on each side.
        [_slot(_perSide, amount: 30, sets: 2, rest: 15)],
        [
          _slot(_timed, amount: 15, sets: 1, rest: 0),
          _slot(_perSide, amount: 20, sets: 2, rest: 0),
          _slot(_perSide, amount: 25, sets: 1, rest: 10),
          _slot(_timed, amount: 30, sets: 2, rest: 20),
        ],
      ];
      for (final slots in plans) {
        final plan = WorkoutPlan(setType: SetType.daily, exercises: slots);
        expect(ticksOfRun(slots), plan.estimatedDurationSec,
            reason: slots.map((s) => '${s.sets}x${s.targetAmount}/${s.restSec}').join(' '));
      }
    });
  });

  group('a hold on each side: side 1, switch sides, side 2, then the rest', () {
    test('the first side ends in a switch-sides countdown, not in the rest', () {
      final (:container, :notifier) = _start([_slot(_perSide)]);
      var s = read(container);
      expect(s.sideIndex, 0);
      expect(s.isSwitchingSides, isFalse);
      expect(s.isLastSide, isFalse);

      tick(notifier, kPrepNewExerciseSec + 5); // countdown + side 1
      s = read(container);
      expect(s.phase, WorkoutPhase.exercise);
      expect(s.setIndex, 0, reason: 'the same set goes on');
      expect(s.sideIndex, 1);
      expect(s.isSwitchingSides, isTrue);
      expect(s.isLastSide, isTrue);
      expect(s.prepSec, kPrepSwitchSideSec);
      expect(s.timerSec, 5, reason: 'side 2 waits with its full hold');
      expect(s.runningCountdownSec, kPrepSwitchSideSec);
    });

    test('side 2 begins by itself and its end goes to the rest', () {
      final (:container, :notifier) = _start([_slot(_perSide)]);
      tick(notifier, kPrepNewExerciseSec + 5 + kPrepSwitchSideSec);
      var s = read(container);
      expect(s.isHolding, isTrue);
      expect(s.sideIndex, 1);

      tick(notifier, 5);
      s = read(container);
      expect(s.phase, WorkoutPhase.rest);
      expect(s.sideIndex, 0);
      expect(s.timerSec, 3, reason: 'the rest');
    });

    test('Stop on the first side goes to the other side, not to the rest', () {
      final (:container, :notifier) = _start([_slot(_perSide)]);
      tick(notifier, kPrepNewExerciseSec + 2);
      notifier.confirmSet(actualDurationSec: 2);
      final s = read(container);
      expect(s.phase, WorkoutPhase.exercise);
      expect(s.isSwitchingSides, isTrue);
      expect(s.firstSideSec, 2);
    });

    test('the switch-sides countdown can be paused like any other', () {
      final (:container, :notifier) = _start([_slot(_perSide)]);
      tick(notifier, kPrepNewExerciseSec + 5 + 2);
      notifier.pausePrep();
      tick(notifier, 10);
      var s = read(container);
      expect(s.isSwitchingSides, isTrue);
      expect(s.prepSec, kPrepSwitchSideSec - 2, reason: 'frozen while paused');
      expect(s.runningCountdownSec, 0);

      notifier.resumePrep();
      tick(notifier, kPrepSwitchSideSec - 2);
      s = read(container);
      expect(s.isHolding, isTrue);
      expect(s.sideIndex, 1);
    });

    test('the next set starts again on the first side, with the short countdown', () {
      final (:container, :notifier) = _start([_slot(_perSide)]);
      tick(notifier, kPrepNewExerciseSec + 5 + kPrepSwitchSideSec + 5); // set 1
      notifier.skipRest();
      final s = read(container);
      expect(s.setIndex, 1);
      expect(s.sideIndex, 0);
      expect(s.isSwitchingSides, isFalse);
      expect(s.prepSec, kPrepNextSetSec);
    });

    test('the result counts the weaker side', () {
      // One set, then another exercise: the result is recorded without
      // finishing the workout.
      final (:container, :notifier) =
          _start([_slot(_perSide, amount: 20, sets: 1, rest: 0), _slot(_timed)]);
      tick(notifier, kPrepNewExerciseSec + 20); // side 1, full
      tick(notifier, kPrepSwitchSideSec + 12);
      notifier.confirmSet(actualDurationSec: 12); // side 2, stopped at 12 s
      var r = read(container).results[0]!;
      expect(r.actualDurationSec, 12);
      expect(r.targetDurationSec, 20);

      final other = _start([_slot(_perSide, amount: 20, sets: 1, rest: 0), _slot(_timed)]);
      tick(other.notifier, kPrepNewExerciseSec + 7);
      other.notifier.confirmSet(actualDurationSec: 7); // side 1, stopped at 7 s
      tick(other.notifier, kPrepSwitchSideSec + 20); // side 2, full
      r = read(other.container).results[0]!;
      expect(r.actualDurationSec, 7);
    });

    test('an exercise held once is unchanged', () {
      final (:container, :notifier) = _start([_slot(_timed)]);
      expect(read(container).isLastSide, isTrue);
      tick(notifier, kPrepNewExerciseSec + 5);
      expect(read(container).phase, WorkoutPhase.rest);
    });
  });

  group('runningCountdownSec follows what is counting down', () {
    test('rest, countdown, paused countdown, hold, reps', () {
      final (:container, :notifier) = _start([_slot(_timed)]);
      expect(read(container).runningCountdownSec, kPrepNewExerciseSec);

      tick(notifier, 3);
      notifier.pausePrep();
      expect(read(container).runningCountdownSec, 0, reason: 'paused');

      notifier.resumePrep();
      tick(notifier, kPrepNewExerciseSec - 3);
      expect(read(container).runningCountdownSec, 5, reason: 'the hold');

      tick(notifier, 5); // set done, rest
      expect(read(container).runningCountdownSec, 3, reason: 'the rest');

      final reps = _start([_slot(_reps, amount: 8)]);
      expect(read(reps.container).runningCountdownSec, 0);
    });
  });
}
