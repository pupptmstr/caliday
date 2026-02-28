import 'package:caliday/l10n/app_localizations.dart';
import 'package:hive/hive.dart';

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

extension BranchIdExtension on BranchId {
  String get emoji => switch (this) {
        BranchId.push => '💪',
        BranchId.pull => '🏋️',
        BranchId.core => '🎯',
        BranchId.legs => '🦵',
        BranchId.balance => '⚖️',
      };

  String localizedName(AppLocalizations l10n) => switch (this) {
        BranchId.push => l10n.homeBranchPush,
        BranchId.pull => l10n.homeBranchPull,
        BranchId.core => l10n.homeBranchCore,
        BranchId.legs => l10n.homeBranchLegs,
        BranchId.balance => l10n.homeBranchBalance,
      };

  int get stageCount => switch (this) {
        BranchId.push => 7,
        BranchId.pull => 6,
        BranchId.core => 6,
        BranchId.legs => 5,
        BranchId.balance => 6,
      };

  bool get requiresEquipment => this == BranchId.pull;
}