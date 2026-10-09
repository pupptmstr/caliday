import 'package:caliday/data/models/enums.dart';
import 'package:caliday/data/models/exercise.dart';
import 'package:caliday/data/models/skill_progress.dart';
import 'package:caliday/data/static/exercise_catalog.dart';
import 'package:caliday/data/static/supplementary_exercise_catalog.dart';
import 'package:caliday/domain/models/branch.dart';
import 'package:caliday/domain/services/custom_stages.dart';
import 'package:flutter_test/flutter_test.dart';

/// A branch the user makes holds catalog exercises in their order; the app
/// sets the amounts and the challenges (owner, 2026-10-09).
void main() {
  final squat = ExerciseCatalog.legsS1Squat; // a stage of its own: 8 → 20
  final fullPushup = ExerciseCatalog.pushS3FullPushup; // stage 3, own norm
  final calfRaise = SupplementaryExerciseCatalog.all
      .firstWhere((e) => e.id == 'supp_standing_calf_raise'); // 15, 2 sets
  final catCow = ExerciseCatalog.cooldownCatCow; // 30 s, one set

  group('stageOf', () {
    test('the place is the stage number; the id, texts and animation stay', () {
      final stages = CustomStages.build([fullPushup, squat, catCow]);
      expect(stages.map((e) => e.stage), [1, 2, 3]);
      expect(stages.map((e) => e.id), [fullPushup.id, squat.id, catCow.id]);
      expect(stages[0].animationPath, fullPushup.animationPath);
      expect(stages[0].branch, BranchId.push, reason: 'its warm-up comes from Push');
      expect(stages[1].type, ExerciseType.reps);
      expect(stages[2].type, ExerciseType.timed);
    });

    test('a built-in stage keeps its own start → target, sets and rests', () {
      final s = CustomStages.stageOf(squat, 2);
      expect([s.startReps, s.targetReps], [squat.startReps, squat.targetReps]);
      expect([s.startSets, s.targetSets], [squat.startSets, squat.targetSets]);
      expect([s.startRestSec, s.targetRestSec],
          [squat.startRestSec, squat.targetRestSec]);
    });

    test('a fixed amount (supplementary) grows to twice it, in 1 → 2 sets', () {
      final s = CustomStages.stageOf(calfRaise, 1);
      expect([s.startReps, s.targetReps], [15, 30]);
      expect([s.startSets, s.targetSets], [1, 2]);
      expect([s.startRestSec, s.targetRestSec],
          [CustomStages.restStart, CustomStages.restTarget]);
      expect(CustomStages.hasOwnProgression(s), isTrue,
          reason: 'the stage now has something to climb');
    });

    test('a timed fixed amount doubles in whole 5 s', () {
      final s = CustomStages.stageOf(catCow, 1);
      expect([s.startReps, s.targetReps], [30, 60]);
      expect(s.targetReps % 5, 0);
    });

    test('per side and equipment carry over', () {
      final sidePlank = SupplementaryExerciseCatalog.all
          .firstWhere((e) => e.id == 'supp_side_plank');
      expect(CustomStages.stageOf(sidePlank, 1).perSide, isTrue);
      final hanging = ExerciseCatalog.coreS4HangingLegRaise;
      expect(CustomStages.stageOf(hanging, 1).requiresEquipment, isTrue);
    });
  });

  group('the challenge to enter a stage', () {
    test('stage 1 has none', () {
      expect(CustomStages.stageOf(fullPushup, 1).challengeTargetReps, 0);
    });

    test('a built-in stage from 2 up brings its own norm', () {
      expect(CustomStages.stageOf(fullPushup, 2).challengeTargetReps,
          fullPushup.challengeTargetReps);
    });

    test('otherwise one and a half times the start', () {
      expect(CustomStages.stageOf(squat, 2).challengeTargetReps, 12); // 8 × 1.5
      expect(CustomStages.stageOf(calfRaise, 3).challengeTargetReps, 23); // 22.5
      expect(CustomStages.stageOf(catCow, 2).challengeTargetReps, 45);
    });

    test('every pickable exercise gives a stage that can be entered and climbed',
        () {
      for (final e in OwnBranch.pickable) {
        final s = CustomStages.stageOf(e, 2);
        expect(s.challengeTargetReps, greaterThan(0), reason: e.id);
        if (e.stage < 2) {
          // A derived norm; a built-in one may sit below the start (the
          // catalog's own choice, e.g. archer push-ups).
          expect(s.challengeTargetReps, greaterThanOrEqualTo(s.startReps),
              reason: e.id);
        }
        expect(s.targetReps, greaterThanOrEqualTo(s.startReps), reason: e.id);
        expect(s.targetSets, greaterThanOrEqualTo(s.startSets), reason: e.id);
        expect(CustomStages.hasOwnProgression(s), isTrue, reason: e.id);
      }
    });
  });

  group('remap: the stages of a branch with progress changed', () {
    final ids = [squat.id, fullPushup.id, catCow.id];

    SkillProgress onStage(int stage) => SkillProgress(
          customBranchId: 'b1',
          currentStage: stage,
          currentReps: 14,
          currentSets: 2,
          currentRestSec: 30,
          isChallengeUnlocked: true,
        );

    test('the user stays on their exercise when it moved, amounts kept', () {
      final p = onStage(2);
      CustomStages.remap(p, ids, CustomStages.build([fullPushup, catCow, squat]));
      expect(p.currentStage, 1);
      expect([p.currentReps, p.currentSets, p.currentRestSec], [14, 2, 30]);
      expect(p.isChallengeUnlocked, isTrue);
    });

    test('their exercise became the last stage: no challenge left', () {
      final p = onStage(1);
      CustomStages.remap(p, ids, CustomStages.build([catCow, squat]));
      expect(p.currentStage, 2);
      expect(p.isChallengeUnlocked, isFalse);
    });

    test('their exercise was removed: the stage in its place, from its start', () {
      final p = onStage(2);
      final stages = CustomStages.build([squat, calfRaise, catCow]);
      CustomStages.remap(p, ids, stages);
      expect(p.currentStage, 2);
      expect(p.currentReps, stages[1].startReps);
      expect(p.currentSets, stages[1].startSets);
      expect(p.currentRestSec, stages[1].startRestSec);
      expect(p.isChallengeUnlocked, isFalse);
    });

    test('the list got shorter than the stage: the last one', () {
      final p = onStage(3);
      CustomStages.remap(p, ids, CustomStages.build([squat]));
      expect(p.currentStage, 1);
      expect(p.currentReps, squat.startReps);
    });

    test('an empty list changes nothing', () {
      final p = onStage(2);
      CustomStages.remap(p, ids, const <Exercise>[]);
      expect(p.currentStage, 2);
    });
  });
}
