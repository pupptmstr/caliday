import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:treniday/features/settings/screens/about_screen.dart';

void main() {
  test('the testers invite shows only in the web version on an Android phone', () {
    for (final platform in TargetPlatform.values) {
      expect(androidTestersInviteShown(isWeb: true, platform: platform),
          platform == TargetPlatform.android,
          reason: 'web on $platform');
      expect(androidTestersInviteShown(isWeb: false, platform: platform), isFalse,
          reason: 'app on $platform');
    }
  });

  test('the site invites to the same group as the app', () {
    expect(File('site/template.html').readAsStringSync(), contains('href="$androidTestersUrl"'));
  });
}
