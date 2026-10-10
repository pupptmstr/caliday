// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String durationMin(int mins, int secs) {
    return '$mins мин $secs сек';
  }

  @override
  String durationSec(int secs) {
    return '$secs сек';
  }

  @override
  String durationSecPerSide(int secs) {
    return '$secs сек на каждую сторону';
  }

  @override
  String get navHome => 'Тренировка';

  @override
  String get navLibrary => 'Курсы';

  @override
  String get navProfile => 'Профиль';

  @override
  String get libraryTitle => 'Курсы';

  @override
  String get progressInfo =>
      'Просто тренируйтесь — приложение само продвигает вас вперёд по веткам. Здесь можно отследить пройденный путь. А если чувствуете, что готовы к большему раньше времени — принимайте Испытание и переходите сами.';

  @override
  String homeStreakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count дня',
      many: '$count дней',
      few: '$count дня',
      one: '$count день',
    );
    return '$_temp0';
  }

  @override
  String get homeBranchesTitle => 'Ветки прогрессии';

  @override
  String get homeBranchPush => 'Толкай';

  @override
  String get homeBranchPull => 'Тяга';

  @override
  String get homeBranchCore => 'Кор';

  @override
  String get homeBranchLegs => 'Ноги';

  @override
  String get homeBranchBalance => 'Баланс';

  @override
  String get homeBranchFlex => 'Гибкость';

  @override
  String get homeBranchPosture => 'Осанка';

  @override
  String get homeBranchNeck => 'Шея';

  @override
  String get homeBranchEveningBack => 'Спина';

  @override
  String get homeBranchEveningHips => 'Бёдра';

  @override
  String get homeBranchEveningFolds => 'Наклоны';

  @override
  String get homeBranchEveningShoulders => 'Плечи';

  @override
  String get homeBranchMorningSpine => 'Позвоночник';

  @override
  String get homeBranchMorningJoints => 'Суставы';

  @override
  String get homeBranchMorningArms => 'Руки';

  @override
  String get homeBranchMorningEnergy => 'Бодрость';

  @override
  String get homeBranchYogaStanding => 'Стойки';

  @override
  String get homeBranchYogaOneLeg => 'Равновесие';

  @override
  String get homeBranchYogaBackbends => 'Прогибы';

  @override
  String get homeBranchYogaFlow => 'Поток';

  @override
  String get courseNameCalisthenics => 'Калистеника';

  @override
  String get courseNameHealthyBody => 'Здоровое тело';

  @override
  String get courseNameEveningStretch => 'Вечерняя растяжка';

  @override
  String get courseNameMorningRoutine => 'Утренняя зарядка';

  @override
  String get courseNameYoga => 'Йога';

  @override
  String get courseDescCalisthenics =>
      'Базовые упражнения с весом тела — от простого к сложному. Сила, выносливость, контроль.';

  @override
  String get courseDescHealthyBody =>
      'Упражнения для тех, кто много сидит. Осанка, шея, гибкость — без нагрузки на суставы.';

  @override
  String get courseDescEveningStretch =>
      'Спокойная растяжка перед сном. Спина, бёдра, ноги и плечи — медленно, на полу, в конце лёжа.';

  @override
  String get courseDescMorningRoutine =>
      'Разбуди тело. Позвоночник, суставы, руки и немного бодрости — стоя, тихо, без прыжков.';

  @override
  String get courseDescYoga =>
      'Позы от простых к сложным: стойки, равновесие на одной ноге, прогибы, приветствие солнцу и баланс на руках.';

  @override
  String get onboardingQ4Courses => 'Выбери курс';

  @override
  String get onboardingQ4CoursesBody =>
      'Можно начать с одного или взять несколько — программы независимы.';

  @override
  String branchJourneyProgress(int done, int total) {
    return 'Пройдено $done из $total этапов';
  }

  @override
  String get branchJourneyStageCompleted => '✓ Пройдено';

  @override
  String get branchJourneyStageCurrent => 'Текущий этап';

  @override
  String get branchJourneyStageLocked => 'Заблокировано';

  @override
  String branchJourneyParams(int reps, int sets, int rest) {
    return '$reps повт. × $sets подх.  ·  Отдых $rest с';
  }

  @override
  String branchJourneyParamsTimed(int secs, int sets, int rest) {
    return '$secs с × $sets подх.  ·  Отдых $rest с';
  }

  @override
  String branchJourneyParamsTimedPerSide(int secs, int sets, int rest) {
    return '$secs с на сторону × $sets подх.  ·  Отдых $rest с';
  }

  @override
  String get branchJourneyStartChallenge => 'Пройти испытание';

  @override
  String homeStage(int stage, int total) {
    return 'Этап $stage/$total';
  }

  @override
  String get homeChallengeUnlocked => 'Испытание доступно';

  @override
  String get homeChallengeButton => 'Принять вызов';

  @override
  String homeChallengeNormReps(int n) {
    return 'Норматив: $n повт.';
  }

  @override
  String homeChallengeNormSec(int n) {
    return 'Норматив: $n сек';
  }

  @override
  String homeChallengeNormSecPerSide(int n) {
    return 'Норматив: $n сек на каждую сторону';
  }

  @override
  String get homeWorkoutDone => 'Тренировка выполнена';

  @override
  String get homeWorkoutStart => 'Тренировка дня';

  @override
  String homeWorkoutStartEstimate(int minutes) {
    return 'Тренировка дня (≈ $minutes мин)';
  }

  @override
  String get homeWorkoutAgain => 'Ещё раз';

  @override
  String homeWorkoutAgainEstimate(int minutes) {
    return 'Ещё раз (≈ $minutes мин)';
  }

  @override
  String get workoutTitle => 'Тренировка';

  @override
  String get workoutExitTitle => 'Прервать тренировку?';

  @override
  String get workoutExitBody => 'Прогресс текущей тренировки не сохранится.';

  @override
  String get workoutContinue => 'Продолжить';

  @override
  String get workoutAbort => 'Прервать';

  @override
  String workoutSetProgress(int current, int total) {
    return 'Подход $current из $total';
  }

  @override
  String workoutSetSideProgress(int current, int total, int side) {
    return 'Подход $current из $total  ·  сторона $side из 2';
  }

  @override
  String get workoutSec => 'сек';

  @override
  String get workoutRestLabel => 'отдых';

  @override
  String get workoutReps => 'Повторения';

  @override
  String get workoutGetReady => 'приготовься';

  @override
  String get workoutSwitchSides => 'смени сторону';

  @override
  String get workoutPaused => 'пауза';

  @override
  String get workoutPause => 'Пауза';

  @override
  String get workoutPrepHint =>
      'Прочитай описание и прими позицию. Таймер запустится сам; нажми «Пауза», если нужно больше времени.';

  @override
  String get workoutPrepPausedHint =>
      'Пауза. Нажми «Продолжить», когда подготовишься: отсчёт пойдёт с того же места.';

  @override
  String get workoutSwitchSidesHint =>
      'Смени сторону. Таймер запустится сам; нажми «Пауза», если нужно больше времени.';

  @override
  String get workoutStop => 'Стоп';

  @override
  String get workoutDone => '✓  Готово';

  @override
  String get workoutSkipRest => 'Пропустить';

  @override
  String get workoutSetDone => '✅  Подход выполнен!';

  @override
  String get workoutExerciseDone => '✅  Упражнение выполнено!';

  @override
  String workoutAmountReps(int count) {
    return '$count повт.';
  }

  @override
  String workoutNextExercise(String name, String amount) {
    return 'Следующее: $name • $amount';
  }

  @override
  String workoutNextSet(int setNum, String amount) {
    return 'Следующий: подход $setNum • $amount';
  }

  @override
  String get summaryTitle => 'Отличная тренировка!';

  @override
  String get summarySubtitle => 'Так держать — ещё один шаг вперёд';

  @override
  String get summaryLabelTime => 'Время';

  @override
  String get summaryLabelExercises => 'Упр.';

  @override
  String get summaryHome => 'Домой';

  @override
  String get summaryFreezeUsedTitle => 'Заморозка сохранила стрик!';

  @override
  String get summaryFreezeUsedBody => 'Серия продолжается — так держать';

  @override
  String get summaryFreezeEarnedTitle => 'Получена заморозка стрика!';

  @override
  String get summaryFreezeEarnedBody => 'Используй, если пропустишь день';

  @override
  String get achievementsTitle => 'Достижения';

  @override
  String get achievementsEarnedSection => 'Получено';

  @override
  String get achievementsLockedSection => 'Заблокировано';

  @override
  String get achievementsSecret => '???';

  @override
  String get achievementsSecretDesc => 'Выполни особое условие, чтобы раскрыть';

  @override
  String achievementsEarnedOn(String date) {
    return 'Получено: $date';
  }

  @override
  String get profileAchievementsTitle => 'Достижения';

  @override
  String get profileAchievementsAll => 'Все достижения →';

  @override
  String get profileNoAchievements => 'Ещё нет достижений';

  @override
  String get summaryAchievementsTitle => 'Новые достижения!';

  @override
  String get achievementFirstWorkoutName => 'Первый шаг';

  @override
  String get achievementFirstWorkoutDesc =>
      'Ты сделал первую тренировку — начало положено!';

  @override
  String get achievementFirstChallengeName => 'Принял вызов';

  @override
  String get achievementFirstChallengeDesc =>
      'Первый пройденный Challenge — теперь ты знаешь, на что способен';

  @override
  String get achievementStreak3Name => 'Три в ряд';

  @override
  String get achievementStreak3Desc =>
      '3 дня подряд без пропусков — привычка начинает формироваться';

  @override
  String get achievementStreak7Name => 'Неделя без пропусков';

  @override
  String get achievementStreak7Desc => 'Целая неделя — ты уже выше большинства';

  @override
  String get achievementStreak30Name => 'Марафонец';

  @override
  String get achievementStreak30Desc =>
      '30 дней подряд — это настоящая дисциплина';

  @override
  String get achievementStreak100Name => 'Железная воля';

  @override
  String get achievementStreak100Desc =>
      '100 дней без пропусков — легендарное достижение';

  @override
  String get achievementWorkouts10Name => 'Десятка';

  @override
  String get achievementWorkouts10Desc =>
      '10 завершённых тренировок — твёрдый старт';

  @override
  String get achievementWorkouts50Name => 'Полсотни';

  @override
  String get achievementWorkouts50Desc =>
      '50 тренировок — ты серьёзно настроен';

  @override
  String get achievementWorkouts100Name => 'Центурион';

  @override
  String get achievementWorkouts100Desc => '100 тренировок — ты в элите';

  @override
  String get achievementRankAmateurName => 'Любитель';

  @override
  String get achievementRankAmateurDesc =>
      'Достигнут ранг Любитель — SP накапливаются';

  @override
  String get achievementRankSportsmanName => 'Спортсмен';

  @override
  String get achievementRankSportsmanDesc =>
      'Ранг Спортсмен — ты уже не просто любитель';

  @override
  String get achievementRankAthleteName => 'Атлет';

  @override
  String get achievementRankAthleteDesc => 'Ранг Атлет — серьёзный уровень';

  @override
  String get achievementRankMasterName => 'Мастер';

  @override
  String get achievementRankMasterDesc =>
      'Ранг Мастер — единицы добираются сюда';

  @override
  String get achievementRankLegendName => 'Легенда';

  @override
  String get achievementRankLegendDesc => 'Максимальный ранг. Ты — легенда.';

  @override
  String get achievementPushS3Name => 'Полное отжимание';

  @override
  String get achievementPushS3Desc => 'Освоены классические отжимания от пола';

  @override
  String get achievementPushS6Name => 'Лучник';

  @override
  String get achievementPushS6Desc =>
      'Освоил отжимания лучника — до стойки на руках рукой подать';

  @override
  String get achievementPushCompleteName => 'Властелин Push';

  @override
  String get achievementPushCompleteDesc =>
      'Все 7 этапов Push пройдены. Горо гордится.';

  @override
  String get achievementCoreS2Name => 'Железная доска';

  @override
  String get achievementCoreS2Desc => 'Планка освоена — основа всего кора';

  @override
  String get achievementCoreS5Name => 'Уголок';

  @override
  String get achievementCoreS5Desc => 'L-sit — истинная проверка силы пресса';

  @override
  String get achievementCoreCompleteName => 'Железный кор';

  @override
  String get achievementCoreCompleteDesc =>
      'Все 6 этапов Core пройдены. Твой кор — как сталь.';

  @override
  String get achievementPullS3Name => 'Первое подтягивание';

  @override
  String get achievementPullS3Desc =>
      'Подбородок выше перекладины — это победа';

  @override
  String get achievementPullCompleteName => 'Король перекладины';

  @override
  String get achievementPullCompleteDesc =>
      'Все 6 этапов Pull пройдены. Ты повелеваешь перекладиной.';

  @override
  String get achievementLegsS5Name => 'Пистолетик';

  @override
  String get achievementLegsS5Desc =>
      'Приседание на одной ноге — баланс и сила';

  @override
  String get achievementLegsCompleteName => 'Стальные ноги';

  @override
  String get achievementLegsCompleteDesc =>
      'Все 5 этапов Legs пройдены. Твои ноги из стали.';

  @override
  String get achievementBalanceS4Name => 'Поза ворона';

  @override
  String get achievementBalanceS4Desc =>
      'Kakasana держится — ты управляешь балансом';

  @override
  String get achievementBalanceS6Name => 'Свободная стойка';

  @override
  String get achievementBalanceS6Desc =>
      'Стойка на руках без стены — вершина баланса';

  @override
  String get achievementBalanceCompleteName => 'Мастер равновесия';

  @override
  String get achievementBalanceCompleteDesc =>
      'Все 6 этапов Balance пройдены. Ты — эквилибрист.';

  @override
  String get achievementFlexCompleteName => 'Мастер гибкости';

  @override
  String get achievementFlexCompleteDesc =>
      'Все 6 этапов Flex пройдены. Твоё тело гнётся во все стороны.';

  @override
  String get achievementEveningBackCompleteName => 'Мягкая спина';

  @override
  String get achievementEveningBackCompleteDesc =>
      'Все 5 этапов вечерней «Спины» пройдены. Позвоночник говорит спасибо.';

  @override
  String get achievementEveningHipsCompleteName => 'Свободные бёдра';

  @override
  String get achievementEveningHipsCompleteDesc =>
      'Все 5 этапов вечерних «Бёдер» пройдены. От коленей к груди до лягушки.';

  @override
  String get achievementEveningFoldsCompleteName => 'Глубокий наклон';

  @override
  String get achievementEveningFoldsCompleteDesc =>
      'Все 4 этапа вечерних «Наклонов» пройдены. До пола между ногами.';

  @override
  String get achievementEveningShouldersCompleteName => 'Свободные плечи';

  @override
  String get achievementEveningShouldersCompleteDesc =>
      'Все 5 этапов вечерних «Плеч» пройдены. Пальцы сцеплены за спиной.';

  @override
  String get achievementMorningSpineCompleteName => 'Мельница';

  @override
  String get achievementMorningSpineCompleteDesc =>
      'Все 5 этапов утреннего «Позвоночника» пройдены. От наклонов в стороны до мельницы.';

  @override
  String get achievementMorningJointsCompleteName => 'Как по маслу';

  @override
  String get achievementMorningJointsCompleteDesc =>
      'Все 5 этапов утренних «Суставов» пройдены. Вплоть до казачьего приседа.';

  @override
  String get achievementMorningArmsCompleteName => 'Руки нараспашку';

  @override
  String get achievementMorningArmsCompleteDesc =>
      'Все 5 этапов утренних «Рук» пройдены. От махов руками до «собаки» из планки.';

  @override
  String get achievementMorningEnergyCompleteName => 'Жаворонок';

  @override
  String get achievementMorningEnergyCompleteDesc =>
      'Все 5 этапов утренней «Бодрости» пройдены. Бодрость до первой чашки кофе.';

  @override
  String get achievementYogaStandingCompleteName => 'Воин';

  @override
  String get achievementYogaStandingCompleteDesc =>
      'Все 5 этапов йоговских «Стоек» пройдены. От стула до бокового угла.';

  @override
  String get achievementYogaOneLegCompleteName => 'Фламинго';

  @override
  String get achievementYogaOneLegCompleteDesc =>
      'Все 5 этапов «Равновесия» пройдены. От дерева до полумесяца.';

  @override
  String get achievementYogaBackbendsCompleteName => 'Радуга';

  @override
  String get achievementYogaBackbendsCompleteDesc =>
      'Все 6 этапов «Прогибов» пройдены. От сфинкса до колеса.';

  @override
  String get achievementYogaFlowCompleteName => 'Восход';

  @override
  String get achievementYogaFlowCompleteDesc =>
      'Все 5 этапов «Потока» пройдены. От собаки мордой вниз до приветствия солнцу B.';

  @override
  String get achievementAllCompleteName => 'Полный комплект';

  @override
  String get achievementAllCompleteDesc =>
      'Все 5 веток пройдены до конца. Абсолютный чемпион.';

  @override
  String get summaryBonusTitle => 'Бонусная тренировка';

  @override
  String get summaryBonusBody => '×½ SP · каждая ветка растёт раз в день';

  @override
  String summaryBonusCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count раза',
      many: '$count раз',
      few: '$count раза',
      one: '$count раз',
    );
    return 'Сегодня ты уже потренировался $_temp0!';
  }

  @override
  String get summaryChallengeUnlockedTitle => 'Испытание ждёт!';

  @override
  String get summaryChallengeUnlockedBody =>
      'Нажми «Принять вызов» на главном экране когда будешь готов';

  @override
  String get summaryChallengePassedTitle => 'Новый этап!';

  @override
  String summaryChallengePassedBody(String exercise) {
    return 'Ты перешёл на: $exercise';
  }

  @override
  String get profileTitle => 'Профиль';

  @override
  String get profileMaxRank => 'Максимальный ранг!';

  @override
  String profileRankProgress(int remaining, String rankName) {
    return '$remaining SP до $rankName';
  }

  @override
  String get profileStatDays => 'дней';

  @override
  String get profileStatRecord => 'рекорд';

  @override
  String get profileStatWorkouts => 'трен.';

  @override
  String get profileStatFreezes => 'заморозок';

  @override
  String get profileHistoryTitle => 'История тренировок';

  @override
  String get profileNoHistory => 'Ещё нет завершённых тренировок';

  @override
  String get calendarTitle => 'Календарь';

  @override
  String get calendarSeeAll => 'Открыть →';

  @override
  String get calendarFreezeUsedTitle => 'Заморозка стрика';

  @override
  String get calendarFreezeUsedBody =>
      'В этот день тренировки не было, но была использована заморозка — серия не прервалась.';

  @override
  String get calendarLegendOneWorkout => '1 тренировка';

  @override
  String get calendarLegendManyWorkouts => '2+ тренировки';

  @override
  String get calendarLegendFreeze => 'Заморозка';

  @override
  String get historyTypeDaily => 'Тренировка дня';

  @override
  String get historyTypeChallenge => 'Испытание';

  @override
  String get historyTypeBonus => 'Бонусная';

  @override
  String get historyDetailExercises => 'Упражнения';

  @override
  String historyDetailReps(int completed, int target) {
    return '$completed / $target повт.';
  }

  @override
  String historyDetailSec(int completed, int target) {
    return '$completed / $target сек';
  }

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get settingsSectionNotifications => 'УВЕДОМЛЕНИЯ';

  @override
  String get settingsSectionLanguage => 'ЯЗЫК';

  @override
  String get settingsNotificationsTitle => 'Включить уведомления';

  @override
  String get settingsNotificationsSubtitle =>
      'Разрешить приложению присылать напоминания';

  @override
  String get settingsNotificationTimeTitle => 'Время напоминания';

  @override
  String get settingsNotificationTimeSubtitle =>
      'Утреннее напоминание потренироваться';

  @override
  String get settingsTimePickerDone => 'Готово';

  @override
  String get settingsEveningReminderTitle => 'Вечерний дожим';

  @override
  String get settingsEveningReminderSubtitle =>
      'Напомнить вечером, если тренировка не выполнена';

  @override
  String get settingsStreakThreatTitle => 'Угроза стрику';

  @override
  String get settingsStreakThreatSubtitle =>
      'Предупредить, когда серия под угрозой';

  @override
  String get settingsLanguageTitle => 'Язык приложения';

  @override
  String get settingsSectionTheme => 'ТЕМА';

  @override
  String get settingsThemeSystem => 'Системная';

  @override
  String get settingsThemeLight => 'Светлая';

  @override
  String get settingsThemeDark => 'Тёмная';

  @override
  String get settingsSectionEquipment => 'ОБОРУДОВАНИЕ';

  @override
  String get settingsEquipmentPullUpBar => 'Турник дома';

  @override
  String get settingsEquipmentPullUpBarSubtitle =>
      'Открывает ветку прогрессии «Тяга»';

  @override
  String get settingsSectionWorkout => 'ТРЕНИРОВКА';

  @override
  String get settingsSoundTitle => 'Звуки';

  @override
  String get settingsSoundSubtitle =>
      'Звуки обратной связи во время тренировки';

  @override
  String get settingsHapticTitle => 'Вибрация';

  @override
  String get settingsHapticSubtitle => 'Тактильные сигналы во время тренировки';

  @override
  String get rankBeginner => 'Новичок';

  @override
  String get rankAmateur => 'Любитель';

  @override
  String get rankSportsman => 'Спортсмен';

  @override
  String get rankAthlete => 'Атлет';

  @override
  String get rankMaster => 'Мастер';

  @override
  String get rankLegend => 'Легенда';

  @override
  String get onboardingWelcomeTitle => 'Привет! Я Горо';

  @override
  String get onboardingWelcomeBody =>
      'Короткие сеты, прокачка навыков, стрики и очки.\nОт отжиманий с колен до стойки на руках — шаг за шагом.';

  @override
  String get onboardingWelcomeCta => 'Настроим всё под тебя за 1 минуту';

  @override
  String get onboardingContinue => 'Продолжить';

  @override
  String get onboardingStart => 'Начать тренировку 🔥';

  @override
  String get onboardingQ1 => 'Как тебя зовут?';

  @override
  String get onboardingQ1Hint => 'Твоё имя (необязательно)';

  @override
  String get onboardingQ1Body => 'Горо будет обращаться к тебе по имени';

  @override
  String get onboardingQ2 => 'Сколько отжиманий ты можешь сделать?';

  @override
  String get onboardingQ3 => 'Какого размера должна быть тренировка?';

  @override
  String get workoutSizeShort => 'Короткая';

  @override
  String get workoutSizeStandard => 'Стандартная';

  @override
  String get workoutSizeFull => 'Полная';

  @override
  String get workoutSizeShortDesc => '2 навыка';

  @override
  String get workoutSizeStandardDesc => '3 навыка';

  @override
  String get workoutSizeFullDesc => 'Все навыки';

  @override
  String get settingsWorkoutSizeTitle => 'Размер тренировки';

  @override
  String get settingsWorkoutSizeSubtitle =>
      'Сколько навыков тренировать в ежедневной тренировке';

  @override
  String get onboardingQ5 => 'Есть ли у тебя турник или кольца дома?';

  @override
  String get onboardingEquipmentYes => 'Да, есть';

  @override
  String get onboardingEquipmentNo => 'Нет';

  @override
  String get onboardingQ6Health => 'Синхронизация с Health';

  @override
  String get onboardingHealthBody =>
      'CaliDay может автоматически сохранять тренировки в Apple Health (iOS) или Health Connect (Android).';

  @override
  String get onboardingHealthEnable => 'Включить';

  @override
  String get onboardingHealthEnableDesc =>
      'Тренировки будут сохраняться автоматически';

  @override
  String get onboardingHealthSkip => 'Пропустить';

  @override
  String get onboardingHealthSkipDesc => 'Можно включить позже в Настройках';

  @override
  String get onboardingQ7 => 'Во сколько напомнить о тренировке?';

  @override
  String get pushupZeroDesc => 'Пока ни одного';

  @override
  String get pushupOneToFiveDesc => 'Совсем немного';

  @override
  String get pushupFiveToFifteenDesc => 'Уже неплохо';

  @override
  String get pushupMoreThan15Desc => 'Отличная база';

  @override
  String get timeOfDayMorning => 'Утро';

  @override
  String get timeOfDayDay => 'День';

  @override
  String get timeOfDayLunch => 'Обед';

  @override
  String get timeOfDayEvening => 'Вечер';

  @override
  String get exercisePushS1WallPushupName => 'Отжимания от стены';

  @override
  String get exercisePushS1WallPushupDesc =>
      'Встань на расстоянии шага от стены, упрись ладонями на уровне груди. Сгибай руки, пока грудь не коснётся стены, затем выпрямляй.';

  @override
  String get exercisePushS1WallPushupTip =>
      'Держи тело прямым, не прогибай поясницу.';

  @override
  String get exercisePushS2KneePushupName => 'Отжимания с колен';

  @override
  String get exercisePushS2KneePushupDesc =>
      'Упор лёжа с опорой на колени. Тело от колен до головы — прямая линия. Опускайся грудью к полу, затем выжимай.';

  @override
  String get exercisePushS2KneePushupTip =>
      'Не опускай бёдра — держи прямую линию от колен до плеч.';

  @override
  String get exercisePushS3FullPushupName => 'Полные отжимания';

  @override
  String get exercisePushS3FullPushupDesc =>
      'Классический упор лёжа. Тело — прямая линия от пяток до головы. Грудь касается пола или подходит на 2–3 см.';

  @override
  String get exercisePushS3FullPushupTip =>
      'Напрягай пресс и ягодицы, чтобы не провисали бёдра.';

  @override
  String get exercisePushS4DiamondPushupName => 'Алмазные отжимания';

  @override
  String get exercisePushS4DiamondPushupDesc =>
      'Руки под грудью, большие и указательные пальцы образуют ромб. Акцент на трицепс. Локти прижаты к корпусу при опускании.';

  @override
  String get exercisePushS4DiamondPushupTip =>
      'Локти не разводи — они должны скользить вдоль тела.';

  @override
  String get exercisePushS5WidePushupName => 'Широкие отжимания';

  @override
  String get exercisePushS5WidePushupDesc =>
      'Руки значительно шире плеч. Опускайся медленно, сохраняя прямую линию тела. Оба трицепса и грудь работают в широкой амплитуде.';

  @override
  String get exercisePushS5WidePushupTip =>
      'Чем шире руки — тем больше нагрузка на грудь и меньше на трицепс.';

  @override
  String get exercisePushS6ArcherPushupName => 'Отжимания лучника';

  @override
  String get exercisePushS6ArcherPushupDesc =>
      'Широкая постановка рук. Опускайся в сторону одной руки, держа вторую прямой. Поочерёдно на каждую сторону.';

  @override
  String get exercisePushS6ArcherPushupTip =>
      'Рабочая рука — полный диапазон, прямая рука на полу — поддержка.';

  @override
  String get exercisePushS7HandstandPushupName => 'Отжимания в стойке на руках';

  @override
  String get exercisePushS7HandstandPushupDesc =>
      'Стойка на руках у стены (спиной). Медленно опускай голову к полу, затем выжимай корпус вверх.';

  @override
  String get exercisePushS7HandstandPushupTip =>
      'Пальцы широко расставлены — так стабильнее. Взгляд между рук.';

  @override
  String get exerciseCoreS1CrunchesName => 'Скручивания';

  @override
  String get exerciseCoreS1CrunchesDesc =>
      'Лёжа на спине, колени согнуты. Руки за головой или скрещены на груди. Отрывай лопатки от пола, сокращая пресс.';

  @override
  String get exerciseCoreS1CrunchesTip =>
      'Не тяни шею руками — тяни грудью к потолку.';

  @override
  String get exerciseCoreS2PlankName => 'Планка';

  @override
  String get exerciseCoreS2PlankDesc =>
      'Упор лёжа на предплечьях. Тело — прямая линия от пяток до головы. Не поднимай таз и не прогибай поясницу.';

  @override
  String get exerciseCoreS2PlankTip =>
      'Напрягай пресс и ягодицы. Дыши ровно — не задерживай.';

  @override
  String get exerciseCoreS3LyingLegRaiseName => 'Подъёмы ног лёжа';

  @override
  String get exerciseCoreS3LyingLegRaiseDesc =>
      'Лёжа на спине, руки под ягодицами. Прямые ноги поднимай до вертикали, затем медленно опускай не касаясь пола.';

  @override
  String get exerciseCoreS3LyingLegRaiseTip =>
      'Поясница прижата к полу на протяжении всего движения.';

  @override
  String get exerciseCoreS4HangingLegRaiseName => 'Подъёмы ног в висе';

  @override
  String get exerciseCoreS4HangingLegRaiseDesc =>
      'Повис на перекладине. Поднимай прямые ноги до параллели с полом или выше. Контролируй опускание.';

  @override
  String get exerciseCoreS4HangingLegRaiseTip =>
      'Не раскачивайся — движение только за счёт пресса.';

  @override
  String get exerciseCoreS4FlutterKicksName => 'Ножницы';

  @override
  String get exerciseCoreS4FlutterKicksDesc =>
      'Лёжа на спине, руки под ягодицами. Подними ноги на 15–20 см от пола. Поочерёдно поднимай и опускай каждую ногу быстрыми небольшими движениями. Одно повторение — один цикл (правая вверх + левая вверх).';

  @override
  String get exerciseCoreS4FlutterKicksTip =>
      'Поясница прижата к полу. Ноги не касаются пола между повторами.';

  @override
  String get exerciseCoreS5LSitName => 'Уголок (L-sit)';

  @override
  String get exerciseCoreS5LSitDesc =>
      'Упор на параллельных брусьях или полу. Ноги прямые, параллельны полу. Удерживай позицию как можно дольше.';

  @override
  String get exerciseCoreS5LSitTip =>
      'Носки тяни на себя, плечи — вниз и назад.';

  @override
  String get exerciseCoreS6DragonFlagName => 'Драконовый флаг';

  @override
  String get exerciseCoreS6DragonFlagDesc =>
      'Лёжа на скамье, держись за опору за головой. Подними тело в прямую линию на лопатках, затем медленно опускай.';

  @override
  String get exerciseCoreS6DragonFlagTip =>
      'Начинай с негативной фазы (только опускание) — это проще.';

  @override
  String get exerciseWarmupArmRotationsName => 'Круговые вращения руками';

  @override
  String get exerciseWarmupArmRotationsDesc =>
      'Стоя, делай большие круговые движения руками вперёд и назад. Разминает плечевой пояс перед отжиманиями.';

  @override
  String get exerciseWarmupJumpingJacksName => 'Прыжки «Ноги вместе — врозь»';

  @override
  String get exerciseWarmupJumpingJacksDesc =>
      'Классические jumping jacks. Повышают пульс и разогревают всё тело за 30–60 секунд.';

  @override
  String get exerciseCooldownShoulderStretchName => 'Растяжка плеч и груди';

  @override
  String get exerciseCooldownShoulderStretchDesc =>
      'Заведи руки за спину, сцепи пальцы и потяни плечи назад-вниз. Удержи 30 секунд.';

  @override
  String get exerciseCooldownCatCowName => 'Кошка-корова';

  @override
  String get exerciseCooldownCatCowDesc =>
      'На четвереньках: на вдохе прогибай спину вниз (корова), на выдохе округляй вверх (кошка). Расслабляет поясницу и пресс.';

  @override
  String get exercisePullS1AustralianName => 'Австралийское подтягивание';

  @override
  String get exercisePullS1AustralianDesc =>
      'Лёжа под перекладиной, хват чуть шире плеч. Тяни грудь к перекладине, держа тело прямой линией. Контролируй опускание.';

  @override
  String get exercisePullS1AustralianTip =>
      'Чем ниже опускаешь перекладину, тем сложнее упражнение.';

  @override
  String get exercisePullS2NegativeName => 'Негативные подтягивания';

  @override
  String get exercisePullS2NegativeDesc =>
      'Запрыгни на перекладину с подбородком выше неё. Медленно опускайся в течение 3–5 секунд до полного выпрямления рук.';

  @override
  String get exercisePullS2NegativeTip =>
      'Чем медленнее опускаешься — тем лучше. Цель: 5 сек вниз.';

  @override
  String get exercisePullS3PullupName => 'Подтягивания';

  @override
  String get exercisePullS3PullupDesc =>
      'Хват на ширине плеч или чуть шире. Тяни грудь к перекладине, пока подбородок не окажется выше неё. Полностью выпрямляй руки внизу.';

  @override
  String get exercisePullS3PullupTip =>
      'Сводя лопатки — тянешь спиной, а не руками.';

  @override
  String get exercisePullS4CloseGripName => 'Подтягивания узким хватом';

  @override
  String get exercisePullS4CloseGripDesc =>
      'Хват уже плеч, ладони к себе или от себя. Акцент на бицепс и нижнюю часть широчайших. Подтягивай грудь к перекладине.';

  @override
  String get exercisePullS4CloseGripTip =>
      'Локти прижимай к корпусу для максимальной нагрузки на бицепс.';

  @override
  String get exercisePullS5ArcherName => 'Подтягивания лучника';

  @override
  String get exercisePullS5ArcherDesc =>
      'Широкий хват. Тяни тело в сторону одной руки, вторую держи прямой. Поочерёдно на каждую сторону.';

  @override
  String get exercisePullS5ArcherTip =>
      'Прямая рука — вспомогательная, рабочая — полный диапазон.';

  @override
  String get exercisePullS6OneArmName => 'Подтягивание на одной руке';

  @override
  String get exercisePullS6OneArmDesc =>
      'Одна рука держит перекладину, вторая — на запястье или свободна. Полный диапазон движения рабочей рукой.';

  @override
  String get exercisePullS6OneArmTip =>
      'Держи корпус стабильным — не раскачивайся.';

  @override
  String get exerciseWarmupDeadHangName => 'Вис на перекладине';

  @override
  String get exerciseWarmupDeadHangDesc =>
      'Повисни на перекладине прямым хватом, руки полностью выпрямлены. Расслабь плечи и удержи вис.';

  @override
  String get exerciseCooldownLatStretchName => 'Растяжка широчайших';

  @override
  String get exerciseCooldownLatStretchDesc =>
      'Встань боком к стене, подними руку вверх и упрись в стену. Наклонись в сторону, чувствуя растяжку сбоку.';

  @override
  String get exerciseLegsS1SquatName => 'Приседания';

  @override
  String get exerciseLegsS1SquatDesc =>
      'Ноги на ширине плеч, носки чуть развёрнуты. Приседай до параллели бёдер с полом, колени над носками. Выпрямляй ноги в верхней точке.';

  @override
  String get exerciseLegsS1SquatTip =>
      'Пятки не отрывай от пола, грудь держи прямо.';

  @override
  String get exerciseLegsS2LungeName => 'Выпады';

  @override
  String get exerciseLegsS2LungeDesc =>
      'Шаг вперёд, опусти заднее колено к полу, не касаясь. Оба колена под углом 90°. Оттолкнись передней ногой и вернись в исходное.';

  @override
  String get exerciseLegsS2LungeTip => 'Переднее колено не уходи за носок.';

  @override
  String get exerciseLegsS3BulgarianName => 'Болгарские сплит-приседания';

  @override
  String get exerciseLegsS3BulgarianDesc =>
      'Задняя нога на возвышении (стул, диван). Опускай переднюю ногу до параллели бедра с полом. Торс прямой.';

  @override
  String get exerciseLegsS3BulgarianTip =>
      'Чем дальше передняя нога — тем больше нагрузка на ягодицы.';

  @override
  String get exerciseLegsS4AssistedPistolName => 'Пистолетик с опорой';

  @override
  String get exerciseLegsS4AssistedPistolDesc =>
      'Держись за дверной косяк или стойку. Приседай на одной ноге, вторую держи прямой перед собой. Опора снижает нагрузку.';

  @override
  String get exerciseLegsS4AssistedPistolTip =>
      'Постепенно уменьшай помощь рук по мере роста силы.';

  @override
  String get exerciseLegsS5PistolName => 'Пистолетик';

  @override
  String get exerciseLegsS5PistolDesc =>
      'Приседание на одной ноге без опоры. Вторая нога прямая перед собой. Полная амплитуда до пола и обратно.';

  @override
  String get exerciseLegsS5PistolTip =>
      'Руки вперёд для противовеса — помогает с балансом.';

  @override
  String get exerciseWarmupLegSwingsName => 'Махи ногами';

  @override
  String get exerciseWarmupLegSwingsDesc =>
      'Стоя у стены, делай маховые движения прямой ногой вперёд-назад и в стороны. Разминает тазобедренный сустав.';

  @override
  String get exerciseCooldownQuadStretchName => 'Растяжка квадрицепса';

  @override
  String get exerciseCooldownQuadStretchDesc =>
      'Стоя на одной ноге, согни вторую назад и удержи стопу рукой. Почувствуй растяжку передней поверхности бедра.';

  @override
  String get exerciseWarmupHipCirclesName => 'Вращения тазом';

  @override
  String get exerciseWarmupHipCirclesDesc =>
      'Стоя, ноги на ширине плеч. Делай медленные круговые движения тазом по часовой и против часовой стрелки. Разогревает тазобедренный сустав.';

  @override
  String get exerciseCooldownHipFlexorName => 'Растяжка сгибателей бедра';

  @override
  String get exerciseCooldownHipFlexorDesc =>
      'Встань в выпад, опусти заднее колено на пол. Выдвинь таз вперёд-вниз, почувствуй растяжку в паху. Удержи каждую сторону.';

  @override
  String get exerciseBalS1OneLegStandName => 'Стойка на одной ноге';

  @override
  String get exerciseBalS1OneLegStandDesc =>
      'Стой на одной ноге, вторую слегка согни и удержи в воздухе. Руки можно держать в стороны для баланса.';

  @override
  String get exerciseBalS1OneLegStandTip =>
      'Фиксируй взгляд на точке — это сильно улучшает баланс.';

  @override
  String get exerciseBalS2OneArmPlankName => 'Планка на одной руке';

  @override
  String get exerciseBalS2OneArmPlankDesc =>
      'Классическая планка на вытянутых руках. Оторви одну руку от пола и удержи позицию, тело параллельно полу.';

  @override
  String get exerciseBalS2OneArmPlankTip =>
      'Бёдра держи параллельно полу — не разворачивай корпус.';

  @override
  String get exerciseBalS3CrowPrepName => 'Подготовка к позе ворона';

  @override
  String get exerciseBalS3CrowPrepDesc =>
      'Присядь, колени на трицепсах. Перенеси вес на руки, слегка отрывая ноги. Удержи баланс на руках.';

  @override
  String get exerciseBalS3CrowPrepTip =>
      'Взгляд вперёд-вниз, не прямо вниз — иначе упадёшь.';

  @override
  String get exerciseBalS4CrowPoseName => 'Поза ворона (Kakasana)';

  @override
  String get exerciseBalS4CrowPoseDesc =>
      'Оба колена на трицепсах, полный баланс на руках. Руки слегка согнуты, пальцы широко расставлены.';

  @override
  String get exerciseBalS4CrowPoseTip =>
      'Округли спину — это активирует корпус и даёт баланс.';

  @override
  String get exerciseBalS5WallHsName => 'Стойка на руках у стены';

  @override
  String get exerciseBalS5WallHsDesc =>
      'Встань на руки спиной к стене. Пятки касаются стены для опоры. Удержи стойку, тело вытянуто в линию.';

  @override
  String get exerciseBalS5WallHsTip =>
      'Пальцы широко, надавливай на подушечки — это баланс.';

  @override
  String get exerciseBalS6FreeHsName => 'Свободная стойка на руках';

  @override
  String get exerciseBalS6FreeHsDesc =>
      'Стойка на руках без опоры. Контролируй баланс мелкими движениями пальцев и запястий.';

  @override
  String get exerciseBalS6FreeHsTip =>
      'Смотри в пол на 30–40 см перед руками, не между руками.';

  @override
  String get exerciseWarmupWristCirclesName => 'Круговые вращения запястьями';

  @override
  String get exerciseWarmupWristCirclesDesc =>
      'Вращай запястьями по часовой и против часовой стрелки. Подготавливает суставы к нагрузке на руках.';

  @override
  String get exerciseCooldownDownwardDogName => 'Собака мордой вниз';

  @override
  String get exerciseCooldownDownwardDogDesc =>
      'На четвереньках выпрями руки и ноги, подними таз вверх. Тело — перевёрнутая V. Растяжка запястий, плеч и ног.';

  @override
  String get exerciseEveningBackS1CatCowName => 'Кошка-корова';

  @override
  String get exerciseEveningBackS1CatCowDesc =>
      'На четвереньках: ладони под плечами, колени под тазом. На вдохе прогни спину и подними грудь, на выдохе округли спину к потолку. Двигайся медленно, в ритме дыхания.';

  @override
  String get exerciseEveningBackS1CatCowTip =>
      'Пусть ведёт дыхание: один медленный вдох и выдох на повтор.';

  @override
  String get exerciseEveningBackS2ChildsPoseName => 'Поза ребёнка';

  @override
  String get exerciseEveningBackS2ChildsPoseDesc =>
      'Встань на колени, большие пальцы ног вместе, колени врозь. Сядь на пятки и опусти грудь между коленями, руки вытянуты вперёд, лоб на полу. Дыши в спину.';

  @override
  String get exerciseEveningBackS2ChildsPoseTip =>
      'С каждым выдохом таз опускается к пяткам.';

  @override
  String get exerciseEveningBackS3SupineTwistName => 'Скручивание лёжа';

  @override
  String get exerciseEveningBackS3SupineTwistDesc =>
      'Лёжа на спине, руки в стороны. Согни одно колено и опусти его через корпус на пол, взгляд в другую сторону. Оба плеча остаются на полу.';

  @override
  String get exerciseEveningBackS3SupineTwistTip =>
      'Не дави на колено — его опускает вес ноги.';

  @override
  String get exerciseEveningBackS4SphinxName => 'Сфинкс';

  @override
  String get exerciseEveningBackS4SphinxDesc =>
      'Лёжа на животе, локти под плечами, предплечья на полу. Подними грудь; таз и ноги расслаблены на полу.';

  @override
  String get exerciseEveningBackS4SphinxTip =>
      'Отводи плечи от ушей; прогиб мягкий, без зажима в пояснице.';

  @override
  String get exerciseEveningBackS5CobraName => 'Кобра';

  @override
  String get exerciseEveningBackS5CobraDesc =>
      'Лёжа на животе, ладони под плечами. Выпрямляй руки настолько, насколько позволяет поясница; таз остаётся на полу.';

  @override
  String get exerciseEveningBackS5CobraTip =>
      'Локти чуть согнуты, плечи вниз; останавливайся там, где спине хорошо.';

  @override
  String get exerciseEveningHipsS1KneesToChestName => 'Колени к груди';

  @override
  String get exerciseEveningHipsS1KneesToChestDesc =>
      'Лёжа на спине, обними оба колена, притяни их к груди и удерживай. Можно мягко покачиваться из стороны в сторону.';

  @override
  String get exerciseEveningHipsS1KneesToChestTip =>
      'Поясница и голова остаются на полу.';

  @override
  String get exerciseEveningHipsS2FigureFourName => '«Четвёрка» лёжа';

  @override
  String get exerciseEveningHipsS2FigureFourDesc =>
      'Лёжа на спине, колени согнуты. Положи лодыжку одной ноги на колено другой и притяни бедро нижней ноги к груди, пока не почувствуешь растяжение в ягодице.';

  @override
  String get exerciseEveningHipsS2FigureFourTip =>
      'Мягко отводи колено скрещённой ноги от себя — растяжка станет глубже.';

  @override
  String get exerciseEveningHipsS3HappyBabyName => 'Счастливый ребёнок';

  @override
  String get exerciseEveningHipsS3HappyBabyDesc =>
      'Лёжа на спине, подтяни колени к подмышкам и возьмись за внешние края стоп, подошвы смотрят в потолок. Мягко тяни колени к полу.';

  @override
  String get exerciseEveningHipsS3HappyBabyTip =>
      'Копчик прижат к полу; покачиваться можно.';

  @override
  String get exerciseEveningHipsS4ButterflyName => 'Бабочка';

  @override
  String get exerciseEveningHipsS4ButterflyDesc =>
      'Сядь ровно, соедини стопы, колени в стороны. Держись за стопы и позволь коленям опускаться к полу.';

  @override
  String get exerciseEveningHipsS4ButterflyTip =>
      'Спина прямая; чтобы углубить, наклоняйся вперёд от таза.';

  @override
  String get exerciseEveningHipsS5FrogName => 'Лягушка';

  @override
  String get exerciseEveningHipsS5FrogDesc =>
      'На четвереньках широко разведи колени, лодыжки на одной линии с коленями, стопы развёрнуты наружу. Опустись на предплечья и мягко отведи таз назад.';

  @override
  String get exerciseEveningHipsS5FrogTip =>
      'Разводи колени только до ощущения растяжки, без боли в коленях.';

  @override
  String get exerciseEveningFoldsS1LegsUpWallName => 'Ноги на стену';

  @override
  String get exerciseEveningFoldsS1LegsUpWallDesc =>
      'Ляг на спину, таз близко к стене, прямые ноги подняты вдоль неё. Руки расслаблены вдоль тела, дыши медленно.';

  @override
  String get exerciseEveningFoldsS1LegsUpWallTip =>
      'Если задняя поверхность ног тянет слишком сильно, чуть согни колени.';

  @override
  String get exerciseEveningFoldsS2TowelHamstringName =>
      'Растяжка лёжа с полотенцем';

  @override
  String get exerciseEveningFoldsS2TowelHamstringDesc =>
      'Лёжа на спине, накинь полотенце на стопу и подними эту ногу как можно прямее. Другая нога остаётся на полу.';

  @override
  String get exerciseEveningFoldsS2TowelHamstringTip =>
      'Тяни полотенцем, а не спиной — таз прижат к полу.';

  @override
  String get exerciseEveningFoldsS3HeadToKneeName => 'Наклон к одной ноге';

  @override
  String get exerciseEveningFoldsS3HeadToKneeDesc =>
      'Сядь: одна нога прямая, стопа другой упирается во внутреннюю сторону её бедра. Наклонись вперёд над прямой ногой, тянись к стопе.';

  @override
  String get exerciseEveningFoldsS3HeadToKneeTip =>
      'Тянись грудью, а не головой; колено прямой ноги можно чуть согнуть.';

  @override
  String get exerciseEveningFoldsS4StraddleFoldName => 'Наклон в широком седе';

  @override
  String get exerciseEveningFoldsS4StraddleFoldDesc =>
      'Сядь, широко разведя ноги, колени смотрят вверх. Переступай руками вперёд и опускай корпус к полу между ногами.';

  @override
  String get exerciseEveningFoldsS4StraddleFoldTip =>
      'Наклоняйся от таза с длинной спиной: круглая спина ничего не добавляет.';

  @override
  String get exerciseEveningShouldersS1SelfHugName => 'Объятия';

  @override
  String get exerciseEveningShouldersS1SelfHugDesc =>
      'Сидя или стоя, обхвати себя руками и возьмись за лопатки. Дай верхней части спины округлиться и дыши в неё.';

  @override
  String get exerciseEveningShouldersS1SelfHugTip =>
      'Расслабь шею, подбородок чуть опущен.';

  @override
  String get exerciseEveningShouldersS2TricepsStretchName =>
      'Растяжка трицепса за головой';

  @override
  String get exerciseEveningShouldersS2TricepsStretchDesc =>
      'Подними одну руку, согни локоть и опусти ладонь за шею. Другой рукой мягко отводи локоть назад.';

  @override
  String get exerciseEveningShouldersS2TricepsStretchTip =>
      'Голова прямо, рёбра не выпячивай.';

  @override
  String get exerciseEveningShouldersS3EagleArmsName => 'Руки «орёл»';

  @override
  String get exerciseEveningShouldersS3EagleArmsDesc =>
      'Скрести руки в локтях, одну под другой, согни их и соедини ладони. Подними локти до уровня плеч.';

  @override
  String get exerciseEveningShouldersS3EagleArmsTip =>
      'Если ладони не сходятся, соедини тыльные стороны кистей.';

  @override
  String get exerciseEveningShouldersS4PuppyPoseName => 'Щенок';

  @override
  String get exerciseEveningShouldersS4PuppyPoseDesc =>
      'На четвереньках переступай руками вперёд и опускай грудь к полу; таз над коленями, руки прямые.';

  @override
  String get exerciseEveningShouldersS4PuppyPoseTip =>
      'Положи лоб на пол и дай груди опуститься.';

  @override
  String get exerciseEveningShouldersS5CowFaceArmsName => 'Руки «корова»';

  @override
  String get exerciseEveningShouldersS5CowFaceArmsDesc =>
      'Заведи одну руку сверху за шею, другую снизу за спину и попробуй сцепить пальцы. Если не достают, возьми между руками полотенце.';

  @override
  String get exerciseEveningShouldersS5CowFaceArmsTip =>
      'Верхний локоть смотрит вверх, спина прямая.';

  @override
  String get exerciseCooldownLyingRelaxationName => 'Расслабление лёжа';

  @override
  String get exerciseCooldownLyingRelaxationDesc =>
      'Ляг на спину, руки вдоль тела, ладони вверх. Закрой глаза и дыши медленно; позволь всему телу стать тяжёлым.';

  @override
  String get exerciseCooldownLyingRelaxationTip => 'Выдох длиннее вдоха.';

  @override
  String get exerciseMorningSpineS1SideBendName => 'Наклоны в стороны';

  @override
  String get exerciseMorningSpineS1SideBendDesc =>
      'Стопы на ширине таза. Подними одну руку над головой и наклонись в другую сторону, вторая рука скользит по бедру. Вернись и смени сторону. Каждая сторона — один повтор.';

  @override
  String get exerciseMorningSpineS1SideBendTip =>
      'Наклоняйся строго вбок, а не вперёд; таз неподвижен.';

  @override
  String get exerciseMorningSpineS2TorsoTwistName => 'Повороты корпуса';

  @override
  String get exerciseMorningSpineS2TorsoTwistDesc =>
      'Стопы чуть шире таза, колени мягкие, руки расслаблены. Поворачивай верх тела из стороны в сторону, руки свободно обвивают корпус. Таз смотрит вперёд. Каждая сторона — один повтор.';

  @override
  String get exerciseMorningSpineS2TorsoTwistTip =>
      'Руки следуют за поворотом, не бросай их.';

  @override
  String get exerciseMorningSpineS3GoodMorningName => 'Наклон «Доброе утро»';

  @override
  String get exerciseMorningSpineS3GoodMorningDesc =>
      'Стопы на ширине таза, руки за головой. Отведи таз назад и наклонись вперёд с прямой спиной, пока не почувствуешь заднюю поверхность бёдер, затем выпрямись.';

  @override
  String get exerciseMorningSpineS3GoodMorningTip =>
      'Сгибайся в тазобедренных суставах, а не в пояснице: спина прямая всё время.';

  @override
  String get exerciseMorningSpineS4RollDownName => 'Скручивание вниз';

  @override
  String get exerciseMorningSpineS4RollDownDesc =>
      'Встань прямо. Опусти подбородок к груди и медленно скручивайся вниз, позвонок за позвонком; руки свисают к полу. Так же медленно поднимайся, голова — последней.';

  @override
  String get exerciseMorningSpineS4RollDownTip =>
      'Сгибай колени сколько нужно: цель — позвоночник, а не коснуться пола.';

  @override
  String get exerciseMorningSpineS5WindmillName => 'Мельница';

  @override
  String get exerciseMorningSpineS5WindmillDesc =>
      'Ноги широко, руки в стороны. Наклонись с поворотом: одна рука тянется к противоположной стопе, другая смотрит в потолок. Вернись в букву «Т» и смени сторону. Каждая сторона — один повтор.';

  @override
  String get exerciseMorningSpineS5WindmillTip =>
      'Руки держи на одной прямой, как крылья мельницы.';

  @override
  String get exerciseMorningJointsS1KneeCirclesName => 'Круги коленями';

  @override
  String get exerciseMorningJointsS1KneeCirclesDesc =>
      'Стопы вместе, колени слегка согнуты, ладони чуть выше колен. Рисуй коленями медленные круги: половину в одну сторону, половину в другую.';

  @override
  String get exerciseMorningJointsS1KneeCirclesTip =>
      'Круги небольшие и плавные, пятки на полу.';

  @override
  String get exerciseMorningJointsS2OpenTheGateName => 'Открыть ворота';

  @override
  String get exerciseMorningJointsS2OpenTheGateDesc =>
      'Встань прямо. Подними колено перед собой до уровня таза, отведи его в сторону и опусти стопу. Смени ногу. Каждая сторона — один повтор.';

  @override
  String get exerciseMorningJointsS2OpenTheGateTip =>
      'Если шатает, держись за стену или стул; грудь поднята.';

  @override
  String get exerciseMorningJointsS3KneeHugName => 'Колено к груди стоя';

  @override
  String get exerciseMorningJointsS3KneeHugDesc =>
      'Встань прямо. Подтяни колено к груди обеими руками и поднимись на носок опорной ноги. Опусти ногу и смени её. Каждая сторона — один повтор.';

  @override
  String get exerciseMorningJointsS3KneeHugTip =>
      'Поднимайся медленно и смотри в одну точку перед собой — так легче держать равновесие.';

  @override
  String get exerciseMorningJointsS4SideLungeName => 'Боковой выпад';

  @override
  String get exerciseMorningJointsS4SideLungeDesc =>
      'Стопы вместе. Сделай широкий шаг в сторону и сядь в это бедро, другая нога прямая, обе стопы на полу. Оттолкнись обратно и смени сторону. Каждая сторона — один повтор.';

  @override
  String get exerciseMorningJointsS4SideLungeTip =>
      'Согнутое колено смотрит туда же, куда носок.';

  @override
  String get exerciseMorningJointsS5CossackSquatName => 'Казачий присед';

  @override
  String get exerciseMorningJointsS5CossackSquatDesc =>
      'Ноги очень широко. Опустись глубоко на одну ногу, другая прямая, носок смотрит вверх. Перейди через середину на другую сторону. Каждая сторона — один повтор.';

  @override
  String get exerciseMorningJointsS5CossackSquatTip =>
      'Пятка согнутой ноги на полу; руки вперёд для равновесия.';

  @override
  String get exerciseMorningArmsS1ArmSwingsName => 'Махи руками';

  @override
  String get exerciseMorningArmsS1ArmSwingsDesc =>
      'Встань прямо. Широко разведи руки в стороны, затем махом обними себя, каждый раз меняя, какая рука сверху. Движение свободное и лёгкое.';

  @override
  String get exerciseMorningArmsS1ArmSwingsTip =>
      'В крайней точке раскрывай грудь и делай вдох.';

  @override
  String get exerciseMorningArmsS2YRaisesName => 'Y-подъёмы';

  @override
  String get exerciseMorningArmsS2YRaisesDesc =>
      'Колени мягкие, наклонись вперёд от таза с прямой спиной. Большие пальцы вверх: подними прямые руки вперёд-вверх буквой Y, сведи лопатки, опусти.';

  @override
  String get exerciseMorningArmsS2YRaisesTip =>
      'Поднимай лопатками, а не прогибом в пояснице.';

  @override
  String get exerciseMorningArmsS3CactusArmsName => 'Кактус';

  @override
  String get exerciseMorningArmsS3CactusArmsDesc =>
      'Подними руки в стороны: локти на уровне плеч и согнуты под 90°, предплечья смотрят вверх, как у кактуса. Не сдвигая локти, поверни предплечья вперёд и вниз, пока они не укажут в пол, затем верни вверх и сведи лопатки.';

  @override
  String get exerciseMorningArmsS3CactusArmsTip =>
      'Двигайся медленно: ходят только предплечья, локти остаются на уровне плеч.';

  @override
  String get exerciseMorningArmsS4InchwormName => 'Гусеница';

  @override
  String get exerciseMorningArmsS4InchwormDesc =>
      'Встань прямо, наклонись и поставь ладони на пол (колени можно согнуть). Переступая руками, дойди до планки, затем вернись руками к стопам и поднимись.';

  @override
  String get exerciseMorningArmsS4InchwormTip =>
      'В планке тело — одна прямая линия.';

  @override
  String get exerciseMorningArmsS5PlankToDogName => 'Из планки в «собаку»';

  @override
  String get exerciseMorningArmsS5PlankToDogDesc =>
      'Встань в планку на прямых руках, ладони под плечами. Подними таз вверх и назад в перевёрнутую букву V, пятки тянутся к полу, затем вернись в планку.';

  @override
  String get exerciseMorningArmsS5PlankToDogTip =>
      'Отталкивай пол руками, голова свободно между руками.';

  @override
  String get exerciseMorningEnergyS1StepJacksName => 'Шаги с руками вверх';

  @override
  String get exerciseMorningEnergyS1StepJacksDesc =>
      'Как «джампинг-джек», только без прыжка: шаг одной ногой в сторону — обе руки вверх; приставь ногу — руки вниз; затем другой ногой. Держи ровный ритм.';

  @override
  String get exerciseMorningEnergyS1StepJacksTip =>
      'Шагай мягко и без прыжков — никого не разбудишь.';

  @override
  String get exerciseMorningEnergyS2ButtKicksName => 'Захлёст голени';

  @override
  String get exerciseMorningEnergyS2ButtKicksDesc =>
      'На месте поднимай пятку к ягодицам то одной, то другой ногой в бодром темпе. Руки согнуты и работают в такт. Одна стопа всегда на полу.';

  @override
  String get exerciseMorningEnergyS2ButtKicksTip =>
      'Тихие шаги на носках: бодро, но без прыжков.';

  @override
  String get exerciseMorningEnergyS3CrossCrunchName => 'Локоть к колену стоя';

  @override
  String get exerciseMorningEnergyS3CrossCrunchDesc =>
      'Встань, руки за головой. Подними колено и опусти к нему противоположный локоть, затем смени сторону — в ровном темпе.';

  @override
  String get exerciseMorningEnergyS3CrossCrunchTip =>
      'Поворачивайся в талии, между повторами раскрывай грудь.';

  @override
  String get exerciseMorningEnergyS4SpeedSkaterName => 'Конькобежец';

  @override
  String get exerciseMorningEnergyS4SpeedSkaterDesc =>
      'Как конькобежец, но без прыжка: широкий шаг в сторону на согнутую ногу, другая стопа уходит назад за неё, противоположная рука махом идёт через корпус. Затем шаг в другую сторону.';

  @override
  String get exerciseMorningEnergyS4SpeedSkaterTip =>
      'Садись в опорную ногу, грудь над ней.';

  @override
  String get exerciseMorningEnergyS5MountainClimbersName =>
      'Скалолаз в медленном темпе';

  @override
  String get exerciseMorningEnergyS5MountainClimbersDesc =>
      'В планке на прямых руках, ладони под плечами, подтяни одно колено к груди и верни стопу, затем другое. Ровный темп, без прыжков при смене ног.';

  @override
  String get exerciseMorningEnergyS5MountainClimbersTip =>
      'Таз на уровне плеч, не задирай его.';

  @override
  String get exerciseWarmupMorningStretchUpName => 'Потягивание';

  @override
  String get exerciseWarmupMorningStretchUpDesc =>
      'Встань прямо. На вдохе потянись обеими руками вверх и поднимись на носки, на выдохе опусти пятки и руки. Потягивайся, как сразу после сна.';

  @override
  String get exerciseWarmupMorningStretchUpTip =>
      'Тянись кончиками пальцев, просыпайся не спеша.';

  @override
  String get exerciseCooldownShakeOutName => 'Встряхнуться';

  @override
  String get exerciseCooldownShakeOutDesc =>
      'Встань свободно и встряхни кисти, руки и ноги, мягко пружиня в коленях. В конце глубокий вдох — и можно начинать день.';

  @override
  String get exerciseCooldownShakeOutTip =>
      'Всё расслаблено: запястья, плечи, челюсть.';

  @override
  String get exerciseYogaStandingS1ChairName => 'Стул';

  @override
  String get exerciseYogaStandingS1ChairDesc =>
      'Стопы вместе, согни колени и отведи таз назад, как будто садишься на стул, руки подняты вверх вдоль ушей. Вес на пятках, грудь раскрыта.';

  @override
  String get exerciseYogaStandingS1ChairTip =>
      'Колени не выходят за носки, живот подтянут.';

  @override
  String get exerciseYogaStandingS2Warrior1Name => 'Воин I';

  @override
  String get exerciseYogaStandingS2Warrior1Desc =>
      'Отступи одной ногой далеко назад и чуть разверни стопу наружу, переднее колено согни над щиколоткой, таз смотрит вперёд. Руки подняты вверх. Затем другая сторона.';

  @override
  String get exerciseYogaStandingS2Warrior1Tip =>
      'Пятка задней ноги прижата к полу, задняя нога прямая.';

  @override
  String get exerciseYogaStandingS3Warrior2Name => 'Воин II';

  @override
  String get exerciseYogaStandingS3Warrior2Desc =>
      'Ноги широко, передняя стопа смотрит вперёд, задняя развёрнута внутрь. Согни переднее колено над щиколоткой, руки разведи в стороны на уровне плеч, взгляд над передней рукой. Затем другая сторона.';

  @override
  String get exerciseYogaStandingS3Warrior2Tip =>
      'Колено смотрит на средние пальцы стопы, не заваливается внутрь.';

  @override
  String get exerciseYogaStandingS4TriangleName => 'Треугольник';

  @override
  String get exerciseYogaStandingS4TriangleDesc =>
      'Ноги широко, передняя стопа смотрит вперёд. Ноги прямые: потянись вперёд и наклони корпус над передней ногой — нижняя рука на голени, верхняя тянется к потолку. Затем другая сторона.';

  @override
  String get exerciseYogaStandingS4TriangleTip =>
      'Обе стороны талии длинные, не проваливайся на переднюю ногу.';

  @override
  String get exerciseYogaStandingS5SideAngleName => 'Боковой угол';

  @override
  String get exerciseYogaStandingS5SideAngleDesc =>
      'Из «Воина II» положи предплечье передней руки на бедро (или ладонь на пол), другую руку вытяни над ухом — одна длинная линия от задней стопы до кончиков пальцев. Затем другая сторона.';

  @override
  String get exerciseYogaStandingS5SideAngleTip =>
      'Колено над щиколоткой, грудь разворачивается к потолку.';

  @override
  String get exerciseYogaOneLegS1TreeName => 'Дерево';

  @override
  String get exerciseYogaOneLegS1TreeDesc =>
      'Встань на одну ногу, стопу другой поставь на внутреннюю сторону голени или бедра (не на колено), колено смотрит в сторону. Ладони вместе у груди или над головой. Затем другая сторона.';

  @override
  String get exerciseYogaOneLegS1TreeTip =>
      'Смотри в одну точку, стопа и нога упираются друг в друга.';

  @override
  String get exerciseYogaOneLegS2EagleName => 'Орёл';

  @override
  String get exerciseYogaOneLegS2EagleDesc =>
      'Согни колени, перекрести одно бедро над другим и, если получается, зацепи стопу за икру опорной ноги. Руки скрещены в локтях, ладони вместе перед лицом. Опустись чуть ниже. Затем другая сторона.';

  @override
  String get exerciseYogaOneLegS2EagleTip =>
      'Таз ровно, локти подняты до уровня плеч.';

  @override
  String get exerciseYogaOneLegS3Warrior3Name => 'Воин III';

  @override
  String get exerciseYogaOneLegS3Warrior3Desc =>
      'Стоя на одной ноге, наклонись вперёд и подними другую ногу назад, пока корпус и нога не образуют букву Т, руки тянутся вперёд. Затем другая сторона.';

  @override
  String get exerciseYogaOneLegS3Warrior3Tip =>
      'Таз ровный, колено опорной ноги чуть мягкое.';

  @override
  String get exerciseYogaOneLegS4DancerName => 'Танцор';

  @override
  String get exerciseYogaOneLegS4DancerDesc =>
      'Стоя на одной ноге, возьми другую стопу рукой сзади и упирайся стопой в ладонь — нога поднимается, корпус наклоняется вперёд, свободная рука тянется вперёд. Затем другая сторона.';

  @override
  String get exerciseYogaOneLegS4DancerTip =>
      'Отталкивай стопу в ладонь, а не тяни ногу рукой.';

  @override
  String get exerciseYogaOneLegS5HalfMoonName => 'Полумесяц';

  @override
  String get exerciseYogaOneLegS5HalfMoonDesc =>
      'Наклонись набок над одной ногой: нижняя рука на полу (или на блоке) под плечом, другая нога поднята на уровень корпуса, верхняя рука тянется к потолку. Затем другая сторона.';

  @override
  String get exerciseYogaOneLegS5HalfMoonTip =>
      'Таз и плечи раскрыты, словно спина прижата к стене.';

  @override
  String get exerciseYogaBackbendsS2LocustName => 'Саранча';

  @override
  String get exerciseYogaBackbendsS2LocustDesc =>
      'Лёжа на животе, руки вдоль тела ладонями вниз. Одновременно оторви от пола грудь, руки и ноги, взгляд вниз и чуть вперёд.';

  @override
  String get exerciseYogaBackbendsS2LocustTip =>
      'Тянись ногами в длину, не сжимай поясницу.';

  @override
  String get exerciseYogaBackbendsS3BridgeName => 'Мост на лопатках';

  @override
  String get exerciseYogaBackbendsS3BridgeDesc =>
      'Лёжа на спине, колени согнуты, стопы на ширине таза рядом с ягодицами. Упрись стопами и подними таз как можно выше, руки на полу. Удерживай, затем опускайся позвонок за позвонком.';

  @override
  String get exerciseYogaBackbendsS3BridgeTip =>
      'Колени смотрят вперёд и не разъезжаются, ягодицы напряжены.';

  @override
  String get exerciseYogaBackbendsS4BowName => 'Лук';

  @override
  String get exerciseYogaBackbendsS4BowDesc =>
      'Лёжа на животе, согни колени и возьмись руками за щиколотки снаружи. Упирайся стопами в ладони — грудь и бёдра поднимаются, тело выгибается, как лук.';

  @override
  String get exerciseYogaBackbendsS4BowTip => 'Колени не шире таза.';

  @override
  String get exerciseYogaBackbendsS5CamelName => 'Верблюд';

  @override
  String get exerciseYogaBackbendsS5CamelDesc =>
      'Встань на колени на ширине таза, пальцы ног подогнуты, ладони на пояснице. Подай таз вперёд, раскрой грудь и прогнись назад, голова мягко следует за ней. Выходи, поднимая сначала грудь.';

  @override
  String get exerciseYogaBackbendsS5CamelTip =>
      'Таз над коленями; прогиб идёт от груди, а не от поясницы.';

  @override
  String get exerciseYogaBackbendsS6WheelName => 'Колесо';

  @override
  String get exerciseYogaBackbendsS6WheelDesc =>
      'Лёжа на спине, колени согнуты, стопы у таза, ладони упираются в пол у плеч. Подними таз, затем выжмись на руках, пока они не выпрямятся, а голова не повиснет между ними. Опускайся медленно, подбородок к груди.';

  @override
  String get exerciseYogaBackbendsS6WheelTip =>
      'Стопы параллельны, отталкивай пол руками и ногами равномерно.';

  @override
  String get exerciseYogaFlowS3HalfSunSalutationName =>
      'Полуприветствие солнцу';

  @override
  String get exerciseYogaFlowS3HalfSunSalutationDesc =>
      'Один круг: стоя, руки через стороны вверх, наклон вперёд, полуподъём с ровной спиной, снова наклон, подъём с руками вверх и руки вниз. Двигайся вместе с дыханием.';

  @override
  String get exerciseYogaFlowS3HalfSunSalutationTip =>
      'Вдох — подъём, выдох — наклон.';

  @override
  String get exerciseYogaFlowS4SunSalutationAName => 'Приветствие солнцу A';

  @override
  String get exerciseYogaFlowS4SunSalutationADesc =>
      'Один круг: руки вверх, наклон, полуподъём, шаг назад в планку, опускание до середины, собака мордой вверх, собака мордой вниз на несколько вдохов, шаг вперёд, полуподъём, подъём с руками вверх и стойка.';

  @override
  String get exerciseYogaFlowS4SunSalutationATip =>
      'Одно движение — один вдох или выдох; опускаться можно с колен.';

  @override
  String get exerciseYogaFlowS5SunSalutationBName => 'Приветствие солнцу B';

  @override
  String get exerciseYogaFlowS5SunSalutationBDesc =>
      'Как «Приветствие солнцу A», но в начале и в конце «Стул», а «Воин I» — на каждую сторону: стул, наклон, планка, опускание, собака мордой вверх, собака мордой вниз, воин I на одну сторону, через планку обратно в собаку, воин I на другую сторону и вперёд к стулу.';

  @override
  String get exerciseYogaFlowS5SunSalutationBTip =>
      'Дыхание ровное — оно задаёт темп.';

  @override
  String get aboutTitle => 'О приложении';

  @override
  String get aboutSectionSupport => 'ПОДДЕРЖКА';

  @override
  String get aboutContactUs => 'Написать нам';

  @override
  String get aboutContactUsSubtitle => 'Сообщить об ошибке или задать вопрос';

  @override
  String get aboutPrivacyPolicy => 'Политика конфиденциальности';

  @override
  String get aboutTermsOfUse => 'Условия использования';

  @override
  String get aboutLegalConsent =>
      'Используя CaliDay, вы соглашаетесь с Политикой конфиденциальности и Условиями использования.';

  @override
  String get aboutCopyright => '© 2026 pupptmstr';

  @override
  String get whatsNewTitle => 'Что нового';

  @override
  String get whatsNewBadge => 'НОВОЕ';

  @override
  String whatsNewVersion(String version) {
    return 'Версия $version';
  }

  @override
  String get releaseNotes092 =>
      'Стойка на одной ноге, растяжка сгибателей бедра и 90/90 стали короче: от 10 до 30 секунд на каждую сторону вместо 20–60. Если ты уже держал дольше 30 секунд, станет 30.\nДостижения курса теперь вручает его ведущий: его портрет стоит на значке достижения, а в карточке он радуется вместе с тобой или подбадривает, пока достижение впереди.\nЗвёзды рангов в достижениях и переключатель темы в настройках больше не переносятся на вторую строку.\nУ позы голубя появилась анимация: Горо показывает её сверху.\nУ упражнения 90/90 тоже появилась анимация: Горо по очереди укладывает колени в обе стороны. Теперь анимация есть у каждого упражнения.';

  @override
  String get releaseNotes091 =>
      'Новый курс «Йога»: позы от простых к сложным в четырёх новых навыках — стойки, равновесие, прогибы и приветствие солнцу. Навык «Баланс» курс делит с калистеникой: прогресс в нём общий.\nЙогу ведёт кот Мисо: пока курс выбран, он встречает на главном экране и в профиле, а в конце тренировки поднимает лапы над головой.';

  @override
  String get releaseNotes090 =>
      'Новый курс «Утренняя зарядка»: разбуди тело в четырёх навыках — позвоночник, суставы, руки и бодрость. Всё стоя и тихо, без прыжков.\nУтреннюю зарядку ведёт жаворонок Аврора: пока курс выбран, она встречает на главном экране и в профиле, а в конце тренировки поёт.';

  @override
  String get releaseNotes0820 =>
      'Упражнения на одну сторону теперь идут на обе: после первой стороны короткий отсчёт даёт время поменять сторону, потом таймер считает вторую. Нажимать ничего не нужно.\nЭто растяжки сгибателя бедра, 90/90, наклоны головы, поза голубя, стойка на одной ноге, планка на одной руке, боковая планка и растяжки ног и боков после тренировки.\nСкала, судья испытаний, перерисован: теперь он и правда бык.\nНовый курс «Вечерняя растяжка»: спокойная растяжка перед сном, четыре навыка — спина, бёдра, наклоны и плечи.\nУ каждого курса теперь свой ведущий: жираф Раффи ведёт «Здоровое тело», сова Луна — «Вечернюю растяжку», Горо остаётся с «Калистеникой». Ведущий текущего курса теперь встречает на главном экране и в профиле, со всеми своими настроениями, и радуется в конце тренировки.';

  @override
  String get releaseNotes0819 =>
      'Каждая ветка теперь растёт раз в день в любой тренировке — утренней, вечерней или своей подборке. Два курса в один день прогрессируют оба.\nДрузья больше не видят твой этап в каждой ветке: в коде друга остались ранг, SP и серия, и он легче сканируется. Друзьям со старой версией нужно обновиться, чтобы его прочитать.';

  @override
  String get releaseNotes0818 =>
      'Виджет на домашнем экране говорит на языке приложения: подпись «Готово» и описание в галерее виджетов больше не всегда на русском.\nПосле смены языка в настройках виджет и напоминания сразу переходят на новый язык.';

  @override
  String get releaseNotes0817 =>
      'Числа теперь согласуются со словами: «1 друг», «21 упражнение», «стрик 3 дня», «потренировался 5 раз».';

  @override
  String get releaseNotes0816 =>
      'Приложение теперь есть и на немецком и испанском.\nПереключатель языка на приветственном экране стал меню.\nУведомление о прерванной серии теперь правильно склоняет число дней.';

  @override
  String get releaseNotes0815 =>
      'Колокольчик в профиле показывает, что изменилось в каждом обновлении.\nЭкран «О приложении» стал короче: убрали техническую строку.';

  @override
  String get releaseNotes0814 =>
      'Кнопка «Ещё раз» показывает, сколько примерно займёт дополнительная тренировка.';

  @override
  String get releaseNotes0813 =>
      'Время на кнопке тренировки теперь учитывает твой темп: после нескольких тренировок оно отражает, сколько они реально у тебя занимают.';

  @override
  String get releaseNotes0812 =>
      'Кнопка тренировки показывает, сколько примерно займёт сегодняшняя тренировка.\nВечернее напоминание больше не обещает «10 минут».';

  @override
  String get releaseNotes0811 =>
      'Размер тренировки вместо «5, 10 или 15 минут»: короткая, стандартная или полная. Он задаёт, сколько навыков войдёт в тренировку, а не сколько она продлится.';

  @override
  String get releaseNotes0810 =>
      'Упражнения на время теперь запускаются сами после короткого отсчёта «приготовься». Нажми «Пауза», если нужно больше времени, чтобы прочитать или занять позицию.\nПоиск в каталоге упражнений работает и на русском, и на английском.\nПереведены несколько текстов, которые оставались на одном языке.';

  @override
  String get settingsAbout => 'О приложении';

  @override
  String get settingsSectionHealth => 'ЗДОРОВЬЕ';

  @override
  String get settingsHealthWorkoutsTitle => 'Записывать тренировки';

  @override
  String get settingsHealthWorkoutsSubtitle =>
      'Сохранять в Apple Health / Health Connect';

  @override
  String get settingsHealthWeightTitle => 'Читать массу тела';

  @override
  String get settingsHealthWeightSubtitle =>
      'Для точного расчёта калорий (иначе 70 кг)';

  @override
  String get summaryHealthSaved => 'Сохранено в Health ✓';

  @override
  String get friendsTitle => 'Друзья';

  @override
  String get friendsMyQrTitle => 'Мой профиль';

  @override
  String get friendsShareHint =>
      'Покажи этот код другу, чтобы поделиться профилем';

  @override
  String get friendsScanQr => 'Сканировать QR-код';

  @override
  String get friendsSectionNearby => 'РЯДОМ';

  @override
  String get friendsSectionList => 'ДРУЗЬЯ';

  @override
  String get friendsNearbyEmpty => 'Пользователей CaliDay рядом нет';

  @override
  String get friendsNearbyScanning => 'Поиск…';

  @override
  String get friendsNearbyBleOff => 'Bluetooth выключен';

  @override
  String get friendsNearbyConnect => 'Получить профиль';

  @override
  String get friendsEmpty =>
      'Друзей пока нет. Отсканируй QR-код, чтобы добавить первого.';

  @override
  String get friendsAdded => 'Друг добавлен!';

  @override
  String get friendsUpdated => 'Профиль обновлён!';

  @override
  String get friendsScanError => 'Неверный QR-код';

  @override
  String get friendsScanTryAgain => 'Повторить';

  @override
  String get friendsScanCameraDeniedTitle => 'Доступ к камере заблокирован';

  @override
  String get friendsScanCameraDeniedWeb =>
      'Разрешите камеру для этого сайта (значок камеры или замка в адресной строке) и нажмите «Повторить». Или покажите другу свой QR-код.';

  @override
  String get friendsScanCameraDeniedApp =>
      'Разрешите CaliDay доступ к камере в настройках устройства и нажмите «Повторить».';

  @override
  String get friendsScanCameraUnsupportedTitle => 'Камера недоступна';

  @override
  String get friendsScanCameraUnsupportedBody =>
      'На этом устройстве или в браузере нет камеры, доступной приложению. Покажите другу свой QR-код.';

  @override
  String get friendsScanCameraFailedTitle => 'Не удалось запустить камеру';

  @override
  String get friendsScanCameraFailedBody =>
      'Проверьте, что камеру не занимает другое приложение и что есть интернет (в браузере сканер загружается при первом использовании), и повторите.';

  @override
  String friendsScanConfirmBody(int sp, int streak) {
    String _temp0 = intl.Intl.pluralLogic(
      streak,
      locale: localeName,
      other: '$streak дня',
      many: '$streak дней',
      few: '$streak дня',
      one: '$streak день',
    );
    return '$sp SP · стрик $_temp0';
  }

  @override
  String get friendsCancel => 'Отмена';

  @override
  String get friendsAdd => 'Добавить';

  @override
  String friendsDetailLastSynced(String date) {
    return 'Синхронизировано: $date';
  }

  @override
  String get friendsDeleteTitle => 'Удалить друга';

  @override
  String friendsDeleteBody(String name) {
    return 'Удалить $name из друзей?';
  }

  @override
  String get friendsDeleteConfirm => 'Удалить';

  @override
  String get settingsSectionFriends => 'ДРУЗЬЯ';

  @override
  String get settingsFriendsNameTitle => 'Имя для друзей';

  @override
  String get settingsFriendsNamePlaceholder => 'Введи своё имя';

  @override
  String get settingsFriendsDiscoverableTitle => 'Виден через Bluetooth';

  @override
  String get settingsFriendsDiscoverableSubtitle =>
      'Другие пользователи CaliDay смогут найти тебя рядом';

  @override
  String get profileFriendsTitle => 'Друзья';

  @override
  String get profileFriendsAll => 'Все друзья →';

  @override
  String get profileFriendsEmpty => 'Друзей пока нет';

  @override
  String profileFriendsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count друга',
      many: '$count друзей',
      few: '$count друга',
      one: '$count друг',
    );
    return '$_temp0';
  }

  @override
  String get exerciseFlexS1HipFlexorStretchName => 'Растяжка сгибателей бедра';

  @override
  String get exerciseFlexS1HipFlexorStretchDesc =>
      'Встань в выпад, опусти заднее колено на пол. Толкай бёдра вперёд, чтобы почувствовать растяжку в передней части бедра. Удержи каждую сторону.';

  @override
  String get exerciseFlexS1HipFlexorStretchTip =>
      'Держи спину прямо и толкай бёдра вперёд — почувствуй растяжку в передней части бедра.';

  @override
  String get exerciseFlexS2WorldsGreatestStretchName =>
      'Лучшая растяжка в мире';

  @override
  String get exerciseFlexS2WorldsGreatestStretchDesc =>
      'Из выпада поставь одноимённую руку на пол. Поверни верхнюю часть тела и потянись другой рукой к потолку. Выполняй плавно.';

  @override
  String get exerciseFlexS2WorldsGreatestStretchTip =>
      'Двигайся медленно через каждую позицию — это поток, а не гонка.';

  @override
  String get exerciseFlexS3Hip9090Name => 'Мобильность бёдер 90/90';

  @override
  String get exerciseFlexS3Hip9090Desc =>
      'Сядь на пол, обе ноги согнуты под 90°: одна спереди, другая сбоку. Удержи положение и смени сторону.';

  @override
  String get exerciseFlexS3Hip9090Tip =>
      'Держи обе седалищные кости на полу. Вращай из бедра, а не из поясницы.';

  @override
  String get exerciseFlexS4ThoracicBridgeName => 'Торакальный мост';

  @override
  String get exerciseFlexS4ThoracicBridgeDesc =>
      'Из положения сидя с руками позади подними бёдра и поверни верхнюю часть позвоночника, открывая грудь к потолку.';

  @override
  String get exerciseFlexS4ThoracicBridgeTip =>
      'Сосредоточь движение в верхней части спины — избегай сгибания в пояснице.';

  @override
  String get exerciseFlexS5DeepSquatHoldName => 'Глубокий присед (удержание)';

  @override
  String get exerciseFlexS5DeepSquatHoldDesc =>
      'Ноги на ширине плеч, носки чуть развёрнуты. Опустись в глубокий присед и удержи. При необходимости держись за дверной косяк.';

  @override
  String get exerciseFlexS5DeepSquatHoldTip =>
      'Поначалу используй косяк двери или стойку. Цель — пятки на полу.';

  @override
  String get exerciseFlexS6PikeStretchName => 'Растяжка в наклоне вперёд';

  @override
  String get exerciseFlexS6PikeStretchDesc =>
      'Сядь на пол, ноги прямые перед собой. Потянись руками к стопам, сгибаясь в бёдрах. Удержи положение.';

  @override
  String get exerciseFlexS6PikeStretchTip =>
      'Тянись вперёд из бёдер, а не из поясницы. Держи ноги прямыми.';

  @override
  String get exerciseSuppObliqueCrunchName => 'Косые скручивания';

  @override
  String get exerciseSuppObliqueCrunchDesc =>
      'Лёжа на спине, ноги согнуты. Тянись правым локтем к левому колену, затем левым к правому. Поочерёдно.';

  @override
  String get exerciseSuppRussianTwistsName => 'Русские скручивания';

  @override
  String get exerciseSuppRussianTwistsDesc =>
      'Сядь, слегка отклонись назад, ноги чуть приподними. Поворачивай корпус вправо и влево — каждый поворот = один повтор.';

  @override
  String get exerciseSuppRussianTwistsTip => 'Держи спину прямой, не горби.';

  @override
  String get exerciseSuppSidePlankName => 'Боковая планка';

  @override
  String get exerciseSuppSidePlankDesc =>
      'Упор на предплечье сбоку, тело вытянуто в прямую линию. Удержи позицию, затем повтори на другой стороне.';

  @override
  String get exerciseSuppSidePlankTip =>
      'Не опускай бёдра — держи прямую линию.';

  @override
  String get exerciseSuppStandingCalfRaiseName => 'Подъёмы на носки';

  @override
  String get exerciseSuppStandingCalfRaiseDesc =>
      'Встань ровно, медленно поднимись на носки на 2–3 секунды, затем опустись. Можно придерживаться за стену для баланса.';

  @override
  String get exerciseSuppSingleLegCalfRaiseName =>
      'Подъём на носок (одна нога)';

  @override
  String get exerciseSuppSingleLegCalfRaiseDesc =>
      'Встань на одну ногу. Медленно поднимись на носок и опустись. Повтори на другой ноге.';

  @override
  String get exerciseSuppSingleLegCalfRaiseTip =>
      'Медленный темп — больше пользы.';

  @override
  String get exerciseSuppDeadBugName => 'Мёртвый жук';

  @override
  String get exerciseSuppDeadBugDesc =>
      'Лёжа на спине, руки вертикально вверх, колени 90°. Одновременно опускай правую руку назад и выпрямляй левую ногу. Поочерёдно.';

  @override
  String get exerciseSuppDeadBugTip =>
      'Поясница прижата к полу на протяжении всего упражнения.';

  @override
  String get exerciseSuppBirdDogName => 'Птица-пёс';

  @override
  String get exerciseSuppBirdDogDesc =>
      'На четвереньках: вытяни правую руку вперёд и левую ногу назад одновременно. Удержи 2 секунды, вернись. Поочерёдно.';

  @override
  String get exerciseSuppBirdDogTip => 'Не поворачивай таз — держи его ровно.';

  @override
  String get exerciseSuppNeckIsometricsName => 'Изометрия шеи';

  @override
  String get exerciseSuppNeckIsometricsDesc =>
      'Упрись ладонью в лоб и надавливай — шея сопротивляется. Затем в затылок и в каждый висок. По 5–10 секунд.';

  @override
  String get exerciseSuppNeckIsometricsTip => 'Мягкое давление — не форсируй.';

  @override
  String get exerciseSuppWristCirclesName => 'Вращения запястьями';

  @override
  String get exerciseSuppWristCirclesDesc =>
      'Сожми руки в кулаки и медленно вращай запястьями по часовой и против часовой стрелки. Укрепляет предплечья и сухожилия.';

  @override
  String get exerciseWarmupNeckRollsName => 'Вращения шеей';

  @override
  String get exerciseWarmupNeckRollsDesc =>
      'Медленно наклоняй голову вперёд-назад и в стороны, затем плавный полукруг от плеча к плечу. Разогревает мышцы шеи.';

  @override
  String get exercisePostureS1PelvicTiltName => 'Наклон таза лёжа';

  @override
  String get exercisePostureS1PelvicTiltDesc =>
      'Лёжа на спине, колени согнуты. Медленно прижимай поясницу к полу, напрягая живот. Удержи 5 секунд, расслабь.';

  @override
  String get exercisePostureS1PelvicTiltTip =>
      'Не задерживай дыхание — работай плавно.';

  @override
  String get exercisePostureS2DeadBugName => 'Мёртвый жук';

  @override
  String get exercisePostureS2DeadBugDesc =>
      'Лёжа на спине, руки вертикально вверх, колени 90°. Одновременно опускай правую руку назад и выпрямляй левую ногу — не давай пояснице оторваться от пола.';

  @override
  String get exercisePostureS2DeadBugTip =>
      'Двигайся медленно — это контроль, а не скорость. Поясница прижата к полу всё время.';

  @override
  String get exercisePostureS3GluteBridgeName => 'Ягодичный мостик';

  @override
  String get exercisePostureS3GluteBridgeDesc =>
      'Лёжа на спине, колени согнуты, стопы на полу. Поднимай бёдра вверх, сжимая ягодицы. Удержи секунду наверху, опусти.';

  @override
  String get exercisePostureS3GluteBridgeTip =>
      'Сжимай ягодицы в верхней точке — не толкай поясницей.';

  @override
  String get exercisePostureS4HipMarchName => 'Шагание на месте';

  @override
  String get exercisePostureS4HipMarchDesc =>
      'Стоя прямо, медленно поднимай одно колено до уровня бедра, опусти. Чередуй стороны. Держи корпус неподвижным.';

  @override
  String get exercisePostureS4HipMarchTip =>
      'Поднимай колено до уровня бедра без наклона корпуса — сгибатель бедра работает, а не инерция.';

  @override
  String get exercisePostureS5KneelingLungeName =>
      'Растяжка сгибателей бедра в выпаде';

  @override
  String get exercisePostureS5KneelingLungeDesc =>
      'Встань в выпад, опусти заднее колено на пол, другая нога впереди. Выдвигай бёдра вперёд до ощущения растяжки в паху задней ноги. Удержи.';

  @override
  String get exercisePostureS5KneelingLungeTip =>
      'Держи спину прямо и мягко подтяни таз под себя, чтобы углубить растяжку.';

  @override
  String get exercisePostureS6PigeonPoseName => 'Поза голубя';

  @override
  String get exercisePostureS6PigeonPoseDesc =>
      'Из положения на четвереньках вынеси правую ногу вперёд, согни под углом 90°. Левая нога вытянута назад. Опусти бёдра вниз и удержи позицию.';

  @override
  String get exercisePostureS6PigeonPoseTip =>
      'Дыши глубоко — поза раскрывает тазобедренный сустав постепенно.';

  @override
  String get exerciseNeckS1NeckTiltName => 'Наклоны шеи';

  @override
  String get exerciseNeckS1NeckTiltDesc =>
      'Медленно наклони голову к правому плечу — без подъёма плеча — и удерживай мягкую растяжку. Потом другая сторона.';

  @override
  String get exerciseNeckS1NeckTiltTip =>
      'Плечо тянется вниз — так растяжка глубже.';

  @override
  String get exerciseNeckS2ChestOpenerName => 'Раскрытие груди';

  @override
  String get exerciseNeckS2ChestOpenerDesc =>
      'Стоя прямо, сцепи руки за спиной. Сведи лопатки вместе и мягко подними руки, раскрывая грудь.';

  @override
  String get exerciseNeckS2ChestOpenerTip =>
      'Сжимай лопатки — не прогибай поясницу.';

  @override
  String get exerciseNeckS3ShoulderRollName => 'Вращения плечами';

  @override
  String get exerciseNeckS3ShoulderRollDesc =>
      'Делай большие медленные круги плечами — 5 раз вперёд, затем 5 раз назад. Шея расслаблена на протяжении всего упражнения.';

  @override
  String get exerciseNeckS3ShoulderRollTip =>
      'Делай круги как можно большими — преувеличивай движение.';

  @override
  String get exerciseNeckS4WallAngelName => 'Ангел у стены';

  @override
  String get exerciseNeckS4WallAngelDesc =>
      'Встань спиной к стене, прижав спину, голову и руки к поверхности. Медленно поднимай руки вверх над головой, не отрывая их от стены. Опусти.';

  @override
  String get exerciseNeckS4WallAngelTip =>
      'Поясница прижата к стене всё время — это сложнее, чем кажется.';

  @override
  String get exerciseNeckS5DoorwayStretchName => 'Растяжка в дверном проёме';

  @override
  String get exerciseNeckS5DoorwayStretchDesc =>
      'Встань в дверной проём, обе руки согнуты под 90° на уровне плеч, предплечья упираются в косяки. Медленно выдвинь грудь вперёд. Удержи 30 секунд.';

  @override
  String get exerciseNeckS5DoorwayStretchTip =>
      'Лопатки вместе — раскрытие грудного отдела в полную силу.';

  @override
  String get tooltipStreakTitle => 'Текущая серия';

  @override
  String get tooltipStreakBody =>
      'Количество дней подряд, в которые ты тренировался. Пропусти день без заморозки — и серия сбросится. Не давай огню погаснуть — Горо следит!';

  @override
  String get tooltipLongestStreakTitle => 'Личный рекорд';

  @override
  String get tooltipLongestStreakBody =>
      'Твоя самая длинная непрерывная серия тренировок за всё время. Этот рекорд хранится вечно — даже если текущая серия оборвётся.';

  @override
  String get tooltipTotalWorkoutsTitle => 'Всего тренировок';

  @override
  String get tooltipTotalWorkoutsBody =>
      'Общее количество завершённых тренировок с момента старта. Каждая сессия в счёт — бонусные тренировки тоже суммируются.';

  @override
  String get tooltipFreezesTitle => 'Заморозки серии';

  @override
  String get tooltipFreezesBody =>
      'Заморозки защищают серию, если пропустил день. Зарабатываются автоматически при регулярных тренировках. Максимум — 3 заморозки одновременно.';

  @override
  String get tooltipRankTitle => 'Ранг и очки силы';

  @override
  String get exerciseLibraryTitle => 'Все упражнения';

  @override
  String get exerciseLibrarySearchHint => 'Поиск упражнений...';

  @override
  String get exerciseLibraryCatalogButton => 'Каталог упражнений';

  @override
  String get exerciseLibraryEmpty => 'Упражнения не найдены';

  @override
  String get exerciseLibraryReset => 'Сбросить';

  @override
  String get exerciseTagFilterAll => 'Все';

  @override
  String exerciseLibraryCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count упражнения',
      many: '$count упражнений',
      few: '$count упражнения',
      one: '$count упражнение',
    );
    return '$_temp0';
  }

  @override
  String get exerciseDetailTipLabel => 'Техника';

  @override
  String exerciseDetailStageLabel(int stage) {
    return 'Этап $stage';
  }

  @override
  String get exerciseTagHipFlexor => 'Сгибатели бедра';

  @override
  String get exerciseTagGlutes => 'Ягодицы';

  @override
  String get exerciseTagCore => 'Пресс';

  @override
  String get exerciseTagChest => 'Грудь';

  @override
  String get exerciseTagBack => 'Спина';

  @override
  String get exerciseTagShoulders => 'Плечи';

  @override
  String get exerciseTagLegs => 'Ноги';

  @override
  String get exerciseTagNeck => 'Шея';

  @override
  String get exerciseTagStretch => 'Растяжка';

  @override
  String get exerciseTagMobility => 'Мобильность';

  @override
  String get exerciseTagStrength => 'Сила';

  @override
  String get exerciseTagEndurance => 'Выносливость';

  @override
  String get exerciseTagSittingRecovery => 'Офисное восстановление';

  @override
  String get exerciseTagFloorOnly => 'Без инвентаря';

  @override
  String get exerciseTagRequiresBar => 'Нужен турник';

  @override
  String get exerciseTagPostureFocus => 'Осанка';

  @override
  String get exerciseTagBeginner => 'Для новичков';

  @override
  String get exerciseTagWarmup => 'Разминка';

  @override
  String get exerciseTagCooldown => 'Заминка';

  @override
  String get customWorkoutNoWarmupTitle => 'Добавить разминку и заминку?';

  @override
  String get customWorkoutNoWarmupBody =>
      'В тренировке нет разминки и заминки. Добавить автоматически?';

  @override
  String get customWorkoutAdd => 'Добавить';

  @override
  String get customWorkoutSkip => 'Пропустить';

  @override
  String get customWorkoutButtonLabel => 'Своя тренировка';

  @override
  String get customWorkoutMyRoutines => 'Мои тренировки';

  @override
  String get customWorkoutNewRoutine => 'Новая тренировка';

  @override
  String get customWorkoutQuickRoutine => 'Быстрая тренировка';

  @override
  String get customWorkoutQuickRoutineDesc =>
      'Выберите направление — мы подберём упражнения';

  @override
  String get customWorkoutEmpty => 'Сохранённых тренировок пока нет';

  @override
  String get customWorkoutNameHint => 'Название тренировки';

  @override
  String get customWorkoutNameRequired =>
      'Введите название, чтобы сохранить тренировку';

  @override
  String get customWorkoutSave => 'Сохранить';

  @override
  String get customWorkoutStartNow => 'Начать';

  @override
  String get customWorkoutDelete => 'Удалить';

  @override
  String get customWorkoutEdit => 'Редактировать';

  @override
  String get customWorkoutBuilderTitle => 'Конструктор тренировки';

  @override
  String get customWorkoutBuilderDesc =>
      'Выбери упражнения и составь свою последовательность';

  @override
  String get customWorkoutPickFocus => 'Что хотите потренировать?';

  @override
  String customWorkoutExerciseCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count упражнения',
      many: '$count упражнений',
      few: '$count упражнения',
      one: '$count упражнение',
    );
    return '$_temp0';
  }

  @override
  String rankDecayWarning(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days дня',
      many: '$days дней',
      few: '$days дня',
      one: '$days день',
    );
    return 'Ты не тренировался $_temp0 — ранг снижен. Вернись к тренировкам!';
  }

  @override
  String get summaryRankRestoredTitle => 'Ранг восстановлен!';

  @override
  String get summaryRankRestoredBody =>
      'Продолжай тренироваться — ранг снова на месте!';

  @override
  String get notificationMorningTitle => 'Время тренироваться! 💪';

  @override
  String get notificationMorningBody =>
      'Твоя ежедневная тренировка ждёт. Не прерывай серию!';

  @override
  String get notificationEveningTitle => 'Ещё не поздно! 🏃';

  @override
  String get notificationEveningBody =>
      'Ты сегодня ещё не тренировался. Даже короткая тренировка засчитается.';

  @override
  String get notificationStreakTitle => 'Серия под угрозой! 🔥';

  @override
  String get notificationStreakBody =>
      'Успей потренироваться до полуночи — иначе серия прервётся.';

  @override
  String get notificationStreakLostTitle => 'Серия прервалась 😔';

  @override
  String notificationStreakLostBody(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days дня',
      many: '$days дней',
      few: '$days дня',
      one: '$days день',
    );
    return 'Твой стрик $_temp0 пропал. Начни новую серию — первый шаг всегда самый важный!';
  }

  @override
  String get notificationRankAtRiskTitle => 'Ранг под угрозой! ⚠️';

  @override
  String get notificationRankAtRiskBody =>
      '14 дней без тренировок — ранг начнёт снижаться через неделю. Вернись!';

  @override
  String get widgetDoneLabel => 'Готово';

  @override
  String get courseBuilderCreateEntry => 'Создать свой курс';

  @override
  String get courseBuilderCreateEntryDesc =>
      'Собери ветки из любых курсов или сделай свои из упражнений';

  @override
  String get courseBuilderNewTitle => 'Новый курс';

  @override
  String get courseBuilderEditTitle => 'Изменить курс';

  @override
  String get courseBuilderEditButton => 'Изменить';

  @override
  String get courseListOwnSection => 'Свои курсы';

  @override
  String get courseListOwnHint =>
      'Сними галочку, чтобы спрятать курс из списка сверху; он сохранится вместе с прогрессом.';

  @override
  String get courseBuilderNameHint => 'Название курса';

  @override
  String get courseBuilderNameRequired => 'Дай курсу название';

  @override
  String get courseBuilderHostTitle => 'Ведущий';

  @override
  String get courseBuilderBranchesTitle => 'Ветки';

  @override
  String get courseBuilderBranchesHint =>
      'У готовой ветки прогресс общий с её курсом.';

  @override
  String get courseBuilderMyBranches => 'Мои ветки';

  @override
  String get courseBuilderCreateBranch => 'Создать ветку';

  @override
  String courseBuilderStages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count этапа',
      many: '$count этапов',
      few: '$count этапа',
      one: '$count этап',
    );
    return '$_temp0';
  }

  @override
  String get courseBuilderPickBranch => 'Выбери хотя бы одну ветку';

  @override
  String get courseBuilderSave => 'Сохранить курс';

  @override
  String get courseBuilderDelete => 'Удалить курс';

  @override
  String courseBuilderDeleteConfirm(String name) {
    return 'Удалить «$name»? Прогресс его веток сохранится.';
  }

  @override
  String get courseBuilderNoBranchesLeft =>
      'В этом курсе нет веток для тренировки. Нажми «Изменить», чтобы добавить.';

  @override
  String get branchBuilderNewTitle => 'Новая ветка';

  @override
  String get branchBuilderEditTitle => 'Изменить ветку';

  @override
  String get branchBuilderNameHint => 'Название ветки';

  @override
  String get branchBuilderNameRequired => 'Дай ветке название';

  @override
  String get branchBuilderHowItWorks =>
      'Выбери упражнения и расставь их от простого к сложному: каждое станет этапом. Повторы, подходы, отдых и испытания для перехода на следующий этап приложение подберёт само.';

  @override
  String get branchBuilderStagesTitle => 'Этапы';

  @override
  String get branchBuilderEmpty => 'Пока нет упражнений.';

  @override
  String get branchBuilderAddExercises => 'Добавить упражнения';

  @override
  String get branchBuilderPickExercise => 'Добавь хотя бы одно упражнение';

  @override
  String get branchBuilderSave => 'Сохранить ветку';

  @override
  String get branchBuilderDelete => 'Удалить ветку';

  @override
  String branchBuilderDeleteConfirm(String name) {
    return 'Удалить «$name»? Её прогресс пропадёт, и она уйдёт из твоих курсов.';
  }

  @override
  String branchBuilderParamsReps(int from, int to, int setsFrom, int setsTo) {
    return '$from → $to повт.  ·  $setsFrom → $setsTo подх.';
  }

  @override
  String branchBuilderParamsTimed(int from, int to, int setsFrom, int setsTo) {
    return '$from → $to с  ·  $setsFrom → $setsTo подх.';
  }

  @override
  String branchBuilderParamsTimedPerSide(
    int from,
    int to,
    int setsFrom,
    int setsTo,
  ) {
    return '$from → $to с на сторону  ·  $setsFrom → $setsTo подх.';
  }

  @override
  String get exercisePickerTitle => 'Выбери упражнения';

  @override
  String exercisePickerDone(int count) {
    return 'Готово ($count)';
  }

  @override
  String get hostGoro => 'Горо';

  @override
  String get hostRaffi => 'Раффи';

  @override
  String get hostLuna => 'Луна';

  @override
  String get hostAurora => 'Аврора';

  @override
  String get hostMiso => 'Мисо';

  @override
  String get whatsNewRecent => 'Последние обновления';

  @override
  String get whatsNewHistory => 'История версий';

  @override
  String get releaseNotes094 =>
      'Свои курсы появились в списке курсов под +: сними галочку, чтобы спрятать курс из ряда сверху (он сохранится), карандаш открывает его для правки.\nСвой курс в ряду сверху отмечен значком с инструментами вместо лица ведущего.\nЕщё не полученное достижение ведущий теперь держит в руках: серая медаль с замочком.\n«О приложении»: нажми на Горо, у него есть несколько новых поз.';

  @override
  String get releaseNotes093 =>
      'Свой курс: на вкладке «Курсы» нажми + и собери ветки из любых курсов, выбери ведущего и дай курсу название.\nСвоя ветка: выбери упражнения и расставь их по порядку, каждое станет этапом. Повторы, подходы, отдых и испытания приложение подберёт само, как в любой ветке.\nВ колокольчике сверху последние обновления, а под ними свёрнута вся история CaliDay по версиям.';

  @override
  String get releaseHistory01 =>
      'Первая версия: короткие ежедневные тренировки, очки SP, серии, напоминания и первая настройка.\nПять навыков: отжимания, кор, подтягивания, ноги и баланс; тренировка чередует их по дням.\nПуть навыка: все этапы на одном экране и испытание, чтобы перейти дальше раньше.\nДостижения, дополнительные тренировки в тот же день и тёмная тема.\nРусский и английский языки.\nГоро показывает каждый этап отжиманий в анимации.';

  @override
  String get releaseHistory02 =>
      'Звук и вибрация во время тренировки.\nИстория тренировок.\nНовый главный экран с тремя вкладками внизу.\nЗаморозки серии: один пропущенный день больше не обрывает серию.\nЭкран «О приложении».';

  @override
  String get releaseHistory03 =>
      'Виджет на домашнем экране с серией и SP.\nApple Health и Health Connect: тренировки сохраняются туда, если хочешь.';

  @override
  String get releaseHistory04 =>
      'Друзья: добавляйте друг друга по QR-коду или находите рядом по Bluetooth и сравнивайте ранги, SP и серии.\nПервая настройка спрашивает твоё имя.';

  @override
  String get releaseHistory05 =>
      'Курсы: «Калистеника» и новое «Здоровое тело» с навыками осанки и шеи.\nНавык гибкости и подвижности.\nДополнительные тренировки добавляют два упражнения из нового набора.\nАнимации Горо для этапов кора, подтягиваний и ног.';

  @override
  String get releaseHistory06 =>
      'Библиотека упражнений: все упражнения с поиском и фильтрами.\nНажми на серию, ранг или заморозки в профиле, чтобы узнать, что они значат.';

  @override
  String get releaseHistory07 =>
      'Свои тренировки: выбери упражнения и сохрани подборку или начни быструю тренировку по фокусу.\nАнимации для этапов баланса.\nПолитика конфиденциальности и условия использования.';

  @override
  String get releaseHistory08 =>
      'Показатели на главном экране открывают календарь, историю и ранги; календарь тренировок.\nРанг снижается после долгих перерывов и возвращается с тренировками.\nCaliDay в браузере: веб-версия.\nАнимации для каждого упражнения первых курсов.\nУпражнения на время начинаются сами после короткого отсчёта; упражнения на одну сторону идут на обе.\nТренировка бывает короткой, стандартной или полной, с оценкой времени, которая учится твоему темпу.\n«Что нового» в колокольчике в профиле; немецкий и испанский языки.\nКаждый навык растёт раз в день, в любой тренировке.\nНовый курс «Вечерняя растяжка» и свой ведущий у каждого курса.';

  @override
  String get releaseHistory09 =>
      'Новые курсы: «Утренняя зарядка» с жаворонком Авророй и «Йога» с котом Мисо.\nВедущие вручают достижения своего курса; упражнения на каждую сторону стали короче.\nУ каждого упражнения есть анимация.\nСвои курсы: из готовых веток и своих, собранных из упражнений в твоём порядке.';
}
