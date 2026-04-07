import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/extensions/build_context_l10n.dart';
import '../../../core/extensions/exercise_l10n.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/custom_routine.dart';
import '../../../data/models/enums.dart';
import '../../../data/repositories/custom_routine_repository.dart';
import '../../../data/static/exercise_catalog.dart';
import '../../../data/static/exercise_tags_catalog.dart';
import '../../../domain/services/workout_generator_service.dart';
import '../../workout/providers/workout_provider.dart';

/// Screen for building a named custom routine.
///
/// If [routine] is provided, opens in edit mode; otherwise creates a new one.
class CustomRoutineBuilderScreen extends ConsumerStatefulWidget {
  const CustomRoutineBuilderScreen({super.key, this.routine});

  final CustomRoutine? routine;

  @override
  ConsumerState<CustomRoutineBuilderScreen> createState() =>
      _CustomRoutineBuilderScreenState();
}

class _CustomRoutineBuilderScreenState
    extends ConsumerState<CustomRoutineBuilderScreen> {
  late final TextEditingController _nameCtrl;
  late List<String> _selectedIds;
  ExerciseTag? _filterTag;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.routine?.name ?? '');
    _selectedIds = List<String>.from(widget.routine?.exerciseIds ?? []);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  List<_ExerciseItem> get _filteredExercises {
    return ExerciseCatalog.libraryAll.map((e) {
      final tags = ExerciseTagsCatalog.forId(e.id);
      return _ExerciseItem(exercise: e, tags: tags);
    }).where((item) {
      if (_filterTag == null) return true;
      return item.tags.contains(_filterTag);
    }).toList();
  }

  Future<void> _save() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty || _selectedIds.isEmpty) return;

    final routine = widget.routine ??
        CustomRoutine(
          id: DateTime.now().microsecondsSinceEpoch.toRadixString(36),
          name: name,
          exerciseIds: _selectedIds,
          createdAt: DateTime.now(),
        );
    routine.name = name;
    routine.exerciseIds = _selectedIds;

    await ref.read(customRoutinesProvider.notifier).save(routine);
    if (mounted) context.pop();
  }

  void _startNow() {
    if (_selectedIds.isEmpty) return;
    final generator = ref.read(workoutGeneratorServiceProvider);
    final plan = generator.fromExerciseIds(_selectedIds);
    ref.read(customWorkoutPlanProvider.notifier).state = plan;
    context.push('/workout');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final exercises = _filteredExercises;
    final canSave = _nameCtrl.text.trim().isNotEmpty && _selectedIds.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.customWorkoutBuilderTitle),
        actions: [
          if (_selectedIds.isNotEmpty)
            TextButton(
              onPressed: canSave ? _save : null,
              child: Text(
                l10n.customWorkoutSave,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // ── Name field ─────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: TextField(
              controller: _nameCtrl,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: l10n.customWorkoutNameHint,
                filled: true,
                fillColor: scheme.surfaceContainerHighest,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // ── Tag filter chips ───────────────────────────────────────────────
          SizedBox(
            height: 38,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _TagChip(
                  label: 'All',
                  selected: _filterTag == null,
                  onTap: () => setState(() => _filterTag = null),
                ),
                for (final tag in ExerciseTag.values)
                  _TagChip(
                    label: tag.localizedName(l10n),
                    selected: _filterTag == tag,
                    color: tag.color,
                    onTap: () =>
                        setState(() => _filterTag = _filterTag == tag ? null : tag),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 4),

          // ── Exercise list ──────────────────────────────────────────────────
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
              itemCount: exercises.length,
              itemBuilder: (_, i) {
                final item = exercises[i];
                final selected = _selectedIds.contains(item.exercise.id);
                return _ExerciseTile(
                  item: item,
                  selected: selected,
                  onTap: () {
                    setState(() {
                      if (selected) {
                        _selectedIds.remove(item.exercise.id);
                      } else {
                        _selectedIds.add(item.exercise.id);
                      }
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),

      // ── Bottom bar ─────────────────────────────────────────────────────────
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _selectedIds.isNotEmpty ? _startNow : null,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    l10n.customWorkoutStartNow,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: canSave ? AppTheme.heroGradient : null,
                    color: canSave ? null : scheme.onSurface.withAlpha(30),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: ElevatedButton(
                    onPressed: canSave ? _save : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      l10n.customWorkoutSave,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: canSave ? Colors.white : scheme.onSurface.withAlpha(80),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Data class ────────────────────────────────────────────────────────────────

class _ExerciseItem {
  const _ExerciseItem({required this.exercise, required this.tags});
  final dynamic exercise; // Exercise
  final List<ExerciseTag> tags;
}

// ── Tag chip ──────────────────────────────────────────────────────────────────

class _TagChip extends StatelessWidget {
  const _TagChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.color,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: selected
                ? (color ?? scheme.primary)
                : scheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : scheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Exercise tile ─────────────────────────────────────────────────────────────

class _ExerciseTile extends StatelessWidget {
  const _ExerciseTile({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final _ExerciseItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;
    final exercise = item.exercise;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: selected
            ? scheme.primaryContainer
            : scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ExerciseL10n.name(l10n, exercise.id as String),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: selected
                              ? scheme.onPrimaryContainer
                              : scheme.onSurface,
                        ),
                      ),
                      if (item.tags.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 4,
                          runSpacing: 2,
                          children: item.tags.take(3).map((tag) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(
                                color: tag.color.withAlpha(selected ? 60 : 30),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                tag.localizedName(l10n),
                                style: TextStyle(
                                  fontSize: 11,
                                  color: tag.color,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ],
                  ),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: selected
                      ? Icon(
                          Icons.check_circle,
                          key: const ValueKey(true),
                          color: scheme.primary,
                          size: 22,
                        )
                      : Icon(
                          Icons.add_circle_outline,
                          key: const ValueKey(false),
                          color: scheme.onSurfaceVariant,
                          size: 22,
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}