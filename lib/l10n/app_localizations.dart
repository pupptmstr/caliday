import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
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
    Locale('de'),
    Locale('es'),
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

  /// No description provided for @durationSecPerSide.
  ///
  /// In en, this message translates to:
  /// **'{secs} sec each side'**
  String durationSecPerSide(int secs);

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

  /// No description provided for @progressInfo.
  ///
  /// In en, this message translates to:
  /// **'Just keep training — the app advances you through the branches automatically. Here you can track how far you\'ve come. And if you feel ready to push ahead early, take the Challenge and move forward yourself.'**
  String get progressInfo;

  /// No description provided for @homeStreakDays.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} day} other{{count} days}}'**
  String homeStreakDays(int count);

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

  /// No description provided for @homeBranchEveningBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get homeBranchEveningBack;

  /// No description provided for @homeBranchEveningHips.
  ///
  /// In en, this message translates to:
  /// **'Hips'**
  String get homeBranchEveningHips;

  /// No description provided for @homeBranchEveningFolds.
  ///
  /// In en, this message translates to:
  /// **'Folds'**
  String get homeBranchEveningFolds;

  /// No description provided for @homeBranchEveningShoulders.
  ///
  /// In en, this message translates to:
  /// **'Shoulders'**
  String get homeBranchEveningShoulders;

  /// No description provided for @homeBranchMorningSpine.
  ///
  /// In en, this message translates to:
  /// **'Spine'**
  String get homeBranchMorningSpine;

  /// No description provided for @homeBranchMorningJoints.
  ///
  /// In en, this message translates to:
  /// **'Joints'**
  String get homeBranchMorningJoints;

  /// No description provided for @homeBranchMorningArms.
  ///
  /// In en, this message translates to:
  /// **'Arms'**
  String get homeBranchMorningArms;

  /// No description provided for @homeBranchMorningEnergy.
  ///
  /// In en, this message translates to:
  /// **'Energy'**
  String get homeBranchMorningEnergy;

  /// No description provided for @homeBranchYogaStanding.
  ///
  /// In en, this message translates to:
  /// **'Standing'**
  String get homeBranchYogaStanding;

  /// No description provided for @homeBranchYogaOneLeg.
  ///
  /// In en, this message translates to:
  /// **'Equilibrium'**
  String get homeBranchYogaOneLeg;

  /// No description provided for @homeBranchYogaBackbends.
  ///
  /// In en, this message translates to:
  /// **'Backbends'**
  String get homeBranchYogaBackbends;

  /// No description provided for @homeBranchYogaFlow.
  ///
  /// In en, this message translates to:
  /// **'Flow'**
  String get homeBranchYogaFlow;

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

  /// No description provided for @courseNameEveningStretch.
  ///
  /// In en, this message translates to:
  /// **'Evening Stretch'**
  String get courseNameEveningStretch;

  /// No description provided for @courseNameMorningRoutine.
  ///
  /// In en, this message translates to:
  /// **'Morning Routine'**
  String get courseNameMorningRoutine;

  /// No description provided for @courseNameYoga.
  ///
  /// In en, this message translates to:
  /// **'Yoga'**
  String get courseNameYoga;

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

  /// No description provided for @courseDescEveningStretch.
  ///
  /// In en, this message translates to:
  /// **'A calm stretch before sleep. Back, hips, legs and shoulders: slowly, on the floor, ending lying down.'**
  String get courseDescEveningStretch;

  /// No description provided for @courseDescMorningRoutine.
  ///
  /// In en, this message translates to:
  /// **'Wake your body up. Spine, joints, arms and a little energy: standing, quietly, no jumps.'**
  String get courseDescMorningRoutine;

  /// No description provided for @courseDescYoga.
  ///
  /// In en, this message translates to:
  /// **'Poses from easy to hard: standing poses, balancing on one leg, backbends, sun salutations and arm balances.'**
  String get courseDescYoga;

  /// No description provided for @onboardingQ4Courses.
  ///
  /// In en, this message translates to:
  /// **'Choose a Course'**
  String get onboardingQ4Courses;

  /// No description provided for @onboardingQ4CoursesBody.
  ///
  /// In en, this message translates to:
  /// **'You can start with one or pick several — the programs are independent.'**
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
  /// **'{reps, plural, one{{reps} rep} other{{reps} reps}} × {sets, plural, one{{sets} set} other{{sets} sets}}  ·  Rest {rest} s'**
  String branchJourneyParams(int reps, int sets, int rest);

  /// No description provided for @branchJourneyParamsTimed.
  ///
  /// In en, this message translates to:
  /// **'{secs} s × {sets, plural, one{{sets} set} other{{sets} sets}}  ·  Rest {rest} s'**
  String branchJourneyParamsTimed(int secs, int sets, int rest);

  /// No description provided for @branchJourneyParamsTimedPerSide.
  ///
  /// In en, this message translates to:
  /// **'{secs} s each side × {sets, plural, one{{sets} set} other{{sets} sets}}  ·  Rest {rest} s'**
  String branchJourneyParamsTimedPerSide(int secs, int sets, int rest);

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
  /// **'Goal: {n, plural, one{{n} rep} other{{n} reps}}'**
  String homeChallengeNormReps(int n);

  /// No description provided for @homeChallengeNormSec.
  ///
  /// In en, this message translates to:
  /// **'Goal: {n} sec'**
  String homeChallengeNormSec(int n);

  /// No description provided for @homeChallengeNormSecPerSide.
  ///
  /// In en, this message translates to:
  /// **'Goal: {n} sec each side'**
  String homeChallengeNormSecPerSide(int n);

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

  /// No description provided for @homeWorkoutStartEstimate.
  ///
  /// In en, this message translates to:
  /// **'Today\'s workout (≈ {minutes} min)'**
  String homeWorkoutStartEstimate(int minutes);

  /// No description provided for @homeWorkoutAgain.
  ///
  /// In en, this message translates to:
  /// **'Again'**
  String get homeWorkoutAgain;

  /// No description provided for @homeWorkoutAgainEstimate.
  ///
  /// In en, this message translates to:
  /// **'Again (≈ {minutes} min)'**
  String homeWorkoutAgainEstimate(int minutes);

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

  /// No description provided for @workoutSetSideProgress.
  ///
  /// In en, this message translates to:
  /// **'Set {current} of {total}  ·  side {side} of 2'**
  String workoutSetSideProgress(int current, int total, int side);

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

  /// No description provided for @workoutGetReady.
  ///
  /// In en, this message translates to:
  /// **'get ready'**
  String get workoutGetReady;

  /// No description provided for @workoutSwitchSides.
  ///
  /// In en, this message translates to:
  /// **'switch sides'**
  String get workoutSwitchSides;

  /// No description provided for @workoutPaused.
  ///
  /// In en, this message translates to:
  /// **'paused'**
  String get workoutPaused;

  /// No description provided for @workoutPause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get workoutPause;

  /// No description provided for @workoutPrepHint.
  ///
  /// In en, this message translates to:
  /// **'Read the description and get into position. The timer starts by itself; tap Pause if you need more time.'**
  String get workoutPrepHint;

  /// No description provided for @workoutPrepPausedHint.
  ///
  /// In en, this message translates to:
  /// **'Paused. Tap Continue when you are ready: the countdown picks up where it stopped.'**
  String get workoutPrepPausedHint;

  /// No description provided for @workoutSwitchSidesHint.
  ///
  /// In en, this message translates to:
  /// **'Switch to the other side. The timer starts by itself; tap Pause if you need more time.'**
  String get workoutSwitchSidesHint;

  /// No description provided for @workoutStop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
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

  /// No description provided for @workoutAmountReps.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} rep} other{{count} reps}}'**
  String workoutAmountReps(int count);

  /// No description provided for @workoutNextExercise.
  ///
  /// In en, this message translates to:
  /// **'Next: {name} • {amount}'**
  String workoutNextExercise(String name, String amount);

  /// No description provided for @workoutNextSet.
  ///
  /// In en, this message translates to:
  /// **'Next: set {setNum} • {amount}'**
  String workoutNextSet(int setNum, String amount);

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

  /// No description provided for @achievementFlexCompleteName.
  ///
  /// In en, this message translates to:
  /// **'Flexibility Master'**
  String get achievementFlexCompleteName;

  /// No description provided for @achievementFlexCompleteDesc.
  ///
  /// In en, this message translates to:
  /// **'All 6 Flex stages cleared. Your body bends in every direction.'**
  String get achievementFlexCompleteDesc;

  /// No description provided for @achievementEveningBackCompleteName.
  ///
  /// In en, this message translates to:
  /// **'Soft Spine'**
  String get achievementEveningBackCompleteName;

  /// No description provided for @achievementEveningBackCompleteDesc.
  ///
  /// In en, this message translates to:
  /// **'All 5 stages of the evening Back skill cleared. Your spine says thank you.'**
  String get achievementEveningBackCompleteDesc;

  /// No description provided for @achievementEveningHipsCompleteName.
  ///
  /// In en, this message translates to:
  /// **'Open Hips'**
  String get achievementEveningHipsCompleteName;

  /// No description provided for @achievementEveningHipsCompleteDesc.
  ///
  /// In en, this message translates to:
  /// **'All 5 stages of the evening Hips skill cleared. From knees-to-chest to the frog.'**
  String get achievementEveningHipsCompleteDesc;

  /// No description provided for @achievementEveningFoldsCompleteName.
  ///
  /// In en, this message translates to:
  /// **'Deep Fold'**
  String get achievementEveningFoldsCompleteName;

  /// No description provided for @achievementEveningFoldsCompleteDesc.
  ///
  /// In en, this message translates to:
  /// **'All 4 stages of the evening Folds skill cleared. Down to the floor between your legs.'**
  String get achievementEveningFoldsCompleteDesc;

  /// No description provided for @achievementEveningShouldersCompleteName.
  ///
  /// In en, this message translates to:
  /// **'Free Shoulders'**
  String get achievementEveningShouldersCompleteName;

  /// No description provided for @achievementEveningShouldersCompleteDesc.
  ///
  /// In en, this message translates to:
  /// **'All 5 stages of the evening Shoulders skill cleared. Fingers hooked behind your back.'**
  String get achievementEveningShouldersCompleteDesc;

  /// No description provided for @achievementMorningSpineCompleteName.
  ///
  /// In en, this message translates to:
  /// **'Windmill'**
  String get achievementMorningSpineCompleteName;

  /// No description provided for @achievementMorningSpineCompleteDesc.
  ///
  /// In en, this message translates to:
  /// **'All 5 stages of the morning Spine skill cleared. From side bends to the windmill.'**
  String get achievementMorningSpineCompleteDesc;

  /// No description provided for @achievementMorningJointsCompleteName.
  ///
  /// In en, this message translates to:
  /// **'Well-Oiled'**
  String get achievementMorningJointsCompleteName;

  /// No description provided for @achievementMorningJointsCompleteDesc.
  ///
  /// In en, this message translates to:
  /// **'All 5 stages of the morning Joints skill cleared. All the way to the Cossack squat.'**
  String get achievementMorningJointsCompleteDesc;

  /// No description provided for @achievementMorningArmsCompleteName.
  ///
  /// In en, this message translates to:
  /// **'Open Arms'**
  String get achievementMorningArmsCompleteName;

  /// No description provided for @achievementMorningArmsCompleteDesc.
  ///
  /// In en, this message translates to:
  /// **'All 5 stages of the morning Arms skill cleared. From arm swings to plank to downward dog.'**
  String get achievementMorningArmsCompleteDesc;

  /// No description provided for @achievementMorningEnergyCompleteName.
  ///
  /// In en, this message translates to:
  /// **'Early Bird'**
  String get achievementMorningEnergyCompleteName;

  /// No description provided for @achievementMorningEnergyCompleteDesc.
  ///
  /// In en, this message translates to:
  /// **'All 5 stages of the morning Energy skill cleared. Wide awake before the first coffee.'**
  String get achievementMorningEnergyCompleteDesc;

  /// No description provided for @achievementYogaStandingCompleteName.
  ///
  /// In en, this message translates to:
  /// **'Warrior'**
  String get achievementYogaStandingCompleteName;

  /// No description provided for @achievementYogaStandingCompleteDesc.
  ///
  /// In en, this message translates to:
  /// **'All 5 stages of the yoga Standing skill cleared. From chair to side angle.'**
  String get achievementYogaStandingCompleteDesc;

  /// No description provided for @achievementYogaOneLegCompleteName.
  ///
  /// In en, this message translates to:
  /// **'Flamingo'**
  String get achievementYogaOneLegCompleteName;

  /// No description provided for @achievementYogaOneLegCompleteDesc.
  ///
  /// In en, this message translates to:
  /// **'All 5 stages of the Equilibrium skill cleared. From tree to half moon.'**
  String get achievementYogaOneLegCompleteDesc;

  /// No description provided for @achievementYogaBackbendsCompleteName.
  ///
  /// In en, this message translates to:
  /// **'Rainbow'**
  String get achievementYogaBackbendsCompleteName;

  /// No description provided for @achievementYogaBackbendsCompleteDesc.
  ///
  /// In en, this message translates to:
  /// **'All 6 stages of the Backbends skill cleared. From sphinx to wheel.'**
  String get achievementYogaBackbendsCompleteDesc;

  /// No description provided for @achievementYogaFlowCompleteName.
  ///
  /// In en, this message translates to:
  /// **'Sunrise'**
  String get achievementYogaFlowCompleteName;

  /// No description provided for @achievementYogaFlowCompleteDesc.
  ///
  /// In en, this message translates to:
  /// **'All 5 stages of the Flow skill cleared. From downward dog to Sun Salutation B.'**
  String get achievementYogaFlowCompleteDesc;

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
  /// **'×½ SP · each branch moves on once a day'**
  String get summaryBonusBody;

  /// No description provided for @summaryBonusCount.
  ///
  /// In en, this message translates to:
  /// **'You\'ve trained {count, plural, one{{count} time} other{{count} times}} today!'**
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

  /// No description provided for @calendarTitle.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendarTitle;

  /// No description provided for @calendarSeeAll.
  ///
  /// In en, this message translates to:
  /// **'Open →'**
  String get calendarSeeAll;

  /// No description provided for @calendarFreezeUsedTitle.
  ///
  /// In en, this message translates to:
  /// **'Streak freeze used'**
  String get calendarFreezeUsedTitle;

  /// No description provided for @calendarFreezeUsedBody.
  ///
  /// In en, this message translates to:
  /// **'No workout on this day — a streak freeze was used to keep the streak going.'**
  String get calendarFreezeUsedBody;

  /// No description provided for @calendarLegendOneWorkout.
  ///
  /// In en, this message translates to:
  /// **'1 workout'**
  String get calendarLegendOneWorkout;

  /// No description provided for @calendarLegendManyWorkouts.
  ///
  /// In en, this message translates to:
  /// **'2+ workouts'**
  String get calendarLegendManyWorkouts;

  /// No description provided for @calendarLegendFreeze.
  ///
  /// In en, this message translates to:
  /// **'Freeze'**
  String get calendarLegendFreeze;

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
  /// **'{completed} / {target, plural, one{{target} rep} other{{target} reps}}'**
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
  /// **'How big should your workout be?'**
  String get onboardingQ3;

  /// No description provided for @workoutSizeShort.
  ///
  /// In en, this message translates to:
  /// **'Short'**
  String get workoutSizeShort;

  /// No description provided for @workoutSizeStandard.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get workoutSizeStandard;

  /// No description provided for @workoutSizeFull.
  ///
  /// In en, this message translates to:
  /// **'Full'**
  String get workoutSizeFull;

  /// No description provided for @workoutSizeShortDesc.
  ///
  /// In en, this message translates to:
  /// **'2 skills'**
  String get workoutSizeShortDesc;

  /// No description provided for @workoutSizeStandardDesc.
  ///
  /// In en, this message translates to:
  /// **'3 skills'**
  String get workoutSizeStandardDesc;

  /// No description provided for @workoutSizeFullDesc.
  ///
  /// In en, this message translates to:
  /// **'All your skills'**
  String get workoutSizeFullDesc;

  /// No description provided for @settingsWorkoutSizeTitle.
  ///
  /// In en, this message translates to:
  /// **'Workout size'**
  String get settingsWorkoutSizeTitle;

  /// No description provided for @settingsWorkoutSizeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'How many skills to train in the daily workout'**
  String get settingsWorkoutSizeSubtitle;

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

  /// No description provided for @exerciseEveningBackS1CatCowName.
  ///
  /// In en, this message translates to:
  /// **'Cat-Cow'**
  String get exerciseEveningBackS1CatCowName;

  /// No description provided for @exerciseEveningBackS1CatCowDesc.
  ///
  /// In en, this message translates to:
  /// **'On all fours, hands under your shoulders, knees under your hips. Breathing in, let your belly drop and lift your chest; breathing out, round your back toward the ceiling. Move slowly with your breath.'**
  String get exerciseEveningBackS1CatCowDesc;

  /// No description provided for @exerciseEveningBackS1CatCowTip.
  ///
  /// In en, this message translates to:
  /// **'Let the breath lead: one slow breath in and one out per rep.'**
  String get exerciseEveningBackS1CatCowTip;

  /// No description provided for @exerciseEveningBackS2ChildsPoseName.
  ///
  /// In en, this message translates to:
  /// **'Child\'s Pose'**
  String get exerciseEveningBackS2ChildsPoseName;

  /// No description provided for @exerciseEveningBackS2ChildsPoseDesc.
  ///
  /// In en, this message translates to:
  /// **'Kneel with your big toes together and knees apart. Sit back on your heels and lay your chest down between your knees, arms stretched forward, forehead on the floor. Breathe into your back.'**
  String get exerciseEveningBackS2ChildsPoseDesc;

  /// No description provided for @exerciseEveningBackS2ChildsPoseTip.
  ///
  /// In en, this message translates to:
  /// **'Let your hips sink toward your heels with every breath out.'**
  String get exerciseEveningBackS2ChildsPoseTip;

  /// No description provided for @exerciseEveningBackS3SupineTwistName.
  ///
  /// In en, this message translates to:
  /// **'Supine Twist'**
  String get exerciseEveningBackS3SupineTwistName;

  /// No description provided for @exerciseEveningBackS3SupineTwistDesc.
  ///
  /// In en, this message translates to:
  /// **'Lie on your back, arms out to the sides. Bend one knee and let it fall across your body to the floor, looking the other way. Keep both shoulders down.'**
  String get exerciseEveningBackS3SupineTwistDesc;

  /// No description provided for @exerciseEveningBackS3SupineTwistTip.
  ///
  /// In en, this message translates to:
  /// **'Don\'t push the knee down: the weight of the leg does the work.'**
  String get exerciseEveningBackS3SupineTwistTip;

  /// No description provided for @exerciseEveningBackS4SphinxName.
  ///
  /// In en, this message translates to:
  /// **'Sphinx'**
  String get exerciseEveningBackS4SphinxName;

  /// No description provided for @exerciseEveningBackS4SphinxDesc.
  ///
  /// In en, this message translates to:
  /// **'Lie on your stomach, elbows under your shoulders, forearms on the floor. Lift your chest; your hips and legs stay relaxed on the floor.'**
  String get exerciseEveningBackS4SphinxDesc;

  /// No description provided for @exerciseEveningBackS4SphinxTip.
  ///
  /// In en, this message translates to:
  /// **'Draw your shoulders away from your ears; the arch is gentle, never pinching.'**
  String get exerciseEveningBackS4SphinxTip;

  /// No description provided for @exerciseEveningBackS5CobraName.
  ///
  /// In en, this message translates to:
  /// **'Cobra'**
  String get exerciseEveningBackS5CobraName;

  /// No description provided for @exerciseEveningBackS5CobraDesc.
  ///
  /// In en, this message translates to:
  /// **'Lie on your stomach, hands under your shoulders. Press up and straighten your arms as far as your lower back allows; your hips stay on the floor.'**
  String get exerciseEveningBackS5CobraDesc;

  /// No description provided for @exerciseEveningBackS5CobraTip.
  ///
  /// In en, this message translates to:
  /// **'Keep the elbows soft and the shoulders down; stop where your back feels good.'**
  String get exerciseEveningBackS5CobraTip;

  /// No description provided for @exerciseEveningHipsS1KneesToChestName.
  ///
  /// In en, this message translates to:
  /// **'Knees to Chest'**
  String get exerciseEveningHipsS1KneesToChestName;

  /// No description provided for @exerciseEveningHipsS1KneesToChestDesc.
  ///
  /// In en, this message translates to:
  /// **'Lie on your back, hug both knees to your chest and hold. You may rock gently from side to side.'**
  String get exerciseEveningHipsS1KneesToChestDesc;

  /// No description provided for @exerciseEveningHipsS1KneesToChestTip.
  ///
  /// In en, this message translates to:
  /// **'Keep your lower back and your head on the floor.'**
  String get exerciseEveningHipsS1KneesToChestTip;

  /// No description provided for @exerciseEveningHipsS2FigureFourName.
  ///
  /// In en, this message translates to:
  /// **'Reclined Figure Four'**
  String get exerciseEveningHipsS2FigureFourName;

  /// No description provided for @exerciseEveningHipsS2FigureFourDesc.
  ///
  /// In en, this message translates to:
  /// **'Lie on your back, knees bent. Cross one ankle over the other knee, then pull that thigh toward your chest until you feel the stretch in the buttock.'**
  String get exerciseEveningHipsS2FigureFourDesc;

  /// No description provided for @exerciseEveningHipsS2FigureFourTip.
  ///
  /// In en, this message translates to:
  /// **'Press the crossed knee gently away from you to go deeper.'**
  String get exerciseEveningHipsS2FigureFourTip;

  /// No description provided for @exerciseEveningHipsS3HappyBabyName.
  ///
  /// In en, this message translates to:
  /// **'Happy Baby'**
  String get exerciseEveningHipsS3HappyBabyName;

  /// No description provided for @exerciseEveningHipsS3HappyBabyDesc.
  ///
  /// In en, this message translates to:
  /// **'Lie on your back, bring your knees toward your armpits and hold the outer edges of your feet, soles to the ceiling. Gently pull your knees toward the floor.'**
  String get exerciseEveningHipsS3HappyBabyDesc;

  /// No description provided for @exerciseEveningHipsS3HappyBabyTip.
  ///
  /// In en, this message translates to:
  /// **'Keep your tailbone down; rocking a little is fine.'**
  String get exerciseEveningHipsS3HappyBabyTip;

  /// No description provided for @exerciseEveningHipsS4ButterflyName.
  ///
  /// In en, this message translates to:
  /// **'Butterfly'**
  String get exerciseEveningHipsS4ButterflyName;

  /// No description provided for @exerciseEveningHipsS4ButterflyDesc.
  ///
  /// In en, this message translates to:
  /// **'Sit up tall with the soles of your feet together and your knees out to the sides. Hold your feet and let your knees sink toward the floor.'**
  String get exerciseEveningHipsS4ButterflyDesc;

  /// No description provided for @exerciseEveningHipsS4ButterflyTip.
  ///
  /// In en, this message translates to:
  /// **'Stay tall; to go deeper, lean forward from your hips.'**
  String get exerciseEveningHipsS4ButterflyTip;

  /// No description provided for @exerciseEveningHipsS5FrogName.
  ///
  /// In en, this message translates to:
  /// **'Frog'**
  String get exerciseEveningHipsS5FrogName;

  /// No description provided for @exerciseEveningHipsS5FrogDesc.
  ///
  /// In en, this message translates to:
  /// **'On all fours, slide your knees wide apart, ankles in line with the knees, feet turned out. Lower onto your forearms and ease your hips back.'**
  String get exerciseEveningHipsS5FrogDesc;

  /// No description provided for @exerciseEveningHipsS5FrogTip.
  ///
  /// In en, this message translates to:
  /// **'Open only as far as it feels like a stretch, never a pain in the knees.'**
  String get exerciseEveningHipsS5FrogTip;

  /// No description provided for @exerciseEveningFoldsS1LegsUpWallName.
  ///
  /// In en, this message translates to:
  /// **'Legs Up the Wall'**
  String get exerciseEveningFoldsS1LegsUpWallName;

  /// No description provided for @exerciseEveningFoldsS1LegsUpWallDesc.
  ///
  /// In en, this message translates to:
  /// **'Lie on your back with your hips close to a wall and your legs straight up along it. Arms relaxed at your sides; breathe slowly.'**
  String get exerciseEveningFoldsS1LegsUpWallDesc;

  /// No description provided for @exerciseEveningFoldsS1LegsUpWallTip.
  ///
  /// In en, this message translates to:
  /// **'Bend your knees a little if the backs of your legs pull too much.'**
  String get exerciseEveningFoldsS1LegsUpWallTip;

  /// No description provided for @exerciseEveningFoldsS2TowelHamstringName.
  ///
  /// In en, this message translates to:
  /// **'Lying Hamstring Stretch'**
  String get exerciseEveningFoldsS2TowelHamstringName;

  /// No description provided for @exerciseEveningFoldsS2TowelHamstringDesc.
  ///
  /// In en, this message translates to:
  /// **'Lie on your back, loop a towel around one foot and raise that leg as straight as you can. The other leg stays on the floor.'**
  String get exerciseEveningFoldsS2TowelHamstringDesc;

  /// No description provided for @exerciseEveningFoldsS2TowelHamstringTip.
  ///
  /// In en, this message translates to:
  /// **'Pull with the towel, not with your back: your hips stay on the floor.'**
  String get exerciseEveningFoldsS2TowelHamstringTip;

  /// No description provided for @exerciseEveningFoldsS3HeadToKneeName.
  ///
  /// In en, this message translates to:
  /// **'Head-to-Knee Fold'**
  String get exerciseEveningFoldsS3HeadToKneeName;

  /// No description provided for @exerciseEveningFoldsS3HeadToKneeDesc.
  ///
  /// In en, this message translates to:
  /// **'Sit with one leg straight and the other foot against the inside of that thigh. Fold forward over the straight leg, reaching toward the foot.'**
  String get exerciseEveningFoldsS3HeadToKneeDesc;

  /// No description provided for @exerciseEveningFoldsS3HeadToKneeTip.
  ///
  /// In en, this message translates to:
  /// **'Lead with your chest, not your head; the straight knee may bend a little.'**
  String get exerciseEveningFoldsS3HeadToKneeTip;

  /// No description provided for @exerciseEveningFoldsS4StraddleFoldName.
  ///
  /// In en, this message translates to:
  /// **'Straddle Fold'**
  String get exerciseEveningFoldsS4StraddleFoldName;

  /// No description provided for @exerciseEveningFoldsS4StraddleFoldDesc.
  ///
  /// In en, this message translates to:
  /// **'Sit with your legs wide apart, knees pointing up. Walk your hands forward and lower your body toward the floor between your legs.'**
  String get exerciseEveningFoldsS4StraddleFoldDesc;

  /// No description provided for @exerciseEveningFoldsS4StraddleFoldTip.
  ///
  /// In en, this message translates to:
  /// **'Tilt from your hips with a long back; rounding the back adds nothing.'**
  String get exerciseEveningFoldsS4StraddleFoldTip;

  /// No description provided for @exerciseEveningShouldersS1SelfHugName.
  ///
  /// In en, this message translates to:
  /// **'Self-Hug'**
  String get exerciseEveningShouldersS1SelfHugName;

  /// No description provided for @exerciseEveningShouldersS1SelfHugDesc.
  ///
  /// In en, this message translates to:
  /// **'Sitting or standing, wrap your arms around yourself and hold your shoulder blades. Let your upper back round and breathe into it.'**
  String get exerciseEveningShouldersS1SelfHugDesc;

  /// No description provided for @exerciseEveningShouldersS1SelfHugTip.
  ///
  /// In en, this message translates to:
  /// **'Relax your neck and let your chin drop a little.'**
  String get exerciseEveningShouldersS1SelfHugTip;

  /// No description provided for @exerciseEveningShouldersS2TricepsStretchName.
  ///
  /// In en, this message translates to:
  /// **'Overhead Triceps Stretch'**
  String get exerciseEveningShouldersS2TricepsStretchName;

  /// No description provided for @exerciseEveningShouldersS2TricepsStretchDesc.
  ///
  /// In en, this message translates to:
  /// **'Raise one arm, bend the elbow and let your hand drop behind your neck. Use the other hand to ease the elbow back.'**
  String get exerciseEveningShouldersS2TricepsStretchDesc;

  /// No description provided for @exerciseEveningShouldersS2TricepsStretchTip.
  ///
  /// In en, this message translates to:
  /// **'Keep your head up and your ribs down.'**
  String get exerciseEveningShouldersS2TricepsStretchTip;

  /// No description provided for @exerciseEveningShouldersS3EagleArmsName.
  ///
  /// In en, this message translates to:
  /// **'Eagle Arms'**
  String get exerciseEveningShouldersS3EagleArmsName;

  /// No description provided for @exerciseEveningShouldersS3EagleArmsDesc.
  ///
  /// In en, this message translates to:
  /// **'Cross one arm under the other at the elbows, bend them and bring your palms together. Lift your elbows to shoulder height.'**
  String get exerciseEveningShouldersS3EagleArmsDesc;

  /// No description provided for @exerciseEveningShouldersS3EagleArmsTip.
  ///
  /// In en, this message translates to:
  /// **'If your palms don\'t meet, press the backs of your hands together.'**
  String get exerciseEveningShouldersS3EagleArmsTip;

  /// No description provided for @exerciseEveningShouldersS4PuppyPoseName.
  ///
  /// In en, this message translates to:
  /// **'Puppy Pose'**
  String get exerciseEveningShouldersS4PuppyPoseName;

  /// No description provided for @exerciseEveningShouldersS4PuppyPoseDesc.
  ///
  /// In en, this message translates to:
  /// **'On all fours, walk your hands forward and lower your chest toward the floor, hips above your knees, arms straight.'**
  String get exerciseEveningShouldersS4PuppyPoseDesc;

  /// No description provided for @exerciseEveningShouldersS4PuppyPoseTip.
  ///
  /// In en, this message translates to:
  /// **'Rest your forehead on the floor and let your chest melt down.'**
  String get exerciseEveningShouldersS4PuppyPoseTip;

  /// No description provided for @exerciseEveningShouldersS5CowFaceArmsName.
  ///
  /// In en, this message translates to:
  /// **'Cow Face Arms'**
  String get exerciseEveningShouldersS5CowFaceArmsName;

  /// No description provided for @exerciseEveningShouldersS5CowFaceArmsDesc.
  ///
  /// In en, this message translates to:
  /// **'Reach one hand down behind your neck and the other up behind your back, and try to hook your fingers. If they don\'t meet, hold a towel between your hands.'**
  String get exerciseEveningShouldersS5CowFaceArmsDesc;

  /// No description provided for @exerciseEveningShouldersS5CowFaceArmsTip.
  ///
  /// In en, this message translates to:
  /// **'Keep the upper elbow pointing up and your back straight.'**
  String get exerciseEveningShouldersS5CowFaceArmsTip;

  /// No description provided for @exerciseCooldownLyingRelaxationName.
  ///
  /// In en, this message translates to:
  /// **'Lying Relaxation'**
  String get exerciseCooldownLyingRelaxationName;

  /// No description provided for @exerciseCooldownLyingRelaxationDesc.
  ///
  /// In en, this message translates to:
  /// **'Lie on your back, arms by your sides, palms up. Close your eyes and breathe slowly; let your whole body go heavy.'**
  String get exerciseCooldownLyingRelaxationDesc;

  /// No description provided for @exerciseCooldownLyingRelaxationTip.
  ///
  /// In en, this message translates to:
  /// **'Breathe out longer than you breathe in.'**
  String get exerciseCooldownLyingRelaxationTip;

  /// No description provided for @exerciseMorningSpineS1SideBendName.
  ///
  /// In en, this message translates to:
  /// **'Standing Side Bend'**
  String get exerciseMorningSpineS1SideBendName;

  /// No description provided for @exerciseMorningSpineS1SideBendDesc.
  ///
  /// In en, this message translates to:
  /// **'Stand with your feet hip-width apart. Raise one arm over your head and lean to the other side, sliding the other hand down your thigh. Come back up and switch sides. Each side counts as one rep.'**
  String get exerciseMorningSpineS1SideBendDesc;

  /// No description provided for @exerciseMorningSpineS1SideBendTip.
  ///
  /// In en, this message translates to:
  /// **'Lean straight to the side, not forward; your hips stay still.'**
  String get exerciseMorningSpineS1SideBendTip;

  /// No description provided for @exerciseMorningSpineS2TorsoTwistName.
  ///
  /// In en, this message translates to:
  /// **'Torso Twist'**
  String get exerciseMorningSpineS2TorsoTwistName;

  /// No description provided for @exerciseMorningSpineS2TorsoTwistDesc.
  ///
  /// In en, this message translates to:
  /// **'Stand with your feet a little wider than your hips, knees soft, arms loose. Turn your upper body from side to side and let your arms swing around you. Your hips keep facing forward. Each side counts as one rep.'**
  String get exerciseMorningSpineS2TorsoTwistDesc;

  /// No description provided for @exerciseMorningSpineS2TorsoTwistTip.
  ///
  /// In en, this message translates to:
  /// **'Let the arms follow the turn; don\'t throw them.'**
  String get exerciseMorningSpineS2TorsoTwistTip;

  /// No description provided for @exerciseMorningSpineS3GoodMorningName.
  ///
  /// In en, this message translates to:
  /// **'Good Morning'**
  String get exerciseMorningSpineS3GoodMorningName;

  /// No description provided for @exerciseMorningSpineS3GoodMorningDesc.
  ///
  /// In en, this message translates to:
  /// **'Stand with your feet hip-width apart, hands behind your head. Push your hips back and lean forward with a flat back until you feel the back of your thighs, then stand tall again.'**
  String get exerciseMorningSpineS3GoodMorningDesc;

  /// No description provided for @exerciseMorningSpineS3GoodMorningTip.
  ///
  /// In en, this message translates to:
  /// **'Bend at the hips, not at the waist: your back stays straight the whole way.'**
  String get exerciseMorningSpineS3GoodMorningTip;

  /// No description provided for @exerciseMorningSpineS4RollDownName.
  ///
  /// In en, this message translates to:
  /// **'Roll-Down'**
  String get exerciseMorningSpineS4RollDownName;

  /// No description provided for @exerciseMorningSpineS4RollDownDesc.
  ///
  /// In en, this message translates to:
  /// **'Stand tall. Drop your chin to your chest and roll down slowly, one vertebra at a time, letting your arms hang toward the floor. Roll back up the same way, your head coming up last.'**
  String get exerciseMorningSpineS4RollDownDesc;

  /// No description provided for @exerciseMorningSpineS4RollDownTip.
  ///
  /// In en, this message translates to:
  /// **'Bend your knees as much as you need; the point is the spine, not touching the floor.'**
  String get exerciseMorningSpineS4RollDownTip;

  /// No description provided for @exerciseMorningSpineS5WindmillName.
  ///
  /// In en, this message translates to:
  /// **'Windmill'**
  String get exerciseMorningSpineS5WindmillName;

  /// No description provided for @exerciseMorningSpineS5WindmillDesc.
  ///
  /// In en, this message translates to:
  /// **'Stand with your feet wide, arms out to the sides. Bend forward and turn, reaching one hand to the opposite foot while the other arm points at the ceiling. Come back up to the T and switch sides. Each side counts as one rep.'**
  String get exerciseMorningSpineS5WindmillDesc;

  /// No description provided for @exerciseMorningSpineS5WindmillTip.
  ///
  /// In en, this message translates to:
  /// **'Keep both arms in one straight line, like the sails of a windmill.'**
  String get exerciseMorningSpineS5WindmillTip;

  /// No description provided for @exerciseMorningJointsS1KneeCirclesName.
  ///
  /// In en, this message translates to:
  /// **'Knee Circles'**
  String get exerciseMorningJointsS1KneeCirclesName;

  /// No description provided for @exerciseMorningJointsS1KneeCirclesDesc.
  ///
  /// In en, this message translates to:
  /// **'Stand with your feet together, bend your knees slightly and rest your hands just above them. Draw slow circles with your knees: half of them one way, half the other.'**
  String get exerciseMorningJointsS1KneeCirclesDesc;

  /// No description provided for @exerciseMorningJointsS1KneeCirclesTip.
  ///
  /// In en, this message translates to:
  /// **'Small, smooth circles; your heels stay on the floor.'**
  String get exerciseMorningJointsS1KneeCirclesTip;

  /// No description provided for @exerciseMorningJointsS2OpenTheGateName.
  ///
  /// In en, this message translates to:
  /// **'Open the Gate'**
  String get exerciseMorningJointsS2OpenTheGateName;

  /// No description provided for @exerciseMorningJointsS2OpenTheGateDesc.
  ///
  /// In en, this message translates to:
  /// **'Stand tall. Lift one knee in front of you to hip height, open it out to the side and lower the foot back down. Switch legs. Each side counts as one rep.'**
  String get exerciseMorningJointsS2OpenTheGateDesc;

  /// No description provided for @exerciseMorningJointsS2OpenTheGateTip.
  ///
  /// In en, this message translates to:
  /// **'Hold on to a wall or a chair if you wobble; keep your chest up.'**
  String get exerciseMorningJointsS2OpenTheGateTip;

  /// No description provided for @exerciseMorningJointsS3KneeHugName.
  ///
  /// In en, this message translates to:
  /// **'Standing Knee Hug'**
  String get exerciseMorningJointsS3KneeHugName;

  /// No description provided for @exerciseMorningJointsS3KneeHugDesc.
  ///
  /// In en, this message translates to:
  /// **'Stand tall. Pull one knee to your chest with both hands and rise onto the toes of the standing foot. Lower it and switch legs. Each side counts as one rep.'**
  String get exerciseMorningJointsS3KneeHugDesc;

  /// No description provided for @exerciseMorningJointsS3KneeHugTip.
  ///
  /// In en, this message translates to:
  /// **'Rise slowly and look at a point in front of you to keep your balance.'**
  String get exerciseMorningJointsS3KneeHugTip;

  /// No description provided for @exerciseMorningJointsS4SideLungeName.
  ///
  /// In en, this message translates to:
  /// **'Side Lunge'**
  String get exerciseMorningJointsS4SideLungeName;

  /// No description provided for @exerciseMorningJointsS4SideLungeDesc.
  ///
  /// In en, this message translates to:
  /// **'Stand with your feet together. Step wide to one side and sit back into that hip, the other leg straight, both feet flat on the floor. Push back to the start and switch sides. Each side counts as one rep.'**
  String get exerciseMorningJointsS4SideLungeDesc;

  /// No description provided for @exerciseMorningJointsS4SideLungeTip.
  ///
  /// In en, this message translates to:
  /// **'Your bent knee points the same way as your toes.'**
  String get exerciseMorningJointsS4SideLungeTip;

  /// No description provided for @exerciseMorningJointsS5CossackSquatName.
  ///
  /// In en, this message translates to:
  /// **'Cossack Squat'**
  String get exerciseMorningJointsS5CossackSquatName;

  /// No description provided for @exerciseMorningJointsS5CossackSquatDesc.
  ///
  /// In en, this message translates to:
  /// **'Stand with your feet very wide. Sink deep onto one leg while the other stays straight, toes pointing up. Move through the middle to the other side. Each side counts as one rep.'**
  String get exerciseMorningJointsS5CossackSquatDesc;

  /// No description provided for @exerciseMorningJointsS5CossackSquatTip.
  ///
  /// In en, this message translates to:
  /// **'Keep the heel of the bent leg down; reach your arms forward for balance.'**
  String get exerciseMorningJointsS5CossackSquatTip;

  /// No description provided for @exerciseMorningArmsS1ArmSwingsName.
  ///
  /// In en, this message translates to:
  /// **'Arm Swings'**
  String get exerciseMorningArmsS1ArmSwingsName;

  /// No description provided for @exerciseMorningArmsS1ArmSwingsDesc.
  ///
  /// In en, this message translates to:
  /// **'Stand tall. Open your arms wide to the sides, then swing them in and hug yourself, changing which arm is on top each time. Keep it loose and easy.'**
  String get exerciseMorningArmsS1ArmSwingsDesc;

  /// No description provided for @exerciseMorningArmsS1ArmSwingsTip.
  ///
  /// In en, this message translates to:
  /// **'Open your chest at the wide point and breathe in.'**
  String get exerciseMorningArmsS1ArmSwingsTip;

  /// No description provided for @exerciseMorningArmsS2YRaisesName.
  ///
  /// In en, this message translates to:
  /// **'Y Raises'**
  String get exerciseMorningArmsS2YRaisesName;

  /// No description provided for @exerciseMorningArmsS2YRaisesDesc.
  ///
  /// In en, this message translates to:
  /// **'Knees soft, lean forward from the hips with a flat back. Thumbs up, raise your straight arms forward and up into a Y, squeezing your shoulder blades, then lower them.'**
  String get exerciseMorningArmsS2YRaisesDesc;

  /// No description provided for @exerciseMorningArmsS2YRaisesTip.
  ///
  /// In en, this message translates to:
  /// **'Lift with the shoulder blades, not by arching your lower back.'**
  String get exerciseMorningArmsS2YRaisesTip;

  /// No description provided for @exerciseMorningArmsS3CactusArmsName.
  ///
  /// In en, this message translates to:
  /// **'Cactus Arms'**
  String get exerciseMorningArmsS3CactusArmsName;

  /// No description provided for @exerciseMorningArmsS3CactusArmsDesc.
  ///
  /// In en, this message translates to:
  /// **'Raise your arms to the sides, elbows at shoulder height and bent at 90°, forearms pointing up like a cactus. Keeping the elbows in place, turn your forearms forward and down until they point at the floor, then back up, squeezing your shoulder blades.'**
  String get exerciseMorningArmsS3CactusArmsDesc;

  /// No description provided for @exerciseMorningArmsS3CactusArmsTip.
  ///
  /// In en, this message translates to:
  /// **'Move slowly: only the forearms travel, the elbows stay at shoulder height.'**
  String get exerciseMorningArmsS3CactusArmsTip;

  /// No description provided for @exerciseMorningArmsS4InchwormName.
  ///
  /// In en, this message translates to:
  /// **'Inchworm'**
  String get exerciseMorningArmsS4InchwormName;

  /// No description provided for @exerciseMorningArmsS4InchwormDesc.
  ///
  /// In en, this message translates to:
  /// **'Stand tall, bend forward and put your hands on the floor (bend your knees if you need to). Walk your hands out to a plank, then walk them back to your feet and roll up to standing.'**
  String get exerciseMorningArmsS4InchwormDesc;

  /// No description provided for @exerciseMorningArmsS4InchwormTip.
  ///
  /// In en, this message translates to:
  /// **'In the plank, keep your body in one straight line.'**
  String get exerciseMorningArmsS4InchwormTip;

  /// No description provided for @exerciseMorningArmsS5PlankToDogName.
  ///
  /// In en, this message translates to:
  /// **'Plank to Downward Dog'**
  String get exerciseMorningArmsS5PlankToDogName;

  /// No description provided for @exerciseMorningArmsS5PlankToDogDesc.
  ///
  /// In en, this message translates to:
  /// **'Start in a high plank, hands under your shoulders. Push your hips up and back into an upside-down V, heels toward the floor, then lower back to the plank.'**
  String get exerciseMorningArmsS5PlankToDogDesc;

  /// No description provided for @exerciseMorningArmsS5PlankToDogTip.
  ///
  /// In en, this message translates to:
  /// **'Push the floor away with your hands and let your head hang between your arms.'**
  String get exerciseMorningArmsS5PlankToDogTip;

  /// No description provided for @exerciseMorningEnergyS1StepJacksName.
  ///
  /// In en, this message translates to:
  /// **'Step Jacks'**
  String get exerciseMorningEnergyS1StepJacksName;

  /// No description provided for @exerciseMorningEnergyS1StepJacksDesc.
  ///
  /// In en, this message translates to:
  /// **'Jumping jacks without the jump: step one foot out to the side as both arms go up over your head, bring it back as the arms come down, then the other foot. Keep a steady rhythm.'**
  String get exerciseMorningEnergyS1StepJacksDesc;

  /// No description provided for @exerciseMorningEnergyS1StepJacksTip.
  ///
  /// In en, this message translates to:
  /// **'Stay light on your feet and never jump, so nobody wakes up.'**
  String get exerciseMorningEnergyS1StepJacksTip;

  /// No description provided for @exerciseMorningEnergyS2ButtKicksName.
  ///
  /// In en, this message translates to:
  /// **'Butt Kicks'**
  String get exerciseMorningEnergyS2ButtKicksName;

  /// No description provided for @exerciseMorningEnergyS2ButtKicksDesc.
  ///
  /// In en, this message translates to:
  /// **'On the spot, kick one heel up toward your glutes, then the other, at a brisk pace. Arms bent, swinging with your legs. One foot always stays on the floor.'**
  String get exerciseMorningEnergyS2ButtKicksDesc;

  /// No description provided for @exerciseMorningEnergyS2ButtKicksTip.
  ///
  /// In en, this message translates to:
  /// **'Quiet steps on the balls of your feet: brisk, but no jumping.'**
  String get exerciseMorningEnergyS2ButtKicksTip;

  /// No description provided for @exerciseMorningEnergyS3CrossCrunchName.
  ///
  /// In en, this message translates to:
  /// **'Standing Cross Crunch'**
  String get exerciseMorningEnergyS3CrossCrunchName;

  /// No description provided for @exerciseMorningEnergyS3CrossCrunchDesc.
  ///
  /// In en, this message translates to:
  /// **'Stand with your hands behind your head. Lift one knee and bring the opposite elbow down to meet it, then switch sides, at a steady pace.'**
  String get exerciseMorningEnergyS3CrossCrunchDesc;

  /// No description provided for @exerciseMorningEnergyS3CrossCrunchTip.
  ///
  /// In en, this message translates to:
  /// **'Turn from the waist and open your chest between reps.'**
  String get exerciseMorningEnergyS3CrossCrunchTip;

  /// No description provided for @exerciseMorningEnergyS4SpeedSkaterName.
  ///
  /// In en, this message translates to:
  /// **'Speed Skater'**
  String get exerciseMorningEnergyS4SpeedSkaterName;

  /// No description provided for @exerciseMorningEnergyS4SpeedSkaterDesc.
  ///
  /// In en, this message translates to:
  /// **'Like a skater, but without the hop: step wide to one side onto a bent leg and sweep the other foot behind it, swinging the opposite arm across your body. Then step to the other side.'**
  String get exerciseMorningEnergyS4SpeedSkaterDesc;

  /// No description provided for @exerciseMorningEnergyS4SpeedSkaterTip.
  ///
  /// In en, this message translates to:
  /// **'Sink into the standing leg and keep your chest over it.'**
  String get exerciseMorningEnergyS4SpeedSkaterTip;

  /// No description provided for @exerciseMorningEnergyS5MountainClimbersName.
  ///
  /// In en, this message translates to:
  /// **'Slow Mountain Climbers'**
  String get exerciseMorningEnergyS5MountainClimbersName;

  /// No description provided for @exerciseMorningEnergyS5MountainClimbersDesc.
  ///
  /// In en, this message translates to:
  /// **'In a high plank, hands under your shoulders, bring one knee toward your chest and put the foot back, then the other. A steady pace, no jumping from foot to foot.'**
  String get exerciseMorningEnergyS5MountainClimbersDesc;

  /// No description provided for @exerciseMorningEnergyS5MountainClimbersTip.
  ///
  /// In en, this message translates to:
  /// **'Hips level with your shoulders; don\'t let them pop up.'**
  String get exerciseMorningEnergyS5MountainClimbersTip;

  /// No description provided for @exerciseWarmupMorningStretchUpName.
  ///
  /// In en, this message translates to:
  /// **'Morning Stretch-Up'**
  String get exerciseWarmupMorningStretchUpName;

  /// No description provided for @exerciseWarmupMorningStretchUpDesc.
  ///
  /// In en, this message translates to:
  /// **'Stand tall. Breathing in, reach both arms up over your head and rise onto your toes; breathing out, lower your heels and arms. Stretch as if you have just woken up.'**
  String get exerciseWarmupMorningStretchUpDesc;

  /// No description provided for @exerciseWarmupMorningStretchUpTip.
  ///
  /// In en, this message translates to:
  /// **'Reach long through your fingertips; wake up slowly.'**
  String get exerciseWarmupMorningStretchUpTip;

  /// No description provided for @exerciseCooldownShakeOutName.
  ///
  /// In en, this message translates to:
  /// **'Shake-Out'**
  String get exerciseCooldownShakeOutName;

  /// No description provided for @exerciseCooldownShakeOutDesc.
  ///
  /// In en, this message translates to:
  /// **'Stand loosely and shake out your hands, arms and legs, bouncing softly in your knees. Finish with a deep breath: the day can begin.'**
  String get exerciseCooldownShakeOutDesc;

  /// No description provided for @exerciseCooldownShakeOutTip.
  ///
  /// In en, this message translates to:
  /// **'Let everything hang loose: wrists, shoulders, jaw.'**
  String get exerciseCooldownShakeOutTip;

  /// No description provided for @exerciseYogaStandingS1ChairName.
  ///
  /// In en, this message translates to:
  /// **'Chair Pose'**
  String get exerciseYogaStandingS1ChairName;

  /// No description provided for @exerciseYogaStandingS1ChairDesc.
  ///
  /// In en, this message translates to:
  /// **'Feet together, bend your knees and sit back as if onto a chair, arms raised alongside your ears. Weight in your heels, chest lifted.'**
  String get exerciseYogaStandingS1ChairDesc;

  /// No description provided for @exerciseYogaStandingS1ChairTip.
  ///
  /// In en, this message translates to:
  /// **'Keep your knees behind your toes and draw your belly in.'**
  String get exerciseYogaStandingS1ChairTip;

  /// No description provided for @exerciseYogaStandingS2Warrior1Name.
  ///
  /// In en, this message translates to:
  /// **'Warrior I'**
  String get exerciseYogaStandingS2Warrior1Name;

  /// No description provided for @exerciseYogaStandingS2Warrior1Desc.
  ///
  /// In en, this message translates to:
  /// **'Step one foot far back and turn it out slightly, bend the front knee over the ankle, hips facing forward. Raise both arms overhead. Then the other side.'**
  String get exerciseYogaStandingS2Warrior1Desc;

  /// No description provided for @exerciseYogaStandingS2Warrior1Tip.
  ///
  /// In en, this message translates to:
  /// **'Press the back heel into the floor and keep the back leg straight.'**
  String get exerciseYogaStandingS2Warrior1Tip;

  /// No description provided for @exerciseYogaStandingS3Warrior2Name.
  ///
  /// In en, this message translates to:
  /// **'Warrior II'**
  String get exerciseYogaStandingS3Warrior2Name;

  /// No description provided for @exerciseYogaStandingS3Warrior2Desc.
  ///
  /// In en, this message translates to:
  /// **'Feet wide apart, the front foot pointing forward, the back foot turned in. Bend the front knee over the ankle and stretch your arms out to the sides at shoulder height, gaze over the front hand. Then the other side.'**
  String get exerciseYogaStandingS3Warrior2Desc;

  /// No description provided for @exerciseYogaStandingS3Warrior2Tip.
  ///
  /// In en, this message translates to:
  /// **'The front knee points over your middle toes, not inward.'**
  String get exerciseYogaStandingS3Warrior2Tip;

  /// No description provided for @exerciseYogaStandingS4TriangleName.
  ///
  /// In en, this message translates to:
  /// **'Triangle Pose'**
  String get exerciseYogaStandingS4TriangleName;

  /// No description provided for @exerciseYogaStandingS4TriangleDesc.
  ///
  /// In en, this message translates to:
  /// **'Feet wide, the front foot pointing forward. With both legs straight, reach forward and tip your torso over the front leg: the lower hand rests on the shin, the upper arm points at the ceiling. Then the other side.'**
  String get exerciseYogaStandingS4TriangleDesc;

  /// No description provided for @exerciseYogaStandingS4TriangleTip.
  ///
  /// In en, this message translates to:
  /// **'Lengthen both sides of your waist; don\'t sink onto the front leg.'**
  String get exerciseYogaStandingS4TriangleTip;

  /// No description provided for @exerciseYogaStandingS5SideAngleName.
  ///
  /// In en, this message translates to:
  /// **'Extended Side Angle'**
  String get exerciseYogaStandingS5SideAngleName;

  /// No description provided for @exerciseYogaStandingS5SideAngleDesc.
  ///
  /// In en, this message translates to:
  /// **'From Warrior II, rest the forearm of your front arm on the front thigh (or the hand on the floor) and reach the other arm over your ear: one long line from the back foot to the fingertips. Then the other side.'**
  String get exerciseYogaStandingS5SideAngleDesc;

  /// No description provided for @exerciseYogaStandingS5SideAngleTip.
  ///
  /// In en, this message translates to:
  /// **'Keep the front knee over the ankle and turn your chest toward the ceiling.'**
  String get exerciseYogaStandingS5SideAngleTip;

  /// No description provided for @exerciseYogaOneLegS1TreeName.
  ///
  /// In en, this message translates to:
  /// **'Tree Pose'**
  String get exerciseYogaOneLegS1TreeName;

  /// No description provided for @exerciseYogaOneLegS1TreeDesc.
  ///
  /// In en, this message translates to:
  /// **'Stand on one leg and place the other foot on the inner calf or thigh (never on the knee), the knee out to the side. Hands together at the chest or raised overhead. Then the other side.'**
  String get exerciseYogaOneLegS1TreeDesc;

  /// No description provided for @exerciseYogaOneLegS1TreeTip.
  ///
  /// In en, this message translates to:
  /// **'Fix your gaze on one point and press the foot and the leg into each other.'**
  String get exerciseYogaOneLegS1TreeTip;

  /// No description provided for @exerciseYogaOneLegS2EagleName.
  ///
  /// In en, this message translates to:
  /// **'Eagle Pose'**
  String get exerciseYogaOneLegS2EagleName;

  /// No description provided for @exerciseYogaOneLegS2EagleDesc.
  ///
  /// In en, this message translates to:
  /// **'Bend your knees, cross one thigh over the other and hook the foot behind the standing calf if you can. Cross the arms at the elbows, palms together in front of your face. Sit a little deeper. Then the other side.'**
  String get exerciseYogaOneLegS2EagleDesc;

  /// No description provided for @exerciseYogaOneLegS2EagleTip.
  ///
  /// In en, this message translates to:
  /// **'Keep your hips square and lift the elbows to shoulder height.'**
  String get exerciseYogaOneLegS2EagleTip;

  /// No description provided for @exerciseYogaOneLegS3Warrior3Name.
  ///
  /// In en, this message translates to:
  /// **'Warrior III'**
  String get exerciseYogaOneLegS3Warrior3Name;

  /// No description provided for @exerciseYogaOneLegS3Warrior3Desc.
  ///
  /// In en, this message translates to:
  /// **'Stand on one leg, hinge forward and lift the other leg behind you until your body and the leg form a T, arms reaching forward. Then the other side.'**
  String get exerciseYogaOneLegS3Warrior3Desc;

  /// No description provided for @exerciseYogaOneLegS3Warrior3Tip.
  ///
  /// In en, this message translates to:
  /// **'Keep both hips level and the standing knee soft.'**
  String get exerciseYogaOneLegS3Warrior3Tip;

  /// No description provided for @exerciseYogaOneLegS4DancerName.
  ///
  /// In en, this message translates to:
  /// **'Dancer Pose'**
  String get exerciseYogaOneLegS4DancerName;

  /// No description provided for @exerciseYogaOneLegS4DancerDesc.
  ///
  /// In en, this message translates to:
  /// **'Stand on one leg, take the other foot behind you with the hand on the same side and press the foot into the hand: the leg rises, the torso tips forward, the free arm reaches ahead. Then the other side.'**
  String get exerciseYogaOneLegS4DancerDesc;

  /// No description provided for @exerciseYogaOneLegS4DancerTip.
  ///
  /// In en, this message translates to:
  /// **'Press the foot back into the hand rather than pulling the leg up.'**
  String get exerciseYogaOneLegS4DancerTip;

  /// No description provided for @exerciseYogaOneLegS5HalfMoonName.
  ///
  /// In en, this message translates to:
  /// **'Half Moon'**
  String get exerciseYogaOneLegS5HalfMoonName;

  /// No description provided for @exerciseYogaOneLegS5HalfMoonDesc.
  ///
  /// In en, this message translates to:
  /// **'Tip sideways over one leg: the lower hand on the floor (or a block) under the shoulder, the other leg lifted level with your body, the upper arm pointing at the ceiling. Then the other side.'**
  String get exerciseYogaOneLegS5HalfMoonDesc;

  /// No description provided for @exerciseYogaOneLegS5HalfMoonTip.
  ///
  /// In en, this message translates to:
  /// **'Stack the hips and shoulders as if your back were against a wall.'**
  String get exerciseYogaOneLegS5HalfMoonTip;

  /// No description provided for @exerciseYogaBackbendsS2LocustName.
  ///
  /// In en, this message translates to:
  /// **'Locust Pose'**
  String get exerciseYogaBackbendsS2LocustName;

  /// No description provided for @exerciseYogaBackbendsS2LocustDesc.
  ///
  /// In en, this message translates to:
  /// **'Lie on your stomach, arms along your body, palms down. Lift your chest, arms and legs off the floor at the same time, gazing down and slightly forward.'**
  String get exerciseYogaBackbendsS2LocustDesc;

  /// No description provided for @exerciseYogaBackbendsS2LocustTip.
  ///
  /// In en, this message translates to:
  /// **'Lengthen through your legs instead of squeezing your lower back.'**
  String get exerciseYogaBackbendsS2LocustTip;

  /// No description provided for @exerciseYogaBackbendsS3BridgeName.
  ///
  /// In en, this message translates to:
  /// **'Bridge Pose'**
  String get exerciseYogaBackbendsS3BridgeName;

  /// No description provided for @exerciseYogaBackbendsS3BridgeDesc.
  ///
  /// In en, this message translates to:
  /// **'Lie on your back, knees bent, feet hip-width apart near your hips. Press into your feet and lift your hips as high as you can, arms on the floor. Hold, then roll down one vertebra at a time.'**
  String get exerciseYogaBackbendsS3BridgeDesc;

  /// No description provided for @exerciseYogaBackbendsS3BridgeTip.
  ///
  /// In en, this message translates to:
  /// **'Knees point forward, not out; squeeze your glutes.'**
  String get exerciseYogaBackbendsS3BridgeTip;

  /// No description provided for @exerciseYogaBackbendsS4BowName.
  ///
  /// In en, this message translates to:
  /// **'Bow Pose'**
  String get exerciseYogaBackbendsS4BowName;

  /// No description provided for @exerciseYogaBackbendsS4BowDesc.
  ///
  /// In en, this message translates to:
  /// **'Lie on your stomach, bend your knees and hold your ankles from the outside. Press the feet into your hands to lift your chest and thighs: the body curves like a bow.'**
  String get exerciseYogaBackbendsS4BowDesc;

  /// No description provided for @exerciseYogaBackbendsS4BowTip.
  ///
  /// In en, this message translates to:
  /// **'Keep your knees no wider than your hips.'**
  String get exerciseYogaBackbendsS4BowTip;

  /// No description provided for @exerciseYogaBackbendsS5CamelName.
  ///
  /// In en, this message translates to:
  /// **'Camel Pose'**
  String get exerciseYogaBackbendsS5CamelName;

  /// No description provided for @exerciseYogaBackbendsS5CamelDesc.
  ///
  /// In en, this message translates to:
  /// **'Kneel with your knees hip-width apart, toes tucked, hands on your lower back. Press your hips forward, lift the chest and arch back, the head following gently. Come up chest first.'**
  String get exerciseYogaBackbendsS5CamelDesc;

  /// No description provided for @exerciseYogaBackbendsS5CamelTip.
  ///
  /// In en, this message translates to:
  /// **'Keep your hips over your knees; the arch comes from the chest, not the lower back.'**
  String get exerciseYogaBackbendsS5CamelTip;

  /// No description provided for @exerciseYogaBackbendsS6WheelName.
  ///
  /// In en, this message translates to:
  /// **'Wheel Pose'**
  String get exerciseYogaBackbendsS6WheelName;

  /// No description provided for @exerciseYogaBackbendsS6WheelDesc.
  ///
  /// In en, this message translates to:
  /// **'Lie on your back, knees bent, feet near your hips, hands planted by your shoulders. Lift your hips, then press up through the hands until the arms straighten and the head hangs between them. Lower slowly, chin to the chest.'**
  String get exerciseYogaBackbendsS6WheelDesc;

  /// No description provided for @exerciseYogaBackbendsS6WheelTip.
  ///
  /// In en, this message translates to:
  /// **'Keep your feet parallel and push the floor away evenly with hands and feet.'**
  String get exerciseYogaBackbendsS6WheelTip;

  /// No description provided for @exerciseYogaFlowS3HalfSunSalutationName.
  ///
  /// In en, this message translates to:
  /// **'Half Sun Salutation'**
  String get exerciseYogaFlowS3HalfSunSalutationName;

  /// No description provided for @exerciseYogaFlowS3HalfSunSalutationDesc.
  ///
  /// In en, this message translates to:
  /// **'One round: standing, sweep the arms up, fold forward, lift halfway with a flat back, fold again, rise with the arms up and lower them. Move with your breath.'**
  String get exerciseYogaFlowS3HalfSunSalutationDesc;

  /// No description provided for @exerciseYogaFlowS3HalfSunSalutationTip.
  ///
  /// In en, this message translates to:
  /// **'Breathe in as you rise, out as you fold.'**
  String get exerciseYogaFlowS3HalfSunSalutationTip;

  /// No description provided for @exerciseYogaFlowS4SunSalutationAName.
  ///
  /// In en, this message translates to:
  /// **'Sun Salutation A'**
  String get exerciseYogaFlowS4SunSalutationAName;

  /// No description provided for @exerciseYogaFlowS4SunSalutationADesc.
  ///
  /// In en, this message translates to:
  /// **'One round: arms up, fold, half lift, step back to a plank, lower halfway, upward dog, downward dog for a few breaths, step forward, half lift, rise with the arms up, stand.'**
  String get exerciseYogaFlowS4SunSalutationADesc;

  /// No description provided for @exerciseYogaFlowS4SunSalutationATip.
  ///
  /// In en, this message translates to:
  /// **'One movement per breath; drop your knees to lower if you need to.'**
  String get exerciseYogaFlowS4SunSalutationATip;

  /// No description provided for @exerciseYogaFlowS5SunSalutationBName.
  ///
  /// In en, this message translates to:
  /// **'Sun Salutation B'**
  String get exerciseYogaFlowS5SunSalutationBName;

  /// No description provided for @exerciseYogaFlowS5SunSalutationBDesc.
  ///
  /// In en, this message translates to:
  /// **'Like Sun Salutation A, with Chair Pose at the start and the end and Warrior I on each side: chair, fold, plank, lower, upward dog, downward dog, Warrior I on one side, back through the plank to downward dog, Warrior I on the other side, then forward to the chair.'**
  String get exerciseYogaFlowS5SunSalutationBDesc;

  /// No description provided for @exerciseYogaFlowS5SunSalutationBTip.
  ///
  /// In en, this message translates to:
  /// **'Keep your breath even: it sets the pace.'**
  String get exerciseYogaFlowS5SunSalutationBTip;

  /// No description provided for @aboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutTitle;

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

  /// No description provided for @aboutTermsOfUse.
  ///
  /// In en, this message translates to:
  /// **'Terms of Use'**
  String get aboutTermsOfUse;

  /// No description provided for @aboutLegalConsent.
  ///
  /// In en, this message translates to:
  /// **'By using CaliDay you agree to the Privacy Policy and Terms of Use.'**
  String get aboutLegalConsent;

  /// No description provided for @aboutCopyright.
  ///
  /// In en, this message translates to:
  /// **'© 2026 pupptmstr'**
  String get aboutCopyright;

  /// No description provided for @whatsNewTitle.
  ///
  /// In en, this message translates to:
  /// **'What\'s new'**
  String get whatsNewTitle;

  /// No description provided for @whatsNewBadge.
  ///
  /// In en, this message translates to:
  /// **'NEW'**
  String get whatsNewBadge;

  /// No description provided for @whatsNewVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String whatsNewVersion(String version);

  /// No description provided for @releaseNotes091.
  ///
  /// In en, this message translates to:
  /// **'New course: Yoga. Poses from easy to hard in four new skills: standing poses, balancing on one leg, backbends and sun salutations. It shares the Balance skill with Calisthenics: one progress for both.'**
  String get releaseNotes091;

  /// No description provided for @releaseNotes090.
  ///
  /// In en, this message translates to:
  /// **'New course: Morning Routine. Wake your body up in four skills: spine, joints, arms and energy. Everything standing and quiet, no jumps.\nAurora the lark leads Morning Routine: she greets you on the home screen and in the profile while the course is active, and sings at the end of a workout.'**
  String get releaseNotes090;

  /// No description provided for @releaseNotes0820.
  ///
  /// In en, this message translates to:
  /// **'Holds done one side at a time now cover both sides: after the first side a short countdown gives you time to switch, then the other side is timed. Nothing to tap.\nThis applies to the hip flexor stretches, 90/90, neck tilts, the pigeon pose, the single-leg stand, the one-arm plank, the side plank and the leg and side stretches after a workout.\nSkala, the judge of the challenges, is redrawn: now he really is a bull.\nNew course: Evening Stretch, a calm stretch before sleep in four skills: back, hips, folds and shoulders.\nEvery course now has its host: Raffi the giraffe leads Healthy Body, Luna the owl leads Evening Stretch, Goro stays with Calisthenics. The host of your current course now greets you on the home screen and in the profile, with all its moods, and cheers at the end of a workout.'**
  String get releaseNotes0820;

  /// No description provided for @releaseNotes0819.
  ///
  /// In en, this message translates to:
  /// **'Every branch now moves on once a day, in any workout: the morning one, the evening one or your own routine. Two courses on one day both progress.\nFriends no longer see your stage in each branch: the friend code carries your rank, SP and streak, and it is easier to scan. Friends on an older version need to update to read it.'**
  String get releaseNotes0819;

  /// No description provided for @releaseNotes0818.
  ///
  /// In en, this message translates to:
  /// **'The home screen widget speaks the app’s language: its “Done” label and its description in the widget gallery are no longer always in Russian.\nWhen you change the app language, the widget and the reminders switch to it right away.'**
  String get releaseNotes0818;

  /// No description provided for @releaseNotes0817.
  ///
  /// In en, this message translates to:
  /// **'Numbers now agree with their words: “1 set”, “1 rep” and “1 friend” instead of “1 sets”, “1 reps” and “1 friends”.'**
  String get releaseNotes0817;

  /// No description provided for @releaseNotes0816.
  ///
  /// In en, this message translates to:
  /// **'The app is now also in German and Spanish.\nThe language switch on the welcome screen is now a menu.\nThe notification about a lost streak now gets the number of days right in Russian.'**
  String get releaseNotes0816;

  /// No description provided for @releaseNotes0815.
  ///
  /// In en, this message translates to:
  /// **'A bell in the profile now shows what changed in each update.\nThe About screen is shorter: the technical line is gone.'**
  String get releaseNotes0815;

  /// No description provided for @releaseNotes0814.
  ///
  /// In en, this message translates to:
  /// **'The “Again” button shows about how long an extra workout takes.'**
  String get releaseNotes0814;

  /// No description provided for @releaseNotes0813.
  ///
  /// In en, this message translates to:
  /// **'The time on the workout button now follows your own pace: after a few workouts it reflects how long they really take you.'**
  String get releaseNotes0813;

  /// No description provided for @releaseNotes0812.
  ///
  /// In en, this message translates to:
  /// **'The workout button shows about how long today\'s workout takes.\nThe evening reminder no longer promises “10 minutes”.'**
  String get releaseNotes0812;

  /// No description provided for @releaseNotes0811.
  ///
  /// In en, this message translates to:
  /// **'Workout size replaces “5, 10 or 15 minutes”: Short, Standard or Full. It sets how many skills a workout covers, not how long it lasts.'**
  String get releaseNotes0811;

  /// No description provided for @releaseNotes0810.
  ///
  /// In en, this message translates to:
  /// **'Timed exercises now start by themselves after a short “get ready” countdown. Tap Pause if you need more time to read or take position.\nSearch in the exercise library works in Russian and English.\nA few texts that stayed in one language are translated.'**
  String get releaseNotes0810;

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

  /// No description provided for @friendsScanTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get friendsScanTryAgain;

  /// No description provided for @friendsScanCameraDeniedTitle.
  ///
  /// In en, this message translates to:
  /// **'Camera access is blocked'**
  String get friendsScanCameraDeniedTitle;

  /// No description provided for @friendsScanCameraDeniedWeb.
  ///
  /// In en, this message translates to:
  /// **'Allow the camera for this site (the camera or lock icon in the address bar), then press Try again. Or show your own QR code to your friend instead.'**
  String get friendsScanCameraDeniedWeb;

  /// No description provided for @friendsScanCameraDeniedApp.
  ///
  /// In en, this message translates to:
  /// **'Allow camera access for CaliDay in your device settings, then press Try again.'**
  String get friendsScanCameraDeniedApp;

  /// No description provided for @friendsScanCameraUnsupportedTitle.
  ///
  /// In en, this message translates to:
  /// **'No camera available'**
  String get friendsScanCameraUnsupportedTitle;

  /// No description provided for @friendsScanCameraUnsupportedBody.
  ///
  /// In en, this message translates to:
  /// **'This device or browser has no camera the app can use. Show your own QR code to your friend instead.'**
  String get friendsScanCameraUnsupportedBody;

  /// No description provided for @friendsScanCameraFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Could not start the camera'**
  String get friendsScanCameraFailedTitle;

  /// No description provided for @friendsScanCameraFailedBody.
  ///
  /// In en, this message translates to:
  /// **'Check that no other app is using the camera and that you are online (in a browser the scanner is downloaded on first use), then try again.'**
  String get friendsScanCameraFailedBody;

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
  /// **'{count, plural, one{{count} friend} other{{count} friends}}'**
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
  /// **'Slowly tilt your head toward your right shoulder — without raising the shoulder — and hold the gentle stretch. Then the other side.'**
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
  /// **'No exercises found'**
  String get exerciseLibraryEmpty;

  /// No description provided for @exerciseLibraryReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get exerciseLibraryReset;

  /// No description provided for @exerciseTagFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get exerciseTagFilterAll;

  /// No description provided for @exerciseLibraryCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} exercise} other{{count} exercises}}'**
  String exerciseLibraryCount(int count);

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

  /// No description provided for @exerciseTagHipFlexor.
  ///
  /// In en, this message translates to:
  /// **'Hip Flexors'**
  String get exerciseTagHipFlexor;

  /// No description provided for @exerciseTagGlutes.
  ///
  /// In en, this message translates to:
  /// **'Glutes'**
  String get exerciseTagGlutes;

  /// No description provided for @exerciseTagCore.
  ///
  /// In en, this message translates to:
  /// **'Core'**
  String get exerciseTagCore;

  /// No description provided for @exerciseTagChest.
  ///
  /// In en, this message translates to:
  /// **'Chest'**
  String get exerciseTagChest;

  /// No description provided for @exerciseTagBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get exerciseTagBack;

  /// No description provided for @exerciseTagShoulders.
  ///
  /// In en, this message translates to:
  /// **'Shoulders'**
  String get exerciseTagShoulders;

  /// No description provided for @exerciseTagLegs.
  ///
  /// In en, this message translates to:
  /// **'Legs'**
  String get exerciseTagLegs;

  /// No description provided for @exerciseTagNeck.
  ///
  /// In en, this message translates to:
  /// **'Neck'**
  String get exerciseTagNeck;

  /// No description provided for @exerciseTagStretch.
  ///
  /// In en, this message translates to:
  /// **'Stretch'**
  String get exerciseTagStretch;

  /// No description provided for @exerciseTagMobility.
  ///
  /// In en, this message translates to:
  /// **'Mobility'**
  String get exerciseTagMobility;

  /// No description provided for @exerciseTagStrength.
  ///
  /// In en, this message translates to:
  /// **'Strength'**
  String get exerciseTagStrength;

  /// No description provided for @exerciseTagEndurance.
  ///
  /// In en, this message translates to:
  /// **'Endurance'**
  String get exerciseTagEndurance;

  /// No description provided for @exerciseTagSittingRecovery.
  ///
  /// In en, this message translates to:
  /// **'Desk Recovery'**
  String get exerciseTagSittingRecovery;

  /// No description provided for @exerciseTagFloorOnly.
  ///
  /// In en, this message translates to:
  /// **'No Equipment'**
  String get exerciseTagFloorOnly;

  /// No description provided for @exerciseTagRequiresBar.
  ///
  /// In en, this message translates to:
  /// **'Requires Bar'**
  String get exerciseTagRequiresBar;

  /// No description provided for @exerciseTagPostureFocus.
  ///
  /// In en, this message translates to:
  /// **'Posture'**
  String get exerciseTagPostureFocus;

  /// No description provided for @exerciseTagBeginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get exerciseTagBeginner;

  /// No description provided for @exerciseTagWarmup.
  ///
  /// In en, this message translates to:
  /// **'Warmup'**
  String get exerciseTagWarmup;

  /// No description provided for @exerciseTagCooldown.
  ///
  /// In en, this message translates to:
  /// **'Cooldown'**
  String get exerciseTagCooldown;

  /// No description provided for @customWorkoutNoWarmupTitle.
  ///
  /// In en, this message translates to:
  /// **'Add warmup & cooldown?'**
  String get customWorkoutNoWarmupTitle;

  /// No description provided for @customWorkoutNoWarmupBody.
  ///
  /// In en, this message translates to:
  /// **'Your routine has no warmup or cooldown. Add them automatically?'**
  String get customWorkoutNoWarmupBody;

  /// No description provided for @customWorkoutAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get customWorkoutAdd;

  /// No description provided for @customWorkoutSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get customWorkoutSkip;

  /// No description provided for @customWorkoutButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Custom Workout'**
  String get customWorkoutButtonLabel;

  /// No description provided for @customWorkoutMyRoutines.
  ///
  /// In en, this message translates to:
  /// **'My Routines'**
  String get customWorkoutMyRoutines;

  /// No description provided for @customWorkoutNewRoutine.
  ///
  /// In en, this message translates to:
  /// **'New Routine'**
  String get customWorkoutNewRoutine;

  /// No description provided for @customWorkoutQuickRoutine.
  ///
  /// In en, this message translates to:
  /// **'Quick Routine'**
  String get customWorkoutQuickRoutine;

  /// No description provided for @customWorkoutQuickRoutineDesc.
  ///
  /// In en, this message translates to:
  /// **'Pick a focus area — we\'ll select exercises for you'**
  String get customWorkoutQuickRoutineDesc;

  /// No description provided for @customWorkoutEmpty.
  ///
  /// In en, this message translates to:
  /// **'No saved routines yet'**
  String get customWorkoutEmpty;

  /// No description provided for @customWorkoutNameHint.
  ///
  /// In en, this message translates to:
  /// **'Routine name'**
  String get customWorkoutNameHint;

  /// No description provided for @customWorkoutNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a name to save this routine'**
  String get customWorkoutNameRequired;

  /// No description provided for @customWorkoutSave.
  ///
  /// In en, this message translates to:
  /// **'Save Routine'**
  String get customWorkoutSave;

  /// No description provided for @customWorkoutStartNow.
  ///
  /// In en, this message translates to:
  /// **'Start Now'**
  String get customWorkoutStartNow;

  /// No description provided for @customWorkoutDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get customWorkoutDelete;

  /// No description provided for @customWorkoutEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get customWorkoutEdit;

  /// No description provided for @customWorkoutBuilderTitle.
  ///
  /// In en, this message translates to:
  /// **'Routine Builder'**
  String get customWorkoutBuilderTitle;

  /// No description provided for @customWorkoutBuilderDesc.
  ///
  /// In en, this message translates to:
  /// **'Pick exercises and build your own sequence'**
  String get customWorkoutBuilderDesc;

  /// No description provided for @customWorkoutPickFocus.
  ///
  /// In en, this message translates to:
  /// **'What do you want to train?'**
  String get customWorkoutPickFocus;

  /// No description provided for @customWorkoutExerciseCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} exercise} other{{count} exercises}}'**
  String customWorkoutExerciseCount(int count);

  /// No description provided for @rankDecayWarning.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t trained for {days, plural, one{{days} day} other{{days} days}} — your rank has dropped. Get back to it!'**
  String rankDecayWarning(int days);

  /// No description provided for @summaryRankRestoredTitle.
  ///
  /// In en, this message translates to:
  /// **'Rank restored!'**
  String get summaryRankRestoredTitle;

  /// No description provided for @summaryRankRestoredBody.
  ///
  /// In en, this message translates to:
  /// **'Keep training — your rank is fully restored!'**
  String get summaryRankRestoredBody;

  /// No description provided for @notificationMorningTitle.
  ///
  /// In en, this message translates to:
  /// **'Time to work out! 💪'**
  String get notificationMorningTitle;

  /// No description provided for @notificationMorningBody.
  ///
  /// In en, this message translates to:
  /// **'Your daily workout is waiting. Keep the streak alive!'**
  String get notificationMorningBody;

  /// No description provided for @notificationEveningTitle.
  ///
  /// In en, this message translates to:
  /// **'Still time! 🏃'**
  String get notificationEveningTitle;

  /// No description provided for @notificationEveningBody.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t trained today yet. Even a short workout counts.'**
  String get notificationEveningBody;

  /// No description provided for @notificationStreakTitle.
  ///
  /// In en, this message translates to:
  /// **'Streak at risk! 🔥'**
  String get notificationStreakTitle;

  /// No description provided for @notificationStreakBody.
  ///
  /// In en, this message translates to:
  /// **'Work out before midnight or your streak will end.'**
  String get notificationStreakBody;

  /// No description provided for @notificationStreakLostTitle.
  ///
  /// In en, this message translates to:
  /// **'Streak is gone 😔'**
  String get notificationStreakLostTitle;

  /// No description provided for @notificationStreakLostBody.
  ///
  /// In en, this message translates to:
  /// **'Your {days}-day streak is gone. Start a new one — the first step is always the hardest!'**
  String notificationStreakLostBody(int days);

  /// No description provided for @notificationRankAtRiskTitle.
  ///
  /// In en, this message translates to:
  /// **'Rank at risk! ⚠️'**
  String get notificationRankAtRiskTitle;

  /// No description provided for @notificationRankAtRiskBody.
  ///
  /// In en, this message translates to:
  /// **'14 days without training — your rank will start dropping soon. Come back!'**
  String get notificationRankAtRiskBody;

  /// No description provided for @widgetDoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get widgetDoneLabel;
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
      <String>['de', 'en', 'es', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
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
