import 'package:caliday/data/models/enums.dart';
import 'package:caliday/data/static/course_catalog.dart';
import 'package:caliday/data/static/exercise_catalog.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Rank', () {
    test('fromSP picks the highest rank whose threshold is reached', () {
      const expected = {
        0: Rank.beginner,
        499: Rank.beginner,
        500: Rank.amateur,
        1999: Rank.amateur,
        2000: Rank.sportsman,
        4999: Rank.sportsman,
        5000: Rank.athlete,
        14999: Rank.athlete,
        15000: Rank.master,
        49999: Rank.master,
        50000: Rank.legend,
        1000000: Rank.legend,
      };
      expected.forEach((sp, rank) {
        expect(RankExtension.fromSP(sp), rank, reason: '$sp SP');
      });
    });

    test('thresholds strictly increase with the rank', () {
      for (var i = 1; i < Rank.values.length; i++) {
        expect(Rank.values[i].spThreshold,
            greaterThan(Rank.values[i - 1].spThreshold));
      }
      expect(Rank.beginner.spThreshold, 0);
    });

    test('next walks up the ladder and ends at the top', () {
      expect(Rank.beginner.next, Rank.amateur);
      expect(Rank.master.next, Rank.legend);
      expect(Rank.legend.next, isNull);
    });

    test('every rank has a display name', () {
      for (final rank in Rank.values) {
        expect(rank.displayName, isNotEmpty);
      }
    });
  });

  group('BranchId', () {
    test('stageCount matches the number of stages in the exercise catalog', () {
      for (final branch in BranchId.values) {
        expect(ExerciseCatalog.progressionFor(branch), hasLength(branch.stageCount),
            reason: branch.name);
      }
    });

    test('Hive indices of the enums are frozen', () {
      // Changing the order would corrupt every stored profile / progress.
      expect(BranchId.values.map((b) => b.name), [
        'push', 'core', 'pull', 'legs', 'balance', 'flex', 'posture', 'neck',
      ]);
      expect(Rank.values.map((r) => r.name), [
        'beginner', 'amateur', 'sportsman', 'athlete', 'master', 'legend',
      ]);
      expect(CourseId.values.map((c) => c.name), ['calisthenics', 'healthyBody']);
      expect(ExerciseType.values.map((t) => t.name), ['reps', 'timed']);
      expect(SetType.values.map((t) => t.name), ['daily', 'skill', 'challenge']);
    });
  });

  group('CourseCatalog', () {
    test('calisthenics and healthy body share only the flex branch', () {
      final cali = CourseCatalog.branchesFor(CourseId.calisthenics);
      final healthy = CourseCatalog.branchesFor(CourseId.healthyBody);
      expect(cali, [
        BranchId.push, BranchId.pull, BranchId.core,
        BranchId.legs, BranchId.balance, BranchId.flex,
      ]);
      expect(healthy, [BranchId.posture, BranchId.neck, BranchId.flex]);
      expect(cali.toSet().intersection(healthy.toSet()), {BranchId.flex});
    });

    test('every branch belongs to at least one course', () {
      final covered = {
        for (final c in CourseId.values) ...CourseCatalog.branchesFor(c),
      };
      expect(covered, BranchId.values.toSet());
    });
  });
}
