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
  String get homeDays => 'дней';

  @override
  String get homeBranchesTitle => 'Ветки прогрессии';

  @override
  String get homeBranchPush => 'Толкай';

  @override
  String get homeBranchCore => 'Кор';

  @override
  String homeStage(int stage, int total) {
    return 'Этап $stage/$total';
  }

  @override
  String get homeChallengeUnlocked => '🏆 Испытание доступно';

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
  String get summarySubtitle => 'Так держать — ещё один шаг вперёд 💪';

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
  String get summaryChallengeUnlockedTitle => 'Испытание ждёт! 🏆';

  @override
  String get summaryChallengeUnlockedBody =>
      'Нажми «Принять вызов» на главном экране когда будешь готов';

  @override
  String get summaryChallengePassedTitle => 'Новый этап! 🎉';

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
  String get settingsSectionWorkout => 'ТРЕНИРОВКА';

  @override
  String get settingsWorkoutDurationTitle => 'Длительность сета';

  @override
  String get settingsWorkoutDurationSubtitle =>
      'Сколько минут уделять ежедневной тренировке';

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
  String get onboardingQ5 => 'Во сколько напомнить о тренировке?';

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
  String get exercisePushS5ArcherPushupName => 'Отжимания лучника';

  @override
  String get exercisePushS5ArcherPushupDesc =>
      'Широкая постановка рук. Опускайся в сторону одной руки, держа вторую прямой. Поочерёдно на каждую сторону.';

  @override
  String get exercisePushS5ArcherPushupTip =>
      'Рабочая рука — полный диапазон, прямая рука на полу — поддержка.';

  @override
  String get exercisePushS6OneArmPushupName => 'Отжимания на одной руке';

  @override
  String get exercisePushS6OneArmPushupDesc =>
      'Одна рука за спиной или сбоку. Ноги шире плеч для баланса. Полный диапазон движения рабочей рукой.';

  @override
  String get exercisePushS6OneArmPushupTip =>
      'Начинай с наклонной поверхности — так легче освоить технику.';

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
}
