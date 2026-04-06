import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/extensions/build_context_l10n.dart';
import '../../data/models/enums.dart';
import '../../data/repositories/user_repository.dart';
import '../../features/home/screens/branch_journey_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/library/screens/library_screen.dart';
import '../../features/onboarding/screens/onboarding_screen.dart';
import '../../features/profile/screens/achievements_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/friends/screens/friends_screen.dart';
import '../../features/settings/screens/about_screen.dart';
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
    // Handle deep links from the home screen widget (caliday://workout).
    if (state.uri.scheme == 'caliday') return '/workout';

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
        path: '/branch/:branchId',
        builder: (_, state) {
          final name = state.pathParameters['branchId']!;
          final branch = BranchId.values.firstWhere(
            (b) => b.name == name,
            orElse: () => BranchId.push,
          );
          return BranchJourneyScreen(branchId: branch);
        },
      ),
      GoRoute(
        path: '/achievements',
        builder: (_, _) => const AchievementsScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (_, _) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/about',
        builder: (_, _) => const AboutScreen(),
      ),
      GoRoute(
        path: '/friends',
        builder: (_, _) => const FriendsScreen(),
      ),
      if (kDebugMode)
        GoRoute(
          path: '/dev-options',
          builder: (_, _) => const DeveloperOptionsScreen(),
        ),

      // ── Main shell with bottom navigation ──────────────────────────────
      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) => _AppShell(navigationShell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (_, _) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/library',
                builder: (_, _) => const LibraryScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (_, _) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

// ── App shell with bottom navigation bar ─────────────────────────────────────

class _AppShell extends StatelessWidget {
  const _AppShell({required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.fitness_center_outlined),
            selectedIcon: const Icon(Icons.fitness_center),
            label: l10n.navHome,
          ),
          NavigationDestination(
            icon: const Icon(Icons.menu_book_outlined),
            selectedIcon: const Icon(Icons.menu_book),
            label: l10n.navLibrary,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline_rounded),
            selectedIcon: const Icon(Icons.person_rounded),
            label: l10n.navProfile,
          ),
        ],
      ),
    );
  }
}
