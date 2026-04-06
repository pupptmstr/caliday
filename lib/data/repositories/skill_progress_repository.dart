import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../models/enums.dart';
import '../models/skill_progress.dart';

/// Provides access to per-branch [SkillProgress] records stored in Hive.
///
/// Keys are course-scoped: `"${course.name}_${branch.name}"` (e.g. "calisthenics_push").
/// [getProgress] defaults to [CourseId.calisthenics] for backward compatibility.
class SkillProgressRepository {
  static const _boxName = 'skill_progress';

  Box<SkillProgress> get _box => Hive.box<SkillProgress>(_boxName);

  String _key(BranchId branch, CourseId course) =>
      '${course.name}_${branch.name}';

  /// Returns the progress for [branch] in [course], or a default starting value.
  SkillProgress getProgress(
    BranchId branch, {
    CourseId course = CourseId.calisthenics,
  }) {
    return _box.get(_key(branch, course)) ?? _defaultFor(branch);
  }

  /// Persists [progress] for its branch in [course].
  Future<void> saveProgress(
    SkillProgress progress, {
    CourseId course = CourseId.calisthenics,
  }) {
    return _box.put(_key(progress.branchId, course), progress);
  }

  /// Returns progress for every branch that has been persisted so far.
  List<SkillProgress> getAll() => _box.values.toList();

  /// Returns true if a record exists for [branch] in [course].
  bool hasProgress(
    BranchId branch, {
    CourseId course = CourseId.calisthenics,
  }) =>
      _box.containsKey(_key(branch, course));

  /// Migrates legacy bare-branch keys (e.g. "push") to course-scoped keys
  /// (e.g. "calisthenics_push"). Safe to call multiple times (idempotent).
  Future<void> migrateToCourseScopedKeys() async {
    for (final branch in BranchId.values) {
      final oldKey = branch.name;
      final newKey = _key(branch, CourseId.calisthenics);
      if (_box.containsKey(oldKey) && !_box.containsKey(newKey)) {
        await _box.put(newKey, _box.get(oldKey)!);
        await _box.delete(oldKey);
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