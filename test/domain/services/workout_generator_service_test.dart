import 'package:caliday/data/models/enums.dart';
import 'package:caliday/data/models/skill_progress.dart';
import 'package:caliday/data/repositories/skill_progress_repository.dart';
import 'package:caliday/data/static/course_catalog.dart';
import 'package:caliday/data/static/exercise_catalog.dart';
import 'package:caliday/data/static/supplementary_exercise_catalog.dart';
import 'package:caliday/domain/models/workout_plan.dart';
import 'package:caliday/domain/services/workout_generator_service.dart';
import 'package:flutter_test/flutter_test.dart';

/// Progress source without Hive: every branch starts at stage 1 unless a test
/// overrides it.
class _FakeProgressRepo extends SkillProgressRepository {
  _FakeProgressRepo([Map<BranchId, SkillProgress>? overrides])
      : _overrides = overrides ?? {};

  final Map<BranchId, SkillProgress> _overrides;

  @override
  SkillProgress getProgress(BranchId branch) =>
      _overrides[branch] ??
      SkillProgress(
        branchId: branch,
        currentStage: 1,
        currentReps: 8,
        currentSets: 2,
        currentRestSec: 45,
      );
}

WorkoutGeneratorService _generator([Map<BranchId, SkillProgress>? progress]) =>
    WorkoutGeneratorService(_FakeProgressRepo(progress));

final _calisthenics = CourseCatalog.branchesFor(CourseId.calisthenics);

List<String> _ids(WorkoutPlan plan) =>
    plan.exercises.map((e) => e.exercise.id).toList();

/// The stage > 0 exercises of a plan: the "main block".
List<PlannedExercise> _main(WorkoutPlan plan) =>
    plan.exercises.where((e) => e.exercise.stage > 0).toList();

