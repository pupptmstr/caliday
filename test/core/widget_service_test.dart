import 'package:caliday/core/services/widget_service.dart';
import 'package:caliday/data/models/enums.dart';
import 'package:caliday/l10n/app_localizations_en.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/all_translations.dart';

/// The widget has no BuildContext, so [WidgetService.rankLabel] reads the rank
/// names straight from the ARB files of the language.
void main() {
  test('every language: the names the app shows, all distinct', () {
    for (final l10n in allTranslations) {
      final names = [
        for (final rank in Rank.values) WidgetService.rankLabel(rank, l10n.localeName),
      ];
      expect(names, [for (final rank in Rank.values) rank.localizedName(l10n)],
          reason: l10n.localeName);
      expect(names.toSet(), hasLength(Rank.values.length), reason: l10n.localeName);
    }
  });

  test('a language the app does not have gets English', () {
    for (final rank in Rank.values) {
      expect(WidgetService.rankLabel(rank, 'fr'), rank.localizedName(AppLocalizationsEn()));
    }
  });
}
