import '../models/enums.dart';

/// Maps exercise IDs to their semantic [ExerciseTag] lists.
///
/// Kept separate from [ExerciseCatalog] so tag metadata can be updated
/// without touching exercise progression data.
class ExerciseTagsCatalog {
  ExerciseTagsCatalog._();

  static const Map<String, List<ExerciseTag>> _tags = {
    // ── Push ──────────────────────────────────────────────────────────────────
    'push_s1_wall_pushup': [
      ExerciseTag.chest, ExerciseTag.shoulders, ExerciseTag.strength, ExerciseTag.beginner,
    ],
    'push_s2_knee_pushup': [
      ExerciseTag.chest, ExerciseTag.shoulders, ExerciseTag.strength,
      ExerciseTag.beginner, ExerciseTag.floorOnly,
    ],
    'push_s3_full_pushup': [
      ExerciseTag.chest, ExerciseTag.shoulders, ExerciseTag.strength, ExerciseTag.floorOnly,
    ],
    'push_s4_diamond_pushup': [
      ExerciseTag.chest, ExerciseTag.shoulders, ExerciseTag.strength, ExerciseTag.floorOnly,
    ],
    'push_s5_wide_pushup': [
      ExerciseTag.chest, ExerciseTag.shoulders, ExerciseTag.strength, ExerciseTag.floorOnly,
    ],
    'push_s6_archer_pushup': [
      ExerciseTag.chest, ExerciseTag.shoulders, ExerciseTag.strength, ExerciseTag.floorOnly,
    ],
    'push_s7_handstand_pushup': [
      ExerciseTag.chest, ExerciseTag.shoulders, ExerciseTag.strength,
    ],

    // ── Core ──────────────────────────────────────────────────────────────────
    'core_s1_crunches': [
      ExerciseTag.core, ExerciseTag.strength, ExerciseTag.floorOnly,
    ],
    'core_s2_plank': [
      ExerciseTag.core, ExerciseTag.strength, ExerciseTag.endurance, ExerciseTag.floorOnly,
    ],
    'core_s3_lying_leg_raise': [
      ExerciseTag.core, ExerciseTag.legs, ExerciseTag.strength, ExerciseTag.floorOnly,
    ],
    'core_s4_hanging_leg_raise': [
      ExerciseTag.core, ExerciseTag.legs, ExerciseTag.strength, ExerciseTag.requiresBar,
    ],
    'core_s4_flutter_kicks': [
      ExerciseTag.core, ExerciseTag.legs, ExerciseTag.strength,
      ExerciseTag.endurance, ExerciseTag.floorOnly,
    ],
    'core_s5_l_sit': [
      ExerciseTag.core, ExerciseTag.shoulders, ExerciseTag.strength, ExerciseTag.floorOnly,
    ],
    'core_s6_dragon_flag': [
      ExerciseTag.core, ExerciseTag.legs, ExerciseTag.strength, ExerciseTag.floorOnly,
    ],

    // ── Pull ──────────────────────────────────────────────────────────────────
    'pull_s1_australian': [
      ExerciseTag.back, ExerciseTag.shoulders, ExerciseTag.strength, ExerciseTag.requiresBar,
    ],
    'pull_s2_negative': [
      ExerciseTag.back, ExerciseTag.shoulders, ExerciseTag.strength, ExerciseTag.requiresBar,
    ],
    'pull_s3_pullup': [
      ExerciseTag.back, ExerciseTag.shoulders, ExerciseTag.strength, ExerciseTag.requiresBar,
    ],
    'pull_s4_close_grip': [
      ExerciseTag.back, ExerciseTag.shoulders, ExerciseTag.strength, ExerciseTag.requiresBar,
    ],
    'pull_s5_archer': [
      ExerciseTag.back, ExerciseTag.shoulders, ExerciseTag.strength, ExerciseTag.requiresBar,
    ],
    'pull_s6_one_arm': [
      ExerciseTag.back, ExerciseTag.shoulders, ExerciseTag.strength, ExerciseTag.requiresBar,
    ],

    // ── Legs ──────────────────────────────────────────────────────────────────
    'legs_s1_squat': [
      ExerciseTag.legs, ExerciseTag.glutes, ExerciseTag.strength, ExerciseTag.beginner,
    ],
    'legs_s2_lunge': [
      ExerciseTag.legs, ExerciseTag.glutes, ExerciseTag.hipFlexor, ExerciseTag.strength,
    ],
    'legs_s3_bulgarian': [
      ExerciseTag.legs, ExerciseTag.glutes, ExerciseTag.strength,
    ],
    'legs_s4_assisted_pistol': [
      ExerciseTag.legs, ExerciseTag.glutes, ExerciseTag.strength,
    ],
    'legs_s5_pistol': [
      ExerciseTag.legs, ExerciseTag.glutes, ExerciseTag.strength,
    ],

    // ── Balance ───────────────────────────────────────────────────────────────
    'bal_s1_one_leg_stand': [
      ExerciseTag.legs, ExerciseTag.strength, ExerciseTag.beginner,
    ],
    'bal_s2_one_arm_plank': [
      ExerciseTag.core, ExerciseTag.shoulders, ExerciseTag.strength, ExerciseTag.floorOnly,
    ],
    'bal_s3_crow_prep': [
      ExerciseTag.core, ExerciseTag.shoulders, ExerciseTag.strength, ExerciseTag.floorOnly,
    ],
    'bal_s4_crow_pose': [
      ExerciseTag.core, ExerciseTag.shoulders, ExerciseTag.strength, ExerciseTag.floorOnly,
    ],
    'bal_s5_wall_hs': [
      ExerciseTag.shoulders, ExerciseTag.strength,
    ],
    'bal_s6_free_hs': [
      ExerciseTag.shoulders, ExerciseTag.strength,
    ],

    // ── Flex ──────────────────────────────────────────────────────────────────
    'flex_s1_hip_flexor_stretch': [
      ExerciseTag.hipFlexor, ExerciseTag.stretch, ExerciseTag.mobility, ExerciseTag.floorOnly,
    ],
    'flex_s2_worlds_greatest_stretch': [
      ExerciseTag.hipFlexor, ExerciseTag.back, ExerciseTag.stretch,
      ExerciseTag.mobility, ExerciseTag.floorOnly,
    ],
    'flex_s3_hip_9090': [
      ExerciseTag.hipFlexor, ExerciseTag.glutes, ExerciseTag.stretch,
      ExerciseTag.mobility, ExerciseTag.floorOnly,
    ],
    'flex_s4_thoracic_bridge': [
      ExerciseTag.back, ExerciseTag.chest, ExerciseTag.stretch,
      ExerciseTag.mobility, ExerciseTag.floorOnly,
    ],
    'flex_s5_deep_squat_hold': [
      ExerciseTag.legs, ExerciseTag.glutes, ExerciseTag.hipFlexor,
      ExerciseTag.stretch, ExerciseTag.mobility,
    ],
    'flex_s6_pike_stretch': [
      ExerciseTag.legs, ExerciseTag.stretch, ExerciseTag.mobility, ExerciseTag.floorOnly,
    ],

    // ── Posture ───────────────────────────────────────────────────────────────
    'posture_s1_pelvic_tilt': [
      ExerciseTag.core, ExerciseTag.postureFocus, ExerciseTag.beginner,
      ExerciseTag.floorOnly, ExerciseTag.sittingRecovery,
    ],
    'posture_s2_dead_bug': [
      ExerciseTag.core, ExerciseTag.postureFocus, ExerciseTag.floorOnly,
    ],
    'posture_s3_glute_bridge': [
      ExerciseTag.glutes, ExerciseTag.postureFocus, ExerciseTag.floorOnly,
    ],
    'posture_s4_hip_march': [
      ExerciseTag.hipFlexor, ExerciseTag.legs, ExerciseTag.postureFocus,
      ExerciseTag.sittingRecovery,
    ],
    'posture_s5_kneeling_lunge': [
      ExerciseTag.hipFlexor, ExerciseTag.stretch, ExerciseTag.postureFocus, ExerciseTag.floorOnly,
    ],
    'posture_s6_pigeon_pose': [
      ExerciseTag.glutes, ExerciseTag.hipFlexor, ExerciseTag.stretch,
      ExerciseTag.postureFocus, ExerciseTag.floorOnly,
    ],

    // ── Neck ──────────────────────────────────────────────────────────────────
    'neck_s1_neck_tilt': [
      ExerciseTag.neck, ExerciseTag.stretch, ExerciseTag.sittingRecovery,
      ExerciseTag.postureFocus,
    ],
    'neck_s2_chest_opener': [
      ExerciseTag.neck, ExerciseTag.chest, ExerciseTag.shoulders, ExerciseTag.stretch,
      ExerciseTag.postureFocus, ExerciseTag.sittingRecovery,
    ],
    'neck_s3_shoulder_roll': [
      ExerciseTag.neck, ExerciseTag.shoulders, ExerciseTag.mobility,
      ExerciseTag.sittingRecovery, ExerciseTag.postureFocus,
    ],
    'neck_s4_wall_angel': [
      ExerciseTag.neck, ExerciseTag.shoulders, ExerciseTag.back, ExerciseTag.postureFocus,
    ],
    'neck_s5_doorway_stretch': [
      ExerciseTag.chest, ExerciseTag.shoulders, ExerciseTag.stretch,
      ExerciseTag.postureFocus, ExerciseTag.sittingRecovery,
    ],

    // ── Evening Stretch ───────────────────────────────────────────────────────
    'evening_back_s1_cat_cow': [
      ExerciseTag.back, ExerciseTag.mobility, ExerciseTag.stretch, ExerciseTag.floorOnly, ExerciseTag.beginner,
    ],
    'evening_back_s2_childs_pose': [
      ExerciseTag.back, ExerciseTag.stretch, ExerciseTag.floorOnly, ExerciseTag.beginner,
    ],
    'evening_back_s3_supine_twist': [
      ExerciseTag.back, ExerciseTag.glutes, ExerciseTag.stretch, ExerciseTag.floorOnly,
    ],
    'evening_back_s4_sphinx': [
      ExerciseTag.back, ExerciseTag.stretch, ExerciseTag.floorOnly, ExerciseTag.postureFocus,
    ],
    'evening_back_s5_cobra': [
      ExerciseTag.back, ExerciseTag.chest, ExerciseTag.stretch, ExerciseTag.floorOnly,
    ],
    'evening_hips_s1_knees_to_chest': [
      ExerciseTag.back, ExerciseTag.glutes, ExerciseTag.stretch, ExerciseTag.floorOnly, ExerciseTag.beginner,
    ],
    'evening_hips_s2_figure_four': [
      ExerciseTag.glutes, ExerciseTag.hipFlexor, ExerciseTag.stretch, ExerciseTag.floorOnly,
    ],
    'evening_hips_s3_happy_baby': [
      ExerciseTag.glutes, ExerciseTag.hipFlexor, ExerciseTag.stretch, ExerciseTag.floorOnly,
    ],
    'evening_hips_s4_butterfly': [
      ExerciseTag.hipFlexor, ExerciseTag.legs, ExerciseTag.stretch, ExerciseTag.mobility, ExerciseTag.floorOnly,
    ],
    'evening_hips_s5_frog': [
      ExerciseTag.hipFlexor, ExerciseTag.legs, ExerciseTag.stretch, ExerciseTag.floorOnly,
    ],
    'evening_folds_s1_legs_up_wall': [
      ExerciseTag.legs, ExerciseTag.stretch, ExerciseTag.floorOnly, ExerciseTag.beginner,
    ],
    'evening_folds_s2_towel_hamstring': [
      ExerciseTag.legs, ExerciseTag.stretch, ExerciseTag.floorOnly,
    ],
    'evening_folds_s3_head_to_knee': [
      ExerciseTag.legs, ExerciseTag.back, ExerciseTag.stretch, ExerciseTag.floorOnly,
    ],
    'evening_folds_s4_straddle_fold': [
      ExerciseTag.legs, ExerciseTag.back, ExerciseTag.stretch, ExerciseTag.mobility, ExerciseTag.floorOnly,
    ],
    'evening_shoulders_s1_self_hug': [
      ExerciseTag.shoulders, ExerciseTag.back, ExerciseTag.stretch, ExerciseTag.beginner, ExerciseTag.sittingRecovery,
    ],
    'evening_shoulders_s2_triceps_stretch': [
      ExerciseTag.shoulders, ExerciseTag.stretch, ExerciseTag.sittingRecovery,
    ],
    'evening_shoulders_s3_eagle_arms': [
      ExerciseTag.shoulders, ExerciseTag.back, ExerciseTag.stretch, ExerciseTag.sittingRecovery,
    ],
    'evening_shoulders_s4_puppy_pose': [
      ExerciseTag.shoulders, ExerciseTag.chest, ExerciseTag.back, ExerciseTag.stretch, ExerciseTag.floorOnly,
    ],
    'evening_shoulders_s5_cow_face_arms': [
      ExerciseTag.shoulders, ExerciseTag.chest, ExerciseTag.stretch, ExerciseTag.mobility,
    ],
    'cooldown_lying_relaxation': [
      ExerciseTag.cooldown, ExerciseTag.floorOnly, ExerciseTag.beginner,
    ],

    // ── Morning Routine ───────────────────────────────────────────────────────
    'morning_spine_s1_side_bend': [
      ExerciseTag.back, ExerciseTag.core, ExerciseTag.mobility, ExerciseTag.beginner,
    ],
    'morning_spine_s2_torso_twist': [
      ExerciseTag.back, ExerciseTag.core, ExerciseTag.mobility,
    ],
    'morning_spine_s3_good_morning': [
      ExerciseTag.back, ExerciseTag.glutes, ExerciseTag.mobility, ExerciseTag.strength,
    ],
    'morning_spine_s4_roll_down': [
      ExerciseTag.back, ExerciseTag.stretch, ExerciseTag.mobility,
    ],
    'morning_spine_s5_windmill': [
      ExerciseTag.back, ExerciseTag.core, ExerciseTag.stretch, ExerciseTag.mobility,
    ],
    'morning_joints_s1_knee_circles': [
      ExerciseTag.legs, ExerciseTag.mobility, ExerciseTag.beginner,
    ],
    'morning_joints_s2_open_the_gate': [
      ExerciseTag.hipFlexor, ExerciseTag.glutes, ExerciseTag.mobility,
    ],
    'morning_joints_s3_knee_hug': [
      ExerciseTag.glutes, ExerciseTag.legs, ExerciseTag.mobility,
    ],
    'morning_joints_s4_side_lunge': [
      ExerciseTag.legs, ExerciseTag.glutes, ExerciseTag.mobility, ExerciseTag.strength,
    ],
    'morning_joints_s5_cossack_squat': [
      ExerciseTag.legs, ExerciseTag.glutes, ExerciseTag.stretch, ExerciseTag.mobility, ExerciseTag.strength,
    ],
    'morning_arms_s1_arm_swings': [
      ExerciseTag.shoulders, ExerciseTag.chest, ExerciseTag.mobility, ExerciseTag.beginner,
    ],
    'morning_arms_s2_y_raises': [
      ExerciseTag.shoulders, ExerciseTag.back, ExerciseTag.strength, ExerciseTag.postureFocus,
    ],
    'morning_arms_s3_cactus_arms': [
      ExerciseTag.shoulders, ExerciseTag.chest, ExerciseTag.mobility, ExerciseTag.postureFocus,
    ],
    'morning_arms_s4_inchworm': [
      ExerciseTag.shoulders, ExerciseTag.core, ExerciseTag.stretch, ExerciseTag.strength,
    ],
    'morning_arms_s5_plank_to_dog': [
      ExerciseTag.shoulders, ExerciseTag.core, ExerciseTag.stretch, ExerciseTag.strength,
    ],
    'morning_energy_s1_step_jacks': [
      ExerciseTag.legs, ExerciseTag.shoulders, ExerciseTag.endurance, ExerciseTag.beginner,
    ],
    'morning_energy_s2_butt_kicks': [
      ExerciseTag.legs, ExerciseTag.endurance,
    ],
    'morning_energy_s3_cross_crunch': [
      ExerciseTag.core, ExerciseTag.endurance,
    ],
    'morning_energy_s4_speed_skater': [
      ExerciseTag.legs, ExerciseTag.glutes, ExerciseTag.endurance,
    ],
    'morning_energy_s5_mountain_climbers': [
      ExerciseTag.core, ExerciseTag.shoulders, ExerciseTag.endurance, ExerciseTag.strength,
    ],
    'warmup_morning_stretch_up': [
      ExerciseTag.warmup, ExerciseTag.mobility, ExerciseTag.beginner,
    ],
    'cooldown_shake_out': [
      ExerciseTag.cooldown, ExerciseTag.mobility, ExerciseTag.beginner,
    ],

    // ── Warmups ───────────────────────────────────────────────────────────────
    'warmup_arm_rotations': [
      ExerciseTag.warmup, ExerciseTag.shoulders, ExerciseTag.mobility,
    ],
    'warmup_dead_hang': [
      ExerciseTag.warmup, ExerciseTag.back, ExerciseTag.requiresBar,
    ],
    'warmup_jumping_jacks': [
      ExerciseTag.warmup, ExerciseTag.endurance, ExerciseTag.floorOnly,
    ],
    'warmup_leg_swings': [
      ExerciseTag.warmup, ExerciseTag.legs, ExerciseTag.mobility, ExerciseTag.floorOnly,
    ],
    'warmup_hip_circles': [
      ExerciseTag.warmup, ExerciseTag.hipFlexor, ExerciseTag.mobility, ExerciseTag.floorOnly,
    ],
    'warmup_wrist_circles': [
      ExerciseTag.warmup, ExerciseTag.mobility, ExerciseTag.floorOnly,
    ],
    'warmup_neck_rolls': [
      ExerciseTag.warmup, ExerciseTag.neck, ExerciseTag.mobility,
      ExerciseTag.sittingRecovery, ExerciseTag.floorOnly,
    ],

    // ── Cooldowns ─────────────────────────────────────────────────────────────
    'cooldown_shoulder_stretch': [
      ExerciseTag.cooldown, ExerciseTag.shoulders, ExerciseTag.stretch, ExerciseTag.floorOnly,
    ],
    'cooldown_lat_stretch': [
      ExerciseTag.cooldown, ExerciseTag.back, ExerciseTag.stretch, ExerciseTag.floorOnly,
    ],
    'cooldown_cat_cow': [
      ExerciseTag.cooldown, ExerciseTag.back, ExerciseTag.mobility,
      ExerciseTag.stretch, ExerciseTag.floorOnly,
    ],
    'cooldown_quad_stretch': [
      ExerciseTag.cooldown, ExerciseTag.legs, ExerciseTag.stretch, ExerciseTag.floorOnly,
    ],
    'cooldown_hip_flexor': [
      ExerciseTag.cooldown, ExerciseTag.hipFlexor, ExerciseTag.stretch, ExerciseTag.floorOnly,
    ],
    'cooldown_downward_dog': [
      ExerciseTag.cooldown, ExerciseTag.stretch, ExerciseTag.mobility,
      ExerciseTag.back, ExerciseTag.floorOnly,
    ],

    // ── Supplementary ─────────────────────────────────────────────────────────
    'supp_oblique_crunch': [
      ExerciseTag.core, ExerciseTag.strength, ExerciseTag.floorOnly,
    ],
    'supp_russian_twists': [
      ExerciseTag.core, ExerciseTag.strength, ExerciseTag.floorOnly,
    ],
    'supp_side_plank': [
      ExerciseTag.core, ExerciseTag.endurance, ExerciseTag.floorOnly,
    ],
    'supp_standing_calf_raise': [
      ExerciseTag.legs, ExerciseTag.strength, ExerciseTag.floorOnly,
    ],
    'supp_single_leg_calf_raise': [
      ExerciseTag.legs, ExerciseTag.strength, ExerciseTag.floorOnly,
    ],
    'supp_dead_bug': [
      ExerciseTag.core, ExerciseTag.strength, ExerciseTag.floorOnly,
    ],
    'supp_bird_dog': [
      ExerciseTag.core, ExerciseTag.strength, ExerciseTag.floorOnly,
    ],
    'supp_neck_isometrics': [
      ExerciseTag.neck, ExerciseTag.postureFocus, ExerciseTag.floorOnly,
    ],
    'supp_wrist_circles': [
      ExerciseTag.warmup, ExerciseTag.mobility, ExerciseTag.floorOnly,
    ],
  };

  /// Returns tags for [exerciseId], or an empty list if not found.
  static List<ExerciseTag> forId(String exerciseId) =>
      _tags[exerciseId] ?? const [];
}