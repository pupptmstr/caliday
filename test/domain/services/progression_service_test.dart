import 'package:caliday/data/models/enums.dart';
import 'package:caliday/data/models/exercise.dart';
import 'package:caliday/data/models/exercise_result.dart';
import 'package:caliday/data/models/skill_progress.dart';
import 'package:caliday/data/static/exercise_catalog.dart';
import 'package:caliday/domain/services/progression_service.dart';
import 'package:flutter_test/flutter_test.dart';

Exercise _exercise({ExerciseType type = ExerciseType.reps, int targetReps = 10}) =>
    Exercise(
      id: 'test',
      name: 'Test',
      description: 'Test',
      branch: BranchId.push,
      stage: 1,
      type: type,
      startReps: 5,
      targetReps: targetReps,
      startSets: 1,
      targetSets: 3,
      startRestSec: 60,
      targetRestSec: 30,
      spBase: 1,
    );

/// Progress of push stage 1 (stage 2 exists, so a challenge can unlock).
SkillProgress _progress({
  int reps = 5,
  int sets = 1,
  int rest = 60,
  int stage = 1,
  BranchId branch = BranchId.push,
}) =>
    SkillProgress(
      branchId: branch,
      currentStage: stage,
      currentReps: reps,
      currentSets: sets,
      currentRestSec: rest,
    );

/// A successful reps result, as the workout would record it: the target is
/// what the plan asked for, i.e. the current reps.
ExerciseResult _success(SkillProgress p) => ExerciseResult(
    exerciseId: 'test', targetReps: p.currentReps, completedReps: p.currentReps);

ExerciseResult _failure(SkillProgress p) => ExerciseResult(
    exerciseId: 'test',
    targetReps: p.currentReps,
    completedReps: p.currentReps - 1);

