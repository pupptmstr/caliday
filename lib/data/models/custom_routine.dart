import 'package:hive/hive.dart';

part 'custom_routine.g.dart';

@HiveType(typeId: 11)
class CustomRoutine extends HiveObject {
  CustomRoutine({
    required this.id,
    required this.name,
    required this.exerciseIds,
    required this.createdAt,
    this.lastRunAt,
  });

  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  /// Ordered list of exercise IDs referencing [ExerciseCatalog].
  @HiveField(2)
  List<String> exerciseIds;

  @HiveField(3)
  DateTime createdAt;

  @HiveField(4)
  DateTime? lastRunAt;
}