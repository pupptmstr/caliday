import 'package:caliday/l10n/app_localizations.dart';

/// The texts of every language the app is translated into (one per ARB file),
/// so that a test written for "every language" covers a new one by itself.
final allTranslations = [
  for (final locale in AppLocalizations.supportedLocales)
    lookupAppLocalizations(locale),
];
