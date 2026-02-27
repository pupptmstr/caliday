import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/build_context_l10n.dart';
import '../../../core/services/notification_service.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../data/repositories/workout_repository.dart';
import '../../home/providers/home_provider.dart';
import '../providers/settings_provider.dart' show settingsProvider;

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);
    final scheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;
    final enabled = state.notificationsEnabled;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 12),
          children: [
            // ── Language section ────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Text(
                l10n.settingsSectionLanguage,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: scheme.primary,
                ),
              ),
            ),

            _SettingsTile(
              title: l10n.settingsLanguageTitle,
              subtitle: state.locale == 'ru' ? 'Русский' : 'English',
              trailing: const Icon(Icons.language_rounded),
              onTap: () => _showLanguagePicker(context, state.locale, notifier.setLocale),
            ),

            // ── Workout section ──────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Text(
                l10n.settingsSectionWorkout,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: scheme.primary,
                ),
              ),
            ),

            _SettingsTile(
              title: l10n.settingsWorkoutDurationTitle,
              subtitle: l10n.settingsWorkoutDurationSubtitle,
              trailing: _MinuteChips(
                selected: state.preferredWorkoutMinutes,
                onSelect: notifier.setWorkoutMinutes,
              ),
            ),

            // ── Notifications section ────────────────────────────────────
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Text(
                l10n.settingsSectionNotifications,
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
              title: l10n.settingsNotificationsTitle,
              subtitle: l10n.settingsNotificationsSubtitle,
              trailing: Switch(
                value: state.notificationsEnabled,
                onChanged: notifier.setNotificationsEnabled,
              ),
            ),

            const Divider(indent: 20, endIndent: 20, height: 1),

            // Notification time
            _SettingsTile(
              enabled: enabled,
              title: l10n.settingsNotificationTimeTitle,
              subtitle: l10n.settingsNotificationTimeSubtitle,
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
              title: l10n.settingsEveningReminderTitle,
              subtitle: l10n.settingsEveningReminderSubtitle,
              trailing: Switch(
                value: state.eveningReminderEnabled,
                onChanged: enabled ? notifier.setEveningReminder : null,
              ),
            ),

            const Divider(indent: 20, endIndent: 20, height: 1),

            // Streak threat
            _SettingsTile(
              enabled: enabled,
              title: l10n.settingsStreakThreatTitle,
              subtitle: l10n.settingsStreakThreatSubtitle,
              trailing: Switch(
                value: state.streakThreatEnabled,
                onChanged: enabled ? notifier.setStreakThreat : null,
              ),
            ),

            // ── Debug section (only in debug builds) ─────────────────────
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
              const Divider(indent: 20, endIndent: 20, height: 1),
              _SettingsTile(
                title: '[DEBUG] Симулировать пропуск дня',
                subtitle: 'lastWorkoutDate = позавчера → заморозка потратится',
                trailing: const Icon(Icons.ac_unit_outlined),
                onTap: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  final userRepo = ref.read(userRepositoryProvider);
                  final workoutRepo = ref.read(workoutRepositoryProvider);

                  final profile = userRepo.getProfile();
                  final twoDaysAgo = DateTime.now().subtract(
                    const Duration(days: 2),
                  );
                  profile.lastWorkoutDate = DateTime(
                    twoDaysAgo.year,
                    twoDaysAgo.month,
                    twoDaysAgo.day,
                  );
                  userRepo.saveProfile(profile);

                  await workoutRepo.deleteForDate(DateTime.now());

                  ref.invalidate(homeDataProvider);

                  messenger.showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Пропуск симулирован — пройди тренировку, заморозка потратится ✓',
                      ),
                    ),
                  );
                },
              ),
              const Divider(indent: 20, endIndent: 20, height: 1),
              _SettingsTile(
                title: '[DEBUG] Стрик → 6, сброс тренировки',
                subtitle: 'Стрик = 6 вчера, сегодняшняя тренировка удалена',
                trailing: const Icon(Icons.replay_outlined),
                onTap: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  final userRepo = ref.read(userRepositoryProvider);
                  final workoutRepo = ref.read(workoutRepositoryProvider);

                  final profile = userRepo.getProfile();
                  final yesterday = DateTime.now().subtract(
                    const Duration(days: 1),
                  );
                  profile.currentStreak = 6;
                  profile.lastWorkoutDate = DateTime(
                    yesterday.year,
                    yesterday.month,
                    yesterday.day,
                  );
                  userRepo.saveProfile(profile);

                  await workoutRepo.deleteForDate(DateTime.now());

                  ref.invalidate(homeDataProvider);

                  messenger.showSnackBar(
                    const SnackBar(
                      content: Text('Стрик = 6, тренировка сброшена ✓'),
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

// ── Language picker ────────────────────────────────────────────────────────────

Future<void> _showLanguagePicker(
  BuildContext context,
  String currentLocale,
  void Function(String) onPicked,
) async {
  await showDialog<void>(
    context: context,
    builder: (ctx) => SimpleDialog(
      title: const Text('🌐  Язык / Language'),
      children: [
        RadioGroup<String>(
          groupValue: currentLocale,
          onChanged: (v) {
            if (v != null) {
              onPicked(v);
              Navigator.of(ctx).pop();
            }
          },
          child: Column(
            children: const [
              RadioListTile<String>(
                title: Text('🇷🇺  Русский'),
                value: 'ru',
              ),
              RadioListTile<String>(
                title: Text('🇬🇧  English'),
                value: 'en',
              ),
            ],
          ),
        ),
      ],
    ),
  );
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

// ── Minute chips (5 / 10 / 15) ───────────────────────────────────────────────

class _MinuteChips extends StatelessWidget {
  const _MinuteChips({required this.selected, required this.onSelect});

  final int selected;
  final void Function(int) onSelect;

  static const _options = [5, 10, 15];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: _options.map((min) {
        final isSelected = min == selected;
        return Padding(
          padding: const EdgeInsets.only(left: 6),
          child: GestureDetector(
            onTap: () => onSelect(min),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: isSelected
                    ? scheme.primary
                    : scheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$min',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: isSelected
                      ? scheme.onPrimary
                      : scheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
        );
      }).toList(),
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
                context.l10n.settingsNotificationTimeTitle,
                style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text(context.l10n.settingsTimePickerDone),
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
