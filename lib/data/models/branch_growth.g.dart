// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'branch_growth.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BranchGrowthAdapter extends TypeAdapter<BranchGrowth> {
  @override
  final typeId = 14;

  @override
  BranchGrowth read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BranchGrowth(
      branchKey: fields[0] as String,
      fromStage: (fields[1] as num).toInt(),
      toStage: (fields[2] as num).toInt(),
      fromAmount: (fields[3] as num).toInt(),
      toAmount: (fields[4] as num).toInt(),
      fromSets: (fields[5] as num).toInt(),
      toSets: (fields[6] as num).toInt(),
      fromRestSec: (fields[7] as num).toInt(),
      toRestSec: (fields[8] as num).toInt(),
      challengeUnlocked: fields[9] == null ? false : fields[9] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, BranchGrowth obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.branchKey)
      ..writeByte(1)
      ..write(obj.fromStage)
      ..writeByte(2)
      ..write(obj.toStage)
      ..writeByte(3)
      ..write(obj.fromAmount)
      ..writeByte(4)
      ..write(obj.toAmount)
      ..writeByte(5)
      ..write(obj.fromSets)
      ..writeByte(6)
      ..write(obj.toSets)
      ..writeByte(7)
      ..write(obj.fromRestSec)
      ..writeByte(8)
      ..write(obj.toRestSec)
      ..writeByte(9)
      ..write(obj.challengeUnlocked);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BranchGrowthAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
