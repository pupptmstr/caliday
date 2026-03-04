import 'package:home_widget/home_widget.dart';

/// Communicates with the native Home Screen Widget (iOS WidgetKit + Android Glance).
///
/// Call [init] once at app startup, then [update] after any data change
/// (workout completion, app open).
class WidgetService {
  WidgetService._();
  static final WidgetService instance = WidgetService._();

  static const _appGroupId = 'group.com.pupptmstr.caliday';
  static const _iOSName = 'CaliDayWidget';
  static const _androidName = 'com.pupptmstr.caliday.CaliDayWidgetReceiver';

  /// Must be called once during app startup (before any [update] calls).
  Future<void> init() async {
    await HomeWidget.setAppGroupId(_appGroupId);
  }

  /// Saves widget data and triggers a native widget refresh.
  Future<void> update({
    required int streak,
    required int totalSP,
    required bool workoutDoneToday,
  }) async {
    try {
      await HomeWidget.saveWidgetData<int>('streak', streak);
      await HomeWidget.saveWidgetData<int>('totalSP', totalSP);
      await HomeWidget.saveWidgetData<bool>('workoutDoneToday', workoutDoneToday);
      await HomeWidget.updateWidget(
        iOSName: _iOSName,
        androidName: _androidName,
      );
    } catch (_) {
      // Widget update is best-effort; never crash the app.
    }
  }
}
