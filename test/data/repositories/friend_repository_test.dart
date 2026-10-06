import 'package:caliday/data/models/friend_profile.dart';
import 'package:caliday/data/repositories/friend_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/hive_test_env.dart';

FriendProfile _friend({String id = 'a1b2c3d4e5f60718293a4b5c6d7e8f90', String name = 'Goro'}) =>
    FriendProfile(
      id: id,
      displayName: name,
      totalSP: 5230,
      currentStreak: 12,
      longestStreak: 30,
      rankIndex: 3,
      branchStages: {'push': 3, 'core': 2},
      profileDate: DateTime.fromMillisecondsSinceEpoch(1791309000 * 1000),
      lastSynced: DateTime(2026, 10, 6, 21, 15),
    );

void main() {
  late HiveTestEnv env;
  late FriendRepository repo;

  setUp(() async {
    env = await HiveTestEnv.open();
    repo = FriendRepository();
  });
  tearDown(() => env.dispose());

  test('a saved friend survives a close / reopen, field by field', () async {
    await repo.save(_friend(name: 'Пётр'));
    await env.reopen();
    final f = FriendRepository().getById('a1b2c3d4e5f60718293a4b5c6d7e8f90')!;
    expect(f.displayName, 'Пётр');
    expect(f.totalSP, 5230);
    expect(f.currentStreak, 12);
    expect(f.longestStreak, 30);
    expect(f.rankIndex, 3);
    expect(f.branchStages, {'push': 3, 'core': 2});
    expect(f.profileDate, DateTime.fromMillisecondsSinceEpoch(1791309000 * 1000));
    expect(f.lastSynced, DateTime(2026, 10, 6, 21, 15));
  });

  test('saving the same id again updates instead of duplicating', () async {
    await repo.save(_friend(name: 'Goro'));
    await repo.save(_friend(name: 'Goro 2'));
    expect(repo.count, 1);
    expect(repo.getById('a1b2c3d4e5f60718293a4b5c6d7e8f90')!.displayName, 'Goro 2');
  });

  test('getAll is newest-synced first; delete removes', () async {
    final older = _friend(id: 'aa')..lastSynced = DateTime(2026, 1, 1);
    final newer = _friend(id: 'bb')..lastSynced = DateTime(2026, 6, 1);
    await repo.save(older);
    await repo.save(newer);
    expect(repo.getAll().map((f) => f.id), ['bb', 'aa']);
    await repo.delete('bb');
    expect(repo.getAll().map((f) => f.id), ['aa']);
  });

  test('an empty id (a profile that never got a peerId) can still be stored', () async {
    await repo.save(_friend(id: ''));
    expect(repo.getById(''), isNotNull);
  });
}
