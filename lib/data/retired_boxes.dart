import 'package:hive_ce/hive_ce.dart';

/// Boxes of features the app no longer has. Their files (IndexedDB databases
/// on the web) are deleted at start-up; the names are never used again.
/// - `friends`: the friends list (`FriendProfile`, typeId 9), removed in 0.9.5.
const retiredBoxes = ['friends'];

/// Deletes whichever [retiredBoxes] are still on disk. A box that is not
/// there, or cannot be deleted now, is skipped: leftover data is harmless.
Future<void> deleteRetiredBoxes() async {
  for (final name in retiredBoxes) {
    try {
      await Hive.deleteBoxFromDisk(name);
    } catch (_) {}
  }
}
