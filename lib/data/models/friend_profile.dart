import 'package:hive/hive.dart';

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

  /// Branch name → current stage (e.g. {'push': 3, 'core': 2}).
  @HiveField(6)
  Map<String, int> branchStages;

  /// When the snapshot was captured on the friend's device.
  @HiveField(7)
  DateTime profileDate;

  /// When we last received an update from this friend.
  @HiveField(8)
  DateTime lastSynced;

  /// Parse from a BLE GATT read (raw UTF-8 JSON, same structure as QR payload).
  static FriendProfile fromBleJson(Map<String, dynamic> json) =>
      fromQrJson(json);

  /// Parse from the QR JSON payload (caliday://friend?data=BASE64URL).
  static FriendProfile fromQrJson(Map<String, dynamic> json) => FriendProfile(
        id: json['id'] as String,
        displayName: json['name'] as String,
        totalSP: (json['sp'] as num).toInt(),
        currentStreak: (json['streak'] as num).toInt(),
        longestStreak: (json['longestStreak'] as num).toInt(),
        rankIndex: (json['rank'] as num).toInt(),
        branchStages: (json['stages'] as Map?)?.map(
              (k, v) => MapEntry(k.toString(), (v as num).toInt()),
            ) ??
            {},
        profileDate: DateTime.fromMillisecondsSinceEpoch(
          (json['date'] as num).toInt() * 1000,
        ),
        lastSynced: DateTime.now(),
      );
}