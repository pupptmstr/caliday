import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/user_repository.dart';

/// Runtime source of truth for the selected locale (BCP-47 language code).
///
/// Initialised from [UserProfile.locale] on first read; falls back to the
/// system locale (ru/en), defaulting to 'en' for unsupported languages.
/// Changing this provider immediately re-renders [MaterialApp] with the
/// new locale without requiring an app restart.
class LocaleNotifier extends Notifier<String> {
  @override
  String build() {
    final systemCode =
        WidgetsBinding.instance.platformDispatcher.locale.languageCode;
    final systemLocale = systemCode == 'ru' ? 'ru' : 'en';
    return ref.read(userRepositoryProvider).getProfile().locale ?? systemLocale;
  }

  void set(String locale) => state = locale;
}

final localeProvider = NotifierProvider<LocaleNotifier, String>(LocaleNotifier.new);