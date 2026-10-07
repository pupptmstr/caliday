import '../../data/models/workout_log.dart';
import '../models/workout_plan.dart';

/// How fast this user is compared with [WorkoutPlan.estimatedDurationSec].
///
/// The estimate has to guess the one thing nobody times, the pace of a rep,
/// and the time between exercises, skipped rests and pauses are the user's
/// own. Every finished workout stores the raw estimate of its plan next to the
/// time it really took ([WorkoutLog.estimatedDurationSec] / `durationSec`); the
/// ratio of the two, taken over the last few workouts, scales the estimate
/// shown on the Home button. Pure: the logs go in, a number comes out.
abstract final class WorkoutPace {
  /// How many of the most recent workouts count.
  static const int window = 7;

  /// Fewer workouts than this say nothing yet: the estimate stays as it is.
  static const int minSamples = 3;

  /// The factor never leaves this range: one odd workout (a phone call in the
  /// middle) must not make "≈ 9 min" read 3 min or 30.
  static const double minFactor = 0.6;
  static const double maxFactor = 1.6;

  /// The workouts that tell something: the newest [window] of those that
  /// recorded an estimate and took a real time, newest first.
  static List<WorkoutLog> samplesFrom(Iterable<WorkoutLog> logs) {
    final usable = logs
        .where((l) => (l.estimatedDurationSec ?? 0) > 0 && l.durationSec > 0)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    return usable.length <= window ? usable : usable.sublist(0, window);
  }

  /// The pace factor: 1.0 is "as estimated", 1.25 "a quarter slower". The
  /// median of the ratios (robust against the odd long workout), clamped to
  /// [minFactor]..[maxFactor]; 1.0 until there are [minSamples] workouts.
  static double factorFrom(Iterable<WorkoutLog> logs) {
    final samples = samplesFrom(logs);
    if (samples.length < minSamples) return 1.0;
    final ratios = [
      for (final l in samples) l.durationSec / l.estimatedDurationSec!,
    ]..sort();
    final mid = ratios.length ~/ 2;
    final median = ratios.length.isOdd
        ? ratios[mid]
        : (ratios[mid - 1] + ratios[mid]) / 2;
    return median.clamp(minFactor, maxFactor);
  }
}
