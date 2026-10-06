import 'dart:convert';
import 'dart:typed_data';

import 'enums.dart';

/// What a friend QR code carries.
///
/// A QR code gets denser (more, smaller squares) the more bytes it holds, and a
/// dense code is hard to scan from a phone screen. The first format was the
/// profile as JSON, base64-encoded: about 315 characters, QR version 19–20 with
/// the error correction the logo needs. Format 2 is a few bytes instead:
///
/// ```
/// caliday://friend?d=BASE64URL(bytes)        (no padding)
///
/// byte    2                    format version
/// 16 B    id                   the 32 hex characters of the peer id, as bytes
/// varint  totalSP
/// varint  currentStreak
/// varint  longestStreak
/// byte    rank index
/// 4 B     branch stages        one nibble per branch, in BranchId order
/// varint  date                 unix seconds of the snapshot
/// rest    display name         UTF-8
/// ```
///
/// Format 1 (`?data=BASE64URL(json)`) is still read, and still written when the
/// id is not a 32-character hex string, so nothing that worked stops working.
/// Phones running an older build do not understand format 2.
///
/// Adding a branch changes the size of the stages field: bump [_formatVersion].
abstract final class FriendQrCodec {
  static const _prefix = 'caliday://friend?';
  static const _formatVersion = 2;

  /// A varint longer than this many bytes cannot be a value we wrote (and would
  /// overflow the 2^53 integers of a web build).
  static const _maxVarintBytes = 7;

  static final _hexId = RegExp(r'^[0-9a-f]{32}$');

  /// Builds the QR text for [json] (keys: v, id, name, sp, streak,
  /// longestStreak, rank, stages, date — the same map BLE sends).
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

  // ── format 2 ────────────────────────────────────────────────────────────────

  static String? _tryEncodeCompact(Map<String, dynamic> json) {
    final id = json['id'];
    final name = json['name'];
    final sp = json['sp'];
    final streak = json['streak'];
    final longest = json['longestStreak'];
    final rank = json['rank'];
    final date = json['date'];
    final stages = json['stages'];
    if (id is! String || !_hexId.hasMatch(id)) return null;
    if (name is! String || name.isEmpty) return null;
    if (sp is! int || streak is! int || longest is! int || date is! int) {
      return null;
    }
    if (sp < 0 || streak < 0 || longest < 0 || date < 0) return null;
    if (rank is! int || rank < 0 || rank >= Rank.values.length) return null;
    if (stages != null && stages is! Map) return null;

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

    final branches = BranchId.values;
    final nibbles = [
      for (final b in branches)
        _clampNibble((stages as Map?)?[b.name]),
    ];
    for (var i = 0; i < nibbles.length; i += 2) {
      final low = i + 1 < nibbles.length ? nibbles[i + 1] : 0;
      out.addByte((nibbles[i] << 4) | low);
    }

    _writeVarint(out, date);
    out.add(utf8.encode(name));
    return base64Url.encode(out.toBytes()).replaceAll('=', '');
  }

  static Map<String, dynamic>? _decodeCompact(String text) {
    final bytes = base64Url.decode(base64Url.normalize(text));
    final branches = BranchId.values;
    final stageBytes = (branches.length + 1) ~/ 2;
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

    if (readByte() != _formatVersion) return null;

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

    final stages = <String, int>{};
    for (var i = 0; i < stageBytes; i++) {
      final b = readByte();
      for (final (index, value) in [(2 * i, b >> 4), (2 * i + 1, b & 0x0f)]) {
        if (index < branches.length && value > 0) {
          stages[branches[index].name] = value;
        }
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
      'stages': stages,
      'date': date,
    };
  }

  static int _clampNibble(Object? stage) =>
      stage is num ? stage.toInt().clamp(0, 15) : 0;

  /// Unsigned LEB128, by arithmetic so it also works with web integers.
  static void _writeVarint(BytesBuilder out, int value) {
    while (value >= 0x80) {
      out.addByte((value % 128) | 0x80);
      value ~/= 128;
    }
    out.addByte(value);
  }
}
