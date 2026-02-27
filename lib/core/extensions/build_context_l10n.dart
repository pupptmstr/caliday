import 'package:flutter/widgets.dart';
import 'package:caliday/l10n/app_localizations.dart';

/// Shortcut: `context.l10n` instead of `AppLocalizations.of(context)!`.
extension BuildContextL10n on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
