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
  String get homeBranchPull => 'Pull';

  @override
  String get homeBranchCore => 'Core';

  @override
  String get homeBranchLegs => 'Legs';

  @override
  String get homeBranchBalance => 'Balance';

  @override
  String branchJourneyProgress(int done, int total) {
    return '$done of $total stages completed';
  }

  @override
  String get branchJourneyStageCompleted => '✓ Completed';

  @override
  String get branchJourneyStageCurrent => 'Current stage';

  @override
  String get branchJourneyStageLocked => 'Locked';

  @override
  String branchJourneyParams(int reps, int sets, int rest) {
    return '$reps reps × $sets sets  ·  Rest $rest s';
  }

  @override
  String branchJourneyParamsTimed(int secs, int sets, int rest) {
    return '$secs s × $sets sets  ·  Rest $rest s';
  }

  @override
  String get branchJourneyStartChallenge => '🏆 Take the Challenge';

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
  String get settingsSectionTheme => 'THEME';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsSectionEquipment => 'EQUIPMENT';

  @override
  String get settingsEquipmentPullUpBar => 'Pull-up bar at home';

  @override
  String get settingsEquipmentPullUpBarSubtitle =>
      'Enables the Pull skill progression branch';

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
  String get onboardingQ5 => 'Do you have a pull-up bar or rings at home?';

  @override
  String get onboardingEquipmentYes => 'Yes, I do';

  @override
  String get onboardingEquipmentNo => 'No';

  @override
  String get onboardingQ6 => 'When should we remind you to work out?';

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

  @override
  String get exercisePullS1AustralianName => 'Australian Pull-up';

  @override
  String get exercisePullS1AustralianDesc =>
      'Lie under a bar with a slightly wider than shoulder-width grip. Pull your chest to the bar, keeping your body in a straight line. Control the descent.';

  @override
  String get exercisePullS1AustralianTip =>
      'The lower the bar, the harder the exercise.';

  @override
  String get exercisePullS2NegativeName => 'Negative Pull-up';

  @override
  String get exercisePullS2NegativeDesc =>
      'Jump up with your chin above the bar. Slowly lower yourself over 3–5 seconds until your arms are fully extended.';

  @override
  String get exercisePullS2NegativeTip =>
      'The slower you lower — the better. Aim for 5 seconds down.';

  @override
  String get exercisePullS3PullupName => 'Pull-up';

  @override
  String get exercisePullS3PullupDesc =>
      'Shoulder-width or slightly wider grip. Pull your chest to the bar until your chin is above it. Fully extend your arms at the bottom.';

  @override
  String get exercisePullS3PullupTip =>
      'Squeeze your shoulder blades — you\'re pulling with your back, not your arms.';

  @override
  String get exercisePullS4CloseGripName => 'Close-Grip Pull-up';

  @override
  String get exercisePullS4CloseGripDesc =>
      'Grip narrower than shoulder-width, palms facing you or away. Targets the biceps and lower lats. Pull your chest to the bar.';

  @override
  String get exercisePullS4CloseGripTip =>
      'Keep elbows tucked in for maximum bicep engagement.';

  @override
  String get exercisePullS5ArcherName => 'Archer Pull-up';

  @override
  String get exercisePullS5ArcherDesc =>
      'Wide grip. Pull your body toward one arm while keeping the other arm straight. Alternate each side.';

  @override
  String get exercisePullS5ArcherTip =>
      'Straight arm is for support; working arm goes full range.';

  @override
  String get exercisePullS6OneArmName => 'One-Arm Pull-up';

  @override
  String get exercisePullS6OneArmDesc =>
      'One hand on the bar, the other on your wrist or free. Full range of motion with the working arm.';

  @override
  String get exercisePullS6OneArmTip => 'Keep your core tight — don\'t swing.';

  @override
  String get exerciseWarmupDeadHangName => 'Dead Hang';

  @override
  String get exerciseWarmupDeadHangDesc =>
      'Hang from the bar with an overhand grip, arms fully extended. Relax your shoulders and hold the hang.';

  @override
  String get exerciseCooldownLatStretchName => 'Lat Stretch';

  @override
  String get exerciseCooldownLatStretchDesc =>
      'Stand sideways to a wall, raise one arm and press against it. Lean into the stretch to feel it along your side.';

  @override
  String get exerciseLegsS1SquatName => 'Squat';

  @override
  String get exerciseLegsS1SquatDesc =>
      'Feet shoulder-width apart, toes slightly turned out. Squat until thighs are parallel to the floor, knees over toes. Extend fully at the top.';

  @override
  String get exerciseLegsS1SquatTip =>
      'Keep heels on the floor and chest upright.';

  @override
  String get exerciseLegsS2LungeName => 'Lunge';

  @override
  String get exerciseLegsS2LungeDesc =>
      'Step forward and lower your back knee toward the floor without touching it. Both knees at 90°. Push off with the front foot to return.';

  @override
  String get exerciseLegsS2LungeTip => 'Keep your front knee behind your toes.';

  @override
  String get exerciseLegsS3BulgarianName => 'Bulgarian Split Squat';

  @override
  String get exerciseLegsS3BulgarianDesc =>
      'Rear foot elevated on a chair or couch. Lower your front leg until your thigh is parallel to the floor. Keep your torso upright.';

  @override
  String get exerciseLegsS3BulgarianTip =>
      'The further your front foot, the more glute activation.';

  @override
  String get exerciseLegsS4AssistedPistolName => 'Assisted Pistol Squat';

  @override
  String get exerciseLegsS4AssistedPistolDesc =>
      'Hold a door frame or pole for support. Squat on one leg while keeping the other straight in front of you. Use the support to reduce load.';

  @override
  String get exerciseLegsS4AssistedPistolTip =>
      'Gradually reduce hand assistance as you get stronger.';

  @override
  String get exerciseLegsS5PistolName => 'Pistol Squat';

  @override
  String get exerciseLegsS5PistolDesc =>
      'Single-leg squat without support. Other leg straight in front. Full range of motion to the floor and back up.';

  @override
  String get exerciseLegsS5PistolTip =>
      'Arms forward as a counterweight — it helps with balance.';

  @override
  String get exerciseWarmupLegSwingsName => 'Leg Swings';

  @override
  String get exerciseWarmupLegSwingsDesc =>
      'Standing by a wall, swing one leg forward and back, then side to side. Warms up the hip joint.';

  @override
  String get exerciseCooldownQuadStretchName => 'Quad Stretch';

  @override
  String get exerciseCooldownQuadStretchDesc =>
      'Stand on one leg, bend the other back and hold your foot with your hand. Feel the stretch along the front of your thigh.';

  @override
  String get exerciseBalS1OneLegStandName => 'One-Leg Stand';

  @override
  String get exerciseBalS1OneLegStandDesc =>
      'Stand on one leg, keep the other slightly bent and off the ground. Arms can be out for balance.';

  @override
  String get exerciseBalS1OneLegStandTip =>
      'Fix your gaze on a point — it greatly improves balance.';

  @override
  String get exerciseBalS2OneArmPlankName => 'One-Arm Plank';

  @override
  String get exerciseBalS2OneArmPlankDesc =>
      'Classic straight-arm plank. Lift one hand off the floor and hold the position, body parallel to the floor.';

  @override
  String get exerciseBalS2OneArmPlankTip =>
      'Keep your hips parallel to the floor — don\'t rotate your torso.';

  @override
  String get exerciseBalS3CrowPrepName => 'Crow Pose Prep';

  @override
  String get exerciseBalS3CrowPrepDesc =>
      'Squat with knees on your triceps. Shift weight onto your hands, gently lifting your feet. Hold the balance.';

  @override
  String get exerciseBalS3CrowPrepTip =>
      'Look forward-down, not straight down — or you\'ll tip over.';

  @override
  String get exerciseBalS4CrowPoseName => 'Crow Pose (Kakasana)';

  @override
  String get exerciseBalS4CrowPoseDesc =>
      'Both knees on your triceps, full balance on your hands. Arms slightly bent, fingers spread wide.';

  @override
  String get exerciseBalS4CrowPoseTip =>
      'Round your back — it engages your core and provides balance.';

  @override
  String get exerciseBalS5WallHsName => 'Wall Handstand';

  @override
  String get exerciseBalS5WallHsDesc =>
      'Kick up into a handstand with your back to the wall. Heels touch the wall for support. Hold the position, body in a straight line.';

  @override
  String get exerciseBalS5WallHsTip =>
      'Spread fingers wide and press through the pads — that\'s your balance control.';

  @override
  String get exerciseBalS6FreeHsName => 'Free Handstand';

  @override
  String get exerciseBalS6FreeHsDesc =>
      'Handstand without wall support. Control balance with small finger and wrist movements.';

  @override
  String get exerciseBalS6FreeHsTip =>
      'Look at the floor 30–40 cm in front of your hands, not between them.';

  @override
  String get exerciseWarmupWristCirclesName => 'Wrist Circles';

  @override
  String get exerciseWarmupWristCirclesDesc =>
      'Rotate your wrists clockwise and counter-clockwise. Prepares your joints for weight-bearing on your hands.';

  @override
  String get exerciseCooldownDownwardDogName => 'Downward Dog';

  @override
  String get exerciseCooldownDownwardDogDesc =>
      'From all fours, straighten arms and legs and lift your hips up. Body forms an inverted V. Stretches wrists, shoulders, and legs.';
}
