import 'package:hive_ce/hive_ce.dart';

import 'custom_branch.dart';
import 'enums.dart';

part 'skill_progress.g.dart';

/// Tracks a user's current progression within one branch: a built-in
/// [BranchId] or the user's own branch ([customBranchId]).
///
/// One box entry per branch, under [branchKey]. Stores the current stage and the
/// current training load (reps/sets/rest), which increases over time
/// until the stage's target is reached and a Challenge test is unlocked.
@HiveType(typeId: 1)
class SkillProgress extends HiveObject {
  SkillProgress({
    this.branchId,
    this.customBranchId,
    this.currentStage = 1,
    this.currentReps = 5,
    this.currentSets = 1,
    this.currentRestSec = 60,
    this.isChallengeUnlocked = false,
    this.lastProgressedOn,
  });

  /// The built-in branch; null for the user's own one ([customBranchId]).
  @HiveField(0)
  BranchId? branchId;

  /// Current stage index (1-based).
  @HiveField(1)
  int currentStage;

  /// Reps (or seconds for timed) the user is currently doing.
  @HiveField(2)
  int currentReps;

  /// Number of sets the user is currently doing.
  @HiveField(3)
  int currentSets;

  /// Rest duration in seconds between sets.
  @HiveField(4)
  int currentRestSec;

  /// True when [currentReps]/[currentSets]/[currentRestSec] have reached
  /// the stage's targets and the Challenge test can be taken.
  @HiveField(5)
  bool isChallengeUnlocked;

  /// When the branch last made its daily step (see
  /// [ProgressionService.applyDailyResult]); only the calendar day matters.
  /// Null: never (and for every progress saved before 0.8.19).
  @HiveField(6)
  DateTime? lastProgressedOn;

  /// `CustomBranch.id` when this is the progress of the user's own branch.
  @HiveField(7)
  String? customBranchId;

  /// The box key, and `Branch.key` of the branch: "push" or "custom_" and
  /// the own branch's id. (Not `key`: that is [HiveObject]'s own.)
  String get branchKey =>
      customBranchId != null
          ? CustomBranch.keyFor(customBranchId!)
          : branchId!.name;
}