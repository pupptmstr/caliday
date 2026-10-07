import 'package:caliday/data/models/enums.dart';
import 'package:caliday/data/models/workout_log.dart';
import 'package:caliday/data/repositories/workout_repository.dart';
import 'package:caliday/data/static/supplementary_exercise_catalog.dart';
import 'package:caliday/features/home/providers/home_provider.dart';
import 'package:caliday/features/workout/providers/workout_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/hive_test_env.dart';

/// The time on the Home button is the time of the plan the workout screen
/// then runs, so the two have to build the very same plan, each on its own.
void main() {
  late HiveTestEnv env;
  setUp(() async => env = await HiveTestEnv.open());
  tearDown(() => env.dispose());

  final supplementary = SupplementaryExerciseCatalog.all.map((e) => e.id).toSet();

  /// What Home shows and what the workout screen runs, from a fresh start.
  ({List<String> home, List<String> run, int homeSec, int runSec}) plans() {
    final home = ProviderContainer();
    final run = ProviderContainer();
    addTearDown(home.dispose);
    addTearDown(run.dispose);
    home.listen(todayPlanProvider, (_, _) {});
    run.listen(workoutProvider, (_, _) {});
    final homePlan = home.read(todayPlanProvider);
    final runPlan = run.read(workoutProvider).plan;
    return (
      home: homePlan.exercises.map((e) => e.exercise.id).toList(),
      run: runPlan.exercises.map((e) => e.exercise.id).toList(),
      homeSec: homePlan.estimatedDurationSec,
      runSec: runPlan.estimatedDurationSec,
    );
  }

  Future<void> logWorkout({required bool primary}) =>
      WorkoutRepository().addLog(WorkoutLog(
        date: DateTime.now(),
        setType: SetType.daily,
        exercises: const [],
        spEarned: 0,
        durationSec: 300,
        isPrimary: primary,
      ));

  test('the day\'s own workout: Home and the workout screen agree', () {
    final p = plans();
    expect(p.run, p.home);
    expect(p.runSec, p.homeSec);
    expect(p.home.where(supplementary.contains), isEmpty);
  });

  test('a bonus workout: the same two supplementary exercises on both sides', () async {
    await logWorkout(primary: true);
    final p = plans();
    expect(p.run, p.home);
    expect(p.runSec, p.homeSec);
    expect(p.home.where(supplementary.contains), hasLength(2));
  });

  test('every further bonus workout agrees too, whatever it picked', () async {
    await logWorkout(primary: true);
    for (var n = 0; n < 4; n++) {
      await logWorkout(primary: false);
      final p = plans();
      expect(p.run, p.home, reason: 'after ${n + 2} workouts');
      expect(p.runSec, p.homeSec);
    }
  });

  test('a finished workout invalidating Home gives the next plan', () async {
    final home = ProviderContainer();
    addTearDown(home.dispose);
    home.listen(todayPlanProvider, (_, _) {});
    expect(home.read(todayPlanProvider).exercises.map((e) => e.exercise.id).where(supplementary.contains),
        isEmpty,
        reason: 'before the primary workout');

    await logWorkout(primary: true);
    home.invalidate(homeDataProvider); // what _finishWorkout does
    expect(home.read(todayPlanProvider).exercises.map((e) => e.exercise.id).where(supplementary.contains),
        hasLength(2),
        reason: 'after it, the bonus workout');
  });
}
