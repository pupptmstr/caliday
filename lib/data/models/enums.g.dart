// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enums.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BranchIdAdapter extends TypeAdapter<BranchId> {
  @override
  final typeId = 4;

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
      case 5:
        return BranchId.flex;
      case 6:
        return BranchId.posture;
      case 7:
        return BranchId.neck;
      default:
        return BranchId.push;
    }
  }

  @override
  void write(BinaryWriter writer, BranchId obj) {
    switch (obj) {
      case BranchId.push:
        writer.writeByte(0);
      case BranchId.core:
        writer.writeByte(1);
      case BranchId.pull:
        writer.writeByte(2);
      case BranchId.legs:
        writer.writeByte(3);
      case BranchId.balance:
        writer.writeByte(4);
      case BranchId.flex:
        writer.writeByte(5);
      case BranchId.posture:
        writer.writeByte(6);
      case BranchId.neck:
        writer.writeByte(7);
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

class CourseIdAdapter extends TypeAdapter<CourseId> {
  @override
  final typeId = 10;

  @override
  CourseId read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return CourseId.calisthenics;
      case 1:
        return CourseId.healthyBody;
      default:
        return CourseId.calisthenics;
    }
  }

  @override
  void write(BinaryWriter writer, CourseId obj) {
    switch (obj) {
      case CourseId.calisthenics:
        writer.writeByte(0);
      case CourseId.healthyBody:
        writer.writeByte(1);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CourseIdAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SetTypeAdapter extends TypeAdapter<SetType> {
  @override
  final typeId = 5;

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
      case SetType.skill:
        writer.writeByte(1);
      case SetType.challenge:
        writer.writeByte(2);
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
  final typeId = 6;

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
      case ExerciseType.timed:
        writer.writeByte(1);
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

class RankAdapter extends TypeAdapter<Rank> {
  @override
  final typeId = 7;

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
      case Rank.amateur:
        writer.writeByte(1);
      case Rank.sportsman:
        writer.writeByte(2);
      case Rank.athlete:
        writer.writeByte(3);
      case Rank.master:
        writer.writeByte(4);
      case Rank.legend:
        writer.writeByte(5);
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

class FitnessGoalAdapter extends TypeAdapter<FitnessGoal> {
  @override
  final typeId = 8;

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
      case FitnessGoal.strengthPush:
        writer.writeByte(1);
      case FitnessGoal.calisthenics:
        writer.writeByte(2);
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
