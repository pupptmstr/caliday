// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enums.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BranchIdAdapter extends TypeAdapter<BranchId> {
  @override
  final int typeId = 4;

  @override
  BranchId read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return BranchId.push;
      case 1:
        return BranchId.core;
      case 2:
        return BranchId.pull;
      case 3:
        return BranchId.legs;
      case 4:
        return BranchId.balance;
      default:
        return BranchId.push;
    }
  }

  @override
  void write(BinaryWriter writer, BranchId obj) {
    switch (obj) {
      case BranchId.push:
        writer.writeByte(0);
        break;
      case BranchId.core:
        writer.writeByte(1);
        break;
      case BranchId.pull:
        writer.writeByte(2);
        break;
      case BranchId.legs:
        writer.writeByte(3);
        break;
      case BranchId.balance:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BranchIdAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SetTypeAdapter extends TypeAdapter<SetType> {
  @override
  final int typeId = 5;

  @override
  SetType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SetType.daily;
      case 1:
        return SetType.skill;
      case 2:
        return SetType.challenge;
      default:
        return SetType.daily;
    }
  }

  @override
  void write(BinaryWriter writer, SetType obj) {
    switch (obj) {
      case SetType.daily:
        writer.writeByte(0);
        break;
      case SetType.skill:
        writer.writeByte(1);
        break;
      case SetType.challenge:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SetTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ExerciseTypeAdapter extends TypeAdapter<ExerciseType> {
  @override
  final int typeId = 6;

  @override
  ExerciseType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ExerciseType.reps;
      case 1:
        return ExerciseType.timed;
      default:
        return ExerciseType.reps;
    }
  }

  @override
  void write(BinaryWriter writer, ExerciseType obj) {
    switch (obj) {
      case ExerciseType.reps:
        writer.writeByte(0);
        break;
      case ExerciseType.timed:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExerciseTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FitnessGoalAdapter extends TypeAdapter<FitnessGoal> {
  @override
  final int typeId = 8;

  @override
  FitnessGoal read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return FitnessGoal.generalFitness;
      case 1:
        return FitnessGoal.strengthPush;
      case 2:
        return FitnessGoal.calisthenics;
      default:
        return FitnessGoal.generalFitness;
    }
  }

  @override
  void write(BinaryWriter writer, FitnessGoal obj) {
    switch (obj) {
      case FitnessGoal.generalFitness:
        writer.writeByte(0);
        break;
      case FitnessGoal.strengthPush:
        writer.writeByte(1);
        break;
      case FitnessGoal.calisthenics:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FitnessGoalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RankAdapter extends TypeAdapter<Rank> {
  @override
  final int typeId = 7;

  @override
  Rank read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Rank.beginner;
      case 1:
        return Rank.amateur;
      case 2:
        return Rank.sportsman;
      case 3:
        return Rank.athlete;
      case 4:
        return Rank.master;
      case 5:
        return Rank.legend;
      default:
        return Rank.beginner;
    }
  }

  @override
  void write(BinaryWriter writer, Rank obj) {
    switch (obj) {
      case Rank.beginner:
        writer.writeByte(0);
        break;
      case Rank.amateur:
        writer.writeByte(1);
        break;
      case Rank.sportsman:
        writer.writeByte(2);
        break;
      case Rank.athlete:
        writer.writeByte(3);
        break;
      case Rank.master:
        writer.writeByte(4);
        break;
      case Rank.legend:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RankAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
