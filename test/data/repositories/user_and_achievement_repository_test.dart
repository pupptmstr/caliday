import 'package:caliday/data/models/enums.dart';
import 'package:caliday/data/static/course_catalog.dart';
import 'package:caliday/data/models/user_profile.dart';
import 'package:caliday/data/repositories/achievement_repository.dart';
import 'package:caliday/data/repositories/user_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive_ce.dart';

import '../../helpers/hive_test_env.dart';

void main() {
  late HiveTestEnv env;
  setUp(() async => env = await HiveTestEnv.open());
  tearDown(() => env.dispose());

  group('UserRepository', () {
    test('returns a fresh default profile that is not stored yet', () {
      final repo = UserRepository();
      expect(repo.hasProfile, isFalse);
      final p = repo.getProfile();
      expect(p.rank, Rank.beginner);
      expect(p.totalSP, 0);
      expect(p.currentStreak, 0);
      expect(p.notificationsEnabled, isTrue);
      expect(repo.hasProfile, isFalse, reason: 'reading must not persist');
    });

    test('every field survives a write / close / reopen cycle', () async {
      final saved = UserProfile(
        rank: Rank.athlete,
        totalSP: 5230,
        currentStreak: 12,
        longestStreak: 30,
        streakFreezeCount: 2,
        lastWorkoutDate: DateTime(2026, 6, 10),
        notificationHour: 7,
        notificationMinute: 45,
        notificationsEnabled: false,
        eveningReminderEnabled: false,
        streakThreatEnabled: false,
        locale: 'en',
        preferredWorkoutMinutes: 15,
        themeModeName: 'dark',
        hasPullUpBar: true,
        soundEnabled: false,
        hapticEnabled: false,
        healthWorkoutsEnabled: true,
        healthWeightEnabled: true,
        peerId: 'peer-1',
        displayName: 'Goro',
        bleDiscoverable: true,
        activeCourseIds: [0, 1],
        activeCourseIndex: 1,
        lastSeenReleaseVersion: '0.8.12',
      );
      await UserRepository().saveProfile(saved);

      await env.reopen();
      final repo = UserRepository();
      expect(repo.hasProfile, isTrue);
      final p = repo.getProfile();
      expect(p.rank, Rank.athlete);
      expect(p.totalSP, 5230);
      expect(p.currentStreak, 12);
      expect(p.longestStreak, 30);
      expect(p.streakFreezeCount, 2);
      expect(p.lastWorkoutDate, DateTime(2026, 6, 10));
      expect(p.notificationHour, 7);
      expect(p.notificationMinute, 45);
      expect(p.notificationsEnabled, isFalse);
      expect(p.eveningReminderEnabled, isFalse);
      expect(p.streakThreatEnabled, isFalse);
      expect(p.locale, 'en');
      expect(p.preferredWorkoutMinutes, 15);
      expect(p.themeModeName, 'dark');
      expect(p.hasPullUpBar, isTrue);
      expect(p.soundEnabled, isFalse);
      expect(p.hapticEnabled, isFalse);
      expect(p.healthWorkoutsEnabled, isTrue);
      expect(p.healthWeightEnabled, isTrue);
      expect(p.peerId, 'peer-1');
      expect(p.displayName, 'Goro');
      expect(p.bleDiscoverable, isTrue);
      expect(p.activeCourseIds, [0, 1]);
      expect(p.activeCourseIndex, 1);
      expect(p.lastSeenReleaseVersion, '0.8.12');
    });

    test('optional fields stay null through a round trip', () async {
      await UserRepository().saveProfile(UserProfile());
      await env.reopen();
      final p = UserRepository().getProfile();
      expect(p.lastWorkoutDate, isNull);
      expect(p.locale, isNull);
      expect(p.hasPullUpBar, isNull);
      expect(p.soundEnabled, isNull);
      expect(p.activeCourseIds, isNull);
      expect(p.activeCourseIndex, isNull);
      expect(p.lastSeenReleaseVersion, isNull);
    });
  });

  group('UserProfile course helpers', () {
    test('no enrolled courses means calisthenics', () {
      expect(UserProfile().enrolledCourses, [CourseId.calisthenics]);
      expect(UserProfile(activeCourseIds: []).enrolledCourses,
          [CourseId.calisthenics]);
    });

    test('ignores course indices that no longer exist', () {
      expect(UserProfile(activeCourseIds: [1, 99, -1]).enrolledCourses,
          [CourseId.healthyBody]);
    });

    test('activeCourse follows the index and falls back to the first course', () {
      final both = UserProfile(activeCourseIds: [0, 1]);
      expect(both.activeCourse, CourseId.calisthenics);
      both.activeCourseIndex = 1;
      expect(both.activeCourse, CourseId.healthyBody);
      both.activeCourseIndex = 5;
      expect(both.activeCourse, CourseId.calisthenics);
    });

    test('pull-up-bar branches are hidden unless the user has a bar', () {
      final noBar = UserProfile(hasPullUpBar: false);
      expect(noBar.branchesForCourse(CourseId.calisthenics),
          isNot(contains(BranchId.pull)));
      expect(UserProfile().branchesForCourse(CourseId.calisthenics),
          isNot(contains(BranchId.pull)),
          reason: 'null means no bar');
      expect(UserProfile(hasPullUpBar: true).branchesForCourse(CourseId.calisthenics),
          contains(BranchId.pull));
    });

    test('activeBranches merges the enrolled courses without duplicates', () {
      final both = UserProfile(activeCourseIds: [0, 1], hasPullUpBar: true);
      final branches = both.activeBranches;
      expect(branches.toSet(), {
        ...CourseCatalog.branchesFor(CourseId.calisthenics),
        ...CourseCatalog.branchesFor(CourseId.healthyBody),
      });
      expect(branches.where((b) => b == BranchId.flex), hasLength(1));

      final all = UserProfile(activeCourseIds: [0, 1, 2, 3], hasPullUpBar: true);
      expect(all.activeBranches.toSet(), BranchId.values.toSet());
    });
  });

  group('AchievementRepository', () {
    late AchievementRepository repo;
    setUp(() => repo = AchievementRepository());

    test('starts empty', () {
      expect(repo.getAllEarnedIds(), isEmpty);
      expect(repo.isEarned('first_workout'), isFalse);
      expect(repo.earnedAt('first_workout'), isNull);
    });

    test('markEarned records the time once and never moves it', () async {
      await repo.markEarned('first_workout');
      final first = repo.earnedAt('first_workout')!;
      expect(repo.isEarned('first_workout'), isTrue);
      await Future<void>.delayed(const Duration(milliseconds: 5));
      await repo.markEarned('first_workout');
      expect(repo.earnedAt('first_workout'), first);
      expect(repo.getAllEarnedIds(), ['first_workout']);
    });

    test('earned ids come back newest first, with their dates', () async {
      final box = Hive.box<DateTime>('achievements');
      await box.put('streak_3', DateTime(2026, 6, 3));
      await box.put('first_workout', DateTime(2026, 6, 1));
      await box.put('workouts_10', DateTime(2026, 6, 9));

      expect(repo.getAllEarnedIds(), ['workouts_10', 'streak_3', 'first_workout']);
      expect(repo.getAllEarned()['streak_3'], DateTime(2026, 6, 3));
    });

    test('earned achievements survive a reopen', () async {
      await repo.markEarned('push_s3');
      await env.reopen();
      expect(AchievementRepository().isEarned('push_s3'), isTrue);
    });
  });
}
