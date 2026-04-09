import 'package:caliday/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce/hive_ce.dart';

part 'enums.g.dart';

@HiveType(typeId: 4)
enum BranchId {
  @HiveField(0)
  push,

  @HiveField(1)
  core,

  @HiveField(2)
  pull,

  @HiveField(3)
  legs,

  @HiveField(4)
  balance,

  @HiveField(5)
  flex,

  @HiveField(6)
  posture,

  @HiveField(7)
  neck,
}

@HiveType(typeId: 10)
enum CourseId {
  @HiveField(0)
  calisthenics,

  @HiveField(1)
  healthyBody,
}

@HiveType(typeId: 5)
enum SetType {
  @HiveField(0)
  daily,

  @HiveField(1)
  skill,

  @HiveField(2)
  challenge,
}

@HiveType(typeId: 6)
enum ExerciseType {
  /// Reps-based exercise (e.g. pushups). [spBase] = SP per completed rep.
  @HiveField(0)
  reps,

  /// Timed exercise (e.g. plank). [spBase] = SP per 10 seconds held.
  @HiveField(1)
  timed,
}

/// User rank. Thresholds are defined in [RankExtension.spThreshold].
@HiveType(typeId: 7)
enum Rank {
  @HiveField(0)
  beginner, // Новичок — 0 SP

  @HiveField(1)
  amateur, // Любитель — 500 SP

  @HiveField(2)
  sportsman, // Спортсмен — 2000 SP

  @HiveField(3)
  athlete, // Атлет — 5000 SP

  @HiveField(4)
  master, // Мастер — 15000 SP

  @HiveField(5)
  legend, // Легенда — 50000 SP
}

extension RankExtension on Rank {
  int get spThreshold {
    switch (this) {
      case Rank.beginner:
        return 0;
      case Rank.amateur:
        return 500;
      case Rank.sportsman:
        return 2000;
      case Rank.athlete:
        return 5000;
      case Rank.master:
        return 15000;
      case Rank.legend:
        return 50000;
    }
  }

  String get displayName {
    switch (this) {
      case Rank.beginner:
        return 'Новичок';
      case Rank.amateur:
        return 'Любитель';
      case Rank.sportsman:
        return 'Спортсмен';
      case Rank.athlete:
        return 'Атлет';
      case Rank.master:
        return 'Мастер';
      case Rank.legend:
        return 'Легенда';
    }
  }

  /// Returns the next rank, or null if already at the top.
  Rank? get next {
    final values = Rank.values;
    final idx = values.indexOf(this);
    return idx < values.length - 1 ? values[idx + 1] : null;
  }

  /// Determines rank from total SP.
  static Rank fromSP(int totalSP) {
    for (final rank in Rank.values.reversed) {
      if (totalSP >= rank.spThreshold) return rank;
    }
    return Rank.beginner;
  }
}

/// User's fitness goal chosen during onboarding.
/// Stored in [UserProfile] so it can later influence branch selection.
@HiveType(typeId: 8)
enum FitnessGoal {
  @HiveField(0)
  generalFitness,

  @HiveField(1)
  strengthPush,

  @HiveField(2)
  calisthenics,
}

extension RankLocalization on Rank {
  String localizedName(AppLocalizations l10n) => switch (this) {
        Rank.beginner => l10n.rankBeginner,
        Rank.amateur => l10n.rankAmateur,
        Rank.sportsman => l10n.rankSportsman,
        Rank.athlete => l10n.rankAthlete,
        Rank.master => l10n.rankMaster,
        Rank.legend => l10n.rankLegend,
      };
}

extension CourseIdExtension on CourseId {
  String localizedName(AppLocalizations l10n) => switch (this) {
        CourseId.calisthenics => l10n.courseNameCalisthenics,
        CourseId.healthyBody => l10n.courseNameHealthyBody,
      };
}

enum ExerciseTag {
  // Muscle groups
  hipFlexor,
  glutes,
  core,
  chest,
  back,
  shoulders,
  legs,
  neck,
  // Load type
  stretch,
  mobility,
  strength,
  endurance,
  // Context
  sittingRecovery,
  floorOnly,
  requiresBar,
  // Program context
  postureFocus,
  beginner,
  // Workout structure
  warmup,
  cooldown,
}

