import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ru'),
    Locale('en'),
  ];

  /// No description provided for @durationMin.
  ///
  /// In ru, this message translates to:
  /// **'{mins} мин {secs} сек'**
  String durationMin(int mins, int secs);

  /// No description provided for @durationSec.
  ///
  /// In ru, this message translates to:
  /// **'{secs} сек'**
  String durationSec(int secs);

  /// No description provided for @homeDays.
  ///
  /// In ru, this message translates to:
  /// **'дней'**
  String get homeDays;

  /// No description provided for @homeBranchesTitle.
  ///
  /// In ru, this message translates to:
  /// **'Ветки прогрессии'**
  String get homeBranchesTitle;

  /// No description provided for @homeBranchPush.
  ///
  /// In ru, this message translates to:
  /// **'Толкай'**
  String get homeBranchPush;

  /// No description provided for @homeBranchCore.
  ///
  /// In ru, this message translates to:
  /// **'Кор'**
  String get homeBranchCore;

  /// No description provided for @homeStage.
  ///
  /// In ru, this message translates to:
  /// **'Этап {stage}/{total}'**
  String homeStage(int stage, int total);

  /// No description provided for @homeChallengeUnlocked.
  ///
  /// In ru, this message translates to:
  /// **'🏆 Испытание доступно'**
  String get homeChallengeUnlocked;

  /// No description provided for @homeChallengeButton.
  ///
  /// In ru, this message translates to:
  /// **'Принять вызов'**
  String get homeChallengeButton;

  /// No description provided for @homeChallengeNormReps.
  ///
  /// In ru, this message translates to:
  /// **'Норматив: {n} повт.'**
  String homeChallengeNormReps(int n);

  /// No description provided for @homeChallengeNormSec.
  ///
  /// In ru, this message translates to:
  /// **'Норматив: {n} сек'**
  String homeChallengeNormSec(int n);

  /// No description provided for @homeWorkoutDone.
  ///
  /// In ru, this message translates to:
  /// **'Тренировка выполнена'**
  String get homeWorkoutDone;

  /// No description provided for @homeWorkoutStart.
  ///
  /// In ru, this message translates to:
  /// **'Тренировка дня'**
  String get homeWorkoutStart;

  /// No description provided for @workoutTitle.
  ///
  /// In ru, this message translates to:
  /// **'Тренировка'**
  String get workoutTitle;

  /// No description provided for @workoutExitTitle.
  ///
  /// In ru, this message translates to:
  /// **'Прервать тренировку?'**
  String get workoutExitTitle;

  /// No description provided for @workoutExitBody.
  ///
  /// In ru, this message translates to:
  /// **'Прогресс текущей тренировки не сохранится.'**
  String get workoutExitBody;

  /// No description provided for @workoutContinue.
  ///
  /// In ru, this message translates to:
  /// **'Продолжить'**
  String get workoutContinue;

  /// No description provided for @workoutAbort.
  ///
  /// In ru, this message translates to:
  /// **'Прервать'**
  String get workoutAbort;

  /// No description provided for @workoutSetProgress.
  ///
  /// In ru, this message translates to:
  /// **'Подход {current} из {total}'**
  String workoutSetProgress(int current, int total);

  /// No description provided for @workoutSec.
  ///
  /// In ru, this message translates to:
  /// **'сек'**
  String get workoutSec;

  /// No description provided for @workoutRestLabel.
  ///
  /// In ru, this message translates to:
  /// **'отдых'**
  String get workoutRestLabel;

  /// No description provided for @workoutReps.
  ///
  /// In ru, this message translates to:
  /// **'Повторения'**
  String get workoutReps;

  /// No description provided for @workoutStop.
  ///
  /// In ru, this message translates to:
  /// **'⏹  Стоп'**
  String get workoutStop;

  /// No description provided for @workoutDone.
  ///
  /// In ru, this message translates to:
  /// **'✓  Готово'**
  String get workoutDone;

  /// No description provided for @workoutSkipRest.
  ///
  /// In ru, this message translates to:
  /// **'Пропустить'**
  String get workoutSkipRest;

  /// No description provided for @workoutSetDone.
  ///
  /// In ru, this message translates to:
  /// **'✅  Подход выполнен!'**
  String get workoutSetDone;

  /// No description provided for @workoutExerciseDone.
  ///
  /// In ru, this message translates to:
  /// **'✅  Упражнение выполнено!'**
  String get workoutExerciseDone;

  /// No description provided for @workoutUnitReps.
  ///
  /// In ru, this message translates to:
  /// **'повт.'**
  String get workoutUnitReps;

  /// No description provided for @workoutNextExercise.
  ///
  /// In ru, this message translates to:
  /// **'Следующее: {name} • {amount} {unit}'**
  String workoutNextExercise(String name, int amount, String unit);

  /// No description provided for @workoutNextSet.
  ///
  /// In ru, this message translates to:
  /// **'Следующий: подход {setNum} • {amount} {unit}'**
  String workoutNextSet(int setNum, int amount, String unit);

  /// No description provided for @summaryTitle.
  ///
  /// In ru, this message translates to:
  /// **'Отличная тренировка!'**
  String get summaryTitle;

  /// No description provided for @summarySubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Так держать — ещё один шаг вперёд 💪'**
  String get summarySubtitle;

  /// No description provided for @summaryLabelTime.
  ///
  /// In ru, this message translates to:
  /// **'Время'**
  String get summaryLabelTime;

  /// No description provided for @summaryLabelExercises.
  ///
  /// In ru, this message translates to:
  /// **'Упр.'**
  String get summaryLabelExercises;

  /// No description provided for @summaryHome.
  ///
  /// In ru, this message translates to:
  /// **'Домой'**
  String get summaryHome;

  /// No description provided for @summaryFreezeUsedTitle.
  ///
  /// In ru, this message translates to:
  /// **'Заморозка сохранила стрик!'**
  String get summaryFreezeUsedTitle;

  /// No description provided for @summaryFreezeUsedBody.
  ///
  /// In ru, this message translates to:
  /// **'Серия продолжается — так держать'**
  String get summaryFreezeUsedBody;

  /// No description provided for @summaryFreezeEarnedTitle.
  ///
  /// In ru, this message translates to:
  /// **'Получена заморозка стрика!'**
  String get summaryFreezeEarnedTitle;

  /// No description provided for @summaryFreezeEarnedBody.
  ///
  /// In ru, this message translates to:
  /// **'Используй, если пропустишь день'**
  String get summaryFreezeEarnedBody;

  /// No description provided for @summaryChallengeUnlockedTitle.
  ///
  /// In ru, this message translates to:
  /// **'Испытание ждёт! 🏆'**
  String get summaryChallengeUnlockedTitle;

  /// No description provided for @summaryChallengeUnlockedBody.
  ///
  /// In ru, this message translates to:
  /// **'Нажми «Принять вызов» на главном экране когда будешь готов'**
  String get summaryChallengeUnlockedBody;

  /// No description provided for @summaryChallengePassedTitle.
  ///
  /// In ru, this message translates to:
  /// **'Новый этап! 🎉'**
  String get summaryChallengePassedTitle;

  /// No description provided for @summaryChallengePassedBody.
  ///
  /// In ru, this message translates to:
  /// **'Ты перешёл на: {exercise}'**
  String summaryChallengePassedBody(String exercise);

  /// No description provided for @profileTitle.
  ///
  /// In ru, this message translates to:
  /// **'Профиль'**
  String get profileTitle;

  /// No description provided for @profileMaxRank.
  ///
  /// In ru, this message translates to:
  /// **'Максимальный ранг!'**
  String get profileMaxRank;

  /// No description provided for @profileRankProgress.
  ///
  /// In ru, this message translates to:
  /// **'{remaining} SP до {rankName}'**
  String profileRankProgress(int remaining, String rankName);

  /// No description provided for @profileStatDays.
  ///
  /// In ru, this message translates to:
  /// **'дней'**
  String get profileStatDays;

  /// No description provided for @profileStatRecord.
  ///
  /// In ru, this message translates to:
  /// **'рекорд'**
  String get profileStatRecord;

  /// No description provided for @profileStatWorkouts.
  ///
  /// In ru, this message translates to:
  /// **'трен.'**
  String get profileStatWorkouts;

  /// No description provided for @profileStatFreezes.
  ///
  /// In ru, this message translates to:
  /// **'заморозок'**
  String get profileStatFreezes;

  /// No description provided for @profileHistoryTitle.
  ///
  /// In ru, this message translates to:
  /// **'История тренировок'**
  String get profileHistoryTitle;

  /// No description provided for @profileNoHistory.
  ///
  /// In ru, this message translates to:
  /// **'Ещё нет завершённых тренировок'**
  String get profileNoHistory;

  /// No description provided for @settingsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Настройки'**
  String get settingsTitle;

  /// No description provided for @settingsSectionNotifications.
  ///
  /// In ru, this message translates to:
  /// **'УВЕДОМЛЕНИЯ'**
  String get settingsSectionNotifications;

  /// No description provided for @settingsSectionLanguage.
  ///
  /// In ru, this message translates to:
  /// **'ЯЗЫК'**
  String get settingsSectionLanguage;

  /// No description provided for @settingsNotificationsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Включить уведомления'**
  String get settingsNotificationsTitle;

  /// No description provided for @settingsNotificationsSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Разрешить приложению присылать напоминания'**
  String get settingsNotificationsSubtitle;

  /// No description provided for @settingsNotificationTimeTitle.
  ///
  /// In ru, this message translates to:
  /// **'Время напоминания'**
  String get settingsNotificationTimeTitle;

  /// No description provided for @settingsNotificationTimeSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Утреннее напоминание потренироваться'**
  String get settingsNotificationTimeSubtitle;

  /// No description provided for @settingsTimePickerDone.
  ///
  /// In ru, this message translates to:
  /// **'Готово'**
  String get settingsTimePickerDone;

  /// No description provided for @settingsEveningReminderTitle.
  ///
  /// In ru, this message translates to:
  /// **'Вечерний дожим'**
  String get settingsEveningReminderTitle;

  /// No description provided for @settingsEveningReminderSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Напомнить вечером, если тренировка не выполнена'**
  String get settingsEveningReminderSubtitle;

  /// No description provided for @settingsStreakThreatTitle.
  ///
  /// In ru, this message translates to:
  /// **'Угроза стрику'**
  String get settingsStreakThreatTitle;

  /// No description provided for @settingsStreakThreatSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Предупредить, когда серия под угрозой'**
  String get settingsStreakThreatSubtitle;

  /// No description provided for @settingsLanguageTitle.
  ///
  /// In ru, this message translates to:
  /// **'Язык приложения'**
  String get settingsLanguageTitle;

  /// No description provided for @settingsSectionWorkout.
  ///
  /// In ru, this message translates to:
  /// **'ТРЕНИРОВКА'**
  String get settingsSectionWorkout;

  /// No description provided for @settingsWorkoutDurationTitle.
  ///
  /// In ru, this message translates to:
  /// **'Длительность сета'**
  String get settingsWorkoutDurationTitle;

  /// No description provided for @settingsWorkoutDurationSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Сколько минут уделять ежедневной тренировке'**
  String get settingsWorkoutDurationSubtitle;

  /// No description provided for @rankBeginner.
  ///
  /// In ru, this message translates to:
  /// **'Новичок'**
  String get rankBeginner;

  /// No description provided for @rankAmateur.
  ///
  /// In ru, this message translates to:
  /// **'Любитель'**
  String get rankAmateur;

  /// No description provided for @rankSportsman.
  ///
  /// In ru, this message translates to:
  /// **'Спортсмен'**
  String get rankSportsman;

  /// No description provided for @rankAthlete.
  ///
  /// In ru, this message translates to:
  /// **'Атлет'**
  String get rankAthlete;

  /// No description provided for @rankMaster.
  ///
  /// In ru, this message translates to:
  /// **'Мастер'**
  String get rankMaster;

  /// No description provided for @rankLegend.
  ///
  /// In ru, this message translates to:
  /// **'Легенда'**
  String get rankLegend;

  /// No description provided for @onboardingWelcomeTitle.
  ///
  /// In ru, this message translates to:
  /// **'Привет! Я Горо'**
  String get onboardingWelcomeTitle;

  /// No description provided for @onboardingWelcomeBody.
  ///
  /// In ru, this message translates to:
  /// **'Короткие сеты, прокачка навыков, стрики и очки.\nОт отжиманий с колен до стойки на руках — шаг за шагом.'**
  String get onboardingWelcomeBody;

  /// No description provided for @onboardingWelcomeCta.
  ///
  /// In ru, this message translates to:
  /// **'Настроим всё под тебя за 1 минуту'**
  String get onboardingWelcomeCta;

  /// No description provided for @onboardingContinue.
  ///
  /// In ru, this message translates to:
  /// **'Продолжить'**
  String get onboardingContinue;

  /// No description provided for @onboardingStart.
  ///
  /// In ru, this message translates to:
  /// **'Начать тренировку 🔥'**
  String get onboardingStart;

  /// No description provided for @onboardingQ1.
  ///
  /// In ru, this message translates to:
  /// **'Как часто ты занимаешься спортом?'**
  String get onboardingQ1;

  /// No description provided for @onboardingQ2.
  ///
  /// In ru, this message translates to:
  /// **'Сколько отжиманий ты можешь сделать?'**
  String get onboardingQ2;

  /// No description provided for @onboardingQ3.
  ///
  /// In ru, this message translates to:
  /// **'Сколько минут в день готов уделять?'**
  String get onboardingQ3;

  /// No description provided for @onboardingQ4.
  ///
  /// In ru, this message translates to:
  /// **'К чему ты стремишься?'**
  String get onboardingQ4;

  /// No description provided for @onboardingQ5.
  ///
  /// In ru, this message translates to:
  /// **'Во сколько напомнить о тренировке?'**
  String get onboardingQ5;

  /// No description provided for @frequencyNeverLabel.
  ///
  /// In ru, this message translates to:
  /// **'Никогда'**
  String get frequencyNeverLabel;

  /// No description provided for @frequencyNeverDesc.
  ///
  /// In ru, this message translates to:
  /// **'Только начинаю'**
  String get frequencyNeverDesc;

  /// No description provided for @frequencySometimesLabel.
  ///
  /// In ru, this message translates to:
  /// **'Иногда'**
  String get frequencySometimesLabel;

  /// No description provided for @frequencySometimesDesc.
  ///
  /// In ru, this message translates to:
  /// **'Тренируюсь время от времени'**
  String get frequencySometimesDesc;

  /// No description provided for @frequencyRegularLabel.
  ///
  /// In ru, this message translates to:
  /// **'Регулярно'**
  String get frequencyRegularLabel;

  /// No description provided for @frequencyRegularDesc.
  ///
  /// In ru, this message translates to:
  /// **'Занимаюсь несколько раз в неделю'**
  String get frequencyRegularDesc;

  /// No description provided for @pushupZeroDesc.
  ///
  /// In ru, this message translates to:
  /// **'Пока ни одного'**
  String get pushupZeroDesc;

  /// No description provided for @pushupOneToFiveDesc.
  ///
  /// In ru, this message translates to:
  /// **'Совсем немного'**
  String get pushupOneToFiveDesc;

  /// No description provided for @pushupFiveToFifteenDesc.
  ///
  /// In ru, this message translates to:
  /// **'Уже неплохо'**
  String get pushupFiveToFifteenDesc;

  /// No description provided for @pushupMoreThan15Desc.
  ///
  /// In ru, this message translates to:
  /// **'Отличная база'**
  String get pushupMoreThan15Desc;

  /// No description provided for @minutesLabel.
  ///
  /// In ru, this message translates to:
  /// **'{minutes} минут'**
  String minutesLabel(int minutes);

  /// No description provided for @minutesFiveDesc.
  ///
  /// In ru, this message translates to:
  /// **'Быстро и эффективно'**
  String get minutesFiveDesc;

  /// No description provided for @minutesTenDesc.
  ///
  /// In ru, this message translates to:
  /// **'Оптимальный вариант'**
  String get minutesTenDesc;

  /// No description provided for @minutesFifteenDesc.
  ///
  /// In ru, this message translates to:
  /// **'Полноценная тренировка'**
  String get minutesFifteenDesc;

  /// No description provided for @goalGeneralLabel.
  ///
  /// In ru, this message translates to:
  /// **'Общая форма'**
  String get goalGeneralLabel;

  /// No description provided for @goalGeneralDesc.
  ///
  /// In ru, this message translates to:
  /// **'Быть активным и здоровым'**
  String get goalGeneralDesc;

  /// No description provided for @goalStrengthLabel.
  ///
  /// In ru, this message translates to:
  /// **'Отжимания и сила'**
  String get goalStrengthLabel;

  /// No description provided for @goalStrengthDesc.
  ///
  /// In ru, this message translates to:
  /// **'Накачать грудь и трицепс'**
  String get goalStrengthDesc;

  /// No description provided for @goalCalisthenicsLabel.
  ///
  /// In ru, this message translates to:
  /// **'Калистеника'**
  String get goalCalisthenicsLabel;

  /// No description provided for @goalCalisthenicsDesc.
  ///
  /// In ru, this message translates to:
  /// **'Стойка на руках и трюки'**
  String get goalCalisthenicsDesc;

  /// No description provided for @timeOfDayMorning.
  ///
  /// In ru, this message translates to:
  /// **'Утро'**
  String get timeOfDayMorning;

  /// No description provided for @timeOfDayDay.
  ///
  /// In ru, this message translates to:
  /// **'День'**
  String get timeOfDayDay;

  /// No description provided for @timeOfDayLunch.
  ///
  /// In ru, this message translates to:
  /// **'Обед'**
  String get timeOfDayLunch;

  /// No description provided for @timeOfDayEvening.
  ///
  /// In ru, this message translates to:
  /// **'Вечер'**
  String get timeOfDayEvening;

  /// No description provided for @exercisePushS1WallPushupName.
  ///
  /// In ru, this message translates to:
  /// **'Отжимания от стены'**
  String get exercisePushS1WallPushupName;

  /// No description provided for @exercisePushS1WallPushupDesc.
  ///
  /// In ru, this message translates to:
  /// **'Встань на расстоянии шага от стены, упрись ладонями на уровне груди. Сгибай руки, пока грудь не коснётся стены, затем выпрямляй.'**
  String get exercisePushS1WallPushupDesc;

  /// No description provided for @exercisePushS1WallPushupTip.
  ///
  /// In ru, this message translates to:
  /// **'Держи тело прямым, не прогибай поясницу.'**
  String get exercisePushS1WallPushupTip;

  /// No description provided for @exercisePushS2KneePushupName.
  ///
  /// In ru, this message translates to:
  /// **'Отжимания с колен'**
  String get exercisePushS2KneePushupName;

  /// No description provided for @exercisePushS2KneePushupDesc.
  ///
  /// In ru, this message translates to:
  /// **'Упор лёжа с опорой на колени. Тело от колен до головы — прямая линия. Опускайся грудью к полу, затем выжимай.'**
  String get exercisePushS2KneePushupDesc;

  /// No description provided for @exercisePushS2KneePushupTip.
  ///
  /// In ru, this message translates to:
  /// **'Не опускай бёдра — держи прямую линию от колен до плеч.'**
  String get exercisePushS2KneePushupTip;

  /// No description provided for @exercisePushS3FullPushupName.
  ///
  /// In ru, this message translates to:
  /// **'Полные отжимания'**
  String get exercisePushS3FullPushupName;

  /// No description provided for @exercisePushS3FullPushupDesc.
  ///
  /// In ru, this message translates to:
  /// **'Классический упор лёжа. Тело — прямая линия от пяток до головы. Грудь касается пола или подходит на 2–3 см.'**
  String get exercisePushS3FullPushupDesc;

  /// No description provided for @exercisePushS3FullPushupTip.
  ///
  /// In ru, this message translates to:
  /// **'Напрягай пресс и ягодицы, чтобы не провисали бёдра.'**
  String get exercisePushS3FullPushupTip;

  /// No description provided for @exercisePushS4DiamondPushupName.
  ///
  /// In ru, this message translates to:
  /// **'Алмазные отжимания'**
  String get exercisePushS4DiamondPushupName;

  /// No description provided for @exercisePushS4DiamondPushupDesc.
  ///
  /// In ru, this message translates to:
  /// **'Руки под грудью, большие и указательные пальцы образуют ромб. Акцент на трицепс. Локти прижаты к корпусу при опускании.'**
  String get exercisePushS4DiamondPushupDesc;

  /// No description provided for @exercisePushS4DiamondPushupTip.
  ///
  /// In ru, this message translates to:
  /// **'Локти не разводи — они должны скользить вдоль тела.'**
  String get exercisePushS4DiamondPushupTip;

  /// No description provided for @exercisePushS5ArcherPushupName.
  ///
  /// In ru, this message translates to:
  /// **'Отжимания лучника'**
  String get exercisePushS5ArcherPushupName;

  /// No description provided for @exercisePushS5ArcherPushupDesc.
  ///
  /// In ru, this message translates to:
  /// **'Широкая постановка рук. Опускайся в сторону одной руки, держа вторую прямой. Поочерёдно на каждую сторону.'**
  String get exercisePushS5ArcherPushupDesc;

  /// No description provided for @exercisePushS5ArcherPushupTip.
  ///
  /// In ru, this message translates to:
  /// **'Рабочая рука — полный диапазон, прямая рука на полу — поддержка.'**
  String get exercisePushS5ArcherPushupTip;

  /// No description provided for @exercisePushS6OneArmPushupName.
  ///
  /// In ru, this message translates to:
  /// **'Отжимания на одной руке'**
  String get exercisePushS6OneArmPushupName;

  /// No description provided for @exercisePushS6OneArmPushupDesc.
  ///
  /// In ru, this message translates to:
  /// **'Одна рука за спиной или сбоку. Ноги шире плеч для баланса. Полный диапазон движения рабочей рукой.'**
  String get exercisePushS6OneArmPushupDesc;

  /// No description provided for @exercisePushS6OneArmPushupTip.
  ///
  /// In ru, this message translates to:
  /// **'Начинай с наклонной поверхности — так легче освоить технику.'**
  String get exercisePushS6OneArmPushupTip;

  /// No description provided for @exercisePushS7HandstandPushupName.
  ///
  /// In ru, this message translates to:
  /// **'Отжимания в стойке на руках'**
  String get exercisePushS7HandstandPushupName;

  /// No description provided for @exercisePushS7HandstandPushupDesc.
  ///
  /// In ru, this message translates to:
  /// **'Стойка на руках у стены (спиной). Медленно опускай голову к полу, затем выжимай корпус вверх.'**
  String get exercisePushS7HandstandPushupDesc;

  /// No description provided for @exercisePushS7HandstandPushupTip.
  ///
  /// In ru, this message translates to:
  /// **'Пальцы широко расставлены — так стабильнее. Взгляд между рук.'**
  String get exercisePushS7HandstandPushupTip;

  /// No description provided for @exerciseCoreS1CrunchesName.
  ///
  /// In ru, this message translates to:
  /// **'Скручивания'**
  String get exerciseCoreS1CrunchesName;

  /// No description provided for @exerciseCoreS1CrunchesDesc.
  ///
  /// In ru, this message translates to:
  /// **'Лёжа на спине, колени согнуты. Руки за головой или скрещены на груди. Отрывай лопатки от пола, сокращая пресс.'**
  String get exerciseCoreS1CrunchesDesc;

  /// No description provided for @exerciseCoreS1CrunchesTip.
  ///
  /// In ru, this message translates to:
  /// **'Не тяни шею руками — тяни грудью к потолку.'**
  String get exerciseCoreS1CrunchesTip;

  /// No description provided for @exerciseCoreS2PlankName.
  ///
  /// In ru, this message translates to:
  /// **'Планка'**
  String get exerciseCoreS2PlankName;

  /// No description provided for @exerciseCoreS2PlankDesc.
  ///
  /// In ru, this message translates to:
  /// **'Упор лёжа на предплечьях. Тело — прямая линия от пяток до головы. Не поднимай таз и не прогибай поясницу.'**
  String get exerciseCoreS2PlankDesc;

  /// No description provided for @exerciseCoreS2PlankTip.
  ///
  /// In ru, this message translates to:
  /// **'Напрягай пресс и ягодицы. Дыши ровно — не задерживай.'**
  String get exerciseCoreS2PlankTip;

  /// No description provided for @exerciseCoreS3LyingLegRaiseName.
  ///
  /// In ru, this message translates to:
  /// **'Подъёмы ног лёжа'**
  String get exerciseCoreS3LyingLegRaiseName;

  /// No description provided for @exerciseCoreS3LyingLegRaiseDesc.
  ///
  /// In ru, this message translates to:
  /// **'Лёжа на спине, руки под ягодицами. Прямые ноги поднимай до вертикали, затем медленно опускай не касаясь пола.'**
  String get exerciseCoreS3LyingLegRaiseDesc;

  /// No description provided for @exerciseCoreS3LyingLegRaiseTip.
  ///
  /// In ru, this message translates to:
  /// **'Поясница прижата к полу на протяжении всего движения.'**
  String get exerciseCoreS3LyingLegRaiseTip;

  /// No description provided for @exerciseCoreS4HangingLegRaiseName.
  ///
  /// In ru, this message translates to:
  /// **'Подъёмы ног в висе'**
  String get exerciseCoreS4HangingLegRaiseName;

  /// No description provided for @exerciseCoreS4HangingLegRaiseDesc.
  ///
  /// In ru, this message translates to:
  /// **'Повис на перекладине. Поднимай прямые ноги до параллели с полом или выше. Контролируй опускание.'**
  String get exerciseCoreS4HangingLegRaiseDesc;

  /// No description provided for @exerciseCoreS4HangingLegRaiseTip.
  ///
  /// In ru, this message translates to:
  /// **'Не раскачивайся — движение только за счёт пресса.'**
  String get exerciseCoreS4HangingLegRaiseTip;

  /// No description provided for @exerciseCoreS5LSitName.
  ///
  /// In ru, this message translates to:
  /// **'Уголок (L-sit)'**
  String get exerciseCoreS5LSitName;

  /// No description provided for @exerciseCoreS5LSitDesc.
  ///
  /// In ru, this message translates to:
  /// **'Упор на параллельных брусьях или полу. Ноги прямые, параллельны полу. Удерживай позицию как можно дольше.'**
  String get exerciseCoreS5LSitDesc;

  /// No description provided for @exerciseCoreS5LSitTip.
  ///
  /// In ru, this message translates to:
  /// **'Носки тяни на себя, плечи — вниз и назад.'**
  String get exerciseCoreS5LSitTip;

  /// No description provided for @exerciseCoreS6DragonFlagName.
  ///
  /// In ru, this message translates to:
  /// **'Драконовый флаг'**
  String get exerciseCoreS6DragonFlagName;

  /// No description provided for @exerciseCoreS6DragonFlagDesc.
  ///
  /// In ru, this message translates to:
  /// **'Лёжа на скамье, держись за опору за головой. Подними тело в прямую линию на лопатках, затем медленно опускай.'**
  String get exerciseCoreS6DragonFlagDesc;

  /// No description provided for @exerciseCoreS6DragonFlagTip.
  ///
  /// In ru, this message translates to:
  /// **'Начинай с негативной фазы (только опускание) — это проще.'**
  String get exerciseCoreS6DragonFlagTip;

  /// No description provided for @exerciseWarmupArmRotationsName.
  ///
  /// In ru, this message translates to:
  /// **'Круговые вращения руками'**
  String get exerciseWarmupArmRotationsName;

  /// No description provided for @exerciseWarmupArmRotationsDesc.
  ///
  /// In ru, this message translates to:
  /// **'Стоя, делай большие круговые движения руками вперёд и назад. Разминает плечевой пояс перед отжиманиями.'**
  String get exerciseWarmupArmRotationsDesc;

  /// No description provided for @exerciseWarmupJumpingJacksName.
  ///
  /// In ru, this message translates to:
  /// **'Прыжки «Ноги вместе — врозь»'**
  String get exerciseWarmupJumpingJacksName;

  /// No description provided for @exerciseWarmupJumpingJacksDesc.
  ///
  /// In ru, this message translates to:
  /// **'Классические jumping jacks. Повышают пульс и разогревают всё тело за 30–60 секунд.'**
  String get exerciseWarmupJumpingJacksDesc;

  /// No description provided for @exerciseCooldownShoulderStretchName.
  ///
  /// In ru, this message translates to:
  /// **'Растяжка плеч и груди'**
  String get exerciseCooldownShoulderStretchName;

  /// No description provided for @exerciseCooldownShoulderStretchDesc.
  ///
  /// In ru, this message translates to:
  /// **'Заведи руки за спину, сцепи пальцы и потяни плечи назад-вниз. Удержи 30 секунд.'**
  String get exerciseCooldownShoulderStretchDesc;

  /// No description provided for @exerciseCooldownCatCowName.
  ///
  /// In ru, this message translates to:
  /// **'Кошка-корова'**
  String get exerciseCooldownCatCowName;

  /// No description provided for @exerciseCooldownCatCowDesc.
  ///
  /// In ru, this message translates to:
  /// **'На четвереньках: на вдохе прогибай спину вниз (корова), на выдохе округляй вверх (кошка). Расслабляет поясницу и пресс.'**
  String get exerciseCooldownCatCowDesc;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
