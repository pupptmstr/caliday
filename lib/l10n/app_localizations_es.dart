// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String durationMin(int mins, int secs) {
    return '$mins min $secs s';
  }

  @override
  String durationSec(int secs) {
    return '$secs s';
  }

  @override
  String durationSecPerSide(int secs) {
    return '$secs s por lado';
  }

  @override
  String get navHome => 'Entrenar';

  @override
  String get navLibrary => 'Cursos';

  @override
  String get navProfile => 'Perfil';

  @override
  String get libraryTitle => 'Cursos';

  @override
  String get progressInfo =>
      'Solo sigue entrenando: la app te hace avanzar por las ramas automáticamente. Aquí puedes ver cuánto has avanzado. Y si te sientes listo para adelantarte, acepta el reto y da el siguiente paso por tu cuenta.';

  @override
  String homeStreakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count días',
      one: '$count día',
    );
    return '$_temp0';
  }

  @override
  String get homeBranchesTitle => 'Ramas de habilidades';

  @override
  String get homeBranchPush => 'Empuje';

  @override
  String get homeBranchPull => 'Tracción';

  @override
  String get homeBranchCore => 'Core';

  @override
  String get homeBranchLegs => 'Piernas';

  @override
  String get homeBranchBalance => 'Equilibrio';

  @override
  String get homeBranchFlex => 'Flexibilidad';

  @override
  String get homeBranchPosture => 'Postura';

  @override
  String get homeBranchNeck => 'Cuello';

  @override
  String get courseNameCalisthenics => 'Calistenia';

  @override
  String get courseNameHealthyBody => 'Cuerpo sano';

  @override
  String get courseDescCalisthenics =>
      'Ejercicios con tu propio peso, de lo básico a lo avanzado. Gana fuerza, resistencia y control del cuerpo.';

  @override
  String get courseDescHealthyBody =>
      'Ejercicios para quienes pasan el día sentados. Mejora la postura, libera la tensión del cuello y gana flexibilidad, sin castigar las articulaciones.';

  @override
  String get onboardingQ4Courses => 'Elige un curso';

  @override
  String get onboardingQ4CoursesBody =>
      'Puedes empezar con uno o elegir los dos: los programas son independientes.';

  @override
  String branchJourneyProgress(int done, int total) {
    return '$done de $total etapas completadas';
  }

  @override
  String get branchJourneyStageCompleted => '✓ Completada';

  @override
  String get branchJourneyStageCurrent => 'Etapa actual';

  @override
  String get branchJourneyStageLocked => 'Bloqueada';

  @override
  String branchJourneyParams(int reps, int sets, int rest) {
    String _temp0 = intl.Intl.pluralLogic(
      sets,
      locale: localeName,
      other: '$sets series',
      one: '$sets serie',
    );
    return '$reps rep. × $_temp0  ·  Descanso $rest s';
  }

  @override
  String branchJourneyParamsTimed(int secs, int sets, int rest) {
    String _temp0 = intl.Intl.pluralLogic(
      sets,
      locale: localeName,
      other: '$sets series',
      one: '$sets serie',
    );
    return '$secs s × $_temp0  ·  Descanso $rest s';
  }

  @override
  String branchJourneyParamsTimedPerSide(int secs, int sets, int rest) {
    String _temp0 = intl.Intl.pluralLogic(
      sets,
      locale: localeName,
      other: '$sets series',
      one: '$sets serie',
    );
    return '$secs s por lado × $_temp0  ·  Descanso $rest s';
  }

  @override
  String get branchJourneyStartChallenge => 'Hacer el reto';

  @override
  String homeStage(int stage, int total) {
    return 'Etapa $stage/$total';
  }

  @override
  String get homeChallengeUnlocked => 'Reto disponible';

  @override
  String get homeChallengeButton => 'Aceptar el reto';

  @override
  String homeChallengeNormReps(int n) {
    return 'Meta: $n rep.';
  }

  @override
  String homeChallengeNormSec(int n) {
    return 'Meta: $n s';
  }

  @override
  String homeChallengeNormSecPerSide(int n) {
    return 'Meta: $n s por lado';
  }

  @override
  String get homeWorkoutDone => 'Entrenamiento hecho';

  @override
  String get homeWorkoutStart => 'Entreno de hoy';

  @override
  String homeWorkoutStartEstimate(int minutes) {
    return 'Entreno de hoy (≈ $minutes min)';
  }

  @override
  String get homeWorkoutAgain => 'Otra vez';

  @override
  String homeWorkoutAgainEstimate(int minutes) {
    return 'Otra vez (≈ $minutes min)';
  }

  @override
  String get workoutTitle => 'Entrenamiento';

  @override
  String get workoutExitTitle => '¿Salir del entrenamiento?';

  @override
  String get workoutExitBody => 'Tu progreso no se guardará.';

  @override
  String get workoutContinue => 'Continuar';

  @override
  String get workoutAbort => 'Salir';

  @override
  String workoutSetProgress(int current, int total) {
    return 'Serie $current de $total';
  }

  @override
  String workoutSetSideProgress(int current, int total, int side) {
    return 'Serie $current de $total  ·  lado $side de 2';
  }

  @override
  String get workoutSec => 's';

  @override
  String get workoutRestLabel => 'descanso';

  @override
  String get workoutReps => 'Rep.';

  @override
  String get workoutGetReady => 'prepárate';

  @override
  String get workoutSwitchSides => 'cambia de lado';

  @override
  String get workoutPaused => 'en pausa';

  @override
  String get workoutPause => 'Pausa';

  @override
  String get workoutPrepHint =>
      'Lee la descripción y ponte en posición. El temporizador arranca solo; toca Pausa si necesitas más tiempo.';

  @override
  String get workoutPrepPausedHint =>
      'En pausa. Toca Continuar cuando estés listo: la cuenta atrás sigue donde se detuvo.';

  @override
  String get workoutSwitchSidesHint =>
      'Cambia al otro lado. El temporizador arranca solo; toca Pausa si necesitas más tiempo.';

  @override
  String get workoutStop => 'Parar';

  @override
  String get workoutDone => '✓  Hecho';

  @override
  String get workoutSkipRest => 'Saltar';

  @override
  String get workoutSetDone => '✅  ¡Serie hecha!';

  @override
  String get workoutExerciseDone => '✅  ¡Ejercicio hecho!';

  @override
  String workoutAmountReps(int count) {
    return '$count rep.';
  }

  @override
  String workoutNextExercise(String name, String amount) {
    return 'Siguiente: $name • $amount';
  }

  @override
  String workoutNextSet(int setNum, String amount) {
    return 'Siguiente: serie $setNum • $amount';
  }

  @override
  String get summaryTitle => '¡Gran entrenamiento!';

  @override
  String get summarySubtitle => 'Sigue así: un paso más hacia delante';

  @override
  String get summaryLabelTime => 'Tiempo';

  @override
  String get summaryLabelExercises => 'Ejerc.';

  @override
  String get summaryHome => 'Inicio';

  @override
  String get summaryFreezeUsedTitle => '¡Un protector salvó tu racha!';

  @override
  String get summaryFreezeUsedBody => 'La racha continúa: sigue así';

  @override
  String get summaryFreezeEarnedTitle => '¡Protector de racha conseguido!';

  @override
  String get summaryFreezeEarnedBody => 'Se usa si te saltas un día';

  @override
  String get achievementsTitle => 'Logros';

  @override
  String get achievementsEarnedSection => 'Conseguidos';

  @override
  String get achievementsLockedSection => 'Bloqueados';

  @override
  String get achievementsSecret => '???';

  @override
  String get achievementsSecretDesc =>
      'Cumple una condición especial para desbloquearlo';

  @override
  String achievementsEarnedOn(String date) {
    return 'Conseguido: $date';
  }

  @override
  String get profileAchievementsTitle => 'Logros';

  @override
  String get profileAchievementsAll => 'Todos los logros →';

  @override
  String get profileNoAchievements => 'Aún no hay logros';

  @override
  String get summaryAchievementsTitle => '¡Nuevos logros!';

  @override
  String get achievementFirstWorkoutName => 'Primer paso';

  @override
  String get achievementFirstWorkoutDesc =>
      'Completaste tu primer entrenamiento: ¡empieza el viaje!';

  @override
  String get achievementFirstChallengeName => 'Reto aceptado';

  @override
  String get achievementFirstChallengeDesc =>
      'Primer reto superado: ahora sabes de lo que eres capaz';

  @override
  String get achievementStreak3Name => 'Tres seguidos';

  @override
  String get achievementStreak3Desc =>
      '3 días seguidos: el hábito se está formando';

  @override
  String get achievementStreak7Name => 'Semana completa';

  @override
  String get achievementStreak7Desc =>
      'Una semana entera: ya superas a la mayoría';

  @override
  String get achievementStreak30Name => 'Maratoniano';

  @override
  String get achievementStreak30Desc =>
      '30 días sin parar: eso es disciplina de verdad';

  @override
  String get achievementStreak100Name => 'Voluntad de hierro';

  @override
  String get achievementStreak100Desc =>
      '100 días sin descanso: un logro legendario';

  @override
  String get achievementWorkouts10Name => 'Diez';

  @override
  String get achievementWorkouts10Desc =>
      '10 entrenamientos completados: un buen comienzo';

  @override
  String get achievementWorkouts50Name => 'Cincuenta';

  @override
  String get achievementWorkouts50Desc => '50 entrenamientos: vas en serio';

  @override
  String get achievementWorkouts100Name => 'Centurión';

  @override
  String get achievementWorkouts100Desc =>
      '100 entrenamientos: estás en la élite';

  @override
  String get achievementRankAmateurName => 'Aficionado';

  @override
  String get achievementRankAmateurDesc =>
      'Rango Aficionado alcanzado: los SP se van sumando';

  @override
  String get achievementRankSportsmanName => 'Deportista';

  @override
  String get achievementRankSportsmanDesc =>
      'Rango Deportista: ya eres más que un aficionado';

  @override
  String get achievementRankAthleteName => 'Atleta';

  @override
  String get achievementRankAthleteDesc => 'Rango Atleta: un nivel serio';

  @override
  String get achievementRankMasterName => 'Maestro';

  @override
  String get achievementRankMasterDesc =>
      'Rango Maestro: muy pocos llegan tan lejos';

  @override
  String get achievementRankLegendName => 'Leyenda';

  @override
  String get achievementRankLegendDesc => 'Rango máximo. Eres una leyenda.';

  @override
  String get achievementPushS3Name => 'Flexión completa';

  @override
  String get achievementPushS3Desc =>
      'Dominas las flexiones clásicas en el suelo';

  @override
  String get achievementPushS6Name => 'Arquero';

  @override
  String get achievementPushS6Desc =>
      'Dominas las flexiones arquero: la parada de manos está a tu alcance';

  @override
  String get achievementPushCompleteName => 'Maestro del empuje';

  @override
  String get achievementPushCompleteDesc =>
      'Las 7 etapas de Empuje superadas. Goro está orgulloso.';

  @override
  String get achievementCoreS2Name => 'Plancha de hierro';

  @override
  String get achievementCoreS2Desc =>
      'Plancha dominada: la base de todo el trabajo de core';

  @override
  String get achievementCoreS5Name => 'L-sit';

  @override
  String get achievementCoreS5Desc =>
      'L-sit: la prueba definitiva de fuerza del core';

  @override
  String get achievementCoreCompleteName => 'Core de hierro';

  @override
  String get achievementCoreCompleteDesc =>
      'Las 6 etapas de Core superadas. Tu core es de acero.';

  @override
  String get achievementPullS3Name => 'Primera dominada';

  @override
  String get achievementPullS3Desc =>
      'La barbilla por encima de la barra: eso es una victoria';

  @override
  String get achievementPullCompleteName => 'Rey de la barra';

  @override
  String get achievementPullCompleteDesc =>
      'Las 6 etapas de Tracción superadas. La barra es tuya.';

  @override
  String get achievementLegsS5Name => 'Sentadilla pistol';

  @override
  String get achievementLegsS5Desc =>
      'Sentadilla a una pierna: equilibrio y fuerza a la vez';

  @override
  String get achievementLegsCompleteName => 'Piernas de acero';

  @override
  String get achievementLegsCompleteDesc =>
      'Las 5 etapas de Piernas superadas. Tus piernas son de acero.';

  @override
  String get achievementBalanceS4Name => 'Postura del cuervo';

  @override
  String get achievementBalanceS4Desc =>
      'Kakasana sostenida: dominas tu equilibrio';

  @override
  String get achievementBalanceS6Name => 'Parada de manos libre';

  @override
  String get achievementBalanceS6Desc =>
      'Parada de manos sin pared: la cima del equilibrio';

  @override
  String get achievementBalanceCompleteName => 'Maestro del equilibrio';

  @override
  String get achievementBalanceCompleteDesc =>
      'Las 6 etapas de Equilibrio superadas. Eres un equilibrista.';

  @override
  String get achievementFlexCompleteName => 'Maestro de la flexibilidad';

  @override
  String get achievementFlexCompleteDesc =>
      'Las 6 etapas de Flexibilidad superadas. Tu cuerpo se dobla en todas las direcciones.';

  @override
  String get achievementAllCompleteName => 'Colección completa';

  @override
  String get achievementAllCompleteDesc =>
      'Las 5 ramas completadas. Campeón absoluto.';

  @override
  String get summaryBonusTitle => 'Entrenamiento extra';

  @override
  String get summaryBonusBody => '×½ SP · cada rama avanza una vez al día';

  @override
  String summaryBonusCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count veces',
      one: '$count vez',
    );
    return '¡Hoy ya has entrenado $_temp0!';
  }

  @override
  String get summaryChallengeUnlockedTitle => '¡El reto te espera!';

  @override
  String get summaryChallengeUnlockedBody =>
      'Toca «Aceptar el reto» en la pantalla de inicio cuando quieras';

  @override
  String get summaryChallengePassedTitle => '¡Nueva etapa!';

  @override
  String summaryChallengePassedBody(String exercise) {
    return 'Has desbloqueado: $exercise';
  }

  @override
  String get profileTitle => 'Perfil';

  @override
  String get profileMaxRank => '¡Rango máximo!';

  @override
  String profileRankProgress(int remaining, String rankName) {
    return '$remaining SP para $rankName';
  }

  @override
  String get profileStatDays => 'días';

  @override
  String get profileStatRecord => 'récord';

  @override
  String get profileStatWorkouts => 'entrenos';

  @override
  String get profileStatFreezes => 'protectores';

  @override
  String get profileHistoryTitle => 'Historial de entrenamientos';

  @override
  String get profileNoHistory => 'Aún no hay entrenamientos completados';

  @override
  String get calendarTitle => 'Calendario';

  @override
  String get calendarSeeAll => 'Abrir →';

  @override
  String get calendarFreezeUsedTitle => 'Protector de racha usado';

  @override
  String get calendarFreezeUsedBody =>
      'Este día no hubo entrenamiento: se usó un protector de racha para mantenerla.';

  @override
  String get calendarLegendOneWorkout => '1 entreno';

  @override
  String get calendarLegendManyWorkouts => '2+ entrenos';

  @override
  String get calendarLegendFreeze => 'Protector';

  @override
  String get historyTypeDaily => 'Entrenamiento diario';

  @override
  String get historyTypeChallenge => 'Reto';

  @override
  String get historyTypeBonus => 'Extra';

  @override
  String get historyDetailExercises => 'Ejercicios';

  @override
  String historyDetailReps(int completed, int target) {
    return '$completed / $target rep.';
  }

  @override
  String historyDetailSec(int completed, int target) {
    return '$completed / $target s';
  }

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get settingsSectionNotifications => 'NOTIFICACIONES';

  @override
  String get settingsSectionLanguage => 'IDIOMA';

  @override
  String get settingsNotificationsTitle => 'Activar notificaciones';

  @override
  String get settingsNotificationsSubtitle =>
      'Permitir que la app envíe recordatorios';

  @override
  String get settingsNotificationTimeTitle => 'Hora del recordatorio';

  @override
  String get settingsNotificationTimeSubtitle =>
      'Recordatorio de entrenamiento por la mañana';

  @override
  String get settingsTimePickerDone => 'Listo';

  @override
  String get settingsEveningReminderTitle => 'Recordatorio por la noche';

  @override
  String get settingsEveningReminderSubtitle =>
      'Recordar por la noche si no has entrenado';

  @override
  String get settingsStreakThreatTitle => 'Racha en peligro';

  @override
  String get settingsStreakThreatSubtitle =>
      'Avisar cuando tu racha esté en riesgo';

  @override
  String get settingsLanguageTitle => 'Idioma de la app';

  @override
  String get settingsSectionTheme => 'TEMA';

  @override
  String get settingsThemeSystem => 'Sistema';

  @override
  String get settingsThemeLight => 'Claro';

  @override
  String get settingsThemeDark => 'Oscuro';

  @override
  String get settingsSectionEquipment => 'EQUIPAMIENTO';

  @override
  String get settingsEquipmentPullUpBar => 'Barra de dominadas en casa';

  @override
  String get settingsEquipmentPullUpBarSubtitle => 'Activa la rama de Tracción';

  @override
  String get settingsSectionWorkout => 'ENTRENAMIENTO';

  @override
  String get settingsSoundTitle => 'Sonidos';

  @override
  String get settingsSoundSubtitle => 'Sonidos durante el entrenamiento';

  @override
  String get settingsHapticTitle => 'Vibración';

  @override
  String get settingsHapticSubtitle =>
      'Respuesta háptica durante el entrenamiento';

  @override
  String get rankBeginner => 'Principiante';

  @override
  String get rankAmateur => 'Aficionado';

  @override
  String get rankSportsman => 'Deportista';

  @override
  String get rankAthlete => 'Atleta';

  @override
  String get rankMaster => 'Maestro';

  @override
  String get rankLegend => 'Leyenda';

  @override
  String get onboardingWelcomeTitle => '¡Hola! Soy Goro';

  @override
  String get onboardingWelcomeBody =>
      'Series cortas, progreso de habilidades, rachas y puntos.\nDe las flexiones de rodillas a la parada de manos, paso a paso.';

  @override
  String get onboardingWelcomeCta => 'Configuremos todo en 1 minuto';

  @override
  String get onboardingContinue => 'Continuar';

  @override
  String get onboardingStart => 'Empezar a entrenar 🔥';

  @override
  String get onboardingQ1 => '¿Cómo te llamas?';

  @override
  String get onboardingQ1Hint => 'Tu nombre (opcional)';

  @override
  String get onboardingQ1Body => 'Goro lo usará para animarte';

  @override
  String get onboardingQ2 => '¿Cuántas flexiones puedes hacer?';

  @override
  String get onboardingQ3 => '¿Qué tamaño debe tener tu entrenamiento?';

  @override
  String get workoutSizeShort => 'Corto';

  @override
  String get workoutSizeStandard => 'Estándar';

  @override
  String get workoutSizeFull => 'Completo';

  @override
  String get workoutSizeShortDesc => '2 habilidades';

  @override
  String get workoutSizeStandardDesc => '3 habilidades';

  @override
  String get workoutSizeFullDesc => 'Todas tus habilidades';

  @override
  String get settingsWorkoutSizeTitle => 'Tamaño del entrenamiento';

  @override
  String get settingsWorkoutSizeSubtitle =>
      'Cuántas habilidades incluye el entrenamiento diario';

  @override
  String get onboardingQ5 =>
      '¿Tienes una barra de dominadas o anillas en casa?';

  @override
  String get onboardingEquipmentYes => 'Sí, tengo';

  @override
  String get onboardingEquipmentNo => 'No';

  @override
  String get onboardingQ6Health => 'Sincronizar con Salud';

  @override
  String get onboardingHealthBody =>
      'CaliDay puede guardar tus entrenamientos automáticamente en Apple Health (iOS) o Health Connect (Android).';

  @override
  String get onboardingHealthEnable => 'Activar';

  @override
  String get onboardingHealthEnableDesc =>
      'Guardar los entrenamientos automáticamente';

  @override
  String get onboardingHealthSkip => 'Ahora no';

  @override
  String get onboardingHealthSkipDesc =>
      'Puedes activarlo más tarde en Ajustes';

  @override
  String get onboardingQ7 => '¿Cuándo te recordamos entrenar?';

  @override
  String get pushupZeroDesc => 'Aún ninguna';

  @override
  String get pushupOneToFiveDesc => 'Solo unas pocas';

  @override
  String get pushupFiveToFifteenDesc => 'Voy progresando';

  @override
  String get pushupMoreThan15Desc => 'Buena base';

  @override
  String get timeOfDayMorning => 'Mañana';

  @override
  String get timeOfDayDay => 'Tarde';

  @override
  String get timeOfDayLunch => 'Mediodía';

  @override
  String get timeOfDayEvening => 'Noche';

  @override
  String get exercisePushS1WallPushupName => 'Flexión en la pared';

  @override
  String get exercisePushS1WallPushupDesc =>
      'Colócate a un paso de la pared y apoya las palmas a la altura del pecho. Dobla los brazos hasta que el pecho toque la pared y empuja de vuelta.';

  @override
  String get exercisePushS1WallPushupTip =>
      'Mantén el cuerpo recto: no arquees la zona lumbar.';

  @override
  String get exercisePushS2KneePushupName => 'Flexión de rodillas';

  @override
  String get exercisePushS2KneePushupDesc =>
      'Posición de flexión con las rodillas en el suelo. Mantén una línea recta de las rodillas a la cabeza. Baja el pecho al suelo y empuja hacia arriba.';

  @override
  String get exercisePushS2KneePushupTip =>
      'No dejes caer la cadera: mantén una línea recta de las rodillas a los hombros.';

  @override
  String get exercisePushS3FullPushupName => 'Flexión completa';

  @override
  String get exercisePushS3FullPushupDesc =>
      'Posición clásica de flexión. El cuerpo forma una línea recta de los talones a la cabeza. El pecho toca el suelo o queda a 2–3 cm de él.';

  @override
  String get exercisePushS3FullPushupTip =>
      'Aprieta el abdomen y los glúteos para que la cadera no se hunda.';

  @override
  String get exercisePushS4DiamondPushupName => 'Flexión diamante';

  @override
  String get exercisePushS4DiamondPushupDesc =>
      'Manos bajo el pecho, con los pulgares y los índices formando un diamante. Trabaja sobre todo el tríceps. Mantén los codos pegados al bajar.';

  @override
  String get exercisePushS4DiamondPushupTip =>
      'No abras los codos: deja que se deslicen junto al cuerpo.';

  @override
  String get exercisePushS5WidePushupName => 'Flexión abierta';

  @override
  String get exercisePushS5WidePushupDesc =>
      'Manos bastante más abiertas que el ancho de los hombros. Baja despacio con el cuerpo en línea recta. Pecho y tríceps trabajan en un rango de movimiento amplio.';

  @override
  String get exercisePushS5WidePushupTip =>
      'Cuanto más abiertas las manos, más trabaja el pecho y menos el tríceps.';

  @override
  String get exercisePushS6ArcherPushupName => 'Flexión arquero';

  @override
  String get exercisePushS6ArcherPushupDesc =>
      'Manos muy abiertas. Baja hacia un brazo mientras el otro se mantiene estirado. Alterna los lados.';

  @override
  String get exercisePushS6ArcherPushupTip =>
      'El brazo que trabaja hace el recorrido completo; el brazo estirado se queda en el suelo como apoyo.';

  @override
  String get exercisePushS7HandstandPushupName => 'Flexión en parada de manos';

  @override
  String get exercisePushS7HandstandPushupDesc =>
      'Parada de manos contra la pared (de espaldas a ella). Baja despacio la cabeza hacia el suelo y vuelve a empujar el cuerpo hacia arriba.';

  @override
  String get exercisePushS7HandstandPushupTip =>
      'Abre bien los dedos para tener estabilidad. Mira entre las manos.';

  @override
  String get exerciseCoreS1CrunchesName => 'Crunch abdominal';

  @override
  String get exerciseCoreS1CrunchesDesc =>
      'Acuéstate boca arriba con las rodillas dobladas. Manos detrás de la cabeza o cruzadas sobre el pecho. Despega los omóplatos del suelo contrayendo el abdomen.';

  @override
  String get exerciseCoreS1CrunchesTip =>
      'No tires del cuello con las manos: lleva el pecho hacia el techo.';

  @override
  String get exerciseCoreS2PlankName => 'Plancha';

  @override
  String get exerciseCoreS2PlankDesc =>
      'Posición de flexión sobre los antebrazos. El cuerpo forma una línea recta de los talones a la cabeza. No subas la cadera ni arquees la zona lumbar.';

  @override
  String get exerciseCoreS2PlankTip =>
      'Aprieta el abdomen y los glúteos. Respira con calma: no aguantes la respiración.';

  @override
  String get exerciseCoreS3LyingLegRaiseName =>
      'Elevación de piernas boca arriba';

  @override
  String get exerciseCoreS3LyingLegRaiseDesc =>
      'Acuéstate boca arriba con las manos bajo los glúteos. Sube las piernas estiradas hasta la vertical y bájalas despacio sin tocar el suelo.';

  @override
  String get exerciseCoreS3LyingLegRaiseTip =>
      'Mantén la zona lumbar pegada al suelo durante todo el movimiento.';

  @override
  String get exerciseCoreS4HangingLegRaiseName =>
      'Elevación de piernas colgado';

  @override
  String get exerciseCoreS4HangingLegRaiseDesc =>
      'Cuélgate de una barra. Sube las piernas estiradas hasta quedar paralelas al suelo o más arriba. Controla la bajada.';

  @override
  String get exerciseCoreS4HangingLegRaiseTip =>
      'No te balancees: el movimiento sale solo del abdomen.';

  @override
  String get exerciseCoreS4FlutterKicksName => 'Patadas alternas';

  @override
  String get exerciseCoreS4FlutterKicksDesc =>
      'Acuéstate boca arriba, con las manos bajo los glúteos. Levanta las dos piernas 15–20 cm del suelo. Sube y baja cada pierna por turnos con movimientos cortos y rápidos. Una repetición = un ciclo (derecha arriba + izquierda arriba).';

  @override
  String get exerciseCoreS4FlutterKicksTip =>
      'Mantén la zona lumbar pegada al suelo. Las piernas no tocan el suelo entre repeticiones.';

  @override
  String get exerciseCoreS5LSitName => 'L-sit';

  @override
  String get exerciseCoreS5LSitDesc =>
      'Apóyate en unas paralelas o en el suelo. Piernas estiradas y paralelas al suelo. Mantén la posición todo lo que puedas.';

  @override
  String get exerciseCoreS5LSitTip =>
      'Lleva las puntas de los pies hacia ti; baja los hombros y llévalos hacia atrás.';

  @override
  String get exerciseCoreS6DragonFlagName => 'Dragon flag';

  @override
  String get exerciseCoreS6DragonFlagDesc =>
      'Acuéstate en un banco y agarra un apoyo detrás de la cabeza. Eleva el cuerpo en línea recta apoyado en los omóplatos y bájalo despacio.';

  @override
  String get exerciseCoreS6DragonFlagTip =>
      'Empieza por la fase negativa (solo la bajada): es más fácil.';

  @override
  String get exerciseWarmupArmRotationsName => 'Círculos de brazos';

  @override
  String get exerciseWarmupArmRotationsDesc =>
      'De pie, haz círculos amplios con los brazos hacia delante y hacia atrás. Calienta la cintura escapular antes de las flexiones.';

  @override
  String get exerciseWarmupJumpingJacksName => 'Saltos de tijera';

  @override
  String get exerciseWarmupJumpingJacksDesc =>
      'Los clásicos jumping jacks. Suben las pulsaciones y calientan todo el cuerpo en 30–60 segundos.';

  @override
  String get exerciseCooldownShoulderStretchName =>
      'Estiramiento de hombros y pecho';

  @override
  String get exerciseCooldownShoulderStretchDesc =>
      'Entrelaza las manos detrás de la espalda y lleva los hombros hacia atrás y hacia abajo. Mantén 30 segundos.';

  @override
  String get exerciseCooldownCatCowName => 'Gato-vaca';

  @override
  String get exerciseCooldownCatCowDesc =>
      'A cuatro patas: inhala y deja caer la espalda (vaca), exhala y redondéala hacia arriba (gato). Libera la tensión de la zona lumbar y del abdomen.';

  @override
  String get exercisePullS1AustralianName => 'Dominada australiana';

  @override
  String get exercisePullS1AustralianDesc =>
      'Acuéstate bajo una barra con un agarre algo más ancho que los hombros. Lleva el pecho a la barra con el cuerpo en línea recta. Controla la bajada.';

  @override
  String get exercisePullS1AustralianTip =>
      'Cuanto más baja la barra, más difícil el ejercicio.';

  @override
  String get exercisePullS2NegativeName => 'Dominada negativa';

  @override
  String get exercisePullS2NegativeDesc =>
      'Salta hasta tener la barbilla por encima de la barra. Baja despacio durante 3–5 segundos hasta estirar del todo los brazos.';

  @override
  String get exercisePullS2NegativeTip =>
      'Cuanto más lenta la bajada, mejor. Intenta bajar en 5 segundos.';

  @override
  String get exercisePullS3PullupName => 'Dominada';

  @override
  String get exercisePullS3PullupDesc =>
      'Agarre al ancho de los hombros o algo más ancho. Lleva el pecho a la barra hasta que la barbilla la supere. Estira del todo los brazos abajo.';

  @override
  String get exercisePullS3PullupTip =>
      'Junta los omóplatos: tiras con la espalda, no con los brazos.';

  @override
  String get exercisePullS4CloseGripName => 'Dominada con agarre cerrado';

  @override
  String get exercisePullS4CloseGripDesc =>
      'Agarre más estrecho que los hombros, con las palmas hacia ti o hacia fuera. Trabaja los bíceps y la parte baja del dorsal. Lleva el pecho a la barra.';

  @override
  String get exercisePullS4CloseGripTip =>
      'Mantén los codos cerca del cuerpo para que el bíceps trabaje al máximo.';

  @override
  String get exercisePullS5ArcherName => 'Dominada arquero';

  @override
  String get exercisePullS5ArcherDesc =>
      'Agarre ancho. Lleva el cuerpo hacia un brazo mientras el otro se mantiene estirado. Alterna los lados.';

  @override
  String get exercisePullS5ArcherTip =>
      'El brazo estirado es de apoyo; el que trabaja hace el recorrido completo.';

  @override
  String get exercisePullS6OneArmName => 'Dominada a una mano';

  @override
  String get exercisePullS6OneArmDesc =>
      'Una mano en la barra, la otra sobre la muñeca o libre. Recorrido completo con el brazo que trabaja.';

  @override
  String get exercisePullS6OneArmTip =>
      'Mantén el core firme: no te balancees.';

  @override
  String get exerciseWarmupDeadHangName => 'Colgarse de la barra';

  @override
  String get exerciseWarmupDeadHangDesc =>
      'Cuélgate de la barra con agarre prono y los brazos totalmente estirados. Relaja los hombros y mantén la suspensión.';

  @override
  String get exerciseCooldownLatStretchName => 'Estiramiento de dorsales';

  @override
  String get exerciseCooldownLatStretchDesc =>
      'Ponte de lado junto a una pared, levanta un brazo y apóyalo en ella. Inclínate hacia el estiramiento hasta sentirlo en el costado.';

  @override
  String get exerciseLegsS1SquatName => 'Sentadilla';

  @override
  String get exerciseLegsS1SquatDesc =>
      'Pies al ancho de los hombros, puntas ligeramente hacia fuera. Baja hasta que los muslos queden paralelos al suelo, con las rodillas sobre los pies. Estírate del todo arriba.';

  @override
  String get exerciseLegsS1SquatTip => 'Talones en el suelo y pecho erguido.';

  @override
  String get exerciseLegsS2LungeName => 'Zancada';

  @override
  String get exerciseLegsS2LungeDesc =>
      'Da un paso al frente y baja la rodilla de atrás hacia el suelo sin tocarlo. Ambas rodillas a 90°. Empuja con el pie delantero para volver.';

  @override
  String get exerciseLegsS2LungeTip =>
      'La rodilla delantera no pasa de la punta del pie.';

  @override
  String get exerciseLegsS3BulgarianName => 'Sentadilla búlgara';

  @override
  String get exerciseLegsS3BulgarianDesc =>
      'El pie trasero apoyado en alto, sobre una silla o un sofá. Baja con la pierna delantera hasta que el muslo quede paralelo al suelo. Torso erguido.';

  @override
  String get exerciseLegsS3BulgarianTip =>
      'Cuanto más adelantado el pie delantero, más trabajan los glúteos.';

  @override
  String get exerciseLegsS4AssistedPistolName => 'Sentadilla pistol asistida';

  @override
  String get exerciseLegsS4AssistedPistolDesc =>
      'Sujétate a un marco de puerta o a un poste como apoyo. Baja sobre una pierna con la otra estirada al frente. El apoyo te quita carga.';

  @override
  String get exerciseLegsS4AssistedPistolTip =>
      'Usa cada vez menos las manos a medida que ganes fuerza.';

  @override
  String get exerciseLegsS5PistolName => 'Sentadilla pistol';

  @override
  String get exerciseLegsS5PistolDesc =>
      'Sentadilla a una pierna sin apoyo. La otra pierna estirada al frente. Recorrido completo hasta el suelo y de vuelta arriba.';

  @override
  String get exerciseLegsS5PistolTip =>
      'Brazos al frente como contrapeso: ayuda con el equilibrio.';

  @override
  String get exerciseWarmupLegSwingsName => 'Balanceo de piernas';

  @override
  String get exerciseWarmupLegSwingsDesc =>
      'De pie junto a una pared, balancea una pierna hacia delante y hacia atrás, y luego de lado a lado. Calienta la articulación de la cadera.';

  @override
  String get exerciseCooldownQuadStretchName => 'Estiramiento de cuádriceps';

  @override
  String get exerciseCooldownQuadStretchDesc =>
      'Apóyate en una pierna, dobla la otra hacia atrás y sujeta el pie con la mano. Siente el estiramiento en la parte delantera del muslo.';

  @override
  String get exerciseWarmupHipCirclesName => 'Círculos de cadera';

  @override
  String get exerciseWarmupHipCirclesDesc =>
      'De pie, con los pies al ancho de los hombros. Haz círculos lentos con la cadera en el sentido de las agujas del reloj y luego al revés. Calienta las articulaciones de la cadera.';

  @override
  String get exerciseCooldownHipFlexorName =>
      'Estiramiento del flexor de cadera';

  @override
  String get exerciseCooldownHipFlexorDesc =>
      'Da una zancada y apoya la rodilla de atrás en el suelo. Empuja la cadera hacia delante y hacia abajo hasta sentir el estiramiento en la cadera. Mantén en cada lado.';

  @override
  String get exerciseBalS1OneLegStandName => 'Equilibrio a una pierna';

  @override
  String get exerciseBalS1OneLegStandDesc =>
      'Apóyate en una pierna, con la otra ligeramente doblada y sin tocar el suelo. Puedes abrir los brazos para equilibrarte.';

  @override
  String get exerciseBalS1OneLegStandTip =>
      'Fija la mirada en un punto: mejora mucho el equilibrio.';

  @override
  String get exerciseBalS2OneArmPlankName => 'Plancha a una mano';

  @override
  String get exerciseBalS2OneArmPlankDesc =>
      'Plancha clásica con los brazos estirados. Levanta una mano del suelo y mantén la posición, con el cuerpo paralelo al suelo.';

  @override
  String get exerciseBalS2OneArmPlankTip =>
      'Mantén la cadera paralela al suelo: no gires el torso.';

  @override
  String get exerciseBalS3CrowPrepName => 'Preparación del cuervo';

  @override
  String get exerciseBalS3CrowPrepDesc =>
      'En cuclillas, apoya las rodillas en los tríceps. Pasa el peso a las manos y despega los pies con suavidad. Mantén el equilibrio.';

  @override
  String get exerciseBalS3CrowPrepTip =>
      'Mira hacia delante y abajo, no justo abajo: si no, te irás hacia delante.';

  @override
  String get exerciseBalS4CrowPoseName => 'Postura del cuervo (Kakasana)';

  @override
  String get exerciseBalS4CrowPoseDesc =>
      'Ambas rodillas sobre los tríceps, todo el peso en las manos. Brazos ligeramente doblados, dedos bien abiertos.';

  @override
  String get exerciseBalS4CrowPoseTip =>
      'Redondea la espalda: activa el core y te da equilibrio.';

  @override
  String get exerciseBalS5WallHsName => 'Parada de manos en la pared';

  @override
  String get exerciseBalS5WallHsDesc =>
      'Sube a la parada de manos de espaldas a la pared. Los talones tocan la pared como apoyo. Mantén la posición con el cuerpo en línea recta.';

  @override
  String get exerciseBalS5WallHsTip =>
      'Abre bien los dedos y empuja con las yemas: así controlas el equilibrio.';

  @override
  String get exerciseBalS6FreeHsName => 'Parada de manos libre';

  @override
  String get exerciseBalS6FreeHsDesc =>
      'Parada de manos sin apoyo en la pared. Controla el equilibrio con pequeños movimientos de los dedos y las muñecas.';

  @override
  String get exerciseBalS6FreeHsTip =>
      'Mira al suelo 30–40 cm por delante de las manos, no entre ellas.';

  @override
  String get exerciseWarmupWristCirclesName => 'Círculos de muñecas';

  @override
  String get exerciseWarmupWristCirclesDesc =>
      'Gira las muñecas en el sentido de las agujas del reloj y al revés. Prepara las articulaciones para cargar peso sobre las manos.';

  @override
  String get exerciseCooldownDownwardDogName => 'Perro boca abajo';

  @override
  String get exerciseCooldownDownwardDogDesc =>
      'Desde cuatro patas, estira brazos y piernas y sube la cadera. El cuerpo forma una V invertida. Estira muñecas, hombros y piernas.';

  @override
  String get aboutTitle => 'Acerca de';

  @override
  String get aboutSectionSupport => 'SOPORTE';

  @override
  String get aboutContactUs => 'Contacto';

  @override
  String get aboutContactUsSubtitle => 'Informa de un error o haz una pregunta';

  @override
  String get aboutPrivacyPolicy => 'Política de privacidad';

  @override
  String get aboutTermsOfUse => 'Condiciones de uso';

  @override
  String get aboutLegalConsent =>
      'Al usar CaliDay aceptas la Política de privacidad y las Condiciones de uso.';

  @override
  String get aboutCopyright => '© 2026 pupptmstr';

  @override
  String get whatsNewTitle => 'Novedades';

  @override
  String get whatsNewBadge => 'NUEVO';

  @override
  String whatsNewVersion(String version) {
    return 'Versión $version';
  }

  @override
  String get releaseNotes0820 =>
      'Los ejercicios a un lado ahora se hacen a ambos: tras el primer lado, una cuenta atrás corta te da tiempo para cambiar y luego se cronometra el otro. No hay que tocar nada.\nEsto vale para los estiramientos del flexor de cadera, el 90/90, las inclinaciones de cuello, la paloma, el equilibrio a una pierna, la plancha a un brazo, la plancha lateral y los estiramientos de piernas y costados tras el entrenamiento.\nSkala, el juez de los retos, tiene un dibujo nuevo: ahora sí es un toro.';

  @override
  String get releaseNotes0819 =>
      'Cada rama avanza ahora una vez al día, en cualquier entrenamiento: el de la mañana, el de la noche o tu propia rutina. Dos cursos en un mismo día avanzan los dos.\nTus amigos ya no ven tu etapa en cada rama: el código de amigo lleva tu rango, tus SP y tu racha, y se escanea más fácil. Los amigos con una versión antigua tienen que actualizar para leerlo.';

  @override
  String get releaseNotes0818 =>
      'El widget de la pantalla de inicio habla el idioma de la app: la etiqueta «Hecho» y su descripción en la galería de widgets ya no aparecen siempre en ruso.\nAl cambiar el idioma de la app, el widget y los recordatorios cambian al momento.';

  @override
  String get releaseNotes0817 =>
      'Los números y las palabras ahora concuerdan: «1 serie» en lugar de «1 series».';

  @override
  String get releaseNotes0816 =>
      'La app ya está disponible también en alemán y español.\nEl selector de idioma de la pantalla de bienvenida ahora es un menú.\nLa notificación de racha perdida ahora declina bien el número de días en ruso.';

  @override
  String get releaseNotes0815 =>
      'Una campana en el perfil muestra ahora qué cambió en cada actualización.\nLa pantalla «Acerca de» es más corta: la línea técnica ya no está.';

  @override
  String get releaseNotes0814 =>
      'El botón «Otra vez» muestra cuánto dura aproximadamente un entrenamiento extra.';

  @override
  String get releaseNotes0813 =>
      'El tiempo del botón de entrenamiento ahora se ajusta a tu propio ritmo: tras unos cuantos entrenamientos refleja cuánto te llevan de verdad.';

  @override
  String get releaseNotes0812 =>
      'El botón de entrenamiento muestra cuánto dura aproximadamente el entrenamiento de hoy.\nEl recordatorio de la noche ya no promete «10 minutos».';

  @override
  String get releaseNotes0811 =>
      'El tamaño del entrenamiento sustituye a «5, 10 o 15 minutos»: Corto, Estándar o Completo. Indica cuántas habilidades incluye un entrenamiento, no cuánto dura.';

  @override
  String get releaseNotes0810 =>
      'Los ejercicios por tiempo ahora empiezan solos tras una breve cuenta atrás para prepararte. Toca Pausa si necesitas más tiempo para leer o colocarte.\nLa búsqueda en la biblioteca de ejercicios funciona en ruso y en inglés.\nAlgunos textos que se habían quedado en un solo idioma ya están traducidos.';

  @override
  String get settingsAbout => 'Acerca de';

  @override
  String get settingsSectionHealth => 'SALUD';

  @override
  String get settingsHealthWorkoutsTitle => 'Registrar entrenamientos';

  @override
  String get settingsHealthWorkoutsSubtitle =>
      'Guardar en Apple Health / Health Connect';

  @override
  String get settingsHealthWeightTitle => 'Leer el peso corporal';

  @override
  String get settingsHealthWeightSubtitle =>
      'Para estimar mejor las calorías (por defecto 70 kg)';

  @override
  String get summaryHealthSaved => 'Guardado en Salud ✓';

  @override
  String get friendsTitle => 'Amigos';

  @override
  String get friendsMyQrTitle => 'Mi perfil';

  @override
  String get friendsShareHint =>
      'Muestra este código a un amigo para compartir tu perfil';

  @override
  String get friendsScanQr => 'Escanear código QR';

  @override
  String get friendsSectionNearby => 'CERCA';

  @override
  String get friendsSectionList => 'AMIGOS';

  @override
  String get friendsNearbyEmpty => 'No hay usuarios de CaliDay cerca';

  @override
  String get friendsNearbyScanning => 'Buscando…';

  @override
  String get friendsNearbyBleOff => 'El Bluetooth está apagado';

  @override
  String get friendsNearbyConnect => 'Obtener perfil';

  @override
  String get friendsEmpty =>
      'Aún no tienes amigos. Escanea un código QR para añadir el primero.';

  @override
  String get friendsAdded => '¡Amigo añadido!';

  @override
  String get friendsUpdated => '¡Perfil actualizado!';

  @override
  String get friendsScanError => 'Código QR no válido';

  @override
  String get friendsScanTryAgain => 'Reintentar';

  @override
  String get friendsScanCameraDeniedTitle =>
      'El acceso a la cámara está bloqueado';

  @override
  String get friendsScanCameraDeniedWeb =>
      'Permite la cámara para este sitio (el icono de la cámara o del candado en la barra de direcciones) y pulsa Reintentar. O muestra tu propio código QR a tu amigo.';

  @override
  String get friendsScanCameraDeniedApp =>
      'Permite el acceso a la cámara para CaliDay en los ajustes del dispositivo y pulsa Reintentar.';

  @override
  String get friendsScanCameraUnsupportedTitle => 'No hay cámara disponible';

  @override
  String get friendsScanCameraUnsupportedBody =>
      'Este dispositivo o navegador no tiene una cámara que la app pueda usar. Muestra tu propio código QR a tu amigo.';

  @override
  String get friendsScanCameraFailedTitle => 'No se pudo iniciar la cámara';

  @override
  String get friendsScanCameraFailedBody =>
      'Comprueba que ninguna otra app esté usando la cámara y que tienes conexión (en el navegador el escáner se descarga la primera vez) y vuelve a intentarlo.';

  @override
  String friendsScanConfirmBody(int sp, int streak) {
    String _temp0 = intl.Intl.pluralLogic(
      streak,
      locale: localeName,
      other: '$streak días',
      one: '$streak día',
    );
    return '$sp SP · racha de $_temp0';
  }

  @override
  String get friendsCancel => 'Cancelar';

  @override
  String get friendsAdd => 'Añadir';

  @override
  String friendsDetailLastSynced(String date) {
    return 'Sincronizado: $date';
  }

  @override
  String get friendsDeleteTitle => 'Eliminar amigo';

  @override
  String friendsDeleteBody(String name) {
    return '¿Eliminar a $name de tus amigos?';
  }

  @override
  String get friendsDeleteConfirm => 'Eliminar';

  @override
  String get settingsSectionFriends => 'AMIGOS';

  @override
  String get settingsFriendsNameTitle => 'Nombre visible';

  @override
  String get settingsFriendsNamePlaceholder => 'Escribe tu nombre';

  @override
  String get settingsFriendsDiscoverableTitle => 'Visible por Bluetooth';

  @override
  String get settingsFriendsDiscoverableSubtitle =>
      'Otros usuarios de CaliDay cerca pueden encontrarte';

  @override
  String get profileFriendsTitle => 'Amigos';

  @override
  String get profileFriendsAll => 'Todos los amigos →';

  @override
  String get profileFriendsEmpty => 'Aún no tienes amigos';

  @override
  String profileFriendsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count amigos',
      one: '$count amigo',
    );
    return '$_temp0';
  }

  @override
  String get exerciseFlexS1HipFlexorStretchName =>
      'Estiramiento del flexor de cadera';

  @override
  String get exerciseFlexS1HipFlexorStretchDesc =>
      'Da una zancada y apoya la rodilla de atrás en el suelo. Empuja la cadera hacia delante hasta sentir el estiramiento en la parte delantera de la cadera. Mantén en cada lado.';

  @override
  String get exerciseFlexS1HipFlexorStretchTip =>
      'Espalda recta y cadera hacia delante: siente el estiramiento en la parte delantera de la cadera.';

  @override
  String get exerciseFlexS2WorldsGreatestStretchName =>
      'World\'s Greatest Stretch';

  @override
  String get exerciseFlexS2WorldsGreatestStretchDesc =>
      'Desde una zancada, apoya en el suelo la mano del mismo lado. Gira el tronco y lleva el otro brazo hacia el techo. Encadena los movimientos con fluidez.';

  @override
  String get exerciseFlexS2WorldsGreatestStretchTip =>
      'Pasa despacio por cada posición: es un flujo, no una carrera.';

  @override
  String get exerciseFlexS3Hip9090Name => 'Movilidad de cadera 90/90';

  @override
  String get exerciseFlexS3Hip9090Desc =>
      'Siéntate en el suelo con las dos piernas dobladas a 90°, una delante y otra al lado. Mantén la posición y cambia de lado.';

  @override
  String get exerciseFlexS3Hip9090Tip =>
      'Mantén los dos isquiones en el suelo. Gira desde la cadera, no desde la zona lumbar.';

  @override
  String get exerciseFlexS4ThoracicBridgeName => 'Puente torácico';

  @override
  String get exerciseFlexS4ThoracicBridgeDesc =>
      'Sentado y con las manos detrás, eleva la cadera y gira la parte alta de la columna para abrir el pecho hacia el techo.';

  @override
  String get exerciseFlexS4ThoracicBridgeTip =>
      'El movimiento sale de la parte alta de la espalda: evita doblarte por la zona lumbar.';

  @override
  String get exerciseFlexS5DeepSquatHoldName => 'Sentadilla profunda sostenida';

  @override
  String get exerciseFlexS5DeepSquatHoldDesc =>
      'Pies al ancho de los hombros, puntas ligeramente hacia fuera. Baja del todo y mantén. Usa un marco de puerta como apoyo si lo necesitas.';

  @override
  String get exerciseFlexS5DeepSquatHoldTip =>
      'Al principio apóyate en un marco de puerta o un poste. La meta: talones planos en el suelo.';

  @override
  String get exerciseFlexS6PikeStretchName => 'Estiramiento en pica';

  @override
  String get exerciseFlexS6PikeStretchDesc =>
      'Siéntate en el suelo con las piernas estiradas al frente. Lleva las manos hacia los pies doblándote desde la cadera. Mantén la posición.';

  @override
  String get exerciseFlexS6PikeStretchTip =>
      'Inclínate desde la cadera, no desde la cintura. Mantén las piernas estiradas.';

  @override
  String get exerciseSuppObliqueCrunchName => 'Crunch oblicuo';

  @override
  String get exerciseSuppObliqueCrunchDesc =>
      'Acuéstate boca arriba con las rodillas dobladas. Lleva el codo derecho hacia la rodilla izquierda y luego el izquierdo hacia la derecha. Alterna.';

  @override
  String get exerciseSuppRussianTwistsName => 'Giros rusos';

  @override
  String get exerciseSuppRussianTwistsDesc =>
      'Siéntate con las rodillas algo elevadas y el torso inclinado hacia atrás. Gira el torso a la izquierda y a la derecha: cada giro cuenta como una repetición.';

  @override
  String get exerciseSuppRussianTwistsTip =>
      'Mantén la espalda recta, no te encorves.';

  @override
  String get exerciseSuppSidePlankName => 'Plancha lateral';

  @override
  String get exerciseSuppSidePlankDesc =>
      'Plancha lateral sobre el antebrazo: el cuerpo en línea recta de la cabeza a los pies. Mantén la posición y repite del otro lado.';

  @override
  String get exerciseSuppSidePlankTip =>
      'No dejes caer la cadera: mantén la línea recta.';

  @override
  String get exerciseSuppStandingCalfRaiseName => 'Elevación de talones de pie';

  @override
  String get exerciseSuppStandingCalfRaiseDesc =>
      'De pie y erguido, sube despacio de puntillas durante 2–3 segundos y luego baja. Apóyate en una pared si lo necesitas para el equilibrio.';

  @override
  String get exerciseSuppSingleLegCalfRaiseName =>
      'Elevación de talón a una pierna';

  @override
  String get exerciseSuppSingleLegCalfRaiseDesc =>
      'Apóyate en un pie. Sube despacio de puntillas y vuelve a bajar. Repite con la otra pierna.';

  @override
  String get exerciseSuppSingleLegCalfRaiseTip => 'Ritmo lento: más beneficio.';

  @override
  String get exerciseSuppDeadBugName => 'Dead bug';

  @override
  String get exerciseSuppDeadBugDesc =>
      'Acuéstate boca arriba, con los brazos hacia arriba y las rodillas dobladas a 90°. Baja a la vez el brazo derecho por encima de la cabeza y estira la pierna izquierda, casi hasta el suelo. Vuelve. Alterna.';

  @override
  String get exerciseSuppDeadBugTip =>
      'Mantén la zona lumbar pegada al suelo todo el tiempo.';

  @override
  String get exerciseSuppBirdDogName => 'Bird dog';

  @override
  String get exerciseSuppBirdDogDesc =>
      'A cuatro patas: estira a la vez el brazo derecho hacia delante y la pierna izquierda hacia atrás. Mantén 2 segundos y vuelve. Alterna los lados.';

  @override
  String get exerciseSuppBirdDogTip => 'No gires la pelvis: mantenla nivelada.';

  @override
  String get exerciseSuppNeckIsometricsName => 'Isometría de cuello';

  @override
  String get exerciseSuppNeckIsometricsDesc =>
      'Presiona la palma contra la frente y resiste: el cuello empuja en sentido contrario. Luego contra la nuca y contra cada sien. Mantén 5–10 segundos en cada dirección.';

  @override
  String get exerciseSuppNeckIsometricsTip => 'Presión suave: no fuerces.';

  @override
  String get exerciseSuppWristCirclesName => 'Círculos de muñecas';

  @override
  String get exerciseSuppWristCirclesDesc =>
      'Cierra los puños y gira despacio las muñecas en el sentido de las agujas del reloj y al revés. Fortalece antebrazos y tendones.';

  @override
  String get exerciseWarmupNeckRollsName => 'Giros de cuello';

  @override
  String get exerciseWarmupNeckRollsDesc =>
      'Inclina despacio la cabeza hacia delante, hacia atrás y a cada lado, y luego haz un semicírculo suave de un hombro al otro. Calienta los músculos del cuello.';

  @override
  String get exercisePostureS1PelvicTiltName => 'Basculación pélvica';

  @override
  String get exercisePostureS1PelvicTiltDesc =>
      'Acuéstate boca arriba con las rodillas dobladas. Presiona despacio la zona lumbar contra el suelo activando el abdomen. Mantén 5 segundos y relaja.';

  @override
  String get exercisePostureS1PelvicTiltTip =>
      'No aguantes la respiración: muévete con suavidad.';

  @override
  String get exercisePostureS2DeadBugName => 'Dead bug';

  @override
  String get exercisePostureS2DeadBugDesc =>
      'Acuéstate boca arriba, con los brazos hacia arriba y las rodillas a 90°. Baja despacio un brazo y la pierna contraria sin dejar que se arquee la zona lumbar.';

  @override
  String get exercisePostureS2DeadBugTip =>
      'Muévete despacio: se trata de control, no de velocidad. Mantén la zona lumbar plana todo el tiempo.';

  @override
  String get exercisePostureS3GluteBridgeName => 'Puente de glúteos';

  @override
  String get exercisePostureS3GluteBridgeDesc =>
      'Acuéstate boca arriba, con las rodillas dobladas y los pies planos en el suelo. Sube la cadera apretando los glúteos, mantén un momento y baja.';

  @override
  String get exercisePostureS3GluteBridgeTip =>
      'Aprieta fuerte los glúteos arriba: no empujes con la zona lumbar.';

  @override
  String get exercisePostureS4HipMarchName => 'Marcha de pie';

  @override
  String get exercisePostureS4HipMarchDesc =>
      'De pie y erguido. Sube despacio una rodilla a la altura de la cadera y bájala. Alterna los lados. Mantén el torso recto y quieto.';

  @override
  String get exercisePostureS4HipMarchTip =>
      'Sube cada rodilla a la altura de la cadera sin inclinar el torso: el trabajo lo hace el flexor de cadera, no el impulso.';

  @override
  String get exercisePostureS5KneelingLungeName =>
      'Estiramiento del flexor de cadera de rodillas';

  @override
  String get exercisePostureS5KneelingLungeDesc =>
      'Apoya una rodilla en el suelo con el otro pie delante. Empuja la cadera hacia delante hasta sentir un estiramiento en la parte delantera de la cadera de atrás. Mantén.';

  @override
  String get exercisePostureS5KneelingLungeTip =>
      'Mantén la espalda recta y mete un poco la pelvis para profundizar el estiramiento.';

  @override
  String get exercisePostureS6PigeonPoseName => 'Postura de la paloma';

  @override
  String get exercisePostureS6PigeonPoseDesc =>
      'Desde cuatro patas, lleva la pierna derecha al frente doblada a 90°. Estira la pierna izquierda hacia atrás. Baja la cadera hacia el suelo y mantén la posición.';

  @override
  String get exercisePostureS6PigeonPoseTip =>
      'Respira hondo: la postura abre la cadera poco a poco.';

  @override
  String get exerciseNeckS1NeckTiltName => 'Inclinación de cuello';

  @override
  String get exerciseNeckS1NeckTiltDesc =>
      'Inclina despacio la cabeza hacia el hombro derecho, sin subir el hombro, y mantén el estiramiento suave. Luego el otro lado.';

  @override
  String get exerciseNeckS1NeckTiltTip =>
      'Deja caer el hombro: así el estiramiento es más profundo.';

  @override
  String get exerciseNeckS2ChestOpenerName => 'Apertura de pecho';

  @override
  String get exerciseNeckS2ChestOpenerDesc =>
      'De pie y erguido, entrelaza las manos detrás de la espalda. Junta los omóplatos y sube un poco los brazos mientras abres el pecho.';

  @override
  String get exerciseNeckS2ChestOpenerTip =>
      'Céntrate en juntar los omóplatos: no arquees la zona lumbar.';

  @override
  String get exerciseNeckS3ShoulderRollName => 'Círculos de hombros';

  @override
  String get exerciseNeckS3ShoulderRollDesc =>
      'Haz círculos grandes y lentos con los hombros: 5 veces hacia delante y luego 5 hacia atrás. Mantén el cuello relajado todo el tiempo.';

  @override
  String get exerciseNeckS3ShoulderRollTip =>
      'Haz los círculos lo más grandes posible: exagera el movimiento.';

  @override
  String get exerciseNeckS4WallAngelName => 'Ángeles en la pared';

  @override
  String get exerciseNeckS4WallAngelDesc =>
      'Apoya la espalda, la cabeza y los brazos en una pared. Desliza los brazos por encima de la cabeza sin perder el contacto con la pared. Baja despacio.';

  @override
  String get exerciseNeckS4WallAngelTip =>
      'Mantén la zona lumbar pegada a la pared todo el tiempo: es más difícil de lo que parece.';

  @override
  String get exerciseNeckS5DoorwayStretchName =>
      'Estiramiento de pecho en la puerta';

  @override
  String get exerciseNeckS5DoorwayStretchDesc =>
      'Ponte en el hueco de una puerta. Apoya los dos antebrazos en el marco a la altura de los hombros. Inclínate con suavidad hacia delante hasta sentir el estiramiento en el pecho y los hombros. Mantén.';

  @override
  String get exerciseNeckS5DoorwayStretchTip =>
      'Mantén el core activo y no arquees la zona lumbar al inclinarte.';

  @override
  String get tooltipStreakTitle => 'Racha actual';

  @override
  String get tooltipStreakBody =>
      'El número de días seguidos que has entrenado. Si te saltas un día sin protector de racha, vuelve a cero. Mantén vivo el fuego: ¡Goro te está mirando!';

  @override
  String get tooltipLongestStreakTitle => 'Récord personal';

  @override
  String get tooltipLongestStreakBody =>
      'Tu racha de entrenamiento más larga de todos los tiempos. Una vez marcado, este récord se queda para siempre, aunque tu racha actual vuelva a cero.';

  @override
  String get tooltipTotalWorkoutsTitle => 'Entrenamientos totales';

  @override
  String get tooltipTotalWorkoutsBody =>
      'El número total de entrenamientos que has completado desde que empezaste. Todos cuentan, también los extra.';

  @override
  String get tooltipFreezesTitle => 'Protectores de racha';

  @override
  String get tooltipFreezesBody =>
      'Los protectores salvan tu racha cuando te saltas un día. Los consigues automáticamente al entrenar con constancia. Puedes tener hasta 3 a la vez.';

  @override
  String get tooltipRankTitle => 'Rango y puntos de fuerza';

  @override
  String get exerciseLibraryTitle => 'Todos los ejercicios';

  @override
  String get exerciseLibrarySearchHint => 'Buscar ejercicios...';

  @override
  String get exerciseLibraryCatalogButton => 'Catálogo de ejercicios';

  @override
  String get exerciseLibraryEmpty => 'No se encontraron ejercicios';

  @override
  String get exerciseLibraryReset => 'Restablecer';

  @override
  String get exerciseTagFilterAll => 'Todos';

  @override
  String exerciseLibraryCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ejercicios',
      one: '$count ejercicio',
    );
    return '$_temp0';
  }

  @override
  String get exerciseDetailTipLabel => 'Técnica';

  @override
  String exerciseDetailStageLabel(int stage) {
    return 'Etapa $stage';
  }

  @override
  String get exerciseTagHipFlexor => 'Flexores de cadera';

  @override
  String get exerciseTagGlutes => 'Glúteos';

  @override
  String get exerciseTagCore => 'Core';

  @override
  String get exerciseTagChest => 'Pecho';

  @override
  String get exerciseTagBack => 'Espalda';

  @override
  String get exerciseTagShoulders => 'Hombros';

  @override
  String get exerciseTagLegs => 'Piernas';

  @override
  String get exerciseTagNeck => 'Cuello';

  @override
  String get exerciseTagStretch => 'Estiramiento';

  @override
  String get exerciseTagMobility => 'Movilidad';

  @override
  String get exerciseTagStrength => 'Fuerza';

  @override
  String get exerciseTagEndurance => 'Resistencia';

  @override
  String get exerciseTagSittingRecovery => 'Para la oficina';

  @override
  String get exerciseTagFloorOnly => 'Sin material';

  @override
  String get exerciseTagRequiresBar => 'Requiere barra';

  @override
  String get exerciseTagPostureFocus => 'Postura';

  @override
  String get exerciseTagBeginner => 'Principiante';

  @override
  String get exerciseTagWarmup => 'Calentamiento';

  @override
  String get exerciseTagCooldown => 'Vuelta a la calma';

  @override
  String get customWorkoutNoWarmupTitle =>
      '¿Añadir calentamiento y vuelta a la calma?';

  @override
  String get customWorkoutNoWarmupBody =>
      'Tu rutina no tiene calentamiento ni vuelta a la calma. ¿Los añadimos automáticamente?';

  @override
  String get customWorkoutAdd => 'Añadir';

  @override
  String get customWorkoutSkip => 'Omitir';

  @override
  String get customWorkoutButtonLabel => 'Entreno personalizado';

  @override
  String get customWorkoutMyRoutines => 'Mis rutinas';

  @override
  String get customWorkoutNewRoutine => 'Nueva rutina';

  @override
  String get customWorkoutQuickRoutine => 'Rutina rápida';

  @override
  String get customWorkoutQuickRoutineDesc =>
      'Elige una zona y te seleccionamos los ejercicios';

  @override
  String get customWorkoutEmpty => 'Aún no hay rutinas guardadas';

  @override
  String get customWorkoutNameHint => 'Nombre de la rutina';

  @override
  String get customWorkoutNameRequired =>
      'Escribe un nombre para guardar la rutina';

  @override
  String get customWorkoutSave => 'Guardar rutina';

  @override
  String get customWorkoutStartNow => 'Empezar ahora';

  @override
  String get customWorkoutDelete => 'Eliminar';

  @override
  String get customWorkoutEdit => 'Editar';

  @override
  String get customWorkoutBuilderTitle => 'Crear rutina';

  @override
  String get customWorkoutBuilderDesc =>
      'Elige ejercicios y arma tu propia secuencia';

  @override
  String get customWorkoutPickFocus => '¿Qué quieres entrenar?';

  @override
  String customWorkoutExerciseCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ejercicios',
      one: '$count ejercicio',
    );
    return '$_temp0';
  }

  @override
  String rankDecayWarning(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days días',
      one: '$days día',
    );
    return 'Llevas $_temp0 sin entrenar: tu rango ha bajado. ¡Vuelve a ello!';
  }

  @override
  String get summaryRankRestoredTitle => '¡Rango recuperado!';

  @override
  String get summaryRankRestoredBody =>
      'Sigue entrenando: ¡tu rango está totalmente recuperado!';

  @override
  String get notificationMorningTitle => '¡Hora de entrenar! 💪';

  @override
  String get notificationMorningBody =>
      'Tu entrenamiento diario te espera. ¡Mantén viva la racha!';

  @override
  String get notificationEveningTitle => '¡Aún hay tiempo! 🏃';

  @override
  String get notificationEveningBody =>
      'Hoy todavía no has entrenado. Incluso un entrenamiento corto cuenta.';

  @override
  String get notificationStreakTitle => '¡Racha en peligro! 🔥';

  @override
  String get notificationStreakBody =>
      'Entrena antes de medianoche o tu racha terminará.';

  @override
  String get notificationStreakLostTitle => 'Racha perdida 😔';

  @override
  String notificationStreakLostBody(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days días',
      one: '$days día',
    );
    return 'Tu racha de $_temp0 se ha perdido. Empieza una nueva: ¡el primer paso siempre es el más difícil!';
  }

  @override
  String get notificationRankAtRiskTitle => '¡Rango en peligro! ⚠️';

  @override
  String get notificationRankAtRiskBody =>
      '14 días sin entrenar: tu rango empezará a bajar pronto. ¡Vuelve!';

  @override
  String get widgetDoneLabel => 'Hecho';
}
