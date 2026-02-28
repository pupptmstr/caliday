import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../../core/router/app_router.dart';
import '../../../core/services/notification_service.dart';
import '../../../data/models/enums.dart';
import '../../../data/models/skill_progress.dart';
import '../../../data/models/user_profile.dart';
import '../../../data/models/workout_log.dart';
import '../../../data/repositories/skill_progress_repository.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../data/repositories/workout_repository.dart';
import '../../home/providers/home_provider.dart';

class DeveloperOptionsScreen extends ConsumerStatefulWidget {
  const DeveloperOptionsScreen({super.key});

  @override
  ConsumerState<DeveloperOptionsScreen> createState() =>
      _DeveloperOptionsScreenState();
}

class _DeveloperOptionsScreenState
    extends ConsumerState<DeveloperOptionsScreen> {
  late UserProfile _profile;
  late Map<BranchId, SkillProgress> _progressMap;

  @override
  void initState() {
    super.initState();
    final userRepo = ref.read(userRepositoryProvider);
    final progressRepo = ref.read(skillProgressRepositoryProvider);
    _profile = userRepo.getProfile();
    _progressMap = {
      for (final b in BranchId.values) b: progressRepo.getProgress(b),
    };
  }

  void _snack(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<bool?> _confirm(String title, String body) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Да'),
          ),
        ],
      ),
    );
  }

  // ── Profile section ────────────────────────────────────────────────────────

  Widget _buildProfileSection() {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader('ПРОФИЛЬ'),

        // Streak stepper
        _DevRow(
          label: 'Стрик',
          child: _Stepper(
            value: _profile.currentStreak,
            min: 0,
            max: 365,
            onChanged: (v) => setState(() => _profile.currentStreak = v),
          ),
        ),

        // Last workout date chips
        _DevRow(
          label: 'Последняя тренировка',
          child: _ChipRow<int>(
            values: const [0, 1, 2, 3, -1],
            selected: _lastWorkoutDaysAgo(),
            label: (v) => switch (v) {
              0 => 'Сегодня',
              1 => 'Вчера',
              2 => '2 дня',
              3 => '3 дня',
              _ => 'Никогда',
            },
            onSelect: (v) => setState(() {
              if (v == -1) {
                _profile.lastWorkoutDate = null;
              } else {
                final d = DateTime.now().subtract(Duration(days: v));
                _profile.lastWorkoutDate =
                    DateTime(d.year, d.month, d.day);
              }
            }),
          ),
        ),

        // SP stepper
        _DevRow(
          label: 'SP',
          child: _Stepper(
            value: _profile.totalSP,
            min: 0,
            max: 99999,
            step: 100,
            allowEdit: true,
            onChanged: (v) => setState(() => _profile.totalSP = v),
          ),
        ),

        // Freeze chips
        _DevRow(
          label: 'Заморозки',
          child: _ChipRow<int>(
            values: const [0, 1, 2, 3],
            selected: _profile.streakFreezeCount,
            label: (v) => '$v',
            onSelect: (v) =>
                setState(() => _profile.streakFreezeCount = v),
          ),
        ),

        // Rank dropdown
        _DevRow(
          label: 'Ранг',
          child: DropdownButton<Rank>(
            value: _profile.rank,
            isDense: true,
            underline: const SizedBox(),
            items: Rank.values
                .map((r) => DropdownMenuItem(
                      value: r,
                      child: Text(r.displayName),
                    ))
                .toList(),
            onChanged: (r) {
              if (r != null) setState(() => _profile.rank = r);
            },
          ),
        ),

        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saveProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: scheme.primary,
                foregroundColor: scheme.onPrimary,
              ),
              child: const Text('Сохранить профиль'),
            ),
          ),
        ),
      ],
    );
  }

  int _lastWorkoutDaysAgo() {
    final d = _profile.lastWorkoutDate;
    if (d == null) return -1;
    final today = DateTime.now();
    final diff = DateTime(today.year, today.month, today.day)
        .difference(DateTime(d.year, d.month, d.day))
        .inDays;
    if (diff == 0) return 0;
    if (diff == 1) return 1;
    if (diff == 2) return 2;
    if (diff == 3) return 3;
    return -1;
  }

  void _saveProfile() {
    ref.read(userRepositoryProvider).saveProfile(_profile);
    ref.invalidate(homeDataProvider);
    _snack('Профиль сохранён ✓');
  }

  // ── Branch progress section ────────────────────────────────────────────────

  Widget _buildBranchSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader('ПРОГРЕСС ВЕТОК'),
        for (final branch in BranchId.values) _buildBranchCard(branch),
      ],
    );
  }

  static int _maxStage(BranchId b) => switch (b) {
        BranchId.push => 7,
        BranchId.core => 6,
        BranchId.pull => 6,
        BranchId.legs => 5,
        BranchId.balance => 6,
      };

  static String _branchLabel(BranchId b) => switch (b) {
        BranchId.push => 'Push',
        BranchId.core => 'Core',
        BranchId.pull => 'Pull',
        BranchId.legs => 'Legs',
        BranchId.balance => 'Balance',
      };

  Widget _buildBranchCard(BranchId branch) {
    final progress = _progressMap[branch]!;
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        elevation: 0,
        color: scheme.surfaceContainerHighest,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _branchLabel(branch),
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 8),
              _DevRow(
                label: 'Этап',
                child: _Stepper(
                  value: progress.currentStage,
                  min: 1,
                  max: _maxStage(branch),
                  onChanged: (v) =>
                      setState(() => progress.currentStage = v),
                ),
              ),
              _DevRow(
                label: 'Повторения',
                child: _Stepper(
                  value: progress.currentReps,
                  min: 1,
                  max: 200,
                  onChanged: (v) =>
                      setState(() => progress.currentReps = v),
                ),
              ),
              _DevRow(
                label: 'Подходы',
                child: _ChipRow<int>(
                  values: const [1, 2, 3],
                  selected: progress.currentSets,
                  label: (v) => '$v',
                  onSelect: (v) =>
                      setState(() => progress.currentSets = v),
                ),
              ),
              _DevRow(
                label: 'Challenge',
                child: Switch(
                  value: progress.isChallengeUnlocked,
                  onChanged: (v) =>
                      setState(() => progress.isChallengeUnlocked = v),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => _saveBranch(branch),
                  child: Text('Сохранить ${_branchLabel(branch)}'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveBranch(BranchId branch) {
    ref
        .read(skillProgressRepositoryProvider)
        .saveProgress(_progressMap[branch]!);
    ref.invalidate(homeDataProvider);
    _snack('${_branchLabel(branch)} сохранён ✓');
  }

  // ── Workout log section ────────────────────────────────────────────────────

  Widget _buildWorkoutSection() {
    final workoutRepo = ref.read(workoutRepositoryProvider);
    final total = workoutRepo.totalCount;
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader('ЖУРНАЛ ТРЕНИРОВОК'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          child: Text(
            'Всего тренировок: $total',
            style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 13),
          ),
        ),
        _ActionTile(
          label: 'Удалить тренировку сегодня',
          onTap: () async {
            await workoutRepo.deleteForDate(DateTime.now());
            ref.invalidate(homeDataProvider);
            setState(() {});
            _snack('Тренировка за сегодня удалена ✓');
          },
        ),
        _ActionTile(
          label: 'Добавить фейковую тренировку',
          onTap: () => _addFakeWorkout(),
        ),
        _ActionTile(
          label: 'Удалить все тренировки',
          destructive: true,
          onTap: () async {
            final ok = await _confirm(
              'Удалить все тренировки?',
              'Это действие необратимо.',
            );
            if (ok != true) return;
            await workoutRepo.deleteAll();
            ref.invalidate(homeDataProvider);
            setState(() {});
            _snack('Все тренировки удалены ✓');
          },
        ),
      ],
    );
  }

  Future<void> _addFakeWorkout() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
    );
    if (picked == null) return;
    final date = DateTime(picked.year, picked.month, picked.day);
    await ref.read(workoutRepositoryProvider).addLog(
          WorkoutLog(
            date: date,
            setType: SetType.daily,
            exercises: const [],
            spEarned: 0,
            durationSec: 0,
          ),
        );
    ref.invalidate(homeDataProvider);
    setState(() {});
    _snack('Фейковая тренировка добавлена ✓');
  }

  // ── Notifications section ──────────────────────────────────────────────────

  Widget _buildNotificationsSection() {
    final ns = NotificationService.instance;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader('УВЕДОМЛЕНИЯ'),
        _ActionTile(
          label: 'Утреннее → сейчас',
          onTap: () async {
            final ok = await ns.debugShowMorning(_profile);
            _snack(ok ? 'Утреннее отправлено ✓' : 'Ошибка ✗');
          },
        ),
        _ActionTile(
          label: 'Вечернее → сейчас',
          onTap: () async {
            final ok = await ns.debugShowEvening(_profile);
            _snack(ok ? 'Вечернее отправлено ✓' : 'Ошибка ✗');
          },
        ),
        _ActionTile(
          label: 'Угроза стрику → сейчас',
          onTap: () async {
            final ok = await ns.debugShowStreakThreat(_profile);
            _snack(ok ? 'Угроза стрику отправлена ✓' : 'Ошибка ✗');
          },
        ),
        _ActionTile(
          label: 'Потеря стрика → сейчас',
          onTap: () async {
            final ok = await ns.debugShowStreakLost(_profile);
            _snack(ok ? 'Потеря стрика отправлена ✓' : 'Ошибка ✗');
          },
        ),
        _ActionTile(
          label: 'Показать запланированные',
          onTap: () => _showPendingNotifications(),
        ),
      ],
    );
  }

  Future<void> _showPendingNotifications() async {
    final pending = await NotificationService.instance.pendingRequests();
    if (!mounted) return;
    final lines = pending.isEmpty
        ? 'Нет запланированных уведомлений'
        : pending
            .map((n) => 'ID ${n.id}: ${n.title}\n${n.body}')
            .join('\n\n');
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Запланированные уведомления'),
        content: SingleChildScrollView(child: Text(lines)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // ── App section ────────────────────────────────────────────────────────────

  Widget _buildAppSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader('ПРИЛОЖЕНИЕ'),
        _ActionTile(
          label: 'Дамп состояния',
          onTap: () => _showStateDump(),
        ),
        _ActionTile(
          label: 'Полный сброс → онбординг',
          destructive: true,
          onTap: () => _fullReset(),
        ),
      ],
    );
  }

  void _showStateDump() {
    final buf = StringBuffer();
    buf.writeln('=== UserProfile ===');
    buf.writeln('rank: ${_profile.rank.name}');
    buf.writeln('totalSP: ${_profile.totalSP}');
    buf.writeln('currentStreak: ${_profile.currentStreak}');
    buf.writeln('longestStreak: ${_profile.longestStreak}');
    buf.writeln('freezeCount: ${_profile.streakFreezeCount}');
    buf.writeln('lastWorkout: ${_profile.lastWorkoutDate}');
    buf.writeln('locale: ${_profile.locale ?? "(system)"}');
    buf.writeln('workoutMins: ${_profile.preferredWorkoutMinutes ?? "(default)"}');
    buf.writeln('fitnessGoal: ${_profile.fitnessGoal?.name ?? "(none)"}');
    buf.writeln();
    buf.writeln('=== SkillProgress ===');
    for (final entry in _progressMap.entries) {
      final p = entry.value;
      buf.writeln(
        '${_branchLabel(entry.key)}: stage=${p.currentStage} '
        'reps=${p.currentReps} sets=${p.currentSets} '
        'challenge=${p.isChallengeUnlocked}',
      );
    }
    buf.writeln();
    buf.writeln(
        'Total workouts: ${ref.read(workoutRepositoryProvider).totalCount}');

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Дамп состояния'),
        content: SingleChildScrollView(
          child: Text(buf.toString(), style: const TextStyle(fontSize: 12)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _fullReset() async {
    final ok = await _confirm(
      'Полный сброс?',
      'Все данные будут удалены и откроется онбординг. Это необратимо.',
    );
    if (ok != true) return;

    await Future.wait([
      Hive.box<UserProfile>('user_profile').clear(),
      Hive.box<SkillProgress>('skill_progress').clear(),
      Hive.box<WorkoutLog>('workout_log').clear(),
    ]);

    ref.read(isOnboardingCompleteProvider.notifier).state = false;
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('[DEBUG] Возможности разработчика')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 32),
          children: [
            _buildProfileSection(),
            const Divider(height: 32),
            _buildBranchSection(),
            const Divider(height: 32),
            _buildWorkoutSection(),
            const Divider(height: 32),
            _buildNotificationsSection(),
            const Divider(height: 32),
            _buildAppSection(),
          ],
        ),
      ),
    );
  }
}

