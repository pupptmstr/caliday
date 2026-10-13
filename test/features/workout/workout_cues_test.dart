import 'dart:io';

import 'package:treniday/core/services/sound_service.dart';
import 'package:treniday/data/models/enums.dart';
import 'package:treniday/data/models/exercise.dart';
import 'package:treniday/data/static/exercise_catalog.dart';
import 'package:treniday/domain/models/workout_plan.dart';
import 'package:treniday/features/workout/providers/workout_provider.dart';
import 'package:treniday/features/workout/workout_cues.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Every moment of a workout has its own cue (owner, 2026-10-12): the user is
/// on the floor and not looking, so each one must be told apart by ear. These
/// tests run the real state machine the way the workout screen does.

final Exercise _timed = ExerciseCatalog.libraryAll
    .firstWhere((e) => e.type == ExerciseType.timed && !e.perSide);
final Exercise _perSide = ExerciseCatalog.libraryAll
    .firstWhere((e) => e.type == ExerciseType.timed && e.perSide);
final Exercise _reps =
    ExerciseCatalog.libraryAll.firstWhere((e) => e.type == ExerciseType.reps);

PlannedExercise _slot(Exercise e, {int amount = 30, int sets = 2, int rest = 10}) =>
    PlannedExercise(exercise: e, targetAmount: amount, sets: sets, restSec: rest);

/// The screen, without the screen: [second] plays the cue of the second and
/// ticks the timer, and every change of state adds its cue to [cues].
class _Run {
  _Run(List<PlannedExercise> slots) {
    container = ProviderContainer();
    addTearDown(container.dispose);
    container
        .read(customWorkoutPlanProvider.notifier)
        .set(WorkoutPlan(setType: SetType.daily, exercises: slots));
    container.listen<WorkoutState>(workoutProvider, (prev, next) {
      if (prev == null) return;
      final cue = cueForChange(prev, next);
      if (cue != null) cues.add(cue);
    });
    notifier = container.read(workoutProvider.notifier);
  }

  late final ProviderContainer container;
  late final WorkoutNotifier notifier;
  final cues = <SoundCue>[];

  WorkoutState get state => container.read(workoutProvider);

  /// [n] seconds pass; returns the cues they played (and clears the list).
  List<SoundCue> second([int n = 1]) {
    for (var i = 0; i < n; i++) {
      final cue = cueForSecond(state);
      if (cue != null) cues.add(cue);
      notifier.tick();
    }
    return taken();
  }

  List<SoundCue> taken() {
    final out = List.of(cues);
    cues.clear();
    return out;
  }
}

const _countdown5 = [
  SoundCue.tick, SoundCue.tick, SoundCue.tick, SoundCue.tick, SoundCue.tickLast,
];
const _countdown4 = [SoundCue.tick, SoundCue.tick, SoundCue.tick, SoundCue.tickLast];
const _holdEnd = [
  SoundCue.tickHold, SoundCue.tickHold, SoundCue.tickHold, SoundCue.tickHold,
  SoundCue.tickHold,
];

