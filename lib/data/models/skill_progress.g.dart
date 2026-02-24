// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'skill_progress.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SkillProgressAdapter extends TypeAdapter<SkillProgress> {
  @override
  final int typeId = 1;

  @override
  SkillProgress read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SkillProgress(
      branchId: fields[0] as BranchId,
      currentStage: fields[1] as int,
      currentReps: fields[2] as int,
      currentSets: fields[3] as int,
      currentRestSec: fields[4] as int,
      isChallengeUnlocked: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, SkillProgress obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.branchId)
      ..writeByte(1)
      ..write(obj.currentStage)
      ..writeByte(2)
      ..write(obj.currentReps)
      ..writeByte(3)
      ..write(obj.currentSets)
      ..writeByte(4)
      ..write(obj.currentRestSec)
      ..writeByte(5)
      ..write(obj.isChallengeUnlocked);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SkillProgressAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
