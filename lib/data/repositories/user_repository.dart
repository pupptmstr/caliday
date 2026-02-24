import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../models/user_profile.dart';

/// Provides access to the single [UserProfile] record stored in Hive.
///
/// The profile is a singleton: always stored under [_profileKey].
/// If the box is empty on first launch, [getProfile] returns a new
/// default instance which is persisted on the first [saveProfile] call.
class UserRepository {
  static const _boxName = 'user_profile';
  static const _profileKey = 'profile';

  Box<UserProfile> get _box => Hive.box<UserProfile>(_boxName);

  /// Returns the stored profile, or a fresh default if none exists yet.
  UserProfile getProfile() {
    return _box.get(_profileKey) ?? UserProfile();
  }

  /// Persists [profile] to Hive.
  Future<void> saveProfile(UserProfile profile) {
    return _box.put(_profileKey, profile);
  }

  /// Returns true if a profile has been saved at least once.
  bool get hasProfile => _box.containsKey(_profileKey);
}

final userRepositoryProvider = Provider<UserRepository>(
  (_) => UserRepository(),
);