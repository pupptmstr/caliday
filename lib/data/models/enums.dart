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

  @HiveField(8)
  eveningBack,

  @HiveField(9)
  eveningHips,

  @HiveField(10)
  eveningFolds,

  @HiveField(11)
  eveningShoulders,

  @HiveField(12)
  morningSpine,

  @HiveField(13)
  morningJoints,

  @HiveField(14)
  morningArms,

  @HiveField(15)
  morningEnergy,
}

@HiveType(typeId: 10)
enum CourseId {
  @HiveField(0)
  calisthenics,

  @HiveField(1)
  healthyBody,

  @HiveField(2)
  eveningStretch,

  @HiveField(3)
  morningRoutine,
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
        CourseId.eveningStretch => l10n.courseNameEveningStretch,
        CourseId.morningRoutine => l10n.courseNameMorningRoutine,
      };

  /// The course host's portrait (course cards): its happy face. Goro, Raffi
  /// the giraffe, Luna the owl, Aurora the lark; art from
  /// tools/characters/gen_hosts.py.
  String get hostPortrait => hostFace('happy');

  /// One of the host's six faces (Home), by mood name: happy, sad, angry,
  /// sleeping, excited, supportive.
  String hostFace(String mood) => switch (this) {
        CourseId.calisthenics => 'assets/goro/goro_face_$mood.svg',
        CourseId.healthyBody => 'assets/hosts/raffi_face_$mood.svg',
        CourseId.eveningStretch => 'assets/hosts/luna_face_$mood.svg',
        CourseId.morningRoutine => 'assets/hosts/aurora_face_$mood.svg',
      };

  /// The host standing calmly (Profile).
  String get hostIdle => switch (this) {
        CourseId.calisthenics => 'assets/goro/goro_idle_v2.svg',
        CourseId.healthyBody => 'assets/hosts/raffi_idle.svg',
        CourseId.eveningStretch => 'assets/hosts/luna_idle.svg',
        CourseId.morningRoutine => 'assets/hosts/aurora_idle.svg',
      };

  /// The course host cheering on the summary of a workout of this course.
  String get hostCheer => switch (this) {
        CourseId.calisthenics => 'assets/goro/goro_flex_v2.svg',
        CourseId.healthyBody => 'assets/hosts/raffi_cheer.svg',
        CourseId.eveningStretch => 'assets/hosts/luna_cheer.svg',
        CourseId.morningRoutine => 'assets/hosts/aurora_cheer.svg',
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
        BranchId.eveningBack => '🐈',
        BranchId.eveningHips => '🦋',
        BranchId.eveningFolds => '🌙',
        BranchId.eveningShoulders => '🦅',
        BranchId.morningSpine => '🌀',
        BranchId.morningJoints => '⚙️',
        BranchId.morningArms => '🙌',
        BranchId.morningEnergy => '⚡',
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
        BranchId.eveningBack => Icons.airline_seat_flat,
        BranchId.eveningHips => Icons.spa,
        BranchId.eveningFolds => Icons.nightlight_round,
        BranchId.eveningShoulders => Icons.accessibility,
        BranchId.morningSpine => Icons.sync,
        BranchId.morningJoints => Icons.threesixty,
        BranchId.morningArms => Icons.front_hand,
        BranchId.morningEnergy => Icons.bolt,
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
        BranchId.eveningBack => l10n.homeBranchEveningBack,
        BranchId.eveningHips => l10n.homeBranchEveningHips,
        BranchId.eveningFolds => l10n.homeBranchEveningFolds,
        BranchId.eveningShoulders => l10n.homeBranchEveningShoulders,
        BranchId.morningSpine => l10n.homeBranchMorningSpine,
        BranchId.morningJoints => l10n.homeBranchMorningJoints,
        BranchId.morningArms => l10n.homeBranchMorningArms,
        BranchId.morningEnergy => l10n.homeBranchMorningEnergy,
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
        BranchId.eveningBack => 5,
        BranchId.eveningHips => 5,
        BranchId.eveningFolds => 4,
        BranchId.eveningShoulders => 5,
        BranchId.morningSpine => 5,
        BranchId.morningJoints => 5,
        BranchId.morningArms => 5,
        BranchId.morningEnergy => 5,
      };

  bool get requiresEquipment => this == BranchId.pull;
}

/// How big the daily workout is: how many skill branches it covers (2, 3 or all
/// of the course's). It never meant real minutes: how long it takes depends on
/// the reps, sets and rests of the day. The profile keeps it as the old code
/// 5 / 10 / 15 (`UserProfile.preferredWorkoutMinutes`), so nothing is migrated.
/// Not stored by Hive itself.
enum WorkoutSize {
  short(5),
  standard(10),
  full(15);

  const WorkoutSize(this.code);

  /// The value saved in `UserProfile.preferredWorkoutMinutes` and passed to
  /// `WorkoutGeneratorService` as `preferredMinutes`.
  final int code;

  /// The size a stored [code] stands for, read the way the generator reads it:
  /// up to 5 is short, 15 and more is full, anything between is standard.
  static WorkoutSize fromCode(int code) => code <= 5
      ? short
      : code >= 15
          ? full
          : standard;
}

extension WorkoutSizeLocalization on WorkoutSize {
  String localizedName(AppLocalizations l10n) => switch (this) {
        WorkoutSize.short => l10n.workoutSizeShort,
        WorkoutSize.standard => l10n.workoutSizeStandard,
        WorkoutSize.full => l10n.workoutSizeFull,
      };

  String localizedDescription(AppLocalizations l10n) => switch (this) {
        WorkoutSize.short => l10n.workoutSizeShortDesc,
        WorkoutSize.standard => l10n.workoutSizeStandardDesc,
        WorkoutSize.full => l10n.workoutSizeFullDesc,
      };
}
