import 'dart:io';

import 'package:caliday/data/models/custom_routine.dart';
import 'package:caliday/data/models/enums.dart';
import 'package:caliday/data/models/exercise_result.dart';
import 'package:caliday/data/models/friend_profile.dart';
import 'package:caliday/data/models/skill_progress.dart';
import 'package:caliday/data/models/user_profile.dart';
import 'package:caliday/data/models/workout_log.dart';
import 'package:hive_ce/hive_ce.dart';

/// A real Hive database in a throw-away temp directory, set up the way
/// `main()` does it (same adapters, same box names).
///
/// Usage:
/// ```dart
/// late HiveTestEnv env;
/// setUp(() async => env = await HiveTestEnv.open());
/// tearDown(() => env.dispose());
/// ```
class HiveTestEnv {
  HiveTestEnv._(this.directory);

  final Directory directory;

  static Future<HiveTestEnv> open() async {
    final dir = await Directory.systemTemp.createTemp('caliday_hive_test_');
    Hive.init(dir.path);
    _registerAdapters();
    await Future.wait([
      Hive.openBox<UserProfile>('user_profile'),
      Hive.openBox<SkillProgress>('skill_progress'),
      Hive.openBox<WorkoutLog>('workout_log'),
      Hive.openBox<DateTime>('achievements'),
      Hive.openBox<FriendProfile>('friends'),
      Hive.openBox<CustomRoutine>('custom_routines'),
    ]);
    return HiveTestEnv._(dir);
  }

  /// Closes every box and deletes the directory.
  Future<void> dispose() async {
    await Hive.close();
    if (directory.existsSync()) await directory.delete(recursive: true);
  }

  /// Closes and reopens the boxes from disk, to prove data really was written
  /// through the adapters rather than just held in memory.
  Future<void> reopen() async {
    await Hive.close();
    Hive.init(directory.path);
    await Future.wait([
      Hive.openBox<UserProfile>('user_profile'),
      Hive.openBox<SkillProgress>('skill_progress'),
      Hive.openBox<WorkoutLog>('workout_log'),
      Hive.openBox<DateTime>('achievements'),
      Hive.openBox<FriendProfile>('friends'),
      Hive.openBox<CustomRoutine>('custom_routines'),
    ]);
  }

  static void _registerAdapters() {
    void register<T>(TypeAdapter<T> adapter) {
      if (!Hive.isAdapterRegistered(adapter.typeId)) {
        Hive.registerAdapter(adapter);
      }
    }

    register(RankAdapter());
    register(BranchIdAdapter());
    register(CourseIdAdapter());
    register(SetTypeAdapter());
    register(ExerciseTypeAdapter());
    register(FitnessGoalAdapter());
    register(UserProfileAdapter());
    register(SkillProgressAdapter());
    register(ExerciseResultAdapter());
    register(WorkoutLogAdapter());
    register(FriendProfileAdapter());
    register(CustomRoutineAdapter());
  }
}
