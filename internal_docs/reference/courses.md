# Courses, branches and the exercise catalog

> Part of the project notes — the index is [internal_docs/README.md](../README.md).

## Set (Set / Workout)
A short session: 3–6 exercises, 5–15 minutes. Types: `Daily`, `Skill`, `Challenge`.

## Courses
TreniDay supports multiple **courses** (like Duolingo). Each course has its own branch set and progression:
- `CourseId.calisthenics` → push, pull, core, legs, balance, flex
- `CourseId.healthyBody` → posture, neck, flex
- `CourseId.eveningStretch` → eveningBack, eveningHips, eveningFolds, eveningShoulders (0.8.20; a bonus workout of this course adds **no** supplementary exercises — `CourseCatalog.addsSupplementary`)
- `CourseId.morningRoutine` → morningSpine, morningJoints, morningArms, morningEnergy (0.9.0; every pose standing, no jumps; the bonus workout keeps the supplementary block)
- `CourseId.yoga` → yogaStanding, yogaOneLeg, yogaBackbends, yogaFlow, **balance** (0.9.1; Balance is the Calisthenics branch itself, one progress for both — courses may share exercises and branches, owner 2026-10-08)
- **Outside every course** (0.9.5, owner's 3rd big feature: "many more exercises"): strongBack, glutes, armsShoulders, cardio — `CourseCatalog.otherBranches` (the rest is `courseBranches`). They are trained through an own course: the course builder lists them first under "Branches outside the courses"; the exercise library shows their exercises like any other. `CourseCatalog.courseOf` is null for them, so Goro presents their achievements (as the app's own); `all_complete` counts only `courseBranches` (owner, 2026-10-11: these branches are optional). Not in the onboarding (their progress starts at stage 1 on first use)

**Own courses (0.9.3, the course builder; owner's plan, 3rd big feature).** The user puts a course together in the Courses tab ("+" → "Create your own course"): a name, a host (one of the five; the art is that course's, `CustomCourse.hostIndex`) and branches — built-in ones, whose progress stays shared with their courses, and **own branches**: catalog exercises (`OwnBranch.pickable`: the library, warm-ups, cool-downs, the supplementary pool) in the user's order, each a stage, the amounts and the challenge norms derived by `CustomStages` (§ CustomStages). `CourseId` and `BranchId` are Hive enums and cannot hold them, so the app runs on runtime types beside them: `Branch` (`BuiltInBranch(BranchId)` | `OwnBranch(CustomBranch)`, `domain/models/branch.dart`) and `Course` (`BuiltInCourse(CourseId)` | `OwnCourse(CustomCourse, own branches)`), both equal by `key` — a built-in one's enum name, an own one's `custom_<id>` (`CustomBranch.keyFor`; no `BranchId` name starts with `custom_`). The generator, the progression, the Courses tab, the Branch Journey and the challenge take a `Branch`; Home, Profile and the summary show `Course.host`; `Course.builtIn` is null for an own course (achievement hosts follow the built-in courses). An own course: `addsSupplementary` true, branches needing the bar are left out without one (`branchesFor(hasPullUpBar:)`, like built-in ones), a deleted own branch drops out of it. Own branches have no achievements of their own (`AchievementService.checkAfterOwnStageAdvance`: only `first_challenge`), and are not in the onboarding. Its warm-up and cool-downs are those of the built-in branch of the current stage's exercise (`OwnBranch.warmupAt` / `cooldownsAt`); a warm-up or cool-down that is itself a stage of the plan is not added twice. Editing an own branch keeps the user on their exercise (`CustomStages.remap`); deleting it removes it from every own course with its progress; deleting a course keeps its branches.

