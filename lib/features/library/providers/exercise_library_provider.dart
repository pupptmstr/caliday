import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/exercise_l10n.dart';
import '../../../data/models/enums.dart';
import '../../../data/models/exercise.dart';
import '../../../data/static/exercise_catalog.dart';
import '../../../data/static/exercise_tags_catalog.dart';
import '../../../l10n/app_localizations.dart';

@immutable
class ExerciseLibraryState {
  const ExerciseLibraryState({
    this.query = '',
    this.selectedTags = const {},
    required this.results,
  });

  final String query;
  final Set<ExerciseTag> selectedTags;
  final List<Exercise> results;

  ExerciseLibraryState copyWith({
    String? query,
    Set<ExerciseTag>? selectedTags,
    List<Exercise>? results,
  }) =>
      ExerciseLibraryState(
        query: query ?? this.query,
        selectedTags: selectedTags ?? this.selectedTags,
        results: results ?? this.results,
      );
}

class ExerciseLibraryNotifier extends Notifier<ExerciseLibraryState> {
  @override
  ExerciseLibraryState build() =>
      ExerciseLibraryState(results: ExerciseCatalog.libraryAll);

  void setQuery(String q) {
    final next = state.copyWith(query: q);
    state = next.copyWith(results: _filter(next));
  }

  void toggleTag(ExerciseTag tag) {
    final tags = Set<ExerciseTag>.from(state.selectedTags);
    if (tags.contains(tag)) {
      tags.remove(tag);
    } else {
      tags.add(tag);
    }
    final next = state.copyWith(selectedTags: tags);
    state = next.copyWith(results: _filter(next));
  }

  void clearFilters() {
    state = ExerciseLibraryState(results: ExerciseCatalog.libraryAll);
  }

  /// Lower case, with "ё" folded to "е": nobody types the dots on a phone
  /// keyboard, and "подъемы" has to find "Подъёмы".
  static String _fold(String s) => s.toLowerCase().replaceAll('ё', 'е');

  /// The names a query is matched against: the name in every supported
  /// language (so "планка" works in the English UI and "plank" in the Russian
  /// one) plus the catalog's own English name.
  static List<String> _searchNames(
      Exercise e, List<AppLocalizations> languages) {
    return [
      e.name,
      for (final l10n in languages) ExerciseL10n.name(l10n, e.id),
    ].map(_fold).toList();
  }

  /// Whether [e] matches the search [query] in any of [languages] (every
  /// supported one, see [allLanguages]); an empty query matches everything.
  /// Also used by the exercise picker of the branch builder.
  static bool matchesQuery(
      Exercise e, String query, List<AppLocalizations> languages) {
    final q = _fold(query.trim());
    return q.isEmpty || _searchNames(e, languages).any((n) => n.contains(q));
  }

  /// Every supported language, for [matchesQuery].
  static List<AppLocalizations> allLanguages() =>
      AppLocalizations.supportedLocales.map(lookupAppLocalizations).toList();

  static List<Exercise> _filter(ExerciseLibraryState s) {
    var list = ExerciseCatalog.libraryAll;
    if (s.query.trim().isNotEmpty) {
      final languages = allLanguages();
      list = list.where((e) => matchesQuery(e, s.query, languages)).toList();
    }
    if (s.selectedTags.isNotEmpty) {
      list = list.where((e) {
        final tags = ExerciseTagsCatalog.forId(e.id);
        return s.selectedTags.every(tags.contains);
      }).toList();
    }
    return list;
  }
}

final exerciseLibraryProvider =
    NotifierProvider.autoDispose<ExerciseLibraryNotifier, ExerciseLibraryState>(
  ExerciseLibraryNotifier.new,
);