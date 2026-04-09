// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'skill_progress.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SkillProgressAdapter extends TypeAdapter<SkillProgress> {
  @override
  final typeId = 1;

  @override
  SkillProgress read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SkillProgress(
      branchId: fields[0] as BranchId,
      currentStage: fields[1] == null ? 1 : (fields[1] as num).toInt(),
      currentReps: fields[2] == null ? 5 : (fields[2] as num).toInt(),
      currentSets: fields[3] == null ? 1 : (fields[3] as num).toInt(),
      currentRestSec: fields[4] == null ? 60 : (fields[4] as num).toInt(),
      isChallengeUnlocked: fields[5] == null ? false : fields[5] as bool,
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
