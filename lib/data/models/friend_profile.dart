import 'package:hive_ce/hive_ce.dart';

import 'friend_qr_codec.dart';

part 'friend_profile.g.dart';

@HiveType(typeId: 9)
class FriendProfile extends HiveObject {
  FriendProfile({
    required this.id,
    required this.displayName,
    required this.totalSP,
    required this.currentStreak,
    required this.longestStreak,
    required this.rankIndex,
    required this.branchStages,
    required this.profileDate,
    required this.lastSynced,
  });

  @HiveField(0)
  String id;

  @HiveField(1)
  String displayName;

  @HiveField(2)
  int totalSP;

  @HiveField(3)
  int currentStreak;

  @HiveField(4)
  int longestStreak;

  /// Index into [Rank.values].
  @HiveField(5)
  int rankIndex;

  /// Branch name → current stage. No longer filled or shown: branch progress
  /// is not shared with friends since 0.8.19 (see FriendQrCodec). Kept so the
  /// stored friends keep their Hive layout.
  @HiveField(6)
  Map<String, int> branchStages;

  /// When the snapshot was captured on the friend's device.
  @HiveField(7)
  DateTime profileDate;

  /// When we last received an update from this friend.
  @HiveField(8)
  DateTime lastSynced;

  /// The text a friend QR code carries (see [FriendQrCodec] for the format).
  static String buildQrPayload(Map<String, dynamic> json) =>
      FriendQrCodec.encode(json);

  /// Parses what [buildQrPayload] produced (either format); null for anything
  /// else (another scheme or host, no data, bad encoding, missing or mistyped
  /// fields).
  static FriendProfile? tryParseQrPayload(String raw) {
    final json = FriendQrCodec.decode(raw);
    if (json == null) return null;
    try {
      return fromQrJson(json);
    } catch (_) {
      return null;
    }
  }

  /// Parse from a BLE GATT read (raw UTF-8 JSON, same structure as QR payload).
  static FriendProfile fromBleJson(Map<String, dynamic> json) =>
      fromQrJson(json);

  /// Parse from the profile map of a QR code or a BLE read.
  static FriendProfile fromQrJson(Map<String, dynamic> json) => FriendProfile(
        id: json['id'] as String,
        displayName: json['name'] as String,
        totalSP: (json['sp'] as num).toInt(),
        currentStreak: (json['streak'] as num).toInt(),
        longestStreak: (json['longestStreak'] as num).toInt(),
        rankIndex: (json['rank'] as num).toInt(),
        // Branch progress is no longer shared (see FriendQrCodec); a code or a
        // BLE read from an older build may still carry it and it is ignored.
        branchStages: {},
        profileDate: DateTime.fromMillisecondsSinceEpoch(
          (json['date'] as num).toInt() * 1000,
        ),
        lastSynced: DateTime.now(),
      );
}