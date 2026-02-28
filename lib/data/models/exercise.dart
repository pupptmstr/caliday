import 'enums.dart';

/// Static exercise definition embedded in the app catalog.
///
/// Not stored in Hive — loaded from [ExerciseCatalog] at runtime.
/// One [Exercise] corresponds to one progression stage within a branch.
class Exercise {
  const Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.branch,
    required this.stage,
    required this.type,
    required this.startReps,
    required this.targetReps,
    required this.startSets,
    required this.targetSets,
    required this.startRestSec,
    required this.targetRestSec,
    required this.spBase,
    this.challengeTargetReps = 0,
    this.requiresEquipment = false,
    this.techniqueTip,
    this.imagePath,
  });

  /// Unique identifier, e.g. "push_s1_wall_pushup".
  final String id;

  /// Display name in Russian.
  final String name;

  /// Short description of the exercise in Russian.
  final String description;

  final BranchId branch;

  /// Progression stage number (1-based). Use 0 for warmup/cooldown accessories.
  final int stage;

  final ExerciseType type;

  /// Reps or seconds when the stage is first unlocked.
  final int startReps;

  /// Target reps/seconds to achieve before the Challenge test.
  final int targetReps;

  /// Starting number of sets (usually 1).
  final int startSets;

  /// Target number of sets (usually 3).
  final int targetSets;

  /// Rest duration in seconds at the start of this stage.
  final int startRestSec;

  /// Minimum rest in seconds after fully optimising within the stage.
  final int targetRestSec;

  /// SP earned per rep (for [ExerciseType.reps])
  /// or per 10 seconds held (for [ExerciseType.timed]).
  final int spBase;

  /// Minimum reps (or seconds for timed) to complete the Challenge
  /// and advance to the next stage. 0 for warmup/cooldown and final stages.
  final int challengeTargetReps;

  /// Whether this exercise requires gym equipment (e.g. pull-up bar).
  final bool requiresEquipment;

  /// Optional short technique cue shown during workout.
  final String? techniqueTip;

  /// Asset path for the exercise illustration image.
  final String? imagePath;
}