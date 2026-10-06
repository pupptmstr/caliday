import 'dart:convert';

import 'package:caliday/data/models/friend_profile.dart';
import 'package:flutter_test/flutter_test.dart';

/// What FriendsScreen puts into the QR code for a typical profile.
Map<String, dynamic> _profileJson({String name = 'Goro'}) => {
      'v': 1,
      'id': 'a1b2c3d4e5f60718293a4b5c6d7e8f90',
      'name': name,
      'sp': 5230,
      'streak': 12,
      'longestStreak': 30,
      'rank': 3,
      'stages': {'push': 3, 'core': 2, 'pull': 1, 'legs': 2},
      'date': 1791309000,
    };

void main() {
  group('QR payload round trip', () {
    test('what one phone shows, the other parses', () {
      final payload = FriendProfile.buildQrPayload(_profileJson());
      final friend = FriendProfile.tryParseQrPayload(payload)!;

      expect(payload, startsWith('caliday://friend?d=')); // compact format
      expect(friend.id, 'a1b2c3d4e5f60718293a4b5c6d7e8f90');
      expect(friend.displayName, 'Goro');
      expect(friend.totalSP, 5230);
      expect(friend.currentStreak, 12);
      expect(friend.longestStreak, 30);
      expect(friend.rankIndex, 3);
      expect(friend.branchStages, {'push': 3, 'core': 2, 'pull': 1, 'legs': 2});
      expect(friend.profileDate,
          DateTime.fromMillisecondsSinceEpoch(1791309000 * 1000));
    });

    test('non-ASCII names survive (UTF-8 inside base64)', () {
      final payload = FriendProfile.buildQrPayload(_profileJson(name: 'Пётр 🦍'));
      expect(FriendProfile.tryParseQrPayload(payload)!.displayName, 'Пётр 🦍');
    });

    test('base64 padding does not break the query string', () {
      // Names of different lengths give 0, 1 and 2 padding characters.
      for (final name in ['A', 'AB', 'ABC', 'ABCD']) {
        final payload = FriendProfile.buildQrPayload(_profileJson(name: name));
        expect(FriendProfile.tryParseQrPayload(payload)?.displayName, name,
            reason: 'name "$name"');
      }
    });

    test('a profile without branch stages still parses', () {
      final json = _profileJson()..remove('stages');
      final friend =
          FriendProfile.tryParseQrPayload(FriendProfile.buildQrPayload(json))!;
      expect(friend.branchStages, isEmpty);
    });

    test('a payload with all eight branches stays small', () {
      // Guard against the payload growing: a bigger one needs a denser QR code
      // that is harder to scan from a screen (sizes: friend_qr_codec_test.dart).
      final json = _profileJson()
        ..['stages'] = {
          'push': 3, 'core': 2, 'pull': 1, 'legs': 2,
          'balance': 1, 'flex': 2, 'posture': 1, 'neck': 1,
        };
      expect(FriendProfile.buildQrPayload(json).length, lessThan(100));
    });
  });

  group('anything else is rejected (null), never an exception', () {
    String wrap(String json) =>
        'caliday://friend?data=${base64Url.encode(utf8.encode(json))}';

    test('not a CaliDay link', () {
      expect(FriendProfile.tryParseQrPayload('https://example.com/?data=abc'),
          isNull);
      expect(FriendProfile.tryParseQrPayload('hello'), isNull);
      expect(FriendProfile.tryParseQrPayload(''), isNull);
    });

    test('right scheme, wrong host or no data', () {
      expect(FriendProfile.tryParseQrPayload('caliday://workout'), isNull);
      expect(FriendProfile.tryParseQrPayload('caliday://friend'), isNull);
      expect(FriendProfile.tryParseQrPayload('caliday://friend?other=1'), isNull);
    });

    test('data that is not base64 or not JSON', () {
      expect(FriendProfile.tryParseQrPayload('caliday://friend?data=@@@'), isNull);
      expect(FriendProfile.tryParseQrPayload(wrap('not json')), isNull);
      expect(FriendProfile.tryParseQrPayload(wrap('[1,2,3]')), isNull);
    });

    test('JSON with missing or mistyped fields', () {
      expect(FriendProfile.tryParseQrPayload(wrap('{}')), isNull);
      expect(
          FriendProfile.tryParseQrPayload(
              wrap(jsonEncode(_profileJson()..['sp'] = 'lots'))),
          isNull);
      expect(
          FriendProfile.tryParseQrPayload(
              wrap(jsonEncode(_profileJson()..remove('id')))),
          isNull);
    });
  });
}
