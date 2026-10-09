import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive_ce.dart';

import '../models/enums.dart';
import '../models/skill_progress.dart';
import '../static/exercise_catalog.dart';

/// Provides access to per-branch [SkillProgress] records stored in Hive.
///
/// Keys are branch-scoped only (e.g. "flex"), so progress is shared across
/// all courses that contain the same branch — branches are physical skills.
class SkillProgressRepository {
  static const _boxName = 'skill_progress';

  Box<SkillProgress> get _box => Hive.box<SkillProgress>(_boxName);

  /// Returns the progress for [branch], or a default starting value.
  SkillProgress getProgress(BranchId branch) {
    return _box.get(branch.name) ?? _defaultFor(branch);
  }

  /// Persists [progress] for its branch.
  Future<void> saveProgress(SkillProgress progress) {
    return _box.put(progress.branchId.name, progress);
  }

  /// Returns progress for every branch that has been persisted so far.
  List<SkillProgress> getAll() => _box.values.toList();

  /// Returns true if a record exists for [branch].
  bool hasProgress(BranchId branch) => _box.containsKey(branch.name);

  /// Migrates data from legacy bare-branch keys ("push") or course-scoped keys
  /// ("calisthenics_push") to bare-branch keys. Safe to call multiple times.
  Future<void> runMigrations() async {
    for (final branch in BranchId.values) {
      final bareKey = branch.name;
      // Migrate course-scoped keys back to bare keys (e.g. "calisthenics_flex" → "flex").
      for (final course in CourseId.values) {
        final scopedKey = '${course.name}_${branch.name}';
        if (_box.containsKey(scopedKey) && !_box.containsKey(bareKey)) {
          // A copy: Hive refuses to store one HiveObject under two keys.
          await _box.put(bareKey, _copyOf(_box.get(scopedKey)!));
        }
        if (_box.containsKey(scopedKey)) {
          await _box.delete(scopedKey);
        }
      }
    }
    await _capRepsAtStageTarget();
  }

  /// A stage whose target was lowered in the catalog (0.9.2: three per-side
  /// holds, 60 → 30 s) would keep asking the old amount until the next set
  /// resets it, so stored reps above the stage's target come down to it.
  Future<void> _capRepsAtStageTarget() async {
    for (final key in _box.keys.toList()) {
      final p = _box.get(key)!;
      final exercise = ExerciseCatalog.forStage(p.branchId, p.currentStage);
      if (exercise == null || p.currentReps <= exercise.targetReps) continue;
      p.currentReps = exercise.targetReps;
      await _box.put(key, p);
    }
  }

  static SkillProgress _copyOf(SkillProgress p) => SkillProgress(
        branchId: p.branchId,
        currentStage: p.currentStage,
        currentReps: p.currentReps,
        currentSets: p.currentSets,
        currentRestSec: p.currentRestSec,
        isChallengeUnlocked: p.isChallengeUnlocked,
      );

  SkillProgress _defaultFor(BranchId branch) {
    // Starting values vary slightly by branch difficulty.
    switch (branch) {
      case BranchId.push:
      case BranchId.core:
        return SkillProgress(
          branchId: branch,
          currentStage: 1,
          currentReps: 5,
          currentSets: 1,
          currentRestSec: 60,
        );
      case BranchId.pull:
        return SkillProgress(
          branchId: branch,
          currentStage: 1,
          currentReps: 5,
          currentSets: 1,
          currentRestSec: 90,
        );
      case BranchId.legs:
        return SkillProgress(
          branchId: branch,
          currentStage: 1,
          currentReps: 8,
          currentSets: 1,
          currentRestSec: 45,
        );
      case BranchId.balance:
        return SkillProgress(
          branchId: branch,
          currentStage: 1,
          currentReps: 10, // seconds for timed hold
          currentSets: 1,
          currentRestSec: 60,
        );
      case BranchId.flex:
        return SkillProgress(
          branchId: branch,
          currentStage: 1,
          currentReps: 10,
          currentSets: 1,
          currentRestSec: 30,
        );
      case BranchId.posture:
        return SkillProgress(
          branchId: branch,
          currentStage: 1,
          currentReps: 10,
          currentSets: 1,
          currentRestSec: 30,
        );
      case BranchId.neck:
        return SkillProgress(
          branchId: branch,
          currentStage: 1,
          currentReps: 15,
          currentSets: 1,
          currentRestSec: 15,
        );
      case BranchId.eveningBack:
      case BranchId.eveningHips:
      case BranchId.eveningFolds:
      case BranchId.eveningShoulders:
      case BranchId.morningSpine:
      case BranchId.morningJoints:
      case BranchId.morningArms:
      case BranchId.morningEnergy:
      case BranchId.yogaStanding:
      case BranchId.yogaOneLeg:
      case BranchId.yogaBackbends:
      case BranchId.yogaFlow:
        // The stage-1 exercise's own starting values.
        final first = ExerciseCatalog.forStage(branch, 1)!;
        return SkillProgress(
          branchId: branch,
          currentStage: 1,
          currentReps: first.startReps,
          currentSets: first.startSets,
          currentRestSec: first.startRestSec,
        );
    }
  }
}

final skillProgressRepositoryProvider = Provider<SkillProgressRepository>(
  (_) => SkillProgressRepository(),
);