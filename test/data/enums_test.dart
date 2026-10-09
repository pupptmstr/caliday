import 'package:caliday/data/models/enums.dart';
import 'package:caliday/data/static/course_catalog.dart';
import 'package:caliday/data/static/exercise_catalog.dart';
import 'package:caliday/l10n/app_localizations_en.dart';
import 'package:caliday/l10n/app_localizations_ru.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/all_translations.dart';

void main() {
  group('WorkoutSize', () {
    test('the stored codes stay 5 / 10 / 15: saved profiles rely on them', () {
      expect(WorkoutSize.short.code, 5);
      expect(WorkoutSize.standard.code, 10);
      expect(WorkoutSize.full.code, 15);
    });

    test('fromCode reads a stored value, also an unusual one', () {
      const expected = {
        0: WorkoutSize.short,
        5: WorkoutSize.short,
        6: WorkoutSize.standard,
        10: WorkoutSize.standard,
        14: WorkoutSize.standard,
        15: WorkoutSize.full,
        99: WorkoutSize.full,
      };
      expected.forEach((code, size) {
        expect(WorkoutSize.fromCode(code), size, reason: '$code');
      });
    });

    test('every size has its own name and description in every language', () {
      for (final l10n in allTranslations) {
        final names = WorkoutSize.values.map((s) => s.localizedName(l10n)).toList();
        final descriptions =
            WorkoutSize.values.map((s) => s.localizedDescription(l10n)).toList();
        expect(names.toSet(), hasLength(3), reason: l10n.localeName);
        expect(descriptions.toSet(), hasLength(3), reason: l10n.localeName);
        expect([...names, ...descriptions].every((t) => t.trim().isNotEmpty), isTrue);
      }
    });

    test('no name promises a duration', () {
      for (final l10n in allTranslations) {
        for (final size in WorkoutSize.values) {
          final text =
              '${size.localizedName(l10n)} ${size.localizedDescription(l10n)}';
          expect(RegExp(r'\d+\s*(min|мин)', caseSensitive: false).hasMatch(text),
              isFalse,
              reason: text);
        }
      }
    });
  });

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

    test('displayed names: the middle ranks differ between English and Russian',
        () {
      // The enum values follow the Russian names, so `sportsman` is "Athlete"
      // and `athlete` is "Champion" in English. Documented in ARCHITECTURE.md.
      final en = AppLocalizationsEn();
      final ru = AppLocalizationsRu();
      expect(Rank.values.map((r) => r.localizedName(en)),
          ['Beginner', 'Amateur', 'Athlete', 'Champion', 'Master', 'Legend']);
      expect(Rank.values.map((r) => r.localizedName(ru)),
          ['Новичок', 'Любитель', 'Спортсмен', 'Атлет', 'Мастер', 'Легенда']);
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
      // New values only ever go at the end.
      expect(BranchId.values.map((b) => b.name), [
        'push', 'core', 'pull', 'legs', 'balance', 'flex', 'posture', 'neck',
        'eveningBack', 'eveningHips', 'eveningFolds', 'eveningShoulders',
        'morningSpine', 'morningJoints', 'morningArms', 'morningEnergy',
        'yogaStanding', 'yogaOneLeg', 'yogaBackbends', 'yogaFlow',
      ]);
      expect(Rank.values.map((r) => r.name), [
        'beginner', 'amateur', 'sportsman', 'athlete', 'master', 'legend',
      ]);
      expect(CourseId.values.map((c) => c.name),
          ['calisthenics', 'healthyBody', 'eveningStretch', 'morningRoutine', 'yoga']);
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
