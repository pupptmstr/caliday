// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String durationMin(int mins, int secs) {
    return '$mins min $secs sec';
  }

  @override
  String durationSec(int secs) {
    return '$secs sec';
  }

  @override
  String get homeDays => 'days';

  @override
  String get homeBranchesTitle => 'Skill Branches';

  @override
  String get homeBranchPush => 'Push';

  @override
  String get homeBranchCore => 'Core';

  @override
  String homeStage(int stage, int total) {
    return 'Stage $stage/$total';
  }

  @override
  String get homeChallengeUnlocked => '🏆 Challenge Ready';

  @override
  String get homeChallengeButton => 'Accept Challenge';

  @override
  String homeChallengeNormReps(int n) {
    return 'Goal: $n reps';
  }

  @override
  String homeChallengeNormSec(int n) {
    return 'Goal: $n sec';
  }

  @override
  String get homeWorkoutDone => 'Workout done';

  @override
  String get homeWorkoutStart => 'Today\'s workout';

  @override
  String get workoutTitle => 'Workout';

  @override
  String get workoutExitTitle => 'Quit workout?';

  @override
  String get workoutExitBody => 'Your progress will not be saved.';

  @override
  String get workoutContinue => 'Continue';

  @override
  String get workoutAbort => 'Quit';

  @override
  String workoutSetProgress(int current, int total) {
    return 'Set $current of $total';
  }

  @override
  String get workoutSec => 'sec';

  @override
  String get workoutRestLabel => 'rest';

  @override
  String get workoutReps => 'Reps';

  @override
  String get workoutStop => '⏹  Stop';

  @override
  String get workoutDone => '✓  Done';

  @override
  String get workoutSkipRest => 'Skip';

  @override
  String get workoutSetDone => '✅  Set done!';

  @override
  String get workoutExerciseDone => '✅  Exercise done!';

  @override
  String get workoutUnitReps => 'reps';

  @override
  String workoutNextExercise(String name, int amount, String unit) {
    return 'Next: $name • $amount $unit';
  }

  @override
  String workoutNextSet(int setNum, int amount, String unit) {
    return 'Next: set $setNum • $amount $unit';
  }

  @override
  String get summaryTitle => 'Great workout!';

  @override
  String get summarySubtitle => 'Keep it up — one more step forward 💪';

  @override
  String get summaryLabelTime => 'Time';

  @override
  String get summaryLabelExercises => 'Exer.';

  @override
  String get summaryHome => 'Home';

  @override
  String get summaryFreezeUsedTitle => 'Freeze saved your streak!';

  @override
  String get summaryFreezeUsedBody => 'Streak continues — keep it up';

  @override
  String get summaryFreezeEarnedTitle => 'Streak freeze earned!';

  @override
  String get summaryFreezeEarnedBody => 'Use it if you miss a day';

  @override
  String get summaryChallengeUnlockedTitle => 'Challenge awaits! 🏆';

  @override
  String get summaryChallengeUnlockedBody =>
      'Tap «Accept Challenge» on the Home screen when you\'re ready';

  @override
  String get summaryChallengePassedTitle => 'New stage! 🎉';

  @override
  String summaryChallengePassedBody(String exercise) {
    return 'You\'ve unlocked: $exercise';
  }

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileMaxRank => 'Max rank!';

  @override
  String profileRankProgress(int remaining, String rankName) {
    return '$remaining SP to $rankName';
  }

  @override
  String get profileStatDays => 'days';

  @override
  String get profileStatRecord => 'record';

  @override
  String get profileStatWorkouts => 'workouts';

  @override
  String get profileStatFreezes => 'freezes';

  @override
  String get profileHistoryTitle => 'Workout history';

  @override
  String get profileNoHistory => 'No completed workouts yet';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsSectionNotifications => 'NOTIFICATIONS';

  @override
  String get settingsSectionLanguage => 'LANGUAGE';

  @override
  String get settingsNotificationsTitle => 'Enable notifications';

  @override
  String get settingsNotificationsSubtitle => 'Allow the app to send reminders';

  @override
  String get settingsNotificationTimeTitle => 'Reminder time';

  @override
  String get settingsNotificationTimeSubtitle => 'Morning workout reminder';

  @override
  String get settingsTimePickerDone => 'Done';

  @override
  String get settingsEveningReminderTitle => 'Evening reminder';

  @override
  String get settingsEveningReminderSubtitle =>
      'Remind in the evening if no workout done';

  @override
  String get settingsStreakThreatTitle => 'Streak threat';

  @override
  String get settingsStreakThreatSubtitle => 'Warn when your streak is at risk';

  @override
  String get settingsLanguageTitle => 'App language';

  @override
  String get settingsSectionWorkout => 'WORKOUT';

  @override
  String get settingsWorkoutDurationTitle => 'Session length';

  @override
  String get settingsWorkoutDurationSubtitle =>
      'How many minutes to spend on the daily workout';

  @override
  String get rankBeginner => 'Beginner';

  @override
  String get rankAmateur => 'Amateur';

  @override
  String get rankSportsman => 'Athlete';

  @override
  String get rankAthlete => 'Champion';

  @override
  String get rankMaster => 'Master';

  @override
  String get rankLegend => 'Legend';

  @override
  String get onboardingWelcomeTitle => 'Hi! I\'m Goro';

  @override
  String get onboardingWelcomeBody =>
      'Short sets, skill progression, streaks and points.\nFrom knee push-ups to handstand — step by step.';

  @override
  String get onboardingWelcomeCta => 'Let\'s set everything up in 1 minute';

  @override
  String get onboardingContinue => 'Continue';

  @override
  String get onboardingStart => 'Start training 🔥';

  @override
  String get onboardingQ1 => 'How often do you work out?';

  @override
  String get onboardingQ2 => 'How many push-ups can you do?';

  @override
  String get onboardingQ3 => 'How many minutes a day are you ready to spend?';

  @override
  String get onboardingQ4 => 'What\'s your goal?';

  @override
  String get onboardingQ5 => 'When should we remind you to work out?';

  @override
  String get frequencyNeverLabel => 'Never';

  @override
  String get frequencyNeverDesc => 'Just starting out';

  @override
  String get frequencySometimesLabel => 'Sometimes';

  @override
  String get frequencySometimesDesc => 'I train from time to time';

  @override
  String get frequencyRegularLabel => 'Regularly';

  @override
  String get frequencyRegularDesc => 'I work out several times a week';

  @override
  String get pushupZeroDesc => 'Not yet';

  @override
  String get pushupOneToFiveDesc => 'Just a few';

  @override
  String get pushupFiveToFifteenDesc => 'Getting there';

  @override
  String get pushupMoreThan15Desc => 'Solid base';

  @override
  String minutesLabel(int minutes) {
    return '$minutes minutes';
  }

  @override
  String get minutesFiveDesc => 'Quick and efficient';

  @override
  String get minutesTenDesc => 'Optimal choice';

  @override
  String get minutesFifteenDesc => 'Full workout';

  @override
  String get goalGeneralLabel => 'General fitness';

  @override
  String get goalGeneralDesc => 'Stay active and healthy';

  @override
  String get goalStrengthLabel => 'Push-ups & strength';

  @override
  String get goalStrengthDesc => 'Build chest and triceps';

  @override
  String get goalCalisthenicsLabel => 'Calisthenics';

  @override
  String get goalCalisthenicsDesc => 'Handstand and skills';

  @override
  String get timeOfDayMorning => 'Morning';

  @override
  String get timeOfDayDay => 'Afternoon';

  @override
  String get timeOfDayLunch => 'Lunch';

  @override
  String get timeOfDayEvening => 'Evening';

  @override
  String get exercisePushS1WallPushupName => 'Wall Push-up';

  @override
  String get exercisePushS1WallPushupDesc =>
      'Stand a step away from the wall and press your palms at chest height. Bend your arms until your chest touches the wall, then push back.';

  @override
  String get exercisePushS1WallPushupTip =>
      'Keep your body straight — don\'t arch your lower back.';

  @override
  String get exercisePushS2KneePushupName => 'Knee Push-up';

  @override
  String get exercisePushS2KneePushupDesc =>
      'Push-up position with knees on the floor. Keep a straight line from knees to head. Lower your chest to the floor, then press up.';

  @override
  String get exercisePushS2KneePushupTip =>
      'Don\'t drop your hips — keep a straight line from knees to shoulders.';

  @override
  String get exercisePushS3FullPushupName => 'Full Push-up';

  @override
  String get exercisePushS3FullPushupDesc =>
      'Classic push-up position. Body forms a straight line from heels to head. Chest touches or comes within 2–3 cm of the floor.';

  @override
  String get exercisePushS3FullPushupTip =>
      'Brace your core and glutes to keep your hips from sagging.';

  @override
  String get exercisePushS4DiamondPushupName => 'Diamond Push-up';

  @override
  String get exercisePushS4DiamondPushupDesc =>
      'Hands under your chest with thumbs and index fingers forming a diamond. Targets the triceps. Keep elbows tucked on the way down.';

  @override
  String get exercisePushS4DiamondPushupTip =>
      'Don\'t flare your elbows — let them glide along your body.';

  @override
  String get exercisePushS5ArcherPushupName => 'Archer Push-up';

  @override
  String get exercisePushS5ArcherPushupDesc =>
      'Wide hand placement. Lower toward one arm while keeping the other arm straight. Alternate each side.';

  @override
  String get exercisePushS5ArcherPushupTip =>
      'Working arm goes full range; straight arm stays on the floor for support.';

  @override
  String get exercisePushS6OneArmPushupName => 'One-Arm Push-up';

  @override
  String get exercisePushS6OneArmPushupDesc =>
      'One hand behind your back or to the side. Feet wider than shoulder-width for balance. Full range of motion with the working arm.';

  @override
  String get exercisePushS6OneArmPushupTip =>
      'Start on an incline — it\'s easier to learn the technique there.';

  @override
  String get exercisePushS7HandstandPushupName => 'Handstand Push-up';

  @override
  String get exercisePushS7HandstandPushupDesc =>
      'Handstand against the wall (back to wall). Slowly lower your head toward the floor, then press your body back up.';

  @override
  String get exercisePushS7HandstandPushupTip =>
      'Spread your fingers wide for stability. Look between your hands.';

  @override
  String get exerciseCoreS1CrunchesName => 'Crunches';

  @override
  String get exerciseCoreS1CrunchesDesc =>
      'Lie on your back with knees bent. Hands behind your head or crossed on your chest. Lift your shoulder blades off the floor by contracting your abs.';

  @override
  String get exerciseCoreS1CrunchesTip =>
      'Don\'t pull your neck with your hands — pull your chest toward the ceiling.';

  @override
  String get exerciseCoreS2PlankName => 'Plank';

  @override
  String get exerciseCoreS2PlankDesc =>
      'Forearm push-up position. Body forms a straight line from heels to head. Don\'t raise your hips or arch your lower back.';

  @override
  String get exerciseCoreS2PlankTip =>
      'Brace your core and glutes. Breathe steadily — don\'t hold your breath.';

  @override
  String get exerciseCoreS3LyingLegRaiseName => 'Lying Leg Raise';

  @override
  String get exerciseCoreS3LyingLegRaiseDesc =>
      'Lie on your back with hands under your glutes. Raise straight legs to vertical, then lower them slowly without touching the floor.';

  @override
  String get exerciseCoreS3LyingLegRaiseTip =>
      'Keep your lower back pressed to the floor throughout the movement.';

  @override
  String get exerciseCoreS4HangingLegRaiseName => 'Hanging Leg Raise';

  @override
  String get exerciseCoreS4HangingLegRaiseDesc =>
      'Hang from a bar. Raise straight legs to parallel with the floor or higher. Control the descent.';

  @override
  String get exerciseCoreS4HangingLegRaiseTip =>
      'Don\'t swing — the movement comes from your abs only.';

  @override
  String get exerciseCoreS5LSitName => 'L-sit';

  @override
  String get exerciseCoreS5LSitDesc =>
      'Support on parallel bars or the floor. Legs straight and parallel to the floor. Hold the position as long as possible.';

  @override
  String get exerciseCoreS5LSitTip =>
      'Point toes toward you; pull shoulders down and back.';

  @override
  String get exerciseCoreS6DragonFlagName => 'Dragon Flag';

  @override
  String get exerciseCoreS6DragonFlagDesc =>
      'Lie on a bench and grip a support behind your head. Lift your body into a straight line on your shoulder blades, then lower slowly.';

  @override
  String get exerciseCoreS6DragonFlagTip =>
      'Start with the negative phase (lowering only) — it\'s easier.';

  @override
  String get exerciseWarmupArmRotationsName => 'Arm Circles';

  @override
  String get exerciseWarmupArmRotationsDesc =>
      'Standing, make large circular movements with your arms forward and backward. Warms up the shoulder girdle before push-ups.';

  @override
  String get exerciseWarmupJumpingJacksName => 'Jumping Jacks';

  @override
  String get exerciseWarmupJumpingJacksDesc =>
      'Classic jumping jacks. Raises your heart rate and warms up your whole body in 30–60 seconds.';

  @override
  String get exerciseCooldownShoulderStretchName => 'Shoulder & Chest Stretch';

  @override
  String get exerciseCooldownShoulderStretchDesc =>
      'Clasp your hands behind your back and pull your shoulders back and down. Hold for 30 seconds.';

  @override
  String get exerciseCooldownCatCowName => 'Cat-Cow';

  @override
  String get exerciseCooldownCatCowDesc =>
      'On all fours: inhale and arch your back down (cow), exhale and round it up (cat). Releases tension in the lower back and abs.';
}