**Progression is global per branch:** `SkillProgress` keys are `branch.name` only (e.g. `"push"`), and `custom_<id>` for an own branch (`SkillProgress.branchKey`; `branchId` is null there, `customBranchId` set). Branches are physical skills — progress is shared across all courses containing that branch.
**Streak and SP are global.** Enrolled courses are `UserProfile.activeCourseIds`, the one shown now is `activeCourseIndex` (read through the `enrolledCourses` / `activeCourse` getters); while an own course is shown, `activeCustomCourseId` names it (cleared when a built-in one is picked; a stale id falls back to the built-in course).
Switching courses happens in the Library tab via pill tabs: the enrolled built-in courses, then every own course that is shown (`enrolledCoursesProvider`). An own course's pill carries the own-course mark (`kOwnCourseIcon`, a hand tool, `library/widgets/builder_widgets.dart`) instead of its host's face (owner, 2026-10-10: the host leads Home and the Profile, the pill only says "made by you"). The course list under "+" lists the own courses too, below the built-in ones: a tick like theirs (unticked = `CustomCourse.shown` false: no pill, nothing deleted; a hidden active course falls back to the first pill left) and a pencil that opens the builder (saving there shows the course again). **One ticked course of any kind stays** (owner, 2026-10-12, 0.9.6; before, one built-in course always stayed, so nobody could train only their own courses): `activeCourseIds` may be empty, the built-in `activeCourse` is then Calisthenics and `ActiveCourseNotifier` shows the first own course; `enrolledCoursesProvider` is never empty (Calisthenics when no course is left, e.g. the last own course deleted).

## Progression Branches
24 branches: 20 in the courses and 4 outside them (appended `BranchId` HiveFields: Evening Stretch 8–11, Morning Routine 12–15, Yoga 16–19, the branches outside the courses 20–23; `CourseId.eveningStretch` is HiveField 2, `CourseId.morningRoutine` 3, `CourseId.yoga` 4). Pull requires a pull-up bar (`requiresEquipment = true`).
`UserProfile.activeBranches` deduplicates branches across all enrolled courses.

## Exercise Catalog

Every stage, its exercise id and its animation. Amounts, rests and challenge norms are in `lib/data/static/exercise_catalog.dart`.

### Push Branch (7 stages)
| Stage | ID | Name | Lottie |
|-------|----|------|--------|
| 1 | `push_s1_wall_pushup` | Wall Push-ups | ✅ |
| 2 | `push_s2_knee_pushup` | Knee Push-ups | ✅ |
| 3 | `push_s3_full_pushup` | Full Push-ups | ✅ |
| 4 | `push_s4_diamond_pushup` | Diamond Push-ups | ✅ |
| 5 | `push_s5_wide_pushup` | Wide Push-ups | ✅ |
| 6 | `push_s6_archer_pushup` | Archer Push-ups | ✅ |
| 7 | `push_s7_handstand_pushup` | Handstand Push-ups | ✅ |

### Pull Branch (6 stages, requires pull-up bar)
| Stage | ID | Name | Lottie |
|-------|----|------|--------|
| 1 | `pull_s1_australian` | Australian Pull-ups | ✅ |
| 2 | `pull_s2_negative` | Negative Pull-ups | ✅ |
| 3 | `pull_s3_pullup` | Pull-ups | ✅ |
| 4 | `pull_s4_close_grip` | Close-grip Pull-ups | ✅ |
| 5 | `pull_s5_archer` | Archer Pull-ups | ✅ |
| 6 | `pull_s6_one_arm` | One-arm Pull-ups | ✅ |

### Core Branch (6 stages)
| Stage | ID | Name | Lottie | Notes |
|-------|----|------|--------|-------|
| 1 | `core_s1_crunches` | Crunches | ✅ | |
| 2 | `core_s2_plank` | Plank | ✅ | |
| 3 | `core_s3_lying_leg_raise` | Lying Leg Raises | ✅ | |
| 4 | `core_s4_hanging_leg_raise` | Hanging Leg Raises | ✅ | `requiresEquipment=true`; alt: `core_s4_flutter_kicks` ✅ |
| 5 | `core_s5_l_sit` | L-sit | ✅ | |
| 6 | `core_s6_dragon_flag` | Dragon Flag | ✅ | |

### Legs Branch (5 stages)
| Stage | ID | Name | Lottie | Notes |
|-------|----|------|--------|-------|
| 1 | `legs_s1_squat` | Squats | ✅ | |
| 2 | `legs_s2_lunge` | Lunges | ✅ | |
| 3 | `legs_s3_bulgarian` | Bulgarian Split Squats | ✅ | |
| 4 | `legs_s4_assisted_pistol` | Assisted Pistol Squats | ✅ | file: `legs_s4_pistol.json` |
| 5 | `legs_s5_pistol` | Pistol Squats | ✅ | file: `legs_s5_pistol_free.json` |

