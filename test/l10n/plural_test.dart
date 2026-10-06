import 'package:caliday/l10n/app_localizations_en.dart';
import 'package:caliday/l10n/app_localizations_ru.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
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
  });
}
