import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/user_repository.dart';

/// Converts a stored string key to [ThemeMode].
ThemeMode themeModeFromString(String? key) => switch (key) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };

/// Converts a [ThemeMode] to the storage string key (null = system).
String? themeModeToString(ThemeMode mode) => switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => null,
    };

/// Current app theme mode. Initialised from [UserProfile.themeModeName];
/// updated when the user changes the setting.
final themeProvider = StateProvider<ThemeMode>((ref) {
  final profile = ref.read(userRepositoryProvider).getProfile();
  return themeModeFromString(profile.themeModeName);
});