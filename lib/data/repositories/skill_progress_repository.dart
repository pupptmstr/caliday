import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../models/enums.dart';
import '../models/skill_progress.dart';

/// Provides access to per-branch [SkillProgress] records stored in Hive.
///
/// Each branch gets its own entry keyed by [BranchId.name].
/// If no record exists for a branch yet, [getProgress] returns a sensible
/// default that the domain layer can use immediately.
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
    }
  }
}

final skillProgressRepositoryProvider = Provider<SkillProgressRepository>(
  (_) => SkillProgressRepository(),
);