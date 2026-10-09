import '../../data/models/custom_branch.dart';
import '../../data/models/enums.dart';
import '../../data/models/exercise_result.dart';
import '../../data/models/skill_progress.dart';
import '../models/branch.dart';
import '../models/workout_plan.dart';
import 'progression_service.dart';

/// What a finished workout does to the branches it trained, decided without
/// Hive: each stage exercise moves its branch — the one of
/// [PlannedExercise.branchKey] (an own branch's stage is a copy of a catalog
/// exercise), else the exercise's own. A challenge exercise (a stage above the
/// branch's current one) advances the stage when its norm is met, in any
/// workout; any other moves the branch once a day
/// ([ProgressionService.applyDailyResult]).
class WorkoutProgression {
  WorkoutProgression._();

  bool challengeUnlocked = false;
  bool challengePassed = false;
  String? newStageExerciseId;

  /// The branch whose challenge was passed, and the stage it reached.
  Branch? advancedBranch;
  int advancedToStage = 0;

  /// Every progress record the workout went through, changed in place; the
  /// caller saves them.
  final List<SkillProgress> touched = [];

  /// Applies [results] (parallel to `plan.exercises`, null = not done) of
  /// [plan]. [progressFor] reads a branch's progress; it is asked once per
  /// branch. A branch deleted meanwhile (an own one) is skipped.
  static WorkoutProgression apply({
    required WorkoutPlan plan,
    required List<ExerciseResult?> results,
    required Iterable<CustomBranch> ownBranches,
    required SkillProgress Function(Branch branch) progressFor,
    required DateTime now,
    ProgressionService progression = const ProgressionService(),
  }) {
    final out = WorkoutProgression._();
    final byKey = <String, SkillProgress>{};

    for (var i = 0; i < plan.exercises.length && i < results.length; i++) {
      final planned = plan.exercises[i];
      final result = results[i];
      if (result == null || planned.exercise.stage == 0) continue;

      final key = planned.branchKey;
      final branch = key == null
          ? BuiltInBranch(planned.exercise.branch)
          : Branch.resolve(key, ownBranches);
      if (branch == null) continue;
      final progress = byKey.putIfAbsent(branch.key, () {
        final p = progressFor(branch);
        out.touched.add(p);
        return p;
      });

      final exercise = planned.exercise;
      if (exercise.stage > progress.currentStage) {
        // Challenge exercise: always advance stage even in bonus workouts.
        final passed = exercise.type == ExerciseType.timed
            ? (result.actualDurationSec ?? 0) >= exercise.challengeTargetReps
            : result.completedReps >= exercise.challengeTargetReps;
        if (passed) {
          progression.advanceStage(progress, exercise);
          out
            ..challengePassed = true
            ..newStageExerciseId = exercise.id
            ..advancedBranch = branch
            ..advancedToStage = progress.currentStage;
        }
        // If failed: isChallengeUnlocked stays true, progress unchanged.
      } else {
        // Regular progression: the branch's first successful set of the day
        // at its current stage, whether this workout is primary or a bonus.
        final unlocked = progression.applyDailyResult(progress, exercise, result,
            now: now, stageCount: branch.stageCount);
        if (unlocked) out.challengeUnlocked = true;
      }
    }
    return out;
  }
}
