// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_course.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CustomCourseAdapter extends TypeAdapter<CustomCourse> {
  @override
  final typeId = 13;

  @override
  CustomCourse read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CustomCourse(
      id: fields[0] as String,
      name: fields[1] as String,
      branchKeys: (fields[2] as List).cast<String>(),
      hostIndex: (fields[3] as num).toInt(),
      createdAt: fields[4] as DateTime,
      shown: fields[5] == null ? true : fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, CustomCourse obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.branchKeys)
      ..writeByte(3)
      ..write(obj.hostIndex)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.shown);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomCourseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