void main() {
  group('generateDailyForCourse', () {
    test('an empty branch list gives an empty plan', () {
      final plan = _generator().generateDailyForCourse(
          course: CourseId.calisthenics, courseBranches: const []);
      expect(plan.exercises, isEmpty);
      expect(plan.setType, SetType.daily);
    });

    test('is warm-up, then one main exercise per branch, then cool-downs', () {
      final plan = _generator().generateDailyForCourse(
        course: CourseId.calisthenics,
        courseBranches: _calisthenics,
        dayIndexOverride: 0,
      );
      final today = _calisthenics.take(3).toList(); // 10 min -> 3 branches

      expect(plan.exercises.first.exercise,
          ExerciseCatalog.warmupFor(today.first));
      expect(plan.exercises.first.exercise.stage, 0);

      expect(_main(plan).map((e) => e.exercise.branch), today);

      expect(plan.exercises.last.exercise.stage, 0, reason: 'ends with a cool-down');
    });

    test('uses the user progress for reps, sets and rest', () {
      final plan = _generator().generateDailyForCourse(
        course: CourseId.calisthenics,
        courseBranches: [BranchId.push],
        dayIndexOverride: 0,
      );
      final push = _main(plan).single;
      expect(push.targetAmount, 8);
      expect(push.sets, 2);
      expect(push.restSec, 45);
    });

    test('warm-ups and cool-downs are single, rest-free sets', () {
      final plan = _generator().generateDailyForCourse(
        course: CourseId.calisthenics,
        courseBranches: _calisthenics,
        dayIndexOverride: 3,
      );
      for (final e in plan.exercises.where((e) => e.exercise.stage == 0)) {
        expect(e.sets, 1, reason: e.exercise.id);
        expect(e.restSec, 0, reason: e.exercise.id);
        expect(e.targetAmount, e.exercise.startReps, reason: e.exercise.id);
      }
    });

    test('has at most two distinct cool-downs', () {
      for (var day = 0; day < _calisthenics.length; day++) {
        final plan = _generator().generateDailyForCourse(
          course: CourseId.calisthenics,
          courseBranches: _calisthenics,
          preferredMinutes: 15,
          dayIndexOverride: day,
        );
        final cooldowns = plan.exercises
            .where((e) => e.exercise.stage == 0)
            .skip(1) // the warm-up
            .map((e) => e.exercise.id)
            .toList();
        expect(cooldowns.length, lessThanOrEqualTo(2), reason: 'day $day');
        expect(cooldowns.toSet(), hasLength(cooldowns.length), reason: 'day $day');
      }
    });

    group('which branches are trained today', () {
      int branchesFor(int minutes, List<BranchId> branches) => _main(
            _generator().generateDailyForCourse(
              course: CourseId.calisthenics,
              courseBranches: branches,
              preferredMinutes: minutes,
              dayIndexOverride: 0,
            ),
          ).length;

      test('5 min trains 2 branches, 10 min 3, 15 min all', () {
        expect(branchesFor(5, _calisthenics), 2);
        expect(branchesFor(10, _calisthenics), 3);
        expect(branchesFor(15, _calisthenics), _calisthenics.length);
      });

      test('never more than the course has', () {
        final healthy = CourseCatalog.branchesFor(CourseId.healthyBody); // 3
        expect(branchesFor(15, healthy), 3);
        expect(branchesFor(5, [BranchId.push]), 1);
      });

      test('the starting branch rotates with the day index', () {
        List<BranchId> startFor(int day) => _main(
              _generator().generateDailyForCourse(
                course: CourseId.calisthenics,
                courseBranches: _calisthenics,
                dayIndexOverride: day,
              ),
            ).map((e) => e.exercise.branch).toList();

        expect(startFor(0).first, _calisthenics[0]);
        expect(startFor(1).first, _calisthenics[1]);
        expect(startFor(5).first, _calisthenics[5]);
        expect(startFor(6).first, _calisthenics[0], reason: 'wraps around');
        // And it wraps inside a single day's selection too.
        expect(startFor(5), [_calisthenics[5], _calisthenics[0], _calisthenics[1]]);
      });

      test('is deterministic: the same day gives the same workout', () {
        List<String> plan() => _ids(_generator().generateDailyForCourse(
              course: CourseId.calisthenics,
              courseBranches: _calisthenics,
              dayIndexOverride: 123,
            ));
        expect(plan(), plan());
      });
    });

    group('equipment', () {
      final core4 = {
        BranchId.core: SkillProgress(
            branchId: BranchId.core, currentStage: 4, currentReps: 10),
      };

      test('without a pull-up bar core stage 4 becomes flutter kicks', () {
        final plan = _generator(core4).generateDailyForCourse(
          course: CourseId.calisthenics,
          courseBranches: [BranchId.core],
          dayIndexOverride: 0,
          hasPullUpBar: false,
        );
        expect(_main(plan).single.exercise, ExerciseCatalog.coreS4FlutterKicks);
      });

      test('with a bar the original exercise is kept', () {
        final plan = _generator(core4).generateDailyForCourse(
          course: CourseId.calisthenics,
          courseBranches: [BranchId.core],
          dayIndexOverride: 0,
          hasPullUpBar: true,
        );
        expect(_main(plan).single.exercise,
            ExerciseCatalog.forStage(BranchId.core, 4));
      });

      test('an equipment exercise without an alternative stays in the plan', () {
        final plan = _generator().generateDailyForCourse(
          course: CourseId.calisthenics,
          courseBranches: [BranchId.pull],
          dayIndexOverride: 0,
          hasPullUpBar: false,
        );
        expect(_main(plan).single.exercise,
            ExerciseCatalog.forStage(BranchId.pull, 1));
      });
    });

    group('bonus workouts', () {
      test('a primary workout has no supplementary exercises', () {
        final plan = _generator().generateDailyForCourse(
          course: CourseId.calisthenics,
          courseBranches: _calisthenics,
          dayIndexOverride: 0,
        );
        final supplementary =
            SupplementaryExerciseCatalog.all.map((e) => e.id).toSet();
        expect(_ids(plan).where(supplementary.contains), isEmpty);
      });

      test('a bonus workout appends two supplementary exercises', () {
        final plan = _generator().generateDailyForCourse(
          course: CourseId.calisthenics,
          courseBranches: _calisthenics,
          dayIndexOverride: 0,
          isPrimary: false,
        );
        final supplementary =
            SupplementaryExerciseCatalog.all.map((e) => e.id).toSet();
        final extra = plan.exercises
            .where((e) => supplementary.contains(e.exercise.id))
            .toList();
        expect(extra, hasLength(2));
        expect(plan.exercises.sublist(plan.exercises.length - 2), extra);
        expect(extra.map((e) => e.exercise.id).toSet(), hasLength(2));
      });
    });

    test('generateDaily is the calisthenics wrapper', () {
      final a = _generator().generateDaily(
          activeBranches: _calisthenics, dayIndexOverride: 2);
      final b = _generator().generateDailyForCourse(
          course: CourseId.calisthenics,
          courseBranches: _calisthenics,
          dayIndexOverride: 2);
      expect(_ids(a), _ids(b));
    });

    test('every course and day produces a plan with real exercises', () {
      for (final course in CourseId.values) {
        final branches = CourseCatalog.branchesFor(course);
        for (var day = 0; day < 14; day++) {
          final plan = _generator().generateDailyForCourse(
              course: course, courseBranches: branches, dayIndexOverride: day);
          expect(_main(plan), isNotEmpty, reason: '${course.name} day $day');
          expect(plan.exercises.first.exercise.stage, 0);
        }
      }
    });
  });

  group('generateChallenge', () {
    test('is warm-up, light current stage, next stage at the challenge target, cool-down',
        () {
      final progress = {
        BranchId.push: SkillProgress(
            branchId: BranchId.push,
            currentStage: 2,
            currentReps: 12,
            currentSets: 3,
            currentRestSec: 30),
      };
      final plan = _generator(progress).generateChallenge(BranchId.push);
      final current = ExerciseCatalog.forStage(BranchId.push, 2)!;
      final next = ExerciseCatalog.forStage(BranchId.push, 3)!;

      expect(plan.setType, SetType.challenge);
      expect(plan.exercises, hasLength(4));
      expect(plan.exercises[0].exercise, ExerciseCatalog.warmupFor(BranchId.push));

      expect(plan.exercises[1].exercise, current);
      expect(plan.exercises[1].sets, 1);
      expect(plan.exercises[1].targetAmount, current.startReps);
      expect(plan.exercises[1].restSec, 30);

      expect(plan.exercises[2].exercise, next);
      expect(plan.exercises[2].sets, 1);
      expect(plan.exercises[2].targetAmount, next.challengeTargetReps);
      expect(plan.exercises[2].restSec, next.startRestSec);

      expect(plan.exercises[3].exercise,
          ExerciseCatalog.cooldownsFor(BranchId.push).first);
    });

    test('at the last stage it falls back to a daily plan', () {
      final progress = {
        BranchId.push: SkillProgress(
            branchId: BranchId.push, currentStage: BranchId.push.stageCount),
      };
      final plan = _generator(progress).generateChallenge(BranchId.push);
      expect(plan.setType, SetType.daily);
      expect(plan.exercises, isNotEmpty);
    });
  });

  group('fromExerciseIds', () {
    test('builds a plan at start values from catalog, library and supplementary ids',
        () {
      final supplementary = SupplementaryExerciseCatalog.all.first;
      final plan = _generator().fromExerciseIds([
        'warmup_arm_rotations',
        'push_s1_wall_pushup',
        'core_s4_flutter_kicks', // only in the library list, not in `all`
        supplementary.id,
      ]);
      expect(_ids(plan), [
        'warmup_arm_rotations',
        'push_s1_wall_pushup',
        'core_s4_flutter_kicks',
        supplementary.id,
      ]);
      for (final e in plan.exercises) {
        expect(e.targetAmount, e.exercise.startReps);
        expect(e.sets, e.exercise.startSets);
        expect(e.restSec, e.exercise.startRestSec);
      }
    });

    test('skips unknown ids and keeps the order of the rest', () {
      final plan = _generator()
          .fromExerciseIds(['push_s1_wall_pushup', 'no_such_exercise', 'warmup_arm_rotations']);
      expect(_ids(plan), ['push_s1_wall_pushup', 'warmup_arm_rotations']);
    });

    test('hasWarmupAndCooldown needs both a warm-up and a cool-down', () {
      expect(WorkoutGeneratorService.hasWarmupAndCooldown(['push_s1_wall_pushup']),
          isFalse);
      expect(
          WorkoutGeneratorService.hasWarmupAndCooldown(
              ['warmup_arm_rotations', 'push_s1_wall_pushup']),
          isFalse);
      expect(
          WorkoutGeneratorService.hasWarmupAndCooldown(
              ['warmup_arm_rotations', 'cooldown_shoulder_stretch']),
          isTrue);
    });

    test('addGenericWarmupCooldown wraps the list and yields real exercises', () {
      final wrapped =
          WorkoutGeneratorService.addGenericWarmupCooldown(['push_s1_wall_pushup']);
      expect(wrapped.length, 3);
      expect(wrapped[1], 'push_s1_wall_pushup');
      expect(WorkoutGeneratorService.hasWarmupAndCooldown(wrapped), isTrue);
      expect(_ids(_generator().fromExerciseIds(wrapped)), wrapped,
          reason: 'both generic ids must exist in the catalog');
    });
  });

  group('WorkoutPlan', () {
    test('totalSets sums the sets of every exercise', () {
      final plan = _generator().generateDailyForCourse(
        course: CourseId.calisthenics,
        courseBranches: [BranchId.push],
        dayIndexOverride: 0,
      );
      // warm-up 1 + push 2 + cool-down 1
      expect(plan.totalSets, 4);
    });

    test('estimatedDurationSec adds ~30 s per set and the rests between sets',
        () {
      const plan = WorkoutPlan(setType: SetType.daily, exercises: []);
      expect(plan.estimatedDurationSec, 0);

      final one = _generator().fromExerciseIds(['push_s1_wall_pushup']);
      final e = one.exercises.single;
      expect(one.estimatedDurationSec,
          e.sets * 30 + (e.sets > 1 ? (e.sets - 1) * e.restSec : 0));
    });
  });
}
