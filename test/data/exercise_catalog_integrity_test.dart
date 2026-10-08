import 'dart:convert';
import 'dart:io';

import 'package:caliday/core/extensions/exercise_l10n.dart';
import 'package:caliday/data/models/enums.dart';
import 'package:caliday/data/static/exercise_catalog.dart';
import 'package:caliday/data/static/exercise_tags_catalog.dart';
import 'package:caliday/data/static/supplementary_exercise_catalog.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/all_translations.dart';

/// Data-integrity checks for the static exercise catalogs. They cost nothing
/// at runtime and catch the mistakes that otherwise only show up as a missing
/// animation, an untranslated name or a progression stage that never ends.
void main() {
  final library = ExerciseCatalog.libraryAll;
  final supplementary = SupplementaryExerciseCatalog.all;
  final everything = [...library, ...supplementary];

  group('identity', () {
    test('ids are unique across progressions, warm-ups, cool-downs and supplementary',
        () {
      final seen = <String>{};
      final duplicates = [
        for (final e in everything)
          if (!seen.add(e.id)) e.id,
      ];
      expect(duplicates, isEmpty);
    });

    test('ExerciseCatalog.byId finds every exercise of `all`', () {
      for (final e in ExerciseCatalog.all) {
        expect(ExerciseCatalog.byId(e.id), same(e), reason: e.id);
      }
      expect(ExerciseCatalog.byId('no_such_exercise'), isNull);
    });
  });

  group('progressions', () {
    for (final branch in BranchId.values) {
      test('${branch.name}: stages are 1..${branch.stageCount} in order, all of this branch',
          () {
        final stages = ExerciseCatalog.progressionFor(branch);
        expect(stages.map((e) => e.stage),
            List.generate(branch.stageCount, (i) => i + 1));
        for (final e in stages) {
          expect(e.branch, branch, reason: e.id);
          expect(ExerciseCatalog.forStage(branch, e.stage), same(e));
        }
        expect(ExerciseCatalog.forStage(branch, 0), isNull);
        expect(ExerciseCatalog.forStage(branch, branch.stageCount + 1), isNull);
      });
    }

    test('every branch has a warm-up and at least one cool-down', () {
      for (final branch in BranchId.values) {
        final warmup = ExerciseCatalog.warmupFor(branch);
        expect(warmup, isNotNull, reason: branch.name);
        expect(warmup!.stage, 0, reason: branch.name);
        final cooldowns = ExerciseCatalog.cooldownsFor(branch);
        expect(cooldowns, isNotEmpty, reason: branch.name);
        for (final c in cooldowns) {
          expect(c.stage, 0, reason: c.id);
        }
      }
    });
  });

  group('numbers make sense', () {
    final staged = [
      for (final b in BranchId.values) ...ExerciseCatalog.progressionFor(b),
    ];

    for (final e in staged) {
      test(e.id, () {
        expect(e.startReps, greaterThan(0));
        expect(e.startReps, lessThanOrEqualTo(e.targetReps),
            reason: 'start must not exceed target or the reps phase is skipped');
        expect(e.startSets, greaterThanOrEqualTo(1));
        expect(e.startSets, lessThanOrEqualTo(e.targetSets));
        expect(e.startRestSec, greaterThanOrEqualTo(e.targetRestSec));
        expect(e.targetRestSec, greaterThanOrEqualTo(0));
        expect(e.spBase, greaterThan(0), reason: 'a staged exercise must earn SP');
        // challengeTargetReps is the norm for ENTERING a stage through the
        // Challenge (the generator and _finishWorkout read it from the next
        // stage); stage 1 is never entered that way. With 0 any result passes.
        if (e.stage >= 2) {
          expect(e.challengeTargetReps, greaterThan(0),
              reason: 'entering this stage through the Challenge needs a norm');
        }
      });
    }

    test('only timed holds are done on each side', () {
      for (final e in everything.where((e) => e.perSide)) {
        expect(e.type, ExerciseType.timed, reason: e.id);
        expect(e.holdsPerSet, 2, reason: e.id);
      }
      expect(everything.where((e) => e.perSide), isNotEmpty);
    });

    test('warm-ups and cool-downs earn no SP and need no rest', () {
      for (final e in [...ExerciseCatalog.warmups, ...ExerciseCatalog.cooldowns]) {
        expect(e.stage, 0, reason: e.id);
        expect(e.startSets, 1, reason: e.id);
      }
    });
  });

  group('animations', () {
    final withAnimation = everything.where((e) => e.animationPath != null).toList();

    test('there are animations to check', () {
      expect(withAnimation, isNotEmpty);
    });

    for (final e in withAnimation) {
      test('${e.id} → ${e.animationPath}', () {
        final file = File(e.animationPath!);
        expect(file.existsSync(), isTrue, reason: 'missing ${e.animationPath}');

        final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
        expect(json['layers'], isA<List<dynamic>>());
        expect((json['layers'] as List).isNotEmpty, isTrue);
        expect(json['fr'], isA<num>());
        expect(json['fr'] as num, greaterThan(0));
        expect(json['op'] as num, greaterThan(json['ip'] as num),
            reason: 'out point must come after the in point');
        expect(json['w'] as num, greaterThan(0));
        expect(json['h'] as num, greaterThan(0));
      });
    }

    test('every animation file in assets/ belongs to an exercise (no orphans)',
        () {
      final referenced = {
        for (final e in everything)
          if (e.animationPath != null) e.animationPath!,
      };
      final onDisk = Directory('assets/animations')
          .listSync()
          .whereType<File>()
          .where((f) => f.path.endsWith('.json'))
          .map((f) => f.path.replaceAll(r'\', '/'))
          .toSet();
      expect(onDisk.difference(referenced), isEmpty);
    });

    test('pubspec registers the animations folder as an asset', () {
      expect(File('pubspec.yaml').readAsStringSync(),
          contains('- assets/animations/'));
    });
  });

  group('translations', () {
    // ExerciseL10n falls back to the raw id, so a missing translation shows up
    // in the UI as "push_s7_handstand_pushup".
    for (final e in everything) {
      test('${e.id} has a name and a description in every language', () {
        for (final l10n in allTranslations) {
          final locale = l10n.localeName;
          expect(ExerciseL10n.name(l10n, e.id), isNot(e.id),
              reason: '$locale name');
          expect(ExerciseL10n.name(l10n, e.id).trim(), isNotEmpty);
          expect(ExerciseL10n.description(l10n, e.id), isNotEmpty,
              reason: '$locale description');
          if (e.techniqueTip != null) {
            expect(ExerciseL10n.tip(l10n, e.id), isNotNull,
                reason: '$locale technique tip');
          }
        }
      });
    }
  });

  group('tags', () {
    test('every library and supplementary exercise is tagged', () {
      final untagged = [
        for (final e in everything)
          if (ExerciseTagsCatalog.forId(e.id).isEmpty) e.id,
      ];
      expect(untagged, isEmpty);
    });

    test('warm-up and cool-down tags mark exactly the stage-0 exercises', () {
      for (final e in everything) {
        final tags = ExerciseTagsCatalog.forId(e.id);
        if (ExerciseCatalog.warmups.contains(e)) {
          expect(tags, contains(ExerciseTag.warmup), reason: e.id);
        }
        if (ExerciseCatalog.cooldowns.contains(e)) {
          expect(tags, contains(ExerciseTag.cooldown), reason: e.id);
        }
        if (e.stage > 0) {
          expect(tags, isNot(contains(ExerciseTag.warmup)), reason: e.id);
          expect(tags, isNot(contains(ExerciseTag.cooldown)), reason: e.id);
        }
      }
    });

    test('the requiresBar tag agrees with requiresEquipment', () {
      for (final e in everything) {
        expect(ExerciseTagsCatalog.forId(e.id).contains(ExerciseTag.requiresBar),
            e.requiresEquipment,
            reason: e.id);
      }
    });
  });
}
