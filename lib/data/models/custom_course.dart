import 'package:hive_ce/hive_ce.dart';

part 'custom_course.g.dart';

/// A course the user put together from branches: built-in ones (their
/// progress is shared with the built-in courses) and their own.
@HiveType(typeId: 13)
class CustomCourse extends HiveObject {
  CustomCourse({
    required this.id,
    required this.name,
    required this.branchKeys,
    required this.hostIndex,
    required this.createdAt,
  });

  /// microsecondsSinceEpoch in base 36, like [CustomRoutine.id].
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  /// The branches in rotation order, by `Branch.key`: a built-in branch by
  /// its name ("push"), the user's own one by `CustomBranch.keyFor`.
  @HiveField(2)
  List<String> branchKeys;

  /// `CourseId.index` of the course whose host leads this one (Goro, Raffi,
  /// Luna, Aurora or Miso).
  @HiveField(3)
  int hostIndex;

  @HiveField(4)
  DateTime createdAt;
}
