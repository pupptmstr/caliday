import '../models/enums.dart';
import '../models/exercise.dart';

/// Static catalog of all exercises used in CaliDay (Push, Core, Pull, Legs, Balance branches).
///
/// Each entry covers one progression stage within a branch. Starting values
/// reflect what a user does on day one of that stage; target values are the
/// goals that must be reached before the Challenge test unlocks.
///
/// SP rules:
///   - [ExerciseType.reps]  → [Exercise.spBase] SP per completed rep.
///   - [ExerciseType.timed] → [Exercise.spBase] SP per 10 seconds held.
class ExerciseCatalog {
  ExerciseCatalog._();

  // ── PUSH ──────────────────────────────────────────────────────────────────

  static const Exercise pushS1WallPushup = Exercise(
    id: 'push_s1_wall_pushup',
    name: 'Wall Push-up',
    description:
        'Stand an arm\'s length from the wall, place palms at chest height. '
        'Bend your arms until your chest touches the wall, then press back.',
    branch: BranchId.push,
    stage: 1,
    type: ExerciseType.reps,
    startReps: 5,
    targetReps: 10,
    startSets: 1,
    targetSets: 3,
    startRestSec: 60,
    targetRestSec: 30,
    spBase: 1,
    techniqueTip: 'Keep your body in a straight line — don\'t let your hips sag.',
    animationPath: 'assets/animations/push_s1_wall_pushup.json',
  );

  static const Exercise pushS2KneePushup = Exercise(
    id: 'push_s2_knee_pushup',
    name: 'Knee Push-up',
    description:
        'Push-up with knees on the floor. Keep your body in a straight line '
        'from knees to head. Lower your chest to the floor, then press up.',
    branch: BranchId.push,
    stage: 2,
    type: ExerciseType.reps,
    startReps: 5,
    targetReps: 15,
    startSets: 1,
    targetSets: 3,
    startRestSec: 60,
    targetRestSec: 30,
    spBase: 1,
    challengeTargetReps: 3,
    techniqueTip: 'Don\'t drop your hips — maintain a straight line from knees to shoulders.',
    animationPath: 'assets/animations/push_s2_knee_pushup.json',
  );

  static const Exercise pushS3FullPushup = Exercise(
    id: 'push_s3_full_pushup',
    name: 'Full Push-up',
    description:
        'Classic push-up position. Body in a straight line from heels to head. '
        'Chest touches or comes within 2–3 cm of the floor.',
    branch: BranchId.push,
    stage: 3,
    type: ExerciseType.reps,
    startReps: 3,
    targetReps: 20,
    startSets: 1,
    targetSets: 3,
    startRestSec: 60,
    targetRestSec: 30,
    spBase: 2,
    challengeTargetReps: 3,
    techniqueTip: 'Brace your core and glutes to prevent your hips from sagging.',
    animationPath: 'assets/animations/push_s3_full_pushup.json',
  );

  static const Exercise pushS4DiamondPushup = Exercise(
    id: 'push_s4_diamond_pushup',
    name: 'Diamond Push-up',
    description:
        'Hands under your chest, thumbs and index fingers forming a diamond. '
        'Triceps focus. Keep elbows close to the body while lowering.',
    branch: BranchId.push,
    stage: 4,
    type: ExerciseType.reps,
    startReps: 3,
    targetReps: 15,
    startSets: 1,
    targetSets: 3,
    startRestSec: 60,
    targetRestSec: 30,
    spBase: 2,
    challengeTargetReps: 5,
    techniqueTip: 'Keep elbows in — they should slide along your sides, not flare out.',
    animationPath: 'assets/animations/push_s4_diamond_pushup.json',
  );

  static const Exercise pushS5WidePushup = Exercise(
    id: 'push_s5_wide_pushup',
    name: 'Wide Push-up',
    description:
        'Hands significantly wider than shoulder-width. Lower slowly, keeping '
        'your body in a straight line. Loads chest and triceps through a wide range.',
    branch: BranchId.push,
    stage: 5,
    type: ExerciseType.reps,
    startReps: 5,
    targetReps: 15,
    startSets: 1,
    targetSets: 3,
    startRestSec: 60,
    targetRestSec: 30,
    spBase: 3,
    challengeTargetReps: 3,
    techniqueTip: 'The wider the hands, the more chest activation and less triceps.',
    animationPath: 'assets/animations/push_s5_wide_pushup.json',
  );

  static const Exercise pushS6ArcherPushup = Exercise(
    id: 'push_s6_archer_pushup',
    name: 'Archer Push-up',
    description:
        'Wide hand placement. Lower toward one hand while keeping the other arm straight. '
        'Alternate sides each rep.',
    branch: BranchId.push,
    stage: 6,
    type: ExerciseType.reps,
    startReps: 2,
    targetReps: 10,
    startSets: 1,
    targetSets: 3,
    startRestSec: 90,
    targetRestSec: 45,
    spBase: 5,
    challengeTargetReps: 2,
    techniqueTip: 'Working arm gets full range of motion; straight arm on the floor provides support.',
    animationPath: 'assets/animations/push_s6_archer_pushup.json',
  );

  static const Exercise pushS7HandstandPushup = Exercise(
    id: 'push_s7_handstand_pushup',
    name: 'Handstand Push-up',
    description:
        'Kick up into a wall handstand (back to wall). Slowly lower your head '
        'toward the floor, then press back up.',
    branch: BranchId.push,
    stage: 7,
    type: ExerciseType.reps,
    startReps: 1,
    targetReps: 10,
    startSets: 1,
    targetSets: 3,
    startRestSec: 120,
    targetRestSec: 60,
    spBase: 5,
    challengeTargetReps: 1,
    techniqueTip: 'Spread fingers wide for stability. Gaze between your hands.',
    animationPath: 'assets/animations/push_s7_handstand_pushup.json',
  );

  // ── CORE ──────────────────────────────────────────────────────────────────

  static const Exercise coreS1Crunches = Exercise(
    id: 'core_s1_crunches',
    name: 'Crunches',
    description:
        'Lie on your back with knees bent. Hands behind your head or crossed on your chest. '
        'Lift shoulder blades off the floor by contracting your abs.',
    branch: BranchId.core,
    stage: 1,
    type: ExerciseType.reps,
    startReps: 5,
    targetReps: 20,
    startSets: 1,
    targetSets: 3,
    startRestSec: 60,
    targetRestSec: 20,
    spBase: 1,
    techniqueTip: 'Don\'t pull your neck with your hands — lead with your chest toward the ceiling.',
    animationPath: 'assets/animations/core_s1_crunches.json',
  );

  static const Exercise coreS2Plank = Exercise(
    id: 'core_s2_plank',
    name: 'Plank',
    description:
        'Forearm plank position. Body in a straight line from heels to head. '
        'Don\'t raise your hips or let your lower back sag.',
    branch: BranchId.core,
    stage: 2,
    type: ExerciseType.timed,
    startReps: 15, // seconds
    targetReps: 60, // seconds
    startSets: 1,
    targetSets: 3,
    startRestSec: 45,
    targetRestSec: 20,
    spBase: 2, // per 10 seconds
    challengeTargetReps: 30,
    techniqueTip: 'Squeeze your abs and glutes. Breathe evenly — don\'t hold your breath.',
    animationPath: 'assets/animations/core_s2_plank.json',
  );

  static const Exercise coreS3LyingLegRaise = Exercise(
    id: 'core_s3_lying_leg_raise',
    name: 'Lying Leg Raise',
    description:
        'Lie on your back with hands under your hips. Raise straight legs to vertical, '
        'then slowly lower without touching the floor.',
    branch: BranchId.core,
    stage: 3,
    type: ExerciseType.reps,
    startReps: 5,
    targetReps: 15,
    startSets: 1,
    targetSets: 3,
    startRestSec: 45,
    targetRestSec: 20,
    spBase: 1,
    challengeTargetReps: 5,
    techniqueTip: 'Keep your lower back pressed to the floor throughout the movement.',
    animationPath: 'assets/animations/core_s3_lying_leg_raise.json',
  );

  static const Exercise coreS4HangingLegRaise = Exercise(
    id: 'core_s4_hanging_leg_raise',
    name: 'Hanging Leg Raise',
    description:
        'Hang from a bar. Raise straight legs to parallel or higher. '
        'Control the lowering phase.',
    branch: BranchId.core,
    stage: 4,
    type: ExerciseType.reps,
    startReps: 3,
    targetReps: 10,
    startSets: 1,
    targetSets: 3,
    startRestSec: 60,
    targetRestSec: 30,
    spBase: 2,
    challengeTargetReps: 3,
    requiresEquipment: true,
    techniqueTip: 'Don\'t swing — the movement comes from your abs only.',
    animationPath: 'assets/animations/core_s4_hanging_leg_raise.json',
  );

  /// Equipment-free alternative to [coreS4HangingLegRaise] for users without a pull-up bar.
  static const Exercise coreS4FlutterKicks = Exercise(
    id: 'core_s4_flutter_kicks',
    name: 'Flutter Kicks',
    description:
        'Lie on your back with hands under your hips. Lift legs 15–20 cm off the floor. '
        'Alternate raising and lowering each leg in small, quick motions. '
        'One rep = one full cycle (right up + left up).',
    branch: BranchId.core,
    stage: 4,
    type: ExerciseType.reps,
    startReps: 10,
    targetReps: 25,
    startSets: 1,
    targetSets: 3,
    startRestSec: 45,
    targetRestSec: 20,
    spBase: 1,
    challengeTargetReps: 10,
    requiresEquipment: false,
    techniqueTip: 'Keep your lower back pressed to the floor. Legs must not touch the floor between reps.',
    animationPath: 'assets/animations/core_s4_flutter_kicks.json',
  );

  static const Exercise coreS5LSit = Exercise(
    id: 'core_s5_l_sit',
    name: 'L-sit',
    description:
        'Support yourself on parallel bars or the floor. Legs straight and parallel to the floor. '
        'Hold the position as long as possible.',
    branch: BranchId.core,
    stage: 5,
    type: ExerciseType.timed,
    startReps: 5, // seconds
    targetReps: 20, // seconds
    startSets: 1,
    targetSets: 3,
    startRestSec: 60,
    targetRestSec: 30,
    spBase: 3, // per 10 seconds
    challengeTargetReps: 5,
    techniqueTip: 'Pull your toes toward you and press shoulders down and back.',
    animationPath: 'assets/animations/core_s5_l_sit.json',
  );

  static const Exercise coreS6DragonFlag = Exercise(
    id: 'core_s6_dragon_flag',
    name: 'Dragon Flag',
    description:
        'Lie on a bench and grip the support behind your head. Raise your body into a straight '
        'line on your shoulder blades, then slowly lower.',
    branch: BranchId.core,
    stage: 6,
    type: ExerciseType.reps,
    startReps: 1,
    targetReps: 5,
    startSets: 1,
    targetSets: 3,
    startRestSec: 90,
    targetRestSec: 60,
    spBase: 5,
    challengeTargetReps: 1,
    techniqueTip: 'Start with just the negative phase (lowering only) — it\'s easier.',
    animationPath: 'assets/animations/core_s6_dragon_flag.json',
  );

  // ── PULL ──────────────────────────────────────────────────────────────────

  static const Exercise pullS1Australian = Exercise(
    id: 'pull_s1_australian',
    name: 'Australian Pull-up',
    description:
        'Lie under a bar with hands slightly wider than shoulders. Pull your chest to the bar, '
        'keeping your body in a straight line. Control the lowering.',
    branch: BranchId.pull,
    stage: 1,
    type: ExerciseType.reps,
    startReps: 5,
    targetReps: 15,
    startSets: 1,
    targetSets: 3,
    startRestSec: 90,
    targetRestSec: 30,
    spBase: 1,
    challengeTargetReps: 2,
    requiresEquipment: true,
    techniqueTip: 'The lower the bar, the harder the exercise.',
    animationPath: 'assets/animations/pull_s1_australian.json',
  );

  static const Exercise pullS2Negative = Exercise(
    id: 'pull_s2_negative',
    name: 'Negative Pull-up',
    description:
        'Jump up to the bar with your chin above it. Slowly lower yourself over '
        '3–5 seconds until your arms are fully extended.',
    branch: BranchId.pull,
    stage: 2,
    type: ExerciseType.reps,
    startReps: 3,
    targetReps: 8,
    startSets: 1,
    targetSets: 3,
    startRestSec: 90,
    targetRestSec: 45,
    spBase: 2,
    challengeTargetReps: 1,
    requiresEquipment: true,
    techniqueTip: 'The slower you lower, the better. Aim for 5 seconds down.',
    animationPath: 'assets/animations/pull_s2_negative.json',
  );

  static const Exercise pullS3Pullup = Exercise(
    id: 'pull_s3_pullup',
    name: 'Pull-up',
    description:
        'Shoulder-width or slightly wider grip. Pull your chest to the bar until your chin clears it. '
        'Fully extend your arms at the bottom.',
    branch: BranchId.pull,
    stage: 3,
    type: ExerciseType.reps,
    startReps: 1,
    targetReps: 10,
    startSets: 1,
    targetSets: 3,
    startRestSec: 90,
    targetRestSec: 45,
    spBase: 3,
    challengeTargetReps: 3,
    requiresEquipment: true,
    techniqueTip: 'Retract your shoulder blades — you\'re pulling with your back, not just your arms.',
    animationPath: 'assets/animations/pull_s3_pullup.json',
  );

