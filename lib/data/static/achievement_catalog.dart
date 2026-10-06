/// Static metadata for a single achievement.
class Achievement {
  const Achievement({
    required this.id,
    required this.emoji,
    this.isSecret = false,
  });

  final String id;
  final String emoji;

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
    Achievement(id: 'push_s3', emoji: '💥'),
    Achievement(id: 'push_s6', emoji: '🤜'),
    Achievement(id: 'push_complete', emoji: '🦍'),
    // ── Core ──────────────────────────────────────────────────────────────────
    Achievement(id: 'core_s2', emoji: '🪨'),
    Achievement(id: 'core_s5', emoji: '📐'),
    Achievement(id: 'core_complete', emoji: '🏋️'),
    // ── Pull ──────────────────────────────────────────────────────────────────
    Achievement(id: 'pull_s3', emoji: '🔝'),
    Achievement(id: 'pull_complete', emoji: '👑'),
    // ── Legs ──────────────────────────────────────────────────────────────────
    Achievement(id: 'legs_s5', emoji: '🦵'),
    Achievement(id: 'legs_complete', emoji: '🦾'),
    // ── Balance ───────────────────────────────────────────────────────────────
    Achievement(id: 'balance_s4', emoji: '🐦'),
    Achievement(id: 'balance_s6', emoji: '🤸'),
    Achievement(id: 'balance_complete', emoji: '⚖️'),
    // ── Flex ──────────────────────────────────────────────────────────────────
    Achievement(id: 'flex_complete', emoji: '🧘'),
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
