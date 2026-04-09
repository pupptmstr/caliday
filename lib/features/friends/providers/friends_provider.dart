import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../data/models/friend_profile.dart';
import '../../../data/repositories/friend_repository.dart';

class FriendsNotifier extends StateNotifier<List<FriendProfile>> {
  FriendsNotifier(this._repo) : super(_repo.getAll());

  final FriendRepository _repo;

  /// Saves [friend]. Returns true if it is a new contact, false if updated.
  Future<bool> addOrUpdate(FriendProfile friend) async {
    final isNew = _repo.getById(friend.id) == null;
    await _repo.save(friend);
    state = _repo.getAll();
    return isNew;
  }

  Future<void> remove(String id) async {
    await _repo.delete(id);
    state = _repo.getAll();
  }
}

final friendsProvider =
    StateNotifierProvider<FriendsNotifier, List<FriendProfile>>((ref) {
  return FriendsNotifier(ref.watch(friendRepositoryProvider));
});

/// Derived count — used in the Profile screen badge.
final friendsCountProvider = Provider<int>(
  (ref) => ref.watch(friendsProvider).length,
);