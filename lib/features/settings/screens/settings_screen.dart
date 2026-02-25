import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/notification_service.dart';
import '../providers/settings_provider.dart' show settingsProvider;

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);
    final scheme = Theme.of(context).colorScheme;
    final enabled = state.notificationsEnabled;

    return Scaffold(
      appBar: AppBar(title: const Text('Настройки')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 12),
          children: [
            // ── Section header ──────────────────────────────────────────
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Text(
                'УВЕДОМЛЕНИЯ',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: scheme.primary,
                ),
              ),
            ),

            // Master toggle
            _SettingsTile(
              title: 'Включить уведомления',
              subtitle: 'Разрешить приложению присылать напоминания',
              trailing: Switch(
                value: state.notificationsEnabled,
                onChanged: notifier.setNotificationsEnabled,
              ),
            ),

            const Divider(indent: 20, endIndent: 20, height: 1),

            // Notification time
            _SettingsTile(
              enabled: enabled,
              title: 'Время напоминания',
              subtitle: 'Утреннее напоминание потренироваться',
              trailing: _TimeChip(
                label: state.timeLabel,
                enabled: enabled,
              ),
              onTap: enabled
                  ? () => _showTimePicker(
                        context,
                        state.notificationHour,
                        state.notificationMinute,
                        notifier.setTime,
                      )
                  : null,
            ),

            const Divider(indent: 20, endIndent: 20, height: 1),

            // Evening reminder
            _SettingsTile(
              enabled: enabled,
              title: 'Вечерний дожим',
              subtitle: 'Напомнить вечером, если тренировка не выполнена',
              trailing: Switch(
                value: state.eveningReminderEnabled,
                onChanged: enabled ? notifier.setEveningReminder : null,
              ),
            ),

            const Divider(indent: 20, endIndent: 20, height: 1),

            // Streak threat
            _SettingsTile(
              enabled: enabled,
              title: 'Угроза стрику',
              subtitle: 'Предупредить, когда серия под угрозой',
              trailing: Switch(
                value: state.streakThreatEnabled,
                onChanged: enabled ? notifier.setStreakThreat : null,
              ),
            ),

            // ── Debug: test notification (only in debug builds) ──────────
            if (kDebugMode) ...[
              const Divider(indent: 20, endIndent: 20, height: 1),
              _SettingsTile(
                title: '[DEBUG] Тест уведомления',
                subtitle: 'Показать уведомление немедленно',
                trailing: const Icon(Icons.science_outlined),
                onTap: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  final ok = await NotificationService.instance.debugShowNow();
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text(
                        ok ? 'Уведомление отправлено!' : 'Ошибка — нет разрешения?',
                      ),
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Shared tile ───────────────────────────────────────────────────────────────

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.title,
    required this.trailing,
    this.subtitle,
    this.enabled = true,
    this.onTap,
  });

  final String title;
  final String? subtitle;
  final Widget trailing;
  final bool enabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: enabled ? null : scheme.onSurfaceVariant,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: TextStyle(
                color: enabled
                    ? scheme.onSurfaceVariant
                    : scheme.onSurfaceVariant.withAlpha(120),
                fontSize: 13,
              ),
            )
          : null,
      trailing: trailing,
      onTap: onTap,
    );
  }
}

// ── Time chip (tappable label) ────────────────────────────────────────────────

class _TimeChip extends StatelessWidget {
  const _TimeChip({required this.label, required this.enabled});

  final String label;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: enabled
            ? scheme.primaryContainer
            : scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          color: enabled ? scheme.onPrimaryContainer : scheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

// ── Time picker (Cupertino scroll wheels) ─────────────────────────────────────

Future<void> _showTimePicker(
  BuildContext context,
  int hour,
  int minute,
  void Function(int h, int m) onPicked,
) async {
  var picked = DateTime(2000, 1, 1, hour, minute);

  await showModalBottomSheet<void>(
    context: context,
    builder: (ctx) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 8, 0),
          child: Row(
            children: [
              Text(
                'Время напоминания',
                style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Готово'),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 200,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.time,
            use24hFormat: true,
            initialDateTime: picked,
            onDateTimeChanged: (dt) => picked = dt,
          ),
        ),
        const SizedBox(height: 16),
      ],
    ),
  );

  onPicked(picked.hour, picked.minute);
}