### Balance Branch (6 stages)
Warmup: `warmup_wrist_circles` ✅. Cooldown: `cooldown_downward_dog` ✅.
| Stage | ID | Name | Lottie |
|-------|----|------|--------|
| 1 | `bal_s1_one_leg_stand` | Single-Leg Stand | ✅ |
| 2 | `bal_s2_one_arm_plank` | One-Arm Plank | ✅ |
| 3 | `bal_s3_crow_prep` | Crow Pose Preparation | ✅ |
| 4 | `bal_s4_crow_pose` | Crow Pose (Kakasana) | ✅ |
| 5 | `bal_s5_wall_hs` | Wall Handstand | ✅ |
| 6 | `bal_s6_free_hs` | Free Handstand | ✅ |

### Flex Branch — Calisthenics course (6 stages)
Warmup: `warmup_leg_swings` ✅. Cooldown: `cooldown_cat_cow` ✅.
| Stage | ID | Name | Lottie |
|-------|----|------|--------|
| 1 | `flex_s1_hip_flexor_stretch` | Hip Flexor Stretch | ✅ |
| 2 | `flex_s2_worlds_greatest_stretch` | World's Greatest Stretch | ✅ |
| 3 | `flex_s3_hip_9090` | 90/90 Hip Mobility | ✅ (front view, 0.9.2) |
| 4 | `flex_s4_thoracic_bridge` | Thoracic Bridge | ✅ |
| 5 | `flex_s5_deep_squat_hold` | Deep Squat Hold | ✅ |
| 6 | `flex_s6_pike_stretch` | Pike Stretch | ✅ |

`flex_s3_hip_9090` is animated since 0.9.2 (approved by the owner 2026-10-09). Before that it had no animation: the pose is not readable in a side-view silhouette (the front shin points at the camera, the back thigh away from it, and the legs merge into the torso; owner, 2026-10-06, the app shows the placeholder icon). After the pigeon worked from above, the owner asked for a try (2026-10-09) and then gave a reference: the 90/90 switch seen from the front and a little above. `gen_flex.py` draws it on `frontview.py`: sitting, leaning back on the hands behind the hips, the feet planted wide; the knees lower together to one side into the 90/90, hold, come up and lower to the other side. The legs are solved in 3D — each knee turns about the line from its hip to its planted foot — and projected for a camera 12° above the floor; they are a third longer than Goro's standing legs (with his own, the knees stayed under his belly). The torso, shortened by the lean back, is stretched down past the hip joints so the thighs do not hang in the air (owner); a thigh pointing at the camera grows its knee cap, which hides the short stub of the thigh turning fast as the knee passes the hip (`check_anim.py` still reports that turn). On the Flex stand and in `assets/`. (A first top-view draft with the pigeon's `upright_fold` is in commit 4c5e378.)

### Posture Branch — Healthy Body course (6 stages)
Warmup: `warmup_hip_circles` ✅. Cooldowns: `[cooldown_hip_flexor` ✅`, cooldown_quad_stretch` ✅`]`.
| Stage | ID | Name | Type | Lottie |
|-------|----|------|------|--------|
| 1 | `posture_s1_pelvic_tilt` | Posterior Pelvic Tilt | timed | ✅ |
| 2 | `posture_s2_dead_bug` | Dead Bug | reps | ✅ (file: `supp_dead_bug.json`) |
| 3 | `posture_s3_glute_bridge` | Glute Bridge | reps | ✅ |
| 4 | `posture_s4_hip_march` | Standing Hip March | reps | ✅ (front view) |
| 5 | `posture_s5_kneeling_lunge` | Kneeling Hip Flexor Stretch | timed | ✅ (file: `flex_s1_hip_flexor_stretch.json`) |
| 6 | `posture_s6_pigeon_pose` | Pigeon Pose | timed | ✅ (from above, 0.9.2) |

`posture_s6_pigeon_pose` is drawn from above (0.9.2, approved by the owner 2026-10-09): in profile the shin across the body pointed at the camera (three profile variants looked like a crawling animal) and a front view hid it, so it had no animation from 2026-10-06. `gen_posture.py` builds it with `topview.upright_fold`: the right leg folded in front, its knee out to the side and the shin across, lit like the thigh so it stands out from the dark head; the left leg straight back; Goro folds from his hands onto his forearms and back.

