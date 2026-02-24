import 'package:hive/hive.dart';

import 'enums.dart';

part 'skill_progress.g.dart';

/// Tracks a user's current progression within one [BranchId].
///
/// One box entry per branch. Stores the current stage and the
/// current training load (reps/sets/rest), which increases over time
/// until the stage's target is reached and a Challenge test is unlocked.
@HiveType(typeId: 1)
class SkillProgress extends HiveObject {
  SkillProgress({
    required this.branchId,
    this.currentStage = 1,
    this.currentReps = 5,
    this.currentSets = 1,
    this.currentRestSec = 60,
    this.isChallengeUnlocked = false,
  });

  @HiveField(0)
  BranchId branchId;

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
}