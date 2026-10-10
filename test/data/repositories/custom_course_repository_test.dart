import 'package:caliday/data/models/custom_branch.dart';
import 'package:caliday/data/models/custom_course.dart';
import 'package:caliday/data/models/enums.dart';
import 'package:caliday/data/models/skill_progress.dart';
import 'package:caliday/data/models/user_profile.dart';
import 'package:caliday/data/repositories/custom_course_repository.dart';
import 'package:caliday/data/repositories/skill_progress_repository.dart';
import 'package:caliday/data/repositories/user_repository.dart';
import 'package:caliday/domain/models/branch.dart';
import 'package:caliday/domain/models/course.dart';
import 'package:caliday/features/home/providers/home_provider.dart';
import 'package:caliday/features/workout/providers/workout_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/hive_test_env.dart';

CustomBranch _branch(String id, List<String> exerciseIds, {int minute = 0}) =>
    CustomBranch(
      id: id,
      name: 'Branch $id',
      exerciseIds: exerciseIds,
      createdAt: DateTime(2026, 10, 9, 12, minute),
    );

CustomCourse _course(String id, List<String> keys, {int minute = 0}) =>
    CustomCourse(
      id: id,
      name: 'Course $id',
      branchKeys: keys,
      hostIndex: CourseId.morningRoutine.index,
      createdAt: DateTime(2026, 10, 9, 12, minute),
    );

