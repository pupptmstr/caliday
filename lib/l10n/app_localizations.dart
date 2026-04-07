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
    Locale('en'),
    Locale('ru'),
  ];

  /// No description provided for @durationMin.
  ///
  /// In en, this message translates to:
  /// **'{mins} min {secs} sec'**
  String durationMin(int mins, int secs);

  /// No description provided for @durationSec.
  ///
  /// In en, this message translates to:
  /// **'{secs} sec'**
  String durationSec(int secs);

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Workout'**
  String get navHome;

  /// No description provided for @navLibrary.
  ///
  /// In en, this message translates to:
  /// **'Courses'**
  String get navLibrary;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @libraryTitle.
  ///
  /// In en, this message translates to:
  /// **'Courses'**
  String get libraryTitle;

  /// No description provided for @progressTitle.
  ///
  /// In en, this message translates to:
  /// **'My Progress'**
  String get progressTitle;

  /// No description provided for @progressInfo.
  ///
  /// In en, this message translates to:
  /// **'Just keep training — the app advances you through the branches automatically. Here you can track how far you\'ve come. And if you feel ready to push ahead early, take the Challenge and move forward yourself.'**
  String get progressInfo;

  /// No description provided for @homeDays.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get homeDays;

  /// No description provided for @homeBranchesTitle.
  ///
  /// In en, this message translates to:
  /// **'Skill Branches'**
  String get homeBranchesTitle;

  /// No description provided for @homeBranchPush.
  ///
  /// In en, this message translates to:
  /// **'Push'**
  String get homeBranchPush;

  /// No description provided for @homeBranchPull.
  ///
  /// In en, this message translates to:
  /// **'Pull'**
  String get homeBranchPull;

  /// No description provided for @homeBranchCore.
  ///
  /// In en, this message translates to:
  /// **'Core'**
  String get homeBranchCore;

  /// No description provided for @homeBranchLegs.
  ///
  /// In en, this message translates to:
  /// **'Legs'**
  String get homeBranchLegs;

  /// No description provided for @homeBranchBalance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get homeBranchBalance;

  /// No description provided for @homeBranchFlex.
  ///
  /// In en, this message translates to:
  /// **'Flexibility'**
  String get homeBranchFlex;

  /// No description provided for @homeBranchPosture.
  ///
  /// In en, this message translates to:
  /// **'Posture'**
  String get homeBranchPosture;

  /// No description provided for @homeBranchNeck.
  ///
  /// In en, this message translates to:
  /// **'Neck'**
  String get homeBranchNeck;

  /// No description provided for @courseNameCalisthenics.
  ///
  /// In en, this message translates to:
  /// **'Calisthenics'**
  String get courseNameCalisthenics;

  /// No description provided for @courseNameHealthyBody.
  ///
  /// In en, this message translates to:
  /// **'Healthy Body'**
  String get courseNameHealthyBody;

  /// No description provided for @courseDescCalisthenics.
  ///
  /// In en, this message translates to:
  /// **'Bodyweight exercises from basic to advanced. Build strength, endurance, and body control.'**
  String get courseDescCalisthenics;

  /// No description provided for @courseDescHealthyBody.
  ///
  /// In en, this message translates to:
  /// **'Exercises for desk workers. Fix posture, release neck tension, and improve flexibility — joint-friendly.'**
  String get courseDescHealthyBody;

  /// No description provided for @onboardingQ4Courses.
  ///
  /// In en, this message translates to:
  /// **'Choose a Course'**
  String get onboardingQ4Courses;

  /// No description provided for @onboardingQ4CoursesBody.
  ///
  /// In en, this message translates to:
  /// **'You can start with one or pick both — the programs are independent.'**
  String get onboardingQ4CoursesBody;

  /// No description provided for @branchJourneyProgress.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total} stages completed'**
  String branchJourneyProgress(int done, int total);

  /// No description provided for @branchJourneyStageCompleted.
  ///
  /// In en, this message translates to:
  /// **'✓ Completed'**
  String get branchJourneyStageCompleted;

  /// No description provided for @branchJourneyStageCurrent.
  ///
  /// In en, this message translates to:
  /// **'Current stage'**
  String get branchJourneyStageCurrent;

  /// No description provided for @branchJourneyStageLocked.
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get branchJourneyStageLocked;

  /// No description provided for @branchJourneyParams.
  ///
  /// In en, this message translates to:
  /// **'{reps} reps × {sets} sets  ·  Rest {rest} s'**
  String branchJourneyParams(int reps, int sets, int rest);

  /// No description provided for @branchJourneyParamsTimed.
  ///
  /// In en, this message translates to:
  /// **'{secs} s × {sets} sets  ·  Rest {rest} s'**
  String branchJourneyParamsTimed(int secs, int sets, int rest);

  /// No description provided for @branchJourneyStartChallenge.
  ///
  /// In en, this message translates to:
  /// **'Take the Challenge'**
  String get branchJourneyStartChallenge;

  /// No description provided for @homeStage.
  ///
  /// In en, this message translates to:
  /// **'Stage {stage}/{total}'**
  String homeStage(int stage, int total);

  /// No description provided for @homeChallengeUnlocked.
  ///
  /// In en, this message translates to:
  /// **'Challenge Ready'**
  String get homeChallengeUnlocked;

  /// No description provided for @homeChallengeButton.
  ///
  /// In en, this message translates to:
  /// **'Accept Challenge'**
  String get homeChallengeButton;

  /// No description provided for @homeChallengeNormReps.
  ///
  /// In en, this message translates to:
  /// **'Goal: {n} reps'**
  String homeChallengeNormReps(int n);

  /// No description provided for @homeChallengeNormSec.
  ///
  /// In en, this message translates to:
  /// **'Goal: {n} sec'**
  String homeChallengeNormSec(int n);

  /// No description provided for @homeWorkoutDone.
  ///
  /// In en, this message translates to:
  /// **'Workout done'**
  String get homeWorkoutDone;

  /// No description provided for @homeWorkoutStart.
  ///
  /// In en, this message translates to:
  /// **'Today\'s workout'**
  String get homeWorkoutStart;

  /// No description provided for @homeWorkoutAgain.
  ///
  /// In en, this message translates to:
  /// **'Again'**
  String get homeWorkoutAgain;

  /// No description provided for @workoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Workout'**
  String get workoutTitle;

  /// No description provided for @workoutExitTitle.
  ///
  /// In en, this message translates to:
  /// **'Quit workout?'**
  String get workoutExitTitle;

  /// No description provided for @workoutExitBody.
  ///
  /// In en, this message translates to:
  /// **'Your progress will not be saved.'**
  String get workoutExitBody;

  /// No description provided for @workoutContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get workoutContinue;

  /// No description provided for @workoutAbort.
  ///
  /// In en, this message translates to:
  /// **'Quit'**
  String get workoutAbort;

  /// No description provided for @workoutSetProgress.
  ///
  /// In en, this message translates to:
  /// **'Set {current} of {total}'**
  String workoutSetProgress(int current, int total);

  /// No description provided for @workoutSec.
  ///
  /// In en, this message translates to:
  /// **'sec'**
  String get workoutSec;

  /// No description provided for @workoutRestLabel.
  ///
  /// In en, this message translates to:
  /// **'rest'**
  String get workoutRestLabel;

  /// No description provided for @workoutReps.
  ///
  /// In en, this message translates to:
  /// **'Reps'**
  String get workoutReps;

  /// No description provided for @workoutStop.
  ///
  /// In en, this message translates to:
  /// **'⏹  Stop'**
  String get workoutStop;

  /// No description provided for @workoutDone.
  ///
  /// In en, this message translates to:
  /// **'✓  Done'**
  String get workoutDone;

  /// No description provided for @workoutSkipRest.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get workoutSkipRest;

  /// No description provided for @workoutSetDone.
  ///
  /// In en, this message translates to:
  /// **'✅  Set done!'**
  String get workoutSetDone;

  /// No description provided for @workoutExerciseDone.
  ///
  /// In en, this message translates to:
  /// **'✅  Exercise done!'**
  String get workoutExerciseDone;

  /// No description provided for @workoutUnitReps.
  ///
  /// In en, this message translates to:
  /// **'reps'**
  String get workoutUnitReps;

  /// No description provided for @workoutNextExercise.
  ///
  /// In en, this message translates to:
  /// **'Next: {name} • {amount} {unit}'**
  String workoutNextExercise(String name, int amount, String unit);

  /// No description provided for @workoutNextSet.
  ///
  /// In en, this message translates to:
  /// **'Next: set {setNum} • {amount} {unit}'**
  String workoutNextSet(int setNum, int amount, String unit);

  /// No description provided for @summaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Great workout!'**
  String get summaryTitle;

  /// No description provided for @summarySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Keep it up — one more step forward'**
  String get summarySubtitle;

  /// No description provided for @summaryLabelTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get summaryLabelTime;

  /// No description provided for @summaryLabelExercises.
  ///
  /// In en, this message translates to:
  /// **'Exer.'**
  String get summaryLabelExercises;

  /// No description provided for @summaryHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get summaryHome;

  /// No description provided for @summaryFreezeUsedTitle.
  ///
  /// In en, this message translates to:
  /// **'Freeze saved your streak!'**
  String get summaryFreezeUsedTitle;

  /// No description provided for @summaryFreezeUsedBody.
  ///
  /// In en, this message translates to:
  /// **'Streak continues — keep it up'**
  String get summaryFreezeUsedBody;

  /// No description provided for @summaryFreezeEarnedTitle.
  ///
  /// In en, this message translates to:
  /// **'Streak freeze earned!'**
  String get summaryFreezeEarnedTitle;

  /// No description provided for @summaryFreezeEarnedBody.
  ///
  /// In en, this message translates to:
  /// **'Use it if you miss a day'**
  String get summaryFreezeEarnedBody;

  /// No description provided for @achievementsTitle.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievementsTitle;

  /// No description provided for @achievementsEarnedSection.
  ///
  /// In en, this message translates to:
  /// **'Earned'**
  String get achievementsEarnedSection;

  /// No description provided for @achievementsLockedSection.
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get achievementsLockedSection;

  /// No description provided for @achievementsSecret.
  ///
  /// In en, this message translates to:
  /// **'???'**
  String get achievementsSecret;

  /// No description provided for @achievementsSecretDesc.
  ///
  /// In en, this message translates to:
  /// **'Complete a special condition to unlock'**
  String get achievementsSecretDesc;

  /// No description provided for @achievementsEarnedOn.
  ///
  /// In en, this message translates to:
  /// **'Earned: {date}'**
  String achievementsEarnedOn(String date);

  /// No description provided for @profileAchievementsTitle.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get profileAchievementsTitle;

  /// No description provided for @profileAchievementsAll.
  ///
  /// In en, this message translates to:
  /// **'All achievements →'**
  String get profileAchievementsAll;

  /// No description provided for @profileNoAchievements.
  ///
  /// In en, this message translates to:
  /// **'No achievements yet'**
  String get profileNoAchievements;

  /// No description provided for @summaryAchievementsTitle.
  ///
  /// In en, this message translates to:
  /// **'New achievements!'**
  String get summaryAchievementsTitle;

  /// No description provided for @achievementFirstWorkoutName.
  ///
  /// In en, this message translates to:
  /// **'First Step'**
  String get achievementFirstWorkoutName;

  /// No description provided for @achievementFirstWorkoutDesc.
  ///
  /// In en, this message translates to:
  /// **'You completed your first workout — the journey begins!'**
  String get achievementFirstWorkoutDesc;

  /// No description provided for @achievementFirstChallengeName.
  ///
  /// In en, this message translates to:
  /// **'Challenge Accepted'**
  String get achievementFirstChallengeName;

  /// No description provided for @achievementFirstChallengeDesc.
  ///
  /// In en, this message translates to:
  /// **'First challenge passed — now you know what you\'re capable of'**
  String get achievementFirstChallengeDesc;

  /// No description provided for @achievementStreak3Name.
  ///
  /// In en, this message translates to:
  /// **'Three in a Row'**
  String get achievementStreak3Name;

  /// No description provided for @achievementStreak3Desc.
  ///
  /// In en, this message translates to:
  /// **'3 days in a row — the habit is forming'**
  String get achievementStreak3Desc;

  /// No description provided for @achievementStreak7Name.
  ///
  /// In en, this message translates to:
  /// **'Full Week'**
  String get achievementStreak7Name;

  /// No description provided for @achievementStreak7Desc.
  ///
  /// In en, this message translates to:
  /// **'A whole week — you\'re already above most'**
  String get achievementStreak7Desc;

  /// No description provided for @achievementStreak30Name.
  ///
  /// In en, this message translates to:
  /// **'Marathoner'**
  String get achievementStreak30Name;

  /// No description provided for @achievementStreak30Desc.
  ///
  /// In en, this message translates to:
  /// **'30 days straight — that\'s real discipline'**
  String get achievementStreak30Desc;

  /// No description provided for @achievementStreak100Name.
  ///
  /// In en, this message translates to:
  /// **'Iron Will'**
  String get achievementStreak100Name;

  /// No description provided for @achievementStreak100Desc.
  ///
  /// In en, this message translates to:
  /// **'100 days without a break — a legendary achievement'**
  String get achievementStreak100Desc;

  /// No description provided for @achievementWorkouts10Name.
  ///
  /// In en, this message translates to:
  /// **'Ten'**
  String get achievementWorkouts10Name;

  /// No description provided for @achievementWorkouts10Desc.
  ///
  /// In en, this message translates to:
  /// **'10 workouts completed — a solid start'**
  String get achievementWorkouts10Desc;

  /// No description provided for @achievementWorkouts50Name.
  ///
  /// In en, this message translates to:
  /// **'Fifty'**
  String get achievementWorkouts50Name;

  /// No description provided for @achievementWorkouts50Desc.
  ///
  /// In en, this message translates to:
  /// **'50 workouts — you mean business'**
  String get achievementWorkouts50Desc;

  /// No description provided for @achievementWorkouts100Name.
  ///
  /// In en, this message translates to:
  /// **'Centurion'**
  String get achievementWorkouts100Name;

  /// No description provided for @achievementWorkouts100Desc.
  ///
  /// In en, this message translates to:
  /// **'100 workouts — you\'re in the elite'**
  String get achievementWorkouts100Desc;

  /// No description provided for @achievementRankAmateurName.
  ///
  /// In en, this message translates to:
  /// **'Amateur'**
  String get achievementRankAmateurName;

  /// No description provided for @achievementRankAmateurDesc.
  ///
  /// In en, this message translates to:
  /// **'Amateur rank reached — SP are accumulating'**
  String get achievementRankAmateurDesc;

  /// No description provided for @achievementRankSportsmanName.
  ///
  /// In en, this message translates to:
  /// **'Sportsman'**
  String get achievementRankSportsmanName;

  /// No description provided for @achievementRankSportsmanDesc.
  ///
  /// In en, this message translates to:
  /// **'Sportsman rank — you\'re more than just a hobbyist'**
  String get achievementRankSportsmanDesc;

  /// No description provided for @achievementRankAthleteName.
  ///
  /// In en, this message translates to:
  /// **'Athlete'**
  String get achievementRankAthleteName;

  /// No description provided for @achievementRankAthleteDesc.
  ///
  /// In en, this message translates to:
  /// **'Athlete rank — a serious level'**
  String get achievementRankAthleteDesc;

  /// No description provided for @achievementRankMasterName.
  ///
  /// In en, this message translates to:
  /// **'Master'**
  String get achievementRankMasterName;

  /// No description provided for @achievementRankMasterDesc.
  ///
  /// In en, this message translates to:
  /// **'Master rank — only a few get this far'**
  String get achievementRankMasterDesc;

  /// No description provided for @achievementRankLegendName.
  ///
  /// In en, this message translates to:
  /// **'Legend'**
  String get achievementRankLegendName;

  /// No description provided for @achievementRankLegendDesc.
  ///
  /// In en, this message translates to:
  /// **'Max rank. You are a legend.'**
  String get achievementRankLegendDesc;

  /// No description provided for @achievementPushS3Name.
  ///
  /// In en, this message translates to:
  /// **'Full Push-up'**
  String get achievementPushS3Name;

  /// No description provided for @achievementPushS3Desc.
  ///
  /// In en, this message translates to:
  /// **'Classic floor push-ups mastered'**
  String get achievementPushS3Desc;

  /// No description provided for @achievementPushS6Name.
  ///
  /// In en, this message translates to:
  /// **'Archer'**
  String get achievementPushS6Name;

  /// No description provided for @achievementPushS6Desc.
  ///
  /// In en, this message translates to:
  /// **'Mastered archer push-ups — handstand is within reach'**
  String get achievementPushS6Desc;

  /// No description provided for @achievementPushCompleteName.
  ///
  /// In en, this message translates to:
  /// **'Push Master'**
  String get achievementPushCompleteName;

  /// No description provided for @achievementPushCompleteDesc.
  ///
  /// In en, this message translates to:
  /// **'All 7 Push stages cleared. Goro is proud.'**
  String get achievementPushCompleteDesc;

  /// No description provided for @achievementCoreS2Name.
  ///
  /// In en, this message translates to:
  /// **'Iron Plank'**
  String get achievementCoreS2Name;

  /// No description provided for @achievementCoreS2Desc.
  ///
  /// In en, this message translates to:
  /// **'Plank mastered — the foundation of all core work'**
  String get achievementCoreS2Desc;

  /// No description provided for @achievementCoreS5Name.
  ///
  /// In en, this message translates to:
  /// **'L-sit'**
  String get achievementCoreS5Name;

  /// No description provided for @achievementCoreS5Desc.
  ///
  /// In en, this message translates to:
  /// **'L-sit — the ultimate core strength test'**
  String get achievementCoreS5Desc;

  /// No description provided for @achievementCoreCompleteName.
  ///
  /// In en, this message translates to:
  /// **'Iron Core'**
  String get achievementCoreCompleteName;

  /// No description provided for @achievementCoreCompleteDesc.
  ///
  /// In en, this message translates to:
  /// **'All 6 Core stages cleared. Your core is steel.'**
  String get achievementCoreCompleteDesc;

  /// No description provided for @achievementPullS3Name.
  ///
  /// In en, this message translates to:
  /// **'First Pull-up'**
  String get achievementPullS3Name;

  /// No description provided for @achievementPullS3Desc.
  ///
  /// In en, this message translates to:
  /// **'Chin above the bar — that\'s a win'**
  String get achievementPullS3Desc;

  /// No description provided for @achievementPullCompleteName.
  ///
  /// In en, this message translates to:
  /// **'Bar King'**
  String get achievementPullCompleteName;

  /// No description provided for @achievementPullCompleteDesc.
  ///
  /// In en, this message translates to:
  /// **'All 6 Pull stages cleared. You rule the bar.'**
  String get achievementPullCompleteDesc;

  /// No description provided for @achievementLegsS5Name.
  ///
  /// In en, this message translates to:
  /// **'Pistol Squat'**
  String get achievementLegsS5Name;

  /// No description provided for @achievementLegsS5Desc.
  ///
  /// In en, this message translates to:
  /// **'Single-leg squat — balance and strength combined'**
  String get achievementLegsS5Desc;

  /// No description provided for @achievementLegsCompleteName.
  ///
  /// In en, this message translates to:
  /// **'Steel Legs'**
  String get achievementLegsCompleteName;

  /// No description provided for @achievementLegsCompleteDesc.
  ///
  /// In en, this message translates to:
  /// **'All 5 Legs stages cleared. Your legs are steel.'**
  String get achievementLegsCompleteDesc;

  /// No description provided for @achievementBalanceS4Name.
  ///
  /// In en, this message translates to:
  /// **'Crow Pose'**
  String get achievementBalanceS4Name;

  /// No description provided for @achievementBalanceS4Desc.
  ///
  /// In en, this message translates to:
  /// **'Kakasana holds — you command your balance'**
  String get achievementBalanceS4Desc;

  /// No description provided for @achievementBalanceS6Name.
  ///
  /// In en, this message translates to:
  /// **'Free Handstand'**
  String get achievementBalanceS6Name;

  /// No description provided for @achievementBalanceS6Desc.
  ///
  /// In en, this message translates to:
  /// **'Wall-free handstand — the peak of balance'**
  String get achievementBalanceS6Desc;

  /// No description provided for @achievementBalanceCompleteName.
  ///
  /// In en, this message translates to:
  /// **'Balance Master'**
  String get achievementBalanceCompleteName;

  /// No description provided for @achievementBalanceCompleteDesc.
  ///
  /// In en, this message translates to:
  /// **'All 6 Balance stages cleared. You are an equilibrist.'**
  String get achievementBalanceCompleteDesc;

  /// No description provided for @achievementAllCompleteName.
  ///
  /// In en, this message translates to:
  /// **'Full Collection'**
  String get achievementAllCompleteName;

  /// No description provided for @achievementAllCompleteDesc.
  ///
  /// In en, this message translates to:
  /// **'All 5 branches completed. Absolute champion.'**
  String get achievementAllCompleteDesc;

  /// No description provided for @summaryBonusTitle.
  ///
  /// In en, this message translates to:
  /// **'Bonus Workout'**
  String get summaryBonusTitle;

  /// No description provided for @summaryBonusBody.
  ///
  /// In en, this message translates to:
  /// **'×½ SP · progression already saved'**
  String get summaryBonusBody;

  /// No description provided for @summaryBonusCount.
  ///
  /// In en, this message translates to:
  /// **'You\'ve trained {count} times today!'**
  String summaryBonusCount(int count);

  /// No description provided for @summaryChallengeUnlockedTitle.
  ///
  /// In en, this message translates to:
  /// **'Challenge awaits!'**
  String get summaryChallengeUnlockedTitle;

  /// No description provided for @summaryChallengeUnlockedBody.
  ///
  /// In en, this message translates to:
  /// **'Tap «Accept Challenge» on the Home screen when you\'re ready'**
  String get summaryChallengeUnlockedBody;

  /// No description provided for @summaryChallengePassedTitle.
  ///
  /// In en, this message translates to:
  /// **'New stage!'**
  String get summaryChallengePassedTitle;

  /// No description provided for @summaryChallengePassedBody.
  ///
  /// In en, this message translates to:
  /// **'You\'ve unlocked: {exercise}'**
  String summaryChallengePassedBody(String exercise);

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileMaxRank.
  ///
  /// In en, this message translates to:
  /// **'Max rank!'**
  String get profileMaxRank;

  /// No description provided for @profileRankProgress.
  ///
  /// In en, this message translates to:
  /// **'{remaining} SP to {rankName}'**
  String profileRankProgress(int remaining, String rankName);

  /// No description provided for @profileStatDays.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get profileStatDays;

  /// No description provided for @profileStatRecord.
  ///
  /// In en, this message translates to:
  /// **'record'**
  String get profileStatRecord;

  /// No description provided for @profileStatWorkouts.
  ///
  /// In en, this message translates to:
  /// **'workouts'**
  String get profileStatWorkouts;

  /// No description provided for @profileStatFreezes.
  ///
  /// In en, this message translates to:
  /// **'freezes'**
  String get profileStatFreezes;

  /// No description provided for @profileHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Workout history'**
  String get profileHistoryTitle;

  /// No description provided for @profileNoHistory.
  ///
  /// In en, this message translates to:
  /// **'No completed workouts yet'**
  String get profileNoHistory;

  /// No description provided for @historyTypeDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily Workout'**
  String get historyTypeDaily;

  /// No description provided for @historyTypeChallenge.
  ///
  /// In en, this message translates to:
  /// **'Challenge'**
  String get historyTypeChallenge;

  /// No description provided for @historyTypeBonus.
  ///
  /// In en, this message translates to:
  /// **'Bonus'**
  String get historyTypeBonus;

  /// No description provided for @historyDetailExercises.
  ///
  /// In en, this message translates to:
  /// **'Exercises'**
  String get historyDetailExercises;

  /// No description provided for @historyDetailReps.
  ///
  /// In en, this message translates to:
  /// **'{completed} / {target} reps'**
  String historyDetailReps(int completed, int target);

  /// No description provided for @historyDetailSec.
  ///
  /// In en, this message translates to:
  /// **'{completed} / {target} sec'**
  String historyDetailSec(int completed, int target);

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsSectionNotifications.
  ///
  /// In en, this message translates to:
  /// **'NOTIFICATIONS'**
  String get settingsSectionNotifications;

  /// No description provided for @settingsSectionLanguage.
  ///
  /// In en, this message translates to:
  /// **'LANGUAGE'**
  String get settingsSectionLanguage;

  /// No description provided for @settingsNotificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Enable notifications'**
  String get settingsNotificationsTitle;

  /// No description provided for @settingsNotificationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Allow the app to send reminders'**
  String get settingsNotificationsSubtitle;

  /// No description provided for @settingsNotificationTimeTitle.
  ///
  /// In en, this message translates to:
  /// **'Reminder time'**
  String get settingsNotificationTimeTitle;

  /// No description provided for @settingsNotificationTimeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Morning workout reminder'**
  String get settingsNotificationTimeSubtitle;

  /// No description provided for @settingsTimePickerDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get settingsTimePickerDone;

  /// No description provided for @settingsEveningReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Evening reminder'**
  String get settingsEveningReminderTitle;

  /// No description provided for @settingsEveningReminderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Remind in the evening if no workout done'**
  String get settingsEveningReminderSubtitle;

  /// No description provided for @settingsStreakThreatTitle.
  ///
  /// In en, this message translates to:
  /// **'Streak threat'**
  String get settingsStreakThreatTitle;

  /// No description provided for @settingsStreakThreatSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Warn when your streak is at risk'**
  String get settingsStreakThreatSubtitle;

  /// No description provided for @settingsLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'App language'**
  String get settingsLanguageTitle;

  /// No description provided for @settingsSectionTheme.
  ///
  /// In en, this message translates to:
  /// **'THEME'**
  String get settingsSectionTheme;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsThemeSystem;

  /// No description provided for @settingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// No description provided for @settingsSectionEquipment.
  ///
  /// In en, this message translates to:
  /// **'EQUIPMENT'**
  String get settingsSectionEquipment;

  /// No description provided for @settingsEquipmentPullUpBar.
  ///
  /// In en, this message translates to:
  /// **'Pull-up bar at home'**
  String get settingsEquipmentPullUpBar;

  /// No description provided for @settingsEquipmentPullUpBarSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enables the Pull skill progression branch'**
  String get settingsEquipmentPullUpBarSubtitle;

  /// No description provided for @settingsSectionWorkout.
  ///
  /// In en, this message translates to:
  /// **'WORKOUT'**
  String get settingsSectionWorkout;

  /// No description provided for @settingsWorkoutDurationTitle.
  ///
  /// In en, this message translates to:
  /// **'Session length'**
  String get settingsWorkoutDurationTitle;

  /// No description provided for @settingsWorkoutDurationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'How many minutes to spend on the daily workout'**
  String get settingsWorkoutDurationSubtitle;

  /// No description provided for @settingsSoundTitle.
  ///
  /// In en, this message translates to:
  /// **'Sounds'**
  String get settingsSoundTitle;

  /// No description provided for @settingsSoundSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Audio feedback during workouts'**
  String get settingsSoundSubtitle;

  /// No description provided for @settingsHapticTitle.
  ///
  /// In en, this message translates to:
  /// **'Haptics'**
  String get settingsHapticTitle;

  /// No description provided for @settingsHapticSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tactile feedback during workouts'**
  String get settingsHapticSubtitle;

  /// No description provided for @rankBeginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get rankBeginner;

  /// No description provided for @rankAmateur.
  ///
  /// In en, this message translates to:
  /// **'Amateur'**
  String get rankAmateur;

  /// No description provided for @rankSportsman.
  ///
  /// In en, this message translates to:
  /// **'Athlete'**
  String get rankSportsman;

  /// No description provided for @rankAthlete.
  ///
  /// In en, this message translates to:
  /// **'Champion'**
  String get rankAthlete;

  /// No description provided for @rankMaster.
  ///
  /// In en, this message translates to:
  /// **'Master'**
  String get rankMaster;

  /// No description provided for @rankLegend.
  ///
  /// In en, this message translates to:
  /// **'Legend'**
  String get rankLegend;

  /// No description provided for @onboardingWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Hi! I\'m Goro'**
  String get onboardingWelcomeTitle;

  /// No description provided for @onboardingWelcomeBody.
  ///
  /// In en, this message translates to:
  /// **'Short sets, skill progression, streaks and points.\nFrom knee push-ups to handstand — step by step.'**
  String get onboardingWelcomeBody;

  /// No description provided for @onboardingWelcomeCta.
  ///
  /// In en, this message translates to:
  /// **'Let\'s set everything up in 1 minute'**
  String get onboardingWelcomeCta;

  /// No description provided for @onboardingContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get onboardingContinue;

  /// No description provided for @onboardingStart.
  ///
  /// In en, this message translates to:
  /// **'Start training 🔥'**
  String get onboardingStart;

  /// No description provided for @onboardingQ1.
  ///
  /// In en, this message translates to:
  /// **'What\'s your name?'**
  String get onboardingQ1;

  /// No description provided for @onboardingQ1Hint.
  ///
  /// In en, this message translates to:
  /// **'Your name (optional)'**
  String get onboardingQ1Hint;

  /// No description provided for @onboardingQ1Body.
  ///
  /// In en, this message translates to:
  /// **'Goro will use it to cheer you on'**
  String get onboardingQ1Body;

  /// No description provided for @onboardingQ2.
  ///
  /// In en, this message translates to:
  /// **'How many push-ups can you do?'**
  String get onboardingQ2;

  /// No description provided for @onboardingQ3.
  ///
  /// In en, this message translates to:
  /// **'How many minutes a day are you ready to spend?'**
  String get onboardingQ3;

  /// No description provided for @onboardingQ4.
  ///
  /// In en, this message translates to:
  /// **'What\'s your goal?'**
  String get onboardingQ4;

  /// No description provided for @onboardingQ5.
  ///
  /// In en, this message translates to:
  /// **'Do you have a pull-up bar or rings at home?'**
  String get onboardingQ5;

  /// No description provided for @onboardingEquipmentYes.
  ///
  /// In en, this message translates to:
  /// **'Yes, I do'**
  String get onboardingEquipmentYes;

  /// No description provided for @onboardingEquipmentNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get onboardingEquipmentNo;

  /// No description provided for @onboardingQ6Health.
  ///
  /// In en, this message translates to:
  /// **'Sync with Health'**
  String get onboardingQ6Health;

  /// No description provided for @onboardingHealthBody.
  ///
  /// In en, this message translates to:
  /// **'CaliDay can automatically save your workouts to Apple Health (iOS) or Health Connect (Android).'**
  String get onboardingHealthBody;

  /// No description provided for @onboardingHealthEnable.
  ///
  /// In en, this message translates to:
  /// **'Enable'**
  String get onboardingHealthEnable;

  /// No description provided for @onboardingHealthEnableDesc.
  ///
  /// In en, this message translates to:
  /// **'Save workouts automatically'**
  String get onboardingHealthEnableDesc;

  /// No description provided for @onboardingHealthSkip.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get onboardingHealthSkip;

  /// No description provided for @onboardingHealthSkipDesc.
  ///
  /// In en, this message translates to:
  /// **'You can enable it later in Settings'**
  String get onboardingHealthSkipDesc;

  /// No description provided for @onboardingQ7.
  ///
  /// In en, this message translates to:
  /// **'When should we remind you to work out?'**
  String get onboardingQ7;

  /// No description provided for @pushupZeroDesc.
  ///
  /// In en, this message translates to:
  /// **'Not yet'**
  String get pushupZeroDesc;

  /// No description provided for @pushupOneToFiveDesc.
  ///
  /// In en, this message translates to:
  /// **'Just a few'**
  String get pushupOneToFiveDesc;

  /// No description provided for @pushupFiveToFifteenDesc.
  ///
  /// In en, this message translates to:
  /// **'Getting there'**
  String get pushupFiveToFifteenDesc;

  /// No description provided for @pushupMoreThan15Desc.
  ///
  /// In en, this message translates to:
  /// **'Solid base'**
  String get pushupMoreThan15Desc;

  /// No description provided for @minutesLabel.
  ///
  /// In en, this message translates to:
  /// **'{minutes} minutes'**
  String minutesLabel(int minutes);

  /// No description provided for @minutesFiveDesc.
  ///
  /// In en, this message translates to:
  /// **'Quick and efficient'**
  String get minutesFiveDesc;

  /// No description provided for @minutesTenDesc.
  ///
  /// In en, this message translates to:
  /// **'Optimal choice'**
  String get minutesTenDesc;

  /// No description provided for @minutesFifteenDesc.
  ///
  /// In en, this message translates to:
  /// **'Full workout'**
  String get minutesFifteenDesc;

  /// No description provided for @goalGeneralLabel.
  ///
  /// In en, this message translates to:
  /// **'General fitness'**
  String get goalGeneralLabel;

  /// No description provided for @goalGeneralDesc.
  ///
  /// In en, this message translates to:
  /// **'Stay active and healthy'**
  String get goalGeneralDesc;

  /// No description provided for @goalStrengthLabel.
  ///
  /// In en, this message translates to:
  /// **'Push-ups & strength'**
  String get goalStrengthLabel;

  /// No description provided for @goalStrengthDesc.
  ///
  /// In en, this message translates to:
  /// **'Build chest and triceps'**
  String get goalStrengthDesc;

  /// No description provided for @goalCalisthenicsLabel.
  ///
  /// In en, this message translates to:
  /// **'Calisthenics'**
  String get goalCalisthenicsLabel;

  /// No description provided for @goalCalisthenicsDesc.
  ///
  /// In en, this message translates to:
  /// **'Handstand and skills'**
  String get goalCalisthenicsDesc;

  /// No description provided for @timeOfDayMorning.
  ///
  /// In en, this message translates to:
  /// **'Morning'**
  String get timeOfDayMorning;

  /// No description provided for @timeOfDayDay.
  ///
  /// In en, this message translates to:
  /// **'Afternoon'**
  String get timeOfDayDay;

  /// No description provided for @timeOfDayLunch.
  ///
  /// In en, this message translates to:
  /// **'Lunch'**
  String get timeOfDayLunch;

  /// No description provided for @timeOfDayEvening.
  ///
  /// In en, this message translates to:
  /// **'Evening'**
  String get timeOfDayEvening;

  /// No description provided for @exercisePushS1WallPushupName.
  ///
  /// In en, this message translates to:
  /// **'Wall Push-up'**
  String get exercisePushS1WallPushupName;

  /// No description provided for @exercisePushS1WallPushupDesc.
  ///
  /// In en, this message translates to:
  /// **'Stand a step away from the wall and press your palms at chest height. Bend your arms until your chest touches the wall, then push back.'**
  String get exercisePushS1WallPushupDesc;

  /// No description provided for @exercisePushS1WallPushupTip.
  ///
  /// In en, this message translates to:
  /// **'Keep your body straight — don\'t arch your lower back.'**
  String get exercisePushS1WallPushupTip;

  /// No description provided for @exercisePushS2KneePushupName.
  ///
  /// In en, this message translates to:
  /// **'Knee Push-up'**
  String get exercisePushS2KneePushupName;

  /// No description provided for @exercisePushS2KneePushupDesc.
  ///
  /// In en, this message translates to:
  /// **'Push-up position with knees on the floor. Keep a straight line from knees to head. Lower your chest to the floor, then press up.'**
  String get exercisePushS2KneePushupDesc;

  /// No description provided for @exercisePushS2KneePushupTip.
  ///
  /// In en, this message translates to:
  /// **'Don\'t drop your hips — keep a straight line from knees to shoulders.'**
  String get exercisePushS2KneePushupTip;

  /// No description provided for @exercisePushS3FullPushupName.
  ///
  /// In en, this message translates to:
  /// **'Full Push-up'**
  String get exercisePushS3FullPushupName;

  /// No description provided for @exercisePushS3FullPushupDesc.
  ///
  /// In en, this message translates to:
  /// **'Classic push-up position. Body forms a straight line from heels to head. Chest touches or comes within 2–3 cm of the floor.'**
  String get exercisePushS3FullPushupDesc;

  /// No description provided for @exercisePushS3FullPushupTip.
  ///
  /// In en, this message translates to:
  /// **'Brace your core and glutes to keep your hips from sagging.'**
  String get exercisePushS3FullPushupTip;

  /// No description provided for @exercisePushS4DiamondPushupName.
  ///
  /// In en, this message translates to:
  /// **'Diamond Push-up'**
  String get exercisePushS4DiamondPushupName;

  /// No description provided for @exercisePushS4DiamondPushupDesc.
  ///
  /// In en, this message translates to:
  /// **'Hands under your chest with thumbs and index fingers forming a diamond. Targets the triceps. Keep elbows tucked on the way down.'**
  String get exercisePushS4DiamondPushupDesc;

  /// No description provided for @exercisePushS4DiamondPushupTip.
  ///
  /// In en, this message translates to:
  /// **'Don\'t flare your elbows — let them glide along your body.'**
  String get exercisePushS4DiamondPushupTip;

  /// No description provided for @exercisePushS5WidePushupName.
  ///
  /// In en, this message translates to:
  /// **'Wide Push-up'**
  String get exercisePushS5WidePushupName;

  /// No description provided for @exercisePushS5WidePushupDesc.
  ///
  /// In en, this message translates to:
  /// **'Hands placed significantly wider than shoulder-width. Lower slowly while keeping your body in a straight line. Both chest and triceps work through a wide range of motion.'**
  String get exercisePushS5WidePushupDesc;

  /// No description provided for @exercisePushS5WidePushupTip.
  ///
  /// In en, this message translates to:
  /// **'The wider your hands, the more the chest is targeted and the less the triceps.'**
  String get exercisePushS5WidePushupTip;

  /// No description provided for @exercisePushS6ArcherPushupName.
  ///
  /// In en, this message translates to:
  /// **'Archer Push-up'**
  String get exercisePushS6ArcherPushupName;

  /// No description provided for @exercisePushS6ArcherPushupDesc.
  ///
  /// In en, this message translates to:
  /// **'Wide hand placement. Lower toward one arm while keeping the other arm straight. Alternate each side.'**
  String get exercisePushS6ArcherPushupDesc;

  /// No description provided for @exercisePushS6ArcherPushupTip.
  ///
  /// In en, this message translates to:
  /// **'Working arm goes full range; straight arm stays on the floor for support.'**
  String get exercisePushS6ArcherPushupTip;

  /// No description provided for @exercisePushS7HandstandPushupName.
  ///
  /// In en, this message translates to:
  /// **'Handstand Push-up'**
  String get exercisePushS7HandstandPushupName;

  /// No description provided for @exercisePushS7HandstandPushupDesc.
  ///
  /// In en, this message translates to:
  /// **'Handstand against the wall (back to wall). Slowly lower your head toward the floor, then press your body back up.'**
  String get exercisePushS7HandstandPushupDesc;

  /// No description provided for @exercisePushS7HandstandPushupTip.
  ///
  /// In en, this message translates to:
  /// **'Spread your fingers wide for stability. Look between your hands.'**
  String get exercisePushS7HandstandPushupTip;

  /// No description provided for @exerciseCoreS1CrunchesName.
  ///
  /// In en, this message translates to:
  /// **'Crunches'**
  String get exerciseCoreS1CrunchesName;

  /// No description provided for @exerciseCoreS1CrunchesDesc.
  ///
  /// In en, this message translates to:
  /// **'Lie on your back with knees bent. Hands behind your head or crossed on your chest. Lift your shoulder blades off the floor by contracting your abs.'**
  String get exerciseCoreS1CrunchesDesc;

  /// No description provided for @exerciseCoreS1CrunchesTip.
  ///
  /// In en, this message translates to:
  /// **'Don\'t pull your neck with your hands — pull your chest toward the ceiling.'**
  String get exerciseCoreS1CrunchesTip;

  /// No description provided for @exerciseCoreS2PlankName.
  ///
  /// In en, this message translates to:
  /// **'Plank'**
  String get exerciseCoreS2PlankName;

  /// No description provided for @exerciseCoreS2PlankDesc.
  ///
  /// In en, this message translates to:
  /// **'Forearm push-up position. Body forms a straight line from heels to head. Don\'t raise your hips or arch your lower back.'**
  String get exerciseCoreS2PlankDesc;

  /// No description provided for @exerciseCoreS2PlankTip.
  ///
  /// In en, this message translates to:
  /// **'Brace your core and glutes. Breathe steadily — don\'t hold your breath.'**
  String get exerciseCoreS2PlankTip;

  /// No description provided for @exerciseCoreS3LyingLegRaiseName.
  ///
  /// In en, this message translates to:
  /// **'Lying Leg Raise'**
  String get exerciseCoreS3LyingLegRaiseName;

  /// No description provided for @exerciseCoreS3LyingLegRaiseDesc.
  ///
  /// In en, this message translates to:
  /// **'Lie on your back with hands under your glutes. Raise straight legs to vertical, then lower them slowly without touching the floor.'**
  String get exerciseCoreS3LyingLegRaiseDesc;

  /// No description provided for @exerciseCoreS3LyingLegRaiseTip.
  ///
  /// In en, this message translates to:
  /// **'Keep your lower back pressed to the floor throughout the movement.'**
  String get exerciseCoreS3LyingLegRaiseTip;

  /// No description provided for @exerciseCoreS4HangingLegRaiseName.
  ///
  /// In en, this message translates to:
  /// **'Hanging Leg Raise'**
  String get exerciseCoreS4HangingLegRaiseName;

  /// No description provided for @exerciseCoreS4HangingLegRaiseDesc.
  ///
  /// In en, this message translates to:
  /// **'Hang from a bar. Raise straight legs to parallel with the floor or higher. Control the descent.'**
  String get exerciseCoreS4HangingLegRaiseDesc;

  /// No description provided for @exerciseCoreS4HangingLegRaiseTip.
  ///
  /// In en, this message translates to:
  /// **'Don\'t swing — the movement comes from your abs only.'**
  String get exerciseCoreS4HangingLegRaiseTip;

  /// No description provided for @exerciseCoreS4FlutterKicksName.
  ///
  /// In en, this message translates to:
  /// **'Flutter Kicks'**
  String get exerciseCoreS4FlutterKicksName;

  /// No description provided for @exerciseCoreS4FlutterKicksDesc.
  ///
  /// In en, this message translates to:
  /// **'Lie on your back, hands under your glutes. Lift both legs 15–20 cm off the floor. Alternate raising and lowering each leg in small quick movements. One rep = one cycle (right up + left up).'**
  String get exerciseCoreS4FlutterKicksDesc;

  /// No description provided for @exerciseCoreS4FlutterKicksTip.
  ///
  /// In en, this message translates to:
  /// **'Keep your lower back pressed to the floor. Legs don\'t touch the floor between reps.'**
  String get exerciseCoreS4FlutterKicksTip;

  /// No description provided for @exerciseCoreS5LSitName.
  ///
  /// In en, this message translates to:
  /// **'L-sit'**
  String get exerciseCoreS5LSitName;

  /// No description provided for @exerciseCoreS5LSitDesc.
  ///
  /// In en, this message translates to:
  /// **'Support on parallel bars or the floor. Legs straight and parallel to the floor. Hold the position as long as possible.'**
  String get exerciseCoreS5LSitDesc;

  /// No description provided for @exerciseCoreS5LSitTip.
  ///
  /// In en, this message translates to:
  /// **'Point toes toward you; pull shoulders down and back.'**
  String get exerciseCoreS5LSitTip;

  /// No description provided for @exerciseCoreS6DragonFlagName.
  ///
  /// In en, this message translates to:
  /// **'Dragon Flag'**
  String get exerciseCoreS6DragonFlagName;

  /// No description provided for @exerciseCoreS6DragonFlagDesc.
  ///
  /// In en, this message translates to:
  /// **'Lie on a bench and grip a support behind your head. Lift your body into a straight line on your shoulder blades, then lower slowly.'**
  String get exerciseCoreS6DragonFlagDesc;

  /// No description provided for @exerciseCoreS6DragonFlagTip.
  ///
  /// In en, this message translates to:
  /// **'Start with the negative phase (lowering only) — it\'s easier.'**
  String get exerciseCoreS6DragonFlagTip;

  /// No description provided for @exerciseWarmupArmRotationsName.
  ///
  /// In en, this message translates to:
  /// **'Arm Circles'**
  String get exerciseWarmupArmRotationsName;

  /// No description provided for @exerciseWarmupArmRotationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Standing, make large circular movements with your arms forward and backward. Warms up the shoulder girdle before push-ups.'**
  String get exerciseWarmupArmRotationsDesc;

  /// No description provided for @exerciseWarmupJumpingJacksName.
  ///
  /// In en, this message translates to:
  /// **'Jumping Jacks'**
  String get exerciseWarmupJumpingJacksName;

  /// No description provided for @exerciseWarmupJumpingJacksDesc.
  ///
  /// In en, this message translates to:
  /// **'Classic jumping jacks. Raises your heart rate and warms up your whole body in 30–60 seconds.'**
  String get exerciseWarmupJumpingJacksDesc;

  /// No description provided for @exerciseCooldownShoulderStretchName.
  ///
  /// In en, this message translates to:
  /// **'Shoulder & Chest Stretch'**
  String get exerciseCooldownShoulderStretchName;

  /// No description provided for @exerciseCooldownShoulderStretchDesc.
  ///
  /// In en, this message translates to:
  /// **'Clasp your hands behind your back and pull your shoulders back and down. Hold for 30 seconds.'**
  String get exerciseCooldownShoulderStretchDesc;

  /// No description provided for @exerciseCooldownCatCowName.
  ///
  /// In en, this message translates to:
  /// **'Cat-Cow'**
  String get exerciseCooldownCatCowName;

  /// No description provided for @exerciseCooldownCatCowDesc.
  ///
  /// In en, this message translates to:
  /// **'On all fours: inhale and arch your back down (cow), exhale and round it up (cat). Releases tension in the lower back and abs.'**
  String get exerciseCooldownCatCowDesc;

  /// No description provided for @exercisePullS1AustralianName.
  ///
  /// In en, this message translates to:
  /// **'Australian Pull-up'**
  String get exercisePullS1AustralianName;

  /// No description provided for @exercisePullS1AustralianDesc.
  ///
  /// In en, this message translates to:
  /// **'Lie under a bar with a slightly wider than shoulder-width grip. Pull your chest to the bar, keeping your body in a straight line. Control the descent.'**
  String get exercisePullS1AustralianDesc;

  /// No description provided for @exercisePullS1AustralianTip.
  ///
  /// In en, this message translates to:
  /// **'The lower the bar, the harder the exercise.'**
  String get exercisePullS1AustralianTip;

  /// No description provided for @exercisePullS2NegativeName.
  ///
  /// In en, this message translates to:
  /// **'Negative Pull-up'**
  String get exercisePullS2NegativeName;

  /// No description provided for @exercisePullS2NegativeDesc.
  ///
  /// In en, this message translates to:
  /// **'Jump up with your chin above the bar. Slowly lower yourself over 3–5 seconds until your arms are fully extended.'**
  String get exercisePullS2NegativeDesc;

  /// No description provided for @exercisePullS2NegativeTip.
  ///
  /// In en, this message translates to:
  /// **'The slower you lower — the better. Aim for 5 seconds down.'**
  String get exercisePullS2NegativeTip;

  /// No description provided for @exercisePullS3PullupName.
  ///
  /// In en, this message translates to:
  /// **'Pull-up'**
  String get exercisePullS3PullupName;

  /// No description provided for @exercisePullS3PullupDesc.
  ///
  /// In en, this message translates to:
  /// **'Shoulder-width or slightly wider grip. Pull your chest to the bar until your chin is above it. Fully extend your arms at the bottom.'**
  String get exercisePullS3PullupDesc;

  /// No description provided for @exercisePullS3PullupTip.
  ///
  /// In en, this message translates to:
  /// **'Squeeze your shoulder blades — you\'re pulling with your back, not your arms.'**
  String get exercisePullS3PullupTip;

  /// No description provided for @exercisePullS4CloseGripName.
  ///
  /// In en, this message translates to:
  /// **'Close-Grip Pull-up'**
  String get exercisePullS4CloseGripName;

  /// No description provided for @exercisePullS4CloseGripDesc.
  ///
  /// In en, this message translates to:
  /// **'Grip narrower than shoulder-width, palms facing you or away. Targets the biceps and lower lats. Pull your chest to the bar.'**
  String get exercisePullS4CloseGripDesc;

  /// No description provided for @exercisePullS4CloseGripTip.
  ///
  /// In en, this message translates to:
  /// **'Keep elbows tucked in for maximum bicep engagement.'**
  String get exercisePullS4CloseGripTip;

  /// No description provided for @exercisePullS5ArcherName.
  ///
  /// In en, this message translates to:
  /// **'Archer Pull-up'**
  String get exercisePullS5ArcherName;

  /// No description provided for @exercisePullS5ArcherDesc.
  ///
  /// In en, this message translates to:
  /// **'Wide grip. Pull your body toward one arm while keeping the other arm straight. Alternate each side.'**
  String get exercisePullS5ArcherDesc;

  /// No description provided for @exercisePullS5ArcherTip.
  ///
  /// In en, this message translates to:
  /// **'Straight arm is for support; working arm goes full range.'**
  String get exercisePullS5ArcherTip;

  /// No description provided for @exercisePullS6OneArmName.
  ///
  /// In en, this message translates to:
  /// **'One-Arm Pull-up'**
  String get exercisePullS6OneArmName;

  /// No description provided for @exercisePullS6OneArmDesc.
  ///
  /// In en, this message translates to:
  /// **'One hand on the bar, the other on your wrist or free. Full range of motion with the working arm.'**
  String get exercisePullS6OneArmDesc;

  /// No description provided for @exercisePullS6OneArmTip.
  ///
  /// In en, this message translates to:
  /// **'Keep your core tight — don\'t swing.'**
  String get exercisePullS6OneArmTip;

  /// No description provided for @exerciseWarmupDeadHangName.
  ///
  /// In en, this message translates to:
  /// **'Dead Hang'**
  String get exerciseWarmupDeadHangName;

  /// No description provided for @exerciseWarmupDeadHangDesc.
  ///
  /// In en, this message translates to:
  /// **'Hang from the bar with an overhand grip, arms fully extended. Relax your shoulders and hold the hang.'**
  String get exerciseWarmupDeadHangDesc;

  /// No description provided for @exerciseCooldownLatStretchName.
  ///
  /// In en, this message translates to:
  /// **'Lat Stretch'**
  String get exerciseCooldownLatStretchName;

  /// No description provided for @exerciseCooldownLatStretchDesc.
  ///
  /// In en, this message translates to:
  /// **'Stand sideways to a wall, raise one arm and press against it. Lean into the stretch to feel it along your side.'**
  String get exerciseCooldownLatStretchDesc;

  /// No description provided for @exerciseLegsS1SquatName.
  ///
  /// In en, this message translates to:
  /// **'Squat'**
  String get exerciseLegsS1SquatName;

  /// No description provided for @exerciseLegsS1SquatDesc.
  ///
  /// In en, this message translates to:
  /// **'Feet shoulder-width apart, toes slightly turned out. Squat until thighs are parallel to the floor, knees over toes. Extend fully at the top.'**
  String get exerciseLegsS1SquatDesc;

  /// No description provided for @exerciseLegsS1SquatTip.
  ///
  /// In en, this message translates to:
  /// **'Keep heels on the floor and chest upright.'**
  String get exerciseLegsS1SquatTip;

  /// No description provided for @exerciseLegsS2LungeName.
  ///
  /// In en, this message translates to:
  /// **'Lunge'**
  String get exerciseLegsS2LungeName;

  /// No description provided for @exerciseLegsS2LungeDesc.
  ///
  /// In en, this message translates to:
  /// **'Step forward and lower your back knee toward the floor without touching it. Both knees at 90°. Push off with the front foot to return.'**
  String get exerciseLegsS2LungeDesc;

  /// No description provided for @exerciseLegsS2LungeTip.
  ///
  /// In en, this message translates to:
  /// **'Keep your front knee behind your toes.'**
  String get exerciseLegsS2LungeTip;

  /// No description provided for @exerciseLegsS3BulgarianName.
  ///
  /// In en, this message translates to:
  /// **'Bulgarian Split Squat'**
  String get exerciseLegsS3BulgarianName;

  /// No description provided for @exerciseLegsS3BulgarianDesc.
  ///
  /// In en, this message translates to:
  /// **'Rear foot elevated on a chair or couch. Lower your front leg until your thigh is parallel to the floor. Keep your torso upright.'**
  String get exerciseLegsS3BulgarianDesc;

  /// No description provided for @exerciseLegsS3BulgarianTip.
  ///
  /// In en, this message translates to:
  /// **'The further your front foot, the more glute activation.'**
  String get exerciseLegsS3BulgarianTip;

  /// No description provided for @exerciseLegsS4AssistedPistolName.
  ///
  /// In en, this message translates to:
  /// **'Assisted Pistol Squat'**
  String get exerciseLegsS4AssistedPistolName;

  /// No description provided for @exerciseLegsS4AssistedPistolDesc.
  ///
  /// In en, this message translates to:
  /// **'Hold a door frame or pole for support. Squat on one leg while keeping the other straight in front of you. Use the support to reduce load.'**
  String get exerciseLegsS4AssistedPistolDesc;

  /// No description provided for @exerciseLegsS4AssistedPistolTip.
  ///
  /// In en, this message translates to:
  /// **'Gradually reduce hand assistance as you get stronger.'**
  String get exerciseLegsS4AssistedPistolTip;

  /// No description provided for @exerciseLegsS5PistolName.
  ///
  /// In en, this message translates to:
  /// **'Pistol Squat'**
  String get exerciseLegsS5PistolName;

  /// No description provided for @exerciseLegsS5PistolDesc.
  ///
  /// In en, this message translates to:
  /// **'Single-leg squat without support. Other leg straight in front. Full range of motion to the floor and back up.'**
  String get exerciseLegsS5PistolDesc;

  /// No description provided for @exerciseLegsS5PistolTip.
  ///
  /// In en, this message translates to:
  /// **'Arms forward as a counterweight — it helps with balance.'**
  String get exerciseLegsS5PistolTip;

  /// No description provided for @exerciseWarmupLegSwingsName.
  ///
  /// In en, this message translates to:
  /// **'Leg Swings'**
  String get exerciseWarmupLegSwingsName;

  /// No description provided for @exerciseWarmupLegSwingsDesc.
  ///
  /// In en, this message translates to:
  /// **'Standing by a wall, swing one leg forward and back, then side to side. Warms up the hip joint.'**
  String get exerciseWarmupLegSwingsDesc;

  /// No description provided for @exerciseCooldownQuadStretchName.
  ///
  /// In en, this message translates to:
  /// **'Quad Stretch'**
  String get exerciseCooldownQuadStretchName;

  /// No description provided for @exerciseCooldownQuadStretchDesc.
  ///
  /// In en, this message translates to:
  /// **'Stand on one leg, bend the other back and hold your foot with your hand. Feel the stretch along the front of your thigh.'**
  String get exerciseCooldownQuadStretchDesc;

  /// No description provided for @exerciseWarmupHipCirclesName.
  ///
  /// In en, this message translates to:
  /// **'Hip Circles'**
  String get exerciseWarmupHipCirclesName;

  /// No description provided for @exerciseWarmupHipCirclesDesc.
  ///
  /// In en, this message translates to:
  /// **'Stand with feet shoulder-width apart. Make slow circular movements with your hips clockwise then counter-clockwise. Warms up the hip joints.'**
  String get exerciseWarmupHipCirclesDesc;

  /// No description provided for @exerciseCooldownHipFlexorName.
  ///
  /// In en, this message translates to:
  /// **'Hip Flexor Stretch'**
  String get exerciseCooldownHipFlexorName;

  /// No description provided for @exerciseCooldownHipFlexorDesc.
  ///
  /// In en, this message translates to:
  /// **'Step into a lunge and lower your back knee to the floor. Press your hips forward and down to feel the stretch in your hip. Hold each side.'**
  String get exerciseCooldownHipFlexorDesc;

  /// No description provided for @exerciseBalS1OneLegStandName.
  ///
  /// In en, this message translates to:
  /// **'One-Leg Stand'**
  String get exerciseBalS1OneLegStandName;

  /// No description provided for @exerciseBalS1OneLegStandDesc.
  ///
  /// In en, this message translates to:
  /// **'Stand on one leg, keep the other slightly bent and off the ground. Arms can be out for balance.'**
  String get exerciseBalS1OneLegStandDesc;

  /// No description provided for @exerciseBalS1OneLegStandTip.
  ///
  /// In en, this message translates to:
  /// **'Fix your gaze on a point — it greatly improves balance.'**
  String get exerciseBalS1OneLegStandTip;

  /// No description provided for @exerciseBalS2OneArmPlankName.
  ///
  /// In en, this message translates to:
  /// **'One-Arm Plank'**
  String get exerciseBalS2OneArmPlankName;

  /// No description provided for @exerciseBalS2OneArmPlankDesc.
  ///
  /// In en, this message translates to:
  /// **'Classic straight-arm plank. Lift one hand off the floor and hold the position, body parallel to the floor.'**
  String get exerciseBalS2OneArmPlankDesc;

  /// No description provided for @exerciseBalS2OneArmPlankTip.
  ///
  /// In en, this message translates to:
  /// **'Keep your hips parallel to the floor — don\'t rotate your torso.'**
  String get exerciseBalS2OneArmPlankTip;

  /// No description provided for @exerciseBalS3CrowPrepName.
  ///
  /// In en, this message translates to:
  /// **'Crow Pose Prep'**
  String get exerciseBalS3CrowPrepName;

  /// No description provided for @exerciseBalS3CrowPrepDesc.
  ///
  /// In en, this message translates to:
  /// **'Squat with knees on your triceps. Shift weight onto your hands, gently lifting your feet. Hold the balance.'**
  String get exerciseBalS3CrowPrepDesc;

  /// No description provided for @exerciseBalS3CrowPrepTip.
  ///
  /// In en, this message translates to:
  /// **'Look forward-down, not straight down — or you\'ll tip over.'**
  String get exerciseBalS3CrowPrepTip;

  /// No description provided for @exerciseBalS4CrowPoseName.
  ///
  /// In en, this message translates to:
  /// **'Crow Pose (Kakasana)'**
  String get exerciseBalS4CrowPoseName;

  /// No description provided for @exerciseBalS4CrowPoseDesc.
  ///
  /// In en, this message translates to:
  /// **'Both knees on your triceps, full balance on your hands. Arms slightly bent, fingers spread wide.'**
  String get exerciseBalS4CrowPoseDesc;

  /// No description provided for @exerciseBalS4CrowPoseTip.
  ///
  /// In en, this message translates to:
  /// **'Round your back — it engages your core and provides balance.'**
  String get exerciseBalS4CrowPoseTip;

  /// No description provided for @exerciseBalS5WallHsName.
  ///
  /// In en, this message translates to:
  /// **'Wall Handstand'**
  String get exerciseBalS5WallHsName;

  /// No description provided for @exerciseBalS5WallHsDesc.
  ///
  /// In en, this message translates to:
  /// **'Kick up into a handstand with your back to the wall. Heels touch the wall for support. Hold the position, body in a straight line.'**
  String get exerciseBalS5WallHsDesc;

  /// No description provided for @exerciseBalS5WallHsTip.
  ///
  /// In en, this message translates to:
  /// **'Spread fingers wide and press through the pads — that\'s your balance control.'**
  String get exerciseBalS5WallHsTip;

  /// No description provided for @exerciseBalS6FreeHsName.
  ///
  /// In en, this message translates to:
  /// **'Free Handstand'**
  String get exerciseBalS6FreeHsName;

  /// No description provided for @exerciseBalS6FreeHsDesc.
  ///
  /// In en, this message translates to:
  /// **'Handstand without wall support. Control balance with small finger and wrist movements.'**
  String get exerciseBalS6FreeHsDesc;

  /// No description provided for @exerciseBalS6FreeHsTip.
  ///
  /// In en, this message translates to:
  /// **'Look at the floor 30–40 cm in front of your hands, not between them.'**
  String get exerciseBalS6FreeHsTip;

  /// No description provided for @exerciseWarmupWristCirclesName.
  ///
  /// In en, this message translates to:
  /// **'Wrist Circles'**
  String get exerciseWarmupWristCirclesName;

  /// No description provided for @exerciseWarmupWristCirclesDesc.
  ///
  /// In en, this message translates to:
  /// **'Rotate your wrists clockwise and counter-clockwise. Prepares your joints for weight-bearing on your hands.'**
  String get exerciseWarmupWristCirclesDesc;

  /// No description provided for @exerciseCooldownDownwardDogName.
  ///
  /// In en, this message translates to:
  /// **'Downward Dog'**
  String get exerciseCooldownDownwardDogName;

  /// No description provided for @exerciseCooldownDownwardDogDesc.
  ///
  /// In en, this message translates to:
  /// **'From all fours, straighten arms and legs and lift your hips up. Body forms an inverted V. Stretches wrists, shoulders, and legs.'**
  String get exerciseCooldownDownwardDogDesc;

  /// No description provided for @exerciseCooldownWristStretchName.
  ///
  /// In en, this message translates to:
  /// **'Wrist Stretch'**
  String get exerciseCooldownWristStretchName;

  /// No description provided for @exerciseCooldownWristStretchDesc.
  ///
  /// In en, this message translates to:
  /// **'Extend one arm forward, palm up. Use your other hand to gently pull the fingers down. Hold for 30 seconds per side.'**
  String get exerciseCooldownWristStretchDesc;

  /// No description provided for @aboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutTitle;

  /// No description provided for @aboutVersion.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get aboutVersion;

  /// No description provided for @aboutSectionSupport.
  ///
  /// In en, this message translates to:
  /// **'SUPPORT'**
  String get aboutSectionSupport;

  /// No description provided for @aboutContactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get aboutContactUs;

  /// No description provided for @aboutContactUsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Report a bug or ask a question'**
  String get aboutContactUsSubtitle;

  /// No description provided for @aboutPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get aboutPrivacyPolicy;

  /// No description provided for @aboutBuiltWith.
  ///
  /// In en, this message translates to:
  /// **'BUILT WITH'**
  String get aboutBuiltWith;

  /// No description provided for @aboutCopyright.
  ///
  /// In en, this message translates to:
  /// **'© 2026 pupptmstr'**
  String get aboutCopyright;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @settingsSectionHealth.
  ///
  /// In en, this message translates to:
  /// **'HEALTH'**
  String get settingsSectionHealth;

  /// No description provided for @settingsHealthWorkoutsTitle.
  ///
  /// In en, this message translates to:
  /// **'Record workouts'**
  String get settingsHealthWorkoutsTitle;

  /// No description provided for @settingsHealthWorkoutsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Save to Apple Health / Health Connect'**
  String get settingsHealthWorkoutsSubtitle;

  /// No description provided for @settingsHealthWeightTitle.
  ///
  /// In en, this message translates to:
  /// **'Read body weight'**
  String get settingsHealthWeightTitle;

  /// No description provided for @settingsHealthWeightSubtitle.
  ///
  /// In en, this message translates to:
  /// **'For accurate calorie estimates (default 70 kg)'**
  String get settingsHealthWeightSubtitle;

  /// No description provided for @summaryHealthSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved to Health ✓'**
  String get summaryHealthSaved;

  /// No description provided for @friendsTitle.
  ///
  /// In en, this message translates to:
  /// **'Friends'**
  String get friendsTitle;

  /// No description provided for @friendsMyQrTitle.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get friendsMyQrTitle;

  /// No description provided for @friendsShareHint.
  ///
  /// In en, this message translates to:
  /// **'Show this code to a friend to share your profile'**
  String get friendsShareHint;

  /// No description provided for @friendsScanQr.
  ///
  /// In en, this message translates to:
  /// **'Scan QR Code'**
  String get friendsScanQr;

  /// No description provided for @friendsSectionNearby.
  ///
  /// In en, this message translates to:
  /// **'NEARBY'**
  String get friendsSectionNearby;

  /// No description provided for @friendsSectionList.
  ///
  /// In en, this message translates to:
  /// **'FRIENDS'**
  String get friendsSectionList;

  /// No description provided for @friendsNearbyEmpty.
  ///
  /// In en, this message translates to:
  /// **'No CaliDay users found nearby'**
  String get friendsNearbyEmpty;

  /// No description provided for @friendsNearbyScanning.
  ///
  /// In en, this message translates to:
  /// **'Scanning…'**
  String get friendsNearbyScanning;

  /// No description provided for @friendsNearbyBleOff.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth is off'**
  String get friendsNearbyBleOff;

  /// No description provided for @friendsNearbyConnect.
  ///
  /// In en, this message translates to:
  /// **'Get profile'**
  String get friendsNearbyConnect;

  /// No description provided for @friendsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No friends yet. Scan a QR code to add your first friend.'**
  String get friendsEmpty;

  /// No description provided for @friendsAdded.
  ///
  /// In en, this message translates to:
  /// **'Friend added!'**
  String get friendsAdded;

  /// No description provided for @friendsUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated!'**
  String get friendsUpdated;

  /// No description provided for @friendsScanError.
  ///
  /// In en, this message translates to:
  /// **'Invalid QR code'**
  String get friendsScanError;

  /// No description provided for @friendsScanConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'{sp} SP · {streak}-day streak'**
  String friendsScanConfirmBody(int sp, int streak);

  /// No description provided for @friendsCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get friendsCancel;

  /// No description provided for @friendsAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get friendsAdd;

  /// No description provided for @friendsDetailLastSynced.
  ///
  /// In en, this message translates to:
  /// **'Synced: {date}'**
  String friendsDetailLastSynced(String date);

  /// No description provided for @friendsDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove friend'**
  String get friendsDeleteTitle;

  /// No description provided for @friendsDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'Remove {name} from friends?'**
  String friendsDeleteBody(String name);

  /// No description provided for @friendsDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get friendsDeleteConfirm;

  /// No description provided for @settingsSectionFriends.
  ///
  /// In en, this message translates to:
  /// **'FRIENDS'**
  String get settingsSectionFriends;

  /// No description provided for @settingsFriendsNameTitle.
  ///
  /// In en, this message translates to:
  /// **'Display name'**
  String get settingsFriendsNameTitle;

  /// No description provided for @settingsFriendsNameSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Shown to friends when sharing your profile'**
  String get settingsFriendsNameSubtitle;

  /// No description provided for @settingsFriendsNamePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get settingsFriendsNamePlaceholder;

  /// No description provided for @settingsFriendsDiscoverableTitle.
  ///
  /// In en, this message translates to:
  /// **'Discoverable via Bluetooth'**
  String get settingsFriendsDiscoverableTitle;

  /// No description provided for @settingsFriendsDiscoverableSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Other CaliDay users can find you nearby'**
  String get settingsFriendsDiscoverableSubtitle;

  /// No description provided for @profileFriendsTitle.
  ///
  /// In en, this message translates to:
  /// **'Friends'**
  String get profileFriendsTitle;

  /// No description provided for @profileFriendsAll.
  ///
  /// In en, this message translates to:
  /// **'All friends →'**
  String get profileFriendsAll;

  /// No description provided for @profileFriendsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No friends yet'**
  String get profileFriendsEmpty;

  /// No description provided for @profileFriendsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} friends'**
  String profileFriendsCount(int count);

  /// No description provided for @exerciseFlexS1HipFlexorStretchName.
  ///
  /// In en, this message translates to:
  /// **'Hip Flexor Stretch'**
  String get exerciseFlexS1HipFlexorStretchName;

  /// No description provided for @exerciseFlexS1HipFlexorStretchDesc.
  ///
  /// In en, this message translates to:
  /// **'Step into a lunge and lower your back knee to the floor. Push your hips forward to feel the stretch at the front of your hip. Hold each side.'**
  String get exerciseFlexS1HipFlexorStretchDesc;

  /// No description provided for @exerciseFlexS1HipFlexorStretchTip.
  ///
  /// In en, this message translates to:
  /// **'Keep your back straight and push hips forward — feel the stretch in the front of your hip.'**
  String get exerciseFlexS1HipFlexorStretchTip;

  /// No description provided for @exerciseFlexS2WorldsGreatestStretchName.
  ///
  /// In en, this message translates to:
  /// **'World\'s Greatest Stretch'**
  String get exerciseFlexS2WorldsGreatestStretchName;

  /// No description provided for @exerciseFlexS2WorldsGreatestStretchDesc.
  ///
  /// In en, this message translates to:
  /// **'From a lunge, place the same-side hand on the floor. Rotate your upper body and reach the other arm toward the ceiling. Flow through the movement.'**
  String get exerciseFlexS2WorldsGreatestStretchDesc;

  /// No description provided for @exerciseFlexS2WorldsGreatestStretchTip.
  ///
  /// In en, this message translates to:
  /// **'Move slowly through each position — this is a flow, not a race.'**
  String get exerciseFlexS2WorldsGreatestStretchTip;

  /// No description provided for @exerciseFlexS3Hip9090Name.
  ///
  /// In en, this message translates to:
  /// **'90/90 Hip Mobility'**
  String get exerciseFlexS3Hip9090Name;

  /// No description provided for @exerciseFlexS3Hip9090Desc.
  ///
  /// In en, this message translates to:
  /// **'Sit on the floor with both legs bent at 90°, one in front and one to the side. Hold the position and switch sides.'**
  String get exerciseFlexS3Hip9090Desc;

  /// No description provided for @exerciseFlexS3Hip9090Tip.
  ///
  /// In en, this message translates to:
  /// **'Keep both sit bones on the floor. Rotate from the hip, not the lower back.'**
  String get exerciseFlexS3Hip9090Tip;

  /// No description provided for @exerciseFlexS4ThoracicBridgeName.
  ///
  /// In en, this message translates to:
  /// **'Thoracic Bridge'**
  String get exerciseFlexS4ThoracicBridgeName;

  /// No description provided for @exerciseFlexS4ThoracicBridgeDesc.
  ///
  /// In en, this message translates to:
  /// **'From a seated position with hands behind you, lift your hips and rotate your upper spine to open the chest toward the ceiling.'**
  String get exerciseFlexS4ThoracicBridgeDesc;

  /// No description provided for @exerciseFlexS4ThoracicBridgeTip.
  ///
  /// In en, this message translates to:
  /// **'Focus movement in the upper back — avoid hinging in the lower back.'**
  String get exerciseFlexS4ThoracicBridgeTip;

  /// No description provided for @exerciseFlexS5DeepSquatHoldName.
  ///
  /// In en, this message translates to:
  /// **'Deep Squat Hold'**
  String get exerciseFlexS5DeepSquatHoldName;

  /// No description provided for @exerciseFlexS5DeepSquatHoldDesc.
  ///
  /// In en, this message translates to:
  /// **'Feet shoulder-width apart, toes slightly out. Squat all the way down and hold. Use a door frame for support as needed.'**
  String get exerciseFlexS5DeepSquatHoldDesc;

  /// No description provided for @exerciseFlexS5DeepSquatHoldTip.
  ///
  /// In en, this message translates to:
  /// **'Use a doorframe or pole for support at first. Heels flat on the floor is the goal.'**
  String get exerciseFlexS5DeepSquatHoldTip;

  /// No description provided for @exerciseFlexS6PikeStretchName.
  ///
  /// In en, this message translates to:
  /// **'Pike Stretch'**
  String get exerciseFlexS6PikeStretchName;

  /// No description provided for @exerciseFlexS6PikeStretchDesc.
  ///
  /// In en, this message translates to:
  /// **'Sit on the floor with legs straight in front of you. Reach your hands toward your feet, hinging at the hips. Hold the position.'**
  String get exerciseFlexS6PikeStretchDesc;

  /// No description provided for @exerciseFlexS6PikeStretchTip.
  ///
  /// In en, this message translates to:
  /// **'Reach forward from your hips, not your waist. Keep legs straight.'**
  String get exerciseFlexS6PikeStretchTip;

  /// No description provided for @exerciseSuppObliqueCrunchName.
  ///
  /// In en, this message translates to:
  /// **'Oblique Crunch'**
  String get exerciseSuppObliqueCrunchName;

  /// No description provided for @exerciseSuppObliqueCrunchDesc.
  ///
  /// In en, this message translates to:
  /// **'Lie on your back, knees bent. Bring your right elbow toward your left knee, then left to right. Alternate.'**
  String get exerciseSuppObliqueCrunchDesc;

  /// No description provided for @exerciseSuppRussianTwistsName.
  ///
  /// In en, this message translates to:
  /// **'Russian Twists'**
  String get exerciseSuppRussianTwistsName;

  /// No description provided for @exerciseSuppRussianTwistsDesc.
  ///
  /// In en, this message translates to:
  /// **'Sit with knees slightly raised and torso leaned back. Rotate your torso left and right — each rotation counts as one rep.'**
  String get exerciseSuppRussianTwistsDesc;

  /// No description provided for @exerciseSuppRussianTwistsTip.
  ///
  /// In en, this message translates to:
  /// **'Keep your back straight, don\'t hunch.'**
  String get exerciseSuppRussianTwistsTip;

  /// No description provided for @exerciseSuppSidePlankName.
  ///
  /// In en, this message translates to:
  /// **'Side Plank'**
  String get exerciseSuppSidePlankName;

  /// No description provided for @exerciseSuppSidePlankDesc.
  ///
  /// In en, this message translates to:
  /// **'Forearm side plank — body in a straight line from head to feet. Hold the position, then repeat on the other side.'**
  String get exerciseSuppSidePlankDesc;

  /// No description provided for @exerciseSuppSidePlankTip.
  ///
  /// In en, this message translates to:
  /// **'Don\'t let your hips drop — keep the line straight.'**
  String get exerciseSuppSidePlankTip;

  /// No description provided for @exerciseSuppStandingCalfRaiseName.
  ///
  /// In en, this message translates to:
  /// **'Standing Calf Raise'**
  String get exerciseSuppStandingCalfRaiseName;

  /// No description provided for @exerciseSuppStandingCalfRaiseDesc.
  ///
  /// In en, this message translates to:
  /// **'Stand tall and slowly rise onto your toes for 2–3 seconds, then lower down. Hold a wall for balance if needed.'**
  String get exerciseSuppStandingCalfRaiseDesc;

  /// No description provided for @exerciseSuppSingleLegCalfRaiseName.
  ///
  /// In en, this message translates to:
  /// **'Single-Leg Calf Raise'**
  String get exerciseSuppSingleLegCalfRaiseName;

  /// No description provided for @exerciseSuppSingleLegCalfRaiseDesc.
  ///
  /// In en, this message translates to:
  /// **'Stand on one foot. Slowly rise onto your toes and lower back down. Repeat on the other leg.'**
  String get exerciseSuppSingleLegCalfRaiseDesc;

  /// No description provided for @exerciseSuppSingleLegCalfRaiseTip.
  ///
  /// In en, this message translates to:
  /// **'Slow tempo — more benefit.'**
  String get exerciseSuppSingleLegCalfRaiseTip;

  /// No description provided for @exerciseSuppDeadBugName.
  ///
  /// In en, this message translates to:
  /// **'Dead Bug'**
  String get exerciseSuppDeadBugName;

  /// No description provided for @exerciseSuppDeadBugDesc.
  ///
  /// In en, this message translates to:
  /// **'Lie on your back, arms pointing up, knees bent 90°. Simultaneously lower your right arm overhead and extend your left leg — almost to the floor. Return. Alternate.'**
  String get exerciseSuppDeadBugDesc;

  /// No description provided for @exerciseSuppDeadBugTip.
  ///
  /// In en, this message translates to:
  /// **'Keep your lower back pressed to the floor throughout.'**
  String get exerciseSuppDeadBugTip;

  /// No description provided for @exerciseSuppBirdDogName.
  ///
  /// In en, this message translates to:
  /// **'Bird-Dog'**
  String get exerciseSuppBirdDogName;

  /// No description provided for @exerciseSuppBirdDogDesc.
  ///
  /// In en, this message translates to:
  /// **'On all fours: simultaneously extend your right arm forward and left leg back. Hold 2 seconds, return. Alternate sides.'**
  String get exerciseSuppBirdDogDesc;

  /// No description provided for @exerciseSuppBirdDogTip.
  ///
  /// In en, this message translates to:
  /// **'Don\'t rotate your pelvis — keep it level.'**
  String get exerciseSuppBirdDogTip;

  /// No description provided for @exerciseSuppNeckIsometricsName.
  ///
  /// In en, this message translates to:
  /// **'Neck Isometrics'**
  String get exerciseSuppNeckIsometricsName;

  /// No description provided for @exerciseSuppNeckIsometricsDesc.
  ///
  /// In en, this message translates to:
  /// **'Press your palm against your forehead and resist — neck pushes back. Then against the back of the head and each temple. Hold 5–10 seconds each direction.'**
  String get exerciseSuppNeckIsometricsDesc;

  /// No description provided for @exerciseSuppNeckIsometricsTip.
  ///
  /// In en, this message translates to:
  /// **'Gentle pressure — don\'t force it.'**
  String get exerciseSuppNeckIsometricsTip;

  /// No description provided for @exerciseSuppWristCirclesName.
  ///
  /// In en, this message translates to:
  /// **'Wrist Circles'**
  String get exerciseSuppWristCirclesName;

  /// No description provided for @exerciseSuppWristCirclesDesc.
  ///
  /// In en, this message translates to:
  /// **'Clench your fists and slowly rotate your wrists clockwise and counter-clockwise. Strengthens forearms and tendons.'**
  String get exerciseSuppWristCirclesDesc;

  /// No description provided for @exerciseWarmupNeckRollsName.
  ///
  /// In en, this message translates to:
  /// **'Neck Rolls'**
  String get exerciseWarmupNeckRollsName;

  /// No description provided for @exerciseWarmupNeckRollsDesc.
  ///
  /// In en, this message translates to:
  /// **'Slowly tilt your head forward, back, and to each side, then make a gentle half-circle from shoulder to shoulder. Warms up neck muscles.'**
  String get exerciseWarmupNeckRollsDesc;

  /// No description provided for @exercisePostureS1PelvicTiltName.
  ///
  /// In en, this message translates to:
  /// **'Pelvic Tilt'**
  String get exercisePostureS1PelvicTiltName;

  /// No description provided for @exercisePostureS1PelvicTiltDesc.
  ///
  /// In en, this message translates to:
  /// **'Lie on your back with knees bent. Slowly press your lower back into the floor by engaging your abs. Hold 5 seconds, relax.'**
  String get exercisePostureS1PelvicTiltDesc;

  /// No description provided for @exercisePostureS1PelvicTiltTip.
  ///
  /// In en, this message translates to:
  /// **'Don\'t hold your breath — move smoothly.'**
  String get exercisePostureS1PelvicTiltTip;

  /// No description provided for @exercisePostureS2DeadBugName.
  ///
  /// In en, this message translates to:
  /// **'Dead Bug'**
  String get exercisePostureS2DeadBugName;

  /// No description provided for @exercisePostureS2DeadBugDesc.
  ///
  /// In en, this message translates to:
  /// **'Lie on your back, arms pointing up, knees at 90°. Slowly lower one arm and the opposite leg without letting your lower back arch.'**
  String get exercisePostureS2DeadBugDesc;

  /// No description provided for @exercisePostureS2DeadBugTip.
  ///
  /// In en, this message translates to:
  /// **'Move slowly — this is about control, not speed. Keep your lower back pressed flat the whole time.'**
  String get exercisePostureS2DeadBugTip;

  /// No description provided for @exercisePostureS3GluteBridgeName.
  ///
  /// In en, this message translates to:
  /// **'Glute Bridge'**
  String get exercisePostureS3GluteBridgeName;

  /// No description provided for @exercisePostureS3GluteBridgeDesc.
  ///
  /// In en, this message translates to:
  /// **'Lie on your back, knees bent, feet flat on floor. Drive your hips up by squeezing your glutes, hold briefly, lower down.'**
  String get exercisePostureS3GluteBridgeDesc;

  /// No description provided for @exercisePostureS3GluteBridgeTip.
  ///
  /// In en, this message translates to:
  /// **'Squeeze your glutes hard at the top — avoid pushing with your lower back.'**
  String get exercisePostureS3GluteBridgeTip;

  /// No description provided for @exercisePostureS4HipMarchName.
  ///
  /// In en, this message translates to:
  /// **'Standing Hip March'**
  String get exercisePostureS4HipMarchName;

  /// No description provided for @exercisePostureS4HipMarchDesc.
  ///
  /// In en, this message translates to:
  /// **'Stand tall. Slowly lift one knee to hip height and lower it. Alternate sides. Keep your torso upright and still.'**
  String get exercisePostureS4HipMarchDesc;

  /// No description provided for @exercisePostureS4HipMarchTip.
  ///
  /// In en, this message translates to:
  /// **'Lift each knee to hip height without leaning your torso — focus on the hip flexor doing the work, not momentum.'**
  String get exercisePostureS4HipMarchTip;

  /// No description provided for @exercisePostureS5KneelingLungeName.
  ///
  /// In en, this message translates to:
  /// **'Kneeling Hip Flexor Stretch'**
  String get exercisePostureS5KneelingLungeName;

  /// No description provided for @exercisePostureS5KneelingLungeDesc.
  ///
  /// In en, this message translates to:
  /// **'Kneel on one knee, other foot in front. Push your hips forward until you feel a stretch at the front of your rear hip. Hold.'**
  String get exercisePostureS5KneelingLungeDesc;

  /// No description provided for @exercisePostureS5KneelingLungeTip.
  ///
  /// In en, this message translates to:
  /// **'Keep your back straight and gently tuck your pelvis under to deepen the stretch.'**
  String get exercisePostureS5KneelingLungeTip;

  /// No description provided for @exercisePostureS6PigeonPoseName.
  ///
  /// In en, this message translates to:
  /// **'Pigeon Pose'**
  String get exercisePostureS6PigeonPoseName;

  /// No description provided for @exercisePostureS6PigeonPoseDesc.
  ///
  /// In en, this message translates to:
  /// **'From all fours, bring your right leg forward bent at 90°. Extend the left leg back. Lower your hips toward the floor and hold the position.'**
  String get exercisePostureS6PigeonPoseDesc;

  /// No description provided for @exercisePostureS6PigeonPoseTip.
  ///
  /// In en, this message translates to:
  /// **'Breathe deeply — the pose opens the hip gradually.'**
  String get exercisePostureS6PigeonPoseTip;

  /// No description provided for @exerciseNeckS1NeckTiltName.
  ///
  /// In en, this message translates to:
  /// **'Neck Tilt'**
  String get exerciseNeckS1NeckTiltName;

  /// No description provided for @exerciseNeckS1NeckTiltDesc.
  ///
  /// In en, this message translates to:
  /// **'Slowly tilt your head toward your right shoulder — without raising the shoulder. Hold 5 seconds, return. Alternate sides.'**
  String get exerciseNeckS1NeckTiltDesc;

  /// No description provided for @exerciseNeckS1NeckTiltTip.
  ///
  /// In en, this message translates to:
  /// **'Let the shoulder drop down — that deepens the stretch.'**
  String get exerciseNeckS1NeckTiltTip;

  /// No description provided for @exerciseNeckS2ChestOpenerName.
  ///
  /// In en, this message translates to:
  /// **'Chest Opener'**
  String get exerciseNeckS2ChestOpenerName;

  /// No description provided for @exerciseNeckS2ChestOpenerDesc.
  ///
  /// In en, this message translates to:
  /// **'Stand tall, clasp your hands behind your back. Squeeze your shoulder blades together and gently lift your arms while opening your chest.'**
  String get exerciseNeckS2ChestOpenerDesc;

  /// No description provided for @exerciseNeckS2ChestOpenerTip.
  ///
  /// In en, this message translates to:
  /// **'Focus on squeezing your shoulder blades — do not arch your lower back.'**
  String get exerciseNeckS2ChestOpenerTip;

  /// No description provided for @exerciseNeckS3ShoulderRollName.
  ///
  /// In en, this message translates to:
  /// **'Shoulder Circles'**
  String get exerciseNeckS3ShoulderRollName;

  /// No description provided for @exerciseNeckS3ShoulderRollDesc.
  ///
  /// In en, this message translates to:
  /// **'Roll your shoulders in large, slow circles — forward 5 times, then backward 5 times. Keep your neck relaxed throughout.'**
  String get exerciseNeckS3ShoulderRollDesc;

  /// No description provided for @exerciseNeckS3ShoulderRollTip.
  ///
  /// In en, this message translates to:
  /// **'Make the circles as big as possible — exaggerate the movement.'**
  String get exerciseNeckS3ShoulderRollTip;

  /// No description provided for @exerciseNeckS4WallAngelName.
  ///
  /// In en, this message translates to:
  /// **'Wall Angels'**
  String get exerciseNeckS4WallAngelName;

  /// No description provided for @exerciseNeckS4WallAngelDesc.
  ///
  /// In en, this message translates to:
  /// **'Stand with your back, head and arms flat against a wall. Slide your arms up overhead while keeping contact with the wall. Slowly lower back down.'**
  String get exerciseNeckS4WallAngelDesc;

  /// No description provided for @exerciseNeckS4WallAngelTip.
  ///
  /// In en, this message translates to:
  /// **'Keep your lower back flat against the wall the whole time — this is harder than it looks.'**
  String get exerciseNeckS4WallAngelTip;

  /// No description provided for @exerciseNeckS5DoorwayStretchName.
  ///
  /// In en, this message translates to:
  /// **'Doorway Pec Stretch'**
  String get exerciseNeckS5DoorwayStretchName;

  /// No description provided for @exerciseNeckS5DoorwayStretchDesc.
  ///
  /// In en, this message translates to:
  /// **'Stand in a doorway. Place both forearms on the door frame at shoulder height. Lean forward gently until you feel a stretch across your chest and shoulders. Hold.'**
  String get exerciseNeckS5DoorwayStretchDesc;

  /// No description provided for @exerciseNeckS5DoorwayStretchTip.
  ///
  /// In en, this message translates to:
  /// **'Keep your core engaged and don\'t arch your lower back as you lean forward.'**
  String get exerciseNeckS5DoorwayStretchTip;

  /// No description provided for @tooltipStreakTitle.
  ///
  /// In en, this message translates to:
  /// **'Current Streak'**
  String get tooltipStreakTitle;

  /// No description provided for @tooltipStreakBody.
  ///
  /// In en, this message translates to:
  /// **'The number of days in a row you\'ve trained. Miss a day without a streak freeze and it resets to zero. Keep the fire burning — Goro is watching!'**
  String get tooltipStreakBody;

  /// No description provided for @tooltipLongestStreakTitle.
  ///
  /// In en, this message translates to:
  /// **'Personal Record'**
  String get tooltipLongestStreakTitle;

  /// No description provided for @tooltipLongestStreakBody.
  ///
  /// In en, this message translates to:
  /// **'Your all-time longest unbroken training streak. Once set, this record stays forever — even if your current streak resets.'**
  String get tooltipLongestStreakBody;

  /// No description provided for @tooltipTotalWorkoutsTitle.
  ///
  /// In en, this message translates to:
  /// **'Total Workouts'**
  String get tooltipTotalWorkoutsTitle;

  /// No description provided for @tooltipTotalWorkoutsBody.
  ///
  /// In en, this message translates to:
  /// **'The total number of workout sessions you\'ve completed since you started. Every session counts — even bonus workouts stack up here.'**
  String get tooltipTotalWorkoutsBody;

  /// No description provided for @tooltipFreezesTitle.
  ///
  /// In en, this message translates to:
  /// **'Streak Freezes'**
  String get tooltipFreezesTitle;

  /// No description provided for @tooltipFreezesBody.
  ///
  /// In en, this message translates to:
  /// **'Freezes protect your streak when you miss a day. They are earned automatically as you train consistently. You can hold up to 3 freezes at once.'**
  String get tooltipFreezesBody;

  /// No description provided for @tooltipRankTitle.
  ///
  /// In en, this message translates to:
  /// **'Rank & Strength Points'**
  String get tooltipRankTitle;

  /// No description provided for @tooltipRankBody.
  ///
  /// In en, this message translates to:
  /// **'SP (Strength Points) are earned every time you complete a workout. As you collect SP your rank climbs from Beginner all the way to Legend. The more you train, the higher you rise.'**
  String get tooltipRankBody;

  // ── Exercise Library ────────────────────────────────────────────────────────

  /// No description provided for @exerciseLibraryTitle.
  ///
  /// In en, this message translates to:
  /// **'All Exercises'**
  String get exerciseLibraryTitle;

  /// No description provided for @exerciseLibrarySearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search exercises...'**
  String get exerciseLibrarySearchHint;

  /// No description provided for @exerciseLibraryCatalogButton.
  ///
  /// In en, this message translates to:
  /// **'Exercise Catalog'**
  String get exerciseLibraryCatalogButton;

  /// No description provided for @exerciseLibraryEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing found'**
  String get exerciseLibraryEmpty;

  /// No description provided for @exerciseDetailTipLabel.
  ///
  /// In en, this message translates to:
  /// **'Technique'**
  String get exerciseDetailTipLabel;

  /// No description provided for @exerciseDetailStageLabel.
  ///
  /// In en, this message translates to:
  /// **'Stage {stage}'**
  String exerciseDetailStageLabel(int stage);

  // ── Exercise Tags ───────────────────────────────────────────────────────────

  /// In en, this message translates to: **'Hip Flexors'**
  String get exerciseTagHipFlexor;
  /// In en, this message translates to: **'Glutes'**
  String get exerciseTagGlutes;
  /// In en, this message translates to: **'Core'**
  String get exerciseTagCore;
  /// In en, this message translates to: **'Chest'**
  String get exerciseTagChest;
  /// In en, this message translates to: **'Back'**
  String get exerciseTagBack;
  /// In en, this message translates to: **'Shoulders'**
  String get exerciseTagShoulders;
  /// In en, this message translates to: **'Legs'**
  String get exerciseTagLegs;
  /// In en, this message translates to: **'Neck'**
  String get exerciseTagNeck;
  /// In en, this message translates to: **'Stretch'**
  String get exerciseTagStretch;
  /// In en, this message translates to: **'Mobility'**
  String get exerciseTagMobility;
  /// In en, this message translates to: **'Strength'**
  String get exerciseTagStrength;
  /// In en, this message translates to: **'Endurance'**
  String get exerciseTagEndurance;
  /// In en, this message translates to: **'Desk Recovery'**
  String get exerciseTagSittingRecovery;
  /// In en, this message translates to: **'No Equipment'**
  String get exerciseTagFloorOnly;
  /// In en, this message translates to: **'Requires Bar'**
  String get exerciseTagRequiresBar;
  /// In en, this message translates to: **'Posture'**
  String get exerciseTagPostureFocus;
  /// In en, this message translates to: **'Beginner'**
  String get exerciseTagBeginner;
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
