import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/user_repository.dart';

/// Runtime source of truth for the selected locale (BCP-47 language code).
///
/// Initialised from [UserProfile.locale] on first read; defaults to 'ru'.
/// Changing this provider immediately re-renders [MaterialApp] with the
/// new locale without requiring an app restart.
final localeProvider = StateProvider<String>((ref) {
  return ref.read(userRepositoryProvider).getProfile().locale ?? 'ru';
});
