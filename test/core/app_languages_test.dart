import 'package:caliday/core/l10n/app_languages.dart';
import 'package:caliday/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('the pickers list exactly the languages of the ARB files', () {
    // A new ARB file without a line in appLanguages could not be picked; a
    // line without its ARB file would crash the lookup.
    expect(appLanguages.map((l) => l.code).toSet(),
        AppLocalizations.supportedLocales.map((l) => l.languageCode).toSet());
    expect(appLanguages.map((l) => l.code).toSet(), hasLength(appLanguages.length));
  });

  test('every language has its own name and a flag', () {
    for (final language in appLanguages) {
      expect(language.nativeName.trim(), isNotEmpty, reason: language.code);
      expect(language.flag.trim(), isNotEmpty, reason: language.code);
    }
    expect(appLanguages.map((l) => l.nativeName).toSet(), hasLength(appLanguages.length));
  });

  test('a supported code is kept, anything else falls back to English', () {
    for (final language in appLanguages) {
      expect(supportedLanguageCode(language.code), language.code);
      expect(appLanguageOf(language.code), same(language));
      expect(l10nFor(language.code).localeName, language.code);
    }
    for (final other in [null, '', 'fr', 'EN', 'pt_BR']) {
      expect(supportedLanguageCode(other), fallbackLanguageCode, reason: '$other');
      expect(appLanguageOf(other).code, fallbackLanguageCode, reason: '$other');
      expect(l10nFor(other).localeName, fallbackLanguageCode, reason: '$other');
    }
  });

  test('the fallback is the template of the ARB files', () {
    expect(fallbackLanguageCode, 'en');
    expect(appLanguages.map((l) => l.code), contains(fallbackLanguageCode));
  });
}
