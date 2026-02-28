import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/locale_provider.dart';
import '../../../core/providers/theme_provider.dart';
import '../../../core/services/notification_service.dart';
import '../../../data/repositories/user_repository.dart';

// ── State ─────────────────────────────────────────────────────────────────────

class SettingsState {
  const SettingsState({
    required this.notificationsEnabled,
    required this.eveningReminderEnabled,
    required this.streakThreatEnabled,
    required this.notificationHour,
    required this.notificationMinute,
    required this.locale,
    required this.preferredWorkoutMinutes,
    required this.themeMode,
    required this.hasPullUpBar,
  });

  final bool notificationsEnabled;
  final bool eveningReminderEnabled;
  final bool streakThreatEnabled;
  final int notificationHour;
  final int notificationMinute;
  final String locale;
  final int preferredWorkoutMinutes;
  final ThemeMode themeMode;
  final bool hasPullUpBar;

  /// Notification time as a zero-padded string, e.g. "09:00".
  String get timeLabel {
    final h = notificationHour.toString().padLeft(2, '0');
    final m = notificationMinute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  SettingsState copyWith({
    bool? notificationsEnabled,
    bool? eveningReminderEnabled,
    bool? streakThreatEnabled,
    int? notificationHour,
    int? notificationMinute,
    String? locale,
    int? preferredWorkoutMinutes,
    ThemeMode? themeMode,
    bool? hasPullUpBar,
  }) {
    return SettingsState(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      eveningReminderEnabled:
          eveningReminderEnabled ?? this.eveningReminderEnabled,
      streakThreatEnabled: streakThreatEnabled ?? this.streakThreatEnabled,
      notificationHour: notificationHour ?? this.notificationHour,
      notificationMinute: notificationMinute ?? this.notificationMinute,
      locale: locale ?? this.locale,
      preferredWorkoutMinutes:
          preferredWorkoutMinutes ?? this.preferredWorkoutMinutes,
      themeMode: themeMode ?? this.themeMode,
      hasPullUpBar: hasPullUpBar ?? this.hasPullUpBar,
    );
  }
}

// ── Notifier ──────────────────────────────────────────────────────────────────

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier(this._userRepo, this._ref) : super(_load(_userRepo));

  final UserRepository _userRepo;
  final Ref _ref;

  static SettingsState _load(UserRepository repo) {
    final p = repo.getProfile();
    return SettingsState(
      notificationsEnabled: p.notificationsEnabled,
      eveningReminderEnabled: p.eveningReminderEnabled,
      streakThreatEnabled: p.streakThreatEnabled,
      notificationHour: p.notificationHour,
      notificationMinute: p.notificationMinute,
      locale: p.locale ?? 'ru',
      preferredWorkoutMinutes: p.preferredWorkoutMinutes ?? 10,
      themeMode: themeModeFromString(p.themeModeName),
      hasPullUpBar: p.hasPullUpBar ?? false,
    );
  }

  void setNotificationsEnabled(bool value) {
    state = state.copyWith(notificationsEnabled: value);
    _save();
    // Request OS permission the first time the user enables notifications.
    if (value) NotificationService.instance.requestPermission();
  }

  void setEveningReminder(bool value) {
    state = state.copyWith(eveningReminderEnabled: value);
    _save();
  }

  void setStreakThreat(bool value) {
    state = state.copyWith(streakThreatEnabled: value);
    _save();
  }

  void setTime(int hour, int minute) {
    state = state.copyWith(notificationHour: hour, notificationMinute: minute);
    _save();
  }

  void setWorkoutMinutes(int minutes) {
    state = state.copyWith(preferredWorkoutMinutes: minutes);
    final p = _userRepo.getProfile()..preferredWorkoutMinutes = minutes;
    _userRepo.saveProfile(p);
  }

  void setLocale(String locale) {
    state = state.copyWith(locale: locale);
    final p = _userRepo.getProfile()..locale = locale;
    _userRepo.saveProfile(p);
    _ref.read(localeProvider.notifier).state = locale;
  }

  void setThemeMode(ThemeMode mode) {
    state = state.copyWith(themeMode: mode);
    final p = _userRepo.getProfile()..themeModeName = themeModeToString(mode);
    _userRepo.saveProfile(p);
    _ref.read(themeProvider.notifier).state = mode;
  }

  void setHasPullUpBar(bool value) {
    state = state.copyWith(hasPullUpBar: value);
    final p = _userRepo.getProfile()..hasPullUpBar = value;
    _userRepo.saveProfile(p);
  }

  void _save() {
    final p = _userRepo.getProfile();
    p.notificationsEnabled = state.notificationsEnabled;
    p.eveningReminderEnabled = state.eveningReminderEnabled;
    p.streakThreatEnabled = state.streakThreatEnabled;
    p.notificationHour = state.notificationHour;
    p.notificationMinute = state.notificationMinute;
    _userRepo.saveProfile(p);
    // Keep the notification schedule in sync with the new settings.
    NotificationService.instance.scheduleAll(p);
  }
}

// ── Provider ──────────────────────────────────────────────────────────────────

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier(ref.watch(userRepositoryProvider), ref);
});