extension ExerciseTagExtension on ExerciseTag {
  String localizedName(AppLocalizations l10n) => switch (this) {
        ExerciseTag.hipFlexor => l10n.exerciseTagHipFlexor,
        ExerciseTag.glutes => l10n.exerciseTagGlutes,
        ExerciseTag.core => l10n.exerciseTagCore,
        ExerciseTag.chest => l10n.exerciseTagChest,
        ExerciseTag.back => l10n.exerciseTagBack,
        ExerciseTag.shoulders => l10n.exerciseTagShoulders,
        ExerciseTag.legs => l10n.exerciseTagLegs,
        ExerciseTag.neck => l10n.exerciseTagNeck,
        ExerciseTag.stretch => l10n.exerciseTagStretch,
        ExerciseTag.mobility => l10n.exerciseTagMobility,
        ExerciseTag.strength => l10n.exerciseTagStrength,
        ExerciseTag.endurance => l10n.exerciseTagEndurance,
        ExerciseTag.sittingRecovery => l10n.exerciseTagSittingRecovery,
        ExerciseTag.floorOnly => l10n.exerciseTagFloorOnly,
        ExerciseTag.requiresBar => l10n.exerciseTagRequiresBar,
        ExerciseTag.postureFocus => l10n.exerciseTagPostureFocus,
        ExerciseTag.beginner => l10n.exerciseTagBeginner,
        ExerciseTag.warmup => l10n.exerciseTagWarmup,
        ExerciseTag.cooldown => l10n.exerciseTagCooldown,
      };

  Color get color => switch (this) {
        ExerciseTag.strength || ExerciseTag.endurance => const Color(0xFF007AFF),
        ExerciseTag.stretch || ExerciseTag.mobility => const Color(0xFF34C759),
        ExerciseTag.requiresBar => const Color(0xFFFF9500),
        ExerciseTag.sittingRecovery ||
        ExerciseTag.postureFocus =>
          const Color(0xFF9B59B6),
        ExerciseTag.beginner => const Color(0xFF5AC8FA),
        ExerciseTag.core ||
        ExerciseTag.chest ||
        ExerciseTag.back ||
        ExerciseTag.shoulders =>
          const Color(0xFFFF3B30),
        ExerciseTag.legs ||
        ExerciseTag.glutes ||
        ExerciseTag.hipFlexor =>
          const Color(0xFFFF6B35),
        ExerciseTag.warmup => const Color(0xFFFF9F0A),
        ExerciseTag.cooldown => const Color(0xFF5E5CE6),
        _ => const Color(0xFF636366),
      };
}

extension BranchIdExtension on BranchId {
  String get emoji => switch (this) {
        BranchId.push => '💪',
        BranchId.pull => '🏋️',
        BranchId.core => '🎯',
        BranchId.legs => '🦵',
        BranchId.balance => '⚖️',
        BranchId.flex => '🧘',
        BranchId.posture => '🏃',
        BranchId.neck => '🦒',
      };

  IconData get icon => switch (this) {
        BranchId.push => Icons.fitness_center,
        BranchId.pull => Icons.sports_gymnastics,
        BranchId.core => Icons.accessibility_new,
        BranchId.legs => Icons.directions_run,
        BranchId.balance => Icons.balance,
        BranchId.flex => Icons.self_improvement,
        BranchId.posture => Icons.airline_seat_recline_normal,
        BranchId.neck => Icons.person_outline,
      };

  String localizedName(AppLocalizations l10n) => switch (this) {
        BranchId.push => l10n.homeBranchPush,
        BranchId.pull => l10n.homeBranchPull,
        BranchId.core => l10n.homeBranchCore,
        BranchId.legs => l10n.homeBranchLegs,
        BranchId.balance => l10n.homeBranchBalance,
        BranchId.flex => l10n.homeBranchFlex,
        BranchId.posture => l10n.homeBranchPosture,
        BranchId.neck => l10n.homeBranchNeck,
      };

  int get stageCount => switch (this) {
        BranchId.push => 7,
        BranchId.pull => 6,
        BranchId.core => 6,
        BranchId.legs => 5,
        BranchId.balance => 6,
        BranchId.flex => 6,
        BranchId.posture => 6,
        BranchId.neck => 5,
      };

  bool get requiresEquipment => this == BranchId.pull;
}