import '../models/enums.dart';

/// Static metadata for a single achievement.
class Achievement {
  const Achievement({
    required this.id,
    required this.emoji,
    this.isSecret = false,
    this.branch,
  });

  final String id;
  final String emoji;

  /// The branch whose stage or completion this marks; null for the
  /// achievements of the whole app (streaks, ranks, volume). The achievements
  /// screen shows the host of the branch's course on these.
  final BranchId? branch;

  /// Secret achievements are hidden until earned.
  final bool isSecret;
}

/// Complete static catalogue of all achievements.
abstract final class AchievementCatalog {
  static const List<Achievement> all = [
    // ── First steps ───────────────────────────────────────────────────────────
    Achievement(id: 'first_workout', emoji: '🐾'),
    Achievement(id: 'first_challenge', emoji: '🏆'),
    // ── Regularity ────────────────────────────────────────────────────────────
    Achievement(id: 'streak_3', emoji: '🔥'),
    Achievement(id: 'streak_7', emoji: '📅'),
    Achievement(id: 'streak_30', emoji: '🏃'),
    Achievement(id: 'streak_100', emoji: '⚡'),
    // ── Volume ────────────────────────────────────────────────────────────────
    Achievement(id: 'workouts_10', emoji: '💪'),
    Achievement(id: 'workouts_50', emoji: '🎯'),
    Achievement(id: 'workouts_100', emoji: '🏅'),
    // ── Ranks ─────────────────────────────────────────────────────────────────
    Achievement(id: 'rank_amateur', emoji: '⭐'),
    Achievement(id: 'rank_sportsman', emoji: '⭐⭐'),
    Achievement(id: 'rank_athlete', emoji: '⭐⭐⭐'),
    Achievement(id: 'rank_master', emoji: '🥇'),
    Achievement(id: 'rank_legend', emoji: '👑'),
    // ── Push ──────────────────────────────────────────────────────────────────
    Achievement(id: 'push_s3', emoji: '💥', branch: BranchId.push),
    Achievement(id: 'push_s6', emoji: '🤜', branch: BranchId.push),
    Achievement(id: 'push_complete', emoji: '🦍', branch: BranchId.push),
    // ── Core ──────────────────────────────────────────────────────────────────
    Achievement(id: 'core_s2', emoji: '🪨', branch: BranchId.core),
    Achievement(id: 'core_s5', emoji: '📐', branch: BranchId.core),
    Achievement(id: 'core_complete', emoji: '🏋️', branch: BranchId.core),
    // ── Pull ──────────────────────────────────────────────────────────────────
    Achievement(id: 'pull_s3', emoji: '🔝', branch: BranchId.pull),
    Achievement(id: 'pull_complete', emoji: '👑', branch: BranchId.pull),
    // ── Legs ──────────────────────────────────────────────────────────────────
    Achievement(id: 'legs_s5', emoji: '🦵', branch: BranchId.legs),
    Achievement(id: 'legs_complete', emoji: '🦾', branch: BranchId.legs),
    // ── Balance ───────────────────────────────────────────────────────────────
    Achievement(id: 'balance_s4', emoji: '🐦', branch: BranchId.balance),
    Achievement(id: 'balance_s6', emoji: '🤸', branch: BranchId.balance),
    Achievement(id: 'balance_complete', emoji: '⚖️', branch: BranchId.balance),
    // ── Flex ──────────────────────────────────────────────────────────────────
    Achievement(id: 'flex_complete', emoji: '🧘', branch: BranchId.flex),
    // ── Evening Stretch ───────────────────────────────────────────────────────
    Achievement(id: 'evening_back_complete', emoji: '🐈', branch: BranchId.eveningBack),
    Achievement(id: 'evening_hips_complete', emoji: '🦋', branch: BranchId.eveningHips),
    Achievement(id: 'evening_folds_complete', emoji: '🌙', branch: BranchId.eveningFolds),
    Achievement(id: 'evening_shoulders_complete', emoji: '🦅', branch: BranchId.eveningShoulders),
    // ── Morning Routine ───────────────────────────────────────────────────────
    Achievement(id: 'morning_spine_complete', emoji: '🌀', branch: BranchId.morningSpine),
    Achievement(id: 'morning_joints_complete', emoji: '⚙️', branch: BranchId.morningJoints),
    Achievement(id: 'morning_arms_complete', emoji: '🙌', branch: BranchId.morningArms),
    Achievement(id: 'morning_energy_complete', emoji: '⚡', branch: BranchId.morningEnergy),
    // ── Yoga ──────────────────────────────────────────────────────────────────
    Achievement(id: 'yoga_standing_complete', emoji: '⛰️', branch: BranchId.yogaStanding),
    Achievement(id: 'yoga_one_leg_complete', emoji: '🦩', branch: BranchId.yogaOneLeg),
    Achievement(id: 'yoga_backbends_complete', emoji: '🌈', branch: BranchId.yogaBackbends),
    Achievement(id: 'yoga_flow_complete', emoji: '☀️', branch: BranchId.yogaFlow),
    // ── Secret ────────────────────────────────────────────────────────────────
    Achievement(id: 'all_complete', emoji: '🌟', isSecret: true),
  ];

  /// Returns the achievement with [id], or null if not found.
  static Achievement? byId(String id) {
    for (final a in all) {
      if (a.id == id) return a;
    }
    return null;
  }
}
