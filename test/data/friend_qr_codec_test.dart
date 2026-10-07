import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:caliday/data/models/enums.dart';
import 'package:caliday/data/models/friend_profile.dart';
import 'package:caliday/data/models/friend_qr_codec.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qr_flutter/qr_flutter.dart';

const _id = 'a1b2c3d4e5f60718293a4b5c6d7e8f90';

Map<String, dynamic> _profile({
  String id = _id,
  String name = 'Goro',
  int sp = 5230,
  int streak = 12,
  int longest = 30,
  int rank = 3,
  int date = 1791309000,
}) =>
    {
      'v': 1,
      'id': id,
      'name': name,
      'sp': sp,
      'streak': streak,
      'longestStreak': longest,
      'rank': rank,
      'date': date,
    };

/// A real format 2 code, written by the build before format 3 (0.8.18) for
/// Горо: 5230 SP, streak 12, record 30, rank 3, date 1791309000, and stages
/// in all eight branches.
const _format2Code =
    'caliday://friend?d=AqGyw9Tl9gcYKTpLXG1-j5DuKAweAzISEhHI6ZTWBtCT0L7RgNC-';

/// The first format, as the app wrote it before: JSON, then base64.
String _legacy(Map<String, dynamic> json) =>
    'caliday://friend?data=${base64Url.encode(utf8.encode(jsonEncode(json)))}';

/// QR version needed for [text] at the error correction the logo needs (H).
int _qrVersion(String text) {
  final result = QrValidator.validate(
    data: text,
    version: QrVersions.auto,
    errorCorrectionLevel: QrErrorCorrectLevel.H,
  );
  expect(result.isValid, isTrue);
  return result.qrCode!.typeNumber;
}

