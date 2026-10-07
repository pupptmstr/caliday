import 'package:caliday/data/models/user_profile.dart';
import 'package:caliday/data/repositories/user_repository.dart';
import 'package:caliday/data/static/release_notes_catalog.dart';
import 'package:caliday/features/profile/providers/whats_new_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/hive_test_env.dart';

/// The dot on the bell: lit while there is a "What's new" entry the user has
/// not opened, put out by opening it, kept in the profile.
void main() {
  late HiveTestEnv env;
  setUp(() async => env = await HiveTestEnv.open());
  tearDown(() => env.dispose());

  ProviderContainer open() {
    final c = ProviderContainer();
    addTearDown(c.dispose);
    c.listen(seenReleaseVersionProvider, (_, _) {});
    c.listen(hasUnseenReleaseNotesProvider, (_, _) {});
    return c;
  }

  final latest = ReleaseNotesCatalog.latest.version;

  test('an existing user who has opened nothing sees the dot', () {
    final c = open();
    expect(c.read(seenReleaseVersionProvider), isNull);
    expect(c.read(hasUnseenReleaseNotesProvider), isTrue);
  });

  test('a user who has seen the current version does not', () async {
    await UserRepository()
        .saveProfile(UserProfile(lastSeenReleaseVersion: latest));
    final c = open();
    expect(c.read(hasUnseenReleaseNotesProvider), isFalse);
  });

  test('a user one update behind sees the dot', () async {
    await UserRepository()
        .saveProfile(UserProfile(lastSeenReleaseVersion: '0.8.12'));
    final c = open();
    expect(c.read(hasUnseenReleaseNotesProvider), isTrue);
  });

  test('opening the notes puts the dot out and the profile remembers it', () async {
    final c = open();
    c.read(seenReleaseVersionProvider.notifier).markSeen();

    expect(c.read(seenReleaseVersionProvider), latest);
    expect(c.read(hasUnseenReleaseNotesProvider), isFalse);

    await env.reopen();
    expect(UserRepository().getProfile().lastSeenReleaseVersion, latest,
        reason: 'it has to survive closing the app');
    expect(open().read(hasUnseenReleaseNotesProvider), isFalse);
  });

  test('marking twice changes nothing, and never goes back to an older version', () async {
    await UserRepository()
        .saveProfile(UserProfile(lastSeenReleaseVersion: '9.9.9'));
    final c = open();
    c.read(seenReleaseVersionProvider.notifier).markSeen();
    expect(c.read(seenReleaseVersionProvider), '9.9.9',
        reason: 'a newer version was seen (a downgrade): keep it');
    expect(UserRepository().getProfile().lastSeenReleaseVersion, '9.9.9');
  });

  test('the rest of the profile is left alone', () async {
    await UserRepository().saveProfile(UserProfile(totalSP: 120, displayName: 'Goro'));
    open().read(seenReleaseVersionProvider.notifier).markSeen();
    final p = UserRepository().getProfile();
    expect(p.totalSP, 120);
    expect(p.displayName, 'Goro');
  });
}
