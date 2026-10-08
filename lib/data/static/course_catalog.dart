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
        CourseId.eveningStretch => const [
            BranchId.eveningBack,
            BranchId.eveningHips,
            BranchId.eveningFolds,
            BranchId.eveningShoulders,
          ],
        CourseId.morningRoutine => const [
            BranchId.morningSpine,
            BranchId.morningJoints,
            BranchId.morningArms,
            BranchId.morningEnergy,
          ],
        // Balance is the Calisthenics branch itself: one progress for both.
        CourseId.yoga => const [
            BranchId.yogaStanding,
            BranchId.yogaOneLeg,
            BranchId.yogaBackbends,
            BranchId.yogaFlow,
            BranchId.balance,
          ],
      };

  /// Whether a bonus workout of [course] adds two exercises of the
  /// supplementary pool. That pool is strength work (Russian twists, side
  /// plank, calf raises), out of place in a calm stretch before sleep.
  static bool addsSupplementary(CourseId course) =>
      course != CourseId.eveningStretch;

  static const List<CourseId> all = CourseId.values;
}
