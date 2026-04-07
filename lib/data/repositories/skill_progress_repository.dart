import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../models/enums.dart';
import '../models/skill_progress.dart';

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
          await _box.put(bareKey, _box.get(scopedKey)!);
        }
        if (_box.containsKey(scopedKey)) {
          await _box.delete(scopedKey);
        }
      }
    }
  }

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
          currentReps: 20, // seconds for timed hold
          currentSets: 1,
          currentRestSec: 60,
        );
      case BranchId.flex:
        return SkillProgress(
          branchId: branch,
          currentStage: 1,
          currentReps: 20,
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
    }
  }
}

final skillProgressRepositoryProvider = Provider<SkillProgressRepository>(
  (_) => SkillProgressRepository(),
);