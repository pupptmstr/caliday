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
    startReps: 8,
    targetReps: 20,
    startSets: 1,
    targetSets: 3,
    startRestSec: 45,
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
    startRestSec: 60,
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
    startReps: 10,
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
    startReps: 20, // seconds
    targetReps: 60,
    startSets: 1,
    targetSets: 3,
    startRestSec: 30,
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
    startReps: 20,
    targetReps: 60,
    startSets: 1,
    targetSets: 3,
    startRestSec: 30,
    targetRestSec: 15,
    spBase: 1,
    challengeTargetReps: 20,
    techniqueTip: 'Keep your back straight and push hips forward — feel the stretch in the front of your hip.',
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
    startReps: 20,
    targetReps: 60,
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
    techniqueTip: 'Reach forward from your hips, not your waist. Keep legs straight.',
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

  /// Warmup exercises (stage = 0).
  static const List<Exercise> warmups = [
    warmupArmRotations,
    warmupDeadHang,
    warmupJumpingJacks,
    warmupLegSwings,
    warmupHipCircles,
    warmupWristCircles,
    warmupNeckRolls,
  ];

  /// Cooldown exercises (stage = 0).
  static const List<Exercise> cooldowns = [
    cooldownShoulderStretch,
    cooldownLatStretch,
    cooldownCatCow,
    cooldownQuadStretch,
    cooldownHipFlexor,
    cooldownDownwardDog,
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
      };
}