// ── Private helpers ────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
          color: scheme.primary,
        ),
      ),
    );
  }
}

/// Row with a label on the left and a control widget on the right.
class _DevRow extends StatelessWidget {
  const _DevRow({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant),
          ),
          const Spacer(),
          child,
        ],
      ),
    );
  }
}

/// `[−] value [+]` stepper. Tapping the value opens an edit dialog when
/// [allowEdit] is true.
class _Stepper extends StatelessWidget {
  const _Stepper({
    required this.value,
    required this.onChanged,
    this.step = 1,
    this.min = 0,
    this.max,
    this.allowEdit = false,
  });

  final int value;
  final void Function(int) onChanged;
  final int step;
  final int min;
  final int? max;
  final bool allowEdit;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _StepBtn(
          icon: Icons.remove,
          enabled: value > min,
          onTap: () => onChanged((value - step).clamp(min, max ?? 999999)),
        ),
        GestureDetector(
          onTap: allowEdit ? () => _openEditDialog(context) : null,
          child: Container(
            constraints: const BoxConstraints(minWidth: 48),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(
              '$value',
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
            ),
          ),
        ),
        _StepBtn(
          icon: Icons.add,
          enabled: max == null || value < max!,
          onTap: () => onChanged((value + step).clamp(min, max ?? 999999)),
        ),
      ],
    );
  }

  void _openEditDialog(BuildContext context) {
    final controller = TextEditingController(text: '$value');
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Введите значение'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          autofocus: true,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              final parsed = int.tryParse(controller.text);
              if (parsed != null) {
                onChanged(parsed.clamp(min, max ?? 999999));
              }
              Navigator.of(ctx).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

class _StepBtn extends StatelessWidget {
  const _StepBtn({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return IconButton(
      icon: Icon(icon, size: 18),
      padding: const EdgeInsets.all(4),
      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
      color: enabled ? scheme.primary : scheme.onSurfaceVariant.withAlpha(80),
      onPressed: enabled ? onTap : null,
    );
  }
}

/// Horizontal row of tappable chips.
class _ChipRow<T> extends StatelessWidget {
  const _ChipRow({
    required this.values,
    required this.selected,
    required this.label,
    required this.onSelect,
  });

  final List<T> values;
  final T selected;
  final String Function(T) label;
  final void Function(T) onSelect;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: values.map((v) {
        final isSelected = v == selected;
        return Padding(
          padding: const EdgeInsets.only(left: 4),
          child: GestureDetector(
            onTap: () => onSelect(v),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: isSelected
                    ? scheme.primary
                    : scheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                label(v),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
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

/// A simple list tile for one-tap actions.
class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.label,
    required this.onTap,
    this.destructive = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          color: destructive ? scheme.error : null,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: destructive ? scheme.error : scheme.onSurfaceVariant,
      ),
      onTap: onTap,
    );
  }
}
