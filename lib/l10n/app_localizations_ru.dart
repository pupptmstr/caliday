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
  String get navHome => 'Тренировка';

  @override
  String get navProgress => 'Прогресс';

  @override
  String get navProfile => 'Профиль';

  @override
  String get progressTitle => 'Мой прогресс';

  @override
  String get progressInfo =>
      'Просто тренируйтесь — приложение само продвигает вас вперёд по веткам. Здесь можно отследить пройденный путь. А если чувствуете, что готовы к большему раньше времени — принимайте Испытание и переходите сами.';

  @override
  String get homeDays => 'дней';

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
  String get homeWorkoutDone => 'Тренировка выполнена';

  @override
  String get homeWorkoutStart => 'Тренировка дня';

  @override
  String get homeWorkoutAgain => 'Ещё раз';

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
  String get workoutSec => 'сек';

  @override
  String get workoutRestLabel => 'отдых';

  @override
  String get workoutReps => 'Повторения';

  @override
  String get workoutStop => '⏹  Стоп';

  @override
  String get workoutDone => '✓  Готово';

  @override
  String get workoutSkipRest => 'Пропустить';

  @override
  String get workoutSetDone => '✅  Подход выполнен!';

  @override
  String get workoutExerciseDone => '✅  Упражнение выполнено!';

  @override
  String get workoutUnitReps => 'повт.';

  @override
  String workoutNextExercise(String name, int amount, String unit) {
    return 'Следующее: $name • $amount $unit';
  }

  @override
  String workoutNextSet(int setNum, int amount, String unit) {
    return 'Следующий: подход $setNum • $amount $unit';
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
  String get achievementAllCompleteName => 'Полный комплект';

  @override
  String get achievementAllCompleteDesc =>
      'Все 5 веток пройдены до конца. Абсолютный чемпион.';

  @override
  String get summaryBonusTitle => 'Бонусная тренировка';

  @override
  String get summaryBonusBody => '×½ SP · прогрессия уже сохранена';

  @override
  String summaryBonusCount(int count) {
    return 'Сегодня ты уже потренировался $count раза!';
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
  String get settingsWorkoutDurationTitle => 'Длительность сета';

  @override
  String get settingsWorkoutDurationSubtitle =>
      'Сколько минут уделять ежедневной тренировке';

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
  String get onboardingQ1 => 'Как часто ты занимаешься спортом?';

  @override
  String get onboardingQ2 => 'Сколько отжиманий ты можешь сделать?';

  @override
  String get onboardingQ3 => 'Сколько минут в день готов уделять?';

  @override
  String get onboardingQ4 => 'К чему ты стремишься?';

  @override
  String get onboardingQ5 => 'Есть ли у тебя турник или кольца дома?';

  @override
  String get onboardingEquipmentYes => 'Да, есть';

  @override
  String get onboardingEquipmentNo => 'Нет';

  @override
  String get onboardingQ6 => 'Во сколько напомнить о тренировке?';

  @override
  String get frequencyNeverLabel => 'Никогда';

  @override
  String get frequencyNeverDesc => 'Только начинаю';

  @override
  String get frequencySometimesLabel => 'Иногда';

  @override
  String get frequencySometimesDesc => 'Тренируюсь время от времени';

  @override
  String get frequencyRegularLabel => 'Регулярно';

  @override
  String get frequencyRegularDesc => 'Занимаюсь несколько раз в неделю';

  @override
  String get pushupZeroDesc => 'Пока ни одного';

  @override
  String get pushupOneToFiveDesc => 'Совсем немного';

  @override
  String get pushupFiveToFifteenDesc => 'Уже неплохо';

  @override
  String get pushupMoreThan15Desc => 'Отличная база';

  @override
  String minutesLabel(int minutes) {
    return '$minutes минут';
  }

  @override
  String get minutesFiveDesc => 'Быстро и эффективно';

  @override
  String get minutesTenDesc => 'Оптимальный вариант';

  @override
  String get minutesFifteenDesc => 'Полноценная тренировка';

  @override
  String get goalGeneralLabel => 'Общая форма';

  @override
  String get goalGeneralDesc => 'Быть активным и здоровым';

  @override
  String get goalStrengthLabel => 'Отжимания и сила';

  @override
  String get goalStrengthDesc => 'Накачать грудь и трицепс';

  @override
  String get goalCalisthenicsLabel => 'Калистеника';

  @override
  String get goalCalisthenicsDesc => 'Стойка на руках и трюки';

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
  String get aboutTitle => 'О приложении';

  @override
  String get aboutVersion => 'Версия';

  @override
  String get aboutSectionSupport => 'ПОДДЕРЖКА';

  @override
  String get aboutContactUs => 'Написать нам';

  @override
  String get aboutContactUsSubtitle => 'Сообщить об ошибке или задать вопрос';

  @override
  String get aboutPrivacyPolicy => 'Политика конфиденциальности';

  @override
  String get aboutBuiltWith => 'СДЕЛАНО НА';

  @override
  String get aboutCopyright => '© 2026 pupptmstr';

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
}
