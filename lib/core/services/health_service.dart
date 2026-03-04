import 'package:health/health.dart';

/// Wraps the `health` package for writing workout sessions and active energy
/// to Apple Health (iOS) or Google Health Connect (Android).
class HealthService {
  HealthService._();
  static final instance = HealthService._();

  final _health = Health();

  Future<void> configure() async {
    try {
      await _health.configure().timeout(const Duration(seconds: 5));
    } catch (_) {
      // Ignore timeout or errors — app continues without Health integration
    }
  }

  /// Requests write access to WORKOUT + TOTAL_CALORIES_BURNED, and optionally
  /// read access to WEIGHT. Returns true if all permissions were granted.
  Future<bool> requestPermissions({bool readWeight = false}) async {
    final types = [
      HealthDataType.WORKOUT,
      HealthDataType.TOTAL_CALORIES_BURNED,
      if (readWeight) HealthDataType.WEIGHT,
    ];
    final perms = [
      HealthDataAccess.WRITE,
      HealthDataAccess.WRITE,
      if (readWeight) HealthDataAccess.READ,
    ];
    try {
      return await _health.requestAuthorization(types, permissions: perms);
    } catch (_) {
      return false;
    }
  }

  /// Writes a strength-training workout session with calorie data.
  Future<bool> writeWorkout({
    required DateTime start,
    required DateTime end,
    required double calories,
  }) async {
    try {
      return await _health.writeWorkoutData(
        activityType: HealthWorkoutActivityType.STRENGTH_TRAINING,
        start: start,
        end: end,
        totalEnergyBurned: calories.round(),
        totalEnergyBurnedUnit: HealthDataUnit.KILOCALORIE,
      );
    } catch (_) {
      return false;
    }
  }

  /// Reads the most recent body-weight measurement (within last 90 days).
  /// Returns null if no data is available or permission is not granted.
  Future<double?> readBodyWeight() async {
    try {
      final data = await _health.getHealthDataFromTypes(
        startTime: DateTime.now().subtract(const Duration(days: 90)),
        endTime: DateTime.now(),
        types: [HealthDataType.WEIGHT],
      );
      if (data.isEmpty) return null;
      data.sort((a, b) => b.dateFrom.compareTo(a.dateFrom));
      final v = data.first.value;
      return v is NumericHealthValue ? v.numericValue.toDouble() : null;
    } catch (_) {
      return null;
    }
  }

  /// Estimates active energy burned using the MET formula:
  /// kcal = MET × weightKg × durationHours
  double calculateCalories({
    required int durationSec,
    required double weightKg,
    double met = 5.5,
  }) =>
      met * weightKg * (durationSec / 3600.0);
}
