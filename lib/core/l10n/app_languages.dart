import 'package:flutter/widgets.dart';

import '../../l10n/app_localizations.dart';

/// A language the app is translated into.
class AppLanguage {
  const AppLanguage(this.code, this.nativeName, this.flag);

  /// The language code of its ARB file (`l10n/app_<code>.arb`).
  final String code;

  /// Its name in itself ("Русский"). The pickers show it the same in every UI
  /// language, so a user who picked a language by mistake can find their own.
  final String nativeName;

  final String flag;
}

/// Every UI language, in the order of the pickers (settings, onboarding).
///
/// Adding a language: its ARB file, `flutter gen-l10n`, then a line here.
/// `app_languages_test.dart` fails while this list and the ARB files differ.
const appLanguages = [
  AppLanguage('ru', 'Русский', '🇷🇺'),
  AppLanguage('en', 'English', '🇬🇧'),
];

/// The language the app falls back to: the template of the ARB files.
const fallbackLanguageCode = 'en';

/// [code] when the app is translated into it, otherwise [fallbackLanguageCode].
String supportedLanguageCode(String? code) =>
    AppLocalizations.supportedLocales.any((l) => l.languageCode == code)
        ? code!
        : fallbackLanguageCode;

/// The [AppLanguage] of [code]; the fallback language for an unknown one.
AppLanguage appLanguageOf(String? code) {
  final supported = supportedLanguageCode(code);
  return appLanguages.firstWhere((l) => l.code == supported);
}

/// The texts of [code] where there is no BuildContext (notifications, the home
/// screen widget); the fallback language for an unknown code.
AppLocalizations l10nFor(String? code) =>
    lookupAppLocalizations(Locale(supportedLanguageCode(code)));
