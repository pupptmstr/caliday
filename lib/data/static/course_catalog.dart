import '../models/enums.dart';

/// Static mapping from [CourseId] to its ordered list of [BranchId]s.
///
/// Flex is shared across courses — progress uses the same Hive key in both.
class CourseCatalog {
  CourseCatalog._();

  static List<BranchId> branchesFor(CourseId course) => switch (course) {
        CourseId.calisthenics => const [
            BranchId.push,
            BranchId.pull,
            BranchId.core,
            BranchId.legs,
            BranchId.balance,
            BranchId.flex,
          ],
        CourseId.healthyBody => const [
            BranchId.posture,
            BranchId.neck,
            BranchId.flex,
          ],
      };

  static const List<CourseId> all = CourseId.values;
}
