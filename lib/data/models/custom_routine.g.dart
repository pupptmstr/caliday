// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_routine.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CustomRoutineAdapter extends TypeAdapter<CustomRoutine> {
  @override
  final typeId = 11;

  @override
  CustomRoutine read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CustomRoutine(
      id: fields[0] as String,
      name: fields[1] as String,
      exerciseIds: (fields[2] as List).cast<String>(),
      createdAt: fields[3] as DateTime,
      lastRunAt: fields[4] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, CustomRoutine obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.exerciseIds)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.lastRunAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomRoutineAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
