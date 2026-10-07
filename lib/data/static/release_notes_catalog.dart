import '../../l10n/app_localizations.dart';

/// One release as the user reads it under the bell in the profile.
class ReleaseNote {
  const ReleaseNote({
    required this.version,
    required this.date,
    required this.text,
  });

  /// The marketing version of `pubspec.yaml` ("0.8.15", no build number).
  final String version;

  final DateTime date;

  /// What changed, in the user's words: one string, one change per line (a
  /// newline separates them), from the ARB files like every other text.
  final String Function(AppLocalizations l10n) text;
}

/// The "What's new" history, newest first.
///
/// Every version bump in `pubspec.yaml` needs an entry here (a test fails
/// without it): write what the user sees, not what the code does. Texts live in
/// every ARB file (`l10n/app_<code>.arb`) as `releaseNotes<version without dots>`.
abstract final class ReleaseNotesCatalog {
  static final List<ReleaseNote> all = [
    ReleaseNote(
      version: '0.8.16',
      date: DateTime(2026, 10, 7),
      text: (l) => l.releaseNotes0816,
    ),
    ReleaseNote(
      version: '0.8.15',
      date: DateTime(2026, 10, 7),
      text: (l) => l.releaseNotes0815,
    ),
    ReleaseNote(
      version: '0.8.14',
      date: DateTime(2026, 10, 7),
      text: (l) => l.releaseNotes0814,
    ),
    ReleaseNote(
      version: '0.8.13',
      date: DateTime(2026, 10, 7),
      text: (l) => l.releaseNotes0813,
    ),
    ReleaseNote(
      version: '0.8.12',
      date: DateTime(2026, 10, 7),
      text: (l) => l.releaseNotes0812,
    ),
    ReleaseNote(
      version: '0.8.11',
      date: DateTime(2026, 10, 7),
      text: (l) => l.releaseNotes0811,
    ),
    ReleaseNote(
      version: '0.8.10',
      date: DateTime(2026, 10, 7),
      text: (l) => l.releaseNotes0810,
    ),
  ];

  /// The newest entry: the version this build is.
  static ReleaseNote get latest => all.first;

  /// Negative when [a] is older than [b], 0 when equal, positive when newer.
  /// Compares `major.minor.patch` as numbers (so 0.8.10 is newer than 0.8.9);
  /// a `+build` suffix is ignored and a part that is no number counts as 0.
  static int compareVersions(String a, String b) {
    List<int> parts(String v) => [
          for (final p in v.split('+').first.split('.')) int.tryParse(p) ?? 0,
        ];
    final pa = parts(a);
    final pb = parts(b);
    for (var i = 0; i < 3; i++) {
      final x = i < pa.length ? pa[i] : 0;
      final y = i < pb.length ? pb[i] : 0;
      if (x != y) return x.compareTo(y);
    }
    return 0;
  }

  /// The entries newer than [lastSeen], newest first; all of them when nothing
  /// has been seen yet (null).
  static List<ReleaseNote> unseenSince(String? lastSeen) => lastSeen == null
      ? List.of(all)
      : [for (final n in all) if (compareVersions(n.version, lastSeen) > 0) n];
}
