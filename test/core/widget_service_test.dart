import 'package:caliday/core/services/widget_service.dart';
import 'package:caliday/data/models/enums.dart';
import 'package:caliday/l10n/app_localizations.dart';
import 'package:caliday/l10n/app_localizations_en.dart';
import 'package:caliday/l10n/app_localizations_ru.dart';
import 'package:flutter_test/flutter_test.dart';

/// The widget cannot read the .arb files (it has no BuildContext), so its rank
/// names are written out in [WidgetService.rankLabel]. They must say what the
/// app says.
String _appName(AppLocalizations l10n, Rank rank) => switch (rank) {
      Rank.beginner => l10n.rankBeginner,
      Rank.amateur => l10n.rankAmateur,
      Rank.sportsman => l10n.rankSportsman,
      Rank.athlete => l10n.rankAthlete,
      Rank.master => l10n.rankMaster,
      Rank.legend => l10n.rankLegend,
    };

void main() {
  group('WidgetService.rankLabel matches the names in the app', () {
    for (final rank in Rank.values) {
      test('${rank.name}: en', () {
        expect(WidgetService.rankLabel(rank, 'en'), _appName(AppLocalizationsEn(), rank));
      });
      test('${rank.name}: ru', () {
        expect(WidgetService.rankLabel(rank, 'ru'), _appName(AppLocalizationsRu(), rank));
      });
    }
  });

  test('an unknown locale gets English; every rank has a distinct name', () {
    for (final rank in Rank.values) {
      expect(WidgetService.rankLabel(rank, 'fr'), WidgetService.rankLabel(rank, 'en'));
    }
    for (final locale in ['en', 'ru']) {
      final names = {for (final r in Rank.values) WidgetService.rankLabel(r, locale)};
      expect(names, hasLength(Rank.values.length), reason: locale);
    }
  });
}