### Neck Branch — Healthy Body course (5 stages)
Warmup: `warmup_neck_rolls` ✅. Cooldowns: `[cooldown_cat_cow` ✅`, cooldown_shoulder_stretch` ✅`]`.
| Stage | ID | Name | Type | Lottie |
|-------|----|------|------|--------|
| 1 | `neck_s1_neck_tilt` | Neck Tilts | timed | ✅ (front) |
| 2 | `neck_s2_chest_opener` | Chest Opener | timed | ✅ (side) |
| 3 | `neck_s3_shoulder_roll` | Shoulder Circles | reps | ✅ (front) |
| 4 | `neck_s4_wall_angel` | Wall Angels | reps | ✅ (side) |
| 5 | `neck_s5_doorway_stretch` | Doorway Pec Stretch | timed | ✅ (front) |

### Evening Stretch — four branches (0.8.20)
A calm stretch before sleep (content agreed with the owner, `internal_docs/specs/done/big-features-roadmap.md` § 2b-1). Its stages happen not to repeat a Flex / Posture / Neck stage (a draft principle, not a rule: courses may share exercises and branches, owner 2026-10-08). Every stage: sets 1→2, rest 15→10 s, `spBase` 1; ↔ = `perSide`. Warm-up of every branch: `warmup_neck_rolls`; cool-down of every branch: `cooldown_lying_relaxation` (so each evening workout ends lying down, once). Every exercise has an animation: `evening_back_s1_cat_cow` reuses `cooldown_cat_cow.json`, the other 18 and the cool-down come from `tools/lottie/gen_evening.py` (seated front views, cow face from behind, side views, the twist / figure four / frog from above).

| Branch (`BranchId`) | Stages (start→target, challenge to enter) |
|---------------------|--------------------------------------------|
| `eveningBack` (Back / Спина, 5) | cat-cow 5→12 reps · child's pose 20→60 s (30) · supine twist ↔ 20→60 (30) · sphinx 20→60 (45) · cobra 30→90 (45) |
| `eveningHips` (Hips / Бёдра, 5) | knees to chest 20→60 · reclined figure four ↔ 20→60 (30) · happy baby 20→60 (30) · butterfly 20→60 (45) · frog 30→90 (45) |
| `eveningFolds` (Folds / Наклоны, 4) | legs up the wall 30→90 · lying hamstring stretch with a towel ↔ 20→60 (30) · head-to-knee fold ↔ 20→60 (45) · straddle fold 30→90 (45) |
| `eveningShoulders` (Shoulders / Плечи, 5) | self-hug 20→60 · overhead triceps ↔ 20→60 (30) · eagle arms ↔ 20→60 (30) · puppy pose 30→90 (45) · cow face arms ↔ 20→60 (45) |

Ids: `evening_<branch>_s<N>_<name>` (e.g. `evening_folds_s2_towel_hamstring`). Achievements: `evening_back_complete`, `evening_hips_complete`, `evening_folds_complete`, `evening_shoulders_complete`.

### Morning Routine — four branches (0.9.0)
Waking the body up (content agreed with the owner, `internal_docs/specs/done/big-features-roadmap.md` § 2b-2): every pose standing, quiet (no jumps), dynamic — mobility in reps, the cardio of Energy timed. An alternating move counts each side as one rep (`perSide` is for timed holds only). Its stages happen not to repeat another branch's (not a rule: courses may share exercises and branches, owner 2026-10-08). Every stage: sets 1→2, rest 15→10 s, `spBase` 1. Warm-up of every branch: `warmup_morning_stretch_up` (5 reps); cool-down of every branch: `cooldown_shake_out` (20 s). Every exercise has an animation from `tools/lottie/gen_morning.py` (front views for the standing moves, side views for the hinges, planks and kicks).

