import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/extensions/build_context_l10n.dart';
import '../../../core/l10n/app_languages.dart';
import '../../../data/models/enums.dart';
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
            // ── Theme section ─────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Text(
                l10n.settingsSectionTheme,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: scheme.primary,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: SegmentedButton<ThemeMode>(
                segments: [
                  ButtonSegment(
                    value: ThemeMode.system,
                    label: _ThemeLabel(Icons.brightness_auto_rounded, l10n.settingsThemeSystem),
                  ),
                  ButtonSegment(
                    value: ThemeMode.light,
                    label: _ThemeLabel(Icons.light_mode_rounded, l10n.settingsThemeLight),
                  ),
                  ButtonSegment(
                    value: ThemeMode.dark,
                    label: _ThemeLabel(Icons.dark_mode_rounded, l10n.settingsThemeDark),
                  ),
                ],
                selected: {state.themeMode},
                onSelectionChanged: (s) => notifier.setThemeMode(s.first),
                // The icons are part of the labels and the selected segment
                // shows no check: a segment with an icon gets fixed 12 / 16 px
                // padding (flutter/flutter#173944), which left «Системная»
                // too little room on a 375 px screen.
                showSelectedIcon: false,
                style: const ButtonStyle(
                  padding: WidgetStatePropertyAll(
                      EdgeInsets.symmetric(horizontal: 6)),
                ),
              ),
            ),

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
              subtitle: appLanguageOf(state.locale).nativeName,
              trailing: const Icon(Icons.language_rounded),
              onTap: () => _showLanguagePicker(context, state.locale, notifier.setLocale),
            ),

            // ── Equipment section ────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Text(
                l10n.settingsSectionEquipment,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: scheme.primary,
                ),
              ),
            ),

            _SettingsTile(
              title: l10n.settingsEquipmentPullUpBar,
              subtitle: l10n.settingsEquipmentPullUpBarSubtitle,
              trailing: Switch(
                value: state.hasPullUpBar,
                onChanged: notifier.setHasPullUpBar,
              ),
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
              title: l10n.settingsWorkoutSizeTitle,
              subtitle: l10n.settingsWorkoutSizeSubtitle,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
              child: SegmentedButton<WorkoutSize>(
                showSelectedIcon: false,
                segments: [
                  for (final size in WorkoutSize.values)
                    ButtonSegment(
                      value: size,
                      label: Text(size.localizedName(l10n)),
                    ),
                ],
                selected: {state.workoutSize},
                onSelectionChanged: (s) => notifier.setWorkoutSize(s.first),
              ),
            ),

            const Divider(indent: 20, endIndent: 20, height: 1),

            _SettingsTile(
              title: l10n.settingsSoundTitle,
              subtitle: l10n.settingsSoundSubtitle,
              trailing: Switch(
                value: state.soundEnabled,
                onChanged: notifier.setSoundEnabled,
              ),
            ),

            const Divider(indent: 20, endIndent: 20, height: 1),

            _SettingsTile(
              title: l10n.settingsHapticTitle,
              subtitle: l10n.settingsHapticSubtitle,
              trailing: Switch(
                value: state.hapticEnabled,
                onChanged: notifier.setHapticEnabled,
              ),
            ),

            // Health and notifications are native-only (no web support).
            if (!kIsWeb) ...[
              // ── Health section ───────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Text(
                  l10n.settingsSectionHealth,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                    color: scheme.primary,
                  ),
                ),
              ),

              _SettingsTile(
                title: l10n.settingsHealthWorkoutsTitle,
                subtitle: l10n.settingsHealthWorkoutsSubtitle,
                trailing: Switch(
                  value: state.healthWorkoutsEnabled,
                  onChanged: notifier.setHealthWorkoutsEnabled,
                ),
              ),

              const Divider(indent: 20, endIndent: 20, height: 1),

              _SettingsTile(
                enabled: state.healthWorkoutsEnabled,
                title: l10n.settingsHealthWeightTitle,
                subtitle: l10n.settingsHealthWeightSubtitle,
                trailing: Switch(
                  value: state.healthWeightEnabled,
                  onChanged: state.healthWorkoutsEnabled
                      ? notifier.setHealthWeightEnabled
                      : null,
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
            ],

            // ── Friends section ──────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Text(
                l10n.settingsSectionFriends,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: scheme.primary,
                ),
              ),
            ),

            _SettingsTile(
              title: l10n.settingsFriendsNameTitle,
              subtitle: state.displayName.isEmpty
                  ? l10n.settingsFriendsNamePlaceholder
                  : state.displayName,
              trailing: const Icon(Icons.edit_outlined),
              onTap: () => _showNameEditor(
                  context, state.displayName, notifier.setDisplayName),
            ),

            // BLE discovery is not available in browsers.
            if (!kIsWeb) ...[
              const Divider(indent: 20, endIndent: 20, height: 1),

              _SettingsTile(
                title: l10n.settingsFriendsDiscoverableTitle,
                subtitle: l10n.settingsFriendsDiscoverableSubtitle,
                trailing: Switch(
                  value: state.bleDiscoverable,
                  onChanged: notifier.setBleDiscoverable,
                ),
              ),
            ],

            // ── About section ─────────────────────────────────────────────
            const Divider(indent: 20, endIndent: 20, height: 1),
            _SettingsTile(
              title: l10n.settingsAbout,
              trailing: const Icon(Icons.info_outlined),
              onTap: () => context.push('/about'),
            ),

            // ── Debug section (only in debug builds) ─────────────────────
            if (kDebugMode) ...[
              const Divider(indent: 20, endIndent: 20, height: 1),
              _SettingsTile(
                title: '[DEBUG] Возможности разработчика',
                subtitle: 'Прямое управление состоянием приложения',
                trailing: const Icon(Icons.developer_mode_rounded),
                onTap: () => context.push('/dev-options'),
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
      title: Text(context.l10n.settingsLanguageTitle),
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
            children: [
              for (final language in appLanguages)
                RadioListTile<String>(
                  title: Text('${language.flag}  ${language.nativeName}'),
                  value: language.code,
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
    this.trailing,
    this.subtitle,
    this.enabled = true,
    this.onTap,
  });

  final String title;
  final String? subtitle;
  final Widget? trailing;
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

// ── Display name editor ───────────────────────────────────────────────────────

Future<void> _showNameEditor(
  BuildContext context,
  String current,
  void Function(String) onSaved,
) async {
  final controller = TextEditingController(text: current);
  final result = await showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(context.l10n.settingsFriendsNameTitle),
      content: TextField(
        controller: controller,
        maxLength: 30,
        autofocus: true,
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(
          hintText: context.l10n.settingsFriendsNamePlaceholder,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(null),
          child: Text(context.l10n.friendsCancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(ctx).pop(controller.text.trim()),
          child: Text(context.l10n.settingsTimePickerDone),
        ),
      ],
    ),
  );
  if (result != null) onSaved(result);
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

/// A theme segment's icon and name on one line; the name shrinks a little
/// rather than break mid-word.
class _ThemeLabel extends StatelessWidget {
  const _ThemeLabel(this.icon, this.text);

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 6),
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(text, maxLines: 1),
            ),
          ),
        ],
      );
}
