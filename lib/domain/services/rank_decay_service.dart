import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/enums.dart';
import '../../data/models/user_profile.dart';

/// Computes rank decay for inactive users.
///
/// Rank is NEVER stored in a decayed state — [UserProfile.rank] always reflects
/// the highest rank earned by SP. Decay is display-only: [effectiveRank] returns
/// the rank the user *sees*, which may be lower than the earned rank when they
/// have been inactive.
///
/// On the next workout, [SPService.applyToProfile] recalculates rank from SP,
/// which immediately restores the full earned rank.
class RankDecayService {
  const RankDecayService();

  /// Days of inactivity before the first rank drop.
  static const warningDays = 14;

  /// Thresholds (days of inactivity) at which each extra tier is lost.
  /// Gaps accelerate: 21 → 35 → 45 → 53 → 59 (gaps: 14, 10, 8, 6).
  static const _decayThresholds = [21, 35, 45, 53, 59];

  /// Number of rank tiers to subtract for [daysSinceLastWorkout] days of inactivity.
  int decayTiers(int daysSinceLastWorkout) {
    var tiers = 0;
    for (final threshold in _decayThresholds) {
      if (daysSinceLastWorkout >= threshold) {
        tiers++;
      } else {
        break;
      }
    }
    return tiers;
  }

  /// Effective rank to display. May be lower than [earnedRank] after inactivity.
  Rank effectiveRank(Rank earnedRank, int daysSinceLastWorkout) {
    final tiers = decayTiers(daysSinceLastWorkout);
    if (tiers == 0) return earnedRank;
    final idx = (earnedRank.index - tiers).clamp(0, Rank.values.length - 1);
    return Rank.values[idx];
  }

  /// Whether a decay warning should be shown (14–20 days inactive).
  bool isWarning(int daysSinceLastWorkout) =>
      daysSinceLastWorkout >= warningDays &&
      daysSinceLastWorkout < _decayThresholds[0];

  /// Whether rank is actively decayed (21+ days inactive).
  bool isDecayed(int daysSinceLastWorkout) =>
      daysSinceLastWorkout >= _decayThresholds[0];

  /// Days until the first decay kicks in, or 0 if already decayed.
  int daysUntilFirstDecay(int daysSinceLastWorkout) =>
      (_decayThresholds[0] - daysSinceLastWorkout).clamp(0, _decayThresholds[0]);

  /// Returns days since last workout. -1 if never trained.
  ///
  /// [now] is injectable for tests; defaults to the current time.
  int daysSinceLastWorkout(UserProfile profile, {DateTime? now}) {
    final last = profile.lastWorkoutDate;
    if (last == null) return -1;
    final today = now ?? DateTime.now();
    // UTC dates, not local midnights: across a DST change two local midnights
    // are 23 or 25 hours apart and `inDays` would truncate 14 days to 13.
    final todayOnly = DateTime.utc(today.year, today.month, today.day);
    final lastOnly = DateTime.utc(last.year, last.month, last.day);
    return todayOnly.difference(lastOnly).inDays;
  }
}

final rankDecayServiceProvider =
    Provider<RankDecayService>((_) => const RankDecayService());