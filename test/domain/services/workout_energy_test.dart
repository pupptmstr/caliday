import 'package:caliday/domain/services/workout_energy.dart';
import 'package:flutter_test/flutter_test.dart';

({DateTime at, double? kg}) sample(int day, double? kg) =>
    (at: DateTime(2026, 6, day, 8), kg: kg);

void main() {
  group('kcal (MET × kg × hours)', () {
    test('an hour at 70 kg is MET × 70', () {
      expect(WorkoutEnergy.kcal(durationSec: 3600, weightKg: 70), 5.5 * 70);
    });

    test('scales with the duration and the weight', () {
      final base = WorkoutEnergy.kcal(durationSec: 1200, weightKg: 70);
      expect(base, closeTo(5.5 * 70 / 3, 1e-9));
      expect(WorkoutEnergy.kcal(durationSec: 2400, weightKg: 70), closeTo(base * 2, 1e-9));
      expect(WorkoutEnergy.kcal(durationSec: 1200, weightKg: 140), closeTo(base * 2, 1e-9));
    });

    test('a different MET', () {
      expect(WorkoutEnergy.kcal(durationSec: 3600, weightKg: 60, met: 8), 480);
    });

    test('zero or negative durations are zero, never negative energy', () {
      expect(WorkoutEnergy.kcal(durationSec: 0, weightKg: 70), 0);
      expect(WorkoutEnergy.kcal(durationSec: -300, weightKg: 70), 0);
    });

    test('a typical 12-minute session is a believable number', () {
      final kcal = WorkoutEnergy.kcal(durationSec: 12 * 60, weightKg: 75);
      expect(kcal, inInclusiveRange(60, 100));
    });
  });

  group('resolveWeightKg', () {
    test('a plausible measurement is used as it is', () {
      expect(WorkoutEnergy.resolveWeightKg(82.5), 82.5);
      expect(WorkoutEnergy.resolveWeightKg(WorkoutEnergy.minPlausibleWeightKg),
          WorkoutEnergy.minPlausibleWeightKg);
      expect(WorkoutEnergy.resolveWeightKg(WorkoutEnergy.maxPlausibleWeightKg),
          WorkoutEnergy.maxPlausibleWeightKg);
    });

    test('no measurement falls back to the default', () {
      expect(WorkoutEnergy.resolveWeightKg(null), WorkoutEnergy.defaultWeightKg);
    });

    test('nonsense falls back to the default: zero, negative, NaN, grams, pounds-in-grams', () {
      for (final bad in [0.0, -70.0, double.nan, double.infinity, 5.0, 82000.0, 401.0]) {
        expect(WorkoutEnergy.resolveWeightKg(bad), WorkoutEnergy.defaultWeightKg,
            reason: '$bad');
      }
    });
  });

  group('latestWeightKg', () {
    test('the newest sample wins, whatever the order', () {
      expect(WorkoutEnergy.latestWeightKg([sample(1, 80), sample(9, 78), sample(5, 79)]), 78);
      expect(WorkoutEnergy.latestWeightKg([sample(9, 78), sample(5, 79), sample(1, 80)]), 78);
    });

    test('no samples: null', () {
      expect(WorkoutEnergy.latestWeightKg(const []), isNull);
    });

    test('samples that are not numbers are skipped, not allowed to hide older ones', () {
      expect(WorkoutEnergy.latestWeightKg([sample(1, 80), sample(9, null)]), 80);
      expect(WorkoutEnergy.latestWeightKg([sample(9, null)]), isNull);
    });

    test('zero, negative and NaN samples are skipped', () {
      expect(
          WorkoutEnergy.latestWeightKg(
              [sample(1, 80), sample(5, 0), sample(7, -3), sample(9, double.nan)]),
          80);
    });

    test('two samples at the same moment: either, but a number', () {
      final at = DateTime(2026, 6, 1);
      expect(WorkoutEnergy.latestWeightKg([(at: at, kg: 70.0), (at: at, kg: 71.0)]),
          anyOf(70.0, 71.0));
    });
  });
}