  static const Exercise pullS4CloseGrip = Exercise(
    id: 'pull_s4_close_grip',
    name: 'Close-Grip Pull-up',
    description:
        'Grip narrower than shoulder-width, palms facing toward or away from you. '
        'Emphasises biceps and lower lats. Pull your chest to the bar.',
    branch: BranchId.pull,
    stage: 4,
    type: ExerciseType.reps,
    startReps: 3,
    targetReps: 10,
    startSets: 1,
    targetSets: 3,
    startRestSec: 90,
    targetRestSec: 45,
    spBase: 3,
    challengeTargetReps: 2,
    requiresEquipment: true,
    techniqueTip: 'Tuck your elbows in close to your body for maximum biceps activation.',
    animationPath: 'assets/animations/pull_s4_close_grip.json',
  );

  static const Exercise pullS5Archer = Exercise(
    id: 'pull_s5_archer',
    name: 'Archer Pull-up',
    description:
        'Wide grip. Pull your body toward one arm while keeping the other arm straight. '
        'Alternate sides each rep.',
    branch: BranchId.pull,
    stage: 5,
    type: ExerciseType.reps,
    startReps: 2,
    targetReps: 6,
    startSets: 1,
    targetSets: 3,
    startRestSec: 90,
    targetRestSec: 60,
    spBase: 4,
    challengeTargetReps: 1,
    requiresEquipment: true,
    techniqueTip: 'Straight arm is the assist; working arm gets full range of motion.',
    animationPath: 'assets/animations/pull_s5_archer.json',
  );

  static const Exercise pullS6OneArm = Exercise(
    id: 'pull_s6_one_arm',
    name: 'One-Arm Pull-up',
    description:
        'One hand on the bar, other hand on the wrist or free. '
        'Full range of motion with the working arm.',
    branch: BranchId.pull,
    stage: 6,
    type: ExerciseType.reps,
    startReps: 1,
    targetReps: 3,
    startSets: 1,
    targetSets: 3,
    startRestSec: 120,
    targetRestSec: 90,
    spBase: 5,
    challengeTargetReps: 1,
    requiresEquipment: true,
    techniqueTip: 'Keep your core tight — don\'t swing.',
    animationPath: 'assets/animations/pull_s6_one_arm.json',
  );

  // ── LEGS ──────────────────────────────────────────────────────────────────

  static const Exercise legsS1Squat = Exercise(
    id: 'legs_s1_squat',
    name: 'Squat',
    description:
        'Feet shoulder-width apart, toes slightly turned out. Squat to parallel, '
        'knees tracking over toes. Fully extend your legs at the top.',
    branch: BranchId.legs,
    stage: 1,
    type: ExerciseType.reps,
    startReps: 8,
    targetReps: 20,
    startSets: 1,
    targetSets: 3,
    startRestSec: 45,
    targetRestSec: 20,
    spBase: 1,
    challengeTargetReps: 5,
    techniqueTip: 'Heels stay flat on the floor. Keep your chest upright.',
    animationPath: 'assets/animations/legs_s1_squat.json',
  );

  static const Exercise legsS2Lunge = Exercise(
    id: 'legs_s2_lunge',
    name: 'Lunge',
    description:
        'Step forward and lower the back knee toward the floor without touching. '
        'Both knees at 90°. Push off the front foot to return to start.',
    branch: BranchId.legs,
    stage: 2,
    type: ExerciseType.reps,
    startReps: 6,
    targetReps: 12,
    startSets: 1,
    targetSets: 3,
    startRestSec: 45,
    targetRestSec: 20,
    spBase: 1,
    challengeTargetReps: 3,
    techniqueTip: 'Keep your front knee tracking over your toes — don\'t let it cave in.',
    animationPath: 'assets/animations/legs_s2_lunge.json',
  );

  static const Exercise legsS3Bulgarian = Exercise(
    id: 'legs_s3_bulgarian',
    name: 'Bulgarian Split Squat',
    description:
        'Rear foot elevated on a bench or chair. Lower your front leg to parallel. '
        'Keep your torso upright.',
    branch: BranchId.legs,
    stage: 3,
    type: ExerciseType.reps,
    startReps: 5,
    targetReps: 10,
    startSets: 1,
    targetSets: 3,
    startRestSec: 60,
    targetRestSec: 30,
    spBase: 2,
    challengeTargetReps: 3,
    techniqueTip: 'The farther your front foot, the more glute activation.',
    animationPath: 'assets/animations/legs_s3_bulgarian.json',
  );

  static const Exercise legsS4AssistedPistol = Exercise(
    id: 'legs_s4_assisted_pistol',
    name: 'Assisted Pistol Squat',
    description:
        'Hold a door frame or post for balance. Squat on one leg while keeping '
        'the other leg straight in front. The support reduces the load.',
    branch: BranchId.legs,
    stage: 4,
    type: ExerciseType.reps,
    startReps: 3,
    targetReps: 8,
    startSets: 1,
    targetSets: 3,
    startRestSec: 60,
    targetRestSec: 30,
    spBase: 3,
    challengeTargetReps: 1,
    techniqueTip: 'Gradually reduce how much you pull on the support as you get stronger.',
    animationPath: 'assets/animations/legs_s4_pistol.json',
  );

  static const Exercise legsS5Pistol = Exercise(
    id: 'legs_s5_pistol',
    name: 'Pistol Squat',
    description:
        'Single-leg squat without support. Other leg straight in front. '
        'Full range of motion, all the way down and back up.',
    branch: BranchId.legs,
    stage: 5,
    type: ExerciseType.reps,
    startReps: 1,
    targetReps: 5,
    startSets: 1,
    targetSets: 3,
    startRestSec: 90,
    targetRestSec: 45,
    spBase: 5,
    challengeTargetReps: 1,
    techniqueTip: 'Extend arms forward as a counterbalance — it helps with stability.',
    animationPath: 'assets/animations/legs_s5_pistol_free.json',
  );

  // ── BALANCE ───────────────────────────────────────────────────────────────

  static const Exercise balS1OneLegStand = Exercise(
    id: 'bal_s1_one_leg_stand',
    name: 'Single-Leg Stand',
    description:
        'Stand on one leg, slightly bend the lifted leg and hold it in the air. '
        'Arms can be extended for balance.',
    branch: BranchId.balance,
    stage: 1,
    type: ExerciseType.timed,
    perSide: true,
    startReps: 10, // seconds
    targetReps: 30,
    startSets: 1,
    targetSets: 3,
    startRestSec: 60,
    targetRestSec: 15,
    spBase: 1,
    challengeTargetReps: 10,
    techniqueTip: 'Fix your gaze on a point — it dramatically improves balance.',
    animationPath: 'assets/animations/bal_s1_one_leg_stand.json',
  );

  static const Exercise balS2OneArmPlank = Exercise(
    id: 'bal_s2_one_arm_plank',
    name: 'One-Arm Plank',
    description:
        'High plank position on extended arms. Lift one hand off the floor '
        'and hold, body parallel to the floor.',
    branch: BranchId.balance,
    stage: 2,
    type: ExerciseType.timed,
    perSide: true,
    startReps: 10,
    targetReps: 30,
    startSets: 1,
    targetSets: 3,
    startRestSec: 45,
    targetRestSec: 20,
    spBase: 2,
    challengeTargetReps: 5,
    techniqueTip: 'Keep hips parallel to the floor — don\'t rotate your torso.',
    animationPath: 'assets/animations/bal_s2_one_arm_plank.json',
  );

  static const Exercise balS3CrowPrep = Exercise(
    id: 'bal_s3_crow_prep',
    name: 'Crow Pose Preparation',
    description:
        'Squat down and place knees on your triceps. Shift weight onto your hands, '
        'slightly lifting your feet. Hold the balance.',
    branch: BranchId.balance,
    stage: 3,
    type: ExerciseType.timed,
    startReps: 5,
    targetReps: 20,
    startSets: 1,
    targetSets: 3,
    startRestSec: 45,
    targetRestSec: 20,
    spBase: 3,
    challengeTargetReps: 3,
    techniqueTip: 'Look forward-down, not straight down — otherwise you\'ll tip over.',
    animationPath: 'assets/animations/bal_s3_crow_prep.json',
  );

  static const Exercise balS4CrowPose = Exercise(
    id: 'bal_s4_crow_pose',
    name: 'Crow Pose (Kakasana)',
    description:
        'Both knees on triceps, full balance on hands. Arms slightly bent, '
        'fingers spread wide.',
    branch: BranchId.balance,
    stage: 4,
    type: ExerciseType.timed,
    startReps: 3,
    targetReps: 15,
    startSets: 1,
    targetSets: 3,
    startRestSec: 60,
    targetRestSec: 30,
    spBase: 4,
    challengeTargetReps: 10,
    techniqueTip: 'Round your back — it engages your core and gives you balance.',
    animationPath: 'assets/animations/bal_s4_crow_pose.json',
  );

  static const Exercise balS5WallHs = Exercise(
    id: 'bal_s5_wall_hs',
    name: 'Wall Handstand',
    description:
        'Kick up into a handstand with your back to the wall. Heels touch the wall for support. '
        'Hold, body extended in a straight line.',
    branch: BranchId.balance,
    stage: 5,
    type: ExerciseType.timed,
    startReps: 10,
    targetReps: 30,
    startSets: 1,
    targetSets: 3,
    startRestSec: 60,
    targetRestSec: 30,
    spBase: 4,
    challengeTargetReps: 5,
    techniqueTip: 'Spread fingers wide and press into your fingertips — that\'s your balance.',
    animationPath: 'assets/animations/bal_s5_wall_hs.json',
  );

  static const Exercise balS6FreeHs = Exercise(
    id: 'bal_s6_free_hs',
    name: 'Free Handstand',
    description:
        'Handstand without wall support. Control your balance with small '
        'finger and wrist adjustments.',
    branch: BranchId.balance,
    stage: 6,
    type: ExerciseType.timed,
    startReps: 5,
    targetReps: 30,
    startSets: 1,
    targetSets: 3,
    startRestSec: 90,
    targetRestSec: 60,
    spBase: 5,
    challengeTargetReps: 5,
    techniqueTip: 'Look at the floor 30–40 cm in front of your hands, not between them.',
    animationPath: 'assets/animations/bal_s6_free_hs.json',
  );

  // ── FLEX ──────────────────────────────────────────────────────────────────

  static const Exercise flexS1HipFlexorStretch = Exercise(
    id: 'flex_s1_hip_flexor_stretch',
    name: 'Hip Flexor Stretch',
    description:
        'Step into a lunge and lower your back knee to the floor. '
        'Push your hips forward to feel the stretch at the front of your hip. Hold each side.',
    branch: BranchId.flex,
    stage: 1,
    type: ExerciseType.timed,
    perSide: true,
    startReps: 10,
    targetReps: 30,
    startSets: 1,
    targetSets: 3,
    startRestSec: 30,
    targetRestSec: 15,
    spBase: 1,
    challengeTargetReps: 20,
    techniqueTip: 'Keep your back straight and push hips forward — feel the stretch in the front of your hip.',
    animationPath: 'assets/animations/flex_s1_hip_flexor_stretch.json',
  );

  static const Exercise flexS2WorldsGreatestStretch = Exercise(
    id: 'flex_s2_worlds_greatest_stretch',
    name: "World's Greatest Stretch",
    description:
        'From a lunge, place the same-side hand on the floor. '
        'Rotate your upper body and reach the other arm toward the ceiling. Flow through the movement.',
    branch: BranchId.flex,
    stage: 2,
    type: ExerciseType.reps,
    startReps: 3,
    targetReps: 8,
    startSets: 1,
    targetSets: 3,
    startRestSec: 30,
    targetRestSec: 15,
    spBase: 1,
    challengeTargetReps: 3,
    techniqueTip: 'Move slowly through each position — this is a flow, not a race.',
    animationPath: 'assets/animations/flex_s2_worlds_greatest_stretch.json',
  );

  static const Exercise flexS3Hip9090 = Exercise(
    id: 'flex_s3_hip_9090',
    name: '90/90 Hip Mobility',
    description:
        'Sit on the floor with both legs bent at 90°, one in front and one to the side. '
        'Hold the position and switch sides.',
    branch: BranchId.flex,
    stage: 3,
    type: ExerciseType.timed,
    perSide: true,
    startReps: 10,
    targetReps: 30,
    startSets: 1,
    targetSets: 3,
    startRestSec: 30,
    targetRestSec: 15,
    spBase: 1,
    challengeTargetReps: 20,
    techniqueTip: 'Keep both sit bones on the floor. Rotate from the hip, not the lower back.',
  );

  static const Exercise flexS4ThoracicBridge = Exercise(
    id: 'flex_s4_thoracic_bridge',
    name: 'Thoracic Bridge',
    description:
        'From a seated position with hands behind you, lift your hips and rotate '
        'your upper spine to open the chest toward the ceiling.',
    branch: BranchId.flex,
    stage: 4,
    type: ExerciseType.reps,
    startReps: 3,
    targetReps: 8,
    startSets: 1,
    targetSets: 3,
    startRestSec: 45,
    targetRestSec: 20,
    spBase: 2,
    challengeTargetReps: 3,
    techniqueTip: 'Focus movement in the upper back — avoid hinging in the lower back.',
    animationPath: 'assets/animations/flex_s4_thoracic_bridge.json',
  );

