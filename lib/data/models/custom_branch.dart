import 'package:hive_ce/hive_ce.dart';

part 'custom_branch.g.dart';

/// A branch the user made: catalog exercises in order, each one a stage. The
/// app derives the amounts and the challenge norms (`CustomStages`), so only
/// the choice and the order are stored.
@HiveType(typeId: 12)
class CustomBranch extends HiveObject {
  CustomBranch({
    required this.id,
    required this.name,
    required this.exerciseIds,
    required this.createdAt,
  });

  /// microsecondsSinceEpoch in base 36, like [CustomRoutine.id].
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  /// Exercise ids of the stages, stage 1 first; an id appears once.
  @HiveField(2)
  List<String> exerciseIds;

  @HiveField(3)
  DateTime createdAt;

  /// The start of [keyFor]: built-in branch names never have it.
  static const String keyPrefix = 'custom_';

  /// The key of the branch with [id]: its `SkillProgress` box key and its
  /// entry in `CustomCourse.branchKeys`.
  static String keyFor(String id) => '$keyPrefix$id';
}
