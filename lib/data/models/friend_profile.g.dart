// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend_profile.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FriendProfileAdapter extends TypeAdapter<FriendProfile> {
  @override
  final int typeId = 9;

  @override
  FriendProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FriendProfile(
      id: fields[0] as String,
      displayName: fields[1] as String,
      totalSP: fields[2] as int,
      currentStreak: fields[3] as int,
      longestStreak: fields[4] as int,
      rankIndex: fields[5] as int,
      branchStages: (fields[6] as Map).cast<String, int>(),
      profileDate: fields[7] as DateTime,
      lastSynced: fields[8] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, FriendProfile obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.displayName)
      ..writeByte(2)
      ..write(obj.totalSP)
      ..writeByte(3)
      ..write(obj.currentStreak)
      ..writeByte(4)
      ..write(obj.longestStreak)
      ..writeByte(5)
      ..write(obj.rankIndex)
      ..writeByte(6)
      ..write(obj.branchStages)
      ..writeByte(7)
      ..write(obj.profileDate)
      ..writeByte(8)
      ..write(obj.lastSynced);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FriendProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
