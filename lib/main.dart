import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:caliday/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

import 'core/providers/locale_provider.dart';
import 'core/providers/theme_provider.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/services/health_service.dart';
import 'core/services/notification_service.dart';
import 'core/services/widget_service.dart';
import 'data/models/custom_routine.dart';
import 'data/models/enums.dart';
import 'data/models/exercise_result.dart';
import 'data/models/friend_profile.dart';
import 'data/models/skill_progress.dart';
import 'data/models/user_profile.dart';
import 'data/models/workout_log.dart';
import 'data/repositories/skill_progress_repository.dart';
import 'data/repositories/user_repository.dart';
import 'data/repositories/workout_repository.dart';
import 'domain/services/streak_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientation to portrait — landscape layout is not yet designed.
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Hive.initFlutter();

  // Register all type adapters before opening any box.
  Hive
    ..registerAdapter(RankAdapter())
    ..registerAdapter(BranchIdAdapter())
    ..registerAdapter(CourseIdAdapter())
    ..registerAdapter(SetTypeAdapter())
    ..registerAdapter(ExerciseTypeAdapter())
    ..registerAdapter(FitnessGoalAdapter())
    ..registerAdapter(UserProfileAdapter())
    ..registerAdapter(SkillProgressAdapter())
    ..registerAdapter(ExerciseResultAdapter())
    ..registerAdapter(WorkoutLogAdapter())
    ..registerAdapter(FriendProfileAdapter())
    ..registerAdapter(CustomRoutineAdapter());

  // Open persistent boxes.
  await Future.wait([
    Hive.openBox<UserProfile>('user_profile'),
    Hive.openBox<SkillProgress>('skill_progress'),
    Hive.openBox<WorkoutLog>('workout_log'),
    Hive.openBox<DateTime>('achievements'),
    Hive.openBox<FriendProfile>('friends'),
    Hive.openBox<CustomRoutine>('custom_routines'),
  ]);

  // Migrate SkillProgress keys to bare branch keys (branches are global skills).
  await SkillProgressRepository().runMigrations();

  runApp(const ProviderScope(child: CaliDayApp()));
}

class CaliDayApp extends ConsumerStatefulWidget {
  const CaliDayApp({super.key});

  @override
  ConsumerState<CaliDayApp> createState() => _CaliDayAppState();
}

class _CaliDayAppState extends ConsumerState<CaliDayApp> {
  StreamSubscription<Uri>? _linkSub;

  @override
  void initState() {
    super.initState();
    // Initialise notifications after the first frame so that the Android
    // Activity is fully active before we call any platform channel methods.
    // This also ensures scheduleAll runs after permission is granted.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final ns = NotificationService.instance;
      await ns.init();
      final profile = UserRepository().getProfile();
      // Reschedule on every cold start to survive device reboots.
      await ns.scheduleAll(profile);
      // Request permission if not yet granted; re-schedule on success
      // (on Android 13+ scheduleAll above silently fails without permission).
      final granted = await ns.requestPermissionIfNeeded();
      if (granted) await ns.scheduleAll(profile);

      // Initialise Health SDK (Apple Health / Health Connect).
      await HealthService.instance.configure();

      // Initialise the Home Screen Widget and push current data.
      await WidgetService.instance.init();
      final workoutRepo = WorkoutRepository();
      final streakService = const StreakService();
      final days = streakService.daysSinceLastWorkout(profile);
      final displayStreak = (days <= 1 ||
              (days == 2 && profile.streakFreezeCount > 0))
          ? profile.currentStreak
          : 0;
      unawaited(WidgetService.instance.update(
        streak: displayStreak,
        totalSP: profile.totalSP,
        workoutDoneToday: workoutRepo.hasWorkoutToday(),
        rankName: WidgetService.rankLabel(profile.rank, ref.read(localeProvider)),
      ));

      // Handle deep links from the Home Screen Widget tap (caliday://workout).
      final appLinks = AppLinks();
      final initialLink = await appLinks.getInitialLink();
      if (initialLink != null && initialLink.scheme == 'caliday') {
        ref.read(routerProvider).go('/workout');
      }
      _linkSub = appLinks.uriLinkStream.listen((uri) {
        if (uri.scheme == 'caliday') {
          ref.read(routerProvider).go('/workout');
        }
      });
    });
  }

  @override
  void dispose() {
    _linkSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    final locale = ref.watch(localeProvider);
    final themeMode = ref.watch(themeProvider);

    return MaterialApp.router(
      title: 'CaliDay',
      debugShowCheckedModeBanner: false,
      locale: Locale(locale),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
