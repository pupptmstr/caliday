import 'package:home_widget/home_widget.dart';

import '../../data/models/enums.dart';

/// Communicates with the native Home Screen Widget (iOS WidgetKit + Android AppWidgetProvider).
///
/// Call [init] once at app startup, then [update] after any data change
/// (workout completion, app open).
class WidgetService {
  WidgetService._();
  static final WidgetService instance = WidgetService._();

  static const _appGroupId = 'group.com.pupptmstr.caliday';
  static const _iOSName = 'CaliDayWidget';
  static const _androidName = 'com.pupptmstr.caliday.CaliDayWidgetReceiver';
  static const _androidNameMedium =
      'com.pupptmstr.caliday.CaliDayWidgetMediumReceiver';

  /// Must be called once during app startup (before any [update] calls).
  Future<void> init() async {
    await HomeWidget.setAppGroupId(_appGroupId);
  }

  /// Saves widget data and triggers a native widget refresh.
  Future<void> update({
    required int streak,
    required int totalSP,
    required bool workoutDoneToday,
    required String rankName,
  }) async {
    try {
      await HomeWidget.saveWidgetData<int>('streak', streak);
      await HomeWidget.saveWidgetData<int>('totalSP', totalSP);
      await HomeWidget.saveWidgetData<bool>('workoutDoneToday', workoutDoneToday);
      await HomeWidget.saveWidgetData<String>('rankName', rankName);
      await HomeWidget.updateWidget(
        iOSName: _iOSName,
        qualifiedAndroidName: _androidName,
      );
      await HomeWidget.updateWidget(qualifiedAndroidName: _androidNameMedium);
    } catch (_) {
      // Widget update is best-effort; never crash the app.
    }
  }

  /// Returns a locale-aware rank display name for use in the widget
  /// (no BuildContext required).
  static String rankLabel(Rank rank, String locale) {
    if (locale == 'ru') {
      return switch (rank) {
        Rank.beginner => 'Новичок',
        Rank.amateur => 'Любитель',
        Rank.sportsman => 'Спортсмен',
        Rank.athlete => 'Атлет',
        Rank.master => 'Мастер',
        Rank.legend => 'Легенда',
      };
    }
    return switch (rank) {
      Rank.beginner => 'Beginner',
      Rank.amateur => 'Amateur',
      Rank.sportsman => 'Athlete',
      Rank.athlete => 'Champion',
      Rank.master => 'Master',
      Rank.legend => 'Legend',
    };
  }
}
