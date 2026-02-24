// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_result.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExerciseResultAdapter extends TypeAdapter<ExerciseResult> {
  @override
  final int typeId = 3;

  @override
  ExerciseResult read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExerciseResult(
      exerciseId: fields[0] as String,
      targetReps: fields[1] as int,
      completedReps: fields[2] as int,
      targetDurationSec: fields[3] as int?,
      actualDurationSec: fields[4] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, ExerciseResult obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.exerciseId)
      ..writeByte(1)
      ..write(obj.targetReps)
      ..writeByte(2)
      ..write(obj.completedReps)
      ..writeByte(3)
      ..write(obj.targetDurationSec)
      ..writeByte(4)
      ..write(obj.actualDurationSec);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExerciseResultAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
