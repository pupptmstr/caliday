// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String durationMin(int mins, int secs) {
    return '$mins Min. $secs Sek.';
  }

  @override
  String durationSec(int secs) {
    return '$secs Sek.';
  }

  @override
  String durationSecPerSide(int secs) {
    return '$secs Sek. pro Seite';
  }

  @override
  String get navHome => 'Training';

  @override
  String get navLibrary => 'Kurse';

  @override
  String get navProfile => 'Profil';

  @override
  String get libraryTitle => 'Kurse';

  @override
  String get progressInfo =>
      'Trainiere einfach weiter — die App bringt dich automatisch durch die Zweige. Hier siehst du, wie weit du schon bist. Und wenn du dich bereit fühlst, früher weiterzukommen, nimm die Challenge an und geh selbst den nächsten Schritt.';

  @override
  String homeStreakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Tage',
      one: '$count Tag',
    );
    return '$_temp0';
  }

  @override
  String get homeBranchesTitle => 'Skill-Zweige';

  @override
  String get homeBranchPush => 'Drücken';

  @override
  String get homeBranchPull => 'Ziehen';

  @override
  String get homeBranchCore => 'Rumpf';

  @override
  String get homeBranchLegs => 'Beine';

  @override
  String get homeBranchBalance => 'Balance';

  @override
  String get homeBranchFlex => 'Beweglichkeit';

  @override
  String get homeBranchPosture => 'Haltung';

  @override
  String get homeBranchNeck => 'Nacken';

  @override
  String get courseNameCalisthenics => 'Calisthenics';

  @override
  String get courseNameHealthyBody => 'Gesunder Körper';

  @override
  String get courseDescCalisthenics =>
      'Übungen mit dem eigenen Körpergewicht, von einfach bis fortgeschritten. Für Kraft, Ausdauer und Körperkontrolle.';

  @override
  String get courseDescHealthyBody =>
      'Übungen für alle, die viel sitzen. Für eine bessere Haltung, einen entspannten Nacken und mehr Beweglichkeit — schonend für die Gelenke.';

  @override
  String get onboardingQ4Courses => 'Wähle einen Kurs';

  @override
  String get onboardingQ4CoursesBody =>
      'Du kannst mit einem anfangen oder beide wählen — die Programme sind unabhängig voneinander.';

  @override
  String branchJourneyProgress(int done, int total) {
    return '$done von $total Stufen abgeschlossen';
  }

  @override
  String get branchJourneyStageCompleted => '✓ Abgeschlossen';

  @override
  String get branchJourneyStageCurrent => 'Aktuelle Stufe';

  @override
  String get branchJourneyStageLocked => 'Gesperrt';

  @override
  String branchJourneyParams(int reps, int sets, int rest) {
    String _temp0 = intl.Intl.pluralLogic(
      sets,
      locale: localeName,
      other: '$sets Sätze',
      one: '$sets Satz',
    );
    return '$reps Wdh. × $_temp0  ·  Pause $rest s';
  }

  @override
  String branchJourneyParamsTimed(int secs, int sets, int rest) {
    String _temp0 = intl.Intl.pluralLogic(
      sets,
      locale: localeName,
      other: '$sets Sätze',
      one: '$sets Satz',
    );
    return '$secs s × $_temp0  ·  Pause $rest s';
  }

  @override
  String branchJourneyParamsTimedPerSide(int secs, int sets, int rest) {
    String _temp0 = intl.Intl.pluralLogic(
      sets,
      locale: localeName,
      other: '$sets Sätze',
      one: '$sets Satz',
    );
    return '$secs s pro Seite × $_temp0  ·  Pause $rest s';
  }

  @override
  String get branchJourneyStartChallenge => 'Challenge starten';

  @override
  String homeStage(int stage, int total) {
    return 'Stufe $stage/$total';
  }

  @override
  String get homeChallengeUnlocked => 'Challenge bereit';

  @override
  String get homeChallengeButton => 'Challenge annehmen';

  @override
  String homeChallengeNormReps(int n) {
    return 'Ziel: $n Wdh.';
  }

  @override
  String homeChallengeNormSec(int n) {
    return 'Ziel: $n Sek.';
  }

  @override
  String homeChallengeNormSecPerSide(int n) {
    return 'Ziel: $n Sek. pro Seite';
  }

  @override
  String get homeWorkoutDone => 'Training erledigt';

  @override
  String get homeWorkoutStart => 'Training heute';

  @override
  String homeWorkoutStartEstimate(int minutes) {
    return 'Training heute (≈ $minutes Min.)';
  }

  @override
  String get homeWorkoutAgain => 'Noch einmal';

  @override
  String homeWorkoutAgainEstimate(int minutes) {
    return 'Noch einmal (≈ $minutes Min.)';
  }

  @override
  String get workoutTitle => 'Training';

  @override
  String get workoutExitTitle => 'Training abbrechen?';

  @override
  String get workoutExitBody => 'Dein Fortschritt wird nicht gespeichert.';

  @override
  String get workoutContinue => 'Weiter';

  @override
  String get workoutAbort => 'Abbrechen';

  @override
  String workoutSetProgress(int current, int total) {
    return 'Satz $current von $total';
  }

  @override
  String workoutSetSideProgress(int current, int total, int side) {
    return 'Satz $current von $total  ·  Seite $side von 2';
  }

  @override
  String get workoutSec => 'Sek.';

  @override
  String get workoutRestLabel => 'Pause';

  @override
  String get workoutReps => 'Wdh.';

  @override
  String get workoutGetReady => 'Mach dich bereit';

  @override
  String get workoutSwitchSides => 'Seite wechseln';

  @override
  String get workoutPaused => 'pausiert';

  @override
  String get workoutPause => 'Pause';

  @override
  String get workoutPrepHint =>
      'Lies die Beschreibung und geh in Position. Der Timer startet von selbst; tippe auf Pause, wenn du mehr Zeit brauchst.';

  @override
  String get workoutPrepPausedHint =>
      'Pausiert. Tippe auf Weiter, wenn du bereit bist: Der Countdown läuft dort weiter, wo er angehalten hat.';

  @override
  String get workoutSwitchSidesHint =>
      'Wechsle auf die andere Seite. Der Timer startet von selbst; tippe auf Pause, wenn du mehr Zeit brauchst.';

  @override
  String get workoutStop => 'Stopp';

  @override
  String get workoutDone => '✓  Fertig';

  @override
  String get workoutSkipRest => 'Überspringen';

  @override
  String get workoutSetDone => '✅  Satz geschafft!';

  @override
  String get workoutExerciseDone => '✅  Übung geschafft!';

  @override
  String workoutAmountReps(int count) {
    return '$count Wdh.';
  }

  @override
  String workoutNextExercise(String name, String amount) {
    return 'Als Nächstes: $name • $amount';
  }

  @override
  String workoutNextSet(int setNum, String amount) {
    return 'Als Nächstes: Satz $setNum • $amount';
  }

  @override
  String get summaryTitle => 'Starkes Training!';

  @override
  String get summarySubtitle => 'Weiter so — wieder ein Schritt nach vorn';

  @override
  String get summaryLabelTime => 'Zeit';

  @override
  String get summaryLabelExercises => 'Übungen';

  @override
  String get summaryHome => 'Start';

  @override
  String get summaryFreezeUsedTitle =>
      'Der Serienschutz hat deine Serie gerettet!';

  @override
  String get summaryFreezeUsedBody => 'Die Serie geht weiter — bleib dran';

  @override
  String get summaryFreezeEarnedTitle => 'Serienschutz verdient!';

  @override
  String get summaryFreezeEarnedBody => 'Er greift, wenn du einen Tag verpasst';

  @override
  String get achievementsTitle => 'Erfolge';

  @override
  String get achievementsEarnedSection => 'Erreicht';

  @override
  String get achievementsLockedSection => 'Gesperrt';

  @override
  String get achievementsSecret => '???';

  @override
  String get achievementsSecretDesc =>
      'Erfülle eine besondere Bedingung, um ihn freizuschalten';

  @override
  String achievementsEarnedOn(String date) {
    return 'Erreicht: $date';
  }

  @override
  String get profileAchievementsTitle => 'Erfolge';

  @override
  String get profileAchievementsAll => 'Alle Erfolge →';

  @override
  String get profileNoAchievements => 'Noch keine Erfolge';

  @override
  String get summaryAchievementsTitle => 'Neue Erfolge!';

  @override
  String get achievementFirstWorkoutName => 'Erster Schritt';

  @override
  String get achievementFirstWorkoutDesc =>
      'Dein erstes Training ist geschafft — die Reise beginnt!';

  @override
  String get achievementFirstChallengeName => 'Challenge angenommen';

  @override
  String get achievementFirstChallengeDesc =>
      'Die erste Challenge bestanden — jetzt weißt du, wozu du fähig bist';

  @override
  String get achievementStreak3Name => 'Drei am Stück';

  @override
  String get achievementStreak3Desc =>
      '3 Tage in Folge — die Gewohnheit entsteht';

  @override
  String get achievementStreak7Name => 'Ganze Woche';

  @override
  String get achievementStreak7Desc =>
      'Eine ganze Woche — damit bist du schon weiter als die meisten';

  @override
  String get achievementStreak30Name => 'Marathonläufer';

  @override
  String get achievementStreak30Desc =>
      '30 Tage ohne Pause — das ist echte Disziplin';

  @override
  String get achievementStreak100Name => 'Eiserner Wille';

  @override
  String get achievementStreak100Desc =>
      '100 Tage ohne Unterbrechung — eine legendäre Leistung';

  @override
  String get achievementWorkouts10Name => 'Zehn';

  @override
  String get achievementWorkouts10Desc =>
      '10 Trainings geschafft — ein guter Anfang';

  @override
  String get achievementWorkouts50Name => 'Fünfzig';

  @override
  String get achievementWorkouts50Desc => '50 Trainings — du meinst es ernst';

  @override
  String get achievementWorkouts100Name => 'Zenturio';

  @override
  String get achievementWorkouts100Desc =>
      '100 Trainings — du gehörst zur Elite';

  @override
  String get achievementRankAmateurName => 'Amateur';

  @override
  String get achievementRankAmateurDesc =>
      'Rang Amateur erreicht — die SP sammeln sich';

  @override
  String get achievementRankSportsmanName => 'Sportler';

  @override
  String get achievementRankSportsmanDesc =>
      'Rang Sportler — du bist mehr als ein Freizeitsportler';

  @override
  String get achievementRankAthleteName => 'Athlet';

  @override
  String get achievementRankAthleteDesc =>
      'Rang Athlet — ein ernsthaftes Niveau';

  @override
  String get achievementRankMasterName => 'Meister';

  @override
  String get achievementRankMasterDesc =>
      'Rang Meister — nur wenige kommen so weit';

  @override
  String get achievementRankLegendName => 'Legende';

  @override
  String get achievementRankLegendDesc =>
      'Höchster Rang. Du bist eine Legende.';

  @override
  String get achievementPushS3Name => 'Echter Liegestütz';

  @override
  String get achievementPushS3Desc =>
      'Klassische Liegestütze am Boden gemeistert';

  @override
  String get achievementPushS6Name => 'Bogenschütze';

  @override
  String get achievementPushS6Desc =>
      'Archer-Liegestütze gemeistert — der Handstand ist in Reichweite';

  @override
  String get achievementPushCompleteName => 'Meister im Drücken';

  @override
  String get achievementPushCompleteDesc =>
      'Alle 7 Stufen im Drücken geschafft. Goro ist stolz.';

  @override
  String get achievementCoreS2Name => 'Eiserne Plank';

  @override
  String get achievementCoreS2Desc =>
      'Plank gemeistert — die Grundlage jedes Rumpftrainings';

  @override
  String get achievementCoreS5Name => 'L-Sitz';

  @override
  String get achievementCoreS5Desc =>
      'L-Sitz — der ultimative Test für die Rumpfkraft';

  @override
  String get achievementCoreCompleteName => 'Eiserner Rumpf';

  @override
  String get achievementCoreCompleteDesc =>
      'Alle 6 Rumpf-Stufen geschafft. Dein Rumpf ist aus Stahl.';

  @override
  String get achievementPullS3Name => 'Erster Klimmzug';

  @override
  String get achievementPullS3Desc =>
      'Das Kinn über der Stange — das ist ein Sieg';

  @override
  String get achievementPullCompleteName => 'König der Stange';

  @override
  String get achievementPullCompleteDesc =>
      'Alle 6 Stufen im Ziehen geschafft. Die Stange gehört dir.';

  @override
  String get achievementLegsS5Name => 'Pistol Squat';

  @override
  String get achievementLegsS5Desc =>
      'Kniebeuge auf einem Bein — Gleichgewicht und Kraft in einem';

  @override
  String get achievementLegsCompleteName => 'Stahlbeine';

  @override
  String get achievementLegsCompleteDesc =>
      'Alle 5 Bein-Stufen geschafft. Deine Beine sind aus Stahl.';

  @override
  String get achievementBalanceS4Name => 'Krähe';

  @override
  String get achievementBalanceS4Desc =>
      'Kakasana gehalten — du beherrschst dein Gleichgewicht';

  @override
  String get achievementBalanceS6Name => 'Freier Handstand';

  @override
  String get achievementBalanceS6Desc =>
      'Handstand ohne Wand — der Gipfel des Gleichgewichts';

  @override
  String get achievementBalanceCompleteName => 'Meister der Balance';

  @override
  String get achievementBalanceCompleteDesc =>
      'Alle 6 Balance-Stufen geschafft. Du bist ein Gleichgewichtskünstler.';

  @override
  String get achievementFlexCompleteName => 'Meister der Beweglichkeit';

  @override
  String get achievementFlexCompleteDesc =>
      'Alle 6 Stufen der Beweglichkeit geschafft. Dein Körper biegt sich in jede Richtung.';

  @override
  String get achievementAllCompleteName => 'Komplette Sammlung';

  @override
  String get achievementAllCompleteDesc =>
      'Alle 5 Zweige abgeschlossen. Absoluter Champion.';

  @override
  String get summaryBonusTitle => 'Bonustraining';

  @override
  String get summaryBonusBody => '×½ SP · jeder Zweig wächst einmal am Tag';

  @override
  String summaryBonusCount(int count) {
    return 'Du hast heute schon $count-mal trainiert!';
  }

  @override
  String get summaryChallengeUnlockedTitle => 'Die Challenge wartet!';

  @override
  String get summaryChallengeUnlockedBody =>
      'Tippe auf dem Startbildschirm auf „Challenge annehmen“, wenn du bereit bist';

  @override
  String get summaryChallengePassedTitle => 'Neue Stufe!';

  @override
  String summaryChallengePassedBody(String exercise) {
    return 'Freigeschaltet: $exercise';
  }

  @override
  String get profileTitle => 'Profil';

  @override
  String get profileMaxRank => 'Höchster Rang!';

  @override
  String profileRankProgress(int remaining, String rankName) {
    return 'Noch $remaining SP bis $rankName';
  }

  @override
  String get profileStatDays => 'Tage';

  @override
  String get profileStatRecord => 'Rekord';

  @override
  String get profileStatWorkouts => 'Trainings';

  @override
  String get profileStatFreezes => 'Schutz';

  @override
  String get profileHistoryTitle => 'Trainingsverlauf';

  @override
  String get profileNoHistory => 'Noch keine abgeschlossenen Trainings';

  @override
  String get calendarTitle => 'Kalender';

  @override
  String get calendarSeeAll => 'Öffnen →';

  @override
  String get calendarFreezeUsedTitle => 'Serienschutz verwendet';

  @override
  String get calendarFreezeUsedBody =>
      'An diesem Tag gab es kein Training — ein Serienschutz hat die Serie erhalten.';

  @override
  String get calendarLegendOneWorkout => '1 Training';

  @override
  String get calendarLegendManyWorkouts => '2+ Trainings';

  @override
  String get calendarLegendFreeze => 'Schutz';

  @override
  String get historyTypeDaily => 'Tägliches Training';

  @override
  String get historyTypeChallenge => 'Challenge';

  @override
  String get historyTypeBonus => 'Bonus';

  @override
  String get historyDetailExercises => 'Übungen';

  @override
  String historyDetailReps(int completed, int target) {
    return '$completed / $target Wdh.';
  }

  @override
  String historyDetailSec(int completed, int target) {
    return '$completed / $target Sek.';
  }

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get settingsSectionNotifications => 'BENACHRICHTIGUNGEN';

  @override
  String get settingsSectionLanguage => 'SPRACHE';

  @override
  String get settingsNotificationsTitle => 'Benachrichtigungen aktivieren';

  @override
  String get settingsNotificationsSubtitle =>
      'Der App erlauben, Erinnerungen zu senden';

  @override
  String get settingsNotificationTimeTitle => 'Erinnerungszeit';

  @override
  String get settingsNotificationTimeSubtitle =>
      'Morgendliche Trainingserinnerung';

  @override
  String get settingsTimePickerDone => 'Fertig';

  @override
  String get settingsEveningReminderTitle => 'Abendliche Erinnerung';

  @override
  String get settingsEveningReminderSubtitle =>
      'Abends erinnern, wenn noch kein Training gemacht wurde';

  @override
  String get settingsStreakThreatTitle => 'Serie in Gefahr';

  @override
  String get settingsStreakThreatSubtitle =>
      'Warnen, wenn deine Serie in Gefahr ist';

  @override
  String get settingsLanguageTitle => 'App-Sprache';

  @override
  String get settingsSectionTheme => 'DESIGN';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsThemeLight => 'Hell';

  @override
  String get settingsThemeDark => 'Dunkel';

  @override
  String get settingsSectionEquipment => 'AUSRÜSTUNG';

  @override
  String get settingsEquipmentPullUpBar => 'Klimmzugstange zu Hause';

  @override
  String get settingsEquipmentPullUpBarSubtitle =>
      'Schaltet den Zweig Ziehen frei';

  @override
  String get settingsSectionWorkout => 'TRAINING';

  @override
  String get settingsSoundTitle => 'Töne';

  @override
  String get settingsSoundSubtitle => 'Akustisches Feedback beim Training';

  @override
  String get settingsHapticTitle => 'Vibration';

  @override
  String get settingsHapticSubtitle => 'Haptisches Feedback beim Training';

  @override
  String get rankBeginner => 'Anfänger';

  @override
  String get rankAmateur => 'Amateur';

  @override
  String get rankSportsman => 'Sportler';

  @override
  String get rankAthlete => 'Athlet';

  @override
  String get rankMaster => 'Meister';

  @override
  String get rankLegend => 'Legende';

  @override
  String get onboardingWelcomeTitle => 'Hallo! Ich bin Goro';

  @override
  String get onboardingWelcomeBody =>
      'Kurze Sätze, Skill-Fortschritt, Serien und Punkte.\nVom Knie-Liegestütz bis zum Handstand — Schritt für Schritt.';

  @override
  String get onboardingWelcomeCta => 'Lass uns alles in 1 Minute einrichten';

  @override
  String get onboardingContinue => 'Weiter';

  @override
  String get onboardingStart => 'Training starten 🔥';

  @override
  String get onboardingQ1 => 'Wie heißt du?';

  @override
  String get onboardingQ1Hint => 'Dein Name (optional)';

  @override
  String get onboardingQ1Body => 'Goro feuert dich damit an';

  @override
  String get onboardingQ2 => 'Wie viele Liegestütze schaffst du?';

  @override
  String get onboardingQ3 => 'Wie umfangreich soll dein Training sein?';

  @override
  String get workoutSizeShort => 'Kurz';

  @override
  String get workoutSizeStandard => 'Standard';

  @override
  String get workoutSizeFull => 'Voll';

  @override
  String get workoutSizeShortDesc => '2 Skills';

  @override
  String get workoutSizeStandardDesc => '3 Skills';

  @override
  String get workoutSizeFullDesc => 'Alle deine Skills';

  @override
  String get settingsWorkoutSizeTitle => 'Trainingsumfang';

  @override
  String get settingsWorkoutSizeSubtitle =>
      'Wie viele Skills das tägliche Training umfasst';

  @override
  String get onboardingQ5 => 'Hast du zu Hause eine Klimmzugstange oder Ringe?';

  @override
  String get onboardingEquipmentYes => 'Ja, habe ich';

  @override
  String get onboardingEquipmentNo => 'Nein';

  @override
  String get onboardingQ6Health => 'Mit Health synchronisieren';

  @override
  String get onboardingHealthBody =>
      'CaliDay kann deine Trainings automatisch in Apple Health (iOS) oder Health Connect (Android) speichern.';

  @override
  String get onboardingHealthEnable => 'Aktivieren';

  @override
  String get onboardingHealthEnableDesc => 'Trainings automatisch speichern';

  @override
  String get onboardingHealthSkip => 'Nicht jetzt';

  @override
  String get onboardingHealthSkipDesc =>
      'Du kannst es später in den Einstellungen aktivieren';

  @override
  String get onboardingQ7 => 'Wann sollen wir dich ans Training erinnern?';

  @override
  String get pushupZeroDesc => 'Noch keinen';

  @override
  String get pushupOneToFiveDesc => 'Nur ein paar';

  @override
  String get pushupFiveToFifteenDesc => 'Auf gutem Weg';

  @override
  String get pushupMoreThan15Desc => 'Solide Basis';

  @override
  String get timeOfDayMorning => 'Morgen';

  @override
  String get timeOfDayDay => 'Nachmittag';

  @override
  String get timeOfDayLunch => 'Mittag';

  @override
  String get timeOfDayEvening => 'Abend';

  @override
  String get exercisePushS1WallPushupName => 'Wand-Liegestütz';

  @override
  String get exercisePushS1WallPushupDesc =>
      'Stell dich einen Schritt von der Wand entfernt hin und leg die Handflächen auf Brusthöhe an. Beuge die Arme, bis die Brust die Wand berührt, und drück dich wieder weg.';

  @override
  String get exercisePushS1WallPushupTip =>
      'Halte den Körper gerade — kein Hohlkreuz.';

  @override
  String get exercisePushS2KneePushupName => 'Knie-Liegestütz';

  @override
  String get exercisePushS2KneePushupDesc =>
      'Liegestützposition mit den Knien am Boden. Halte eine gerade Linie von den Knien bis zum Kopf. Senke die Brust zum Boden und drück dich wieder hoch.';

  @override
  String get exercisePushS2KneePushupTip =>
      'Lass die Hüfte nicht durchhängen — eine gerade Linie von den Knien bis zu den Schultern.';

  @override
  String get exercisePushS3FullPushupName => 'Klassischer Liegestütz';

  @override
  String get exercisePushS3FullPushupDesc =>
      'Klassische Liegestützposition. Der Körper bildet eine gerade Linie von den Fersen bis zum Kopf. Die Brust berührt den Boden oder kommt ihm auf 2–3 cm nahe.';

  @override
  String get exercisePushS3FullPushupTip =>
      'Spann Bauch und Po an, damit die Hüfte nicht durchhängt.';

  @override
  String get exercisePushS4DiamondPushupName => 'Diamant-Liegestütz';

  @override
  String get exercisePushS4DiamondPushupDesc =>
      'Hände unter der Brust, Daumen und Zeigefinger bilden eine Raute. Trainiert vor allem den Trizeps. Halte die Ellbogen beim Absenken nah am Körper.';

  @override
  String get exercisePushS4DiamondPushupTip =>
      'Spreiz die Ellbogen nicht ab — lass sie am Körper entlanggleiten.';

  @override
  String get exercisePushS5WidePushupName => 'Breiter Liegestütz';

  @override
  String get exercisePushS5WidePushupDesc =>
      'Hände deutlich weiter als schulterbreit aufsetzen. Langsam absenken, der Körper bleibt eine gerade Linie. Brust und Trizeps arbeiten über einen großen Bewegungsumfang.';

  @override
  String get exercisePushS5WidePushupTip =>
      'Je weiter die Hände, desto mehr arbeitet die Brust und desto weniger der Trizeps.';

  @override
  String get exercisePushS6ArcherPushupName => 'Archer-Liegestütz';

  @override
  String get exercisePushS6ArcherPushupDesc =>
      'Hände weit aufsetzen. Senk dich zu einem Arm ab, während der andere Arm gestreckt bleibt. Wechsle die Seiten.';

  @override
  String get exercisePushS6ArcherPushupTip =>
      'Der Arbeitsarm geht den vollen Weg; der gestreckte Arm bleibt zur Stütze am Boden.';

  @override
  String get exercisePushS7HandstandPushupName => 'Handstand-Liegestütz';

  @override
  String get exercisePushS7HandstandPushupDesc =>
      'Handstand an der Wand (Rücken zur Wand). Senk den Kopf langsam Richtung Boden und drück den Körper wieder hoch.';

  @override
  String get exercisePushS7HandstandPushupTip =>
      'Spreiz die Finger weit für mehr Stabilität. Schau zwischen deine Hände.';

  @override
  String get exerciseCoreS1CrunchesName => 'Crunches';

  @override
  String get exerciseCoreS1CrunchesDesc =>
      'Leg dich mit angewinkelten Knien auf den Rücken. Hände hinter dem Kopf oder vor der Brust gekreuzt. Heb die Schulterblätter vom Boden, indem du die Bauchmuskeln anspannst.';

  @override
  String get exerciseCoreS1CrunchesTip =>
      'Zieh nicht mit den Händen am Nacken — zieh die Brust Richtung Decke.';

  @override
  String get exerciseCoreS2PlankName => 'Plank';

  @override
  String get exerciseCoreS2PlankDesc =>
      'Liegestützposition auf den Unterarmen. Der Körper bildet eine gerade Linie von den Fersen bis zum Kopf. Hüfte nicht anheben, kein Hohlkreuz.';

  @override
  String get exerciseCoreS2PlankTip =>
      'Spann Bauch und Po an. Atme gleichmäßig — halte nicht die Luft an.';

  @override
  String get exerciseCoreS3LyingLegRaiseName => 'Beinheben im Liegen';

  @override
  String get exerciseCoreS3LyingLegRaiseDesc =>
      'Leg dich auf den Rücken, die Hände unter dem Po. Heb die gestreckten Beine bis in die Senkrechte und senk sie langsam wieder, ohne den Boden zu berühren.';

  @override
  String get exerciseCoreS3LyingLegRaiseTip =>
      'Drück den unteren Rücken während der ganzen Bewegung in den Boden.';

  @override
  String get exerciseCoreS4HangingLegRaiseName => 'Hängendes Beinheben';

  @override
  String get exerciseCoreS4HangingLegRaiseDesc =>
      'Häng dich an eine Stange. Heb die gestreckten Beine bis parallel zum Boden oder höher. Senk sie kontrolliert ab.';

  @override
  String get exerciseCoreS4HangingLegRaiseTip =>
      'Kein Schwung — die Bewegung kommt nur aus dem Bauch.';

  @override
  String get exerciseCoreS4FlutterKicksName => 'Flutter Kicks';

  @override
  String get exerciseCoreS4FlutterKicksDesc =>
      'Leg dich auf den Rücken, die Hände unter dem Po. Heb beide Beine 15–20 cm vom Boden. Heb und senk die Beine abwechselnd in kleinen, schnellen Bewegungen. Eine Wiederholung = ein Zyklus (rechts hoch + links hoch).';

  @override
  String get exerciseCoreS4FlutterKicksTip =>
      'Drück den unteren Rücken in den Boden. Die Beine berühren den Boden zwischen den Wiederholungen nicht.';

  @override
  String get exerciseCoreS5LSitName => 'L-Sitz';

  @override
  String get exerciseCoreS5LSitDesc =>
      'Stütz dich auf Barren oder auf dem Boden ab. Die Beine sind gestreckt und parallel zum Boden. Halte die Position so lange wie möglich.';

  @override
  String get exerciseCoreS5LSitTip =>
      'Zieh die Zehen zu dir; zieh die Schultern nach unten und hinten.';

  @override
  String get exerciseCoreS6DragonFlagName => 'Dragon Flag';

  @override
  String get exerciseCoreS6DragonFlagDesc =>
      'Leg dich auf eine Bank und greif hinter dem Kopf eine Stütze. Heb den Körper auf den Schulterblättern in eine gerade Linie und senk ihn langsam ab.';

  @override
  String get exerciseCoreS6DragonFlagTip =>
      'Fang mit der negativen Phase an (nur absenken) — das ist leichter.';

  @override
  String get exerciseWarmupArmRotationsName => 'Armkreisen';

  @override
  String get exerciseWarmupArmRotationsDesc =>
      'Mach im Stehen große Kreise mit den Armen, vorwärts und rückwärts. Wärmt den Schultergürtel vor den Liegestützen auf.';

  @override
  String get exerciseWarmupJumpingJacksName => 'Hampelmann';

  @override
  String get exerciseWarmupJumpingJacksDesc =>
      'Klassische Hampelmänner. Bringen den Puls hoch und wärmen den ganzen Körper in 30–60 Sekunden auf.';

  @override
  String get exerciseCooldownShoulderStretchName =>
      'Schulter- und Brustdehnung';

  @override
  String get exerciseCooldownShoulderStretchDesc =>
      'Verschränk die Hände hinter dem Rücken und zieh die Schultern nach hinten und unten. Halte 30 Sekunden.';

  @override
  String get exerciseCooldownCatCowName => 'Katze-Kuh';

  @override
  String get exerciseCooldownCatCowDesc =>
      'Im Vierfüßlerstand: einatmen und den Rücken nach unten durchhängen lassen (Kuh), ausatmen und ihn nach oben runden (Katze). Löst Spannung im unteren Rücken und im Bauch.';

  @override
  String get exercisePullS1AustralianName => 'Australischer Klimmzug';

  @override
  String get exercisePullS1AustralianDesc =>
      'Leg dich unter eine Stange und greif etwas weiter als schulterbreit. Zieh die Brust zur Stange, der Körper bleibt eine gerade Linie. Senk dich kontrolliert ab.';

  @override
  String get exercisePullS1AustralianTip =>
      'Je tiefer die Stange, desto schwerer die Übung.';

  @override
  String get exercisePullS2NegativeName => 'Negativer Klimmzug';

  @override
  String get exercisePullS2NegativeDesc =>
      'Spring hoch, sodass das Kinn über der Stange ist. Lass dich in 3–5 Sekunden langsam ab, bis die Arme ganz gestreckt sind.';

  @override
  String get exercisePullS2NegativeTip =>
      'Je langsamer du dich ablässt, desto besser. Ziel: 5 Sekunden nach unten.';

  @override
  String get exercisePullS3PullupName => 'Klimmzug';

  @override
  String get exercisePullS3PullupDesc =>
      'Griff schulterbreit oder etwas weiter. Zieh die Brust zur Stange, bis das Kinn darüber ist. Streck unten die Arme ganz durch.';

  @override
  String get exercisePullS3PullupTip =>
      'Zieh die Schulterblätter zusammen — du ziehst mit dem Rücken, nicht mit den Armen.';

  @override
  String get exercisePullS4CloseGripName => 'Enger Klimmzug';

  @override
  String get exercisePullS4CloseGripDesc =>
      'Griff enger als schulterbreit, Handflächen zu dir oder von dir weg. Trainiert Bizeps und unteren Latissimus. Zieh die Brust zur Stange.';

  @override
  String get exercisePullS4CloseGripTip =>
      'Halte die Ellbogen nah am Körper, damit der Bizeps maximal arbeitet.';

  @override
  String get exercisePullS5ArcherName => 'Archer-Klimmzug';

  @override
  String get exercisePullS5ArcherDesc =>
      'Weiter Griff. Zieh den Körper zu einem Arm, während der andere Arm gestreckt bleibt. Wechsle die Seiten.';

  @override
  String get exercisePullS5ArcherTip =>
      'Der gestreckte Arm stützt; der Arbeitsarm geht den vollen Weg.';

  @override
  String get exercisePullS6OneArmName => 'Einarmiger Klimmzug';

  @override
  String get exercisePullS6OneArmDesc =>
      'Eine Hand an der Stange, die andere am Handgelenk oder frei. Voller Bewegungsumfang mit dem Arbeitsarm.';

  @override
  String get exercisePullS6OneArmTip => 'Halte den Rumpf fest — kein Schwung.';

  @override
  String get exerciseWarmupDeadHangName => 'Passives Hängen';

  @override
  String get exerciseWarmupDeadHangDesc =>
      'Häng dich im Obergriff an die Stange, die Arme ganz gestreckt. Lass die Schultern locker und halte das Hängen.';

  @override
  String get exerciseCooldownLatStretchName => 'Latissimus-Dehnung';

  @override
  String get exerciseCooldownLatStretchDesc =>
      'Stell dich seitlich zur Wand, heb einen Arm und drück ihn gegen die Wand. Lehn dich in die Dehnung, bis du sie an der Seite spürst.';

  @override
  String get exerciseLegsS1SquatName => 'Kniebeuge';

  @override
  String get exerciseLegsS1SquatDesc =>
      'Füße schulterbreit, Zehen leicht nach außen. Geh in die Hocke, bis die Oberschenkel parallel zum Boden sind, Knie über den Zehen. Oben ganz aufrichten.';

  @override
  String get exerciseLegsS1SquatTip =>
      'Fersen am Boden lassen, Brust aufrecht.';

  @override
  String get exerciseLegsS2LungeName => 'Ausfallschritt';

  @override
  String get exerciseLegsS2LungeDesc =>
      'Mach einen Schritt nach vorn und senk das hintere Knie Richtung Boden, ohne ihn zu berühren. Beide Knie im 90°-Winkel. Drück dich mit dem vorderen Fuß zurück.';

  @override
  String get exerciseLegsS2LungeTip =>
      'Das vordere Knie bleibt hinter den Zehen.';

  @override
  String get exerciseLegsS3BulgarianName => 'Bulgarische Kniebeuge';

  @override
  String get exerciseLegsS3BulgarianDesc =>
      'Der hintere Fuß liegt erhöht auf einem Stuhl oder Sofa. Senk dich auf dem vorderen Bein ab, bis der Oberschenkel parallel zum Boden ist. Oberkörper aufrecht.';

  @override
  String get exerciseLegsS3BulgarianTip =>
      'Je weiter der vordere Fuß, desto mehr arbeitet der Po.';

  @override
  String get exerciseLegsS4AssistedPistolName => 'Pistol Squat mit Hilfe';

  @override
  String get exerciseLegsS4AssistedPistolDesc =>
      'Halte dich zur Unterstützung an einem Türrahmen oder einer Stange fest. Geh auf einem Bein in die Hocke, das andere bleibt gestreckt vor dir. Die Stütze nimmt dir Last ab.';

  @override
  String get exerciseLegsS4AssistedPistolTip =>
      'Nutz die Hände nach und nach weniger, je stärker du wirst.';

  @override
  String get exerciseLegsS5PistolName => 'Pistol Squat';

  @override
  String get exerciseLegsS5PistolDesc =>
      'Kniebeuge auf einem Bein ohne Stütze. Das andere Bein gestreckt nach vorn. Voller Bewegungsumfang bis zum Boden und wieder hoch.';

  @override
  String get exerciseLegsS5PistolTip =>
      'Arme als Gegengewicht nach vorn — das hilft beim Gleichgewicht.';

  @override
  String get exerciseWarmupLegSwingsName => 'Beinschwingen';

  @override
  String get exerciseWarmupLegSwingsDesc =>
      'Stell dich neben eine Wand und schwing ein Bein vor und zurück, dann seitlich. Wärmt das Hüftgelenk auf.';

  @override
  String get exerciseCooldownQuadStretchName => 'Oberschenkeldehnung';

  @override
  String get exerciseCooldownQuadStretchDesc =>
      'Stell dich auf ein Bein, beug das andere nach hinten und halte den Fuß mit der Hand. Spür die Dehnung an der Vorderseite des Oberschenkels.';

  @override
  String get exerciseWarmupHipCirclesName => 'Hüftkreisen';

  @override
  String get exerciseWarmupHipCirclesDesc =>
      'Stell dich mit schulterbreiten Füßen hin. Kreise die Hüfte langsam im Uhrzeigersinn und dann gegen den Uhrzeigersinn. Wärmt die Hüftgelenke auf.';

  @override
  String get exerciseCooldownHipFlexorName => 'Hüftbeuger-Dehnung';

  @override
  String get exerciseCooldownHipFlexorDesc =>
      'Geh in einen Ausfallschritt und senk das hintere Knie auf den Boden. Schieb die Hüfte nach vorn und unten, bis du die Dehnung in der Hüfte spürst. Halte auf jeder Seite.';

  @override
  String get exerciseBalS1OneLegStandName => 'Einbeinstand';

  @override
  String get exerciseBalS1OneLegStandDesc =>
      'Stell dich auf ein Bein, das andere leicht gebeugt in der Luft. Die Arme dürfen zur Balance zur Seite.';

  @override
  String get exerciseBalS1OneLegStandTip =>
      'Fixier einen Punkt mit den Augen — das verbessert das Gleichgewicht enorm.';

  @override
  String get exerciseBalS2OneArmPlankName => 'Einarmige Plank';

  @override
  String get exerciseBalS2OneArmPlankDesc =>
      'Klassische Plank auf gestreckten Armen. Heb eine Hand vom Boden und halte die Position, der Körper parallel zum Boden.';

  @override
  String get exerciseBalS2OneArmPlankTip =>
      'Halte die Hüfte parallel zum Boden — dreh den Oberkörper nicht.';

  @override
  String get exerciseBalS3CrowPrepName => 'Krähe – Vorübung';

  @override
  String get exerciseBalS3CrowPrepDesc =>
      'Geh in die Hocke und leg die Knie auf den Trizeps. Verlagere das Gewicht auf die Hände und heb die Füße sanft an. Halte das Gleichgewicht.';

  @override
  String get exerciseBalS3CrowPrepTip =>
      'Schau nach vorn unten, nicht senkrecht nach unten — sonst kippst du nach vorn.';

  @override
  String get exerciseBalS4CrowPoseName => 'Krähe (Kakasana)';

  @override
  String get exerciseBalS4CrowPoseDesc =>
      'Beide Knie auf dem Trizeps, das ganze Gewicht auf den Händen. Arme leicht gebeugt, Finger weit gespreizt.';

  @override
  String get exerciseBalS4CrowPoseTip =>
      'Mach einen runden Rücken — das aktiviert den Rumpf und gibt Gleichgewicht.';

  @override
  String get exerciseBalS5WallHsName => 'Handstand an der Wand';

  @override
  String get exerciseBalS5WallHsDesc =>
      'Schwing dich mit dem Rücken zur Wand in den Handstand. Die Fersen berühren die Wand zur Stütze. Halte die Position, der Körper eine gerade Linie.';

  @override
  String get exerciseBalS5WallHsTip =>
      'Spreiz die Finger weit und drück über die Fingerballen — so steuerst du das Gleichgewicht.';

  @override
  String get exerciseBalS6FreeHsName => 'Freier Handstand';

  @override
  String get exerciseBalS6FreeHsDesc =>
      'Handstand ohne Wand. Halte das Gleichgewicht mit kleinen Bewegungen der Finger und Handgelenke.';

  @override
  String get exerciseBalS6FreeHsTip =>
      'Schau auf den Boden 30–40 cm vor den Händen, nicht zwischen sie.';

  @override
  String get exerciseWarmupWristCirclesName => 'Handgelenkkreisen';

  @override
  String get exerciseWarmupWristCirclesDesc =>
      'Kreise die Handgelenke im und gegen den Uhrzeigersinn. Bereitet die Gelenke auf das Stützen auf den Händen vor.';

  @override
  String get exerciseCooldownDownwardDogName => 'Herabschauender Hund';

  @override
  String get exerciseCooldownDownwardDogDesc =>
      'Streck aus dem Vierfüßlerstand Arme und Beine und schieb die Hüfte nach oben. Der Körper bildet ein umgedrehtes V. Dehnt Handgelenke, Schultern und Beine.';

  @override
  String get aboutTitle => 'Über die App';

  @override
  String get aboutSectionSupport => 'SUPPORT';

  @override
  String get aboutContactUs => 'Kontakt';

  @override
  String get aboutContactUsSubtitle =>
      'Einen Fehler melden oder eine Frage stellen';

  @override
  String get aboutPrivacyPolicy => 'Datenschutzerklärung';

  @override
  String get aboutTermsOfUse => 'Nutzungsbedingungen';

  @override
  String get aboutLegalConsent =>
      'Mit der Nutzung von CaliDay stimmst du der Datenschutzerklärung und den Nutzungsbedingungen zu.';

  @override
  String get aboutCopyright => '© 2026 pupptmstr';

  @override
  String get whatsNewTitle => 'Was ist neu';

  @override
  String get whatsNewBadge => 'NEU';

  @override
  String whatsNewVersion(String version) {
    return 'Version $version';
  }

  @override
  String get releaseNotes0820 =>
      'Übungen für eine Seite laufen jetzt auf beiden: Nach der ersten Seite gibt dir ein kurzer Countdown Zeit zum Wechseln, dann wird die andere Seite gemessen. Du musst nichts antippen.\nDas gilt für die Hüftbeuger-Dehnungen, 90/90, das Kopfneigen, die Taube, den Einbeinstand, die einarmige Plank, den Seitstütz und die Bein- und Flankendehnungen nach dem Training.\nSkala, der Richter der Challenges, ist neu gezeichnet: Jetzt ist er wirklich ein Stier.';

  @override
  String get releaseNotes0819 =>
      'Jeder Zweig wächst jetzt einmal am Tag, in jedem Training — morgens, abends oder in deiner eigenen Routine. Zwei Kurse an einem Tag kommen beide voran.\nFreunde sehen deine Stufe in den einzelnen Zweigen nicht mehr: Der Freundes-Code enthält Rang, SP und Serie und lässt sich leichter scannen. Freunde mit einer älteren Version müssen aktualisieren, um ihn zu lesen.';

  @override
  String get releaseNotes0818 =>
      'Das Widget auf dem Startbildschirm spricht die Sprache der App: Die Beschriftung „Erledigt“ und die Beschreibung in der Widget-Galerie sind nicht mehr immer auf Russisch.\nWenn du die Sprache der App änderst, wechseln Widget und Erinnerungen sofort mit.';

  @override
  String get releaseNotes0817 =>
      'Zahlen und Wörter passen jetzt zusammen: „1 Satz“ statt „1 Sätze“.';

  @override
  String get releaseNotes0816 =>
      'Die App gibt es jetzt auch auf Deutsch und Spanisch.\nDie Sprachauswahl auf dem Begrüßungsbildschirm ist jetzt ein Menü.\nDie Benachrichtigung über eine verlorene Serie nennt die Zahl der Tage auf Russisch jetzt grammatisch richtig.';

  @override
  String get releaseNotes0815 =>
      'Eine Glocke im Profil zeigt jetzt, was sich mit jedem Update geändert hat.\nDer Bildschirm „Über die App“ ist kürzer: Die technische Zeile ist weg.';

  @override
  String get releaseNotes0814 =>
      'Der Button „Noch einmal“ zeigt, wie lange ein zusätzliches Training ungefähr dauert.';

  @override
  String get releaseNotes0813 =>
      'Die Zeit auf dem Trainingsbutton richtet sich jetzt nach deinem eigenen Tempo: Nach ein paar Trainings zeigt sie, wie lange sie bei dir wirklich dauern.';

  @override
  String get releaseNotes0812 =>
      'Der Trainingsbutton zeigt, wie lange das heutige Training ungefähr dauert.\nDie abendliche Erinnerung verspricht keine „10 Minuten“ mehr.';

  @override
  String get releaseNotes0811 =>
      'Der Trainingsumfang ersetzt „5, 10 oder 15 Minuten“: Kurz, Standard oder Voll. Er legt fest, wie viele Skills ein Training umfasst, nicht wie lange es dauert.';

  @override
  String get releaseNotes0810 =>
      'Übungen auf Zeit starten jetzt von selbst nach einem kurzen Countdown zum Bereitmachen. Tippe auf Pause, wenn du mehr Zeit zum Lesen oder für die Position brauchst.\nDie Suche in der Übungsbibliothek funktioniert auf Russisch und Englisch.\nEinige Texte, die nur in einer Sprache waren, sind übersetzt.';

  @override
  String get settingsAbout => 'Über die App';

  @override
  String get settingsSectionHealth => 'GESUNDHEIT';

  @override
  String get settingsHealthWorkoutsTitle => 'Trainings speichern';

  @override
  String get settingsHealthWorkoutsSubtitle =>
      'In Apple Health / Health Connect speichern';

  @override
  String get settingsHealthWeightTitle => 'Körpergewicht lesen';

  @override
  String get settingsHealthWeightSubtitle =>
      'Für eine genauere Kalorienschätzung (Standard: 70 kg)';

  @override
  String get summaryHealthSaved => 'In Health gespeichert ✓';

  @override
  String get friendsTitle => 'Freunde';

  @override
  String get friendsMyQrTitle => 'Mein Profil';

  @override
  String get friendsShareHint =>
      'Zeig diesen Code einem Freund, um dein Profil zu teilen';

  @override
  String get friendsScanQr => 'QR-Code scannen';

  @override
  String get friendsSectionNearby => 'IN DER NÄHE';

  @override
  String get friendsSectionList => 'FREUNDE';

  @override
  String get friendsNearbyEmpty => 'Keine CaliDay-Nutzer in der Nähe gefunden';

  @override
  String get friendsNearbyScanning => 'Suche läuft…';

  @override
  String get friendsNearbyBleOff => 'Bluetooth ist aus';

  @override
  String get friendsNearbyConnect => 'Profil abrufen';

  @override
  String get friendsEmpty =>
      'Noch keine Freunde. Scann einen QR-Code, um deinen ersten Freund hinzuzufügen.';

  @override
  String get friendsAdded => 'Freund hinzugefügt!';

  @override
  String get friendsUpdated => 'Profil aktualisiert!';

  @override
  String get friendsScanError => 'Ungültiger QR-Code';

  @override
  String get friendsScanTryAgain => 'Erneut versuchen';

  @override
  String get friendsScanCameraDeniedTitle => 'Kamerazugriff ist blockiert';

  @override
  String get friendsScanCameraDeniedWeb =>
      'Erlaube die Kamera für diese Seite (das Kamera- oder Schloss-Symbol in der Adressleiste) und tippe dann auf „Erneut versuchen“. Oder zeig deinem Freund stattdessen deinen eigenen QR-Code.';

  @override
  String get friendsScanCameraDeniedApp =>
      'Erlaube CaliDay in den Geräteeinstellungen den Kamerazugriff und tippe dann auf „Erneut versuchen“.';

  @override
  String get friendsScanCameraUnsupportedTitle => 'Keine Kamera verfügbar';

  @override
  String get friendsScanCameraUnsupportedBody =>
      'Dieses Gerät oder dieser Browser hat keine Kamera, die die App nutzen kann. Zeig deinem Freund stattdessen deinen eigenen QR-Code.';

  @override
  String get friendsScanCameraFailedTitle =>
      'Kamera konnte nicht gestartet werden';

  @override
  String get friendsScanCameraFailedBody =>
      'Prüfe, dass keine andere App die Kamera nutzt und dass du online bist (im Browser wird der Scanner beim ersten Mal heruntergeladen), und versuch es dann noch einmal.';

  @override
  String friendsScanConfirmBody(int sp, int streak) {
    String _temp0 = intl.Intl.pluralLogic(
      streak,
      locale: localeName,
      other: '$streak Tage',
      one: '$streak Tag',
    );
    return '$sp SP · Serie: $_temp0';
  }

  @override
  String get friendsCancel => 'Abbrechen';

  @override
  String get friendsAdd => 'Hinzufügen';

  @override
  String friendsDetailLastSynced(String date) {
    return 'Synchronisiert: $date';
  }

  @override
  String get friendsDeleteTitle => 'Freund entfernen';

  @override
  String friendsDeleteBody(String name) {
    return '$name aus deinen Freunden entfernen?';
  }

  @override
  String get friendsDeleteConfirm => 'Entfernen';

  @override
  String get settingsSectionFriends => 'FREUNDE';

  @override
  String get settingsFriendsNameTitle => 'Anzeigename';

  @override
  String get settingsFriendsNamePlaceholder => 'Gib deinen Namen ein';

  @override
  String get settingsFriendsDiscoverableTitle => 'Per Bluetooth auffindbar';

  @override
  String get settingsFriendsDiscoverableSubtitle =>
      'Andere CaliDay-Nutzer in der Nähe können dich finden';

  @override
  String get profileFriendsTitle => 'Freunde';

  @override
  String get profileFriendsAll => 'Alle Freunde →';

  @override
  String get profileFriendsEmpty => 'Noch keine Freunde';

  @override
  String profileFriendsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Freunde',
      one: '$count Freund',
    );
    return '$_temp0';
  }

  @override
  String get exerciseFlexS1HipFlexorStretchName => 'Hüftbeuger-Dehnung';

  @override
  String get exerciseFlexS1HipFlexorStretchDesc =>
      'Geh in einen Ausfallschritt und senk das hintere Knie auf den Boden. Schieb die Hüfte nach vorn, bis du die Dehnung vorn an der Hüfte spürst. Halte auf jeder Seite.';

  @override
  String get exerciseFlexS1HipFlexorStretchTip =>
      'Halte den Rücken gerade und schieb die Hüfte nach vorn — spür die Dehnung vorn an der Hüfte.';

  @override
  String get exerciseFlexS2WorldsGreatestStretchName =>
      'World\'s Greatest Stretch';

  @override
  String get exerciseFlexS2WorldsGreatestStretchDesc =>
      'Setz aus dem Ausfallschritt die Hand derselben Seite auf den Boden. Dreh den Oberkörper auf und streck den anderen Arm zur Decke. Bewege dich fließend.';

  @override
  String get exerciseFlexS2WorldsGreatestStretchTip =>
      'Geh langsam durch jede Position — das ist ein Flow, kein Wettrennen.';

  @override
  String get exerciseFlexS3Hip9090Name => '90/90-Hüftmobilisation';

  @override
  String get exerciseFlexS3Hip9090Desc =>
      'Setz dich auf den Boden, beide Beine im 90°-Winkel gebeugt, eins vorn und eins seitlich. Halte die Position und wechsle die Seiten.';

  @override
  String get exerciseFlexS3Hip9090Tip =>
      'Lass beide Sitzbeinhöcker am Boden. Dreh aus der Hüfte, nicht aus dem unteren Rücken.';

  @override
  String get exerciseFlexS4ThoracicBridgeName => 'Thorax-Brücke';

  @override
  String get exerciseFlexS4ThoracicBridgeDesc =>
      'Heb aus dem Sitz, die Hände hinter dir, die Hüfte an und dreh die obere Wirbelsäule, sodass sich die Brust zur Decke öffnet.';

  @override
  String get exerciseFlexS4ThoracicBridgeTip =>
      'Die Bewegung kommt aus dem oberen Rücken — knick nicht im unteren Rücken ein.';

  @override
  String get exerciseFlexS5DeepSquatHoldName => 'Tiefe Hocke halten';

  @override
  String get exerciseFlexS5DeepSquatHoldDesc =>
      'Füße schulterbreit, Zehen leicht nach außen. Geh ganz tief in die Hocke und halte. Halte dich bei Bedarf an einem Türrahmen fest.';

  @override
  String get exerciseFlexS5DeepSquatHoldTip =>
      'Nutz anfangs einen Türrahmen oder eine Stange als Stütze. Das Ziel: Fersen flach am Boden.';

  @override
  String get exerciseFlexS6PikeStretchName => 'Pike-Dehnung';

  @override
  String get exerciseFlexS6PikeStretchDesc =>
      'Setz dich mit gestreckten Beinen auf den Boden. Greif mit den Händen Richtung Füße und beug dich dabei aus der Hüfte. Halte die Position.';

  @override
  String get exerciseFlexS6PikeStretchTip =>
      'Beug dich aus der Hüfte nach vorn, nicht aus der Taille. Die Beine bleiben gestreckt.';

  @override
  String get exerciseSuppObliqueCrunchName => 'Seitliche Crunches';

  @override
  String get exerciseSuppObliqueCrunchDesc =>
      'Leg dich auf den Rücken, die Knie gebeugt. Führ den rechten Ellbogen zum linken Knie, dann den linken zum rechten. Abwechselnd.';

  @override
  String get exerciseSuppRussianTwistsName => 'Russian Twists';

  @override
  String get exerciseSuppRussianTwistsDesc =>
      'Setz dich hin, die Knie leicht angehoben, der Oberkörper zurückgelehnt. Dreh den Oberkörper nach links und rechts — jede Drehung zählt als eine Wiederholung.';

  @override
  String get exerciseSuppRussianTwistsTip =>
      'Halte den Rücken gerade, mach keinen Buckel.';

  @override
  String get exerciseSuppSidePlankName => 'Seitstütz';

  @override
  String get exerciseSuppSidePlankDesc =>
      'Seitstütz auf dem Unterarm — der Körper eine gerade Linie vom Kopf bis zu den Füßen. Halte die Position und wiederhole auf der anderen Seite.';

  @override
  String get exerciseSuppSidePlankTip =>
      'Lass die Hüfte nicht absinken — halte die Linie gerade.';

  @override
  String get exerciseSuppStandingCalfRaiseName => 'Wadenheben im Stehen';

  @override
  String get exerciseSuppStandingCalfRaiseDesc =>
      'Stell dich aufrecht hin und geh in 2–3 Sekunden langsam auf die Zehenspitzen, dann wieder runter. Halte dich bei Bedarf zur Balance an einer Wand fest.';

  @override
  String get exerciseSuppSingleLegCalfRaiseName => 'Einbeiniges Wadenheben';

  @override
  String get exerciseSuppSingleLegCalfRaiseDesc =>
      'Stell dich auf einen Fuß. Geh langsam auf die Zehenspitzen und wieder runter. Wiederhole auf dem anderen Bein.';

  @override
  String get exerciseSuppSingleLegCalfRaiseTip =>
      'Langsames Tempo — mehr Wirkung.';

  @override
  String get exerciseSuppDeadBugName => 'Dead Bug';

  @override
  String get exerciseSuppDeadBugDesc =>
      'Leg dich auf den Rücken, die Arme zeigen nach oben, die Knie im 90°-Winkel. Senk gleichzeitig den rechten Arm über den Kopf und streck das linke Bein — fast bis zum Boden. Zurück. Abwechselnd.';

  @override
  String get exerciseSuppDeadBugTip =>
      'Drück den unteren Rücken die ganze Zeit in den Boden.';

  @override
  String get exerciseSuppBirdDogName => 'Bird-Dog';

  @override
  String get exerciseSuppBirdDogDesc =>
      'Im Vierfüßlerstand: streck gleichzeitig den rechten Arm nach vorn und das linke Bein nach hinten. 2 Sekunden halten, zurück. Seiten abwechseln.';

  @override
  String get exerciseSuppBirdDogTip =>
      'Dreh das Becken nicht — halte es gerade.';

  @override
  String get exerciseSuppNeckIsometricsName => 'Isometrische Nackenübung';

  @override
  String get exerciseSuppNeckIsometricsDesc =>
      'Drück die Handfläche gegen die Stirn und halte dagegen — der Nacken drückt zurück. Dann gegen den Hinterkopf und gegen jede Schläfe. Halte jede Richtung 5–10 Sekunden.';

  @override
  String get exerciseSuppNeckIsometricsTip =>
      'Sanfter Druck — nicht mit Gewalt.';

  @override
  String get exerciseSuppWristCirclesName => 'Handgelenkkreisen';

  @override
  String get exerciseSuppWristCirclesDesc =>
      'Mach Fäuste und kreise die Handgelenke langsam im und gegen den Uhrzeigersinn. Stärkt Unterarme und Sehnen.';

  @override
  String get exerciseWarmupNeckRollsName => 'Nackenkreisen';

  @override
  String get exerciseWarmupNeckRollsDesc =>
      'Neig den Kopf langsam nach vorn, nach hinten und zu jeder Seite und mach dann einen sanften Halbkreis von Schulter zu Schulter. Wärmt die Nackenmuskeln auf.';

  @override
  String get exercisePostureS1PelvicTiltName => 'Beckenkippen';

  @override
  String get exercisePostureS1PelvicTiltDesc =>
      'Leg dich mit angewinkelten Knien auf den Rücken. Drück den unteren Rücken langsam in den Boden, indem du den Bauch anspannst. 5 Sekunden halten, entspannen.';

  @override
  String get exercisePostureS1PelvicTiltTip =>
      'Halte nicht die Luft an — beweg dich gleichmäßig.';

  @override
  String get exercisePostureS2DeadBugName => 'Dead Bug';

  @override
  String get exercisePostureS2DeadBugDesc =>
      'Leg dich auf den Rücken, die Arme zeigen nach oben, die Knie im 90°-Winkel. Senk langsam einen Arm und das gegenüberliegende Bein, ohne ins Hohlkreuz zu gehen.';

  @override
  String get exercisePostureS2DeadBugTip =>
      'Beweg dich langsam — es geht um Kontrolle, nicht um Tempo. Halte den unteren Rücken die ganze Zeit flach am Boden.';

  @override
  String get exercisePostureS3GluteBridgeName => 'Beckenheben';

  @override
  String get exercisePostureS3GluteBridgeDesc =>
      'Leg dich auf den Rücken, die Knie gebeugt, die Füße flach am Boden. Drück die Hüfte hoch, indem du den Po anspannst, halte kurz und senk sie wieder.';

  @override
  String get exercisePostureS3GluteBridgeTip =>
      'Spann oben den Po fest an — drück nicht mit dem unteren Rücken.';

  @override
  String get exercisePostureS4HipMarchName => 'Knieheben im Stand';

  @override
  String get exercisePostureS4HipMarchDesc =>
      'Stell dich aufrecht hin. Heb langsam ein Knie auf Hüfthöhe und senk es wieder. Seiten abwechseln. Der Oberkörper bleibt aufrecht und ruhig.';

  @override
  String get exercisePostureS4HipMarchTip =>
      'Heb jedes Knie auf Hüfthöhe, ohne dich mit dem Oberkörper zu neigen — die Arbeit macht der Hüftbeuger, nicht der Schwung.';

  @override
  String get exercisePostureS5KneelingLungeName =>
      'Hüftbeuger-Dehnung im Knien';

  @override
  String get exercisePostureS5KneelingLungeDesc =>
      'Knie dich auf ein Knie, der andere Fuß steht vorn. Schieb die Hüfte nach vorn, bis du vorn an der hinteren Hüfte eine Dehnung spürst. Halten.';

  @override
  String get exercisePostureS5KneelingLungeTip =>
      'Halte den Rücken gerade und kipp das Becken sanft nach hinten, um die Dehnung zu vertiefen.';

  @override
  String get exercisePostureS6PigeonPoseName => 'Taube';

  @override
  String get exercisePostureS6PigeonPoseDesc =>
      'Bring aus dem Vierfüßlerstand das rechte Bein im 90°-Winkel gebeugt nach vorn. Streck das linke Bein nach hinten. Senk die Hüfte Richtung Boden und halte die Position.';

  @override
  String get exercisePostureS6PigeonPoseTip =>
      'Atme tief — die Haltung öffnet die Hüfte nach und nach.';

  @override
  String get exerciseNeckS1NeckTiltName => 'Kopf seitlich neigen';

  @override
  String get exerciseNeckS1NeckTiltDesc =>
      'Neig den Kopf langsam zur rechten Schulter — ohne die Schulter hochzuziehen — und halte die sanfte Dehnung. Dann die andere Seite.';

  @override
  String get exerciseNeckS1NeckTiltTip =>
      'Lass die Schulter nach unten sinken — das vertieft die Dehnung.';

  @override
  String get exerciseNeckS2ChestOpenerName => 'Brustöffner';

  @override
  String get exerciseNeckS2ChestOpenerDesc =>
      'Stell dich aufrecht hin und verschränk die Hände hinter dem Rücken. Zieh die Schulterblätter zusammen und heb die Arme sanft an, während sich die Brust öffnet.';

  @override
  String get exerciseNeckS2ChestOpenerTip =>
      'Konzentrier dich darauf, die Schulterblätter zusammenzuziehen — kein Hohlkreuz.';

  @override
  String get exerciseNeckS3ShoulderRollName => 'Schulterkreisen';

  @override
  String get exerciseNeckS3ShoulderRollDesc =>
      'Kreise die Schultern in großen, langsamen Kreisen — 5-mal nach vorn, dann 5-mal nach hinten. Der Nacken bleibt die ganze Zeit locker.';

  @override
  String get exerciseNeckS3ShoulderRollTip =>
      'Mach die Kreise so groß wie möglich — übertreib die Bewegung.';

  @override
  String get exerciseNeckS4WallAngelName => 'Wall Angels';

  @override
  String get exerciseNeckS4WallAngelDesc =>
      'Stell dich mit Rücken, Kopf und Armen flach an eine Wand. Schieb die Arme über den Kopf, ohne den Kontakt zur Wand zu verlieren. Langsam wieder absenken.';

  @override
  String get exerciseNeckS4WallAngelTip =>
      'Halte den unteren Rücken die ganze Zeit flach an der Wand — das ist schwerer, als es aussieht.';

  @override
  String get exerciseNeckS5DoorwayStretchName => 'Brustdehnung im Türrahmen';

  @override
  String get exerciseNeckS5DoorwayStretchDesc =>
      'Stell dich in einen Türrahmen. Leg beide Unterarme auf Schulterhöhe an den Rahmen. Lehn dich sanft nach vorn, bis du eine Dehnung in Brust und Schultern spürst. Halten.';

  @override
  String get exerciseNeckS5DoorwayStretchTip =>
      'Halte den Rumpf angespannt und geh beim Vorlehnen nicht ins Hohlkreuz.';

  @override
  String get tooltipStreakTitle => 'Aktuelle Serie';

  @override
  String get tooltipStreakBody =>
      'Die Zahl der Tage, an denen du in Folge trainiert hast. Verpasst du einen Tag ohne Serienschutz, fällt sie auf null. Halte das Feuer am Brennen — Goro schaut zu!';

  @override
  String get tooltipLongestStreakTitle => 'Persönlicher Rekord';

  @override
  String get tooltipLongestStreakBody =>
      'Deine längste ununterbrochene Trainingsserie aller Zeiten. Dieser Rekord bleibt für immer — auch wenn deine aktuelle Serie zurückgesetzt wird.';

  @override
  String get tooltipTotalWorkoutsTitle => 'Trainings insgesamt';

  @override
  String get tooltipTotalWorkoutsBody =>
      'Die Gesamtzahl der Trainings, die du seit deinem Start abgeschlossen hast. Jedes zählt — auch Bonustrainings.';

  @override
  String get tooltipFreezesTitle => 'Serienschutz';

  @override
  String get tooltipFreezesBody =>
      'Ein Serienschutz rettet deine Serie, wenn du einen Tag verpasst. Du verdienst ihn automatisch, wenn du regelmäßig trainierst. Du kannst bis zu 3 gleichzeitig haben.';

  @override
  String get tooltipRankTitle => 'Rang und Stärkepunkte';

  @override
  String get exerciseLibraryTitle => 'Alle Übungen';

  @override
  String get exerciseLibrarySearchHint => 'Übungen suchen...';

  @override
  String get exerciseLibraryCatalogButton => 'Übungskatalog';

  @override
  String get exerciseLibraryEmpty => 'Keine Übungen gefunden';

  @override
  String get exerciseLibraryReset => 'Zurücksetzen';

  @override
  String get exerciseTagFilterAll => 'Alle';

  @override
  String exerciseLibraryCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Übungen',
      one: '$count Übung',
    );
    return '$_temp0';
  }

  @override
  String get exerciseDetailTipLabel => 'Technik';

  @override
  String exerciseDetailStageLabel(int stage) {
    return 'Stufe $stage';
  }

  @override
  String get exerciseTagHipFlexor => 'Hüftbeuger';

  @override
  String get exerciseTagGlutes => 'Po';

  @override
  String get exerciseTagCore => 'Rumpf';

  @override
  String get exerciseTagChest => 'Brust';

  @override
  String get exerciseTagBack => 'Rücken';

  @override
  String get exerciseTagShoulders => 'Schultern';

  @override
  String get exerciseTagLegs => 'Beine';

  @override
  String get exerciseTagNeck => 'Nacken';

  @override
  String get exerciseTagStretch => 'Dehnung';

  @override
  String get exerciseTagMobility => 'Mobilität';

  @override
  String get exerciseTagStrength => 'Kraft';

  @override
  String get exerciseTagEndurance => 'Ausdauer';

  @override
  String get exerciseTagSittingRecovery => 'Ausgleich zum Sitzen';

  @override
  String get exerciseTagFloorOnly => 'Ohne Geräte';

  @override
  String get exerciseTagRequiresBar => 'Stange nötig';

  @override
  String get exerciseTagPostureFocus => 'Haltung';

  @override
  String get exerciseTagBeginner => 'Einsteiger';

  @override
  String get exerciseTagWarmup => 'Aufwärmen';

  @override
  String get exerciseTagCooldown => 'Cool-down';

  @override
  String get customWorkoutNoWarmupTitle =>
      'Aufwärmen und Cool-down hinzufügen?';

  @override
  String get customWorkoutNoWarmupBody =>
      'Deine Routine hat kein Aufwärmen und kein Cool-down. Automatisch hinzufügen?';

  @override
  String get customWorkoutAdd => 'Hinzufügen';

  @override
  String get customWorkoutSkip => 'Überspringen';

  @override
  String get customWorkoutButtonLabel => 'Eigenes Training';

  @override
  String get customWorkoutMyRoutines => 'Meine Routinen';

  @override
  String get customWorkoutNewRoutine => 'Neue Routine';

  @override
  String get customWorkoutQuickRoutine => 'Schnelle Routine';

  @override
  String get customWorkoutQuickRoutineDesc =>
      'Wähl einen Schwerpunkt — wir suchen die Übungen für dich aus';

  @override
  String get customWorkoutEmpty => 'Noch keine gespeicherten Routinen';

  @override
  String get customWorkoutNameHint => 'Name der Routine';

  @override
  String get customWorkoutNameRequired =>
      'Gib einen Namen ein, um die Routine zu speichern';

  @override
  String get customWorkoutSave => 'Routine speichern';

  @override
  String get customWorkoutStartNow => 'Jetzt starten';

  @override
  String get customWorkoutDelete => 'Löschen';

  @override
  String get customWorkoutEdit => 'Bearbeiten';

  @override
  String get customWorkoutBuilderTitle => 'Routine erstellen';

  @override
  String get customWorkoutBuilderDesc =>
      'Wähl Übungen aus und stell deine eigene Reihenfolge zusammen';

  @override
  String get customWorkoutPickFocus => 'Was möchtest du trainieren?';

  @override
  String customWorkoutExerciseCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Übungen',
      one: '$count Übung',
    );
    return '$_temp0';
  }

  @override
  String rankDecayWarning(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days Tagen',
      one: '$days Tag',
    );
    return 'Du hast seit $_temp0 nicht trainiert — dein Rang ist gesunken. Leg wieder los!';
  }

  @override
  String get summaryRankRestoredTitle => 'Rang wiederhergestellt!';

  @override
  String get summaryRankRestoredBody =>
      'Trainiere weiter — dein Rang ist vollständig wiederhergestellt!';

  @override
  String get notificationMorningTitle => 'Zeit fürs Training! 💪';

  @override
  String get notificationMorningBody =>
      'Dein tägliches Training wartet. Halte deine Serie am Leben!';

  @override
  String get notificationEveningTitle => 'Noch ist Zeit! 🏃';

  @override
  String get notificationEveningBody =>
      'Du hast heute noch nicht trainiert. Auch ein kurzes Training zählt.';

  @override
  String get notificationStreakTitle => 'Serie in Gefahr! 🔥';

  @override
  String get notificationStreakBody =>
      'Trainiere vor Mitternacht, sonst endet deine Serie.';

  @override
  String get notificationStreakLostTitle => 'Serie verloren 😔';

  @override
  String notificationStreakLostBody(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days Tagen',
      one: '$days Tag',
    );
    return 'Deine Serie von $_temp0 ist vorbei. Starte eine neue — der erste Schritt ist immer der schwerste!';
  }

  @override
  String get notificationRankAtRiskTitle => 'Rang in Gefahr! ⚠️';

  @override
  String get notificationRankAtRiskBody =>
      '14 Tage ohne Training — dein Rang beginnt bald zu sinken. Komm zurück!';

  @override
  String get widgetDoneLabel => 'Erledigt';
}
