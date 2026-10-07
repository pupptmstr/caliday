import 'dart:io';

import 'package:caliday/core/l10n/app_languages.dart';
import 'package:caliday/core/services/widget_service.dart';
import 'package:caliday/data/models/enums.dart';
import 'package:caliday/l10n/app_localizations_en.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/all_translations.dart';

const _swift = 'ios/CaliDayWidget/CaliDayWidget.swift';
const _kotlinMedium =
    'android/app/src/main/kotlin/com/pupptmstr/caliday/CaliDayWidgetMediumReceiver.kt';
const _layouts = [
  'android/app/src/main/res/layout/caliday_widget_layout.xml',
  'android/app/src/main/res/layout/caliday_widget_medium_layout.xml',
];

final _cyrillic = RegExp('[А-Яа-яЁё]');

/// The native widgets show no text of their own: [WidgetService.texts] hands
/// it over in the app's language. These tests keep the two sides in step.
void main() {
  test('every language: the rank names the app shows and the done label', () {
    for (final l10n in allTranslations) {
      final names = <String>{};
      for (final rank in Rank.values) {
        final texts = WidgetService.texts(rank, l10n.localeName);
        expect(texts['rankName'], rank.localizedName(l10n), reason: l10n.localeName);
        expect(texts['doneLabel'], l10n.widgetDoneLabel, reason: l10n.localeName);
        names.add(texts['rankName']!);
      }
      expect(names, hasLength(Rank.values.length), reason: l10n.localeName);
    }
  });

  test('a language the app does not have gets English', () {
    final en = AppLocalizationsEn();
    for (final rank in Rank.values) {
      expect(WidgetService.texts(rank, 'fr'),
          {'rankName': rank.localizedName(en), 'doneLabel': en.widgetDoneLabel});
    }
  });

  group('the native widgets', () {
    final swift = File(_swift).readAsStringSync();

    test('read every text key the app writes', () {
      final kotlin = File(_kotlinMedium).readAsStringSync();
      for (final key in WidgetService.texts(Rank.beginner, 'en').keys) {
        expect(swift, contains('forKey: "$key"'), reason: 'iOS does not read $key');
        expect(kotlin, contains('getString("$key"'), reason: 'Android does not read $key');
      }
    });

    test('hold no hard-coded text: the Android layouts have no Russian', () {
      for (final path in _layouts) {
        final lines = File(path).readAsLinesSync().where(_cyrillic.hasMatch);
        expect(lines, isEmpty, reason: path);
      }
    });

    test('iOS: Russian only in the gallery description, which has every language', () {
      // The gallery shows the description before the app has run, so it is
      // the one text the app cannot hand over.
      final table = RegExp(r'func galleryDescription\(\)[^{]*\{(.*?)\n\}', dotAll: true)
          .firstMatch(swift);
      expect(table, isNotNull, reason: 'galleryDescription() not found');
      final codes = RegExp(r'"(\w\w)": "[^"]+"')
          .allMatches(table!.group(1)!)
          .map((m) => m.group(1))
          .toSet();
      expect(codes, appLanguages.map((l) => l.code).toSet());

      final russian = swift
          .split('\n')
          .map((l) => l.split('//').first)
          .where(_cyrillic.hasMatch)
          .toList();
      expect(russian, hasLength(1), reason: russian.join('\n'));
      expect(russian.single, contains('"ru":'));
    });
  });
}
