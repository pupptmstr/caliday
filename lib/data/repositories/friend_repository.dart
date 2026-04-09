import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive_ce.dart';

import '../models/friend_profile.dart';

class FriendRepository {
  static const _boxName = 'friends';

  Box<FriendProfile> get _box => Hive.box<FriendProfile>(_boxName);

  List<FriendProfile> getAll() {
    final list = _box.values.toList()
      ..sort((a, b) => b.lastSynced.compareTo(a.lastSynced));
    return list;
  }

  FriendProfile? getById(String id) => _box.get(id);

  Future<void> save(FriendProfile friend) => _box.put(friend.id, friend);

  Future<void> delete(String id) => _box.delete(id);

  int get count => _box.length;
}

final friendRepositoryProvider = Provider<FriendRepository>(
  (_) => FriendRepository(),
);