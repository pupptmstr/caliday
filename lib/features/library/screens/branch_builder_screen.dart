import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/extensions/build_context_l10n.dart';
import '../../../core/extensions/exercise_l10n.dart';
import '../../../data/models/custom_branch.dart';
import '../../../data/models/enums.dart';
import '../../../data/models/exercise.dart';
import '../../../data/repositories/custom_course_repository.dart';
import '../../../data/repositories/skill_progress_repository.dart';
import '../../../data/static/exercise_tags_catalog.dart';
import '../../../domain/models/branch.dart';
import '../../../domain/services/custom_stages.dart';
import '../../home/providers/home_provider.dart';
import '../providers/exercise_library_provider.dart';
import '../widgets/builder_widgets.dart';

/// Builds a branch of the user's own (owner, 2026-10-09): a name and
/// exercises in order, each one a stage; the amounts come from
/// [CustomStages]. Pops with the saved [CustomBranch], or with nothing when
/// left or deleted. With [branch] it edits that one.
class BranchBuilderScreen extends ConsumerStatefulWidget {
  const BranchBuilderScreen({super.key, this.branch});

  final CustomBranch? branch;

  @override
  ConsumerState<BranchBuilderScreen> createState() =>
      _BranchBuilderScreenState();
}

class _BranchBuilderScreenState extends ConsumerState<BranchBuilderScreen> {
  late final TextEditingController _name;
  late List<String> _ids;
  final _nameFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.branch?.name ?? '');
    _ids = [
      for (final id in widget.branch?.exerciseIds ?? const <String>[])
        if (OwnBranch.exerciseById(id) != null) id,
    ];
  }

  @override
  void dispose() {
    _name.dispose();
    _nameFocus.dispose();
    super.dispose();
  }

  bool get _canSave => _name.text.trim().isNotEmpty && _ids.isNotEmpty;

  Future<void> _save() async {
    final l10n = context.l10n;
    if (_name.text.trim().isEmpty) {
      _nameFocus.requestFocus();
      showBuilderNotice(context, l10n.branchBuilderNameRequired);
      return;
    }
    if (_ids.isEmpty) {
      showBuilderNotice(context, l10n.branchBuilderPickExercise);
      return;
    }
    final old = widget.branch;
    final oldIds = List<String>.of(old?.exerciseIds ?? const []);
    final branch = old ??
        CustomBranch(
          id: newCustomId(),
          name: '',
          exerciseIds: const [],
          createdAt: DateTime.now(),
        );
    branch
      ..name = _name.text.trim()
      ..exerciseIds = List.of(_ids);

    // The stages changed under a branch that has progress: keep the user on
    // their exercise (see CustomStages.remap).
    final progressRepo = ref.read(skillProgressRepositoryProvider);
    final own = OwnBranch(branch);
    if (old != null && progressRepo.hasStored(own.key)) {
      final progress = progressRepo.progressFor(own);
      CustomStages.remap(progress, oldIds, own.stages);
      await progressRepo.saveProgress(progress);
    }

    await ref.read(customBranchesProvider.notifier).save(branch);
    ref.invalidate(homeDataProvider);
    if (mounted) context.pop(branch);
  }

  Future<void> _delete() async {
    final l10n = context.l10n;
    final branch = widget.branch!;
    final ok = await confirmBuilderDelete(
      context,
      title: l10n.branchBuilderDelete,
      body: l10n.branchBuilderDeleteConfirm(branch.name),
      confirm: l10n.customWorkoutDelete,
      cancel: l10n.friendsCancel,
    );
    if (!ok) return;
    await ref.read(customBranchesProvider.notifier).delete(branch.id);
    ref.invalidate(homeDataProvider);
    if (mounted) context.pop();
  }

  Future<void> _pick() async {
    final picked = await showModalBottomSheet<List<String>>(
      context: context,
      isScrollControlled: true,
      // Over the bottom navigation, which would hide the end of the list.
      useRootNavigator: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _ExercisePickerSheet(selected: _ids),
    );
    if (picked != null) setState(() => _ids = picked);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final stages = CustomStages.build([
      for (final id in _ids) ?OwnBranch.exerciseById(id),
    ]);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.branch == null
            ? l10n.branchBuilderNewTitle
            : l10n.branchBuilderEditTitle),
        actions: [
          if (widget.branch != null)
            IconButton(
              tooltip: l10n.branchBuilderDelete,
              icon: const Icon(Icons.delete_outline),
              onPressed: _delete,
            ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            sliver: SliverList.list(
              children: [
                BuilderNameField(
                  controller: _name,
                  focusNode: _nameFocus,
                  hint: l10n.branchBuilderNameHint,
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: scheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.auto_graph,
                          size: 18, color: scheme.onSecondaryContainer),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          l10n.branchBuilderHowItWorks,
                          style: TextStyle(
                            fontSize: 13,
                            color: scheme.onSecondaryContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                BuilderSectionTitle(l10n.branchBuilderStagesTitle),
                const SizedBox(height: 10),
                if (stages.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      l10n.branchBuilderEmpty,
                      style: TextStyle(
                          fontSize: 14, color: scheme.onSurfaceVariant),
                    ),
                  ),
              ],
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverReorderableList(
              itemCount: stages.length,
              onReorder: (from, to) => setState(() {
                if (to > from) to -= 1;
                _ids.insert(to, _ids.removeAt(from));
              }),
              itemBuilder: (_, i) => _StageTile(
                key: ValueKey(stages[i].id),
                index: i,
                stage: stages[i],
                onRemove: () => setState(() => _ids.removeAt(i)),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
            sliver: SliverToBoxAdapter(
              child: OutlinedButton.icon(
                onPressed: _pick,
                icon: const Icon(Icons.add),
                label: Text(l10n.branchBuilderAddExercises),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BuilderSaveBar(
        label: l10n.branchBuilderSave,
        enabled: _canSave,
        onPressed: _save,
      ),
    );
  }
}

// ── Stage tile ────────────────────────────────────────────────────────────────

/// One stage: its number, the exercise, the amounts the app derived, a drag
/// handle and a remove button.
class _StageTile extends StatelessWidget {
  const _StageTile({
    required this.index,
    required this.stage,
    required this.onRemove,
    super.key,
  });

  final int index;
  final Exercise stage;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final params = stage.type == ExerciseType.timed
        ? (stage.holdsPerSet > 1
            ? l10n.branchBuilderParamsTimedPerSide
            : l10n.branchBuilderParamsTimed)(stage.startReps, stage.targetReps,
            stage.startSets, stage.targetSets)
        : l10n.branchBuilderParamsReps(stage.startReps, stage.targetReps,
            stage.startSets, stage.targetSets);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 4, 10),
          child: Row(
            children: [
              Container(
                width: 30,
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: scheme.primary,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${stage.stage}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: scheme.onPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ExerciseL10n.name(l10n, stage.id),
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      params,
                      style: TextStyle(
                          fontSize: 12, color: scheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                icon: Icon(Icons.close, size: 20, color: scheme.onSurfaceVariant),
                onPressed: onRemove,
              ),
              ReorderableDragStartListener(
                index: index,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Icon(Icons.drag_handle, color: scheme.onSurfaceVariant),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Exercise picker ───────────────────────────────────────────────────────────

/// Every exercise an own branch can hold, with the library's search (every
/// language) and a tag filter. Pops with the new list: the ones kept in their
/// order, the added ones after them in the order they were tapped.
class _ExercisePickerSheet extends StatefulWidget {
  const _ExercisePickerSheet({required this.selected});

  final List<String> selected;

  @override
  State<_ExercisePickerSheet> createState() => _ExercisePickerSheetState();
}

class _ExercisePickerSheetState extends State<_ExercisePickerSheet> {
  late final List<String> _ids = List.of(widget.selected);
  final _all = OwnBranch.pickable;
  final _languages = ExerciseLibraryNotifier.allLanguages();
  String _query = '';
  ExerciseTag? _tag;

  List<Exercise> get _shown => [
        for (final e in _all)
          if ((_tag == null || ExerciseTagsCatalog.forId(e.id).contains(_tag)) &&
              ExerciseLibraryNotifier.matchesQuery(e, _query, _languages))
            e,
      ];

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final shown = _shown;

    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.9,
      child: Column(
        children: [
          const SizedBox(height: 10),
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: scheme.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 8, 4),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.exercisePickerTitle,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(_ids),
                  // The theme's buttons are full width; this one sits in a row.
                  style: FilledButton.styleFrom(minimumSize: const Size(0, 40)),
                  child: Text(l10n.exercisePickerDone(_ids.length)),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              onChanged: (q) => setState(() => _query = q),
              decoration: InputDecoration(
                hintText: l10n.exerciseLibrarySearchHint,
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: scheme.surfaceContainerHighest,
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 38,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _TagChip(
                  label: l10n.exerciseTagFilterAll,
                  selected: _tag == null,
                  onTap: () => setState(() => _tag = null),
                ),
                for (final tag in ExerciseTag.values)
                  _TagChip(
                    label: tag.localizedName(l10n),
                    selected: _tag == tag,
                    color: tag.color,
                    onTap: () => setState(() => _tag = _tag == tag ? null : tag),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: shown.isEmpty
                ? Center(
                    child: Text(
                      l10n.exerciseLibraryEmpty,
                      style: TextStyle(color: scheme.onSurfaceVariant),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                    itemCount: shown.length,
                    itemBuilder: (_, i) {
                      final e = shown[i];
                      final at = _ids.indexOf(e.id);
                      return _PickTile(
                        exercise: e,
                        position: at < 0 ? null : at + 1,
                        onTap: () => setState(() {
                          if (at < 0) {
                            _ids.add(e.id);
                          } else {
                            _ids.removeAt(at);
                          }
                        }),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

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
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
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

/// An exercise of the picker; [position] is its stage number once picked.
class _PickTile extends StatelessWidget {
  const _PickTile({
    required this.exercise,
    required this.position,
    required this.onTap,
  });

  final Exercise exercise;
  final int? position;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final picked = position != null;
    final tags = ExerciseTagsCatalog.forId(exercise.id);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: picked ? scheme.primaryContainer : scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ExerciseL10n.name(l10n, exercise.id),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: picked
                              ? scheme.onPrimaryContainer
                              : scheme.onSurface,
                        ),
                      ),
                      if (tags.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 4,
                          runSpacing: 2,
                          children: [
                            for (final tag in tags.take(3))
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 7, vertical: 2),
                                decoration: BoxDecoration(
                                  color: tag.color.withAlpha(picked ? 60 : 30),
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
                              ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                picked
                    ? Container(
                        width: 26,
                        height: 26,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: scheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '$position',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: scheme.onPrimary,
                          ),
                        ),
                      )
                    : Icon(Icons.add_circle_outline,
                        color: scheme.onSurfaceVariant, size: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