  static const Exercise flexS5DeepSquatHold = Exercise(
    id: 'flex_s5_deep_squat_hold',
    name: 'Deep Squat Hold',
    description:
        'Feet shoulder-width apart, toes slightly out. Squat all the way down and hold. '
        'Use a door frame for support as needed.',
    branch: BranchId.flex,
    stage: 5,
    type: ExerciseType.timed,
    startReps: 20,
    targetReps: 90,
    startSets: 1,
    targetSets: 3,
    startRestSec: 30,
    targetRestSec: 15,
    spBase: 1,
    challengeTargetReps: 30,
    techniqueTip: 'Use a doorframe or pole for support at first. Heels flat on the floor is the goal.',
    animationPath: 'assets/animations/flex_s5_deep_squat_hold.json',
  );

  static const Exercise flexS6PikeStretch = Exercise(
    id: 'flex_s6_pike_stretch',
    name: 'Pike Stretch',
    description:
        'Sit on the floor with legs straight in front of you. '
        'Reach your hands toward your feet, hinging at the hips. Hold the position.',
    branch: BranchId.flex,
    stage: 6,
    type: ExerciseType.timed,
    startReps: 20,
    targetReps: 60,
    startSets: 1,
    targetSets: 3,
    startRestSec: 30,
    targetRestSec: 15,
    spBase: 1,
    challengeTargetReps: 30,
    techniqueTip: 'Reach forward from your hips, not your waist. Keep legs straight.',
    animationPath: 'assets/animations/flex_s6_pike_stretch.json',
  );

  // ── EVENING STRETCH (animations: tools/lottie/gen_evening.py; cat-cow reused) ─

  static const Exercise eveningBackS1CatCow = Exercise(
    id: 'evening_back_s1_cat_cow',
    name: 'Cat-Cow',
    description:
        'On all fours, hands under your shoulders, knees under your hips. Breathing in, let your belly drop and lift your chest; breathing out, round your back toward the ceiling. Move slowly with your breath.',
    branch: BranchId.eveningBack,
    stage: 1,
    type: ExerciseType.reps,
    startReps: 5,
    targetReps: 12,
    startSets: 1,
    targetSets: 2,
    startRestSec: 15,
    targetRestSec: 10,
    spBase: 1,
    techniqueTip: 'Let the breath lead: one slow breath in and one out per rep.',
    animationPath: 'assets/animations/cooldown_cat_cow.json',
  );

  static const Exercise eveningBackS2ChildsPose = Exercise(
    id: 'evening_back_s2_childs_pose',
    name: "Child's Pose",
    description:
        'Kneel with your big toes together and knees apart. Sit back on your heels and lay your chest down between your knees, arms stretched forward, forehead on the floor. Breathe into your back.',
    branch: BranchId.eveningBack,
    stage: 2,
    type: ExerciseType.timed,
    startReps: 20,
    targetReps: 60,
    startSets: 1,
    targetSets: 2,
    startRestSec: 15,
    targetRestSec: 10,
    spBase: 1,
    challengeTargetReps: 30,
    techniqueTip: 'Let your hips sink toward your heels with every breath out.',
    animationPath: 'assets/animations/evening_back_s2_childs_pose.json',
  );

  static const Exercise eveningBackS3SupineTwist = Exercise(
    id: 'evening_back_s3_supine_twist',
    name: 'Supine Twist',
    description:
        'Lie on your back, arms out to the sides. Bend one knee and let it fall across your body to the floor, looking the other way. Keep both shoulders down.',
    branch: BranchId.eveningBack,
    stage: 3,
    type: ExerciseType.timed,
    perSide: true,
    startReps: 20,
    targetReps: 60,
    startSets: 1,
    targetSets: 2,
    startRestSec: 15,
    targetRestSec: 10,
    spBase: 1,
    challengeTargetReps: 30,
    techniqueTip: "Don't push the knee down: the weight of the leg does the work.",
    animationPath: 'assets/animations/evening_back_s3_supine_twist.json',
  );

  static const Exercise eveningBackS4Sphinx = Exercise(
    id: 'evening_back_s4_sphinx',
    name: 'Sphinx',
    description:
        'Lie on your stomach, elbows under your shoulders, forearms on the floor. Lift your chest; your hips and legs stay relaxed on the floor.',
    branch: BranchId.eveningBack,
    stage: 4,
    type: ExerciseType.timed,
    startReps: 20,
    targetReps: 60,
    startSets: 1,
    targetSets: 2,
    startRestSec: 15,
    targetRestSec: 10,
    spBase: 1,
    challengeTargetReps: 45,
    techniqueTip: 'Draw your shoulders away from your ears; the arch is gentle, never pinching.',
    animationPath: 'assets/animations/evening_back_s4_sphinx.json',
  );

  static const Exercise eveningBackS5Cobra = Exercise(
    id: 'evening_back_s5_cobra',
    name: 'Cobra',
    description:
        'Lie on your stomach, hands under your shoulders. Press up and straighten your arms as far as your lower back allows; your hips stay on the floor.',
    branch: BranchId.eveningBack,
    stage: 5,
    type: ExerciseType.timed,
    startReps: 30,
    targetReps: 90,
    startSets: 1,
    targetSets: 2,
    startRestSec: 15,
    targetRestSec: 10,
    spBase: 1,
    challengeTargetReps: 45,
    techniqueTip: 'Keep the elbows soft and the shoulders down; stop where your back feels good.',
    animationPath: 'assets/animations/evening_back_s5_cobra.json',
  );

  static const Exercise eveningHipsS1KneesToChest = Exercise(
    id: 'evening_hips_s1_knees_to_chest',
    name: 'Knees to Chest',
    description:
        'Lie on your back, hug both knees to your chest and hold. You may rock gently from side to side.',
    branch: BranchId.eveningHips,
    stage: 1,
    type: ExerciseType.timed,
    startReps: 20,
    targetReps: 60,
    startSets: 1,
    targetSets: 2,
    startRestSec: 15,
    targetRestSec: 10,
    spBase: 1,
    techniqueTip: 'Keep your lower back and your head on the floor.',
    animationPath: 'assets/animations/evening_hips_s1_knees_to_chest.json',
  );

  static const Exercise eveningHipsS2FigureFour = Exercise(
    id: 'evening_hips_s2_figure_four',
    name: 'Reclined Figure Four',
    description:
        'Lie on your back, knees bent. Cross one ankle over the other knee, then pull that thigh toward your chest until you feel the stretch in the buttock.',
    branch: BranchId.eveningHips,
    stage: 2,
    type: ExerciseType.timed,
    perSide: true,
    startReps: 20,
    targetReps: 60,
    startSets: 1,
    targetSets: 2,
    startRestSec: 15,
    targetRestSec: 10,
    spBase: 1,
    challengeTargetReps: 30,
    techniqueTip: 'Press the crossed knee gently away from you to go deeper.',
    animationPath: 'assets/animations/evening_hips_s2_figure_four.json',
  );

  static const Exercise eveningHipsS3HappyBaby = Exercise(
    id: 'evening_hips_s3_happy_baby',
    name: 'Happy Baby',
    description:
        'Lie on your back, bring your knees toward your armpits and hold the outer edges of your feet, soles to the ceiling. Gently pull your knees toward the floor.',
    branch: BranchId.eveningHips,
    stage: 3,
    type: ExerciseType.timed,
    startReps: 20,
    targetReps: 60,
    startSets: 1,
    targetSets: 2,
    startRestSec: 15,
    targetRestSec: 10,
    spBase: 1,
    challengeTargetReps: 30,
    techniqueTip: 'Keep your tailbone down; rocking a little is fine.',
    animationPath: 'assets/animations/evening_hips_s3_happy_baby.json',
  );

  static const Exercise eveningHipsS4Butterfly = Exercise(
    id: 'evening_hips_s4_butterfly',
    name: 'Butterfly',
    description:
        'Sit up tall with the soles of your feet together and your knees out to the sides. Hold your feet and let your knees sink toward the floor.',
    branch: BranchId.eveningHips,
    stage: 4,
    type: ExerciseType.timed,
    startReps: 20,
    targetReps: 60,
    startSets: 1,
    targetSets: 2,
    startRestSec: 15,
    targetRestSec: 10,
    spBase: 1,
    challengeTargetReps: 45,
    techniqueTip: 'Stay tall; to go deeper, lean forward from your hips.',
    animationPath: 'assets/animations/evening_hips_s4_butterfly.json',
  );

  static const Exercise eveningHipsS5Frog = Exercise(
    id: 'evening_hips_s5_frog',
    name: 'Frog',
    description:
        'On all fours, slide your knees wide apart, ankles in line with the knees, feet turned out. Lower onto your forearms and ease your hips back.',
    branch: BranchId.eveningHips,
    stage: 5,
    type: ExerciseType.timed,
    startReps: 30,
    targetReps: 90,
    startSets: 1,
    targetSets: 2,
    startRestSec: 15,
    targetRestSec: 10,
    spBase: 1,
    challengeTargetReps: 45,
    techniqueTip: 'Open only as far as it feels like a stretch, never a pain in the knees.',
    animationPath: 'assets/animations/evening_hips_s5_frog.json',
  );

  static const Exercise eveningFoldsS1LegsUpWall = Exercise(
    id: 'evening_folds_s1_legs_up_wall',
    name: 'Legs Up the Wall',
    description:
        'Lie on your back with your hips close to a wall and your legs straight up along it. Arms relaxed at your sides; breathe slowly.',
    branch: BranchId.eveningFolds,
    stage: 1,
    type: ExerciseType.timed,
    startReps: 30,
    targetReps: 90,
    startSets: 1,
    targetSets: 2,
    startRestSec: 15,
    targetRestSec: 10,
    spBase: 1,
    techniqueTip: 'Bend your knees a little if the backs of your legs pull too much.',
    animationPath: 'assets/animations/evening_folds_s1_legs_up_wall.json',
  );

  static const Exercise eveningFoldsS2TowelHamstring = Exercise(
    id: 'evening_folds_s2_towel_hamstring',
    name: 'Lying Hamstring Stretch',
    description:
        'Lie on your back, loop a towel around one foot and raise that leg as straight as you can. The other leg stays on the floor.',
    branch: BranchId.eveningFolds,
    stage: 2,
    type: ExerciseType.timed,
    perSide: true,
    startReps: 20,
    targetReps: 60,
    startSets: 1,
    targetSets: 2,
    startRestSec: 15,
    targetRestSec: 10,
    spBase: 1,
    challengeTargetReps: 30,
    techniqueTip: 'Pull with the towel, not with your back: your hips stay on the floor.',
    animationPath: 'assets/animations/evening_folds_s2_towel_hamstring.json',
  );

  static const Exercise eveningFoldsS3HeadToKnee = Exercise(
    id: 'evening_folds_s3_head_to_knee',
    name: 'Head-to-Knee Fold',
    description:
        'Sit with one leg straight and the other foot against the inside of that thigh. Fold forward over the straight leg, reaching toward the foot.',
    branch: BranchId.eveningFolds,
    stage: 3,
    type: ExerciseType.timed,
    perSide: true,
    startReps: 20,
    targetReps: 60,
    startSets: 1,
    targetSets: 2,
    startRestSec: 15,
    targetRestSec: 10,
    spBase: 1,
    challengeTargetReps: 45,
    techniqueTip: 'Lead with your chest, not your head; the straight knee may bend a little.',
    animationPath: 'assets/animations/evening_folds_s3_head_to_knee.json',
  );

  static const Exercise eveningFoldsS4StraddleFold = Exercise(
    id: 'evening_folds_s4_straddle_fold',
    name: 'Straddle Fold',
    description:
        'Sit with your legs wide apart, knees pointing up. Walk your hands forward and lower your body toward the floor between your legs.',
    branch: BranchId.eveningFolds,
    stage: 4,
    type: ExerciseType.timed,
    startReps: 30,
    targetReps: 90,
    startSets: 1,
    targetSets: 2,
    startRestSec: 15,
    targetRestSec: 10,
    spBase: 1,
    challengeTargetReps: 45,
    techniqueTip: 'Tilt from your hips with a long back; rounding the back adds nothing.',
    animationPath: 'assets/animations/evening_folds_s4_straddle_fold.json',
  );

  static const Exercise eveningShouldersS1SelfHug = Exercise(
    id: 'evening_shoulders_s1_self_hug',
    name: 'Self-Hug',
    description:
        'Sitting or standing, wrap your arms around yourself and hold your shoulder blades. Let your upper back round and breathe into it.',
    branch: BranchId.eveningShoulders,
    stage: 1,
    type: ExerciseType.timed,
    startReps: 20,
    targetReps: 60,
    startSets: 1,
    targetSets: 2,
    startRestSec: 15,
    targetRestSec: 10,
    spBase: 1,
    techniqueTip: 'Relax your neck and let your chin drop a little.',
    animationPath: 'assets/animations/evening_shoulders_s1_self_hug.json',
  );

  static const Exercise eveningShouldersS2TricepsStretch = Exercise(
    id: 'evening_shoulders_s2_triceps_stretch',
    name: 'Overhead Triceps Stretch',
    description:
        'Raise one arm, bend the elbow and let your hand drop behind your neck. Use the other hand to ease the elbow back.',
    branch: BranchId.eveningShoulders,
    stage: 2,
    type: ExerciseType.timed,
    perSide: true,
    startReps: 20,
    targetReps: 60,
    startSets: 1,
    targetSets: 2,
    startRestSec: 15,
    targetRestSec: 10,
    spBase: 1,
    challengeTargetReps: 30,
    techniqueTip: 'Keep your head up and your ribs down.',
    animationPath: 'assets/animations/evening_shoulders_s2_triceps_stretch.json',
  );

