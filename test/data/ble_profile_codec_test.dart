import 'dart:convert';
import 'dart:typed_data';

import 'package:caliday/data/models/ble_profile_codec.dart';
import 'package:caliday/data/models/enums.dart';
import 'package:caliday/data/models/friend_profile.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> _profile({String name = 'Goro'}) => {
      'v': 1,
      'id': 'a1b2c3d4e5f60718293a4b5c6d7e8f90',
      'name': name,
      'sp': 5230,
      'streak': 12,
      'longestStreak': 30,
      'rank': 3,
      'date': 1791309000,
    };

void main() {
  group('round trip', () {
    test('what a phone serves, the other reads', () {
      final back = BleProfileCodec.decode(BleProfileCodec.encode(_profile()))!;
      expect(back, _profile());
    });

    test('through the friend model, as the friends screen does it', () {
      final bytes = BleProfileCodec.encode(_profile(name: 'Пётр 🦍'));
      final friend = FriendProfile.fromBleJson(BleProfileCodec.decode(bytes)!);
      expect(friend.displayName, 'Пётр 🦍');
      expect(friend.totalSP, 5230);
      expect(friend.branchStages, isEmpty); // not shared with friends
    });

    test('branch stages from an older build are ignored', () {
      final older = {..._profile(), 'stages': {for (final b in BranchId.values) b.name: 3}};
      final friend = FriendProfile.fromBleJson(
          BleProfileCodec.decode(BleProfileCodec.encode(older))!);
      expect(friend.totalSP, 5230);
      expect(friend.branchStages, isEmpty);
    });

    test('the payload is plain UTF-8 JSON, readable by older builds', () {
      final bytes = BleProfileCodec.encode(_profile());
      expect(jsonDecode(utf8.decode(bytes)), _profile());
    });
  });

  group('size', () {
    test('a typical profile fits one GATT value with room to spare', () {
      expect(BleProfileCodec.encode(_profile()).length, lessThan(BleProfileCodec.maxBytes ~/ 2));
    });

    test('the worst case still fits: longest name of 4-byte characters, big numbers', () {
      final worst = _profile(name: '🦍' * 30)
        ..['sp'] = 99999999
        ..['streak'] = 99999
        ..['longestStreak'] = 99999
        ..['rank'] = 5;
      expect(BleProfileCodec.encode(worst).length, lessThanOrEqualTo(BleProfileCodec.maxBytes));
    });
  });

  group('garbage is null, never an exception', () {
    test('an empty read', () {
      expect(BleProfileCodec.decode(Uint8List(0)), isNull);
    });

    test('not JSON, or JSON that is not an object', () {
      expect(BleProfileCodec.decode(utf8.encode('hello')), isNull);
      expect(BleProfileCodec.decode(utf8.encode('[1,2,3]')), isNull);
      expect(BleProfileCodec.decode(utf8.encode('"text"')), isNull);
      expect(BleProfileCodec.decode(utf8.encode('42')), isNull);
      expect(BleProfileCodec.decode(utf8.encode('null')), isNull);
    });

    test('not UTF-8', () {
      expect(BleProfileCodec.decode([0xff, 0xfe, 0xfd]), isNull);
    });

    test('a transfer cut off in the middle', () {
      final bytes = BleProfileCodec.encode(_profile());
      for (final cut in [1, 20, bytes.length ~/ 2, bytes.length - 1]) {
        expect(BleProfileCodec.decode(bytes.sublist(0, cut)), isNull, reason: 'cut at $cut');
      }
    });
  });
}
