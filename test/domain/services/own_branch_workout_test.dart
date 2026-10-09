import 'package:caliday/data/models/custom_branch.dart';
import 'package:caliday/data/models/enums.dart';
import 'package:caliday/data/models/exercise_result.dart';
import 'package:caliday/data/models/skill_progress.dart';
import 'package:caliday/data/repositories/skill_progress_repository.dart';
import 'package:caliday/data/static/exercise_catalog.dart';
import 'package:caliday/data/static/supplementary_exercise_catalog.dart';
import 'package:caliday/domain/models/branch.dart';
import 'package:caliday/domain/models/workout_plan.dart';
import 'package:caliday/domain/services/achievement_service.dart';
import 'package:caliday/domain/services/workout_generator_service.dart';
import 'package:caliday/domain/services/workout_progression.dart';
import 'package:flutter_test/flutter_test.dart';

/// Progress without Hive: what a test put in, else the start of stage 1.
class _Progress extends SkillProgressRepository {
  final Map<String, SkillProgress> stored = {};

  @override
  SkillProgress progressFor(Branch branch) => stored[branch.key] ??=
      switch (branch) {
        BuiltInBranch(:final id) => SkillProgress(
            branchId: id,
            currentReps: branch.stage(1)!.startReps,
            currentSets: 1,
            currentRestSec: 30,
          ),
        OwnBranch(:final data) => SkillProgress(
            customBranchId: data.id,
            currentReps: branch.stage(1)!.startReps,
            currentSets: branch.stage(1)!.startSets,
            currentRestSec: branch.stage(1)!.startRestSec,
          ),
      };
}

final _data = CustomBranch(
  id: 'b1',
  name: 'Mine',
  exerciseIds: ['legs_s1_squat', 'push_s3_full_pushup', 'warmup_arm_rotations'],
  createdAt: DateTime(2026, 10, 9),
);
final _own = OwnBranch(_data);

ExerciseResult _done(PlannedExercise p) => p.exercise.type == ExerciseType.timed
    ? ExerciseResult(
        exerciseId: p.exercise.id,
        targetReps: p.targetAmount,
        completedReps: 0,
        actualDurationSec: p.targetAmount)
    : ExerciseResult(
        exerciseId: p.exercise.id,
        targetReps: p.targetAmount,
        completedReps: p.targetAmount);