| Branch (`BranchId`) | Stages (start→target, challenge to enter) |
|---------------------|--------------------------------------------|
| `morningSpine` (Spine / Позвоночник, 5) | side bend 6→16 reps · torso twist 10→24 (12) · good morning 8→20 (8) · roll-down 3→8 (4) · windmill 6→16 (8) |
| `morningJoints` (Joints / Суставы, 5) | knee circles 8→20 · open the gate 6→16 (8) · standing knee hug 6→16 (8) · side lunge 6→16 (8) · Cossack squat 4→12 (6) |
| `morningArms` (Arms / Руки, 5) | arm swings 10→24 · Y raises 8→20 (10) · cactus arms 8→20 (10) · inchworm 3→8 (4) · plank to downward dog 4→10 (5) |
| `morningEnergy` (Energy / Бодрость, 5) | step jacks 20→60 s · butt kicks 20→45 (30) · standing cross crunch 20→45 (30) · speed skater 20→45 (30) · slow mountain climbers 20→45 (30) |

Ids: `morning_<branch>_s<N>_<name>` (e.g. `morning_joints_s2_open_the_gate`). Achievements: `morning_spine_complete`, `morning_joints_complete`, `morning_arms_complete`, `morning_energy_complete`. The host is Aurora the lark (`assets/hosts/aurora_*`, `tools/characters/gen_hosts.py`).

### Yoga — four branches and the shared Balance (0.9.1)
A ladder of harder and harder poses (`internal_docs/specs/done/big-features-roadmap.md` § 2b-3). Holds mostly, one-sided ones on each side (↔ = `perSide`); the Flow branch counts rounds. Every stage: sets 1→2, rest 15→10 s, `spBase` 1. Warm-up of the four Yoga branches: `cooldown_cat_cow` (`warmupFor` returns any exercise); cool-down: `cooldown_lying_relaxation`. The fifth branch is **Balance** of Calisthenics, as it is (its wrist circles / downward dog). Reused stages keep their own id and borrow the animation and the texts (`ExerciseL10n` maps them to the original keys): the sphinx (Evening Stretch), the downward dog (`cooldown_downward_dog`), plank to dog (Morning Routine). Every stage has an animation from `tools/lottie/gen_yoga.py` (Warrior II, triangle, side angle, tree, eagle and half moon from the front, the rest from the side).

| Branch (`BranchId`) | Stages (start→target, challenge to enter) |
|---------------------|--------------------------------------------|
| `yogaStanding` (Standing / Стойки, 5) | chair 15→45 s · warrior I ↔ 20→45 (20) · warrior II ↔ 20→45 (30) · triangle ↔ 20→45 (30) · extended side angle ↔ 20→45 (30) |
| `yogaOneLeg` (Equilibrium / Равновесие, 5) | tree ↔ 15→45 · eagle ↔ 15→40 (20) · warrior III ↔ 10→30 (15) · dancer ↔ 10→30 (15) · half moon ↔ 10→30 (15) |
| `yogaBackbends` (Backbends / Прогибы, 6) | sphinx 20→60 (reused) · locust 10→30 (15) · bridge 15→45 (20) · bow 10→30 (15) · camel 15→40 (15) · wheel 5→20 (10) |
| `yogaFlow` (Flow / Поток, 5) | downward dog 20→60 s (reused) · plank to dog 4→10 reps (5, reused) · half sun salutation 2→6 rounds (3) · Sun Salutation A 2→5 (2) · Sun Salutation B 2→5 (2) |
| `balance` (shared with Calisthenics, 6) | § Balance Branch |

Ids: `yoga_<branch>_s<N>_<name>` (e.g. `yoga_one_leg_s5_half_moon`). Achievements: `yoga_standing_complete`, `yoga_one_leg_complete`, `yoga_backbends_complete`, `yoga_flow_complete`. The host is Miso the cat (`assets/hosts/miso_*`, `tools/characters/gen_hosts.py`).

### Branches outside the courses (0.9.5)
Content agreed with the owner on 2026-10-11 (`internal_docs/specs/done/next-ideas-2026-10-10.md` § 1): no equipment beyond a chair, a sofa and a door frame. Strength stages: sets 1→3, rest 60→30 s; Cardio: sets 1→3, rest 45→20 s; `spBase` 2, 3 on the hardest. An alternating move counts each side as one rep. Warm-up / cool-downs reuse existing ones: Strong Back arm circles / cat-cow, Glutes hip circles / hip flexor stretch, Arms & Shoulders wrist circles / shoulder stretch, Cardio jumping jacks / quad stretch. Every exercise has an animation from `tools/lottie/gen_extra.py`.