  static const Exercise eveningShouldersS3EagleArms = Exercise(
    id: 'evening_shoulders_s3_eagle_arms',
    name: 'Eagle Arms',
    description:
        'Cross one arm under the other at the elbows, bend them and bring your palms together. Lift your elbows to shoulder height.',
    branch: BranchId.eveningShoulders,
    stage: 3,
    type: ExerciseType.timed,
    perSide: true,
    startReps: 20,
    targetReps: 60,
    startSets: 1,
    targetSets: 2,
    startRestSec: 15,
    targetRestSec: 10,
    spBase: 1,
    challengeTargetReps: 30,
    techniqueTip: "If your palms don't meet, press the backs of your hands together.",
    animationPath: 'assets/animations/evening_shoulders_s3_eagle_arms.json',
  );

  static const Exercise eveningShouldersS4PuppyPose = Exercise(
    id: 'evening_shoulders_s4_puppy_pose',
    name: 'Puppy Pose',
    description:
        'On all fours, walk your hands forward and lower your chest toward the floor, hips above your knees, arms straight.',
    branch: BranchId.eveningShoulders,
    stage: 4,
    type: ExerciseType.timed,
    startReps: 30,
    targetReps: 90,
    startSets: 1,
    targetSets: 2,
    startRestSec: 15,
    targetRestSec: 10,
    spBase: 1,
    challengeTargetReps: 45,
    techniqueTip: 'Rest your forehead on the floor and let your chest melt down.',
    animationPath: 'assets/animations/evening_shoulders_s4_puppy_pose.json',
  );

  static const Exercise eveningShouldersS5CowFaceArms = Exercise(
    id: 'evening_shoulders_s5_cow_face_arms',
    name: 'Cow Face Arms',
    description:
        "Reach one hand down behind your neck and the other up behind your back, and try to hook your fingers. If they don't meet, hold a towel between your hands.",
    branch: BranchId.eveningShoulders,
    stage: 5,
    type: ExerciseType.timed,
    perSide: true,
    startReps: 20,
    targetReps: 60,
    startSets: 1,
    targetSets: 2,
    startRestSec: 15,
    targetRestSec: 10,
    spBase: 1,
    challengeTargetReps: 45,
    techniqueTip: 'Keep the upper elbow pointing up and your back straight.',
    animationPath: 'assets/animations/evening_shoulders_s5_cow_face_arms.json',
  );

  /// Lying relaxation: the one cool-down of every Evening Stretch branch.
  static const Exercise cooldownLyingRelaxation = Exercise(
    id: 'cooldown_lying_relaxation',
    name: 'Lying Relaxation',
    description:
        'Lie on your back, arms by your sides, palms up. Close your eyes and breathe slowly; let your whole body go heavy.',
    branch: BranchId.eveningBack,
    stage: 0,
    type: ExerciseType.timed,
    startReps: 60,
    targetReps: 60,
    startSets: 1,
    targetSets: 1,
    startRestSec: 0,
    targetRestSec: 0,
    spBase: 0,
    techniqueTip: 'Breathe out longer than you breathe in.',
    animationPath: 'assets/animations/cooldown_lying_relaxation.json',
  );

  // ── MORNING ROUTINE (animations: tools/lottie/gen_morning.py) ──────────────

  static const Exercise morningSpineS1SideBend = Exercise(
    id: 'morning_spine_s1_side_bend',
    name: 'Standing Side Bend',
    description:
        'Stand with your feet hip-width apart. Raise one arm over your head and lean to the other side, sliding the other hand down your thigh. Come back up and switch sides. Each side counts as one rep.',
    branch: BranchId.morningSpine,
    stage: 1,
    type: ExerciseType.reps,
    startReps: 6,
    targetReps: 16,
    startSets: 1,
    targetSets: 2,
    startRestSec: 15,
    targetRestSec: 10,
    spBase: 1,
    techniqueTip: 'Lean straight to the side, not forward; your hips stay still.',
    animationPath: 'assets/animations/morning_spine_s1_side_bend.json',
  );

  static const Exercise morningSpineS2TorsoTwist = Exercise(
    id: 'morning_spine_s2_torso_twist',
    name: 'Torso Twist',
    description:
        'Stand with your feet a little wider than your hips, knees soft, arms loose. Turn your upper body from side to side and let your arms swing around you. Your hips keep facing forward. Each side counts as one rep.',
    branch: BranchId.morningSpine,
    stage: 2,
    type: ExerciseType.reps,
    startReps: 10,
    targetReps: 24,
    startSets: 1,
    targetSets: 2,
    startRestSec: 15,
    targetRestSec: 10,
    spBase: 1,
    challengeTargetReps: 12,
    techniqueTip: "Let the arms follow the turn; don't throw them.",
    animationPath: 'assets/animations/morning_spine_s2_torso_twist.json',
  );

  static const Exercise morningSpineS3GoodMorning = Exercise(
    id: 'morning_spine_s3_good_morning',
    name: 'Good Morning',
    description:
        'Stand with your feet hip-width apart, hands behind your head. Push your hips back and lean forward with a flat back until you feel the back of your thighs, then stand tall again.',
    branch: BranchId.morningSpine,
    stage: 3,
    type: ExerciseType.reps,
    startReps: 8,
    targetReps: 20,
    startSets: 1,
    targetSets: 2,
    startRestSec: 15,
    targetRestSec: 10,
    spBase: 1,
    challengeTargetReps: 8,
    techniqueTip: 'Bend at the hips, not at the waist: your back stays straight the whole way.',
    animationPath: 'assets/animations/morning_spine_s3_good_morning.json',
  );

  static const Exercise morningSpineS4RollDown = Exercise(
    id: 'morning_spine_s4_roll_down',
    name: 'Roll-Down',
    description:
        'Stand tall. Drop your chin to your chest and roll down slowly, one vertebra at a time, letting your arms hang toward the floor. Roll back up the same way, your head coming up last.',
    branch: BranchId.morningSpine,
    stage: 4,
    type: ExerciseType.reps,
    startReps: 3,
    targetReps: 8,
    startSets: 1,
    targetSets: 2,
    startRestSec: 15,
    targetRestSec: 10,
    spBase: 1,
    challengeTargetReps: 4,
    techniqueTip: 'Bend your knees as much as you need; the point is the spine, not touching the floor.',
    animationPath: 'assets/animations/morning_spine_s4_roll_down.json',
  );

  static const Exercise morningSpineS5Windmill = Exercise(
    id: 'morning_spine_s5_windmill',
    name: 'Windmill',
    description:
        'Stand with your feet wide, arms out to the sides. Bend forward and turn, reaching one hand to the opposite foot while the other arm points at the ceiling. Come back up to the T and switch sides. Each side counts as one rep.',
    branch: BranchId.morningSpine,
    stage: 5,
    type: ExerciseType.reps,
    startReps: 6,
    targetReps: 16,
    startSets: 1,
    targetSets: 2,
    startRestSec: 15,
    targetRestSec: 10,
    spBase: 1,
    challengeTargetReps: 8,
    techniqueTip: 'Keep both arms in one straight line, like the sails of a windmill.',
    animationPath: 'assets/animations/morning_spine_s5_windmill.json',
  );

  static const Exercise morningJointsS1KneeCircles = Exercise(
    id: 'morning_joints_s1_knee_circles',
    name: 'Knee Circles',
    description:
        'Stand with your feet together, bend your knees slightly and rest your hands just above them. Draw slow circles with your knees: half of them one way, half the other.',
    branch: BranchId.morningJoints,
    stage: 1,
    type: ExerciseType.reps,
    startReps: 8,
    targetReps: 20,
    startSets: 1,
    targetSets: 2,
    startRestSec: 15,
    targetRestSec: 10,
    spBase: 1,
    techniqueTip: 'Small, smooth circles; your heels stay on the floor.',
    animationPath: 'assets/animations/morning_joints_s1_knee_circles.json',
  );

  static const Exercise morningJointsS2OpenTheGate = Exercise(
    id: 'morning_joints_s2_open_the_gate',
    name: 'Open the Gate',
    description:
        'Stand tall. Lift one knee in front of you to hip height, open it out to the side and lower the foot back down. Switch legs. Each side counts as one rep.',
    branch: BranchId.morningJoints,
    stage: 2,
    type: ExerciseType.reps,
    startReps: 6,
    targetReps: 16,
    startSets: 1,
    targetSets: 2,
    startRestSec: 15,
    targetRestSec: 10,
    spBase: 1,
    challengeTargetReps: 8,
    techniqueTip: 'Hold on to a wall or a chair if you wobble; keep your chest up.',
    animationPath: 'assets/animations/morning_joints_s2_open_the_gate.json',
  );

  static const Exercise morningJointsS3KneeHug = Exercise(
    id: 'morning_joints_s3_knee_hug',
    name: 'Standing Knee Hug',
    description:
        'Stand tall. Pull one knee to your chest with both hands and rise onto the toes of the standing foot. Lower it and switch legs. Each side counts as one rep.',
    branch: BranchId.morningJoints,
    stage: 3,
    type: ExerciseType.reps,
    startReps: 6,
    targetReps: 16,
    startSets: 1,
    targetSets: 2,
    startRestSec: 15,
    targetRestSec: 10,
    spBase: 1,
    challengeTargetReps: 8,
    techniqueTip: 'Rise slowly and look at a point in front of you to keep your balance.',
    animationPath: 'assets/animations/morning_joints_s3_knee_hug.json',
  );

  static const Exercise morningJointsS4SideLunge = Exercise(
    id: 'morning_joints_s4_side_lunge',
    name: 'Side Lunge',
    description:
        'Stand with your feet together. Step wide to one side and sit back into that hip, the other leg straight, both feet flat on the floor. Push back to the start and switch sides. Each side counts as one rep.',
    branch: BranchId.morningJoints,
    stage: 4,
    type: ExerciseType.reps,
    startReps: 6,
    targetReps: 16,
    startSets: 1,
    targetSets: 2,
    startRestSec: 15,
    targetRestSec: 10,
    spBase: 1,
    challengeTargetReps: 8,
    techniqueTip: 'Your bent knee points the same way as your toes.',
    animationPath: 'assets/animations/morning_joints_s4_side_lunge.json',
  );

  static const Exercise morningJointsS5CossackSquat = Exercise(
    id: 'morning_joints_s5_cossack_squat',
    name: 'Cossack Squat',
    description:
        'Stand with your feet very wide. Sink deep onto one leg while the other stays straight, toes pointing up. Move through the middle to the other side. Each side counts as one rep.',
    branch: BranchId.morningJoints,
    stage: 5,
    type: ExerciseType.reps,
    startReps: 4,
    targetReps: 12,
    startSets: 1,
    targetSets: 2,
    startRestSec: 15,
    targetRestSec: 10,
    spBase: 1,
    challengeTargetReps: 6,
    techniqueTip: 'Keep the heel of the bent leg down; reach your arms forward for balance.',
    animationPath: 'assets/animations/morning_joints_s5_cossack_squat.json',
  );

  static const Exercise morningArmsS1ArmSwings = Exercise(
    id: 'morning_arms_s1_arm_swings',
    name: 'Arm Swings',
    description:
        'Stand tall. Open your arms wide to the sides, then swing them in and hug yourself, changing which arm is on top each time. Keep it loose and easy.',
    branch: BranchId.morningArms,
    stage: 1,
    type: ExerciseType.reps,
    startReps: 10,
    targetReps: 24,
    startSets: 1,
    targetSets: 2,
    startRestSec: 15,
    targetRestSec: 10,
    spBase: 1,
    techniqueTip: 'Open your chest at the wide point and breathe in.',
    animationPath: 'assets/animations/morning_arms_s1_arm_swings.json',
  );

  static const Exercise morningArmsS2YRaises = Exercise(
    id: 'morning_arms_s2_y_raises',
    name: 'Y Raises',
    description:
        'Knees soft, lean forward from the hips with a flat back. Thumbs up, raise your straight arms forward and up into a Y, squeezing your shoulder blades, then lower them.',
    branch: BranchId.morningArms,
    stage: 2,
    type: ExerciseType.reps,
    startReps: 8,
    targetReps: 20,
    startSets: 1,
    targetSets: 2,
    startRestSec: 15,
    targetRestSec: 10,
    spBase: 1,
    challengeTargetReps: 10,
    techniqueTip: 'Lift with the shoulder blades, not by arching your lower back.',
    animationPath: 'assets/animations/morning_arms_s2_y_raises.json',
  );

  static const Exercise morningArmsS3CactusArms = Exercise(
    id: 'morning_arms_s3_cactus_arms',
    name: 'Cactus Arms',
    description:
        'Raise your arms to the sides, elbows at shoulder height and bent at 90°, forearms pointing up like a cactus. Keeping the elbows in place, turn your forearms forward and down until they point at the floor, then back up, squeezing your shoulder blades.',
    branch: BranchId.morningArms,
    stage: 3,
    type: ExerciseType.reps,
    startReps: 8,
    targetReps: 20,
    startSets: 1,
    targetSets: 2,
    startRestSec: 15,
    targetRestSec: 10,
    spBase: 1,
    challengeTargetReps: 10,
    techniqueTip: 'Move slowly: only the forearms travel, the elbows stay at shoulder height.',
    animationPath: 'assets/animations/morning_arms_s3_cactus_arms.json',
  );

