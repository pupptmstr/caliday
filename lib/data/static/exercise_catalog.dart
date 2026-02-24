import '../models/enums.dart';
import '../models/exercise.dart';

/// Static catalog of all exercises used in MVP v1.0 (Push + Core branches).
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
    name: 'Отжимания от стены',
    description:
        'Встань на расстоянии шага от стены, упрись ладонями на уровне груди. '
        'Сгибай руки, пока грудь не коснётся стены, затем выпрямляй.',
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
    techniqueTip: 'Держи тело прямым, не прогибай поясницу.',
  );

  static const Exercise pushS2KneePushup = Exercise(
    id: 'push_s2_knee_pushup',
    name: 'Отжимания с колен',
    description:
        'Упор лёжа с опорой на колени. Тело от колен до головы — прямая линия. '
        'Опускайся грудью к полу, затем выжимай.',
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
    techniqueTip: 'Не опускай бёдра — держи прямую линию от колен до плеч.',
  );

  static const Exercise pushS3FullPushup = Exercise(
    id: 'push_s3_full_pushup',
    name: 'Полные отжимания',
    description:
        'Классический упор лёжа. Тело — прямая линия от пяток до головы. '
        'Грудь касается пола или подходит на 2–3 см.',
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
    techniqueTip: 'Напрягай пресс и ягодицы, чтобы не провисали бёдра.',
  );

  static const Exercise pushS4DiamondPushup = Exercise(
    id: 'push_s4_diamond_pushup',
    name: 'Алмазные отжимания',
    description:
        'Руки под грудью, большие и указательные пальцы образуют ромб. '
        'Акцент на трицепс. Локти прижаты к корпусу при опускании.',
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
    techniqueTip: 'Локти не разводи — они должны скользить вдоль тела.',
  );

  static const Exercise pushS5ArcherPushup = Exercise(
    id: 'push_s5_archer_pushup',
    name: 'Отжимания лучника',
    description:
        'Широкая постановка рук. Опускайся в сторону одной руки, '
        'держа вторую прямой. Поочерёдно на каждую сторону.',
    branch: BranchId.push,
    stage: 5,
    type: ExerciseType.reps,
    startReps: 2,
    targetReps: 10,
    startSets: 1,
    targetSets: 3,
    startRestSec: 90,
    targetRestSec: 45,
    spBase: 3,
    techniqueTip: 'Рабочая рука — полный диапазон, прямая рука на полу — поддержка.',
  );

  static const Exercise pushS6OneArmPushup = Exercise(
    id: 'push_s6_one_arm_pushup',
    name: 'Отжимания на одной руке',
    description:
        'Одна рука за спиной или сбоку. Ноги шире плеч для баланса. '
        'Полный диапазон движения рабочей рукой.',
    branch: BranchId.push,
    stage: 6,
    type: ExerciseType.reps,
    startReps: 1,
    targetReps: 5,
    startSets: 1,
    targetSets: 3,
    startRestSec: 90,
    targetRestSec: 60,
    spBase: 5,
    techniqueTip: 'Начинай с наклонной поверхности — так легче освоить технику.',
  );

  static const Exercise pushS7HandstandPushup = Exercise(
    id: 'push_s7_handstand_pushup',
    name: 'Отжимания в стойке на руках',
    description:
        'Стойка на руках у стены (спиной). Медленно опускай голову к полу, '
        'затем выжимай корпус вверх.',
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
    techniqueTip: 'Пальцы широко расставлены — так стабильнее. Взгляд между рук.',
  );

  // ── CORE ──────────────────────────────────────────────────────────────────

  static const Exercise coreS1Crunches = Exercise(
    id: 'core_s1_crunches',
    name: 'Скручивания',
    description:
        'Лёжа на спине, колени согнуты. Руки за головой или скрещены на груди. '
        'Отрывай лопатки от пола, сокращая пресс.',
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
    techniqueTip: 'Не тяни шею руками — тяни грудью к потолку.',
  );

  static const Exercise coreS2Plank = Exercise(
    id: 'core_s2_plank',
    name: 'Планка',
    description:
        'Упор лёжа на предплечьях. Тело — прямая линия от пяток до головы. '
        'Не поднимай таз и не прогибай поясницу.',
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
    techniqueTip: 'Напрягай пресс и ягодицы. Дыши ровно — не задерживай.',
  );

  static const Exercise coreS3LyingLegRaise = Exercise(
    id: 'core_s3_lying_leg_raise',
    name: 'Подъёмы ног лёжа',
    description:
        'Лёжа на спине, руки под ягодицами. Прямые ноги поднимай до вертикали, '
        'затем медленно опускай не касаясь пола.',
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
    techniqueTip: 'Поясница прижата к полу на протяжении всего движения.',
  );

  static const Exercise coreS4HangingLegRaise = Exercise(
    id: 'core_s4_hanging_leg_raise',
    name: 'Подъёмы ног в висе',
    description:
        'Повис на перекладине. Поднимай прямые ноги до параллели с полом '
        'или выше. Контролируй опускание.',
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
    techniqueTip: 'Не раскачивайся — движение только за счёт пресса.',
  );

  static const Exercise coreS5LSit = Exercise(
    id: 'core_s5_l_sit',
    name: 'Уголок (L-sit)',
    description:
        'Упор на параллельных брусьях или полу. Ноги прямые, параллельны полу. '
        'Удерживай позицию как можно дольше.',
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
    techniqueTip: 'Носки тяни на себя, плечи — вниз и назад.',
  );

  static const Exercise coreS6DragonFlag = Exercise(
    id: 'core_s6_dragon_flag',
    name: 'Драконовый флаг',
    description:
        'Лёжа на скамье, держись за опору за головой. Подними тело в прямую '
        'линию на лопатках, затем медленно опускай.',
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
    techniqueTip: 'Начинай с негативной фазы (только опускание) — это проще.',
  );

  // ── WARMUP / COOLDOWN (stage 0) ──────────────────────────────────────────
  //
  // These are accessories used at the start and end of any session.
  // [stage] = 0 signals to WorkoutGeneratorService that they are not
  // part of any progression track.

  static const Exercise warmupArmRotations = Exercise(
    id: 'warmup_arm_rotations',
    name: 'Круговые вращения руками',
    description:
        'Стоя, делай большие круговые движения руками вперёд и назад. '
        'Разминает плечевой пояс перед отжиманиями.',
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
  );

  static const Exercise warmupJumpingJacks = Exercise(
    id: 'warmup_jumping_jacks',
    name: 'Прыжки «Ноги вместе — врозь»',
    description:
        'Классические jumping jacks. Повышают пульс и разогревают всё тело '
        'за 30–60 секунд.',
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
  );

  static const Exercise cooldownShoulderStretch = Exercise(
    id: 'cooldown_shoulder_stretch',
    name: 'Растяжка плеч и груди',
    description:
        'Заведи руки за спину, сцепи пальцы и потяни плечи назад-вниз. '
        'Удержи 30 секунд.',
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

  static const Exercise cooldownCatCow = Exercise(
    id: 'cooldown_cat_cow',
    name: 'Кошка-корова',
    description:
        'На четвереньках: на вдохе прогибай спину вниз (корова), '
        'на выдохе округляй вверх (кошка). Расслабляет поясницу и пресс.',
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
  );

  // ── Grouped accessors ─────────────────────────────────────────────────────

  /// All Push progression exercises ordered by stage.
  static const List<Exercise> pushProgression = [
    pushS1WallPushup,
    pushS2KneePushup,
    pushS3FullPushup,
    pushS4DiamondPushup,
    pushS5ArcherPushup,
    pushS6OneArmPushup,
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

  /// Warmup exercises (stage = 0).
  static const List<Exercise> warmups = [
    warmupArmRotations,
    warmupJumpingJacks,
  ];

  /// Cooldown exercises (stage = 0).
  static const List<Exercise> cooldowns = [
    cooldownShoulderStretch,
    cooldownCatCow,
  ];

  /// All exercises available in MVP v1.0.
  static const List<Exercise> all = [
    ...pushProgression,
    ...coreProgression,
    ...warmups,
    ...cooldowns,
  ];

  /// Returns the exercise for [branch] at [stage], or null if not found.
  static Exercise? forStage(BranchId branch, int stage) {
    try {
      return all.firstWhere((e) => e.branch == branch && e.stage == stage);
    } catch (_) {
      return null;
    }
  }

  /// Returns the exercise with [id], or null if not found.
  static Exercise? byId(String id) {
    try {
      return all.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }
}