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
    animationPath: 'assets/animations/push_s1_wall_pushup.json',
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
    challengeTargetReps: 3,
    techniqueTip: 'Не опускай бёдра — держи прямую линию от колен до плеч.',
    animationPath: 'assets/animations/push_s2_knee_pushup.json',
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
    challengeTargetReps: 3,
    techniqueTip: 'Напрягай пресс и ягодицы, чтобы не провисали бёдра.',
    animationPath: 'assets/animations/push_s3_full_pushup.json',
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
    challengeTargetReps: 5,
    techniqueTip: 'Локти не разводи — они должны скользить вдоль тела.',
    animationPath: 'assets/animations/push_s4_diamond_pushup.json',
  );

  static const Exercise pushS5WidePushup = Exercise(
    id: 'push_s5_wide_pushup',
    name: 'Широкие отжимания',
    description:
        'Руки значительно шире плеч. Опускайся медленно, сохраняя прямую '
        'линию тела. Оба трицепса и грудь работают в широкой амплитуде.',
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
    techniqueTip: 'Чем шире руки — тем больше нагрузка на грудь и меньше на трицепс.',
    animationPath: 'assets/animations/push_s5_wide_pushup.json',
  );

  static const Exercise pushS6ArcherPushup = Exercise(
    id: 'push_s6_archer_pushup',
    name: 'Отжимания лучника',
    description:
        'Широкая постановка рук. Опускайся в сторону одной руки, '
        'держа вторую прямой. Поочерёдно на каждую сторону.',
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
    techniqueTip: 'Рабочая рука — полный диапазон, прямая рука на полу — поддержка.',
    animationPath: 'assets/animations/push_s6_archer_pushup.json',
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
    animationPath: 'assets/animations/push_s7_handstand_pushup.json',
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
    animationPath: 'assets/animations/core_s1_crunches.json',
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
    challengeTargetReps: 30,
    techniqueTip: 'Напрягай пресс и ягодицы. Дыши ровно — не задерживай.',
    animationPath: 'assets/animations/core_s2_plank.json',
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
    challengeTargetReps: 5,
    techniqueTip: 'Поясница прижата к полу на протяжении всего движения.',
    animationPath: 'assets/animations/core_s3_lying_leg_raise.json',
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
    challengeTargetReps: 3,
    requiresEquipment: true,
    techniqueTip: 'Не раскачивайся — движение только за счёт пресса.',
    animationPath: 'assets/animations/core_s4_hanging_leg_raise.json',
  );

  /// Equipment-free alternative to [coreS4HangingLegRaise] for users without a pull-up bar.
  static const Exercise coreS4FlutterKicks = Exercise(
    id: 'core_s4_flutter_kicks',
    name: 'Ножницы',
    description:
        'Лёжа на спине, руки под ягодицами. Подними ноги на 15–20 см от пола. '
        'Поочерёдно поднимай и опускай каждую ногу быстрыми небольшими движениями. '
        'Одно повторение — один цикл (правая вверх + левая вверх).',
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
    techniqueTip: 'Поясница прижата к полу. Ноги не касаются пола между повторами.',
    animationPath: 'assets/animations/core_s4_flutter_kicks.json',
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
    challengeTargetReps: 5,
    techniqueTip: 'Носки тяни на себя, плечи — вниз и назад.',
    animationPath: 'assets/animations/core_s5_l_sit.json',
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
    animationPath: 'assets/animations/core_s6_dragon_flag.json',
  );

  // ── PULL ──────────────────────────────────────────────────────────────────

  static const Exercise pullS1Australian = Exercise(
    id: 'pull_s1_australian',
    name: 'Австралийский подтягивание',
    description:
        'Лёжа под перекладиной, хват чуть шире плеч. Тяни грудь к перекладине, '
        'держа тело прямой линией. Контролируй опускание.',
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
    techniqueTip: 'Чем ниже опускаешь перекладину, тем сложнее упражнение.',
    animationPath: 'assets/animations/pull_s1_australian.json',
  );

  static const Exercise pullS2Negative = Exercise(
    id: 'pull_s2_negative',
    name: 'Негативные подтягивания',
    description:
        'Запрыгни на перекладину с подбородком выше неё. Медленно опускайся '
        'в течение 3–5 секунд до полного выпрямления рук.',
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
    techniqueTip: 'Чем медленнее опускаешься — тем лучше. Цель: 5 сек вниз.',
    animationPath: 'assets/animations/pull_s2_negative.json',
  );

  static const Exercise pullS3Pullup = Exercise(
    id: 'pull_s3_pullup',
    name: 'Подтягивания',
    description:
        'Хват на ширине плеч или чуть шире. Тяни грудь к перекладине, '
        'пока подбородок не окажется выше неё. Полностью выпрямляй руки внизу.',
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
    techniqueTip: 'Сводя лопатки — тянешь спиной, а не руками.',
    animationPath: 'assets/animations/pull_s3_pullup.json',
  );

  static const Exercise pullS4CloseGrip = Exercise(
    id: 'pull_s4_close_grip',
    name: 'Подтягивания узким хватом',
    description:
        'Хват уже плеч, ладони к себе или от себя. Акцент на бицепс '
        'и нижнюю часть широчайших. Подтягивай грудь к перекладине.',
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
    techniqueTip: 'Локти прижимай к корпусу для максимальной нагрузки на бицепс.',
    animationPath: 'assets/animations/pull_s4_close_grip.json',
  );

  static const Exercise pullS5Archer = Exercise(
    id: 'pull_s5_archer',
    name: 'Подтягивания лучника',
    description:
        'Широкий хват. Тяни тело в сторону одной руки, вторую держи прямой. '
        'Поочерёдно на каждую сторону.',
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
    techniqueTip: 'Прямая рука — вспомогательная, рабочая — полный диапазон.',
    animationPath: 'assets/animations/pull_s5_archer.json',
  );

  static const Exercise pullS6OneArm = Exercise(
    id: 'pull_s6_one_arm',
    name: 'Подтягивание на одной руке',
    description:
        'Одна рука держит перекладину, вторая — на запястье или свободна. '
        'Полный диапазон движения рабочей рукой.',
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
    techniqueTip: 'Держи корпус стабильным — не раскачивайся.',
    animationPath: 'assets/animations/pull_s6_one_arm.json',
  );

  // ── LEGS ──────────────────────────────────────────────────────────────────

  static const Exercise legsS1Squat = Exercise(
    id: 'legs_s1_squat',
    name: 'Приседания',
    description:
        'Ноги на ширине плеч, носки чуть развёрнуты. Приседай до параллели '
        'бёдер с полом, колени над носками. Выпрямляй ноги в верхней точке.',
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
    techniqueTip: 'Пятки не отрывай от пола, грудь держи прямо.',
    animationPath: 'assets/animations/legs_s1_squat.json',
  );

  static const Exercise legsS2Lunge = Exercise(
    id: 'legs_s2_lunge',
    name: 'Выпады',
    description:
        'Шаг вперёд, опусти заднее колено к полу, не касаясь. Оба колена '
        'под углом 90°. Оттолкнись передней ногой и вернись в исходное.',
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
    techniqueTip: 'Переднее колено не уходи за носок.',
    animationPath: 'assets/animations/legs_s2_lunge.json',
  );

  static const Exercise legsS3Bulgarian = Exercise(
    id: 'legs_s3_bulgarian',
    name: 'Болгарские сплит-приседания',
    description:
        'Задняя нога на возвышении (стул, диван). Опускай переднюю ногу до '
        'параллели бедра с полом. Торс прямой.',
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
    techniqueTip: 'Чем дальше передняя нога — тем больше нагрузка на ягодицы.',
    animationPath: 'assets/animations/legs_s3_bulgarian.json',
  );

  static const Exercise legsS4AssistedPistol = Exercise(
    id: 'legs_s4_assisted_pistol',
    name: 'Пистолетик с опорой',
    description:
        'Держись за дверной косяк или стойку. Приседай на одной ноге, '
        'вторую держи прямой перед собой. Опора снижает нагрузку.',
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
    techniqueTip: 'Постепенно уменьшай помощь рук по мере роста силы.',
    animationPath: 'assets/animations/legs_s4_pistol.json',
  );

  static const Exercise legsS5Pistol = Exercise(
    id: 'legs_s5_pistol',
    name: 'Пистолетик',
    description:
        'Приседание на одной ноге без опоры. Вторая нога прямая перед собой. '
        'Полная амплитуда до пола и обратно.',
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
    techniqueTip: 'Руки вперёд для противовеса — помогает с балансом.',
    animationPath: 'assets/animations/legs_s5_pistol_free.json',
  );

  // ── BALANCE ───────────────────────────────────────────────────────────────

  static const Exercise balS1OneLegStand = Exercise(
    id: 'bal_s1_one_leg_stand',
    name: 'Стойка на одной ноге',
    description:
        'Стой на одной ноге, вторую слегка согни и удержи в воздухе. '
        'Руки можно держать в стороны для баланса.',
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
    techniqueTip: 'Фиксируй взгляд на точке — это сильно улучшает баланс.',
  );

  static const Exercise balS2OneArmPlank = Exercise(
    id: 'bal_s2_one_arm_plank',
    name: 'Планка на одной руке',
    description:
        'Классическая планка на вытянутых руках. Оторви одну руку от пола '
        'и удержи позицию, тело параллельно полу.',
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
    techniqueTip: 'Бёдра держи параллельно полу — не разворачивай корпус.',
  );

  static const Exercise balS3CrowPrep = Exercise(
    id: 'bal_s3_crow_prep',
    name: 'Подготовка к позе ворона',
    description:
        'Присядь, колени на трицепсах. Перенеси вес на руки, слегка '
        'отрывая ноги. Удержи баланс на руках.',
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
    techniqueTip: 'Взгляд вперёд-вниз, не прямо вниз — иначе упадёшь.',
  );

  static const Exercise balS4CrowPose = Exercise(
    id: 'bal_s4_crow_pose',
    name: 'Поза ворона (Kakasana)',
    description:
        'Оба колена на трицепсах, полный баланс на руках. Руки слегка '
        'согнуты, пальцы широко расставлены.',
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
    techniqueTip: 'Округли спину — это активирует корпус и даёт баланс.',
  );

  static const Exercise balS5WallHs = Exercise(
    id: 'bal_s5_wall_hs',
    name: 'Стойка на руках у стены',
    description:
        'Встань на руки спиной к стене. Пятки касаются стены для опоры. '
        'Удержи стойку, тело вытянуто в линию.',
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
    techniqueTip: 'Пальцы широко, надавливай на подушечки — это баланс.',
  );

  static const Exercise balS6FreeHs = Exercise(
    id: 'bal_s6_free_hs',
    name: 'Свободная стойка на руках',
    description:
        'Стойка на руках без опоры. Контролируй баланс мелкими движениями '
        'пальцев и запястий.',
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
    techniqueTip: 'Смотри в пол на 30–40 см перед руками, не между руками.',
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
    animationPath: 'assets/animations/warmup_arm_rotations.json',
  );

  static const Exercise warmupDeadHang = Exercise(
    id: 'warmup_dead_hang',
    name: 'Вис на перекладине',
    description:
        'Повисни на перекладине прямым хватом, руки полностью выпрямлены. '
        'Расслабь плечи и удержи вис.',
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
    animationPath: 'assets/animations/warmup_jumping_jacks.json',
  );

  static const Exercise warmupLegSwings = Exercise(
    id: 'warmup_leg_swings',
    name: 'Махи ногами',
    description:
        'Стоя у стены, делай маховые движения прямой ногой вперёд-назад '
        'и в стороны. Разминает тазобедренный сустав.',
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
    name: 'Вращения тазом',
    description:
        'Стоя, ноги на ширине плеч, руки на бёдрах. Делай широкие круговые '
        'движения тазом по и против часовой стрелки. Разогревает тазобедренные суставы.',
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
    name: 'Круговые вращения запястьями',
    description:
        'Вращай запястьями по часовой и против часовой стрелки. '
        'Подготавливает суставы к нагрузке на руках.',
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
    animationPath: 'assets/animations/cooldown_shoulder_stretch.json',
  );

  static const Exercise cooldownLatStretch = Exercise(
    id: 'cooldown_lat_stretch',
    name: 'Растяжка широчайших',
    description:
        'Встань боком к стене, подними руку вверх и упрись в стену. '
        'Наклонись в сторону, чувствуя растяжку сбоку.',
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
    animationPath: 'assets/animations/cooldown_cat_cow.json',
  );

  static const Exercise cooldownQuadStretch = Exercise(
    id: 'cooldown_quad_stretch',
    name: 'Растяжка квадрицепса',
    description:
        'Стоя на одной ноге, согни вторую назад и удержи стопу рукой. '
        'Почувствуй растяжку передней поверхности бедра.',
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
    name: 'Растяжка сгибателей бедра',
    description:
        'Стань в выпад, опусти заднее колено на пол. Держи корпус прямо '
        'и почувствуй растяжку в передней части бедра задней ноги.',
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
    name: 'Собака мордой вниз',
    description:
        'На четвереньках выпрями руки и ноги, подними таз вверх. '
        'Тело — перевёрнутая V. Растяжка запястий, плеч и ног.',
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
