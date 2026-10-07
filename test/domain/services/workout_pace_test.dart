import 'package:caliday/data/models/enums.dart';
import 'package:caliday/data/models/workout_log.dart';
import 'package:caliday/domain/services/workout_pace.dart';
import 'package:flutter_test/flutter_test.dart';

/// A finished workout that was estimated at [estimated] s and took [actual] s.
WorkoutLog _log(int day, {required int estimated, required int actual}) =>
    WorkoutLog(
      date: DateTime(2026, 6, day),
      setType: SetType.daily,
      exercises: const [],
      spEarned: 0,
      durationSec: actual,
      estimatedDurationSec: estimated,
    );

/// [count] workouts a day apart, all with the same ratio [actual] / 600.
List<WorkoutLog> _same(int count, {required int actual, int firstDay = 1}) => [
      for (var i = 0; i < count; i++)
        _log(firstDay + i, estimated: 600, actual: actual),
    ];

void main() {
  group('factorFrom', () {
    test('no workouts, or too few, say nothing: 1.0', () {
      expect(WorkoutPace.factorFrom(const []), 1.0);
      expect(WorkoutPace.factorFrom(_same(WorkoutPace.minSamples - 1, actual: 900)), 1.0);
    });

    test('from minSamples on, the ratio of real to estimated time', () {
      expect(WorkoutPace.factorFrom(_same(WorkoutPace.minSamples, actual: 750)),
          closeTo(1.25, 1e-9));
      expect(WorkoutPace.factorFrom(_same(5, actual: 480)), closeTo(0.8, 1e-9));
    });

    test('the median ignores one odd workout', () {
      final logs = [
        _log(1, estimated: 600, actual: 600), // 1.0
        _log(2, estimated: 600, actual: 660), // 1.1
        _log(3, estimated: 600, actual: 3000), // 5.0: a phone call
      ];
      expect(WorkoutPace.factorFrom(logs), closeTo(1.1, 1e-9));
    });

    test('an even count averages the two middle ratios', () {
      final logs = [
        _log(1, estimated: 100, actual: 100), // 1.0
        _log(2, estimated: 100, actual: 120), // 1.2
        _log(3, estimated: 100, actual: 140), // 1.4
        _log(4, estimated: 100, actual: 160), // 1.6
      ];
      expect(WorkoutPace.factorFrom(logs), closeTo(1.3, 1e-9));
    });

    test('the factor stays inside its range', () {
      expect(WorkoutPace.factorFrom(_same(4, actual: 3000)), WorkoutPace.maxFactor);
      expect(WorkoutPace.factorFrom(_same(4, actual: 60)), WorkoutPace.minFactor);
    });

    test('only the newest workouts count, whatever the order they come in', () {
      final old = _same(8, actual: 1200, firstDay: 1); // 2.0, days 1..8
      final recent = _same(WorkoutPace.window, actual: 600, firstDay: 10); // 1.0
      final shuffled = [...recent.reversed, ...old]..shuffle();
      expect(WorkoutPace.factorFrom(shuffled), closeTo(1.0, 1e-9));
    });

    test('workouts without an estimate, or without a time, are skipped', () {
      final legacy = WorkoutLog(
        date: DateTime(2026, 6, 20),
        setType: SetType.daily,
        exercises: const [],
        spEarned: 0,
        durationSec: 900,
      );
      final zeroTime = _log(21, estimated: 600, actual: 0);
      final zeroEstimate = _log(22, estimated: 0, actual: 600);
      final logs = [legacy, zeroTime, zeroEstimate, ..._same(2, actual: 900)];
      expect(WorkoutPace.samplesFrom(logs), hasLength(2),
          reason: 'only the two real samples');
      expect(WorkoutPace.factorFrom(logs), 1.0, reason: 'two is below minSamples');

      // The skipped ones do not count towards the minimum either, but they
      // do not poison the rest.
      expect(WorkoutPace.factorFrom([...logs, ..._same(1, actual: 900, firstDay: 5)]),
          closeTo(1.5, 1e-9));
    });
  });
}
