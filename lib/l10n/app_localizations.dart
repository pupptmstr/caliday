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

  /// No description provided for @navHome.
  ///
  /// In ru, this message translates to:
  /// **'Тренировка'**
  String get navHome;

  /// No description provided for @navProgress.
  ///
  /// In ru, this message translates to:
  /// **'Прогресс'**
  String get navProgress;

  /// No description provided for @navProfile.
  ///
  /// In ru, this message translates to:
  /// **'Профиль'**
  String get navProfile;

  /// No description provided for @progressTitle.
  ///
  /// In ru, this message translates to:
  /// **'Мой прогресс'**
  String get progressTitle;

  /// No description provided for @progressInfo.
  ///
  /// In ru, this message translates to:
  /// **'Просто тренируйтесь — приложение само продвигает вас вперёд по веткам. Здесь можно отследить пройденный путь. А если чувствуете, что готовы к большему раньше времени — принимайте Испытание и переходите сами.'**
  String get progressInfo;

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

  /// No description provided for @homeBranchPull.
  ///
  /// In ru, this message translates to:
  /// **'Тяга'**
  String get homeBranchPull;

  /// No description provided for @homeBranchCore.
  ///
  /// In ru, this message translates to:
  /// **'Кор'**
  String get homeBranchCore;

  /// No description provided for @homeBranchLegs.
  ///
  /// In ru, this message translates to:
  /// **'Ноги'**
  String get homeBranchLegs;

  /// No description provided for @homeBranchBalance.
  ///
  /// In ru, this message translates to:
  /// **'Баланс'**
  String get homeBranchBalance;

  /// No description provided for @branchJourneyProgress.
  ///
  /// In ru, this message translates to:
  /// **'Пройдено {done} из {total} этапов'**
  String branchJourneyProgress(int done, int total);

  /// No description provided for @branchJourneyStageCompleted.
  ///
  /// In ru, this message translates to:
  /// **'✓ Пройдено'**
  String get branchJourneyStageCompleted;

  /// No description provided for @branchJourneyStageCurrent.
  ///
  /// In ru, this message translates to:
  /// **'Текущий этап'**
  String get branchJourneyStageCurrent;

  /// No description provided for @branchJourneyStageLocked.
  ///
  /// In ru, this message translates to:
  /// **'Заблокировано'**
  String get branchJourneyStageLocked;

  /// No description provided for @branchJourneyParams.
  ///
  /// In ru, this message translates to:
  /// **'{reps} повт. × {sets} подх.  ·  Отдых {rest} с'**
  String branchJourneyParams(int reps, int sets, int rest);

  /// No description provided for @branchJourneyParamsTimed.
  ///
  /// In ru, this message translates to:
  /// **'{secs} с × {sets} подх.  ·  Отдых {rest} с'**
  String branchJourneyParamsTimed(int secs, int sets, int rest);

  /// No description provided for @branchJourneyStartChallenge.
  ///
  /// In ru, this message translates to:
  /// **'Пройти испытание'**
  String get branchJourneyStartChallenge;

  /// No description provided for @homeStage.
  ///
  /// In ru, this message translates to:
  /// **'Этап {stage}/{total}'**
  String homeStage(int stage, int total);

  /// No description provided for @homeChallengeUnlocked.
  ///
  /// In ru, this message translates to:
  /// **'Испытание доступно'**
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

  /// No description provided for @homeWorkoutAgain.
  ///
  /// In ru, this message translates to:
  /// **'Ещё раз'**
  String get homeWorkoutAgain;

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
  /// **'Так держать — ещё один шаг вперёд'**
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

  /// No description provided for @achievementsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Достижения'**
  String get achievementsTitle;

  /// No description provided for @achievementsEarnedSection.
  ///
  /// In ru, this message translates to:
  /// **'Получено'**
  String get achievementsEarnedSection;

  /// No description provided for @achievementsLockedSection.
  ///
  /// In ru, this message translates to:
  /// **'Заблокировано'**
  String get achievementsLockedSection;

  /// No description provided for @achievementsSecret.
  ///
  /// In ru, this message translates to:
  /// **'???'**
  String get achievementsSecret;

  /// No description provided for @achievementsSecretDesc.
  ///
  /// In ru, this message translates to:
  /// **'Выполни особое условие, чтобы раскрыть'**
  String get achievementsSecretDesc;

  /// No description provided for @achievementsEarnedOn.
  ///
  /// In ru, this message translates to:
  /// **'Получено: {date}'**
  String achievementsEarnedOn(String date);

  /// No description provided for @profileAchievementsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Достижения'**
  String get profileAchievementsTitle;

  /// No description provided for @profileAchievementsAll.
  ///
  /// In ru, this message translates to:
  /// **'Все достижения →'**
  String get profileAchievementsAll;

  /// No description provided for @profileNoAchievements.
  ///
  /// In ru, this message translates to:
  /// **'Ещё нет достижений'**
  String get profileNoAchievements;

  /// No description provided for @summaryAchievementsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Новые достижения!'**
  String get summaryAchievementsTitle;

  /// No description provided for @achievementFirstWorkoutName.
  ///
  /// In ru, this message translates to:
  /// **'Первый шаг'**
  String get achievementFirstWorkoutName;

  /// No description provided for @achievementFirstWorkoutDesc.
  ///
  /// In ru, this message translates to:
  /// **'Ты сделал первую тренировку — начало положено!'**
  String get achievementFirstWorkoutDesc;

  /// No description provided for @achievementFirstChallengeName.
  ///
  /// In ru, this message translates to:
  /// **'Принял вызов'**
  String get achievementFirstChallengeName;

  /// No description provided for @achievementFirstChallengeDesc.
  ///
  /// In ru, this message translates to:
  /// **'Первый пройденный Challenge — теперь ты знаешь, на что способен'**
  String get achievementFirstChallengeDesc;

  /// No description provided for @achievementStreak3Name.
  ///
  /// In ru, this message translates to:
  /// **'Три в ряд'**
  String get achievementStreak3Name;

  /// No description provided for @achievementStreak3Desc.
  ///
  /// In ru, this message translates to:
  /// **'3 дня подряд без пропусков — привычка начинает формироваться'**
  String get achievementStreak3Desc;

  /// No description provided for @achievementStreak7Name.
  ///
  /// In ru, this message translates to:
  /// **'Неделя без пропусков'**
  String get achievementStreak7Name;

  /// No description provided for @achievementStreak7Desc.
  ///
  /// In ru, this message translates to:
  /// **'Целая неделя — ты уже выше большинства'**
  String get achievementStreak7Desc;

  /// No description provided for @achievementStreak30Name.
  ///
  /// In ru, this message translates to:
  /// **'Марафонец'**
  String get achievementStreak30Name;

  /// No description provided for @achievementStreak30Desc.
  ///
  /// In ru, this message translates to:
  /// **'30 дней подряд — это настоящая дисциплина'**
  String get achievementStreak30Desc;

  /// No description provided for @achievementStreak100Name.
  ///
  /// In ru, this message translates to:
  /// **'Железная воля'**
  String get achievementStreak100Name;

  /// No description provided for @achievementStreak100Desc.
  ///
  /// In ru, this message translates to:
  /// **'100 дней без пропусков — легендарное достижение'**
  String get achievementStreak100Desc;

  /// No description provided for @achievementWorkouts10Name.
  ///
  /// In ru, this message translates to:
  /// **'Десятка'**
  String get achievementWorkouts10Name;

  /// No description provided for @achievementWorkouts10Desc.
  ///
  /// In ru, this message translates to:
  /// **'10 завершённых тренировок — твёрдый старт'**
  String get achievementWorkouts10Desc;

  /// No description provided for @achievementWorkouts50Name.
  ///
  /// In ru, this message translates to:
  /// **'Полсотни'**
  String get achievementWorkouts50Name;

  /// No description provided for @achievementWorkouts50Desc.
  ///
  /// In ru, this message translates to:
  /// **'50 тренировок — ты серьёзно настроен'**
  String get achievementWorkouts50Desc;

  /// No description provided for @achievementWorkouts100Name.
  ///
  /// In ru, this message translates to:
  /// **'Центурион'**
  String get achievementWorkouts100Name;

  /// No description provided for @achievementWorkouts100Desc.
  ///
  /// In ru, this message translates to:
  /// **'100 тренировок — ты в элите'**
  String get achievementWorkouts100Desc;

  /// No description provided for @achievementRankAmateurName.
  ///
  /// In ru, this message translates to:
  /// **'Любитель'**
  String get achievementRankAmateurName;

  /// No description provided for @achievementRankAmateurDesc.
  ///
  /// In ru, this message translates to:
  /// **'Достигнут ранг Любитель — SP накапливаются'**
  String get achievementRankAmateurDesc;

  /// No description provided for @achievementRankSportsmanName.
  ///
  /// In ru, this message translates to:
  /// **'Спортсмен'**
  String get achievementRankSportsmanName;

  /// No description provided for @achievementRankSportsmanDesc.
  ///
  /// In ru, this message translates to:
  /// **'Ранг Спортсмен — ты уже не просто любитель'**
  String get achievementRankSportsmanDesc;

  /// No description provided for @achievementRankAthleteName.
  ///
  /// In ru, this message translates to:
  /// **'Атлет'**
  String get achievementRankAthleteName;

  /// No description provided for @achievementRankAthleteDesc.
  ///
  /// In ru, this message translates to:
  /// **'Ранг Атлет — серьёзный уровень'**
  String get achievementRankAthleteDesc;

  /// No description provided for @achievementRankMasterName.
  ///
  /// In ru, this message translates to:
  /// **'Мастер'**
  String get achievementRankMasterName;

  /// No description provided for @achievementRankMasterDesc.
  ///
  /// In ru, this message translates to:
  /// **'Ранг Мастер — единицы добираются сюда'**
  String get achievementRankMasterDesc;

  /// No description provided for @achievementRankLegendName.
  ///
  /// In ru, this message translates to:
  /// **'Легенда'**
  String get achievementRankLegendName;

  /// No description provided for @achievementRankLegendDesc.
  ///
  /// In ru, this message translates to:
  /// **'Максимальный ранг. Ты — легенда.'**
  String get achievementRankLegendDesc;

  /// No description provided for @achievementPushS3Name.
  ///
  /// In ru, this message translates to:
  /// **'Полное отжимание'**
  String get achievementPushS3Name;

  /// No description provided for @achievementPushS3Desc.
  ///
  /// In ru, this message translates to:
  /// **'Освоены классические отжимания от пола'**
  String get achievementPushS3Desc;

  /// No description provided for @achievementPushS6Name.
  ///
  /// In ru, this message translates to:
  /// **'Лучник'**
  String get achievementPushS6Name;

  /// No description provided for @achievementPushS6Desc.
  ///
  /// In ru, this message translates to:
  /// **'Освоил отжимания лучника — до стойки на руках рукой подать'**
  String get achievementPushS6Desc;

  /// No description provided for @achievementPushCompleteName.
  ///
  /// In ru, this message translates to:
  /// **'Властелин Push'**
  String get achievementPushCompleteName;

  /// No description provided for @achievementPushCompleteDesc.
  ///
  /// In ru, this message translates to:
  /// **'Все 7 этапов Push пройдены. Горо гордится.'**
  String get achievementPushCompleteDesc;

  /// No description provided for @achievementCoreS2Name.
  ///
  /// In ru, this message translates to:
  /// **'Железная доска'**
  String get achievementCoreS2Name;

  /// No description provided for @achievementCoreS2Desc.
  ///
  /// In ru, this message translates to:
  /// **'Планка освоена — основа всего кора'**
  String get achievementCoreS2Desc;

  /// No description provided for @achievementCoreS5Name.
  ///
  /// In ru, this message translates to:
  /// **'Уголок'**
  String get achievementCoreS5Name;

  /// No description provided for @achievementCoreS5Desc.
  ///
  /// In ru, this message translates to:
  /// **'L-sit — истинная проверка силы пресса'**
  String get achievementCoreS5Desc;

  /// No description provided for @achievementCoreCompleteName.
  ///
  /// In ru, this message translates to:
  /// **'Железный кор'**
  String get achievementCoreCompleteName;

  /// No description provided for @achievementCoreCompleteDesc.
  ///
  /// In ru, this message translates to:
  /// **'Все 6 этапов Core пройдены. Твой кор — как сталь.'**
  String get achievementCoreCompleteDesc;

  /// No description provided for @achievementPullS3Name.
  ///
  /// In ru, this message translates to:
  /// **'Первое подтягивание'**
  String get achievementPullS3Name;

  /// No description provided for @achievementPullS3Desc.
  ///
  /// In ru, this message translates to:
  /// **'Подбородок выше перекладины — это победа'**
  String get achievementPullS3Desc;

  /// No description provided for @achievementPullCompleteName.
  ///
  /// In ru, this message translates to:
  /// **'Король перекладины'**
  String get achievementPullCompleteName;

  /// No description provided for @achievementPullCompleteDesc.
  ///
  /// In ru, this message translates to:
  /// **'Все 6 этапов Pull пройдены. Ты повелеваешь перекладиной.'**
  String get achievementPullCompleteDesc;

  /// No description provided for @achievementLegsS5Name.
  ///
  /// In ru, this message translates to:
  /// **'Пистолетик'**
  String get achievementLegsS5Name;

  /// No description provided for @achievementLegsS5Desc.
  ///
  /// In ru, this message translates to:
  /// **'Приседание на одной ноге — баланс и сила'**
  String get achievementLegsS5Desc;

  /// No description provided for @achievementLegsCompleteName.
  ///
  /// In ru, this message translates to:
  /// **'Стальные ноги'**
  String get achievementLegsCompleteName;

  /// No description provided for @achievementLegsCompleteDesc.
  ///
  /// In ru, this message translates to:
  /// **'Все 5 этапов Legs пройдены. Твои ноги из стали.'**
  String get achievementLegsCompleteDesc;

  /// No description provided for @achievementBalanceS4Name.
  ///
  /// In ru, this message translates to:
  /// **'Поза ворона'**
  String get achievementBalanceS4Name;

  /// No description provided for @achievementBalanceS4Desc.
  ///
  /// In ru, this message translates to:
  /// **'Kakasana держится — ты управляешь балансом'**
  String get achievementBalanceS4Desc;

  /// No description provided for @achievementBalanceS6Name.
  ///
  /// In ru, this message translates to:
  /// **'Свободная стойка'**
  String get achievementBalanceS6Name;

  /// No description provided for @achievementBalanceS6Desc.
  ///
  /// In ru, this message translates to:
  /// **'Стойка на руках без стены — вершина баланса'**
  String get achievementBalanceS6Desc;

  /// No description provided for @achievementBalanceCompleteName.
  ///
  /// In ru, this message translates to:
  /// **'Мастер равновесия'**
  String get achievementBalanceCompleteName;

  /// No description provided for @achievementBalanceCompleteDesc.
  ///
  /// In ru, this message translates to:
  /// **'Все 6 этапов Balance пройдены. Ты — эквилибрист.'**
  String get achievementBalanceCompleteDesc;

  /// No description provided for @achievementAllCompleteName.
  ///
  /// In ru, this message translates to:
  /// **'Полный комплект'**
  String get achievementAllCompleteName;

  /// No description provided for @achievementAllCompleteDesc.
  ///
  /// In ru, this message translates to:
  /// **'Все 5 веток пройдены до конца. Абсолютный чемпион.'**
  String get achievementAllCompleteDesc;

  /// No description provided for @summaryBonusTitle.
  ///
  /// In ru, this message translates to:
  /// **'Бонусная тренировка'**
  String get summaryBonusTitle;

  /// No description provided for @summaryBonusBody.
  ///
  /// In ru, this message translates to:
  /// **'×½ SP · прогрессия уже сохранена'**
  String get summaryBonusBody;

  /// No description provided for @summaryBonusCount.
  ///
  /// In ru, this message translates to:
  /// **'Сегодня ты уже потренировался {count} раза!'**
  String summaryBonusCount(int count);

  /// No description provided for @summaryChallengeUnlockedTitle.
  ///
  /// In ru, this message translates to:
  /// **'Испытание ждёт!'**
  String get summaryChallengeUnlockedTitle;

  /// No description provided for @summaryChallengeUnlockedBody.
  ///
  /// In ru, this message translates to:
  /// **'Нажми «Принять вызов» на главном экране когда будешь готов'**
  String get summaryChallengeUnlockedBody;

  /// No description provided for @summaryChallengePassedTitle.
  ///
  /// In ru, this message translates to:
  /// **'Новый этап!'**
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

  /// No description provided for @historyTypeDaily.
  ///
  /// In ru, this message translates to:
  /// **'Тренировка дня'**
  String get historyTypeDaily;

  /// No description provided for @historyTypeChallenge.
  ///
  /// In ru, this message translates to:
  /// **'Испытание'**
  String get historyTypeChallenge;

  /// No description provided for @historyTypeBonus.
  ///
  /// In ru, this message translates to:
  /// **'Бонусная'**
  String get historyTypeBonus;

  /// No description provided for @historyDetailExercises.
  ///
  /// In ru, this message translates to:
  /// **'Упражнения'**
  String get historyDetailExercises;

  /// No description provided for @historyDetailReps.
  ///
  /// In ru, this message translates to:
  /// **'{completed} / {target} повт.'**
  String historyDetailReps(int completed, int target);

  /// No description provided for @historyDetailSec.
  ///
  /// In ru, this message translates to:
  /// **'{completed} / {target} сек'**
  String historyDetailSec(int completed, int target);

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

  /// No description provided for @settingsSectionTheme.
  ///
  /// In ru, this message translates to:
  /// **'ТЕМА'**
  String get settingsSectionTheme;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In ru, this message translates to:
  /// **'Системная'**
  String get settingsThemeSystem;

  /// No description provided for @settingsThemeLight.
  ///
  /// In ru, this message translates to:
  /// **'Светлая'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In ru, this message translates to:
  /// **'Тёмная'**
  String get settingsThemeDark;

  /// No description provided for @settingsSectionEquipment.
  ///
  /// In ru, this message translates to:
  /// **'ОБОРУДОВАНИЕ'**
  String get settingsSectionEquipment;

  /// No description provided for @settingsEquipmentPullUpBar.
  ///
  /// In ru, this message translates to:
  /// **'Турник дома'**
  String get settingsEquipmentPullUpBar;

  /// No description provided for @settingsEquipmentPullUpBarSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Открывает ветку прогрессии «Тяга»'**
  String get settingsEquipmentPullUpBarSubtitle;

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

  /// No description provided for @settingsSoundTitle.
  ///
  /// In ru, this message translates to:
  /// **'Звуки'**
  String get settingsSoundTitle;

  /// No description provided for @settingsSoundSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Звуки обратной связи во время тренировки'**
  String get settingsSoundSubtitle;

  /// No description provided for @settingsHapticTitle.
  ///
  /// In ru, this message translates to:
  /// **'Вибрация'**
  String get settingsHapticTitle;

  /// No description provided for @settingsHapticSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Тактильные сигналы во время тренировки'**
  String get settingsHapticSubtitle;

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
  /// **'Есть ли у тебя турник или кольца дома?'**
  String get onboardingQ5;

  /// No description provided for @onboardingEquipmentYes.
  ///
  /// In ru, this message translates to:
  /// **'Да, есть'**
  String get onboardingEquipmentYes;

  /// No description provided for @onboardingEquipmentNo.
  ///
  /// In ru, this message translates to:
  /// **'Нет'**
  String get onboardingEquipmentNo;

  /// No description provided for @onboardingQ6.
  ///
  /// In ru, this message translates to:
  /// **'Во сколько напомнить о тренировке?'**
  String get onboardingQ6;

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

  /// No description provided for @exercisePushS5WidePushupName.
  ///
  /// In ru, this message translates to:
  /// **'Широкие отжимания'**
  String get exercisePushS5WidePushupName;

  /// No description provided for @exercisePushS5WidePushupDesc.
  ///
  /// In ru, this message translates to:
  /// **'Руки значительно шире плеч. Опускайся медленно, сохраняя прямую линию тела. Оба трицепса и грудь работают в широкой амплитуде.'**
  String get exercisePushS5WidePushupDesc;

  /// No description provided for @exercisePushS5WidePushupTip.
  ///
  /// In ru, this message translates to:
  /// **'Чем шире руки — тем больше нагрузка на грудь и меньше на трицепс.'**
  String get exercisePushS5WidePushupTip;

  /// No description provided for @exercisePushS6ArcherPushupName.
  ///
  /// In ru, this message translates to:
  /// **'Отжимания лучника'**
  String get exercisePushS6ArcherPushupName;

  /// No description provided for @exercisePushS6ArcherPushupDesc.
  ///
  /// In ru, this message translates to:
  /// **'Широкая постановка рук. Опускайся в сторону одной руки, держа вторую прямой. Поочерёдно на каждую сторону.'**
  String get exercisePushS6ArcherPushupDesc;

  /// No description provided for @exercisePushS6ArcherPushupTip.
  ///
  /// In ru, this message translates to:
  /// **'Рабочая рука — полный диапазон, прямая рука на полу — поддержка.'**
  String get exercisePushS6ArcherPushupTip;

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

  /// No description provided for @exercisePullS1AustralianName.
  ///
  /// In ru, this message translates to:
  /// **'Австралийское подтягивание'**
  String get exercisePullS1AustralianName;

  /// No description provided for @exercisePullS1AustralianDesc.
  ///
  /// In ru, this message translates to:
  /// **'Лёжа под перекладиной, хват чуть шире плеч. Тяни грудь к перекладине, держа тело прямой линией. Контролируй опускание.'**
  String get exercisePullS1AustralianDesc;

  /// No description provided for @exercisePullS1AustralianTip.
  ///
  /// In ru, this message translates to:
  /// **'Чем ниже опускаешь перекладину, тем сложнее упражнение.'**
  String get exercisePullS1AustralianTip;

  /// No description provided for @exercisePullS2NegativeName.
  ///
  /// In ru, this message translates to:
  /// **'Негативные подтягивания'**
  String get exercisePullS2NegativeName;

  /// No description provided for @exercisePullS2NegativeDesc.
  ///
  /// In ru, this message translates to:
  /// **'Запрыгни на перекладину с подбородком выше неё. Медленно опускайся в течение 3–5 секунд до полного выпрямления рук.'**
  String get exercisePullS2NegativeDesc;

  /// No description provided for @exercisePullS2NegativeTip.
  ///
  /// In ru, this message translates to:
  /// **'Чем медленнее опускаешься — тем лучше. Цель: 5 сек вниз.'**
  String get exercisePullS2NegativeTip;

  /// No description provided for @exercisePullS3PullupName.
  ///
  /// In ru, this message translates to:
  /// **'Подтягивания'**
  String get exercisePullS3PullupName;

  /// No description provided for @exercisePullS3PullupDesc.
  ///
  /// In ru, this message translates to:
  /// **'Хват на ширине плеч или чуть шире. Тяни грудь к перекладине, пока подбородок не окажется выше неё. Полностью выпрямляй руки внизу.'**
  String get exercisePullS3PullupDesc;

  /// No description provided for @exercisePullS3PullupTip.
  ///
  /// In ru, this message translates to:
  /// **'Сводя лопатки — тянешь спиной, а не руками.'**
  String get exercisePullS3PullupTip;

  /// No description provided for @exercisePullS4CloseGripName.
  ///
  /// In ru, this message translates to:
  /// **'Подтягивания узким хватом'**
  String get exercisePullS4CloseGripName;

  /// No description provided for @exercisePullS4CloseGripDesc.
  ///
  /// In ru, this message translates to:
  /// **'Хват уже плеч, ладони к себе или от себя. Акцент на бицепс и нижнюю часть широчайших. Подтягивай грудь к перекладине.'**
  String get exercisePullS4CloseGripDesc;

  /// No description provided for @exercisePullS4CloseGripTip.
  ///
  /// In ru, this message translates to:
  /// **'Локти прижимай к корпусу для максимальной нагрузки на бицепс.'**
  String get exercisePullS4CloseGripTip;

  /// No description provided for @exercisePullS5ArcherName.
  ///
  /// In ru, this message translates to:
  /// **'Подтягивания лучника'**
  String get exercisePullS5ArcherName;

  /// No description provided for @exercisePullS5ArcherDesc.
  ///
  /// In ru, this message translates to:
  /// **'Широкий хват. Тяни тело в сторону одной руки, вторую держи прямой. Поочерёдно на каждую сторону.'**
  String get exercisePullS5ArcherDesc;

  /// No description provided for @exercisePullS5ArcherTip.
  ///
  /// In ru, this message translates to:
  /// **'Прямая рука — вспомогательная, рабочая — полный диапазон.'**
  String get exercisePullS5ArcherTip;

  /// No description provided for @exercisePullS6OneArmName.
  ///
  /// In ru, this message translates to:
  /// **'Подтягивание на одной руке'**
  String get exercisePullS6OneArmName;

  /// No description provided for @exercisePullS6OneArmDesc.
  ///
  /// In ru, this message translates to:
  /// **'Одна рука держит перекладину, вторая — на запястье или свободна. Полный диапазон движения рабочей рукой.'**
  String get exercisePullS6OneArmDesc;

  /// No description provided for @exercisePullS6OneArmTip.
  ///
  /// In ru, this message translates to:
  /// **'Держи корпус стабильным — не раскачивайся.'**
  String get exercisePullS6OneArmTip;

  /// No description provided for @exerciseWarmupDeadHangName.
  ///
  /// In ru, this message translates to:
  /// **'Вис на перекладине'**
  String get exerciseWarmupDeadHangName;

  /// No description provided for @exerciseWarmupDeadHangDesc.
  ///
  /// In ru, this message translates to:
  /// **'Повисни на перекладине прямым хватом, руки полностью выпрямлены. Расслабь плечи и удержи вис.'**
  String get exerciseWarmupDeadHangDesc;

  /// No description provided for @exerciseCooldownLatStretchName.
  ///
  /// In ru, this message translates to:
  /// **'Растяжка широчайших'**
  String get exerciseCooldownLatStretchName;

  /// No description provided for @exerciseCooldownLatStretchDesc.
  ///
  /// In ru, this message translates to:
  /// **'Встань боком к стене, подними руку вверх и упрись в стену. Наклонись в сторону, чувствуя растяжку сбоку.'**
  String get exerciseCooldownLatStretchDesc;

  /// No description provided for @exerciseLegsS1SquatName.
  ///
  /// In ru, this message translates to:
  /// **'Приседания'**
  String get exerciseLegsS1SquatName;

  /// No description provided for @exerciseLegsS1SquatDesc.
  ///
  /// In ru, this message translates to:
  /// **'Ноги на ширине плеч, носки чуть развёрнуты. Приседай до параллели бёдер с полом, колени над носками. Выпрямляй ноги в верхней точке.'**
  String get exerciseLegsS1SquatDesc;

  /// No description provided for @exerciseLegsS1SquatTip.
  ///
  /// In ru, this message translates to:
  /// **'Пятки не отрывай от пола, грудь держи прямо.'**
  String get exerciseLegsS1SquatTip;

  /// No description provided for @exerciseLegsS2LungeName.
  ///
  /// In ru, this message translates to:
  /// **'Выпады'**
  String get exerciseLegsS2LungeName;

  /// No description provided for @exerciseLegsS2LungeDesc.
  ///
  /// In ru, this message translates to:
  /// **'Шаг вперёд, опусти заднее колено к полу, не касаясь. Оба колена под углом 90°. Оттолкнись передней ногой и вернись в исходное.'**
  String get exerciseLegsS2LungeDesc;

  /// No description provided for @exerciseLegsS2LungeTip.
  ///
  /// In ru, this message translates to:
  /// **'Переднее колено не уходи за носок.'**
  String get exerciseLegsS2LungeTip;

  /// No description provided for @exerciseLegsS3BulgarianName.
  ///
  /// In ru, this message translates to:
  /// **'Болгарские сплит-приседания'**
  String get exerciseLegsS3BulgarianName;

  /// No description provided for @exerciseLegsS3BulgarianDesc.
  ///
  /// In ru, this message translates to:
  /// **'Задняя нога на возвышении (стул, диван). Опускай переднюю ногу до параллели бедра с полом. Торс прямой.'**
  String get exerciseLegsS3BulgarianDesc;

  /// No description provided for @exerciseLegsS3BulgarianTip.
  ///
  /// In ru, this message translates to:
  /// **'Чем дальше передняя нога — тем больше нагрузка на ягодицы.'**
  String get exerciseLegsS3BulgarianTip;

  /// No description provided for @exerciseLegsS4AssistedPistolName.
  ///
  /// In ru, this message translates to:
  /// **'Пистолетик с опорой'**
  String get exerciseLegsS4AssistedPistolName;

  /// No description provided for @exerciseLegsS4AssistedPistolDesc.
  ///
  /// In ru, this message translates to:
  /// **'Держись за дверной косяк или стойку. Приседай на одной ноге, вторую держи прямой перед собой. Опора снижает нагрузку.'**
  String get exerciseLegsS4AssistedPistolDesc;

  /// No description provided for @exerciseLegsS4AssistedPistolTip.
  ///
  /// In ru, this message translates to:
  /// **'Постепенно уменьшай помощь рук по мере роста силы.'**
  String get exerciseLegsS4AssistedPistolTip;

  /// No description provided for @exerciseLegsS5PistolName.
  ///
  /// In ru, this message translates to:
  /// **'Пистолетик'**
  String get exerciseLegsS5PistolName;

  /// No description provided for @exerciseLegsS5PistolDesc.
  ///
  /// In ru, this message translates to:
  /// **'Приседание на одной ноге без опоры. Вторая нога прямая перед собой. Полная амплитуда до пола и обратно.'**
  String get exerciseLegsS5PistolDesc;

  /// No description provided for @exerciseLegsS5PistolTip.
  ///
  /// In ru, this message translates to:
  /// **'Руки вперёд для противовеса — помогает с балансом.'**
  String get exerciseLegsS5PistolTip;

  /// No description provided for @exerciseWarmupLegSwingsName.
  ///
  /// In ru, this message translates to:
  /// **'Махи ногами'**
  String get exerciseWarmupLegSwingsName;

  /// No description provided for @exerciseWarmupLegSwingsDesc.
  ///
  /// In ru, this message translates to:
  /// **'Стоя у стены, делай маховые движения прямой ногой вперёд-назад и в стороны. Разминает тазобедренный сустав.'**
  String get exerciseWarmupLegSwingsDesc;

  /// No description provided for @exerciseCooldownQuadStretchName.
  ///
  /// In ru, this message translates to:
  /// **'Растяжка квадрицепса'**
  String get exerciseCooldownQuadStretchName;

  /// No description provided for @exerciseCooldownQuadStretchDesc.
  ///
  /// In ru, this message translates to:
  /// **'Стоя на одной ноге, согни вторую назад и удержи стопу рукой. Почувствуй растяжку передней поверхности бедра.'**
  String get exerciseCooldownQuadStretchDesc;

  /// No description provided for @exerciseBalS1OneLegStandName.
  ///
  /// In ru, this message translates to:
  /// **'Стойка на одной ноге'**
  String get exerciseBalS1OneLegStandName;

  /// No description provided for @exerciseBalS1OneLegStandDesc.
  ///
  /// In ru, this message translates to:
  /// **'Стой на одной ноге, вторую слегка согни и удержи в воздухе. Руки можно держать в стороны для баланса.'**
  String get exerciseBalS1OneLegStandDesc;

  /// No description provided for @exerciseBalS1OneLegStandTip.
  ///
  /// In ru, this message translates to:
  /// **'Фиксируй взгляд на точке — это сильно улучшает баланс.'**
  String get exerciseBalS1OneLegStandTip;

  /// No description provided for @exerciseBalS2OneArmPlankName.
  ///
  /// In ru, this message translates to:
  /// **'Планка на одной руке'**
  String get exerciseBalS2OneArmPlankName;

  /// No description provided for @exerciseBalS2OneArmPlankDesc.
  ///
  /// In ru, this message translates to:
  /// **'Классическая планка на вытянутых руках. Оторви одну руку от пола и удержи позицию, тело параллельно полу.'**
  String get exerciseBalS2OneArmPlankDesc;

  /// No description provided for @exerciseBalS2OneArmPlankTip.
  ///
  /// In ru, this message translates to:
  /// **'Бёдра держи параллельно полу — не разворачивай корпус.'**
  String get exerciseBalS2OneArmPlankTip;

  /// No description provided for @exerciseBalS3CrowPrepName.
  ///
  /// In ru, this message translates to:
  /// **'Подготовка к позе ворона'**
  String get exerciseBalS3CrowPrepName;

  /// No description provided for @exerciseBalS3CrowPrepDesc.
  ///
  /// In ru, this message translates to:
  /// **'Присядь, колени на трицепсах. Перенеси вес на руки, слегка отрывая ноги. Удержи баланс на руках.'**
  String get exerciseBalS3CrowPrepDesc;

  /// No description provided for @exerciseBalS3CrowPrepTip.
  ///
  /// In ru, this message translates to:
  /// **'Взгляд вперёд-вниз, не прямо вниз — иначе упадёшь.'**
  String get exerciseBalS3CrowPrepTip;

  /// No description provided for @exerciseBalS4CrowPoseName.
  ///
  /// In ru, this message translates to:
  /// **'Поза ворона (Kakasana)'**
  String get exerciseBalS4CrowPoseName;

  /// No description provided for @exerciseBalS4CrowPoseDesc.
  ///
  /// In ru, this message translates to:
  /// **'Оба колена на трицепсах, полный баланс на руках. Руки слегка согнуты, пальцы широко расставлены.'**
  String get exerciseBalS4CrowPoseDesc;

  /// No description provided for @exerciseBalS4CrowPoseTip.
  ///
  /// In ru, this message translates to:
  /// **'Округли спину — это активирует корпус и даёт баланс.'**
  String get exerciseBalS4CrowPoseTip;

  /// No description provided for @exerciseBalS5WallHsName.
  ///
  /// In ru, this message translates to:
  /// **'Стойка на руках у стены'**
  String get exerciseBalS5WallHsName;

  /// No description provided for @exerciseBalS5WallHsDesc.
  ///
  /// In ru, this message translates to:
  /// **'Встань на руки спиной к стене. Пятки касаются стены для опоры. Удержи стойку, тело вытянуто в линию.'**
  String get exerciseBalS5WallHsDesc;

  /// No description provided for @exerciseBalS5WallHsTip.
  ///
  /// In ru, this message translates to:
  /// **'Пальцы широко, надавливай на подушечки — это баланс.'**
  String get exerciseBalS5WallHsTip;

  /// No description provided for @exerciseBalS6FreeHsName.
  ///
  /// In ru, this message translates to:
  /// **'Свободная стойка на руках'**
  String get exerciseBalS6FreeHsName;

  /// No description provided for @exerciseBalS6FreeHsDesc.
  ///
  /// In ru, this message translates to:
  /// **'Стойка на руках без опоры. Контролируй баланс мелкими движениями пальцев и запястий.'**
  String get exerciseBalS6FreeHsDesc;

  /// No description provided for @exerciseBalS6FreeHsTip.
  ///
  /// In ru, this message translates to:
  /// **'Смотри в пол на 30–40 см перед руками, не между руками.'**
  String get exerciseBalS6FreeHsTip;

  /// No description provided for @exerciseWarmupWristCirclesName.
  ///
  /// In ru, this message translates to:
  /// **'Круговые вращения запястьями'**
  String get exerciseWarmupWristCirclesName;

  /// No description provided for @exerciseWarmupWristCirclesDesc.
  ///
  /// In ru, this message translates to:
  /// **'Вращай запястьями по часовой и против часовой стрелки. Подготавливает суставы к нагрузке на руках.'**
  String get exerciseWarmupWristCirclesDesc;

  /// No description provided for @exerciseCooldownDownwardDogName.
  ///
  /// In ru, this message translates to:
  /// **'Собака мордой вниз'**
  String get exerciseCooldownDownwardDogName;

  /// No description provided for @exerciseCooldownDownwardDogDesc.
  ///
  /// In ru, this message translates to:
  /// **'На четвереньках выпрями руки и ноги, подними таз вверх. Тело — перевёрнутая V. Растяжка запястий, плеч и ног.'**
  String get exerciseCooldownDownwardDogDesc;

  /// No description provided for @aboutTitle.
  ///
  /// In ru, this message translates to:
  /// **'О приложении'**
  String get aboutTitle;

  /// No description provided for @aboutVersion.
  ///
  /// In ru, this message translates to:
  /// **'Версия'**
  String get aboutVersion;

  /// No description provided for @aboutSectionSupport.
  ///
  /// In ru, this message translates to:
  /// **'ПОДДЕРЖКА'**
  String get aboutSectionSupport;

  /// No description provided for @aboutContactUs.
  ///
  /// In ru, this message translates to:
  /// **'Написать нам'**
  String get aboutContactUs;

  /// No description provided for @aboutContactUsSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Сообщить об ошибке или задать вопрос'**
  String get aboutContactUsSubtitle;

  /// No description provided for @aboutPrivacyPolicy.
  ///
  /// In ru, this message translates to:
  /// **'Политика конфиденциальности'**
  String get aboutPrivacyPolicy;

  /// No description provided for @aboutBuiltWith.
  ///
  /// In ru, this message translates to:
  /// **'СДЕЛАНО НА'**
  String get aboutBuiltWith;

  /// No description provided for @aboutCopyright.
  ///
  /// In ru, this message translates to:
  /// **'© 2026 pupptmstr'**
  String get aboutCopyright;

  /// No description provided for @settingsAbout.
  ///
  /// In ru, this message translates to:
  /// **'О приложении'**
  String get settingsAbout;

  /// No description provided for @settingsSectionHealth.
  ///
  /// In ru, this message translates to:
  /// **'ЗДОРОВЬЕ'**
  String get settingsSectionHealth;

  /// No description provided for @settingsHealthWorkoutsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Записывать тренировки'**
  String get settingsHealthWorkoutsTitle;

  /// No description provided for @settingsHealthWorkoutsSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Сохранять в Apple Health / Health Connect'**
  String get settingsHealthWorkoutsSubtitle;

  /// No description provided for @settingsHealthWeightTitle.
  ///
  /// In ru, this message translates to:
  /// **'Читать массу тела'**
  String get settingsHealthWeightTitle;

  /// No description provided for @settingsHealthWeightSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Для точного расчёта калорий (иначе 70 кг)'**
  String get settingsHealthWeightSubtitle;

  /// No description provided for @summaryHealthSaved.
  ///
  /// In ru, this message translates to:
  /// **'Сохранено в Health ✓'**
  String get summaryHealthSaved;
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
