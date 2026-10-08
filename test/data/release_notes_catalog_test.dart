import 'dart:io';

import 'package:caliday/data/static/release_notes_catalog.dart';
import 'package:caliday/l10n/app_localizations_en.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/all_translations.dart';

/// The "What's new" history has to stay in step with the app: a version that
/// is bumped without a note is a release nobody is told about.
void main() {
  final all = ReleaseNotesCatalog.all;

  test('the newest entry is the version of pubspec.yaml', () {
    final line = File('pubspec.yaml')
        .readAsLinesSync()
        .firstWhere((l) => l.startsWith('version:'));
    final version = line.split(':').last.trim().split('+').first;
    expect(ReleaseNotesCatalog.latest.version, version,
        reason: 'bumped pubspec.yaml? add the user-facing entry to '
            'lib/data/static/release_notes_catalog.dart and every ARB file');
  });

  test('versions are unique and run from newest to oldest', () {
    expect(all.map((n) => n.version).toSet(), hasLength(all.length));
    for (var i = 1; i < all.length; i++) {
      expect(ReleaseNotesCatalog.compareVersions(all[i - 1].version, all[i].version),
          greaterThan(0),
          reason: '${all[i - 1].version} must be newer than ${all[i].version}');
      expect(all[i - 1].date.isBefore(all[i].date), isFalse,
          reason: 'the dates must not run backwards');
    }
  });

  test('every entry has text in every language, one non-empty change per line', () {
    for (final l10n in allTranslations) {
      for (final note in all) {
        final text = note.text(l10n);
        final lines = text.split('\n');
        expect(lines, isNotEmpty);
        for (final line in lines) {
          expect(line.trim(), isNotEmpty,
              reason: '${note.version} (${l10n.localeName}) has an empty line');
        }
      }
    }
    for (final l10n in allTranslations.where((l) => l.localeName != 'en')) {
      for (final note in all) {
        expect(note.text(l10n), isNot(note.text(AppLocalizationsEn())),
            reason: '${note.version}: the ${l10n.localeName} text is the English one');
      }
    }
  });

  group('compareVersions', () {
    test('numbers, not text: 0.8.10 is newer than 0.8.9', () {
      expect(ReleaseNotesCatalog.compareVersions('0.8.10', '0.8.9'), greaterThan(0));
      expect(ReleaseNotesCatalog.compareVersions('0.8.9', '0.8.10'), lessThan(0));
      expect(ReleaseNotesCatalog.compareVersions('1.0.0', '0.99.99'), greaterThan(0));
    });

    test('equal versions, a build suffix and missing parts do not matter', () {
      expect(ReleaseNotesCatalog.compareVersions('0.8.15', '0.8.15'), 0);
      expect(ReleaseNotesCatalog.compareVersions('0.8.15+24', '0.8.15'), 0);
      expect(ReleaseNotesCatalog.compareVersions('1.0', '1.0.0'), 0);
    });

    test('a part that is no number counts as 0', () {
      expect(ReleaseNotesCatalog.compareVersions('0.8.x', '0.8.0'), 0);
    });
  });

  group('unseenSince', () {
    final versions = all.map((n) => n.version).toList();

    test('nothing seen yet: every entry', () {
      expect(ReleaseNotesCatalog.unseenSince(null).map((n) => n.version), versions);
    });

    test('the newest seen: nothing', () {
      expect(ReleaseNotesCatalog.unseenSince(ReleaseNotesCatalog.latest.version), isEmpty);
    });

    test('older seen: only what came after, newest first', () {
      // Everything above 0.8.12 in the history, so a new release needs no edit.
      expect(ReleaseNotesCatalog.unseenSince('0.8.12').map((n) => n.version),
          versions.sublist(0, versions.indexOf('0.8.12')));
      expect(versions.sublist(versions.indexOf('0.8.12') - 2, versions.indexOf('0.8.12')),
          ['0.8.14', '0.8.13']);
    });

    test('a version older than the whole history: every entry', () {
      expect(ReleaseNotesCatalog.unseenSince('0.1.0').map((n) => n.version), versions);
    });

    test('a version newer than the history (a downgrade): nothing', () {
      expect(ReleaseNotesCatalog.unseenSince('9.9.9'), isEmpty);
    });
  });
}
