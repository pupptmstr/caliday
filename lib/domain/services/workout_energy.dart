/// How much energy a workout is worth in Apple Health / Health Connect, and
/// which body weight to base it on. Pure: HealthService only reads the
/// measurements from the plugin and writes the result back.
abstract final class WorkoutEnergy {
  /// Used when the user has no (usable) weight measurement.
  static const defaultWeightKg = 70.0;

  /// MET of a strength-training session (Compendium of Physical Activities,
  /// "resistance training, vigorous effort" ~5.5).
  static const strengthMet = 5.5;

  /// Weights outside this range are measurement or unit mistakes, not people.
  static const minPlausibleWeightKg = 20.0;
  static const maxPlausibleWeightKg = 400.0;

  /// MET formula: kcal = MET × weight (kg) × duration (hours). A negative
  /// duration is treated as zero.
  static double kcal({
    required int durationSec,
    required double weightKg,
    double met = strengthMet,
  }) =>
      met * weightKg * (durationSec < 0 ? 0 : durationSec) / 3600.0;

  /// The weight to use for [measured] (null: no measurement): [measured] when
  /// it is a plausible body weight, otherwise [defaultWeightKg].
  static double resolveWeightKg(double? measured) {
    if (measured == null || !measured.isFinite) return defaultWeightKg;
    if (measured < minPlausibleWeightKg || measured > maxPlausibleWeightKg) {
      return defaultWeightKg;
    }
    return measured;
  }

  /// The most recent usable weight among [samples] (a time and a value in kg;
  /// null values are samples that were not a number), or null when there is
  /// none. Samples may come in any order.
  static double? latestWeightKg(
      Iterable<({DateTime at, double? kg})> samples) {
    ({DateTime at, double kg})? latest;
    for (final s in samples) {
      final kg = s.kg;
      if (kg == null || !kg.isFinite || kg <= 0) continue;
      if (latest == null || s.at.isAfter(latest.at)) {
        latest = (at: s.at, kg: kg);
      }
    }
    return latest?.kg;
  }
}
