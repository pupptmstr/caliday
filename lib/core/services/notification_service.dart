import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../data/models/user_profile.dart';
import '../../domain/services/notification_planner.dart';
import '../../l10n/app_localizations.dart';

// ── Service ───────────────────────────────────────────────────────────────────

/// Hands local notifications to the OS.
///
/// What to schedule and when is decided by [NotificationPlanner] (pure and
/// tested); this class only talks to the plugin.
///
/// Call [init] once at app startup, then [scheduleAll] whenever the
/// user's notification settings change (or at every cold start so the
/// schedule stays in sync after phone reboots).
///
/// On web the service is a no-op: browsers can't schedule notifications for
/// future delivery without a push server.
class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final _plugin = FlutterLocalNotificationsPlugin();
  final _planner = const NotificationPlanner();
  bool _initialized = false;

  // ── Lifecycle ─────────────────────────────────────────────────────────────

  Future<void> init() async {
    if (kIsWeb || _initialized) return;

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
      settings: const InitializationSettings(android: android, iOS: darwin),
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
  ///
  /// The plan includes the one-off alerts (streak lost, rank at risk): the
  /// cancelAll() above wipes the ones the last workout scheduled, so they have
  /// to be re-created on every rescheduling.
  Future<void> scheduleAll(UserProfile profile) async {
    if (kIsWeb) return;
    if (!_initialized) await init();

    await _plugin.cancelAll();
    await _schedule(_planner.planAll(profile, tz.TZDateTime.now(tz.local)));
  }

  /// Cancels day-specific notifications (evening, streak threat, streak lost).
  ///
  /// Called after workout completion so the user is not nagged on days
  /// they have already trained, and so a previously scheduled streak-lost
  /// alert is cleared when the next workout happens.
  Future<void> cancelDayReminders() async {
    await _plugin.cancel(id: NotificationKind.evening.id);
    await _plugin.cancel(id: NotificationKind.streakThreat.id);
    await _plugin.cancel(id: NotificationKind.streakLost.id);
  }

  /// Cancels every scheduled notification.
  Future<void> cancelAll() async => _plugin.cancelAll();

  /// Schedules the one-time "streak lost" alert after a workout (see
  /// [NotificationPlanner.streakLost] for when it applies).
  Future<void> scheduleStreakLost(UserProfile profile) async {
    if (kIsWeb) return;
    if (!_initialized) await init();
    final alert = _planner.streakLost(profile, tz.TZDateTime.now(tz.local));
    if (alert != null) await _schedule([alert]);
  }

  /// Schedules the one-time "rank at risk" alert after a workout (see
  /// [NotificationPlanner.rankAtRisk]). Scheduling it again replaces it.
  Future<void> scheduleRankAtRisk(UserProfile profile) async {
    if (kIsWeb) return;
    if (!_initialized) await init();
    final alert = _planner.rankAtRisk(profile, tz.TZDateTime.now(tz.local));
    if (alert != null) await _schedule([alert]);
  }

  Future<void> _schedule(List<PlannedNotification> notifications) async {
    if (notifications.isEmpty) return;
    final mode = await _getScheduleMode();
    for (final n in notifications) {
      await _plugin.zonedSchedule(
        id: n.kind.id,
        title: n.title,
        body: n.body,
        scheduledDate: n.when,
        notificationDetails: _details(
          channelId: n.kind.channelId,
          channelName: n.kind.channelName,
        ),
        androidScheduleMode: mode,
        matchDateTimeComponents:
            n.repeatsDaily ? DateTimeComponents.time : null,
      );
    }
  }

  // ── Debug ─────────────────────────────────────────────────────────────────

  /// Shows an immediate test notification.
  /// Returns true on success. Only call from debug code.
  Future<bool> debugShowNow() async {
    if (!_initialized) await init();
    try {
      await _plugin.show(
        id: 99,
        title: 'Тест уведомлений ✅',
        body: 'Если ты видишь это — всё работает!',
        notificationDetails: _details(channelId: 'debug', channelName: 'Debug'),
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Fires one of the real notification types immediately for testing.
  /// Only call from debug code.
  Future<bool> debugShowMorning(UserProfile p) => _debugFireNow(
      NotificationKind.morning,
      p,
      (t) => (t.notificationMorningTitle, t.notificationMorningBody));

  Future<bool> debugShowEvening(UserProfile p) => _debugFireNow(
      NotificationKind.evening,
      p,
      (t) => (t.notificationEveningTitle, t.notificationEveningBody));

  Future<bool> debugShowStreakThreat(UserProfile p) => _debugFireNow(
      NotificationKind.streakThreat,
      p,
      (t) => (t.notificationStreakTitle, t.notificationStreakBody));

  Future<bool> debugShowStreakLost(UserProfile p) => _debugFireNow(
      NotificationKind.streakLost,
      p,
      (t) => (
            t.notificationStreakLostTitle,
            t.notificationStreakLostBody(p.currentStreak)
          ));

  Future<bool> debugShowRankAtRisk(UserProfile p) => _debugFireNow(
      NotificationKind.rankAtRisk,
      p,
      (t) => (t.notificationRankAtRiskTitle, t.notificationRankAtRiskBody));

  Future<bool> _debugFireNow(NotificationKind kind, UserProfile p,
      (String, String) Function(AppLocalizations) texts) async {
    if (!_initialized) await init();
    try {
      final (title, body) = texts(NotificationPlanner.textsFor(p.locale));
      await _plugin.show(
        id: kind.id,
        title: title,
        body: body,
        notificationDetails: _details(channelId: 'debug', channelName: 'Debug'),
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Returns all currently pending (scheduled) notification requests.
  Future<List<PendingNotificationRequest>> pendingRequests() =>
      _plugin.pendingNotificationRequests();

  // ── Private helpers ───────────────────────────────────────────────────────

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
