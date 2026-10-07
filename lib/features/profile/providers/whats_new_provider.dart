import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repositories/user_repository.dart';
import '../../../data/static/release_notes_catalog.dart';

/// The version of the newest "What's new" entry the user has opened (null:
/// none yet). Kept in the profile (`UserProfile.lastSeenReleaseVersion`); a new
/// user starts at the current version, so only an update lights the bell.
class SeenReleaseNotifier extends Notifier<String?> {
  @override
  String? build() =>
      ref.read(userRepositoryProvider).getProfile().lastSeenReleaseVersion;

  /// "What's new" was opened: everything up to the newest entry counts as seen.
  void markSeen() {
    final latest = ReleaseNotesCatalog.latest.version;
    final seen = state;
    if (seen != null && ReleaseNotesCatalog.compareVersions(latest, seen) <= 0) {
      return;
    }
    final repo = ref.read(userRepositoryProvider);
    repo.saveProfile(repo.getProfile()..lastSeenReleaseVersion = latest);
    state = latest;
  }
}

final seenReleaseVersionProvider =
    NotifierProvider<SeenReleaseNotifier, String?>(SeenReleaseNotifier.new);

/// True while there is an entry in "What's new" that has not been opened: the
/// dot on the bell.
final hasUnseenReleaseNotesProvider = Provider<bool>((ref) =>
    ReleaseNotesCatalog.unseenSince(ref.watch(seenReleaseVersionProvider))
        .isNotEmpty);
