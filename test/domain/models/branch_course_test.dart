import 'package:caliday/data/models/custom_branch.dart';
import 'package:caliday/data/models/custom_course.dart';
import 'package:caliday/data/models/enums.dart';
import 'package:caliday/data/models/user_profile.dart';
import 'package:caliday/data/static/course_catalog.dart';
import 'package:caliday/data/static/exercise_catalog.dart';
import 'package:caliday/domain/models/branch.dart';
import 'package:caliday/domain/models/course.dart';
import 'package:flutter_test/flutter_test.dart';

CustomBranch _own(String id, List<String> exerciseIds) => CustomBranch(
      id: id,
      name: 'Mine $id',
      exerciseIds: exerciseIds,
      createdAt: DateTime(2026, 10, 9),
    );

CustomCourse _course(List<String> keys, {int host = 0}) => CustomCourse(
      id: 'c1',
      name: 'My course',
      branchKeys: keys,
      hostIndex: host,
      createdAt: DateTime(2026, 10, 9),
    );

void main() {
  group('Branch', () {
    test('a built-in branch is the catalog branch, keyed by its name', () {
      for (final id in BranchId.values) {
        final b = BuiltInBranch(id);
        expect(b.key, id.name);
        expect(b.stageCount, id.stageCount);
        expect(b.stages, ExerciseCatalog.progressionFor(id));
        for (var n = 1; n <= id.stageCount; n++) {
          expect(b.stage(n), ExerciseCatalog.forStage(id, n));
          expect(b.warmupAt(n), ExerciseCatalog.warmupFor(id));
          expect(b.cooldownsAt(n), ExerciseCatalog.cooldownsFor(id));
        }
      }
      expect(const BuiltInBranch(BranchId.pull).requiresEquipment, isTrue);
      expect(const BuiltInBranch(BranchId.core).equipmentFreeStage(4),
          ExerciseCatalog.coreS4FlutterKicks);
    });

    test('an own branch: its exercises in its order, keyed apart', () {
      final b = OwnBranch(_own('x1', [
        'legs_s1_squat',
        'push_s3_full_pushup',
        'supp_bird_dog',
      ]));
      expect(b.key, 'custom_x1');
      expect(b.key, CustomBranch.keyFor('x1'));
      expect(b.stageCount, 3);
      expect(b.stage(1)!.id, 'legs_s1_squat');
      expect(b.stage(3)!.id, 'supp_bird_dog');
      expect(b.stage(3)!.stage, 3);
      expect(b.stage(0), isNull);
      expect(b.stage(4), isNull);
      expect(b.requiresEquipment, isFalse);
    });

    test('its warm-up and cool-downs follow the exercise of the stage', () {
      final b = OwnBranch(_own('x1', ['legs_s1_squat', 'push_s3_full_pushup']));
      expect(b.warmupAt(1), ExerciseCatalog.warmupFor(BranchId.legs));
      expect(b.warmupAt(2), ExerciseCatalog.warmupFor(BranchId.push));
      expect(b.cooldownsAt(2), ExerciseCatalog.cooldownsFor(BranchId.push));
      expect(b.warmupAt(5), isNull);
      expect(b.cooldownsAt(5), isEmpty);
    });

    test('an exercise that left the catalog is skipped', () {
      final b = OwnBranch(_own('x1', ['legs_s1_squat', 'gone_s9_nothing']));
      expect(b.stages.map((e) => e.id), ['legs_s1_squat']);
    });

    test('resolve: built-in by name, own by key, null when gone', () {
      final own = [_own('x1', ['legs_s1_squat'])];
      expect(Branch.resolve('flex', own), const BuiltInBranch(BranchId.flex));
      expect(Branch.resolve('custom_x1', own), isA<OwnBranch>());
      expect(Branch.resolve('custom_x2', own), isNull);
      expect(Branch.resolve('nothing', own), isNull);
    });

    test('equal by key, so a rebuilt branch is the same map key', () {
      final data = _own('x1', ['legs_s1_squat']);
      expect(OwnBranch(data), OwnBranch(data));
      expect({OwnBranch(data): 1}[OwnBranch(data)], 1);
      expect(const BuiltInBranch(BranchId.push) == OwnBranch(data), isFalse);
    });

    test('no built-in branch name looks like an own key', () {
      for (final id in BranchId.values) {
        expect(id.name.startsWith(CustomBranch.keyPrefix), isFalse);
      }
    });
  });

  group('Course', () {
    test('a built-in course is its catalog branches, filtered like the profile', () {
      for (final id in CourseId.values) {
        final c = BuiltInCourse(id);
        expect(c.key, id.name);
        expect(c.host, id);
        expect(c.builtIn, id);
        expect(c.addsSupplementary, CourseCatalog.addsSupplementary(id));
        for (final bar in [true, false]) {
          expect(
            c.branchesFor(hasPullUpBar: bar).map((b) => (b as BuiltInBranch).id),
            UserProfile(hasPullUpBar: bar).branchesForCourse(id),
          );
        }
      }
    });

    test('an own course: built-in and own branches in its order', () {
      final own = [_own('x1', ['legs_s1_squat'])];
      final c = OwnCourse(_course(['custom_x1', 'pull', 'flex'], host: 4), own);
      expect(c.key, 'custom_c1');
      expect(c.host, CourseId.yoga);
      expect(c.builtIn, isNull);
      expect(c.addsSupplementary, isTrue);
      expect(c.allBranches.map((b) => b.key), ['custom_x1', 'pull', 'flex']);
      expect(c.branchesFor(hasPullUpBar: false).map((b) => b.key),
          ['custom_x1', 'flex'],
          reason: 'Pull needs the bar, in an own course too');
    });

    test('a deleted branch drops out; an unknown host is Goro', () {
      final c = OwnCourse(_course(['custom_gone', 'push'], host: 99), const []);
      expect(c.allBranches.map((b) => b.key), ['push']);
      expect(c.host, CourseId.calisthenics);
    });

    test('equal by key', () {
      final data = _course(['push']);
      expect(OwnCourse(data, const []), OwnCourse(data, const []));
      expect(const BuiltInCourse(CourseId.yoga), const BuiltInCourse(CourseId.yoga));
      expect(const BuiltInCourse(CourseId.yoga) == OwnCourse(data, const []), isFalse);
    });
  });
}
