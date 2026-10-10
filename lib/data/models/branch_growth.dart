import 'package:hive_ce/hive_ce.dart';

part 'branch_growth.g.dart';

/// How a branch moved on in one workout: its values before and after. A
/// branch moves one step a day (more reps, a set, less rest, the challenge
/// unlocked) or a stage when its challenge is passed. Kept in
/// [WorkoutLog.growth] for "Today it grew" on Home.
@HiveType(typeId: 14)
class BranchGrowth {
  BranchGrowth({
    required this.branchKey,
    required this.fromStage,
    required this.toStage,
    required this.fromAmount,
    required this.toAmount,
    required this.fromSets,
    required this.toSets,
    required this.fromRestSec,
    required this.toRestSec,
    this.challengeUnlocked = false,
  });

  /// `Branch.key`: a built-in branch by its name, an own one `custom_<id>`.
  @HiveField(0)
  final String branchKey;

  @HiveField(1)
  final int fromStage;

  @HiveField(2)
  final int toStage;

  /// Reps, or seconds of a hold.
  @HiveField(3)
  final int fromAmount;

  @HiveField(4)
  final int toAmount;

  @HiveField(5)
  final int fromSets;

  @HiveField(6)
  final int toSets;

  @HiveField(7)
  final int fromRestSec;

  @HiveField(8)
  final int toRestSec;

  /// The challenge of the next stage opened in this workout.
  @HiveField(9, defaultValue: false)
  final bool challengeUnlocked;

  GrowthKind get kind {
    if (toStage > fromStage) return GrowthKind.stage;
    if (toSets > fromSets) return GrowthKind.sets;
    if (toAmount > fromAmount) return GrowthKind.amount;
    if (toRestSec < fromRestSec) return GrowthKind.rest;
    return GrowthKind.challenge;
  }
}

/// The one step a [BranchGrowth] took, in the order of the progression.
enum GrowthKind { amount, sets, rest, challenge, stage }
