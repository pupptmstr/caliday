import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/extensions/build_context_l10n.dart';
import '../../../data/models/custom_branch.dart';
import '../../../data/models/custom_course.dart';
import '../../../data/models/enums.dart';
import '../../../data/repositories/custom_course_repository.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../data/static/course_catalog.dart';
import '../../../domain/models/branch.dart';
import '../../../domain/models/course.dart';
import '../../home/providers/home_provider.dart';
import '../widgets/builder_widgets.dart';

/// Builds a course of the user's own (owner, 2026-10-09): a name, a host and
/// branches — built-in ones (their progress is shared with their courses)
/// and the user's own, made in the branch builder. The amounts and the
/// progression are the app's. With [course] it edits that one. Saving shows
/// the course.
class CourseBuilderScreen extends ConsumerStatefulWidget {
  const CourseBuilderScreen({super.key, this.course});

  final CustomCourse? course;

  @override
  ConsumerState<CourseBuilderScreen> createState() =>
      _CourseBuilderScreenState();
}

class _CourseBuilderScreenState extends ConsumerState<CourseBuilderScreen> {
  late final TextEditingController _name;
  late List<String> _keys;
  late int _host;
  final _nameFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.course?.name ?? '');
    _keys = List.of(widget.course?.branchKeys ?? const <String>[]);
    _host = widget.course?.hostIndex ?? CourseId.calisthenics.index;
  }

  @override
  void dispose() {
    _name.dispose();
    _nameFocus.dispose();
    super.dispose();
  }

  bool get _canSave => _name.text.trim().isNotEmpty && _keys.isNotEmpty;

  void _toggle(Branch branch) => setState(() {
        if (!_keys.remove(branch.key)) _keys.add(branch.key);
      });

  Future<void> _save() async {
    final l10n = context.l10n;
    if (_name.text.trim().isEmpty) {
      _nameFocus.requestFocus();
      showBuilderNotice(context, l10n.courseBuilderNameRequired);
      return;
    }
    if (_keys.isEmpty) {
      showBuilderNotice(context, l10n.courseBuilderPickBranch);
      return;
    }
    final course = widget.course ??
        CustomCourse(
          id: newCustomId(),
          name: '',
          branchKeys: const [],
          hostIndex: _host,
          createdAt: DateTime.now(),
        );
    course
      ..name = _name.text.trim()
      ..branchKeys = List.of(_keys)
      ..hostIndex = _host;
    await ref.read(customCoursesProvider.notifier).save(course);
    ref
        .read(activeCourseProvider.notifier)
        .select(OwnCourse(course, ref.read(customBranchesProvider)));
    ref.invalidate(homeDataProvider);
    if (mounted) context.pop();
  }

  Future<void> _delete() async {
    final l10n = context.l10n;
    final course = widget.course!;
    final ok = await confirmBuilderDelete(
      context,
      title: l10n.courseBuilderDelete,
      body: l10n.courseBuilderDeleteConfirm(course.name),
      confirm: l10n.customWorkoutDelete,
      cancel: l10n.friendsCancel,
    );
    if (!ok) return;
    await ref.read(customCoursesProvider.notifier).delete(course.id);
    // Back to the built-in course that was shown before.
    final profile = ref.read(userRepositoryProvider).getProfile();
    ref
        .read(activeCourseProvider.notifier)
        .select(BuiltInCourse(profile.activeCourse));
    ref.invalidate(homeDataProvider);
    if (mounted) context.pop();
  }

  Future<void> _openBranchBuilder([CustomBranch? branch]) async {
    final saved =
        await context.push<CustomBranch>('/library/branch-builder', extra: branch);
    if (!mounted) return;
    setState(() {
      // A new branch joins the course; a deleted one leaves it.
      final own = ref.read(customBranchesProvider);
      _keys.removeWhere((k) => Branch.resolve(k, own) == null);
      if (saved != null && branch == null) {
        _keys.add(CustomBranch.keyFor(saved.id));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final own = ref.watch(customBranchesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.course == null
            ? l10n.courseBuilderNewTitle
            : l10n.courseBuilderEditTitle),
        actions: [
          if (widget.course != null)
            IconButton(
              tooltip: l10n.courseBuilderDelete,
              icon: const Icon(Icons.delete_outline),
              onPressed: _delete,
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          BuilderNameField(
            controller: _name,
            focusNode: _nameFocus,
            hint: l10n.courseBuilderNameHint,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 20),
          BuilderSectionTitle(l10n.courseBuilderHostTitle),
          const SizedBox(height: 10),
          _HostPicker(
            selected: _host,
            onSelect: (i) => setState(() => _host = i),
          ),
          const SizedBox(height: 24),
          BuilderSectionTitle(
            l10n.courseBuilderBranchesTitle,
            subtitle: l10n.courseBuilderBranchesHint,
          ),
          const SizedBox(height: 14),

          // ── The user's own branches ──────────────────────────────────────
          _GroupHeader(l10n.courseBuilderMyBranches),
          for (final b in own) ...[
            _BranchTile(
              branch: OwnBranch(b),
              selected: _keys.contains(CustomBranch.keyFor(b.id)),
              onTap: () => _toggle(OwnBranch(b)),
              onEdit: () => _openBranchBuilder(b),
            ),
          ],
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Material(
              color: scheme.secondaryContainer,
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: _openBranchBuilder,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      Icon(Icons.add_circle_outline,
                          color: scheme.onSecondaryContainer),
                      const SizedBox(width: 12),
                      Text(
                        l10n.courseBuilderCreateBranch,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: scheme.onSecondaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── The built-in branches, by course ─────────────────────────────
          for (final course in CourseId.values) ...[
            const SizedBox(height: 12),
            _GroupHeader(course.localizedName(l10n)),
            for (final id in CourseCatalog.branchesFor(course))
              _BranchTile(
                branch: BuiltInBranch(id),
                selected: _keys.contains(id.name),
                onTap: () => _toggle(BuiltInBranch(id)),
              ),
          ],
        ],
      ),
      bottomNavigationBar: BuilderSaveBar(
        label: l10n.courseBuilderSave,
        enabled: _canSave,
        onPressed: _save,
      ),
    );
  }
}

// ── Host picker ───────────────────────────────────────────────────────────────

/// The five hosts, one of which leads the course (by `CourseId.index`).
class _HostPicker extends StatelessWidget {
  const _HostPicker({required this.selected, required this.onSelect});

  final int selected;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        for (final host in CourseId.values)
          Expanded(
            child: GestureDetector(
              onTap: () => onSelect(host.index),
              child: Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: host.index == selected
                          ? scheme.primaryContainer
                          : Colors.transparent,
                      border: Border.all(
                        color: host.index == selected
                            ? scheme.primary
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: SvgPicture.asset(host.hostPortrait,
                        width: 44, height: 44),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    host.hostName(l10n),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: host.index == selected
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: host.index == selected
                          ? scheme.primary
                          : scheme.onSurfaceVariant,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

// ── Branch list ───────────────────────────────────────────────────────────────

class _GroupHeader extends StatelessWidget {
  const _GroupHeader(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

/// A branch to tick: its icon, name and number of stages; an own branch has
/// an edit button too. A shared built-in branch (Flex, Balance) shows under
/// each of its courses, ticked in both.
class _BranchTile extends StatelessWidget {
  const _BranchTile({
    required this.branch,
    required this.selected,
    required this.onTap,
    this.onEdit,
  });

  final Branch branch;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: selected ? scheme.primaryContainer : scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 12, onEdit == null ? 16 : 4, 12),
            child: Row(
              children: [
                Icon(branch.icon,
                    size: 22,
                    color: selected ? scheme.onPrimaryContainer : scheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        branch.name(l10n),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: selected
                              ? scheme.onPrimaryContainer
                              : scheme.onSurface,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        l10n.courseBuilderStages(branch.stageCount),
                        style: TextStyle(
                          fontSize: 12,
                          color: selected
                              ? scheme.onPrimaryContainer.withAlpha(180)
                              : scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  selected ? Icons.check_circle : Icons.circle_outlined,
                  color: selected ? scheme.primary : scheme.outline,
                  size: 22,
                ),
                if (onEdit != null)
                  IconButton(
                    tooltip: l10n.branchBuilderEditTitle,
                    icon: Icon(Icons.edit_outlined,
                        size: 20, color: scheme.onSurfaceVariant),
                    onPressed: onEdit,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
