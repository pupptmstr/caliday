import '../models/enums.dart';
import '../models/exercise.dart';

/// Pool of supplementary exercises without a progression track.
///
/// These are added to bonus workouts (1–2 random picks) to provide
/// variety beyond the main 6 branches. stage = 0 follows the same
/// convention as warmup/cooldown exercises.
class SupplementaryExerciseCatalog {
  SupplementaryExerciseCatalog._();

  static const Exercise obliqueCrunch = Exercise(
    id: 'supp_oblique_crunch',
    name: 'Oblique Crunch',
    description:
        'Lie on your back, knees bent. Bring your right elbow toward your left knee, '
        'then left to right. Alternate sides.',
    branch: BranchId.core,
    stage: 0,
    type: ExerciseType.reps,
    startReps: 10,
    targetReps: 10,
    startSets: 2,
    targetSets: 2,
    startRestSec: 20,
    targetRestSec: 20,
    spBase: 1,
  );

  static const Exercise russianTwists = Exercise(
    id: 'supp_russian_twists',
    name: 'Russian Twists',
    description:
        'Sit with knees slightly raised and torso leaned back. '
        'Rotate your torso left and right — each rotation counts as one rep.',
    branch: BranchId.core,
    stage: 0,
    type: ExerciseType.reps,
    startReps: 12,
    targetReps: 12,
    startSets: 2,
    targetSets: 2,
    startRestSec: 20,
    targetRestSec: 20,
    spBase: 1,
    techniqueTip: 'Keep your back straight, don\'t hunch.',
  );

  static const Exercise sidePlank = Exercise(
    id: 'supp_side_plank',
    name: 'Side Plank',
    description:
        'Forearm side plank — body in a straight line from head to feet. '
        'Hold the position, then repeat on the other side.',
    branch: BranchId.core,
    stage: 0,
    type: ExerciseType.timed,
    startReps: 20,
    targetReps: 20,
    startSets: 2,
    targetSets: 2,
    startRestSec: 20,
    targetRestSec: 20,
    spBase: 1,
    techniqueTip: 'Don\'t let your hips drop — keep the line straight.',
  );

  static const Exercise standingCalfRaise = Exercise(
    id: 'supp_standing_calf_raise',
    name: 'Standing Calf Raise',
    description:
        'Stand tall and slowly rise onto your toes for 2–3 seconds, '
        'then lower down. Hold a wall for balance if needed.',
    branch: BranchId.legs,
    stage: 0,
    type: ExerciseType.reps,
    startReps: 15,
    targetReps: 15,
    startSets: 2,
    targetSets: 2,
    startRestSec: 20,
    targetRestSec: 20,
    spBase: 1,
  );

  static const Exercise singleLegCalfRaise = Exercise(
    id: 'supp_single_leg_calf_raise',
    name: 'Single-Leg Calf Raise',
    description:
        'Stand on one foot. Slowly rise onto your toes and lower back down. '
        'Repeat on the other leg.',
    branch: BranchId.legs,
    stage: 0,
    type: ExerciseType.reps,
    startReps: 10,
    targetReps: 10,
    startSets: 2,
    targetSets: 2,
    startRestSec: 20,
    targetRestSec: 20,
    spBase: 1,
    techniqueTip: 'Slow tempo — more benefit.',
  );

  static const Exercise deadBug = Exercise(
    id: 'supp_dead_bug',
    name: 'Dead Bug',
    description:
        'Lie on your back, arms pointing up, knees bent 90°. '
        'Simultaneously lower your right arm overhead and extend your left leg — almost to the floor. '
        'Return. Alternate.',
    branch: BranchId.core,
    stage: 0,
    type: ExerciseType.reps,
    startReps: 8,
    targetReps: 8,
    startSets: 2,
    targetSets: 2,
    startRestSec: 20,
    targetRestSec: 20,
    spBase: 1,
    techniqueTip: 'Keep your lower back pressed to the floor throughout.',
  );

  static const Exercise birdDog = Exercise(
    id: 'supp_bird_dog',
    name: 'Bird-Dog',
    description:
        'On all fours: simultaneously extend your right arm forward and left leg back. '
        'Hold 2 seconds, return. Alternate sides.',
    branch: BranchId.core,
    stage: 0,
    type: ExerciseType.reps,
    startReps: 8,
    targetReps: 8,
    startSets: 2,
    targetSets: 2,
    startRestSec: 20,
    targetRestSec: 20,
    spBase: 1,
    techniqueTip: 'Don\'t rotate your pelvis — keep it level.',
  );

  static const Exercise neckIsometrics = Exercise(
    id: 'supp_neck_isometrics',
    name: 'Neck Isometrics',
    description:
        'Press your palm against your forehead and resist — neck pushes back. '
        'Then against the back of the head and each temple. Hold 5–10 seconds each direction.',
    branch: BranchId.balance,
    stage: 0,
    type: ExerciseType.timed,
    startReps: 30,
    targetReps: 30,
    startSets: 1,
    targetSets: 1,
    startRestSec: 10,
    targetRestSec: 10,
    spBase: 0,
    techniqueTip: 'Gentle pressure — don\'t force it.',
  );

  static const Exercise wristCircles = Exercise(
    id: 'supp_wrist_circles',
    name: 'Wrist Circles',
    description:
        'Clench your fists and slowly rotate your wrists clockwise and counter-clockwise. '
        'Strengthens forearms and tendons.',
    branch: BranchId.push,
    stage: 0,
    type: ExerciseType.timed,
    startReps: 30,
    targetReps: 30,
    startSets: 1,
    targetSets: 1,
    startRestSec: 0,
    targetRestSec: 0,
    spBase: 0,
  );

  static const List<Exercise> all = [
    obliqueCrunch,
    russianTwists,
    sidePlank,
    standingCalfRaise,
    singleLegCalfRaise,
    deadBug,
    birdDog,
    neckIsometrics,
    wristCircles,
  ];
}