  static const Exercise morningArmsS4Inchworm = Exercise(
    id: 'morning_arms_s4_inchworm',
    name: 'Inchworm',
    description:
        'Stand tall, bend forward and put your hands on the floor (bend your knees if you need to). Walk your hands out to a plank, then walk them back to your feet and roll up to standing.',
    branch: BranchId.morningArms,
    stage: 4,
    type: ExerciseType.reps,
    startReps: 3,
    targetReps: 8,
    startSets: 1,
    targetSets: 2,
    startRestSec: 15,
    targetRestSec: 10,
    spBase: 1,
    challengeTargetReps: 4,
    techniqueTip: 'In the plank, keep your body in one straight line.',
    animationPath: 'assets/animations/morning_arms_s4_inchworm.json',
  );

  static const Exercise morningArmsS5PlankToDog = Exercise(
    id: 'morning_arms_s5_plank_to_dog',
    name: 'Plank to Downward Dog',
    description:
        'Start in a high plank, hands under your shoulders. Push your hips up and back into an upside-down V, heels toward the floor, then lower back to the plank.',
    branch: BranchId.morningArms,
    stage: 5,
    type: ExerciseType.reps,
    startReps: 4,
    targetReps: 10,
    startSets: 1,
    targetSets: 2,
    startRestSec: 15,
    targetRestSec: 10,
    spBase: 1,
    challengeTargetReps: 5,
    techniqueTip: 'Push the floor away with your hands and let your head hang between your arms.',
    animationPath: 'assets/animations/morning_arms_s5_plank_to_dog.json',
  );

  static const Exercise morningEnergyS1StepJacks = Exercise(
    id: 'morning_energy_s1_step_jacks',
    name: 'Step Jacks',
    description:
        'Jumping jacks without the jump: step one foot out to the side as both arms go up over your head, bring it back as the arms come down, then the other foot. Keep a steady rhythm.',
    branch: BranchId.morningEnergy,
    stage: 1,
    type: ExerciseType.timed,
    startReps: 20,
    targetReps: 60,
    startSets: 1,
    targetSets: 2,
    startRestSec: 15,
    targetRestSec: 10,
    spBase: 1,
    techniqueTip: 'Stay light on your feet and never jump, so nobody wakes up.',
    animationPath: 'assets/animations/morning_energy_s1_step_jacks.json',
  );

  static const Exercise morningEnergyS2ButtKicks = Exercise(
    id: 'morning_energy_s2_butt_kicks',
    name: 'Butt Kicks',
    description:
        'On the spot, kick one heel up toward your glutes, then the other, at a brisk pace. Arms bent, swinging with your legs. One foot always stays on the floor.',
    branch: BranchId.morningEnergy,
    stage: 2,
    type: ExerciseType.timed,
    startReps: 20,
    targetReps: 45,
    startSets: 1,
    targetSets: 2,
    startRestSec: 15,
    targetRestSec: 10,
    spBase: 1,
    challengeTargetReps: 30,
    techniqueTip: 'Quiet steps on the balls of your feet: brisk, but no jumping.',
    animationPath: 'assets/animations/morning_energy_s2_butt_kicks.json',
  );

  static const Exercise morningEnergyS3CrossCrunch = Exercise(
    id: 'morning_energy_s3_cross_crunch',
    name: 'Standing Cross Crunch',
    description:
        'Stand with your hands behind your head. Lift one knee and bring the opposite elbow down to meet it, then switch sides, at a steady pace.',
    branch: BranchId.morningEnergy,
    stage: 3,
    type: ExerciseType.timed,
    startReps: 20,
    targetReps: 45,
    startSets: 1,
    targetSets: 2,
    startRestSec: 15,
    targetRestSec: 10,
    spBase: 1,
    challengeTargetReps: 30,
    techniqueTip: 'Turn from the waist and open your chest between reps.',
    animationPath: 'assets/animations/morning_energy_s3_cross_crunch.json',
  );

  static const Exercise morningEnergyS4SpeedSkater = Exercise(
    id: 'morning_energy_s4_speed_skater',
    name: 'Speed Skater',
    description:
        'Like a skater, but without the hop: step wide to one side onto a bent leg and sweep the other foot behind it, swinging the opposite arm across your body. Then step to the other side.',
    branch: BranchId.morningEnergy,
    stage: 4,
    type: ExerciseType.timed,
    startReps: 20,
    targetReps: 45,
    startSets: 1,
    targetSets: 2,
    startRestSec: 15,
    targetRestSec: 10,
    spBase: 1,
    challengeTargetReps: 30,
    techniqueTip: 'Sink into the standing leg and keep your chest over it.',
    animationPath: 'assets/animations/morning_energy_s4_speed_skater.json',
  );

  static const Exercise morningEnergyS5MountainClimbers = Exercise(
    id: 'morning_energy_s5_mountain_climbers',
    name: 'Slow Mountain Climbers',
    description:
        'In a high plank, hands under your shoulders, bring one knee toward your chest and put the foot back, then the other. A steady pace, no jumping from foot to foot.',
    branch: BranchId.morningEnergy,
    stage: 5,
    type: ExerciseType.timed,
    startReps: 20,
    targetReps: 45,
    startSets: 1,
    targetSets: 2,
    startRestSec: 15,
    targetRestSec: 10,
    spBase: 1,
    challengeTargetReps: 30,
    techniqueTip: "Hips level with your shoulders; don't let them pop up.",
    animationPath: 'assets/animations/morning_energy_s5_mountain_climbers.json',
  );

  // ── Yoga ───────────────────────────────────────────────────────────────
  static const Exercise yogaStandingS1Chair = Exercise(
    id: 'yoga_standing_s1_chair',
    name: 'Chair Pose',
    description:
        'Feet together, bend your knees and sit back as if onto a chair, arms raised alongside your ears. Weight in your heels, chest lifted.',
    branch: BranchId.yogaStanding,
    stage: 1,
    type: ExerciseType.timed,
    startReps: 15,
    targetReps: 45,
    startSets: 1,
    targetSets: 2,
    startRestSec: 15,
    targetRestSec: 10,
    spBase: 1,
    techniqueTip: 'Keep your knees behind your toes and draw your belly in.',
    animationPath: 'assets/animations/yoga_standing_s1_chair.json',
  );

  static const Exercise yogaStandingS2Warrior1 = Exercise(
    id: 'yoga_standing_s2_warrior_1',
    name: 'Warrior I',
    description:
        'Step one foot far back and turn it out slightly, bend the front knee over the ankle, hips facing forward. Raise both arms overhead. Then the other side.',
    branch: BranchId.yogaStanding,
    stage: 2,
    type: ExerciseType.timed,
    startReps: 20,
    targetReps: 45,
    startSets: 1,
    targetSets: 2,
    startRestSec: 15,
    targetRestSec: 10,
    spBase: 1,
    challengeTargetReps: 20,
    perSide: true,
    techniqueTip: 'Press the back heel into the floor and keep the back leg straight.',
    animationPath: 'assets/animations/yoga_standing_s2_warrior_1.json',
  );

  static const Exercise yogaStandingS3Warrior2 = Exercise(
    id: 'yoga_standing_s3_warrior_2',
    name: 'Warrior II',
    description:
        'Feet wide apart, the front foot pointing forward, the back foot turned in. Bend the front knee over the ankle and stretch your arms out to the sides at shoulder height, gaze over the front hand. Then the other side.',
    branch: BranchId.yogaStanding,
    stage: 3,
    type: ExerciseType.timed,
    startReps: 20,
    targetReps: 45,
    startSets: 1,
    targetSets: 2,
    startRestSec: 15,
    targetRestSec: 10,
    spBase: 1,
    challengeTargetReps: 30,
    perSide: true,
    techniqueTip: 'The front knee points over your middle toes, not inward.',
    animationPath: 'assets/animations/yoga_standing_s3_warrior_2.json',
  );

  static const Exercise yogaStandingS4Triangle = Exercise(
    id: 'yoga_standing_s4_triangle',
    name: 'Triangle Pose',
    description:
        'Feet wide, the front foot pointing forward. With both legs straight, reach forward and tip your torso over the front leg: the lower hand rests on the shin, the upper arm points at the ceiling. Then the other side.',
    branch: BranchId.yogaStanding,
    stage: 4,
    type: ExerciseType.timed,
    startReps: 20,
    targetReps: 45,
    startSets: 1,
    targetSets: 2,
    startRestSec: 15,
    targetRestSec: 10,
    spBase: 1,
    challengeTargetReps: 30,
    perSide: true,
    techniqueTip: "Lengthen both sides of your waist; don't sink onto the front leg.",
    animationPath: 'assets/animations/yoga_standing_s4_triangle.json',
  );

  static const Exercise yogaStandingS5SideAngle = Exercise(
    id: 'yoga_standing_s5_side_angle',
    name: 'Extended Side Angle',
    description:
        'From Warrior II, rest the forearm of your front arm on the front thigh (or the hand on the floor) and reach the other arm over your ear: one long line from the back foot to the fingertips. Then the other side.',
    branch: BranchId.yogaStanding,
    stage: 5,
    type: ExerciseType.timed,
    startReps: 20,
    targetReps: 45,
    startSets: 1,
    targetSets: 2,
    startRestSec: 15,
    targetRestSec: 10,
    spBase: 1,
    challengeTargetReps: 30,
    perSide: true,
    techniqueTip: 'Keep the front knee over the ankle and turn your chest toward the ceiling.',
    animationPath: 'assets/animations/yoga_standing_s5_side_angle.json',
  );

  static const Exercise yogaOneLegS1Tree = Exercise(
    id: 'yoga_one_leg_s1_tree',
    name: 'Tree Pose',
    description:
        'Stand on one leg and place the other foot on the inner calf or thigh (never on the knee), the knee out to the side. Hands together at the chest or raised overhead. Then the other side.',
    branch: BranchId.yogaOneLeg,
    stage: 1,
    type: ExerciseType.timed,
    startReps: 15,
    targetReps: 45,
    startSets: 1,
    targetSets: 2,
    startRestSec: 15,
    targetRestSec: 10,
    spBase: 1,
    perSide: true,
    techniqueTip: 'Fix your gaze on one point and press the foot and the leg into each other.',
    animationPath: 'assets/animations/yoga_one_leg_s1_tree.json',
  );

  static const Exercise yogaOneLegS2Eagle = Exercise(
    id: 'yoga_one_leg_s2_eagle',
    name: 'Eagle Pose',
    description:
        'Bend your knees, cross one thigh over the other and hook the foot behind the standing calf if you can. Cross the arms at the elbows, palms together in front of your face. Sit a little deeper. Then the other side.',
    branch: BranchId.yogaOneLeg,
    stage: 2,
    type: ExerciseType.timed,
    startReps: 15,
    targetReps: 40,
    startSets: 1,
    targetSets: 2,
    startRestSec: 15,
    targetRestSec: 10,
    spBase: 1,
    challengeTargetReps: 20,
    perSide: true,
    techniqueTip: 'Keep your hips square and lift the elbows to shoulder height.',
    animationPath: 'assets/animations/yoga_one_leg_s2_eagle.json',
  );

  static const Exercise yogaOneLegS3Warrior3 = Exercise(
    id: 'yoga_one_leg_s3_warrior_3',
    name: 'Warrior III',
    description:
        'Stand on one leg, hinge forward and lift the other leg behind you until your body and the leg form a T, arms reaching forward. Then the other side.',
    branch: BranchId.yogaOneLeg,
    stage: 3,
    type: ExerciseType.timed,
    startReps: 10,
    targetReps: 30,
    startSets: 1,
    targetSets: 2,
    startRestSec: 15,
    targetRestSec: 10,
    spBase: 1,
    challengeTargetReps: 15,
    perSide: true,
    techniqueTip: 'Keep both hips level and the standing knee soft.',
    animationPath: 'assets/animations/yoga_one_leg_s3_warrior_3.json',
  );

  static const Exercise yogaOneLegS4Dancer = Exercise(
    id: 'yoga_one_leg_s4_dancer',
    name: 'Dancer Pose',
    description:
        'Stand on one leg, take the other foot behind you with the hand on the same side and press the foot into the hand: the leg rises, the torso tips forward, the free arm reaches ahead. Then the other side.',
    branch: BranchId.yogaOneLeg,
    stage: 4,
    type: ExerciseType.timed,
    startReps: 10,
    targetReps: 30,
    startSets: 1,
    targetSets: 2,
    startRestSec: 15,
    targetRestSec: 10,
    spBase: 1,
    challengeTargetReps: 15,
    perSide: true,
    techniqueTip: 'Press the foot back into the hand rather than pulling the leg up.',
    animationPath: 'assets/animations/yoga_one_leg_s4_dancer.json',
  );

