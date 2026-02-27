import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../data/models/user_profile.dart';

// ── Stable notification IDs ───────────────────────────────────────────────────

const int _idMorning = 1;
const int _idEvening = 2;
const int _idStreakThreat = 3;

// ── Locale-aware notification strings ────────────────────────────────────────

const _notifStrings = {
  'ru': {
    'morningTitle': 'Время тренироваться! 💪',
    'morningBody': 'Твоя ежедневная тренировка ждёт. Не прерывай серию!',
    'eveningTitle': 'Ещё не поздно! 🏃',
    'eveningBody': 'Ты сегодня ещё не тренировался. Займёт всего 10 минут.',
    'streakTitle': 'Серия под угрозой! 🔥',
    'streakBody': 'Успей потренироваться до полуночи — иначе серия прервётся.',
  },
  'en': {
    'morningTitle': 'Time to work out! 💪',
    'morningBody': 'Your daily workout is waiting. Keep the streak alive!',
    'eveningTitle': 'Still time! 🏃',
    'eveningBody': "You haven't trained today yet. It only takes 10 minutes.",
    'streakTitle': 'Streak at risk! 🔥',
    'streakBody': 'Work out before midnight or your streak will end.',
  },
};

// ── Service ───────────────────────────────────────────────────────────────────

/// Manages all local notifications for CaliDay.
///
/// Call [init] once at app startup, then [scheduleAll] whenever the
/// user's notification settings change (or at every cold start so the
/// schedule stays in sync after phone reboots).
class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  // ── Lifecycle ─────────────────────────────────────────────────────────────

  Future<void> init() async {
    if (_initialized) return;

    tz.initializeTimeZones();
    try {
      final tzInfo = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(tzInfo.identifier));
      assert(() {
        // ignore: avoid_print
        print('[NS] timezone: ${tzInfo.identifier}');
        return true;
      }());
    } catch (e) {
      // ignore: avoid_print
      print('[NS] timezone fallback to UTC: $e');
    }

    const android = AndroidInitializationSettings('ic_goro_notif');
    const darwin = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: darwin),
    );

    _initialized = true;
  }

  /// Checks current permission status and requests it if not yet granted.
  ///
  /// Returns true if permission is (now) granted. Safe to call on every app
  /// start — shows the OS dialog only once. Must be called from within the
  /// widget tree (needs an active Activity on Android).
  Future<bool> requestPermissionIfNeeded() async {
    if (!_initialized) await init();

    final android = _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      final enabled = await android.areNotificationsEnabled();
      if (enabled == true) return true;
      return requestPermission();
    }

    final ios = _plugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();
    if (ios != null) {
      final status = await ios.checkPermissions();
      if (status?.isEnabled == true) return true;
      return requestPermission();
    }

    return false;
  }

  /// Asks the OS for notification permission (iOS permission prompt).
  ///
  /// Returns true if granted. Call this once after the user enables
  /// notifications for the first time.
  Future<bool> requestPermission() async {
    if (!_initialized) await init();

    final ios = _plugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();
    if (ios != null) {
      final granted = await ios.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return granted ?? false;
    }

    final android = _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      final granted = await android.requestNotificationsPermission();
      return granted ?? false;
    }

    return false;
  }

  // ── Scheduling ────────────────────────────────────────────────────────────

  /// Cancels all existing scheduled notifications and re-creates them
  /// from [profile]. Safe to call on every cold start.
  Future<void> scheduleAll(UserProfile profile) async {
    if (!_initialized) await init();

    await _plugin.cancelAll();

    if (!profile.notificationsEnabled) return;

    final strings = _notifStrings[profile.locale ?? 'ru'] ?? _notifStrings['ru']!;
    final mode = await _getScheduleMode();
    await _scheduleMorning(
      profile.notificationHour,
      profile.notificationMinute,
      mode,
      strings,
    );
    if (profile.eveningReminderEnabled) await _scheduleEvening(mode, strings);
    if (profile.streakThreatEnabled) await _scheduleStreakThreat(mode, strings);
  }

  /// Cancels only the evening and streak-threat notifications.
  ///
  /// Called after workout completion so the user is not nagged on days
  /// they have already trained.
  Future<void> cancelDayReminders() async {
    await _plugin.cancel(_idEvening);
    await _plugin.cancel(_idStreakThreat);
  }

  /// Cancels every scheduled notification.
  Future<void> cancelAll() async => _plugin.cancelAll();

  /// Shows an immediate test notification.
  /// Returns true on success. Only call from debug code.
  Future<bool> debugShowNow() async {
    if (!_initialized) await init();
    try {
      await _plugin.show(
        99,
        'Тест уведомлений ✅',
        'Если ты видишь это — всё работает!',
        _details(channelId: 'debug', channelName: 'Debug'),
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  // ── Private helpers ───────────────────────────────────────────────────────

  Future<void> _scheduleMorning(
    int hour,
    int minute,
    AndroidScheduleMode mode,
    Map<String, String> strings,
  ) async {
    await _plugin.zonedSchedule(
      _idMorning,
      strings['morningTitle']!,
      strings['morningBody']!,
      _nextInstanceOf(hour, minute),
      _details(channelId: 'morning', channelName: 'Morning reminder'),
      androidScheduleMode: mode,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> _scheduleEvening(
    AndroidScheduleMode mode,
    Map<String, String> strings,
  ) async {
    await _plugin.zonedSchedule(
      _idEvening,
      strings['eveningTitle']!,
      strings['eveningBody']!,
      _nextInstanceOf(20, 0),
      _details(channelId: 'evening', channelName: 'Evening reminder'),
      androidScheduleMode: mode,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> _scheduleStreakThreat(
    AndroidScheduleMode mode,
    Map<String, String> strings,
  ) async {
    await _plugin.zonedSchedule(
      _idStreakThreat,
      strings['streakTitle']!,
      strings['streakBody']!,
      _nextInstanceOf(22, 0),
      _details(channelId: 'streak', channelName: 'Streak threat'),
      androidScheduleMode: mode,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  /// Returns [AndroidScheduleMode.exactAllowWhileIdle] if the app has
  /// exact-alarm permission (Android 12+), otherwise falls back to
  /// [AndroidScheduleMode.inexactAllowWhileIdle].
  Future<AndroidScheduleMode> _getScheduleMode() async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      final canExact = await android.canScheduleExactNotifications();
      if (canExact == true) return AndroidScheduleMode.exactAllowWhileIdle;
      return AndroidScheduleMode.inexactAllowWhileIdle;
    }
    // Non-Android platforms don't use this field.
    return AndroidScheduleMode.inexactAllowWhileIdle;
  }

  /// Returns the next [TZDateTime] matching the given [hour] and [minute].
  /// If that time has already passed today, returns tomorrow's instance.
  tz.TZDateTime _nextInstanceOf(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    // ignore: avoid_print
    print('[NS] scheduling $hour:${minute.toString().padLeft(2, '0')}'
        ' → $scheduled (tz: ${tz.local.name}, now: $now)');
    return scheduled;
  }

  NotificationDetails _details({
    required String channelId,
    required String channelName,
  }) {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        channelName,
        icon: 'ic_goro_notif',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: false,
        presentSound: true,
      ),
    );
  }
}

// ── Provider ──────────────────────────────────────────────────────────────────

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService.instance;
});