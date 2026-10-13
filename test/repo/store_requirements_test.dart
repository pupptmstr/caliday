import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:treniday/core/l10n/app_languages.dart';

/// What App Store Connect and Google Play check on upload lives in native
/// files no build here runs through the stores; these are the plain-text
/// settings that would get an upload refused (internal_docs/specs/store-listing.md).
void main() {
  group('iOS', () {
    final pbxproj = File('ios/Runner.xcodeproj/project.pbxproj').readAsStringSync();
    final infoPlist = File('ios/Runner/Info.plist').readAsStringSync();

    test('1.0 is for iPhone only: every target builds for device family 1', () {
      final families = RegExp(r'TARGETED_DEVICE_FAMILY = "?([0-9,]+)"?;')
          .allMatches(pbxproj)
          .map((m) => m.group(1))
          .toSet();
      expect(families, {'1'});
      expect(infoPlist, isNot(contains('UISupportedInterfaceOrientations~ipad')));
    });

    test('the app declares it uses no non-exempt encryption', () {
      expect(
        infoPlist,
        matches(RegExp(r'<key>ITSAppUsesNonExemptEncryption</key>\s*<false/>')),
      );
    });

    test('the Health prompts are English in Info.plist and translated for every app language', () {
      for (final key in ['NSHealthShareUsageDescription', 'NSHealthUpdateUsageDescription']) {
        final base = RegExp('<key>$key</key>\\s*<string>([^<]*)</string>')
            .firstMatch(infoPlist)!
            .group(1)!;
        expect(base, isNot(matches(RegExp('[А-Яа-яЁё]'))), reason: '$key must be English');
        for (final language in appLanguages) {
          final strings = File('ios/Runner/${language.code}.lproj/InfoPlist.strings');
          expect(strings.existsSync(), isTrue, reason: '${language.code}.lproj');
          expect(strings.readAsStringSync(), contains('"$key" = "'),
              reason: '$key in ${language.code}');
        }
      }
      expect(pbxproj, contains('InfoPlist.strings in Resources'));
    });

    test('the app and the widget each ship a privacy manifest with the App Group reason', () {
      for (final dir in ['Runner', 'TreniDayWidget']) {
        final manifest = File('ios/$dir/PrivacyInfo.xcprivacy').readAsStringSync();
        expect(manifest, contains('NSPrivacyAccessedAPICategoryUserDefaults'));
        expect(manifest, contains('1C8F.1'));
        expect(manifest, matches(RegExp(r'<key>NSPrivacyTracking</key>\s*<false/>')));
      }
      expect('PrivacyInfo.xcprivacy in Resources */ = {isa = PBXBuildFile'.allMatchesIn(pbxproj), 2,
          reason: 'one in the resources of each target');
    });
  });

  group('Android', () {
    final manifest = File('android/app/src/main/AndroidManifest.xml').readAsStringSync();

    test('no USE_EXACT_ALARM: Play allows it only for alarm clocks and calendars', () {
      expect(manifest, isNot(contains('android.permission.USE_EXACT_ALARM"')));
      expect(manifest, contains('android.permission.SCHEDULE_EXACT_ALARM'));
    });

    test('Health Connect opens the privacy policy on every Android version', () {
      final activity = RegExp(
        r'<activity\s+android:name="\.PermissionsRationaleActivity"[\s\S]*?</activity>',
      ).firstMatch(manifest)?.group(0);
      expect(activity, isNotNull);
      expect(activity, contains('androidx.health.ACTION_SHOW_PERMISSIONS_RATIONALE'));
      final alias = RegExp(r'<activity-alias[\s\S]*?</activity-alias>')
          .firstMatch(manifest)!
          .group(0)!;
      expect(alias, contains('android:targetActivity=".PermissionsRationaleActivity"'));
      expect(alias, contains('android.intent.action.VIEW_PERMISSION_USAGE'));

      final kotlin = File(
        'android/app/src/main/kotlin/com/pupptmstr/treniday/PermissionsRationaleActivity.kt',
      ).readAsStringSync();
      final url = RegExp(r'PRIVACY_POLICY_URL = "([^"]+)"').firstMatch(kotlin)!.group(1)!;
      final about = File('lib/features/settings/screens/about_screen.dart').readAsStringSync();
      expect(about, contains("url: '$url'"), reason: 'the same policy as About');
    });
  });
}

extension on String {
  int allMatchesIn(String text) => RegExp(RegExp.escape(this)).allMatches(text).length;
}