  static const Exercise yogaOneLegS5HalfMoon = Exercise(
    id: 'yoga_one_leg_s5_half_moon',
    name: 'Half Moon',
    description:
        'Tip sideways over one leg: the lower hand on the floor (or a block) under the shoulder, the other leg lifted level with your body, the upper arm pointing at the ceiling. Then the other side.',
    branch: BranchId.yogaOneLeg,
    stage: 5,
    type: ExerciseType.timed,
    startReps: 10,
    targetReps: 30,
    startSets: 1,
    targetSets: 2,
    startRestSec: 15,
    targetRestSec: 10,
    spBase: 1,
    challengeTargetReps: 15,
    perSide: true,
    techniqueTip: 'Stack the hips and shoulders as if your back were against a wall.',
    animationPath: 'assets/animations/yoga_one_leg_s5_half_moon.json',
  );

  static const Exercise yogaBackbendsS1Sphinx = Exercise(
    id: 'yoga_backbends_s1_sphinx',
    name: 'Sphinx',
    description:
        'Lie on your stomach, elbows under your shoulders, forearms on the floor. Lift your chest; your hips and legs stay relaxed on the floor.',
    branch: BranchId.yogaBackbends,
    stage: 1,
    type: ExerciseType.timed,
    startReps: 20,
    targetReps: 60,
    startSets: 1,
    targetSets: 2,
    startRestSec: 15,
    targetRestSec: 10,
    spBase: 1,
    techniqueTip: 'Draw your shoulders away from your ears; the arch is gentle, never pinching.',
    animationPath: 'assets/animations/evening_back_s4_sphinx.json',
  );

  static const Exercise yogaBackbendsS2Locust = Exercise(
    id: 'yoga_backbends_s2_locust',
    name: 'Locust Pose',
    description:
        'Lie on your stomach, arms along your body, palms down. Lift your chest, arms and legs off the floor at the same time, gazing down and slightly forward.',
    branch: BranchId.yogaBackbends,
    stage: 2,
    type: ExerciseType.timed,
    startReps: 10,
    targetReps: 30,
    startSets: 1,
    targetSets: 2,
    startRestSec: 15,
    targetRestSec: 10,
    spBase: 1,
    challengeTargetReps: 15,
    techniqueTip: 'Lengthen through your legs instead of squeezing your lower back.',
    animationPath: 'assets/animations/yoga_backbends_s2_locust.json',
  );

  static const Exercise yogaBackbendsS3Bridge = Exercise(
    id: 'yoga_backbends_s3_bridge',
    name: 'Bridge Pose',
    description:
        'Lie on your back, knees bent, feet hip-width apart near your hips. Press into your feet and lift your hips as high as you can, arms on the floor. Hold, then roll down one vertebra at a time.',
    branch: BranchId.yogaBackbends,
    stage: 3,
    type: ExerciseType.timed,
    startReps: 15,
    targetReps: 45,
    startSets: 1,
    targetSets: 2,
    startRestSec: 15,
    targetRestSec: 10,
    spBase: 1,
    challengeTargetReps: 20,
    techniqueTip: 'Knees point forward, not out; squeeze your glutes.',
    animationPath: 'assets/animations/yoga_backbends_s3_bridge.json',
  );

  static const Exercise yogaBackbendsS4Bow = Exercise(
    id: 'yoga_backbends_s4_bow',
    name: 'Bow Pose',
    description:
        'Lie on your stomach, bend your knees and hold your ankles from the outside. Press the feet into your hands to lift your chest and thighs: the body curves like a bow.',
    branch: BranchId.yogaBackbends,
    stage: 4,
    type: ExerciseType.timed,
    startReps: 10,
    targetReps: 30,
    startSets: 1,
    targetSets: 2,
    startRestSec: 15,
    targetRestSec: 10,
    spBase: 1,
    challengeTargetReps: 15,
    techniqueTip: 'Keep your knees no wider than your hips.',
    animationPath: 'assets/animations/yoga_backbends_s4_bow.json',
  );

  static const Exercise yogaBackbendsS5Camel = Exercise(
    id: 'yoga_backbends_s5_camel',
    name: 'Camel Pose',
    description:
        'Kneel with your knees hip-width apart, toes tucked, hands on your lower back. Press your hips forward, lift the chest and arch back, the head following gently. Come up chest first.',
    branch: BranchId.yogaBackbends,
    stage: 5,
    type: ExerciseType.timed,
    startReps: 15,
    targetReps: 40,
    startSets: 1,
    targetSets: 2,
    startRestSec: 15,
    targetRestSec: 10,
    spBase: 1,
    challengeTargetReps: 15,
    techniqueTip: 'Keep your hips over your knees; the arch comes from the chest, not the lower back.',
    animationPath: 'assets/animations/yoga_backbends_s5_camel.json',
  );

  static const Exercise yogaBackbendsS6Wheel = Exercise(
    id: 'yoga_backbends_s6_wheel',
    name: 'Wheel Pose',
    description:
        'Lie on your back, knees bent, feet near your hips, hands planted by your shoulders. Lift your hips, then press up through the hands until the arms straighten and the head hangs between them. Lower slowly, chin to the chest.',
    branch: BranchId.yogaBackbends,
    stage: 6,
    type: ExerciseType.timed,
    startReps: 5,
    targetReps: 20,
    startSets: 1,
    targetSets: 2,
    startRestSec: 15,
    targetRestSec: 10,
    spBase: 1,
    challengeTargetReps: 10,
    techniqueTip: 'Keep your feet parallel and push the floor away evenly with hands and feet.',
    animationPath: 'assets/animations/yoga_backbends_s6_wheel.json',
  );

  static const Exercise yogaFlowS1DownwardDog = Exercise(
    id: 'yoga_flow_s1_downward_dog',
    name: 'Downward-Facing Dog',
    description:
        'From all fours, straighten your arms and legs and lift your hips upward. Body forms an inverted V. Stretches wrists, shoulders, and legs.',
    branch: BranchId.yogaFlow,
    stage: 1,
    type: ExerciseType.timed,
    startReps: 20,
    targetReps: 60,
    startSets: 1,
    targetSets: 2,
    startRestSec: 15,
    targetRestSec: 10,
    spBase: 1,
    animationPath: 'assets/animations/cooldown_downward_dog.json',
  );

  static const Exercise yogaFlowS2PlankToDog = Exercise(
    id: 'yoga_flow_s2_plank_to_dog',
    name: 'Plank to Downward Dog',
    description:
        'Start in a high plank, hands under your shoulders. Push your hips up and back into an upside-down V, heels toward the floor, then lower back to the plank.',
    branch: BranchId.yogaFlow,
    stage: 2,
    type: ExerciseType.reps,
    startReps: 4,
    targetReps: 10,
    startSets: 1,
    targetSets: 2,
    startRestSec: 15,
    targetRestSec: 10,
    spBase: 1,
    challengeTargetReps: 5,
    techniqueTip: 'Push the floor away with your hands and let your head hang between your arms.',
    animationPath: 'assets/animations/morning_arms_s5_plank_to_dog.json',
  );

  static const Exercise yogaFlowS3HalfSunSalutation = Exercise(
    id: 'yoga_flow_s3_half_sun_salutation',
    name: 'Half Sun Salutation',
    description:
        'One round: standing, sweep the arms up, fold forward, lift halfway with a flat back, fold again, rise with the arms up and lower them. Move with your breath.',
    branch: BranchId.yogaFlow,
    stage: 3,
    type: ExerciseType.reps,
    startReps: 2,
    targetReps: 6,
    startSets: 1,
    targetSets: 2,
    startRestSec: 15,
    targetRestSec: 10,
    spBase: 1,
    challengeTargetReps: 3,
    techniqueTip: 'Breathe in as you rise, out as you fold.',
    animationPath: 'assets/animations/yoga_flow_s3_half_sun_salutation.json',
  );

  static const Exercise yogaFlowS4SunSalutationA = Exercise(
    id: 'yoga_flow_s4_sun_salutation_a',
    name: 'Sun Salutation A',
    description:
        'One round: arms up, fold, half lift, step back to a plank, lower halfway, upward dog, downward dog for a few breaths, step forward, half lift, rise with the arms up, stand.',
    branch: BranchId.yogaFlow,
    stage: 4,
    type: ExerciseType.reps,
    startReps: 2,
    targetReps: 5,
    startSets: 1,
    targetSets: 2,
    startRestSec: 15,
    targetRestSec: 10,
    spBase: 1,
    challengeTargetReps: 2,
    techniqueTip: 'One movement per breath; drop your knees to lower if you need to.',
    animationPath: 'assets/animations/yoga_flow_s4_sun_salutation_a.json',
  );

  static const Exercise yogaFlowS5SunSalutationB = Exercise(
    id: 'yoga_flow_s5_sun_salutation_b',
    name: 'Sun Salutation B',
    description:
        'Like Sun Salutation A, with Chair Pose at the start and the end and Warrior I on each side: chair, fold, plank, lower, upward dog, downward dog, Warrior I on one side, back through the plank to downward dog, Warrior I on the other side, then forward to the chair.',
    branch: BranchId.yogaFlow,
    stage: 5,
    type: ExerciseType.reps,
    startReps: 2,
    targetReps: 5,
    startSets: 1,
    targetSets: 2,
    startRestSec: 15,
    targetRestSec: 10,
    spBase: 1,
    challengeTargetReps: 2,
    techniqueTip: 'Keep your breath even: it sets the pace.',
    animationPath: 'assets/animations/yoga_flow_s5_sun_salutation_b.json',
  );

  /// Morning stretch-up: the one warm-up of every Morning Routine branch.
  static const Exercise warmupMorningStretchUp = Exercise(
    id: 'warmup_morning_stretch_up',
    name: 'Morning Stretch-Up',
    description:
        'Stand tall. Breathing in, reach both arms up over your head and rise onto your toes; breathing out, lower your heels and arms. Stretch as if you have just woken up.',
    branch: BranchId.morningSpine,
    stage: 0,
    type: ExerciseType.reps,
    startReps: 5,
    targetReps: 5,
    startSets: 1,
    targetSets: 1,
    startRestSec: 0,
    targetRestSec: 0,
    spBase: 0,
    techniqueTip: 'Reach long through your fingertips; wake up slowly.',
    animationPath: 'assets/animations/warmup_morning_stretch_up.json',
  );

  /// Shake-out: the one cool-down of every Morning Routine branch.
  static const Exercise cooldownShakeOut = Exercise(
    id: 'cooldown_shake_out',
    name: 'Shake-Out',
    description:
        'Stand loosely and shake out your hands, arms and legs, bouncing softly in your knees. Finish with a deep breath: the day can begin.',
    branch: BranchId.morningSpine,
    stage: 0,
    type: ExerciseType.timed,
    startReps: 20,
    targetReps: 20,
    startSets: 1,
    targetSets: 1,
    startRestSec: 0,
    targetRestSec: 0,
    spBase: 0,
    techniqueTip: 'Let everything hang loose: wrists, shoulders, jaw.',
    animationPath: 'assets/animations/cooldown_shake_out.json',
  );

  // ── WARMUP / COOLDOWN (stage 0) ──────────────────────────────────────────
  //
  // These are accessories used at the start and end of any session.
  // [stage] = 0 signals to WorkoutGeneratorService that they are not
  // part of any progression track.

  static const Exercise warmupArmRotations = Exercise(
    id: 'warmup_arm_rotations',
    name: 'Arm Circles',
    description:
        'Stand tall and make large circular movements with your arms, forward and backward. '
        'Warms up the shoulder girdle before push exercises.',
    branch: BranchId.push,
    stage: 0,
    type: ExerciseType.reps,
    startReps: 10,
    targetReps: 10,
    startSets: 1,
    targetSets: 1,
    startRestSec: 0,
    targetRestSec: 0,
    spBase: 0,
    animationPath: 'assets/animations/warmup_arm_rotations.json',
  );

  static const Exercise warmupDeadHang = Exercise(
    id: 'warmup_dead_hang',
    name: 'Dead Hang',
    description:
        'Hang from a bar with an overhand grip, arms fully extended. '
        'Relax your shoulders and hold the hang.',
    branch: BranchId.pull,
    stage: 0,
    type: ExerciseType.timed,
    startReps: 20,
    targetReps: 20,
    startSets: 1,
    targetSets: 1,
    startRestSec: 0,
    targetRestSec: 0,
    spBase: 0,
    requiresEquipment: true,
    animationPath: 'assets/animations/warmup_dead_hang.json',
  );

  static const Exercise warmupJumpingJacks = Exercise(
    id: 'warmup_jumping_jacks',
    name: 'Jumping Jacks',
    description:
        'Classic jumping jacks. Raises heart rate and warms up the whole body '
        'in 30–60 seconds.',
    branch: BranchId.core,
    stage: 0,
    type: ExerciseType.timed,
    startReps: 30, // seconds
    targetReps: 30,
    startSets: 1,
    targetSets: 1,
    startRestSec: 0,
    targetRestSec: 0,
    spBase: 0,
    animationPath: 'assets/animations/warmup_jumping_jacks.json',
  );

  static const Exercise warmupLegSwings = Exercise(
    id: 'warmup_leg_swings',
    name: 'Leg Swings',
    description:
        'Stand next to a wall and swing one straight leg forward and backward, '
        'then side to side. Warms up the hip joint.',
    branch: BranchId.legs,
    stage: 0,
    type: ExerciseType.reps,
    startReps: 10,
    targetReps: 10,
    startSets: 1,
    targetSets: 1,
    startRestSec: 0,
    targetRestSec: 0,
    spBase: 0,
    animationPath: 'assets/animations/warmup_leg_swings.json',
  );

