import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/friend_profile.dart';
import '../../../data/repositories/friend_repository.dart';

class FriendsNotifier extends Notifier<List<FriendProfile>> {
  @override
  List<FriendProfile> build() => ref.read(friendRepositoryProvider).getAll();

  /// Saves [friend]. Returns true if it is a new contact, false if updated.
  Future<bool> addOrUpdate(FriendProfile friend) async {
    final repo = ref.read(friendRepositoryProvider);
    final isNew = repo.getById(friend.id) == null;
    await repo.save(friend);
    state = repo.getAll();
    return isNew;
  }

  Future<void> remove(String id) async {
    final repo = ref.read(friendRepositoryProvider);
    await repo.delete(id);
    state = repo.getAll();
  }
}

final friendsProvider =
    NotifierProvider<FriendsNotifier, List<FriendProfile>>(FriendsNotifier.new);

/// Derived count — used in the Profile screen badge.
final friendsCountProvider = Provider<int>(
  (ref) => ref.watch(friendsProvider).length,
);