void main() {
  group('a timed exercise, second by second', () {
    test('the get-ready countdown: five ticks, the last higher, then "go"', () {
      final run = _Run([_slot(_timed)]);
      expect(kPrepNewExerciseSec, 10);
      expect(run.second(kPrepNewExerciseSec - kTickSeconds - 1), isEmpty);
      expect(run.second(kTickSeconds + 1), [..._countdown5, SoundCue.go]);
      expect(run.state.isHolding, isTrue);
    });

    test('a 30 s hold: halfway, five lower ticks, then the set is done', () {
      final run = _Run([_slot(_timed)])..second(kPrepNewExerciseSec);
      expect(run.second(14), isEmpty);
      expect(run.second(), [SoundCue.holdHalf]);
      expect(run.state.timerSec, 15, reason: 'half of the hold is left');
      expect(run.second(15), [..._holdEnd, SoundCue.setDone]);
      expect(run.state.phase, WorkoutPhase.rest);
    });

    test('a hold under 20 s has no halfway cue', () {
      final run = _Run([_slot(_timed, amount: 15)])..second(kPrepNewExerciseSec);
      expect(run.second(15), [..._holdEnd, SoundCue.setDone]);
    });

    test('the rest ticks down to the next set, whose short countdown leads to "go"', () {
      final run = _Run([_slot(_timed)])..second(kPrepNewExerciseSec + 30);
      expect(run.second(10), [..._countdown5, SoundCue.restOver]);
      expect(run.state.setIndex, 1);
      expect(kPrepNextSetSec, 5);
      expect(run.second(kPrepNextSetSec), [..._countdown4, SoundCue.go]);
    });

    test('Pause and Continue have their cues; a paused countdown is silent', () {
      final run = _Run([_slot(_timed)])..second(4);
      run.notifier.pausePrep();
      expect(run.taken(), [SoundCue.pause]);
      expect(run.second(20), isEmpty);
      run.notifier.resumePrep();
      expect(run.taken(), [SoundCue.resume]);
      expect(run.second(6), [..._countdown5, SoundCue.go]);
    });

    test('Stop during the hold ends the set at once', () {
      final run = _Run([_slot(_timed)])..second(kPrepNewExerciseSec + 3);
      run.notifier.confirmSet(actualDurationSec: 3);
      expect(run.taken(), [SoundCue.setDone]);
    });
  });

  group('a hold on each side', () {
    test('side 1 ends in "switch sides", its countdown leads to "go" again', () {
      final run = _Run([_slot(_perSide)])..second(kPrepNewExerciseSec + 15);
      expect(run.second(15), [..._holdEnd, SoundCue.switchSides]);
      expect(run.state.isSwitchingSides, isTrue);
      expect(run.second(kPrepSwitchSideSec), [..._countdown4, SoundCue.go]);
      expect(run.second(30),
          [SoundCue.holdHalf, ..._holdEnd, SoundCue.setDone],
          reason: 'the second side ends the set');
    });
  });

  group('sets, rests and exercises', () {
    test('a reps set: the counter is silent, "Done" ends the set', () {
      final run = _Run([_slot(_reps, amount: 10)]);
      run.notifier
        ..adjustReps(1)
        ..adjustReps(-1);
      expect(run.second(5), isEmpty, reason: 'nothing counts down');
      run.notifier.confirmSet();
      expect(run.taken(), [SoundCue.setDone]);
    });

    test('skipping the rest has its own cue', () {
      final run = _Run([_slot(_reps, amount: 10)]);
      run.notifier.confirmSet();
      run.second(3);
      run.taken();
      run.notifier.skipRest();
      expect(run.taken(), [SoundCue.skip]);
    });

    test('the rest between exercises ends in "next exercise"', () {
      final run = _Run([_slot(_reps, sets: 1), _slot(_timed)]);
      run.notifier.confirmSet();
      expect(run.taken(), [SoundCue.setDone]);
      expect(run.second(10), [..._countdown5, SoundCue.nextExercise]);
      expect(run.state.exerciseIndex, 1);
    });

    test('without a rest: the next exercise and the next set have their cues', () {
      final run = _Run([_slot(_reps, sets: 2, rest: 0), _slot(_timed)]);
      run.notifier.confirmSet();
      expect(run.taken(), [SoundCue.setDone]);
      expect(run.state.setIndex, 1);
      run.notifier.confirmSet();
      expect(run.taken(), [SoundCue.nextExercise]);
    });
  });

  group('the start and the end', () {
    WorkoutPlan plan(SetType type) =>
        WorkoutPlan(setType: type, exercises: [_slot(_timed)]);

    test('a challenge opens with Skala\'s drum', () {
      expect(startCue(plan(SetType.daily)), SoundCue.start);
      expect(startCue(plan(SetType.challenge)), SoundCue.challengeStart);
    });

    test('the end: the finale, or the challenge passed or failed', () {
      SoundCue? end(SetType type, {bool passed = false}) {
        final prev = WorkoutState.initial(plan(type));
        return cueForChange(
            prev, prev.copyWith(phase: WorkoutPhase.done, challengePassed: passed));
      }

      expect(end(SetType.daily), SoundCue.complete);
      expect(end(SetType.challenge, passed: true), SoundCue.challengePassed);
      expect(end(SetType.challenge), SoundCue.challengeFailed);

      final done = WorkoutState.initial(plan(SetType.daily))
          .copyWith(phase: WorkoutPhase.done);
      expect(cueForChange(done, done.copyWith(spEarned: 10)), isNull,
          reason: 'the end plays once');
    });

    test('the summary plays its cues in the order of its banners', () {
      expect(
          summaryCues(
            achievement: true,
            freezeUsed: true,
            freezeEarned: true,
            challengeUnlocked: true,
            newStage: true,
          ),
          [
            SoundCue.achievement,
            SoundCue.freezeUsed,
            SoundCue.freezeEarned,
            SoundCue.challengeStart,
            SoundCue.stageUp,
          ]);
      expect(
          summaryCues(
            achievement: false,
            freezeUsed: false,
            freezeEarned: false,
            challengeUnlocked: false,
            newStage: false,
          ),
          isEmpty);
    });
  });

  group('sound modes', () {
    test('"key only" keeps what is needed without looking at the screen', () {
      expect(
          {for (final c in SoundCue.values) if (c.soundsIn(SoundMode.key)) c},
          {
            SoundCue.tickLast,
            SoundCue.go,
            SoundCue.switchSides,
            SoundCue.setDone,
            SoundCue.restOver,
            SoundCue.nextExercise,
            SoundCue.complete,
            SoundCue.challengePassed,
            SoundCue.challengeFailed,
          });
      expect(SoundCue.values.every((c) => c.soundsIn(SoundMode.all)), isTrue);
      expect(SoundCue.values.any((c) => c.soundsIn(SoundMode.off)), isFalse);
    });

    test('a profile from before 0.9.6 keeps its on/off switch', () {
      expect(SoundMode.from(null), SoundMode.all);
      expect(SoundMode.from(null, legacyEnabled: true), SoundMode.all);
      expect(SoundMode.from(null, legacyEnabled: false), SoundMode.off);
      expect(SoundMode.from('key', legacyEnabled: false), SoundMode.key);
      expect(SoundMode.from('loud'), SoundMode.all);
    });
  });

  test('every cue has its file, and every file is a cue', () {
    final files = {
      for (final f in Directory('assets/sounds').listSync())
        f.uri.pathSegments.last,
    };
    expect(files, {for (final c in SoundCue.values) '${c.file}.wav'});
  });

  test('the web build finds every cue in the asset bundle', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    for (final cue in SoundCue.values) {
      final data = await rootBundle.load(cue.bundleKey);
      expect(data.lengthInBytes, greaterThan(44), reason: cue.bundleKey);
    }
  });
}