  static const Exercise warmupHipCircles = Exercise(
    id: 'warmup_hip_circles',
    name: 'Hip Circles',
    description:
        'Stand with feet shoulder-width apart, hands on hips. Make large circles '
        'with your hips clockwise and counterclockwise. Warms up the hip joints.',
    branch: BranchId.legs,
    stage: 0,
    type: ExerciseType.reps,
    startReps: 10,
    targetReps: 10,
    startSets: 1,
    targetSets: 1,
    startRestSec: 0,
    targetRestSec: 0,
    spBase: 0,
    animationPath: 'assets/animations/warmup_hip_circles.json',
  );

  static const Exercise warmupWristCircles = Exercise(
    id: 'warmup_wrist_circles',
    name: 'Wrist Circles',
    description:
        'Rotate your wrists clockwise and counterclockwise. '
        'Prepares the joints for hand-loading exercises.',
    branch: BranchId.balance,
    stage: 0,
    type: ExerciseType.reps,
    startReps: 10,
    targetReps: 10,
    startSets: 1,
    targetSets: 1,
    startRestSec: 0,
    targetRestSec: 0,
    spBase: 0,
    animationPath: 'assets/animations/warmup_wrist_circles.json',
  );

  static const Exercise cooldownShoulderStretch = Exercise(
    id: 'cooldown_shoulder_stretch',
    name: 'Shoulder & Chest Stretch',
    description:
        'Clasp your hands behind your back and pull your shoulders back and down. '
        'Hold for 30 seconds.',
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
    animationPath: 'assets/animations/cooldown_shoulder_stretch.json',
  );

  static const Exercise cooldownLatStretch = Exercise(
    id: 'cooldown_lat_stretch',
    name: 'Lat Stretch',
    description:
        'Stand sideways to a wall, raise one arm and press it against the wall. '
        'Lean sideways until you feel the stretch along your side.',
    branch: BranchId.pull,
    stage: 0,
    type: ExerciseType.timed,
    perSide: true,
    startReps: 30,
    targetReps: 30,
    startSets: 1,
    targetSets: 1,
    startRestSec: 0,
    targetRestSec: 0,
    spBase: 0,
    animationPath: 'assets/animations/cooldown_lat_stretch.json',
  );

  static const Exercise cooldownCatCow = Exercise(
    id: 'cooldown_cat_cow',
    name: 'Cat-Cow',
    description:
        'On hands and knees: inhale and let your back sag down (cow), '
        'exhale and round it upward (cat). Relaxes the lower back and core.',
    branch: BranchId.core,
    stage: 0,
    type: ExerciseType.timed,
    startReps: 30,
    targetReps: 30,
    startSets: 1,
    targetSets: 1,
    startRestSec: 0,
    targetRestSec: 0,
    spBase: 0,
    animationPath: 'assets/animations/cooldown_cat_cow.json',
  );

  static const Exercise cooldownQuadStretch = Exercise(
    id: 'cooldown_quad_stretch',
    name: 'Quad Stretch',
    description:
        'Stand on one leg, bend the other backward and hold the foot with your hand. '
        'Feel the stretch in the front of your thigh.',
    branch: BranchId.legs,
    stage: 0,
    type: ExerciseType.timed,
    perSide: true,
    startReps: 30,
    targetReps: 30,
    startSets: 1,
    targetSets: 1,
    startRestSec: 0,
    targetRestSec: 0,
    spBase: 0,
    animationPath: 'assets/animations/cooldown_quad_stretch.json',
  );

  static const Exercise cooldownHipFlexor = Exercise(
    id: 'cooldown_hip_flexor',
    name: 'Hip Flexor Stretch',
    description:
        'Step into a lunge, lower the back knee to the floor. Keep your torso upright '
        'and feel the stretch in the front of the rear hip.',
    branch: BranchId.legs,
    stage: 0,
    type: ExerciseType.timed,
    perSide: true,
    startReps: 30,
    targetReps: 30,
    startSets: 1,
    targetSets: 1,
    startRestSec: 0,
    targetRestSec: 0,
    spBase: 0,
    animationPath: 'assets/animations/cooldown_hip_flexor.json',
  );

  static const Exercise cooldownDownwardDog = Exercise(
    id: 'cooldown_downward_dog',
    name: 'Downward-Facing Dog',
    description:
        'From all fours, straighten your arms and legs and lift your hips upward. '
        'Body forms an inverted V. Stretches wrists, shoulders, and legs.',
    branch: BranchId.balance,
    stage: 0,
    type: ExerciseType.timed,
    startReps: 30,
    targetReps: 30,
    startSets: 1,
    targetSets: 1,
    startRestSec: 0,
    targetRestSec: 0,
    spBase: 0,
    animationPath: 'assets/animations/cooldown_downward_dog.json',
  );

  // ── Posture Branch ────────────────────────────────────────────────────────

  static const Exercise postureS1PelvicTilt = Exercise(
    id: 'posture_s1_pelvic_tilt',
    name: 'Posterior Pelvic Tilt',
    description:
        'Lie on your back with knees bent. Press your lower back flat '
        'against the floor by tilting your pelvis. Hold for 10 seconds.',
    branch: BranchId.posture,
    stage: 1,
    type: ExerciseType.timed,
    startReps: 10,
    targetReps: 30,
    startSets: 1,
    targetSets: 3,
    startRestSec: 30,
    targetRestSec: 15,
    spBase: 1,
    challengeTargetReps: 30,
    techniqueTip: 'Focus on pressing the small of your back into the floor — '
        'you should feel your abs engage lightly.',
    animationPath: 'assets/animations/posture_s1_pelvic_tilt.json',
  );

  static const Exercise postureS2DeadBug = Exercise(
    id: 'posture_s2_dead_bug',
    name: 'Dead Bug',
    description:
        'Lie on your back, arms up, knees at 90°. Slowly lower one arm '
        'and the opposite leg without letting your lower back arch.',
    branch: BranchId.posture,
    stage: 2,
    type: ExerciseType.reps,
    startReps: 4,
    targetReps: 10,
    startSets: 1,
    targetSets: 3,
    startRestSec: 45,
    targetRestSec: 20,
    spBase: 2,
    challengeTargetReps: 8,
    techniqueTip: 'Move slowly — this is about control, not speed. '
        'Keep your lower back pressed flat the whole time.',
    animationPath: 'assets/animations/supp_dead_bug.json',
  );

  static const Exercise postureS3GluteBridge = Exercise(
    id: 'posture_s3_glute_bridge',
    name: 'Glute Bridge',
    description:
        'Lie on your back, knees bent, feet flat on floor. '
        'Drive your hips up by squeezing your glutes, hold briefly, lower down.',
    branch: BranchId.posture,
    stage: 3,
    type: ExerciseType.reps,
    startReps: 8,
    targetReps: 20,
    startSets: 1,
    targetSets: 3,
    startRestSec: 45,
    targetRestSec: 20,
    spBase: 2,
    challengeTargetReps: 15,
    techniqueTip: 'Squeeze your glutes hard at the top — avoid pushing '
        'with your lower back.',
    animationPath: 'assets/animations/posture_s3_glute_bridge.json',
  );

  static const Exercise postureS4HipMarch = Exercise(
    id: 'posture_s4_hip_march',
    name: 'Standing Hip March',
    description:
        'Stand tall. Slowly lift one knee to hip height and lower it. '
        'Alternate sides. Keep your torso upright and still.',
    branch: BranchId.posture,
    stage: 4,
    type: ExerciseType.reps,
    startReps: 8,
    targetReps: 20,
    startSets: 2,
    targetSets: 3,
    startRestSec: 30,
    targetRestSec: 15,
    spBase: 2,
    challengeTargetReps: 16,
    techniqueTip: 'Lift each knee to hip height without leaning your torso — '
        'focus on the hip flexor doing the work, not momentum.',
    animationPath: 'assets/animations/posture_s4_hip_march.json',
  );

  static const Exercise postureS5KneelingLunge = Exercise(
    id: 'posture_s5_kneeling_lunge',
    name: 'Kneeling Hip Flexor Stretch',
    description:
        'Kneel on one knee, other foot in front. Push your hips forward '
        'until you feel a stretch at the front of your rear hip. Hold.',
    branch: BranchId.posture,
    stage: 5,
    type: ExerciseType.timed,
    perSide: true,
    startReps: 20,
    targetReps: 60,
    startSets: 1,
    targetSets: 2,
    startRestSec: 15,
    targetRestSec: 10,
    spBase: 1,
    challengeTargetReps: 45,
    techniqueTip: 'Keep your back straight and gently tuck your pelvis under '
        'to deepen the stretch.',
    animationPath: 'assets/animations/flex_s1_hip_flexor_stretch.json',
  );

  static const Exercise postureS6PigeonPose = Exercise(
    id: 'posture_s6_pigeon_pose',
    name: 'Pigeon Pose',
    description:
        'From a lunge, bring your front knee across and lower your shin '
        'to the floor. Lean forward until you feel a deep stretch in your hip.',
    branch: BranchId.posture,
    stage: 6,
    type: ExerciseType.timed,
    perSide: true,
    startReps: 20,
    targetReps: 60,
    startSets: 1,
    targetSets: 2,
    startRestSec: 15,
    targetRestSec: 10,
    spBase: 1,
    challengeTargetReps: 45,
    techniqueTip: 'Keep your hips square to the floor as much as possible '
        'and breathe into the stretch.',
    animationPath: 'assets/animations/posture_s6_pigeon_pose.json',
  );

  // ── Neck Branch ────────────────────────────────────────────────────────────

  static const Exercise neckS1NeckTilt = Exercise(
    id: 'neck_s1_neck_tilt',
    name: 'Neck Tilts',
    description:
        'Sit or stand tall. Slowly tilt your head to one side, ear toward '
        'shoulder, until you feel a gentle stretch. Hold, then switch sides.',
    branch: BranchId.neck,
    stage: 1,
    type: ExerciseType.timed,
    perSide: true,
    startReps: 15,
    targetReps: 45,
    startSets: 1,
    targetSets: 2,
    startRestSec: 15,
    targetRestSec: 10,
    spBase: 1,
    challengeTargetReps: 30,
    techniqueTip: 'Do not force your head down with your hand. '
        'Let gravity do the work.',
    animationPath: 'assets/animations/neck_s1_neck_tilt.json',
  );

  static const Exercise neckS2ChestOpener = Exercise(
    id: 'neck_s2_chest_opener',
    name: 'Chest Opener',
    description:
        'Stand tall, clasp your hands behind your back. '
        'Squeeze your shoulder blades together and gently lift your arms '
        'while opening your chest.',
    branch: BranchId.neck,
    stage: 2,
    type: ExerciseType.timed,
    startReps: 15,
    targetReps: 45,
    startSets: 1,
    targetSets: 2,
    startRestSec: 15,
    targetRestSec: 10,
    spBase: 1,
    challengeTargetReps: 30,
    techniqueTip: 'Focus on squeezing your shoulder blades — '
        'do not arch your lower back.',
    animationPath: 'assets/animations/neck_s2_chest_opener.json',
  );

  static const Exercise neckS3ShoulderRoll = Exercise(
    id: 'neck_s3_shoulder_roll',
    name: 'Shoulder Circles',
    description:
        'Roll your shoulders in large, slow circles — forward 5 times, '
        'then backward 5 times. Keep your neck relaxed throughout.',
    branch: BranchId.neck,
    stage: 3,
    type: ExerciseType.reps,
    startReps: 8,
    targetReps: 20,
    startSets: 2,
    targetSets: 3,
    startRestSec: 20,
    targetRestSec: 10,
    spBase: 1,
    challengeTargetReps: 15,
    techniqueTip: 'Make the circles as big as possible — '
        'exaggerate the movement.',
    animationPath: 'assets/animations/neck_s3_shoulder_roll.json',
  );

  static const Exercise neckS4WallAngel = Exercise(
    id: 'neck_s4_wall_angel',
    name: 'Wall Angels',
    description:
        'Stand with your back, head and arms flat against a wall. '
        'Slide your arms up overhead while keeping contact with the wall. '
        'Slowly lower back down.',
    branch: BranchId.neck,
    stage: 4,
    type: ExerciseType.reps,
    startReps: 5,
    targetReps: 15,
    startSets: 2,
    targetSets: 3,
    startRestSec: 30,
    targetRestSec: 15,
    spBase: 2,
    challengeTargetReps: 10,
    techniqueTip: 'Keep your lower back flat against the wall the whole time — '
        'this is harder than it looks.',
    animationPath: 'assets/animations/neck_s4_wall_angel.json',
  );

  static const Exercise neckS5DoorwayStretch = Exercise(
    id: 'neck_s5_doorway_stretch',
    name: 'Doorway Pec Stretch',
    description:
        'Stand in a doorway. Place both forearms on the door frame at '
        'shoulder height. Lean forward gently until you feel a stretch '
        'across your chest and shoulders. Hold.',
    branch: BranchId.neck,
    stage: 5,
    type: ExerciseType.timed,
    startReps: 20,
    targetReps: 60,
    startSets: 1,
    targetSets: 2,
    startRestSec: 15,
    targetRestSec: 10,
    spBase: 1,
    challengeTargetReps: 45,
    techniqueTip: 'Do not push too far forward. Find the edge of the stretch '
        'and breathe into it.',
    animationPath: 'assets/animations/neck_s5_doorway_stretch.json',
  );

