import 'package:caliday/core/extensions/exercise_l10n.dart';
import 'package:caliday/data/static/exercise_catalog.dart';
import 'package:caliday/features/library/providers/exercise_library_provider.dart';
import 'package:caliday/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// The library search looks at the name of an exercise in every supported
/// language, whichever one the app is in.

({ProviderContainer container, ExerciseLibraryNotifier notifier}) _open() {
  final container = ProviderContainer();
  addTearDown(container.dispose);
  // The provider is auto-disposed: keep it alive for the test.
  container.listen(exerciseLibraryProvider, (_, _) {});
  return (
    container: container,
    notifier: container.read(exerciseLibraryProvider.notifier),
  );
}

/// The ids found by [query].
Set<String> _search(String query) {
  final (:container, :notifier) = _open();
  notifier.setQuery(query);
  return container
      .read(exerciseLibraryProvider)
      .results
      .map((e) => e.id)
      .toSet();
}

void main() {
  test('a Russian name finds the exercise, in any letter case', () {
    expect(_search('планка'), contains('core_s2_plank'));
    expect(_search('ПЛАНКА'), contains('core_s2_plank'));
    expect(_search('отжимания от стены'), contains('push_s1_wall_pushup'));
  });

  test('an English name still finds it', () {
    expect(_search('plank'), contains('core_s2_plank'));
    expect(_search('Wall Push'), contains('push_s1_wall_pushup'));
  });

  test('part of a word is enough', () {
    expect(_search('план'), contains('core_s2_plank'));
  });

  test('"е" finds "ё": nobody types the dots', () {
    expect(_search('мертвый жук'), contains('posture_s2_dead_bug'));
    expect(_search('мёртвый жук'), contains('posture_s2_dead_bug'));
    expect(_search('подъемы ног'), contains('core_s3_lying_leg_raise'));
  });

  test('the catalog English name still finds what it found before', () {
    // The screen says "One-Leg Stand"; the catalog calls it "Single-Leg Stand".
    expect(_search('single-leg stand'), contains('bal_s1_one_leg_stand'));
  });

  test('spaces around the query are ignored', () {
    expect(_search('  планка '), contains('core_s2_plank'));
    expect(_search('   '), hasLength(ExerciseCatalog.libraryAll.length),
        reason: 'only spaces is no query');
  });

  test('a query that matches no name finds nothing', () {
    expect(_search('qwertyuiop'), isEmpty);
    expect(_search('яблоко'), isEmpty);
  });

  test('every exercise is found by its own name in every supported language', () {
    final (:container, :notifier) = _open();
    for (final locale in AppLocalizations.supportedLocales) {
      final l10n = lookupAppLocalizations(locale);
      for (final e in ExerciseCatalog.libraryAll) {
        final name = ExerciseL10n.name(l10n, e.id);
        notifier.setQuery(name);
        final ids = container.read(exerciseLibraryProvider).results.map((r) => r.id);
        expect(ids, contains(e.id), reason: '"$name" ($locale) should find ${e.id}');
      }
    }
  });

  test('clearing the filters brings every exercise back', () {
    final (:container, :notifier) = _open();
    notifier.setQuery('планка');
    final byQuery = container.read(exerciseLibraryProvider).results;
    expect(byQuery, isNotEmpty);
    expect(byQuery.length, lessThan(ExerciseCatalog.libraryAll.length));

    notifier.clearFilters();
    expect(container.read(exerciseLibraryProvider).results.length,
        ExerciseCatalog.libraryAll.length);
  });
}
