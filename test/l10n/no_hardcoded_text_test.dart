import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Text the user reads comes from `l10n/*.arb`. A Russian string written
/// straight into the code stays Russian in the English UI (the library's
/// "Сбросить" and the calendar legend did), so Cyrillic outside a comment is
/// only allowed in the files below. The English half is a second check at the
/// end of this file: English cannot be told from code by a scan of the whole
/// source, so it only looks at the places where text is shown (see there).
const _allowed = {
  'lib/features/settings/screens/developer_options_screen.dart':
      'debug-only screen, Russian by design',
  'lib/core/services/notification_service.dart':
      'debugShowNow: a test notification fired from the debug screen',
  'lib/core/l10n/app_languages.dart':
      'the pickers name each language in itself ("Русский"), the same in every UI language',
  'lib/features/settings/screens/settings_screen.dart': 'the DEBUG tile is debug-only',
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

/// Every Dart file under `lib/`, with `/` in the path on every OS (Windows
/// lists `lib\core\...`, which would match no entry of the allow-lists).
Iterable<File> _libFiles() => Directory('lib')
    .listSync(recursive: true)
    .whereType<File>()
    .map((f) => File(f.path.replaceAll(r'\', '/')))
    .where((f) => f.path.endsWith('.dart'))
    .where((f) => !f.path.startsWith('lib/l10n/'));

// ── English ───────────────────────────────────────────────────────────────────

/// Words that read the same in every language: the brand, the unit of the
/// strength points, the unit of the signal strength.
const _sameInEveryLanguage = {'CaliDay', 'SP', 'dBm'};

/// Files that may show English-looking text, and why. Everything under
/// `lib/data/` is left out of the scan: the exercise catalog holds the source
/// text of names, descriptions and tips, and the screens read them through
/// `ExerciseL10n`, never from there.
const _englishAllowed = {
  'lib/features/settings/screens/developer_options_screen.dart':
      'debug-only screen ("OK", "Challenge"), Russian by design',
  'lib/features/settings/screens/settings_screen.dart':
      'the "[DEBUG]" tile is debug-only',
};

/// Where the expression that is shown begins: after `Text(`, or after
/// `label:`, `title:`, `subtitle:`, `hintText:`, `tooltip:` and the like
/// (`label: Text('...')` is the same thing twice, harmlessly).
final _visibleStart = RegExp(
  r'\bText\(\s*|\bText\.rich\(\s*|\b(?:label|labelText|title|subtitle|hintText|helperText|errorText|tooltip|semanticsLabel|semanticLabel|message)\s*:\s*(?:const\s+)?(?:Text\(\s*)?',
);

/// The index just after the string literal that starts at [i] in [s]; an
/// interpolation `${...}` may hold quotes and braces of its own.
int _skipString(String s, int i) {
  final quote = s[i];
  i++;
  while (i < s.length) {
    final c = s[i];
    if (c == r'\') {
      i += 2;
    } else if (c == quote) {
      return i + 1;
    } else if (c == r'$' && i + 1 < s.length && s[i + 1] == '{') {
      var depth = 1;
      i += 2;
      while (i < s.length && depth > 0) {
        if (s[i] == "'" || s[i] == '"') {
          i = _skipString(s, i);
          continue;
        }
        if (s[i] == '{') depth++;
        if (s[i] == '}') depth--;
        i++;
      }
    } else {
      i++;
    }
  }
  return i;
}

/// The string literals of the expression that starts at [start], as
/// (index, text between the quotes): the ones that are shown themselves
/// (`'a'`, `cond ? 'a' : 'b'`, `x + 'a'`), not those that are an argument of a
/// call (`DateFormat('d MMMM')`, `l10n.f('x')`). The expression ends at the
/// comma or the closing bracket that finishes it.
List<(int, String)> _shownLiterals(String src, int start) {
  final literals = <(int, String)>[];
  final stack = <bool>[]; // true: a call or a collection, false: plain grouping
  var i = start;
  while (i < src.length) {
    final c = src[i];
    if (c == "'" || c == '"') {
      final end = _skipString(src, i);
      if (!stack.contains(true)) {
        literals.add((i, src.substring(i + 1, end - 1)));
      }
      i = end;
      continue;
    }
    if (c == '(') {
      var j = i - 1;
      while (j >= 0 && src[j].trim().isEmpty) {
        j--;
      }
      stack.add(j >= 0 && RegExp(r'[A-Za-z0-9_>)\]]').hasMatch(src[j]));
    } else if (c == '[' || c == '{') {
      stack.add(true);
    } else if (c == ')' || c == ']' || c == '}') {
      if (stack.isEmpty) break;
      stack.removeLast();
    } else if (c == ',' && stack.isEmpty) {
      break;
    }
    i++;
  }
  return literals;
}

/// The English-looking literals shown by [file], as `path:line: literal`.
/// Interpolations (`$x`, `${...}`) and the words that are the same in every
/// language do not count; a word is two or more letters.
List<String> _englishLiterals(File file) {
  // Comment lines are blanked, so an example in a doc comment is not a hit.
  final src = [
    for (final l in file.readAsLinesSync())
      l.trimLeft().startsWith('//') ? '' : l,
  ].join('\n');
  final found = <String>{};
  for (final begin in _visibleStart.allMatches(src)) {
    for (final (index, literal) in _shownLiterals(src, begin.end)) {
      var words = literal.replaceAll(RegExp(r'\$\{[^}]*\}|\$\w+'), ' ');
      for (final same in _sameInEveryLanguage) {
        words = words.replaceAll(RegExp('\\b$same\\b'), ' ');
      }
      if (RegExp('[A-Za-z]{2,}').hasMatch(words)) {
        final line = '\n'.allMatches(src.substring(0, index)).length + 1;
        found.add('${file.path}:$line: $literal');
      }
    }
  }
  return found.toList();
}

Iterable<File> _screenAndLogicFiles() => _libFiles().where((f) =>
    !f.path.startsWith('lib/data/') && !f.path.endsWith('.g.dart'));

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

  group('English text', () {
    test('no English is written into the places where text is shown', () {
      final offenders = [
        for (final file in _screenAndLogicFiles())
          if (!_englishAllowed.containsKey(file.path)) ..._englishLiterals(file),
      ];
      expect(offenders, isEmpty,
          reason: 'move these to l10n/app_en.arb + app_ru.arb:\n${offenders.join('\n')}');
    });

    test('every file allowed to show English still does', () {
      for (final path in _englishAllowed.keys) {
        expect(File(path).existsSync(), isTrue, reason: '$path is gone');
        expect(_englishLiterals(File(path)), isNotEmpty,
            reason: '$path shows no English text any more: drop it from the list');
      }
    });

    test('the scan sees what it is meant to (it is not blind)', () {
      // A scan that matches nothing would pass forever: check it on text that
      // has to be found, and on text that must not.
      final dir = Directory.systemTemp.createTempSync('english_scan_');
      addTearDown(() => dir.deleteSync(recursive: true));
      File write(String body) =>
          File('${dir.path}/probe.dart')..writeAsStringSync(body);

      expect(_englishLiterals(write("Text('Reset')")), hasLength(1));
      expect(_englishLiterals(write("const Text(\n  'Start workout',\n)")), hasLength(1));
      expect(_englishLiterals(write("label: 'All',")), hasLength(1));
      expect(_englishLiterals(write("title: const Text('Settings')")), hasLength(1));
      expect(_englishLiterals(write('hintText: "Search",')), hasLength(1));
      expect(_englishLiterals(write("tooltip: 'Close \$name'")), hasLength(1));
      expect(_englishLiterals(write("Text(done ? 'Done' : 'Open')")), hasLength(2),
          reason: 'a literal in a ternary is shown too');
      expect(_englishLiterals(write("Text(l10n.homeCount(n) + ' items')")), hasLength(1));
      expect(_englishLiterals(write("Text(cond ? l10n.a : 'Again', maxLines: 1)")), hasLength(1));

      expect(_englishLiterals(write("Text('\${x.name} SP')")), isEmpty,
          reason: 'only interpolations and a word that is the same everywhere');
      expect(_englishLiterals(write("Text('CaliDay')")), isEmpty);
      expect(_englishLiterals(write("Text('\${device.rssi} dBm')")), isEmpty);
      expect(_englishLiterals(write("Text(l10n.homeTitle)")), isEmpty);
      expect(_englishLiterals(write("Text(cond ? l10n.a : l10n.b)")), isEmpty);
      expect(_englishLiterals(write("Text(DateFormat('d MMMM', 'ru').format(day))")), isEmpty,
          reason: 'a date pattern is an argument, not text');
      expect(_englishLiterals(write("Text(l10n.homeTitle, style: const TextStyle(fontFamily: 'Roboto'))")),
          isEmpty,
          reason: 'only the first argument of Text is shown');
      expect(_englishLiterals(write("// Text('Reset')")), isEmpty,
          reason: 'a comment');
      expect(_englishLiterals(write("final id = 'reset_button';")), isEmpty,
          reason: 'not a place where text is shown');
    });
  });
}
