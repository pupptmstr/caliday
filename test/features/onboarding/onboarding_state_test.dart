import 'package:caliday/data/models/enums.dart';
import 'package:caliday/data/repositories/user_repository.dart';
import 'package:caliday/data/static/release_notes_catalog.dart';
import 'package:caliday/features/onboarding/providers/onboarding_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/hive_test_env.dart';

/// The choices of the onboarding steps have to reach the end: the state is
/// copied by hand in `withHasPullUpBar`, which silently drops a field it does
/// not list.
void main() {
  // The locale provider reads the platform locale from the binding.
  TestWidgetsFlutterBinding.ensureInitialized();

  test('every choice survives the pull-up bar answer', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final notifier = container.read(onboardingProvider.notifier);

    notifier.setDisplayName('Goro');
    notifier.selectPushupCount(PushupCount.oneToFive);
    notifier.selectWorkoutSize(WorkoutSize.standard);
    notifier.toggleCourse(CourseId.healthyBody);
    notifier.selectHealthEnabled(true);
    notifier.selectReminderTime(7, 30);
    notifier.selectHasPullUpBar(true);

    final s = container.read(onboardingProvider);
    expect(s.displayName, 'Goro');
    expect(s.pushupCount, PushupCount.oneToFive);
    expect(s.workoutSize, WorkoutSize.standard);
    expect(s.selectedCourseIds, [CourseId.calisthenics, CourseId.healthyBody]);
    expect(s.healthEnabled, isTrue);
    expect((s.reminderHour, s.reminderMinute), (7, 30));
    expect(s.hasPullUpBar, isTrue);
  });

  test('the size is part of what a step needs to continue', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final notifier = container.read(onboardingProvider.notifier);

    notifier.selectPushupCount(PushupCount.zero);
    notifier.nextStep(); // name
    notifier.nextStep(); // push-ups
    notifier.nextStep(); // size
    expect(container.read(onboardingProvider).step, 3);
    expect(container.read(onboardingProvider).canAdvance, isFalse,
        reason: 'no size chosen yet');

    notifier.selectWorkoutSize(WorkoutSize.short);
    expect(container.read(onboardingProvider).canAdvance, isTrue);
  });

  test('a new user starts with the current "What\'s new" seen: no dot on the bell', () async {
    final env = await HiveTestEnv.open();
    addTearDown(env.dispose);
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final notifier = container.read(onboardingProvider.notifier);
    notifier.selectPushupCount(PushupCount.zero);
    notifier.selectWorkoutSize(WorkoutSize.standard);
    notifier.selectHasPullUpBar(false);

    await notifier.completeOnboarding();

    final profile = UserRepository().getProfile();
    expect(profile.lastSeenReleaseVersion, ReleaseNotesCatalog.latest.version);
    expect(ReleaseNotesCatalog.unseenSince(profile.lastSeenReleaseVersion), isEmpty);
  });
}
