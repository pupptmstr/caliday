import 'package:caliday/l10n/app_localizations.dart';

/// Provides localised display strings for exercises looked up by their ID.
///
/// Falls back to the raw [id] string if the exercise is unknown — safe for
/// exercises added in future versions before their translations land.
class ExerciseL10n {
  ExerciseL10n._();

  static String name(AppLocalizations l10n, String id) => switch (id) {
        'push_s1_wall_pushup' => l10n.exercisePushS1WallPushupName,
        'push_s2_knee_pushup' => l10n.exercisePushS2KneePushupName,
        'push_s3_full_pushup' => l10n.exercisePushS3FullPushupName,
        'push_s4_diamond_pushup' => l10n.exercisePushS4DiamondPushupName,
        'push_s5_archer_pushup' => l10n.exercisePushS5ArcherPushupName,
        'push_s6_one_arm_pushup' => l10n.exercisePushS6OneArmPushupName,
        'push_s7_handstand_pushup' => l10n.exercisePushS7HandstandPushupName,
        'core_s1_crunches' => l10n.exerciseCoreS1CrunchesName,
        'core_s2_plank' => l10n.exerciseCoreS2PlankName,
        'core_s3_lying_leg_raise' => l10n.exerciseCoreS3LyingLegRaiseName,
        'core_s4_hanging_leg_raise' => l10n.exerciseCoreS4HangingLegRaiseName,
        'core_s5_l_sit' => l10n.exerciseCoreS5LSitName,
        'core_s6_dragon_flag' => l10n.exerciseCoreS6DragonFlagName,
        'warmup_arm_rotations' => l10n.exerciseWarmupArmRotationsName,
        'warmup_jumping_jacks' => l10n.exerciseWarmupJumpingJacksName,
        'cooldown_shoulder_stretch' => l10n.exerciseCooldownShoulderStretchName,
        'cooldown_cat_cow' => l10n.exerciseCooldownCatCowName,
        _ => id,
      };

  static String description(AppLocalizations l10n, String id) => switch (id) {
        'push_s1_wall_pushup' => l10n.exercisePushS1WallPushupDesc,
        'push_s2_knee_pushup' => l10n.exercisePushS2KneePushupDesc,
        'push_s3_full_pushup' => l10n.exercisePushS3FullPushupDesc,
        'push_s4_diamond_pushup' => l10n.exercisePushS4DiamondPushupDesc,
        'push_s5_archer_pushup' => l10n.exercisePushS5ArcherPushupDesc,
        'push_s6_one_arm_pushup' => l10n.exercisePushS6OneArmPushupDesc,
        'push_s7_handstand_pushup' => l10n.exercisePushS7HandstandPushupDesc,
        'core_s1_crunches' => l10n.exerciseCoreS1CrunchesDesc,
        'core_s2_plank' => l10n.exerciseCoreS2PlankDesc,
        'core_s3_lying_leg_raise' => l10n.exerciseCoreS3LyingLegRaiseDesc,
        'core_s4_hanging_leg_raise' => l10n.exerciseCoreS4HangingLegRaiseDesc,
        'core_s5_l_sit' => l10n.exerciseCoreS5LSitDesc,
        'core_s6_dragon_flag' => l10n.exerciseCoreS6DragonFlagDesc,
        'warmup_arm_rotations' => l10n.exerciseWarmupArmRotationsDesc,
        'warmup_jumping_jacks' => l10n.exerciseWarmupJumpingJacksDesc,
        'cooldown_shoulder_stretch' => l10n.exerciseCooldownShoulderStretchDesc,
        'cooldown_cat_cow' => l10n.exerciseCooldownCatCowDesc,
        _ => id,
      };

  static String? tip(AppLocalizations l10n, String id) => switch (id) {
        'push_s1_wall_pushup' => l10n.exercisePushS1WallPushupTip,
        'push_s2_knee_pushup' => l10n.exercisePushS2KneePushupTip,
        'push_s3_full_pushup' => l10n.exercisePushS3FullPushupTip,
        'push_s4_diamond_pushup' => l10n.exercisePushS4DiamondPushupTip,
        'push_s5_archer_pushup' => l10n.exercisePushS5ArcherPushupTip,
        'push_s6_one_arm_pushup' => l10n.exercisePushS6OneArmPushupTip,
        'push_s7_handstand_pushup' => l10n.exercisePushS7HandstandPushupTip,
        'core_s1_crunches' => l10n.exerciseCoreS1CrunchesTip,
        'core_s2_plank' => l10n.exerciseCoreS2PlankTip,
        'core_s3_lying_leg_raise' => l10n.exerciseCoreS3LyingLegRaiseTip,
        'core_s4_hanging_leg_raise' => l10n.exerciseCoreS4HangingLegRaiseTip,
        'core_s5_l_sit' => l10n.exerciseCoreS5LSitTip,
        'core_s6_dragon_flag' => l10n.exerciseCoreS6DragonFlagTip,
        _ => null,
      };
}
