import 'dart:convert';
import 'dart:typed_data';

/// The profile as it travels over Bluetooth: the same map as in the QR code
/// (keys v, id, name, sp, streak, longestStreak, rank, date) as UTF-8
/// JSON in one GATT characteristic. Pure, so the format and its limits can be
/// tested without a radio.
abstract final class BleProfileCodec {
  /// A GATT attribute value is at most 512 bytes (Bluetooth Core Spec, Vol 3
  /// Part F 3.2.9). Anything bigger cannot be read back in full.
  static const maxBytes = 512;

  static Uint8List encode(Map<String, dynamic> profile) =>
      Uint8List.fromList(utf8.encode(jsonEncode(profile)));

  /// The profile map, or null for anything that is not a JSON object in UTF-8
  /// (an empty read, another app's characteristic, a cut-off transfer).
  static Map<String, dynamic>? decode(List<int> bytes) {
    try {
      final json = jsonDecode(utf8.decode(bytes));
      return json is Map<String, dynamic> ? json : null;
    } catch (_) {
      return null;
    }
  }
}
