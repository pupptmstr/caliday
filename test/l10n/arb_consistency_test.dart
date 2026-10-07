import 'dart:convert';
import 'dart:io';

import 'package:caliday/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> _load(String path) =>
    jsonDecode(File(path).readAsStringSync()) as Map<String, dynamic>;

/// Message keys, i.e. everything except `@key` metadata and `@@locale`.
Set<String> _messageKeys(Map<String, dynamic> arb) =>
    arb.keys.where((k) => !k.startsWith('@')).toSet();

/// Names of the placeholders a message actually uses: `{name}` / `{name, ...}`.
Set<String> _usedPlaceholders(String message) => RegExp(r'\{(\w+)[,}]')
    .allMatches(message)
    .map((m) => m.group(1)!)
    .toSet();

Set<String> _declaredPlaceholders(Map<String, dynamic> arb, String key) {
  final meta = arb['@$key'];
  if (meta is! Map) return {};
  final placeholders = meta['placeholders'];
  return placeholders is Map ? placeholders.keys.cast<String>().toSet() : {};
}

const _template = 'en'; // see l10n.yaml

void main() {
  // Every language file, keyed by the code in its name (`app_<code>.arb`).
  final arbs = {
    for (final file in Directory('l10n').listSync().whereType<File>())
      if (RegExp(r'app_(\w+)\.arb$').firstMatch(file.path) case final m?)
        m.group(1)!: _load(file.path),
  };
  final template = arbs[_template]!;
  final others = {...arbs}..remove(_template);

  test('the ARB files are the languages the app is built with', () {
    expect(arbs.keys.toSet(),
        AppLocalizations.supportedLocales.map((l) => l.languageCode).toSet(),
        reason: 'run flutter gen-l10n');
    expect(others, isNotEmpty);
  });

  test('every language has exactly the messages of the template', () {
    final keys = _messageKeys(template);
    others.forEach((code, arb) {
      expect(keys.difference(_messageKeys(arb)), isEmpty, reason: 'missing in $code');
      expect(_messageKeys(arb).difference(keys), isEmpty,
          reason: 'in $code but not in $_template');
    });
  });

  test('every message is a non-empty string', () {
    arbs.forEach((code, arb) {
      for (final key in _messageKeys(arb)) {
        expect(arb[key], isA<String>(), reason: '$code $key');
        expect((arb[key] as String).trim(), isNotEmpty, reason: '$code $key');
      }
    });
  });

  test('every language declares the placeholders of the template', () {
    others.forEach((code, arb) {
      for (final key in _messageKeys(template)) {
        expect(_declaredPlaceholders(arb, key), _declaredPlaceholders(template, key),
            reason: 'placeholders of "$key" differ between $_template and $code');
      }
    });
  });

  test('every placeholder used in a message is declared, and vice versa', () {
    arbs.forEach((code, arb) {
      for (final key in _messageKeys(arb)) {
        final used = _usedPlaceholders(arb[key] as String);
        final declared = _declaredPlaceholders(arb, key);
        expect(used, declared, reason: '$code "$key"');
      }
    });
  });

  test('metadata entries belong to a message', () {
    arbs.forEach((code, arb) {
      final keys = _messageKeys(arb);
      for (final meta in arb.keys.where((k) => k.startsWith('@') && k != '@@locale')) {
        expect(keys, contains(meta.substring(1)), reason: '$code: orphan $meta');
      }
    });
  });

  test('each file declares the locale of its name', () {
    arbs.forEach((code, arb) => expect(arb['@@locale'], code));
  });
}
