import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/repositories/user_repository.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/onboarding/screens/onboarding_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/settings/screens/developer_options_screen.dart';
import '../../features/settings/screens/settings_screen.dart';
import '../../features/workout/screens/summary_screen.dart';
import '../../features/workout/screens/workout_screen.dart';

// ── Onboarding gate ──────────────────────────────────────────────────────────

/// Tracks whether the user has completed onboarding.
///
/// Initialised synchronously from Hive on app start.
/// Set to true by [OnboardingNotifier.completeOnboarding] at the end of the
/// onboarding flow; the router automatically redirects when it changes.
final isOnboardingCompleteProvider = StateProvider<bool>((ref) {
  return ref.read(userRepositoryProvider).hasProfile;
});

// ── Router ───────────────────────────────────────────────────────────────────

/// [ChangeNotifier] that bridges Riverpod state changes to [GoRouter].
///
/// Listens to [isOnboardingCompleteProvider] and calls [notifyListeners] so
/// that the router re-evaluates its redirect logic after onboarding finishes.
class _RouterNotifier extends ChangeNotifier {
  _RouterNotifier(this._ref) {
    _ref.listen<bool>(isOnboardingCompleteProvider, (_, _) {
      notifyListeners();
    });
  }

  final Ref _ref;

  String? redirect(BuildContext context, GoRouterState state) {
    final done = _ref.read(isOnboardingCompleteProvider);
    final onOnboarding = state.uri.path.startsWith('/onboarding');

    if (!done && !onOnboarding) return '/onboarding';
    if (done && onOnboarding) return '/home';
    return null;
  }
}

final _routerNotifierProvider = Provider<_RouterNotifier>((ref) {
  final notifier = _RouterNotifier(ref);
  ref.onDispose(notifier.dispose);
  return notifier;
});

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = ref.watch(_routerNotifierProvider);

  return GoRouter(
    initialLocation: '/home',
    refreshListenable: notifier,
    redirect: notifier.redirect,
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (_, _) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (_, _) => const HomeScreen(),
      ),
      GoRoute(
        path: '/workout',
        builder: (_, _) => const WorkoutScreen(),
      ),
      GoRoute(
        path: '/summary',
        builder: (context, state) {
          final extras =
              state.extra as Map<String, dynamic>? ?? const {};
          return SummaryScreen(extras: extras);
        },
      ),
      GoRoute(
        path: '/profile',
        builder: (_, _) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (_, _) => const SettingsScreen(),
      ),
      if (kDebugMode)
        GoRoute(
          path: '/dev-options',
          builder: (_, _) => const DeveloperOptionsScreen(),
        ),
    ],
  );
});