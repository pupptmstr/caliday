import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/locale_provider.dart';
import '../../../core/providers/theme_provider.dart';
import '../../../core/services/health_service.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/services/sound_service.dart';
import '../../../data/repositories/user_repository.dart';
import '../../home/providers/home_provider.dart';

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
    required this.soundEnabled,
    required this.hapticEnabled,
    required this.healthWorkoutsEnabled,
    required this.healthWeightEnabled,
    required this.displayName,
    required this.bleDiscoverable,
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
  final bool soundEnabled;
  final bool hapticEnabled;
  final bool healthWorkoutsEnabled;
  final bool healthWeightEnabled;
  final String displayName;
  final bool bleDiscoverable;

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
    bool? soundEnabled,
    bool? hapticEnabled,
    bool? healthWorkoutsEnabled,
    bool? healthWeightEnabled,
    String? displayName,
    bool? bleDiscoverable,
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
      soundEnabled: soundEnabled ?? this.soundEnabled,
      hapticEnabled: hapticEnabled ?? this.hapticEnabled,
      healthWorkoutsEnabled:
          healthWorkoutsEnabled ?? this.healthWorkoutsEnabled,
      healthWeightEnabled: healthWeightEnabled ?? this.healthWeightEnabled,
      displayName: displayName ?? this.displayName,
      bleDiscoverable: bleDiscoverable ?? this.bleDiscoverable,
    );
  }
}

// ── Notifier ──────────────────────────────────────────────────────────────────

class SettingsNotifier extends Notifier<SettingsState> {
  @override
  SettingsState build() {
    return _load(ref.read(userRepositoryProvider));
  }

  static SettingsState _load(UserRepository repo) {
    final p = repo.getProfile();
    final sound = p.soundEnabled ?? true;
    final haptic = p.hapticEnabled ?? true;
    SoundService.instance.configure(soundEnabled: sound, hapticEnabled: haptic);
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
      soundEnabled: sound,
      hapticEnabled: haptic,
      healthWorkoutsEnabled: p.healthWorkoutsEnabled ?? false,
      healthWeightEnabled: p.healthWeightEnabled ?? false,
      displayName: p.displayName ?? '',
      bleDiscoverable: p.bleDiscoverable ?? false,
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
    final p = ref.read(userRepositoryProvider).getProfile()..preferredWorkoutMinutes = minutes;
    ref.read(userRepositoryProvider).saveProfile(p);
  }

  void setLocale(String locale) {
    state = state.copyWith(locale: locale);
    final p = ref.read(userRepositoryProvider).getProfile()..locale = locale;
    ref.read(userRepositoryProvider).saveProfile(p);
    ref.read(localeProvider.notifier).set(locale);
  }

  void setThemeMode(ThemeMode mode) {
    state = state.copyWith(themeMode: mode);
    final p = ref.read(userRepositoryProvider).getProfile()..themeModeName = themeModeToString(mode);
    ref.read(userRepositoryProvider).saveProfile(p);
    ref.read(themeProvider.notifier).set(mode);
  }

  void setHasPullUpBar(bool value) {
    state = state.copyWith(hasPullUpBar: value);
    final p = ref.read(userRepositoryProvider).getProfile()..hasPullUpBar = value;
    ref.read(userRepositoryProvider).saveProfile(p);
    ref.invalidate(homeDataProvider);
  }

  void setSoundEnabled(bool value) {
    state = state.copyWith(soundEnabled: value);
    SoundService.instance.configure(
      soundEnabled: value,
      hapticEnabled: state.hapticEnabled,
    );
    final p = ref.read(userRepositoryProvider).getProfile()..soundEnabled = value;
    ref.read(userRepositoryProvider).saveProfile(p);
  }

  void setHapticEnabled(bool value) {
    state = state.copyWith(hapticEnabled: value);
    SoundService.instance.configure(
      soundEnabled: state.soundEnabled,
      hapticEnabled: value,
    );
    final p = ref.read(userRepositoryProvider).getProfile()..hapticEnabled = value;
    ref.read(userRepositoryProvider).saveProfile(p);
  }

  Future<void> setHealthWorkoutsEnabled(bool value) async {
    if (value) {
      final granted = await HealthService.instance.requestPermissions(
        readWeight: state.healthWeightEnabled,
      );
      if (!granted) return;
    }
    final p = ref.read(userRepositoryProvider).getProfile()..healthWorkoutsEnabled = value;
    ref.read(userRepositoryProvider).saveProfile(p);
    state = state.copyWith(healthWorkoutsEnabled: value);
  }

  Future<void> setHealthWeightEnabled(bool value) async {
    final p = ref.read(userRepositoryProvider).getProfile()..healthWeightEnabled = value;
    ref.read(userRepositoryProvider).saveProfile(p);
    state = state.copyWith(healthWeightEnabled: value);
  }

  void setDisplayName(String value) {
    state = state.copyWith(displayName: value);
    final p = ref.read(userRepositoryProvider).getProfile()..displayName = value;
    ref.read(userRepositoryProvider).saveProfile(p);
  }

  void setBleDiscoverable(bool value) {
    state = state.copyWith(bleDiscoverable: value);
    final p = ref.read(userRepositoryProvider).getProfile()..bleDiscoverable = value;
    ref.read(userRepositoryProvider).saveProfile(p);
  }

  void _save() {
    final p = ref.read(userRepositoryProvider).getProfile();
    p.notificationsEnabled = state.notificationsEnabled;
    p.eveningReminderEnabled = state.eveningReminderEnabled;
    p.streakThreatEnabled = state.streakThreatEnabled;
    p.notificationHour = state.notificationHour;
    p.notificationMinute = state.notificationMinute;
    ref.read(userRepositoryProvider).saveProfile(p);
    // Keep the notification schedule in sync with the new settings.
    NotificationService.instance.scheduleAll(p);
  }
}

// ── Provider ──────────────────────────────────────────────────────────────────

final settingsProvider =
    NotifierProvider<SettingsNotifier, SettingsState>(SettingsNotifier.new);
