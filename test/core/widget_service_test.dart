import 'dart:io';

import 'package:caliday/core/l10n/app_languages.dart';
import 'package:caliday/core/router/app_redirect.dart';
import 'package:caliday/core/services/widget_service.dart';
import 'package:caliday/core/services/widget_snapshot.dart';
import 'package:caliday/data/models/user_profile.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

const _swiftDir = 'ios/CaliDayWidget';
const _kotlinDir = 'android/app/src/main/kotlin/com/pupptmstr/caliday';
const _res = 'android/app/src/main/res';

final _cyrillic = RegExp('[А-Яа-яЁё]');

String _readAll(String dir, String ext) => Directory(dir)
    .listSync()
    .whereType<File>()
    .where((f) => f.path.endsWith(ext))
    .map((f) => f.readAsStringSync())
    .join('\n');

/// The native widgets show what [WidgetSnapshot] hands over and add no text
/// of their own. These tests keep Dart, Swift and Kotlin in step.
void main() {
  final swift = _readAll(_swiftDir, '.swift');
  final kotlin = _readAll(_kotlinDir, '.kt');

  setUpAll(() => initializeDateFormatting('en'));

  test('both platforms read every key the app writes', () {
    final keys = WidgetSnapshot.build(
      profile: UserProfile(),
      logs: const [],
      plan: null,
      pace: 1,
      courseName: '',
      ownBranches: const [],
      now: DateTime(2026, 10, 12),
      locale: 'en',
    ).keys;
    for (final key in keys) {
      expect(swift, contains('"$key"'), reason: 'iOS does not read $key');
      expect(kotlin, contains('"$key"'), reason: 'Android does not read $key');
    }
  });

  test('Goro takes the same pose of the day on both platforms', () {
    final swiftPoses = RegExp(r'let poses = \[([^\]]*)\]')
        .firstMatch(swift)!
        .group(1)!
        .split(',')
        .map((s) => s.trim().replaceAll('"', ''))
        .toList();
    final kotlinPoses = RegExp(r'POSES = listOf\(([^)]*)\)')
        .firstMatch(kotlin)!
        .group(1)!
        .split(',')
        .map((s) => s.trim().replaceFirst('R.drawable.goro_pose_', ''))
        .where((s) => s.isNotEmpty)
        .toList();
    expect(swiftPoses, hasLength(6));
    expect(kotlinPoses, swiftPoses);
    for (final pose in swiftPoses) {
      expect(File('$_res/drawable-nodpi/goro_pose_$pose.png').existsSync(), isTrue, reason: pose);
      expect(Directory('$_swiftDir/Assets.xcassets/goro_pose_$pose.imageset').existsSync(), isTrue,
          reason: pose);
    }
  });

  test('the art is the same on both platforms', () {
    final ios = Directory('$_swiftDir/Assets.xcassets')
        .listSync()
        .map((e) => e.path.split('/').last)
        .where((n) => n.endsWith('.imageset'))
        .map((n) => n.replaceAll('.imageset', ''))
        .toSet();
    final android = Directory('$_res/drawable-nodpi')
        .listSync()
        .map((e) => e.path.split('/').last)
        .where((n) => n.startsWith('goro_'))
        .map((n) => n.replaceAll('.png', ''))
        .toSet();
    expect(android, ios);
    for (final mood in ['happy', 'sad', 'angry', 'sleeping', 'supportive']) {
      expect(ios, contains('goro_face_$mood'));
    }
    expect(ios, contains('goro_flex'));
  });

  test('every widget is declared where the app asks it to redraw', () {
    for (final kind in WidgetService.iOSKinds) {
      expect(swift, contains('kind: "$kind"'), reason: kind);
    }
    final manifest = File('android/app/src/main/AndroidManifest.xml').readAsStringSync();
    for (final provider in WidgetService.androidProviders) {
      final name = provider.split('.').last;
      expect(kotlin, contains('class $name '), reason: name);
      expect(manifest, contains('android:name=".$name"'), reason: name);
    }
  });

  test('each widget link opens a place of its own', () {
    final links = {
      ...RegExp(r'caliday://(\w+)').allMatches(swift).map((m) => m.group(1)!),
    };
    final androidLinks = {
      ...RegExp(r'caliday://(\w+)').allMatches(kotlin).map((m) => m.group(1)!),
    };
    expect(links, {'workout', 'home', 'calendar', 'profile'});
    expect(androidLinks, links);
    expect({for (final l in links) deepLinkTarget(Uri.parse('caliday://$l'))},
        hasLength(links.length));
  });

  group('no text of their own', () {
    test('the Android layouts have no Russian', () {
      final layouts = Directory('$_res/layout').listSync().whereType<File>();
      for (final f in layouts) {
        final lines = f.readAsLinesSync().where(_cyrillic.hasMatch);
        expect(lines, isEmpty, reason: f.path);
      }
    });

    test('iOS: Russian only in the gallery texts, which have every language', () {
      // The gallery shows the names before the app has run, so they are the
      // one text the app cannot hand over.
      final table = RegExp(r'func gallery\([^)]*\)[^{]*\{(.*?)\n\}', dotAll: true)
          .firstMatch(swift);
      expect(table, isNotNull, reason: 'gallery() not found');
      final codes = RegExp(r'"(\w\w)": \[')
          .allMatches(table!.group(1)!)
          .map((m) => m.group(1))
          .toSet();
      expect(codes, appLanguages.map((l) => l.code).toSet());

      final outside = swift.replaceFirst(table.group(0)!, '');
      final russian = outside
          .split('\n')
          .map((l) => l.split('//').first)
          .where(_cyrillic.hasMatch)
          .toList();
      expect(russian, isEmpty, reason: russian.join('\n'));
    });

    test('Android: the gallery names in every app language, with the same keys', () {
      Set<String> keysOf(String folder) => RegExp(r'<string name="(\w+)"')
          .allMatches(File('$_res/$folder/widget_strings.xml').readAsStringSync())
          .map((m) => m.group(1)!)
          .toSet();
      final base = keysOf('values');
      expect(base, hasLength(8));
      for (final lang in appLanguages.where((l) => l.code != fallbackLanguageCode)) {
        expect(keysOf('values-${lang.code}'), base, reason: lang.code);
      }
    });
  });
}
