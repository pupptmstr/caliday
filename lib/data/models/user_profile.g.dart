// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserProfileAdapter extends TypeAdapter<UserProfile> {
  @override
  final typeId = 0;

  @override
  UserProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserProfile(
      rank: fields[0] == null ? Rank.beginner : fields[0] as Rank,
      totalSP: fields[1] == null ? 0 : (fields[1] as num).toInt(),
      currentStreak: fields[2] == null ? 0 : (fields[2] as num).toInt(),
      longestStreak: fields[3] == null ? 0 : (fields[3] as num).toInt(),
      streakFreezeCount: fields[4] == null ? 0 : (fields[4] as num).toInt(),
      lastWorkoutDate: fields[5] as DateTime?,
      notificationHour: fields[6] == null ? 9 : (fields[6] as num).toInt(),
      notificationMinute: fields[7] == null ? 0 : (fields[7] as num).toInt(),
      notificationsEnabled: fields[8] == null ? true : fields[8] as bool,
      eveningReminderEnabled: fields[9] == null ? true : fields[9] as bool,
      streakThreatEnabled: fields[10] == null ? true : fields[10] as bool,
      locale: fields[11] as String?,
      preferredWorkoutMinutes: (fields[12] as num?)?.toInt(),
      fitnessGoal: fields[13] as FitnessGoal?,
      themeModeName: fields[14] as String?,
      hasPullUpBar: fields[15] as bool?,
      soundEnabled: fields[19] as bool?,
      hapticEnabled: fields[20] as bool?,
      healthWorkoutsEnabled: fields[21] as bool?,
      healthWeightEnabled: fields[22] as bool?,
      peerId: fields[17] as String?,
      displayName: fields[18] as String?,
      bleDiscoverable: fields[23] as bool?,
      activeCourseIds: (fields[24] as List?)?.cast<int>(),
      activeCourseIndex: (fields[25] as num?)?.toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, UserProfile obj) {
    writer
      ..writeByte(25)
      ..writeByte(0)
      ..write(obj.rank)
      ..writeByte(1)
      ..write(obj.totalSP)
      ..writeByte(2)
      ..write(obj.currentStreak)
      ..writeByte(3)
      ..write(obj.longestStreak)
      ..writeByte(4)
      ..write(obj.streakFreezeCount)
      ..writeByte(5)
      ..write(obj.lastWorkoutDate)
      ..writeByte(6)
      ..write(obj.notificationHour)
      ..writeByte(7)
      ..write(obj.notificationMinute)
      ..writeByte(8)
      ..write(obj.notificationsEnabled)
      ..writeByte(9)
      ..write(obj.eveningReminderEnabled)
      ..writeByte(10)
      ..write(obj.streakThreatEnabled)
      ..writeByte(11)
      ..write(obj.locale)
      ..writeByte(12)
      ..write(obj.preferredWorkoutMinutes)
      ..writeByte(13)
      ..write(obj.fitnessGoal)
      ..writeByte(14)
      ..write(obj.themeModeName)
      ..writeByte(15)
      ..write(obj.hasPullUpBar)
      ..writeByte(17)
      ..write(obj.peerId)
      ..writeByte(18)
      ..write(obj.displayName)
      ..writeByte(19)
      ..write(obj.soundEnabled)
      ..writeByte(20)
      ..write(obj.hapticEnabled)
      ..writeByte(21)
      ..write(obj.healthWorkoutsEnabled)
      ..writeByte(22)
      ..write(obj.healthWeightEnabled)
      ..writeByte(23)
      ..write(obj.bleDiscoverable)
      ..writeByte(24)
      ..write(obj.activeCourseIds)
      ..writeByte(25)
      ..write(obj.activeCourseIndex);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