  // ── Warmup: Neck Rolls ─────────────────────────────────────────────────────

  static const Exercise warmupNeckRolls = Exercise(
    id: 'warmup_neck_rolls',
    name: 'Neck Rolls',
    description:
        'Gently drop your chin to your chest, then roll your head in '
        'a slow half-circle from side to side. Avoid rolling backward.',
    branch: BranchId.neck,
    stage: 0,
    type: ExerciseType.reps,
    startReps: 5,
    targetReps: 5,
    startSets: 1,
    targetSets: 1,
    startRestSec: 0,
    targetRestSec: 0,
    spBase: 0,
    challengeTargetReps: 5,
    animationPath: 'assets/animations/warmup_neck_rolls.json',
  );

  // ── Grouped accessors ─────────────────────────────────────────────────────

  /// All Push progression exercises ordered by stage.
  static const List<Exercise> pushProgression = [
    pushS1WallPushup,
    pushS2KneePushup,
    pushS3FullPushup,
    pushS4DiamondPushup,
    pushS5WidePushup,
    pushS6ArcherPushup,
    pushS7HandstandPushup,
  ];

  /// All Core progression exercises ordered by stage.
  static const List<Exercise> coreProgression = [
    coreS1Crunches,
    coreS2Plank,
    coreS3LyingLegRaise,
    coreS4HangingLegRaise,
    coreS5LSit,
    coreS6DragonFlag,
  ];

  /// All Pull progression exercises ordered by stage.
  static const List<Exercise> pullProgression = [
    pullS1Australian,
    pullS2Negative,
    pullS3Pullup,
    pullS4CloseGrip,
    pullS5Archer,
    pullS6OneArm,
  ];

  /// All Legs progression exercises ordered by stage.
  static const List<Exercise> legsProgression = [
    legsS1Squat,
    legsS2Lunge,
    legsS3Bulgarian,
    legsS4AssistedPistol,
    legsS5Pistol,
  ];

  /// All Balance progression exercises ordered by stage.
  static const List<Exercise> balanceProgression = [
    balS1OneLegStand,
    balS2OneArmPlank,
    balS3CrowPrep,
    balS4CrowPose,
    balS5WallHs,
    balS6FreeHs,
  ];

  /// All Flex progression exercises ordered by stage.
  static const List<Exercise> flexProgression = [
    flexS1HipFlexorStretch,
    flexS2WorldsGreatestStretch,
    flexS3Hip9090,
    flexS4ThoracicBridge,
    flexS5DeepSquatHold,
    flexS6PikeStretch,
  ];

  /// All Posture progression exercises ordered by stage.
  static const List<Exercise> postureProgression = [
    postureS1PelvicTilt,
    postureS2DeadBug,
    postureS3GluteBridge,
    postureS4HipMarch,
    postureS5KneelingLunge,
    postureS6PigeonPose,
  ];

  /// All Neck progression exercises ordered by stage.
  static const List<Exercise> neckProgression = [
    neckS1NeckTilt,
    neckS2ChestOpener,
    neckS3ShoulderRoll,
    neckS4WallAngel,
    neckS5DoorwayStretch,
  ];

  /// Evening Stretch — Back progression ordered by stage.
  static const List<Exercise> eveningBackProgression = [
    eveningBackS1CatCow,
    eveningBackS2ChildsPose,
    eveningBackS3SupineTwist,
    eveningBackS4Sphinx,
    eveningBackS5Cobra,
  ];

  /// Evening Stretch — Hips progression ordered by stage.
  static const List<Exercise> eveningHipsProgression = [
    eveningHipsS1KneesToChest,
    eveningHipsS2FigureFour,
    eveningHipsS3HappyBaby,
    eveningHipsS4Butterfly,
    eveningHipsS5Frog,
  ];

  /// Evening Stretch — Folds progression ordered by stage.
  static const List<Exercise> eveningFoldsProgression = [
    eveningFoldsS1LegsUpWall,
    eveningFoldsS2TowelHamstring,
    eveningFoldsS3HeadToKnee,
    eveningFoldsS4StraddleFold,
  ];

  /// Evening Stretch — Shoulders progression ordered by stage.
  static const List<Exercise> eveningShouldersProgression = [
    eveningShouldersS1SelfHug,
    eveningShouldersS2TricepsStretch,
    eveningShouldersS3EagleArms,
    eveningShouldersS4PuppyPose,
    eveningShouldersS5CowFaceArms,
  ];

  /// Morning Routine — Spine progression ordered by stage.
  static const List<Exercise> morningSpineProgression = [
    morningSpineS1SideBend,
    morningSpineS2TorsoTwist,
    morningSpineS3GoodMorning,
    morningSpineS4RollDown,
    morningSpineS5Windmill,
  ];

  /// Morning Routine — Joints progression ordered by stage.
  static const List<Exercise> morningJointsProgression = [
    morningJointsS1KneeCircles,
    morningJointsS2OpenTheGate,
    morningJointsS3KneeHug,
    morningJointsS4SideLunge,
    morningJointsS5CossackSquat,
  ];

  /// Morning Routine — Arms progression ordered by stage.
  static const List<Exercise> morningArmsProgression = [
    morningArmsS1ArmSwings,
    morningArmsS2YRaises,
    morningArmsS3CactusArms,
    morningArmsS4Inchworm,
    morningArmsS5PlankToDog,
  ];

  /// Morning Routine — Energy progression ordered by stage.
  static const List<Exercise> morningEnergyProgression = [
    morningEnergyS1StepJacks,
    morningEnergyS2ButtKicks,
    morningEnergyS3CrossCrunch,
    morningEnergyS4SpeedSkater,
    morningEnergyS5MountainClimbers,
  ];

  /// Yoga — Standing progression ordered by stage.
  static const List<Exercise> yogaStandingProgression = [
    yogaStandingS1Chair,
    yogaStandingS2Warrior1,
    yogaStandingS3Warrior2,
    yogaStandingS4Triangle,
    yogaStandingS5SideAngle,
  ];

  /// Yoga — Equilibrium (one leg) progression ordered by stage.
  static const List<Exercise> yogaOneLegProgression = [
    yogaOneLegS1Tree,
    yogaOneLegS2Eagle,
    yogaOneLegS3Warrior3,
    yogaOneLegS4Dancer,
    yogaOneLegS5HalfMoon,
  ];

  /// Yoga — Backbends progression ordered by stage.
  static const List<Exercise> yogaBackbendsProgression = [
    yogaBackbendsS1Sphinx,
    yogaBackbendsS2Locust,
    yogaBackbendsS3Bridge,
    yogaBackbendsS4Bow,
    yogaBackbendsS5Camel,
    yogaBackbendsS6Wheel,
  ];

  /// Yoga — Flow progression ordered by stage.
  static const List<Exercise> yogaFlowProgression = [
    yogaFlowS1DownwardDog,
    yogaFlowS2PlankToDog,
    yogaFlowS3HalfSunSalutation,
    yogaFlowS4SunSalutationA,
    yogaFlowS5SunSalutationB,
  ];

  /// Warmup exercises (stage = 0).
  static const List<Exercise> warmups = [
    warmupArmRotations,
    warmupDeadHang,
    warmupJumpingJacks,
    warmupLegSwings,
    warmupHipCircles,
    warmupWristCircles,
    warmupNeckRolls,
    warmupMorningStretchUp,
  ];

  /// Cooldown exercises (stage = 0).
  static const List<Exercise> cooldowns = [
    cooldownShoulderStretch,
    cooldownLatStretch,
    cooldownCatCow,
    cooldownQuadStretch,
    cooldownHipFlexor,
    cooldownDownwardDog,
    cooldownLyingRelaxation,
    cooldownShakeOut,
  ];

  /// All exercises available for browsing and building custom routines.
  ///
  /// Includes all progression stages, warmups, and cooldowns.
  /// Supplementary exercises are added separately via [SupplementaryExerciseCatalog]
  /// (e.g. in the Custom Routine Builder).
  static List<Exercise> get libraryAll => [
    ...pushProgression,
    ...coreProgression,
    coreS4FlutterKicks,
    ...pullProgression,
    ...legsProgression,
    ...balanceProgression,
    ...flexProgression,
    ...postureProgression,
    ...neckProgression,
    ...eveningBackProgression,
    ...eveningHipsProgression,
    ...eveningFoldsProgression,
    ...eveningShouldersProgression,
    ...morningSpineProgression,
    ...morningJointsProgression,
    ...morningArmsProgression,
    ...morningEnergyProgression,
    ...yogaStandingProgression,
    ...yogaOneLegProgression,
    ...yogaBackbendsProgression,
    ...yogaFlowProgression,
    ...warmups,
    ...cooldowns,
  ];

  /// All exercises in the catalog.
  static const List<Exercise> all = [
    ...pushProgression,
    ...coreProgression,
    ...pullProgression,
    ...legsProgression,
    ...balanceProgression,
    ...flexProgression,
    ...postureProgression,
    ...neckProgression,
    ...eveningBackProgression,
    ...eveningHipsProgression,
    ...eveningFoldsProgression,
    ...eveningShouldersProgression,
    ...morningSpineProgression,
    ...morningJointsProgression,
    ...morningArmsProgression,
    ...morningEnergyProgression,
    ...yogaStandingProgression,
    ...yogaOneLegProgression,
    ...yogaBackbendsProgression,
    ...yogaFlowProgression,
    ...warmups,
    ...cooldowns,
  ];

  /// Returns the ordered progression list for [branch].
  static List<Exercise> progressionFor(BranchId branch) => switch (branch) {
        BranchId.push => pushProgression,
        BranchId.pull => pullProgression,
        BranchId.core => coreProgression,
        BranchId.legs => legsProgression,
        BranchId.balance => balanceProgression,
        BranchId.flex => flexProgression,
        BranchId.posture => postureProgression,
        BranchId.neck => neckProgression,
        BranchId.eveningBack => eveningBackProgression,
        BranchId.eveningHips => eveningHipsProgression,
        BranchId.eveningFolds => eveningFoldsProgression,
        BranchId.eveningShoulders => eveningShouldersProgression,
        BranchId.morningSpine => morningSpineProgression,
        BranchId.morningJoints => morningJointsProgression,
        BranchId.morningArms => morningArmsProgression,
        BranchId.morningEnergy => morningEnergyProgression,
        BranchId.yogaStanding => yogaStandingProgression,
        BranchId.yogaOneLeg => yogaOneLegProgression,
        BranchId.yogaBackbends => yogaBackbendsProgression,
        BranchId.yogaFlow => yogaFlowProgression,
      };

  /// Returns the exercise for [branch] at [stage], or null if not found.
  static Exercise? forStage(BranchId branch, int stage) {
    final progression = progressionFor(branch);
    return progression.where((e) => e.stage == stage).firstOrNull;
  }

  /// Returns an equipment-free alternative for [branch] at [stage], or null if
  /// no alternative exists (exercise can be done without equipment as-is).
  static Exercise? equipmentFreeForStage(BranchId branch, int stage) {
    if (branch == BranchId.core && stage == 4) return coreS4FlutterKicks;
    return null;
  }

  /// Returns the exercise with [id], or null if not found.
  static Exercise? byId(String id) {
    try {
      return all.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Returns the warmup exercise for the given [branch].
  static Exercise? warmupFor(BranchId branch) => switch (branch) {
        BranchId.push => warmupArmRotations,
        BranchId.pull => warmupDeadHang,
        BranchId.core => warmupJumpingJacks,
        BranchId.legs => warmupHipCircles,
        BranchId.balance => warmupWristCircles,
        BranchId.flex => warmupLegSwings,
        BranchId.posture => warmupHipCircles,
        BranchId.neck => warmupNeckRolls,
        BranchId.eveningBack ||
        BranchId.eveningHips ||
        BranchId.eveningFolds ||
        BranchId.eveningShoulders =>
          warmupNeckRolls,
        BranchId.morningSpine ||
        BranchId.morningJoints ||
        BranchId.morningArms ||
        BranchId.morningEnergy =>
          warmupMorningStretchUp,
        BranchId.yogaStanding ||
        BranchId.yogaOneLeg ||
        BranchId.yogaBackbends ||
        BranchId.yogaFlow =>
          cooldownCatCow,
      };

  /// Returns the cooldown exercise(s) for the given [branch].
  static List<Exercise> cooldownsFor(BranchId branch) => switch (branch) {
        BranchId.push => [cooldownShoulderStretch],
        BranchId.pull => [cooldownLatStretch],
        BranchId.core => [cooldownCatCow],
        BranchId.legs => [cooldownQuadStretch, cooldownHipFlexor],
        BranchId.balance => [cooldownDownwardDog],
        BranchId.flex => [cooldownCatCow],
        BranchId.posture => [cooldownHipFlexor, cooldownQuadStretch],
        BranchId.neck => [cooldownCatCow, cooldownShoulderStretch],
        BranchId.eveningBack ||
        BranchId.eveningHips ||
        BranchId.eveningFolds ||
        BranchId.eveningShoulders =>
          [cooldownLyingRelaxation],
        BranchId.morningSpine ||
        BranchId.morningJoints ||
        BranchId.morningArms ||
        BranchId.morningEnergy =>
          [cooldownShakeOut],
        BranchId.yogaStanding ||
        BranchId.yogaOneLeg ||
        BranchId.yogaBackbends ||
        BranchId.yogaFlow =>
          [cooldownLyingRelaxation],
      };
}
