import 'package:caliday/data/models/enums.dart';
import 'package:caliday/data/models/skill_progress.dart';
import 'package:caliday/data/repositories/skill_progress_repository.dart';
import 'package:caliday/data/static/exercise_catalog.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive_ce.dart';

import '../../helpers/hive_test_env.dart';

void main() {
  late HiveTestEnv env;
  late SkillProgressRepository repo;

  setUp(() async {
    env = await HiveTestEnv.open();
    repo = SkillProgressRepository();
  });
  tearDown(() => env.dispose());

  group('defaults for a branch that was never trained', () {
    test('start at stage 1 with the Challenge locked', () {
      for (final branch in BranchId.values) {
        final p = repo.getProgress(branch);
        expect(p.branchId, branch);
        expect(p.currentStage, 1, reason: branch.name);
        expect(p.currentSets, 1, reason: branch.name);
        expect(p.isChallengeUnlocked, isFalse, reason: branch.name);
      }
    });

    test('match the starting values of the stage-1 exercise in the catalog', () {
      // Otherwise a new user starts with a different load than the catalog
      // says is the start of the stage (and regression / custom routines use
      // the catalog values).
      for (final branch in BranchId.values) {
        final p = repo.getProgress(branch);
        final first = ExerciseCatalog.forStage(branch, 1)!;
        expect(p.currentReps, first.startReps, reason: '${branch.name} reps');
        expect(p.currentSets, first.startSets, reason: '${branch.name} sets');
        expect(p.currentRestSec, first.startRestSec,
            reason: '${branch.name} rest');
      }
    });

    test('are not stored until saved', () {
      expect(repo.hasProgress(BranchId.push), isFalse);
      repo.getProgress(BranchId.push);
      expect(repo.hasProgress(BranchId.push), isFalse);
      expect(repo.getAll(), isEmpty);
    });
  });

  test('saved progress is returned instead of the default', () async {
    await repo.saveProgress(SkillProgress(
      branchId: BranchId.pull,
      currentStage: 3,
      currentReps: 9,
      currentSets: 2,
      currentRestSec: 75,
      isChallengeUnlocked: true,
    ));
    expect(repo.hasProgress(BranchId.pull), isTrue);
    expect(repo.hasProgress(BranchId.push), isFalse);

    await env.reopen();
    final p = SkillProgressRepository().getProgress(BranchId.pull);
    expect(p.currentStage, 3);
    expect(p.currentReps, 9);
    expect(p.currentSets, 2);
    expect(p.currentRestSec, 75);
    expect(p.isChallengeUnlocked, isTrue);
  });

  test('progress is stored per branch and shared by every course', () async {
    // Flex belongs to both courses but has a single record.
    await repo.saveProgress(SkillProgress(branchId: BranchId.flex, currentStage: 4));
    await repo.saveProgress(SkillProgress(branchId: BranchId.neck, currentStage: 2));
    expect(repo.getAll(), hasLength(2));
    expect(repo.getProgress(BranchId.flex).currentStage, 4);
    expect(repo.getProgress(BranchId.neck).currentStage, 2);
  });

  group('runMigrations (course-scoped keys back to bare branch keys)', () {
    Box<SkillProgress> box() => Hive.box<SkillProgress>('skill_progress');

    test('moves a course-scoped record to the bare key and removes the old one',
        () async {
      await box().put(
          'calisthenics_push',
          SkillProgress(branchId: BranchId.push, currentStage: 5));
      await repo.runMigrations();
      expect(box().containsKey('calisthenics_push'), isFalse);
      expect(repo.getProgress(BranchId.push).currentStage, 5);
    });

    test('never overwrites an existing bare-key record', () async {
      await box().put('push', SkillProgress(branchId: BranchId.push, currentStage: 6));
      await box().put(
          'calisthenics_push',
          SkillProgress(branchId: BranchId.push, currentStage: 2));
      await repo.runMigrations();
      expect(repo.getProgress(BranchId.push).currentStage, 6);
      expect(box().containsKey('calisthenics_push'), isFalse);
    });

    test('handles the other course prefix as well', () async {
      await box().put('healthyBody_posture',
          SkillProgress(branchId: BranchId.posture, currentStage: 3));
      await repo.runMigrations();
      expect(repo.getProgress(BranchId.posture).currentStage, 3);
    });

    test('is idempotent', () async {
      await box().put('calisthenics_core',
          SkillProgress(branchId: BranchId.core, currentStage: 4));
      await repo.runMigrations();
      await repo.runMigrations();
      expect(box().keys.toSet(), {'core'});
      expect(repo.getProgress(BranchId.core).currentStage, 4);
    });
  });
}
