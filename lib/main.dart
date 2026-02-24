import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/router/app_router.dart';
import 'core/services/notification_service.dart';
import 'data/models/enums.dart';
import 'data/models/exercise_result.dart';
import 'data/models/skill_progress.dart';
import 'data/models/user_profile.dart';
import 'data/models/workout_log.dart';
import 'data/repositories/user_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  // Register all type adapters before opening any box.
  Hive
    ..registerAdapter(RankAdapter())
    ..registerAdapter(BranchIdAdapter())
    ..registerAdapter(SetTypeAdapter())
    ..registerAdapter(ExerciseTypeAdapter())
    ..registerAdapter(UserProfileAdapter())
    ..registerAdapter(SkillProgressAdapter())
    ..registerAdapter(ExerciseResultAdapter())
    ..registerAdapter(WorkoutLogAdapter());

  // Open persistent boxes.
  await Future.wait([
    Hive.openBox<UserProfile>('user_profile'),
    Hive.openBox<SkillProgress>('skill_progress'),
    Hive.openBox<WorkoutLog>('workout_log'),
  ]);

  // Initialise notification plugin and reschedule daily reminders.
  // Rescheduling on every cold start keeps the schedule intact after reboots.
  final ns = NotificationService.instance;
  await ns.init();
  final profile = UserRepository().getProfile();
  await ns.scheduleAll(profile);

  runApp(const ProviderScope(child: CaliDayApp()));
}

class CaliDayApp extends ConsumerStatefulWidget {
  const CaliDayApp({super.key});

  @override
  ConsumerState<CaliDayApp> createState() => _CaliDayAppState();
}

class _CaliDayAppState extends ConsumerState<CaliDayApp> {
  @override
  void initState() {
    super.initState();
    // Request notification permission after the first frame so that
    // an Android Activity is fully active before we call the plugin.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final ns = NotificationService.instance;
      final granted = await ns.requestPermissionIfNeeded();
      // On Android 13+, scheduleAll in main() runs before permission is
      // granted and silently fails. Re-schedule now that we have permission.
      if (granted) {
        final profile = UserRepository().getProfile();
        await ns.scheduleAll(profile);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'CaliDay',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF58CC02)),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}