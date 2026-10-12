import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/app_languages.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/services/widget_service.dart';
import '../../../core/services/widget_snapshot.dart';
import '../../../core/utils/calendar_days.dart';
import '../../../data/repositories/custom_course_repository.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../data/repositories/workout_repository.dart';
import '../../../domain/models/workout_plan.dart';
import '../../workout/providers/workout_provider.dart';
import 'home_provider.dart';

/// Hands the current state to the home-screen widgets. Pushed at start-up,
/// after a workout, after a language change and whenever the app goes to the
/// background: the day's plan follows the course, the workout size, the
/// pull-up bar and own branches, so leaving the app is when the widgets catch
/// up with any of them.
final homeWidgetSyncProvider =
    Provider<HomeWidgetSync>((ref) => HomeWidgetSync(ref));

class HomeWidgetSync {
  HomeWidgetSync(this._ref);

  final Ref _ref;

  Future<void> push() async {
    if (kIsWeb) return;
    final profile = _ref.read(userRepositoryProvider).getProfile();
    final now = DateTime.now();
    final locale = _ref.read(localeProvider);
    WorkoutPlan? plan;
    try {
      plan = buildDailyPlan(_ref);
    } catch (_) {
      // No profile yet (onboarding): the widgets show no plan.
    }
    await WidgetService.instance.update(WidgetSnapshot.build(
      profile: profile,
      logs: _ref.read(workoutRepositoryProvider).getInRange(
          addCalendarDays(now, -(WidgetSnapshot.trainedDaysKept - 1)), now),
      plan: plan,
      pace: _ref.read(workoutPaceProvider),
      courseName: _ref.read(activeCourseProvider).name(l10nFor(locale)),
      ownBranches: _ref.read(customBranchesProvider),
      now: now,
      locale: locale,
    ));
  }
}
