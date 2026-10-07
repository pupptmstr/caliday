import 'dart:convert';
import 'dart:typed_data';

import 'enums.dart';

/// What a friend QR code carries.
///
/// A QR code gets denser (more, smaller squares) the more bytes it holds, and a
/// dense code is hard to scan from a phone screen. The first format was the
/// profile as JSON, base64-encoded: about 315 characters, QR version 19–20 with
/// the error correction the logo needs. Format 3 is a few bytes instead:
///
/// ```
/// caliday://friend?d=BASE64URL(bytes)        (no padding)
///
/// byte    3                    format version
/// 16 B    id                   the 32 hex characters of the peer id, as bytes
/// varint  totalSP
/// varint  currentStreak
/// varint  longestStreak
/// byte    rank index
/// varint  date                 unix seconds of the snapshot
/// rest    display name         UTF-8
/// ```
///
/// Branch progress is not shared with friends (owner's decision, 2026-10-07),
/// so a new branch never changes the format. Format 2 is format 3 with the
/// stages of the first eight branches after the rank byte (4 bytes, one
/// nibble each); it is still read and those bytes are skipped. Format 1
/// (`?data=BASE64URL(json)`) is still read too, and still written when the id
/// is not a 32-character hex string, so nothing that worked stops working.
/// Phones running a build older than format 3 cannot read it.
abstract final class FriendQrCodec {
  static const _prefix = 'caliday://friend?';
  static const _formatVersion = 3;

  /// Format 2, still read: the same fields plus [_v2StageBytes] of branch
  /// stages, which are skipped.
  static const _v2 = 2;
  static const _v2StageBytes = 4;

  /// A varint longer than this many bytes cannot be a value we wrote (and would
  /// overflow the 2^53 integers of a web build).
  static const _maxVarintBytes = 7;

  static final _hexId = RegExp(r'^[0-9a-f]{32}$');

  /// Builds the QR text for [json] (keys: v, id, name, sp, streak,
  /// longestStreak, rank, date — the same map BLE sends). Any other key is not
  /// written in the compact format.
  static String encode(Map<String, dynamic> json) {
    final compact = _tryEncodeCompact(json);
    if (compact != null) return '${_prefix}d=$compact';
    return '${_prefix}data=${base64Url.encode(utf8.encode(jsonEncode(json)))}';
  }

  /// The profile map of a scanned [raw] text, or null if it is not a CaliDay
  /// friend code (or is damaged). Never throws.
  static Map<String, dynamic>? decode(String raw) {
    try {
      final uri = Uri.parse(raw);
      if (uri.scheme != 'caliday' || uri.host != 'friend') return null;

      final compact = uri.queryParameters['d'];
      if (compact != null) return _decodeCompact(compact);

      final data = uri.queryParameters['data'];
      if (data == null) return null;
      final json =
          jsonDecode(utf8.decode(base64Url.decode(base64Url.normalize(data))));
      return json is Map<String, dynamic> ? json : null;
    } catch (_) {
      return null;
    }
  }

  // ── format 3 (and 2) ────────────────────────────────────────────────────────

  static String? _tryEncodeCompact(Map<String, dynamic> json) {
    final id = json['id'];
    final name = json['name'];
    final sp = json['sp'];
    final streak = json['streak'];
    final longest = json['longestStreak'];
    final rank = json['rank'];
    final date = json['date'];
    if (id is! String || !_hexId.hasMatch(id)) return null;
    if (name is! String || name.isEmpty) return null;
    if (sp is! int || streak is! int || longest is! int || date is! int) {
      return null;
    }
    if (sp < 0 || streak < 0 || longest < 0 || date < 0) return null;
    if (rank is! int || rank < 0 || rank >= Rank.values.length) return null;

    final out = BytesBuilder()
      ..addByte(_formatVersion)
      ..add([
        for (var i = 0; i < 32; i += 2)
          int.parse(id.substring(i, i + 2), radix: 16),
      ]);
    _writeVarint(out, sp);
    _writeVarint(out, streak);
    _writeVarint(out, longest);
    out.addByte(rank);
    _writeVarint(out, date);
    out.add(utf8.encode(name));
    return base64Url.encode(out.toBytes()).replaceAll('=', '');
  }

  static Map<String, dynamic>? _decodeCompact(String text) {
    final bytes = base64Url.decode(base64Url.normalize(text));
    var pos = 0;

    int readByte() {
      if (pos >= bytes.length) throw const FormatException('truncated');
      return bytes[pos++];
    }

    int readVarint() {
      var value = 0;
      var factor = 1; // arithmetic, not shifts: 32-bit shifts on the web
      for (var i = 0; i < _maxVarintBytes; i++) {
        final b = readByte();
        value += (b & 0x7f) * factor;
        if (b < 0x80) return value;
        factor *= 128;
      }
      throw const FormatException('varint too long');
    }

    final version = readByte();
    if (version != _formatVersion && version != _v2) return null;

    if (bytes.length - pos < 16) return null;
    final id = StringBuffer();
    for (var i = 0; i < 16; i++) {
      id.write(readByte().toRadixString(16).padLeft(2, '0'));
    }

    final sp = readVarint();
    final streak = readVarint();
    final longest = readVarint();
    final rank = readByte();
    if (rank >= Rank.values.length) return null;

    if (version == _v2) {
      for (var i = 0; i < _v2StageBytes; i++) {
        readByte();
      }
    }

    final date = readVarint();
    final name = utf8.decode(bytes.sublist(pos)); // throws on bad UTF-8
    if (name.isEmpty) return null;

    return {
      'v': _formatVersion,
      'id': id.toString(),
      'name': name,
      'sp': sp,
      'streak': streak,
      'longestStreak': longest,
      'rank': rank,
      'date': date,
    };
  }

  /// Unsigned LEB128, by arithmetic so it also works with web integers.
  static void _writeVarint(BytesBuilder out, int value) {
    while (value >= 0x80) {
      out.addByte((value % 128) | 0x80);
      value ~/= 128;
    }
    out.addByte(value);
  }
}