void main() {
  late HiveTestEnv env;
  setUp(() async => env = await HiveTestEnv.open());
  tearDown(() => env.dispose());

  test('own branches and courses go through their adapters, oldest first', () async {
    await CustomBranchRepository().save(_branch('b2', ['supp_bird_dog'], minute: 2));
    await CustomBranchRepository().save(_branch('b1', ['legs_s1_squat', 'push_s3_full_pushup']));
    await CustomCourseRepository().save(_course('c1', ['custom_b1', 'flex']));
    await env.reopen();

    final branches = CustomBranchRepository().getAll();
    expect(branches.map((b) => b.id), ['b1', 'b2']);
    expect(branches.first.exerciseIds, ['legs_s1_squat', 'push_s3_full_pushup']);
    final course = CustomCourseRepository().getAll().single;
    expect(course.branchKeys, ['custom_b1', 'flex']);
    expect(course.hostIndex, CourseId.morningRoutine.index);
    expect(course.shown, isTrue);

    await CustomCourseRepository().save(course..shown = false);
    await env.reopen();
    expect(CustomCourseRepository().getAll().single.shown, isFalse);
  });

  group('progress of an own branch', () {
    final own = OwnBranch(_branch('b1', ['legs_s1_squat', 'push_s3_full_pushup']));

    test('starts at stage 1 with its derived start values, without a branchId', () {
      final p = SkillProgressRepository().progressFor(own);
      final first = own.stage(1)!;
      expect(p.branchId, isNull);
      expect(p.customBranchId, 'b1');
      expect(p.branchKey, 'custom_b1');
      expect([p.currentStage, p.currentReps, p.currentSets, p.currentRestSec],
          [1, first.startReps, first.startSets, first.startRestSec]);
      expect(SkillProgressRepository().hasStored(own.key), isFalse);
    });

    test('is stored under its key, beside the built-in Legs it does not touch',
        () async {
      final repo = SkillProgressRepository();
      await repo.saveProgress(repo.progressFor(own)
        ..currentStage = 2
        ..currentReps = 9);
      await env.reopen();
      final again = SkillProgressRepository();
      final p = again.progressFor(own);
      expect([p.currentStage, p.currentReps, p.customBranchId], [2, 9, 'b1']);
      expect(again.hasProgress(BranchId.legs), isFalse);
      expect(again.hasProgress(BranchId.push), isFalse);
    });

    test('the start-up migrations leave it alone', () async {
      final repo = SkillProgressRepository();
      await repo.saveProgress(repo.progressFor(own)..currentReps = 999);
      await repo.runMigrations();
      expect(repo.progressFor(own).currentReps, 999,
          reason: 'capping by the catalog stage is for built-in branches');
    });
  });

  group('deleting', () {
    late ProviderContainer container;
    setUp(() async {
      await CustomBranchRepository().save(_branch('b1', ['legs_s1_squat']));
      await CustomCourseRepository().save(_course('c1', ['custom_b1', 'push']));
      await CustomCourseRepository().save(_course('c2', ['custom_b1'], minute: 1));
      final repo = SkillProgressRepository();
      await repo.saveProgress(SkillProgress(customBranchId: 'b1', currentStage: 1));
      container = ProviderContainer();
      addTearDown(container.dispose);
    });

    test('a branch leaves every course and takes its progress with it', () async {
      await container.read(customBranchesProvider.notifier).delete('b1');
      expect(container.read(customBranchesProvider), isEmpty);
      final courses = container.read(customCoursesProvider);
      expect(courses.map((c) => c.branchKeys), [
        ['push'],
        <String>[],
      ]);
      expect(SkillProgressRepository().hasStored('custom_b1'), isFalse);
    });

    test('a course keeps its branches and their progress', () async {
      await container.read(customCoursesProvider.notifier).delete('c1');
      expect(container.read(customCoursesProvider).map((c) => c.id), ['c2']);
      expect(container.read(customBranchesProvider), hasLength(1));
      expect(SkillProgressRepository().hasStored('custom_b1'), isTrue);
    });
  });

  group('the active course', () {
    setUp(() async {
      await UserRepository().saveProfile(UserProfile(
        activeCourseIds: [CourseId.calisthenics.index, CourseId.yoga.index],
        activeCourseIndex: 1,
      ));
      await CustomBranchRepository().save(_branch('b1', ['legs_s1_squat']));
      await CustomCourseRepository().save(_course('c1', ['custom_b1', 'flex']));
    });

    test('the pills: enrolled built-in courses, then the own ones', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      expect(container.read(enrolledCoursesProvider).map((c) => c.key),
          ['calisthenics', 'yoga', 'custom_c1']);
    });

    test('picking an own course is remembered, and Home trains its branches', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      expect(container.read(activeCourseProvider), const BuiltInCourse(CourseId.yoga));
      final own = container.read(enrolledCoursesProvider).last;
      container.read(activeCourseProvider.notifier).select(own);
      expect(UserRepository().getProfile().activeCustomCourseId, 'c1');

      final fresh = ProviderContainer();
      addTearDown(fresh.dispose);
      expect(fresh.read(activeCourseProvider), own);
      fresh.listen(todayPlanProvider, (_, _) {});
      final keys = {
        for (final e in fresh.read(todayPlanProvider).exercises)
          if (e.exercise.stage > 0) e.branchKey,
      };
      expect(keys, {'custom_b1', 'flex'});
    });

    test('picking a built-in course again forgets the own one', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier = container.read(activeCourseProvider.notifier);
      notifier.select(container.read(enrolledCoursesProvider).last);
      notifier.select(const BuiltInCourse(CourseId.calisthenics));
      final profile = UserRepository().getProfile();
      expect(profile.activeCustomCourseId, isNull);
      expect(profile.activeCourse, CourseId.calisthenics);
    });

    test('an edited own course is shown with its new branches', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container.listen(activeCourseProvider, (_, _) {});
      container
          .read(activeCourseProvider.notifier)
          .select(container.read(enrolledCoursesProvider).last);
      final data = container.read(customCoursesProvider).single;
      await container
          .read(customCoursesProvider.notifier)
          .save(data..branchKeys = ['push']);
      expect(container.read(activeCourseProvider).allBranches.map((b) => b.key),
          ['push']);
    });

    test('a hidden own course loses its pill and stops being the active one',
        () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container.listen(activeCourseProvider, (_, _) {});
      container.listen(enrolledCoursesProvider, (_, _) {});
      container
          .read(activeCourseProvider.notifier)
          .select(container.read(enrolledCoursesProvider).last);
      final data = container.read(customCoursesProvider).single;
      await container
          .read(customCoursesProvider.notifier)
          .save(data..shown = false);
      expect(container.read(enrolledCoursesProvider).map((c) => c.key),
          ['calisthenics', 'yoga']);
      expect(container.read(activeCourseProvider), const BuiltInCourse(CourseId.yoga));
    });

    test('a deleted own course falls back to the built-in one', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container.listen(activeCourseProvider, (_, _) {});
      container
          .read(activeCourseProvider.notifier)
          .select(container.read(enrolledCoursesProvider).last);
      await container.read(customCoursesProvider.notifier).delete('c1');
      expect(container.read(activeCourseProvider), const BuiltInCourse(CourseId.yoga));
    });
  });
}
