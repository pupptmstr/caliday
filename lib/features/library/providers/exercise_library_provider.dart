import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../data/models/enums.dart';
import '../../../data/models/exercise.dart';
import '../../../data/static/exercise_catalog.dart';
import '../../../data/static/exercise_tags_catalog.dart';

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

class ExerciseLibraryNotifier extends StateNotifier<ExerciseLibraryState> {
  ExerciseLibraryNotifier()
      : super(ExerciseLibraryState(results: ExerciseCatalog.libraryAll));

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

  static List<Exercise> _filter(ExerciseLibraryState s) {
    var list = ExerciseCatalog.libraryAll;
    if (s.query.isNotEmpty) {
      final q = s.query.toLowerCase();
      list = list.where((e) => e.name.toLowerCase().contains(q)).toList();
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
    StateNotifierProvider.autoDispose<ExerciseLibraryNotifier, ExerciseLibraryState>(
  (_) => ExerciseLibraryNotifier(),
);