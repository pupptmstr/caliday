import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../../../core/extensions/build_context_l10n.dart';
import '../../../core/extensions/exercise_l10n.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/enums.dart';
import '../../../data/models/exercise.dart';
import '../../../data/static/exercise_tags_catalog.dart';
import '../providers/exercise_library_provider.dart';
import '../widgets/exercise_detail_sheet.dart';

class ExerciseLibraryScreen extends ConsumerStatefulWidget {
  const ExerciseLibraryScreen({super.key});

  @override
  ConsumerState<ExerciseLibraryScreen> createState() =>
      _ExerciseLibraryScreenState();
}

class _ExerciseLibraryScreenState extends ConsumerState<ExerciseLibraryScreen> {
  late final TextEditingController _search;

  @override
  void initState() {
    super.initState();
    _search = TextEditingController();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final state = ref.watch(exerciseLibraryProvider);
    final notifier = ref.read(exerciseLibraryProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.exerciseLibraryTitle),
        elevation: 0,
      ),
      body: Column(
        children: [
          // ── Search field ───────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: TextField(
              controller: _search,
              onChanged: notifier.setQuery,
              decoration: InputDecoration(
                hintText: l10n.exerciseLibrarySearchHint,
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon: state.query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close, size: 18),
                        onPressed: () {
                          _search.clear();
                          notifier.clearFilters();
                        },
                      )
                    : null,
                filled: true,
                fillColor: scheme.surfaceContainerHighest,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // ── Tag filter chips ────────────────────────────────────────────────
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: ExerciseTag.values.length,
              separatorBuilder: (context, _) => const SizedBox(width: 6),
              itemBuilder: (_, i) {
                final tag = ExerciseTag.values[i];
                final selected = state.selectedTags.contains(tag);
                return FilterChip(
                  label: Text(
                    tag.localizedName(l10n),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: selected
                          ? scheme.onPrimary
                          : scheme.onSurfaceVariant,
                    ),
                  ),
                  selected: selected,
                  onSelected: (_) => notifier.toggleTag(tag),
                  selectedColor: AppTheme.brandBlue,
                  backgroundColor: scheme.surfaceContainerHighest,
                  checkmarkColor: scheme.onPrimary,
                  side: BorderSide.none,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  visualDensity: VisualDensity.compact,
                );
              },
            ),
          ),
          const SizedBox(height: 8),

          // ── Results count ──────────────────────────────────────────────────
          if (state.selectedTags.isNotEmpty || state.query.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
              child: Row(
                children: [
                  Text(
                    '${state.results.length}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _exerciseCountLabel(state.results.length),
                    style: TextStyle(
                      fontSize: 13,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                  const Spacer(),
                  if (state.selectedTags.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        notifier.clearFilters();
                        _search.clear();
                      },
                      child: Text(
                        'Сбросить',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.brandBlue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ),

          // ── Grid ──────────────────────────────────────────────────────────
          Expanded(
            child: state.results.isEmpty
                ? Center(
                    child: Text(
                      l10n.exerciseLibraryEmpty,
                      style: TextStyle(color: scheme.onSurfaceVariant),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: state.results.length,
                    itemBuilder: (_, i) => _ExerciseCard(
                      exercise: state.results[i],
                      isDark: isDark,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  String _exerciseCountLabel(int count) {
    if (count == 1) return 'упражнение';
    if (count >= 2 && count <= 4) return 'упражнения';
    return 'упражнений';
  }
}

// ── Exercise card ─────────────────────────────────────────────────────────────

class _ExerciseCard extends StatelessWidget {
  const _ExerciseCard({required this.exercise, required this.isDark});

  final Exercise exercise;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => ExerciseDetailSheet.show(context, exercise),
      child: Container(
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isDark ? AppTheme.cardShadowDark : AppTheme.cardShadowLight,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            Expanded(
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                child: Container(
                  color: scheme.surfaceContainerHighest,
                  width: double.infinity,
                  child: exercise.animationPath != null
                      ? Lottie.asset(
                          exercise.animationPath!,
                          fit: BoxFit.contain,
                          repeat: true,
                        )
                      : Center(
                          child: Icon(
                            exercise.branch.icon,
                            size: 40,
                            color:
                                scheme.onSurfaceVariant.withAlpha(100),
                          ),
                        ),
                ),
              ),
            ),

            // Info area
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ExerciseL10n.name(l10n, exercise.id),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(exercise.branch.icon,
                          size: 12, color: scheme.primary),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          exercise.branch.localizedName(l10n),
                          style: TextStyle(
                            fontSize: 11,
                            color: scheme.onSurfaceVariant,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      _TagDots(exercise: exercise, scheme: scheme),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shows colored dots representing top-3 tags to give a quick visual hint.
class _TagDots extends StatelessWidget {
  const _TagDots({required this.exercise, required this.scheme});

  final Exercise exercise;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    final tags = ExerciseTagsCatalog.forId(exercise.id);
    final shown = tags.take(3).toList();
    if (shown.isEmpty) return const SizedBox.shrink();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: shown.map((t) {
        return Container(
          width: 6,
          height: 6,
          margin: const EdgeInsets.only(left: 3),
          decoration: BoxDecoration(
            color: _tagColor(t),
            shape: BoxShape.circle,
          ),
        );
      }).toList(),
    );
  }

  Color _tagColor(ExerciseTag tag) {
    return switch (tag) {
      ExerciseTag.strength => AppTheme.brandBlue,
      ExerciseTag.stretch || ExerciseTag.mobility => const Color(0xFF34C759),
      ExerciseTag.requiresBar => const Color(0xFFFF9500),
      ExerciseTag.sittingRecovery || ExerciseTag.postureFocus =>
        const Color(0xFF9B59B6),
      ExerciseTag.beginner => const Color(0xFF5AC8FA),
      _ => AppTheme.brandBlueDeep,
    };
  }
}