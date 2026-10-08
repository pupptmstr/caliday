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
    this.perSide = false,
    this.techniqueTip,
    this.imagePath,
    this.animationPath,
    this.tags = const [],
  });

  /// Unique identifier, e.g. "push_s1_wall_pushup".
  final String id;

  /// Display name in English (source text; UI uses ExerciseL10n).
  final String name;

  /// Short description of the exercise in English (source text; UI uses ExerciseL10n).
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

  /// Minimum reps (or seconds for timed) the user must reach in the Challenge
  /// to ENTER this stage from the previous one. It is read from the next stage
  /// when a challenge is generated and judged, so it is unused for stage 1 and
  /// for warmups / cooldowns (0). With 0 any result passes the Challenge.
  final int challengeTargetReps;

  /// Whether this exercise requires gym equipment (e.g. pull-up bar).
  final bool requiresEquipment;

  /// A one-sided hold (a stretch, a balance) done on each side: every set of a
  /// timed exercise runs the hold twice, with a switch-sides countdown between
  /// the two. The amounts (start, target, challenge) are per side.
  final bool perSide;

  /// Holds in one set: 2 for a [perSide] timed exercise, otherwise 1.
  int get holdsPerSet => perSide && type == ExerciseType.timed ? 2 : 1;

  /// Optional short technique cue shown during workout.
  final String? techniqueTip;

  /// Asset path for the exercise illustration image.
  final String? imagePath;

  /// Asset path for the Lottie exercise animation (e.g. "assets/animations/push_s1_wall_pushup.json").
  final String? animationPath;

  /// Semantic tags for filtering in the Exercise Library. Not stored in Hive.
  final List<ExerciseTag> tags;
}