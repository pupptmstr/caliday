import 'package:flutter/foundation.dart';
import 'package:home_widget/home_widget.dart';

import '../../data/models/enums.dart';
import '../l10n/app_languages.dart';

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

  /// Saves widget data and triggers a native widget refresh. The texts are
  /// written in [locale] (see [texts]).
  Future<void> update({
    required int streak,
    required int totalSP,
    required bool workoutDoneToday,
    required Rank rank,
    required String locale,
  }) async {
    if (kIsWeb) return;
    try {
      await HomeWidget.saveWidgetData<int>('streak', streak);
      await HomeWidget.saveWidgetData<int>('totalSP', totalSP);
      await HomeWidget.saveWidgetData<bool>('workoutDoneToday', workoutDoneToday);
      await _saveTexts(rank, locale);
      await _refresh();
    } catch (_) {
      // Widget update is best-effort; never crash the app.
    }
  }

  /// Re-sends only the texts, after the user changed the app language.
  Future<void> updateTexts({required Rank rank, required String locale}) async {
    if (kIsWeb) return;
    try {
      await _saveTexts(rank, locale);
      await _refresh();
    } catch (_) {
      // Widget update is best-effort; never crash the app.
    }
  }

  /// Everything the widget shows as text, keyed as the native widgets read it.
  /// The widgets have no strings of their own (native resources would follow
  /// the system language, not the one picked in the app), so the texts come
  /// from the ARB files of [locale]; English for a language the app does not
  /// have. The only exception is the iOS gallery description, shown before the
  /// app has ever run (see `CaliDayWidget.swift`).
  static Map<String, String> texts(Rank rank, String locale) {
    final l10n = l10nFor(locale);
    return {
      'rankName': rank.localizedName(l10n),
      'doneLabel': l10n.widgetDoneLabel,
    };
  }

  Future<void> _saveTexts(Rank rank, String locale) async {
    for (final MapEntry(:key, :value) in texts(rank, locale).entries) {
      await HomeWidget.saveWidgetData<String>(key, value);
    }
  }

  Future<void> _refresh() async {
    await HomeWidget.updateWidget(
      iOSName: _iOSName,
      qualifiedAndroidName: _androidName,
    );
    await HomeWidget.updateWidget(qualifiedAndroidName: _androidNameMedium);
  }
}