| Branch (`BranchId`) | Stages (start→target, challenge to enter) |
|---------------------|--------------------------------------------|
| `strongBack` (Strong Back / Сильная спина, 5) | prone Y-T-W 4→10 rounds · reverse snow angels 6→15 (6) · superman hold 15→45 s (20) · swimmers 20→45 s (20) · door frame rows 6→15 (6) |
| `glutes` (Glutes / Ягодицы, 5) | donkey kicks 10→24 · fire hydrants 10→24 (12) · single-leg glute bridge 6→16 (8) · hip thrust on the sofa 8→20 (10) · single-leg hip thrust 6→16 (8) |
| `armsShoulders` (Arms & Shoulders / Руки и плечи, 6) | plank shoulder taps 10→24 · chair dips, knees bent 5→15 (6) · plank up-downs 6→16 (8) · pike push-ups 4→12 (5) · chair dips, legs straight 6→16 (8) · elevated pike push-ups 3→10 (4) — the step before the handstand push-up of Push |
| `cardio` (Cardio / Кардио, 6) | high knees 20→45 s · skater jumps 20→45 s (30) · squat jumps 20→40 s (20) · fast mountain climbers 20→45 s (30) · half burpees 6→15 (6) · burpees 5→15 (6) — with jumps, unlike the quiet Energy of Morning Routine (owner) |

Ids: `<branch>_s<N>_<name>` (`strong_back_s5_door_row`, `arms_shoulders_s6_elevated_pike`). The texts are in the ARB files as for every exercise (`exercise<Id>Name/Desc/Tip`).

### Warmup Accessories (stage 0)
| ID | Name | Used by | Lottie |
|----|------|---------|--------|
| `warmup_arm_rotations` | Arm Circles | Push | ✅ |
| `warmup_dead_hang` | Dead Hang | Pull | ✅ |
| `warmup_jumping_jacks` | Jumping Jacks | Core | ✅ |
| `warmup_leg_swings` | Leg Swings | Flex | ✅ |
| `warmup_hip_circles` | Hip Circles | Legs, Posture | ✅ |
| `warmup_wrist_circles` | Wrist Circles | Balance | ✅ |
| `warmup_neck_rolls` | Neck Rolls | Neck, every Evening Stretch branch | ✅ (front) |
| `warmup_morning_stretch_up` | Morning Stretch-Up (5 reps) | every Morning Routine branch | ✅ (front) |

### Cooldown Accessories (stage 0)
| ID | Name | Used by | Lottie |
|----|------|---------|--------|
| `cooldown_shoulder_stretch` | Shoulder & Chest Stretch | Push, Neck | ✅ |
| `cooldown_lat_stretch` | Lat Stretch | Pull | ✅ |
| `cooldown_cat_cow` | Cat-Cow | Core, Flex, Neck | ✅ |
| `cooldown_quad_stretch` | Quad Stretch | Legs, Posture | ✅ |
| `cooldown_hip_flexor` | Hip Flexor Stretch | Legs, Posture | ✅ |
| `cooldown_downward_dog` | Downward-Facing Dog | Balance | ✅ |
| `cooldown_lying_relaxation` | Lying Relaxation (60 s) | every Evening Stretch branch | ✅ (side) |
| `cooldown_shake_out` | Shake-Out (20 s) | every Morning Routine branch | ✅ (front) |

### Supplementary Pool (9 exercises, stage 0)
`SupplementaryExerciseCatalog.all` — used in custom workouts and bonus sessions. All nine have an animation; `supp_wrist_circles` reuses the existing front-view `warmup_wrist_circles.json`, the other eight are generated by `tools/lottie/gen_supp.py`.
| ID | Name | Category |
|----|------|----------|
| `supp_oblique_crunch` | Oblique Crunch | core |
| `supp_russian_twists` | Russian Twists | core |
| `supp_side_plank` | Side Plank | core |
| `supp_standing_calf_raise` | Standing Calf Raise | legs |
| `supp_single_leg_calf_raise` | Single-Leg Calf Raise | legs |
| `supp_dead_bug` | Dead Bug | core |
| `supp_bird_dog` | Bird-Dog | core |
| `supp_neck_isometrics` | Neck Isometrics | neck/balance |
| `supp_wrist_circles` | Wrist Circles | push/warmup |
