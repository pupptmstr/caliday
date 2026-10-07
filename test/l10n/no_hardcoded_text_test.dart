import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Text the user reads comes from `l10n/*.arb`. A Russian string written
/// straight into the code stays Russian in the English UI (the library's
/// "Сбросить" and the calendar legend did), so Cyrillic outside a comment is
/// only allowed in the files below. English text cannot be told from code by
/// a scan, so this guards the Russian half only.
const _allowed = {
  'lib/features/settings/screens/developer_options_screen.dart':
      'debug-only screen, Russian by design',
  'lib/core/services/notification_service.dart':
      'debugShowNow: a test notification fired from the debug screen',
  'lib/core/services/widget_service.dart':
      'rank names for the home screen widget; they mirror the ARB, pinned by a test',
  'lib/domain/services/notification_planner.dart':
      'its own Russian / English table of notification texts',
  'lib/features/settings/screens/settings_screen.dart':
      'the language picker names each language in itself; the DEBUG tile is debug-only',
  'lib/features/library/providers/exercise_library_provider.dart':
      "the 'ё' that the search folds into 'е'",
};

final _cyrillic = RegExp('[А-Яа-яЁё]');

/// The Cyrillic lines of [file], without the comment part of each line.
List<String> _cyrillicLines(File file) {
  final found = <String>[];
  final lines = file.readAsLinesSync();
  for (var i = 0; i < lines.length; i++) {
    final code = lines[i].split('//').first;
    if (_cyrillic.hasMatch(code)) found.add('${file.path}:${i + 1}: ${lines[i].trim()}');
  }
  return found;
}

Iterable<File> _libFiles() => Directory('lib')
    .listSync(recursive: true)
    .whereType<File>()
    .where((f) => f.path.endsWith('.dart'))
    .where((f) => !f.path.startsWith('lib/l10n/'));

void main() {
  test('no Russian text is written into the code outside the allowed files', () {
    final offenders = [
      for (final file in _libFiles())
        if (!_allowed.containsKey(file.path)) ..._cyrillicLines(file),
    ];
    expect(offenders, isEmpty,
        reason: 'move these to l10n/app_en.arb + app_ru.arb:\n${offenders.join('\n')}');
  });

  test('every allowed file still needs its exception', () {
    for (final path in _allowed.keys) {
      expect(File(path).existsSync(), isTrue, reason: '$path is gone');
      expect(_cyrillicLines(File(path)), isNotEmpty,
          reason: '$path has no Russian text any more: drop it from the list');
    }
  });
}
