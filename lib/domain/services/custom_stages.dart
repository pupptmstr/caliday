import 'dart:math';

import '../../data/models/enums.dart';
import '../../data/models/exercise.dart';
import '../../data/models/skill_progress.dart';

/// The stages of a branch the user made (owner, 2026-10-09): the user picks
/// exercises and their order, the app sets the amounts and the challenges.
///
/// Each stage is a copy of its catalog exercise (same id, so the texts, tags
/// and animation are its own) with the stage number of its place.
/// - An exercise with an in-stage progression of its own (every stage of a
///   built-in branch) keeps its start / target reps, sets and rests.
/// - One without (warm-ups, cool-downs, the supplementary pool: one fixed
///   amount) starts at that amount and works up to twice it ([growth], timed
///   amounts rounded to 5 s), in 1 → 2 sets, rest 30 → 15 s.
/// - The challenge to enter a stage is the exercise's own norm when it has one
///   (a built-in stage from 2 up), otherwise one and a half times its start.
abstract final class CustomStages {
  static const int growth = 2;
  static const int restStart = 30;
  static const int restTarget = 15;

  /// The stages of [exercises], stage 1 first.
  static List<Exercise> build(List<Exercise> exercises) => [
        for (var i = 0; i < exercises.length; i++) stageOf(exercises[i], i + 1),
      ];

  /// [e] as stage [stage] of an own branch.
  static Exercise stageOf(Exercise e, int stage) {
    final own = hasOwnProgression(e);
    final targetReps = own ? e.targetReps : _amount(e, e.startReps * growth);
    return Exercise(
      id: e.id,
      name: e.name,
      description: e.description,
      branch: e.branch,
      stage: stage,
      type: e.type,
      startReps: e.startReps,
      targetReps: targetReps,
      startSets: own ? e.startSets : 1,
      targetSets: own ? e.targetSets : max(2, e.startSets),
      startRestSec: own ? e.startRestSec : restStart,
      targetRestSec: own ? e.targetRestSec : restTarget,
      spBase: e.spBase,
      challengeTargetReps: stage == 1 ? 0 : challengeNorm(e),
      requiresEquipment: e.requiresEquipment,
      perSide: e.perSide,
      techniqueTip: e.techniqueTip,
      imagePath: e.imagePath,
      animationPath: e.animationPath,
      tags: e.tags,
    );
  }

  /// Whether [e] has a start → target of its own to climb (reps, sets or rest).
  static bool hasOwnProgression(Exercise e) =>
      e.targetReps > e.startReps ||
      e.targetSets > e.startSets ||
      e.startRestSec > e.targetRestSec;

  /// The amount to reach in the challenge that enters a stage of [e].
  static int challengeNorm(Exercise e) {
    if (e.stage >= 2 && e.challengeTargetReps > 0) return e.challengeTargetReps;
    return max(_amount(e, e.startReps * 3 / 2), e.startReps);
  }

  /// [raw] reps rounded to a whole rep, seconds to 5 s; never below 1 / 5.
  static int _amount(Exercise e, num raw) => e.type == ExerciseType.timed
      ? max(5, (raw / 5).round() * 5)
      : max(1, raw.round());

  /// The stages of an own branch went from [oldIds] to [stages]: the user
  /// stays on the exercise they were on when it is still there (its amounts
  /// do not depend on the place), otherwise on the stage that took its place
  /// (the last one when the list got shorter) from its start. Mutates
  /// [progress]; saving is the caller's.
  static void remap(
    SkillProgress progress,
    List<String> oldIds,
    List<Exercise> stages,
  ) {
    if (stages.isEmpty) return;
    final at = progress.currentStage - 1;
    final currentId = at >= 0 && at < oldIds.length ? oldIds[at] : null;
    final kept = stages.indexWhere((e) => e.id == currentId);
    if (kept >= 0) {
      progress.currentStage = kept + 1;
      if (progress.currentStage >= stages.length) {
        progress.isChallengeUnlocked = false;
      }
      return;
    }
    final stage = stages[min(max(at, 0), stages.length - 1)];
    progress
      ..currentStage = stage.stage
      ..currentReps = stage.startReps
      ..currentSets = stage.startSets
      ..currentRestSec = stage.startRestSec
      ..isChallengeUnlocked = false;
  }
}
