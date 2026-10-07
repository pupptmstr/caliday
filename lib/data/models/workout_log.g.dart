// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_log.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WorkoutLogAdapter extends TypeAdapter<WorkoutLog> {
  @override
  final typeId = 2;

  @override
  WorkoutLog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorkoutLog(
      date: fields[0] as DateTime,
      setType: fields[1] as SetType,
      exercises: (fields[2] as List).cast<ExerciseResult>(),
      spEarned: (fields[3] as num).toInt(),
      durationSec: (fields[4] as num).toInt(),
      isPrimary: fields[5] == null ? true : fields[5] as bool,
      courseIdIndex: (fields[6] as num?)?.toInt(),
      freezeUsed: fields[7] == null ? false : fields[7] as bool,
      freezeEarned: fields[8] == null ? false : fields[8] as bool,
      estimatedDurationSec: (fields[9] as num?)?.toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, WorkoutLog obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.setType)
      ..writeByte(2)
      ..write(obj.exercises)
      ..writeByte(3)
      ..write(obj.spEarned)
      ..writeByte(4)
      ..write(obj.durationSec)
      ..writeByte(5)
      ..write(obj.isPrimary)
      ..writeByte(6)
      ..write(obj.courseIdIndex)
      ..writeByte(7)
      ..write(obj.freezeUsed)
      ..writeByte(8)
      ..write(obj.freezeEarned)
      ..writeByte(9)
      ..write(obj.estimatedDurationSec);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutLogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
