import 'dart:convert';
import 'dart:io';

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

void main() {
  final en = _load('l10n/app_en.arb'); // template (see l10n.yaml)
  final ru = _load('l10n/app_ru.arb');

  test('English and Russian have exactly the same messages', () {
    final enKeys = _messageKeys(en);
    final ruKeys = _messageKeys(ru);
    expect(enKeys.difference(ruKeys), isEmpty, reason: 'missing in Russian');
    expect(ruKeys.difference(enKeys), isEmpty, reason: 'missing in English');
  });

  test('every message is a non-empty string', () {
    for (final arb in [en, ru]) {
      for (final key in _messageKeys(arb)) {
        expect(arb[key], isA<String>(), reason: key);
        expect((arb[key] as String).trim(), isNotEmpty, reason: key);
      }
    }
  });

  test('both languages use the same placeholders', () {
    for (final key in _messageKeys(en)) {
      expect(_declaredPlaceholders(ru, key), _declaredPlaceholders(en, key),
          reason: 'placeholders of "$key" differ between en and ru');
    }
  });

  test('every placeholder used in a message is declared, and vice versa', () {
    for (final (name, arb) in [('en', en), ('ru', ru)]) {
      for (final key in _messageKeys(arb)) {
        final used = _usedPlaceholders(arb[key] as String);
        final declared = _declaredPlaceholders(arb, key);
        expect(used, declared, reason: '$name "$key"');
      }
    }
  });

  test('metadata entries belong to a message', () {
    for (final arb in [en, ru]) {
      final keys = _messageKeys(arb);
      for (final meta in arb.keys.where((k) => k.startsWith('@') && k != '@@locale')) {
        expect(keys, contains(meta.substring(1)), reason: 'orphan $meta');
      }
    }
  });

  test('the locales are declared', () {
    expect(en['@@locale'], 'en');
    expect(ru['@@locale'], 'ru');
  });
}
