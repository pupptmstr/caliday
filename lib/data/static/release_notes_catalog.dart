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

/// One line of versions (0.8 = 0.8.0 … 0.8.20) told in its main points: the
/// "Version history" part of "What's new", folded under the recent entries.
class ReleaseLine {
  const ReleaseLine({
    required this.version,
    required this.from,
    required this.to,
    required this.text,
  });

  /// "major.minor", e.g. "0.8".
  final String version;

  /// The first and the last day of the line.
  final DateTime from;
  final DateTime to;

  /// The main points, one per line (newline-separated), from the ARB files.
  final String Function(AppLocalizations l10n) text;
}

/// The "What's new" history, newest first.
///
/// Every version bump in `pubspec.yaml` needs an entry here (a test fails
/// without it): write what the user sees, not what the code does. Texts live in
/// every ARB file (`l10n/app_<code>.arb`) as `releaseNotes<version without dots>`.
/// The screen shows the newest [recentCount] entries; all of them stay here.
/// A new minor version (0.10) needs a [lines] entry too, and a change worth
/// remembering a line of its `releaseHistory<major><minor>` text.
abstract final class ReleaseNotesCatalog {
  /// How many of the newest entries "What's new" shows in full.
  static const int recentCount = 6;

  static final List<ReleaseNote> all = [
    ReleaseNote(
      version: '0.9.4',
      date: DateTime(2026, 10, 10),
      text: (l) => l.releaseNotes094,
    ),
    ReleaseNote(
      version: '0.9.3',
      date: DateTime(2026, 10, 9),
      text: (l) => l.releaseNotes093,
    ),
    ReleaseNote(
      version: '0.9.2',
      date: DateTime(2026, 10, 9),
      text: (l) => l.releaseNotes092,
    ),
    ReleaseNote(
      version: '0.9.1',
      date: DateTime(2026, 10, 8),
      text: (l) => l.releaseNotes091,
    ),
    ReleaseNote(
      version: '0.9.0',
      date: DateTime(2026, 10, 8),
      text: (l) => l.releaseNotes090,
    ),
    ReleaseNote(
      version: '0.8.20',
      date: DateTime(2026, 10, 8),
      text: (l) => l.releaseNotes0820,
    ),
    ReleaseNote(
      version: '0.8.19',
      date: DateTime(2026, 10, 7),
      text: (l) => l.releaseNotes0819,
    ),
    ReleaseNote(
      version: '0.8.18',
      date: DateTime(2026, 10, 7),
      text: (l) => l.releaseNotes0818,
    ),
    ReleaseNote(
      version: '0.8.17',
      date: DateTime(2026, 10, 7),
      text: (l) => l.releaseNotes0817,
    ),
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

  /// The entries "What's new" shows in full, newest first.
  static List<ReleaseNote> get recent => all.take(recentCount).toList();

  /// Every line of versions from the first one, newest first. Before
  /// 2026-04-22 the versions were numbered 1.x (1.1 – 1.7 are 0.1 – 0.7 here);
  /// the detailed notes start at 0.8.10, when "What's new" came.
  static final List<ReleaseLine> lines = [
    ReleaseLine(
      version: '0.9',
      from: DateTime(2026, 10, 8),
      to: DateTime(2026, 10, 10),
      text: (l) => l.releaseHistory09,
    ),
    ReleaseLine(
      version: '0.8',
      from: DateTime(2026, 5, 2),
      to: DateTime(2026, 10, 8),
      text: (l) => l.releaseHistory08,
    ),
    ReleaseLine(
      version: '0.7',
      from: DateTime(2026, 4, 7),
      to: DateTime(2026, 4, 9),
      text: (l) => l.releaseHistory07,
    ),
    ReleaseLine(
      version: '0.6',
      from: DateTime(2026, 4, 7),
      to: DateTime(2026, 4, 7),
      text: (l) => l.releaseHistory06,
    ),
    ReleaseLine(
      version: '0.5',
      from: DateTime(2026, 4, 4),
      to: DateTime(2026, 4, 6),
      text: (l) => l.releaseHistory05,
    ),
    ReleaseLine(
      version: '0.4',
      from: DateTime(2026, 3, 22),
      to: DateTime(2026, 3, 28),
      text: (l) => l.releaseHistory04,
    ),
    ReleaseLine(
      version: '0.3',
      from: DateTime(2026, 3, 5),
      to: DateTime(2026, 3, 5),
      text: (l) => l.releaseHistory03,
    ),
    ReleaseLine(
      version: '0.2',
      from: DateTime(2026, 3, 2),
      to: DateTime(2026, 3, 4),
      text: (l) => l.releaseHistory02,
    ),
    ReleaseLine(
      version: '0.1',
      from: DateTime(2026, 2, 25),
      to: DateTime(2026, 3, 1),
      text: (l) => l.releaseHistory01,
    ),
  ];

  /// "major.minor" of [version]: "0.8" for "0.8.15".
  static String lineOf(String version) =>
      version.split('+').first.split('.').take(2).join('.');

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
