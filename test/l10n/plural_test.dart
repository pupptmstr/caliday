import 'package:caliday/l10n/app_localizations_en.dart';
import 'package:caliday/l10n/app_localizations_ru.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/all_translations.dart';

void main() {
  test('every language: a counted message always carries its number', () {
    // A plural branch that drops the number ("one{a day}") reads fine in one
    // language and says nothing in the next one.
    for (final l10n in allTranslations) {
      for (final n in [0, 1, 2, 3, 5, 11, 21, 22, 101]) {
        for (final text in [
          l10n.homeStreakDays(n),
          l10n.exerciseLibraryCount(n),
          l10n.rankDecayWarning(n),
          l10n.notificationStreakLostBody(n),
        ]) {
          expect(text, contains('$n'), reason: '${l10n.localeName}: $text');
        }
      }
    }
  });

  group('Russian day plurals', () {
    final ru = AppLocalizationsRu();

    test('homeStreakDays picks the right form', () {
      const expected = {
        0: '0 дней',
        1: '1 день',
        2: '2 дня',
        4: '4 дня',
        5: '5 дней',
        11: '11 дней',
        12: '12 дней',
        14: '14 дней',
        21: '21 день',
        22: '22 дня',
        25: '25 дней',
        101: '101 день',
      };
      expected.forEach((n, text) {
        expect(ru.homeStreakDays(n), text, reason: '$n');
      });
    });

    test('rankDecayWarning declines the number of days', () {
      expect(ru.rankDecayWarning(21), contains('21 день'));
      expect(ru.rankDecayWarning(23), contains('23 дня'));
      expect(ru.rankDecayWarning(35), contains('35 дней'));
    });

    test('exerciseLibraryCount names the exercises', () {
      const expected = {
        0: '0 упражнений',
        1: '1 упражнение',
        2: '2 упражнения',
        4: '4 упражнения',
        5: '5 упражнений',
        11: '11 упражнений',
        21: '21 упражнение',
        22: '22 упражнения',
        25: '25 упражнений',
        61: '61 упражнение',
      };
      expected.forEach((n, text) {
        expect(ru.exerciseLibraryCount(n), text, reason: '$n');
      });
    });
  });

  group('English day plurals', () {
    final en = AppLocalizationsEn();

    test('homeStreakDays', () {
      expect(en.homeStreakDays(0), '0 days');
      expect(en.homeStreakDays(1), '1 day');
      expect(en.homeStreakDays(2), '2 days');
    });

    test('rankDecayWarning', () {
      expect(en.rankDecayWarning(21), contains('21 days'));
      expect(en.rankDecayWarning(1), contains('1 day '));
    });

    test('exerciseLibraryCount', () {
      expect(en.exerciseLibraryCount(0), '0 exercises');
      expect(en.exerciseLibraryCount(1), '1 exercise');
      expect(en.exerciseLibraryCount(2), '2 exercises');
    });
  });
}
