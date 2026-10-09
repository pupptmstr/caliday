// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_branch.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CustomBranchAdapter extends TypeAdapter<CustomBranch> {
  @override
  final typeId = 12;

  @override
  CustomBranch read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CustomBranch(
      id: fields[0] as String,
      name: fields[1] as String,
      exerciseIds: (fields[2] as List).cast<String>(),
      createdAt: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, CustomBranch obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.exerciseIds)
      ..writeByte(3)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomBranchAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