void main() {
  final day = DateTime(2026, 10, 9, 18);

  group('the daily plan with an own branch', () {
    test('its stage at the stored progress, tagged with the branch key', () {
      final repo = _Progress();
      repo.stored[_own.key] = SkillProgress(
          customBranchId: 'b1', currentStage: 2, currentReps: 7, currentSets: 2, currentRestSec: 45);
      final plan = WorkoutGeneratorService(repo)
          .generateDailyFor(branches: [_own], dayIndexOverride: 0);
      final main = plan.exercises.where((e) => e.exercise.stage > 0).single;
      expect(main.exercise.id, 'push_s3_full_pushup');
      expect(main.exercise.stage, 2);
      expect([main.targetAmount, main.sets, main.restSec], [7, 2, 45]);
      expect(main.branchKey, 'custom_b1');
      expect(plan.exercises.first.exercise, ExerciseCatalog.warmupFor(BranchId.push),
          reason: 'the warm-up of the stage exercise\'s branch');
    });

    test('a stage that is a warm-up is not added a second time', () {
      final repo = _Progress();
      repo.stored[_own.key] = SkillProgress(
          customBranchId: 'b1', currentStage: 3, currentReps: 10, currentSets: 1, currentRestSec: 30);
      final plan = WorkoutGeneratorService(repo)
          .generateDailyFor(branches: [_own], dayIndexOverride: 0);
      expect(plan.exercises.where((e) => e.exercise.id == 'warmup_arm_rotations'),
          hasLength(1));
      expect(plan.exercises.where((e) => e.exercise.stage > 0).single.exercise.id,
          'warmup_arm_rotations');
    });

    test('mixed with built-in branches, each keeps its own key', () {
      final plan = WorkoutGeneratorService(_Progress()).generateDailyFor(
        branches: [const BuiltInBranch(BranchId.push), _own],
        preferredMinutes: 15,
        dayIndexOverride: 0,
      );
      final main = plan.exercises.where((e) => e.exercise.stage > 0).toList();
      expect(main.map((e) => e.branchKey), ['push', 'custom_b1']);
      expect(main.map((e) => e.exercise.id), ['push_s1_wall_pushup', 'legs_s1_squat']);
    });

    test('a bonus workout adds the supplementary pair, unless the course says no',
        () {
      final supp = SupplementaryExerciseCatalog.all.map((e) => e.id).toSet();
      final gen = WorkoutGeneratorService(_Progress());
      final bonus = gen.generateDailyFor(
          branches: [_own], isPrimary: false, dayIndexOverride: 0);
      expect(bonus.exercises.where((e) => supp.contains(e.exercise.id)), hasLength(2));
      final calm = gen.generateDailyFor(
          branches: [_own], isPrimary: false, addsSupplementary: false, dayIndexOverride: 0);
      expect(calm.exercises.where((e) => supp.contains(e.exercise.id)), isEmpty);
    });

    test('the challenge: the current stage light, the next one at its norm', () {
      final repo = _Progress();
      repo.stored[_own.key] = SkillProgress(
          customBranchId: 'b1', currentStage: 1, currentReps: 20, currentSets: 3,
          currentRestSec: 20, isChallengeUnlocked: true);
      final plan = WorkoutGeneratorService(repo).generateChallengeFor(_own);
      expect(plan.setType, SetType.challenge);
      final main = plan.exercises.where((e) => e.exercise.stage > 0).toList();
      expect(main.map((e) => e.exercise.id), ['legs_s1_squat', 'push_s3_full_pushup']);
      expect(main.last.targetAmount, ExerciseCatalog.pushS3FullPushup.challengeTargetReps);
      expect(main.map((e) => e.branchKey).toSet(), {'custom_b1'});
    });
  });

  group('WorkoutProgression: what a finished workout moves', () {
    test('an own stage moves the own branch, not the exercise\'s built-in one', () {
      final repo = _Progress();
      final plan = WorkoutGeneratorService(repo).generateDailyFor(
          branches: [_own], dayIndexOverride: 0);
      final out = WorkoutProgression.apply(
        plan: plan,
        results: plan.exercises.map(_done).toList(),
        ownBranches: [_data],
        progressFor: repo.progressFor,
        now: day,
      );
      final own = repo.stored[_own.key]!;
      expect(own.currentReps, ExerciseCatalog.legsS1Squat.startReps + 2);
      expect(own.lastProgressedOn, day);
      expect(repo.stored.containsKey('legs'), isFalse,
          reason: 'built-in Legs was not trained');
      expect(out.touched, [own]);
      expect(out.challengeUnlocked, isFalse);
    });

    test('the last stage of an own branch unlocks no challenge', () {
      final repo = _Progress();
      final last = _own.stage(3)!;
      repo.stored[_own.key] = SkillProgress(
        customBranchId: 'b1',
        currentStage: 3,
        currentReps: last.targetReps,
        currentSets: last.targetSets,
        currentRestSec: last.targetRestSec,
      );
      final plan = WorkoutGeneratorService(repo).generateDailyFor(
          branches: [_own], dayIndexOverride: 0);
      final out = WorkoutProgression.apply(
        plan: plan,
        results: plan.exercises.map(_done).toList(),
        ownBranches: [_data],
        progressFor: repo.progressFor,
        now: day,
      );
      expect(out.challengeUnlocked, isFalse);
      expect(repo.stored[_own.key]!.isChallengeUnlocked, isFalse);
    });

    test('a stage at its targets before the last one unlocks the challenge', () {
      final repo = _Progress();
      final first = _own.stage(1)!;
      repo.stored[_own.key] = SkillProgress(
        customBranchId: 'b1',
        currentReps: first.targetReps,
        currentSets: first.targetSets,
        currentRestSec: first.targetRestSec,
      );
      final plan = WorkoutGeneratorService(repo).generateDailyFor(
          branches: [_own], dayIndexOverride: 0);
      final out = WorkoutProgression.apply(
        plan: plan,
        results: plan.exercises.map(_done).toList(),
        ownBranches: [_data],
        progressFor: repo.progressFor,
        now: day,
      );
      expect(out.challengeUnlocked, isTrue);
    });

    test('passing the own challenge enters the next own stage', () {
      final repo = _Progress();
      repo.stored[_own.key] = SkillProgress(
          customBranchId: 'b1', currentReps: 20, currentSets: 3, currentRestSec: 20,
          isChallengeUnlocked: true);
      final plan = WorkoutGeneratorService(repo).generateChallengeFor(_own);
      final out = WorkoutProgression.apply(
        plan: plan,
        results: plan.exercises.map(_done).toList(),
        ownBranches: [_data],
        progressFor: repo.progressFor,
        now: day,
      );
      final p = repo.stored[_own.key]!;
      expect(out.challengePassed, isTrue);
      expect(out.advancedBranch, _own);
      expect(out.advancedToStage, 2);
      expect(out.newStageExerciseId, 'push_s3_full_pushup');
      expect([p.currentStage, p.currentReps, p.isChallengeUnlocked],
          [2, ExerciseCatalog.pushS3FullPushup.startReps, false]);
      expect(repo.stored.containsKey('push'), isFalse);
      expect(out.touched, hasLength(1), reason: 'one record for both exercises');
    });

    test('an own branch deleted during the workout is skipped', () {
      final repo = _Progress();
      final plan = WorkoutGeneratorService(repo).generateDailyFor(
          branches: [_own], dayIndexOverride: 0);
      repo.stored.clear();
      final out = WorkoutProgression.apply(
        plan: plan,
        results: plan.exercises.map(_done).toList(),
        ownBranches: const [],
        progressFor: repo.progressFor,
        now: day,
      );
      expect(out.touched, isEmpty);
    });

    test('a custom routine (no keys) moves the built-in branches as before', () {
      final repo = _Progress();
      final plan = WorkoutGeneratorService(repo).fromExerciseIds(['push_s1_wall_pushup']);
      WorkoutProgression.apply(
        plan: plan,
        results: plan.exercises.map(_done).toList(),
        ownBranches: const [],
        progressFor: repo.progressFor,
        now: day,
      );
      expect(repo.stored['push']!.lastProgressedOn, day);
    });
  });

  test('a stage of an own branch earns only the first challenge', () {
    const service = AchievementService();
    final earned = <String>{};
    expect(service.checkAfterOwnStageAdvance(alreadyEarned: earned), ['first_challenge']);
    expect(service.checkAfterOwnStageAdvance(alreadyEarned: earned), isEmpty);
    expect(earned, {'first_challenge'});
  });
}
