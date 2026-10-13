import 'package:flutter/foundation.dart';
import 'package:home_widget/home_widget.dart';

/// Communicates with the native home-screen widgets (iOS WidgetKit, Android
/// AppWidgetProvider): writes a [WidgetSnapshot] and asks every widget to
/// redraw. What they show is decided in `widget_snapshot.dart`.
///
/// Call [init] once at app startup, then [update] (through
/// `HomeWidgetSync.push`) after any change the widgets show.
class WidgetService {
  WidgetService._();
  static final WidgetService instance = WidgetService._();

  static const _appGroupId = 'group.com.pupptmstr.treniday';

  /// The widget kinds on iOS (`TreniDayWidget.swift`) and their providers on
  /// Android, in the same order: Today, Goro, Streak, Rank.
  static const iOSKinds = [
    'TreniDayWidget',
    'TreniDayGoroWidget',
    'TreniDayStreakWidget',
    'TreniDayRankWidget',
  ];
  static const androidProviders = [
    'com.pupptmstr.treniday.TreniDayWidgetReceiver',
    'com.pupptmstr.treniday.GoroWidgetReceiver',
    'com.pupptmstr.treniday.StreakWidgetReceiver',
    'com.pupptmstr.treniday.RankWidgetReceiver',
  ];

  /// Must be called once during app startup (before any [update] calls).
  Future<void> init() async {
    await HomeWidget.setAppGroupId(_appGroupId);
  }

  /// Saves [snapshot] (`WidgetSnapshot.build`) and redraws every widget.
  Future<void> update(Map<String, Object> snapshot) async {
    if (kIsWeb) return;
    try {
      for (final MapEntry(:key, :value) in snapshot.entries) {
        await HomeWidget.saveWidgetData<Object>(key, value);
      }
      for (var i = 0; i < iOSKinds.length; i++) {
        await HomeWidget.updateWidget(
          iOSName: iOSKinds[i],
          qualifiedAndroidName: androidProviders[i],
        );
      }
    } catch (_) {
      // Widget update is best-effort; never crash the app.
    }
  }
}