void main() {
  group('format 3 round trip', () {
    test('every field comes back', () {
      final json = FriendQrCodec.decode(FriendQrCodec.encode(_profile()))!;
      expect(json['id'], _id);
      expect(json['name'], 'Goro');
      expect(json['sp'], 5230);
      expect(json['streak'], 12);
      expect(json['longestStreak'], 30);
      expect(json['rank'], 3);
      expect(json['date'], 1791309000);
      expect(json.containsKey('stages'), isFalse);
    });

    test('the compact format is the one that gets written', () {
      final text = FriendQrCodec.encode(_profile());
      expect(text, startsWith('caliday://friend?d='));
      expect(text, isNot(contains('=='))); // no padding
      expect(text, isNot(contains('data=')));
    });

    test('numbers on both sides of the varint byte boundaries', () {
      for (final n in [
        0, 1, 127, 128, 255, 16383, 16384, 2097151, 2097152,
        1000000, 2147483647, 2147483648, 4294967296, 1099511627776,
      ]) {
        final json = FriendQrCodec.decode(
            FriendQrCodec.encode(_profile(sp: n, streak: n, longest: n, date: n)))!;
        expect(json['sp'], n, reason: 'sp $n');
        expect(json['streak'], n, reason: 'streak $n');
        expect(json['longestStreak'], n, reason: 'longestStreak $n');
        expect(json['date'], n, reason: 'date $n');
      }
    });

    test('every rank', () {
      for (var r = 0; r < Rank.values.length; r++) {
        expect(FriendQrCodec.decode(FriendQrCodec.encode(_profile(rank: r)))!['rank'], r);
      }
    });

    test('names: ASCII, Cyrillic, emoji, the 30-character maximum', () {
      for (final name in [
        'A',
        'Goro',
        'Пётр Курняков',
        'Горо 🦍',
        'ж' * 30,
        '🦍' * 30,
        'with spaces & symbols = ? # %',
      ]) {
        final json = FriendQrCodec.decode(FriendQrCodec.encode(_profile(name: name)))!;
        expect(json['name'], name);
      }
    });

    test('branch progress is not written: new branches cannot change the format', () {
      // Branch progress is not shared with friends; a map that still carries
      // it (any branches, any number of them) gives the same code.
      final plain = FriendQrCodec.encode(_profile());
      for (final stages in [
        {for (final b in BranchId.values) b.name: 3},
        {'push': 99, 'some_future_branch': 4, 'another': 1},
      ]) {
        expect(FriendQrCodec.encode(_profile()..['stages'] = stages), plain);
      }
    });
  });

  group('format 2 (codes of builds up to 0.8.18) is still read', () {
    test('a real format 2 code: every field, the branch stages skipped', () {
      final json = FriendQrCodec.decode(_format2Code)!;
      expect(json['id'], _id);
      expect(json['name'], 'Горо');
      expect(json['sp'], 5230);
      expect(json['streak'], 12);
      expect(json['longestStreak'], 30);
      expect(json['rank'], 3);
      expect(json['date'], 1791309000);
      expect(json.containsKey('stages'), isFalse);
    });

    test('through FriendProfile, without branch progress', () {
      final friend = FriendProfile.tryParseQrPayload(_format2Code)!;
      expect(friend.displayName, 'Горо');
      expect(friend.totalSP, 5230);
      expect(friend.branchStages, isEmpty);
    });

    test('format 3 is the format 2 bytes without the four stage bytes', () {
      Uint8List bytesOf(String code) =>
          base64Url.decode(base64Url.normalize(code.split('d=').last));
      final v2 = bytesOf(_format2Code);
      final v3 = bytesOf(FriendQrCodec.encode(_profile(name: 'Горо')));
      // version | id, three varints, rank (21 bytes) | 4 stage bytes | date, name
      expect(v2[0], 2);
      expect(v3[0], 3);
      expect(v3.sublist(1, 22), v2.sublist(1, 22));
      expect(v3.sublist(22), v2.sublist(26));
    });
  });

  group('size', () {
    test('a typical profile is about 70 characters and QR version 8', () {
      final text = FriendQrCodec.encode(_profile());
      expect(text.length, lessThan(80));
      expect(_qrVersion(text), lessThanOrEqualTo(8)); // 49 x 49 modules
    });

    test('the longest name keeps the QR at version 13 or below', () {
      // Version 13 is 69 x 69 modules; the old format was 93 x 93 and more.
      final text = FriendQrCodec.encode(_profile(name: 'ж' * 30));
      expect(_qrVersion(text), lessThanOrEqualTo(13));
    });

    test('it is much smaller than the first format', () {
      final json = _profile();
      final compact = FriendQrCodec.encode(json);
      // The first format as builds before format 2 wrote it: with the stages.
      final old = _legacy({...json, 'stages': {for (final b in BranchId.values) b.name: 1}});
      expect(compact.length * 4, lessThan(old.length));
      expect(_qrVersion(compact), lessThan(_qrVersion(old) - 8));
    });
  });

  group('the first format is still understood', () {
    test('a code made by an older build parses (its branch stages ignored)', () {
      final friend = FriendProfile.tryParseQrPayload(
          _legacy(_profile()..['stages'] = {'push': 3, 'core': 2}))!;
      expect(friend.id, _id);
      expect(friend.displayName, 'Goro');
      expect(friend.totalSP, 5230);
      expect(friend.branchStages, isEmpty);
    });

    test('an id that is not 32 hex characters is written in the first format', () {
      for (final id in ['', 'short', 'A1B2C3D4E5F60718293A4B5C6D7E8F90', 'g' * 32]) {
        final text = FriendQrCodec.encode(_profile(id: id));
        expect(text, contains('data='), reason: 'id "$id"');
        expect(FriendQrCodec.decode(text)!['id'], id, reason: 'id "$id"');
      }
    });

    test('values the compact format cannot hold fall back too', () {
      for (final bad in [
        _profile(name: ''),
        _profile(sp: -1),
        _profile(rank: 99),
        _profile()..['sp'] = 12.5,
      ]) {
        expect(FriendQrCodec.encode(bad), contains('data='));
      }
    });
  });

  group('damaged or foreign input is rejected, never thrown', () {
    String compactBytes(List<int> bytes) =>
        'caliday://friend?d=${base64Url.encode(bytes).replaceAll('=', '')}';

    final good = base64Url
        .decode(base64Url.normalize(
            FriendQrCodec.encode(_profile()).split('d=').last));

    test('every truncation of a valid code', () {
      for (var cut = 0; cut < good.length; cut++) {
        // Either null or (when only the name was cut) a shorter name.
        FriendQrCodec.decode(compactBytes(good.sublist(0, cut)));
      }
      expect(FriendQrCodec.decode(compactBytes(good.sublist(0, 10))), isNull);
      expect(FriendQrCodec.decode(compactBytes(const [])), isNull);
    });

    test('an unknown format version', () {
      for (final version in [0, 1, 4, 255]) {
        final bytes = [version, ...good.sublist(1)];
        expect(FriendQrCodec.decode(compactBytes(bytes)), isNull,
            reason: 'version $version');
      }
    });

    test('a rank outside the enum', () {
      // The rank byte follows the version, 16 id bytes and three varints
      // (5230 = 2 bytes, 12 = 1, 30 = 1).
      final bytes = [...good]..[1 + 16 + 2 + 1 + 1] = 200;
      expect(FriendQrCodec.decode(compactBytes(bytes)), isNull);
    });

    test('an endless varint', () {
      for (final version in [2, 3]) {
        final bytes = [version, ...List.filled(16, 1), ...List.filled(12, 0xff)];
        expect(FriendQrCodec.decode(compactBytes(bytes)), isNull);
      }
    });

    test('a name that is not UTF-8, or empty', () {
      final head = good.sublist(0, good.length - 'Goro'.length);
      expect(FriendQrCodec.decode(compactBytes([...head, 0xff, 0xfe, 0xfd])), isNull);
      expect(FriendQrCodec.decode(compactBytes(head)), isNull);
    });

    test('not base64', () {
      expect(FriendQrCodec.decode('caliday://friend?d=%%%'), isNull);
      expect(FriendQrCodec.decode('caliday://friend?d=A'), isNull);
    });

    test('not a CaliDay friend link', () {
      for (final raw in [
        '',
        'hello',
        'https://example.com/?d=AqGy',
        'caliday://workout',
        'caliday://friend',
        'caliday://friend?other=1',
        'caliday://friend?data=@@@',
        'caliday://friend?data=${base64Url.encode(utf8.encode('[1,2]'))}',
      ]) {
        expect(FriendQrCodec.decode(raw), isNull, reason: raw);
      }
    });

    test('random bytes, 500 times, never throw', () {
      final random = Random(42);
      for (var i = 0; i < 500; i++) {
        final bytes = List.generate(random.nextInt(60), (_) => random.nextInt(256));
        if (bytes.isNotEmpty && random.nextBool()) bytes[0] = 2 + random.nextInt(2);
        FriendQrCodec.decode(compactBytes(bytes));
        FriendProfile.tryParseQrPayload(compactBytes(bytes));
      }
    });

    test('a valid code with random bytes flipped never throws', () {
      final random = Random(7);
      for (var i = 0; i < 300; i++) {
        final bytes = [...good];
        for (var k = 0; k < 1 + random.nextInt(3); k++) {
          bytes[random.nextInt(bytes.length)] = random.nextInt(256);
        }
        FriendProfile.tryParseQrPayload(compactBytes(bytes));
      }
    });
  });

  group('through FriendProfile', () {
    test('what one phone shows, the other parses', () {
      final text = FriendProfile.buildQrPayload(_profile(name: 'Горо'));
      final friend = FriendProfile.tryParseQrPayload(text)!;
      expect(friend.id, _id);
      expect(friend.displayName, 'Горо');
      expect(friend.rankIndex, 3);
      expect(friend.profileDate, DateTime.fromMillisecondsSinceEpoch(1791309000 * 1000));
      expect(friend.branchStages, isEmpty);
    });
  });
}