void main() {
  const service = ProgressionService();

  group('applyResult', () {
    test('a failed set changes nothing', () {
      final p = _progress();
      expect(service.applyResult(p, _exercise(), _failure(p)), isFalse);
      expect(p.currentReps, 5);
      expect(p.currentSets, 1);
    });

    test('phase 1: reps grow by 2 and stop at the target', () {
      final p = _progress(reps: 5);
      service.applyResult(p, _exercise(), _success(p));
      expect(p.currentReps, 7);
      service.applyResult(p, _exercise(), _success(p));
      expect(p.currentReps, 9);
      service.applyResult(p, _exercise(), _success(p));
      expect(p.currentReps, 10); // capped at targetReps, not 11
    });

    test('phase 2: at target reps a set is added and reps start over', () {
      final p = _progress(reps: 10, sets: 1);
      service.applyResult(p, _exercise(), _success(p));
      expect(p.currentSets, 2);
      expect(p.currentReps, 5);
    });

    test('phase 3: with reps and sets at target, rest shrinks by 15 s', () {
      final p = _progress(reps: 10, sets: 3, rest: 60);
      service.applyResult(p, _exercise(), _success(p));
      expect(p.currentRestSec, 45);
      service.applyResult(p, _exercise(), _success(p));
      expect(p.currentRestSec, 30);
      expect(p.isChallengeUnlocked, isFalse);
    });

    test('rest never drops below the target', () {
      final p = _progress(reps: 10, sets: 3, rest: 40);
      service.applyResult(p, _exercise(), _success(p));
      expect(p.currentRestSec, 30);
    });

    test('when everything is at target the challenge unlocks, once', () {
      final p = _progress(reps: 10, sets: 3, rest: 30);
      expect(service.applyResult(p, _exercise(), _success(p)), isTrue);
      expect(p.isChallengeUnlocked, isTrue);
      // Already unlocked: nothing more to progress, no second "unlock" signal.
      expect(service.applyResult(p, _exercise(), _success(p)), isFalse);
    });

    test('the final stage of a branch never unlocks a challenge', () {
      final last = _progress(
          reps: 10, sets: 3, rest: 30, stage: BranchId.push.stageCount);
      expect(service.applyResult(last, _exercise(), _success(last)), isFalse);
      expect(last.isChallengeUnlocked, isFalse);
    });

    test('timed exercises succeed when the held time reaches the target', () {
      final plank = _exercise(type: ExerciseType.timed, targetReps: 60);
      final p = _progress(reps: 20);
      ExerciseResult held(int seconds) => ExerciseResult(
            exerciseId: 'test',
            targetReps: p.currentReps,
            completedReps: 0,
            targetDurationSec: p.currentReps,
            actualDurationSec: seconds,
          );
      service.applyResult(p, plank, held(19));
      expect(p.currentReps, 20, reason: 'held 19 s of 20 s');
      service.applyResult(p, plank, held(20));
      expect(p.currentReps, 22);
    });

    test('a full stage plays out in the documented order', () {
      final exercise = _exercise();
      final p = _progress();
      var unlocked = 0;
      var steps = 0;
      while (!p.isChallengeUnlocked && steps < 100) {
        if (service.applyResult(p, exercise, _success(p))) unlocked++;
        steps++;
      }
      expect(p.isChallengeUnlocked, isTrue);
      expect(unlocked, 1);
      expect((p.currentReps, p.currentSets, p.currentRestSec), (10, 3, 30));
      // 3 rep steps per set x 3 sets, 2 set additions, 2 rest cuts, 1 unlock.
      expect(steps, 14);
    });
  });

  group('advanceStage', () {
    test('moves to the next exercise and resets the load', () {
      final p = _progress(reps: 10, sets: 3, rest: 30)
        ..isChallengeUnlocked = true;
      final next = ExerciseCatalog.forStage(BranchId.push, 2)!;
      service.advanceStage(p, next);
      expect(p.currentStage, 2);
      expect(p.currentReps, next.startReps);
      expect(p.currentSets, next.startSets);
      expect(p.currentRestSec, next.startRestSec);
      expect(p.isChallengeUnlocked, isFalse);
    });
  });

  group('applyRegression', () {
    test('does nothing for fewer than 3 days', () {
      final p = _progress(reps: 9);
      service.applyRegression(p, _exercise(), 2);
      expect(p.currentReps, 9);
    });

    test('takes one 2-rep step back per full 3-day block', () {
      final p = _progress(reps: 9);
      service.applyRegression(p, _exercise(), 3);
      expect(p.currentReps, 7);
      service.applyRegression(p, _exercise(), 5); // still 1 block
      expect(p.currentReps, 5);
      final q = _progress(reps: 10);
      service.applyRegression(q, _exercise(), 9); // 3 blocks
      expect(q.currentReps, 5); // 10 - 6 = 4, floored at startReps
    });

    test('never goes below the exercise start reps', () {
      final p = _progress(reps: 6);
      service.applyRegression(p, _exercise(), 300);
      expect(p.currentReps, 5);
    });
  });

  group('nextExercise', () {
    test('is the following stage, and null after the last one', () {
      expect(service.nextExercise(_progress(stage: 1))!.stage, 2);
      expect(
          service.nextExercise(_progress(stage: BranchId.push.stageCount)),
          isNull);
    });
  });

  group('every real stage can be progressed through', () {
    // Runs the actual catalog data through the service: a wrong target in the
    // catalog (e.g. start above target) would leave the stage stuck forever.
    for (final branch in BranchId.values) {
      for (final exercise in ExerciseCatalog.progressionFor(branch)) {
        test(exercise.id, () {
          final p = SkillProgress(
            branchId: branch,
            currentStage: exercise.stage,
            currentReps: exercise.startReps,
            currentSets: exercise.startSets,
            currentRestSec: exercise.startRestSec,
          );
          final isTimed = exercise.type == ExerciseType.timed;
          var steps = 0;
          while (!p.isChallengeUnlocked && steps < 200) {
            final target = p.currentReps;
            final result = ExerciseResult(
              exerciseId: exercise.id,
              targetReps: target,
              completedReps: isTimed ? 0 : target,
              targetDurationSec: isTimed ? target : null,
              actualDurationSec: isTimed ? target : null,
            );
            final before = (p.currentReps, p.currentSets, p.currentRestSec);
            service.applyResult(p, exercise, result);
            if (!p.isChallengeUnlocked &&
                before == (p.currentReps, p.currentSets, p.currentRestSec)) {
              break; // no movement and no unlock: stuck
            }
            steps++;
          }
          final isFinal = exercise.stage == branch.stageCount;
          if (isFinal) {
            expect(p.isChallengeUnlocked, isFalse,
                reason: 'there is no next stage to challenge');
          } else {
            expect(p.isChallengeUnlocked, isTrue,
                reason: 'stuck at ${p.currentReps} reps, ${p.currentSets} sets, '
                    '${p.currentRestSec} s rest after $steps steps');
            expect(p.currentReps, exercise.targetReps);
            expect(p.currentSets, exercise.targetSets);
          }
        });
      }
    }
  });
}
