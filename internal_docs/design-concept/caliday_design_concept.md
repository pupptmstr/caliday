# CaliDay — Mascot and Visual Style Design Concept

**Version:** 2.0
**Date:** February 2026

---

## 1. Mascot — Goro

### 1.1 Concept

Goro is the gorilla mascot of the CaliDay app. The central brand character.

**Why a gorilla:**

- Gorillas use calisthenics in the wild — they climb, hang, and balance on their arms
- Strong yet friendly — a cartoon style makes the character approachable
- Stands out in the App Store among generic fitness icons
- Scales perfectly: recognisable silhouette from 16 px to full-size animations
- Works well with the brand's blue colour

**Name:** Goro (from "gorilla", short and memorable)

### 1.2 Visual Characteristics

- **Body:** dark grey with a purple undertone (#38384C primary, #424258 light)
- **Face:** warm beige/brown (#C4A882 → #A8896A)
- **Nose:** wide, flat, with prominent nostrils — a defining gorilla trait (#967756)
- **Eyes:** large, expressive, white with dark pupils — friendly cartoon style
- **Sagittal crest:** bump on the top of the head — the key feature of a male gorilla
- **Brow ridges:** heavy, prominent — creates a characteristic gaze
- **Headband:** blue (#A8D8FF) — brand accent, sporty element
- **Body shape:** triangular — broad shoulders, powerful arms, narrow hips, small legs

### 1.3 Drawing Style

- Flat design with minimal shadows
- No outlines (shapes are defined by colour contrast)
- Large expressive eyes
- Simplified anatomy with a hint of musculature (chest, biceps, abs)
- Scalable: readable silhouette at any size

### 1.4 Poses

| Pose | Usage | Description |
|------|-------|-------------|
| **Face** | App icon (primary), notifications, avatar | Only Goro's head, filling the entire frame. Supports expression swapping |
| **Flex** | Home screen, promo materials, store listing | One arm on the ground (gorilla stance), the other flexing a bicep |
| **Idle** | Resting state, menus, settings | Standing upright, both arms lowered, neutral friendly expression |

### 1.5 Character System

| Character | Role | Personality | Visual | Status |
|-----------|------|-------------|--------|--------|
| **Goro** (main) | Coach / mentor | Friendly, encouraging | Gorilla, blue headband | ✅ Ready |
| **Skala** | Challenge host | Strict but fair | Bull | ✅ Integrated (Workout screen, Challenge phase); redrawn as a real bull 2026-10-08 (`tools/characters/gen_skala.py`) |
| **Raffi** | Host of Healthy Body | Cheerful, upright | Giraffe, blue neck band | ✅ Drawn 0.8.20 (portrait + cheer) |
| **Luna** | Host of Evening Stretch | Calm, gentle | Owl, blue scarf, night sky | ✅ Drawn 0.8.20 (portrait + cheer) |
| **Aurora** | Host of Morning Routine | Bright, early, sings | Lark, blue sports headband, sunrise | ✅ Drawn 0.9.0 (six faces, idle, cheer) |
| **Miso** | Host of Yoga | Calm, flexible, quietly pleased | Ginger tabby cat, blue collar with a bell, teal tile, yoga mat | ✅ Drawn 0.9.1 (six faces, idle in lotus, cheer with paws overhead) |
| **Bruno** | Exercise demonstrator | Calm, technical | Bear | ❌ Dropped in that role (2026-10-08): stage previews will play Goro's animations |
| **Rex** | Streak motivator | Energetic, hyperactive | Small monkey, flame | 🔲 Deferred |

**Course hosts (decided 2026-10-08):** every course has its own host — static art in 2–3 poses, like Skala — on the course cards, the workout summary of that course and its achievements. Goro stays the coach (Home, notifications) and performs every exercise animation. Details and the Skala redraw brief: `internal_docs/DEV_NOTES.md` § Course hosts.

**Skala — details (v1.1) ✅ Ready:**
Appears on the Challenge screen. Visually larger and more monumental than Goro — commands respect.
Poses: neutral (arms crossed, silently evaluating) and approving (fist with thumb up).

Colour palette:

| Element | HEX |
|---------|-----|
| Body | `#2A1F17` / `#3B2C21` / `#52402F` |
| Forearms, fists | `#5C4836` / `#7A6250` |
| Muzzle | `#C9A07A` → `#A97D5A` |
| Horns | `#F2E6C8` → `#CDB78C`, tips `#3A2E24` |
| Nose ring (gold) | `#D4A73C` / `#F4D676` |
| Background | `#5C1A1A` → `#3A0C0C` (dark red) |

The dark red background distinguishes the Challenge screen from Goro's blue — it creates the feeling of an "arena of trials".

**Bruno — details (v1.2):**
Appears on the Branch Journey Screen (branch progression route) alongside each stage —
demonstrating technique. Calm, precise, technical. Does not compete with Goro, but complements him.

---

## 2. Expression System

### 2.1 Concept

The app icon — Goro's face — is "alive": the expression changes depending on the user's state.
This creates an emotional bond with the mascot and provides additional motivation through a sense of
responsibility towards the character.

Goro's head fills the entire icon frame without neck or body. Only three facial zones change —
eyebrows, eyes, and mouth — while everything else (crest, headband, ears, nose, background) stays fixed.

### 2.2 Expressions

| Expression | Trigger | Eyebrows | Eyes | Mouth |
|------------|---------|----------|------|-------|
| **Happy** (default) | Workout completed today | Calm, slightly raised | Open, pupils centred | Wide smile |
| **Sad** | Evening, no workout today | Inner corners raised | Pupils looking down | Corners drooping |
| **Angry / Motivating** | Streak at risk (2 hours before midnight) | Drawn together, furrowed | Narrowed, pupils straight | Tight mouth, determined |
| **Sleeping** | Night time (after midnight) | Relaxed | Closed (arcs instead of circles) | Slightly open |
| **Excited** | Achievement / new rank / record | High up | Wide open, star pupils | Open mouth, wide smile |
| **Supportive** | User returning after a missed day | Softly raised | Warm gaze, pupils slightly up | Light encouraging smile |

### 2.3 Implementation Status

SVG files for all 6 expressions **received from the designer**; they live in `assets/goro/` (the delivery notes are in `internal_docs/caliday_design_v1_1/RESULTS.md`).
The system is **fully integrated** in the code — `GoroExpressionProvider` is implemented and active.

### 2.4 Technical Details

The icon is built from layers. Static layers:

- Background (blue gradient)
- Head shape, fur
- Sagittal crest
- Brow ridges (base shape)
- Headband
- Ears
- Nose

Dynamic layers (change based on expression):

- Eyebrows (path: angle, curvature)
- Eyes (ellipse: size, shape, pupil visibility)
- Pupils (ellipse: cx/cy position, possible replacement with stars)
- Mouth (path: curvature, openness)

### 2.5 Where Expressions Are Used

| Context | Expression |
|---------|------------|
| Home screen icon | Depends on state (iOS Dynamic Icon / Android Adaptive) |
| Push notification (morning) | Happy |
| Push notification (evening reminder) | Sad |
| Push notification (streak threat) | Angry |
| Push notification (congratulations) | Excited |
| Results screen (after workout) | Excited / Happy |
| Home screen (workout not started) | Supportive |
| Home screen (workout completed) | Happy |
| Returning after a missed day | Supportive |

---

## 3. Colour Palette

### 3.1 Primary Colours

| Role | Colour | HEX | Usage |
|------|--------|-----|-------|
| **Primary** | Blue | `#4DA6FF` | Main brand colour, buttons, accents |
| **Primary Dark** | Deep blue | `#2B7DE9` | Gradients, shadows, active states |
| **Primary Light** | Light blue | `#A8D8FF` | Goro's headband, backgrounds, highlights |

### 3.2 Secondary Colours

| Role | Colour | HEX | Usage |
|------|--------|-----|-------|
| **Energy** | Orange | `#FF9500` | Streaks, fire, energy |
| **Success** | Green | `#34C759` | Progress, completion, unlocking |

### 3.3 Character Colours

| Element | HEX | Description |
|---------|-----|-------------|
| Body (dark) | `#38384C` | Primary fur colour |
| Body (light) | `#424258` | Highlights, volume |
| Muscles / details | `#4A4A60` | Chest, abs, shadows |
| Face (upper) | `#C4A882` | Light part of the face |
| Face (lower) | `#A8896A` | Dark part of the face |
| Nose | `#967756` | Primary nose colour |
| Nostrils / mouth | `#7A6045` | Face details |
| Brow ridges | `#2E2E42` | Dark shadows |

### 3.4 Icon Background

Gradient: `#4DA6FF` (top left) → `#2B7DE9` (bottom right)

---

## 4. App Icon

### 4.1 Primary Icon — Goro's Face

The primary app icon is a close-up of Goro's face, filling the entire frame. Head only — no neck or body.
This format was chosen as the primary one for several reasons:

- Reads better at small sizes (48 px, 32 px) — the face is recognisable even in miniature
- Supports dynamic expression swapping — emotional bond with the user
- The character becomes "alive" — reacts to user actions (or inaction)
- More memorable — faces attract attention more than abstract symbols

### 4.2 Additional Variants

| Variant | File | Usage |
|---------|------|-------|
| **Face** (primary) | `caliday_icon_face.svg` | App icon, avatar, notifications |
| **Flex** | `caliday_icon.svg` | Store listing, promo, home screen |
| **Idle** | `caliday_icon_idle.svg` | Menus, settings, resting state |

### 4.3 File Requirements

- **Vector source:** SVG (for rebuilding at any size)
- **icon.png:** 1024×1024 px, PNG, opaque background — flutter_launcher_icons cuts all sizes
- **icon_foreground.png:** 1024×1024 px, PNG, transparent background — for Android adaptive icon
- Rounded corners: `rx="224"` (22% of 1024) — iOS style

### 4.4 Scalability

The icon has been tested at: 180 px (iOS), 120 px, 72 px, 48 px (Android), 32 px, 16 px. The silhouette reads clearly at all sizes.

---

---

## 5. Exercise Animation System

### 5.1 Concept

Every exercise is accompanied by an animation demonstrating correct technique.
The animation is not a video — it is a stylised 2D illustration in motion, matching the app's overall
flat style.

### 5.2 Where Animations Are Used

One animation per exercise is used in **two places**:

**1. Workout Screen (WorkoutScreen) — primary use**
During the exercise the animation plays directly on screen — the user sees a technique example while
counting reps or holding time. Plays on loop for the entire duration of the set.

**2. Branch Journey Screen — secondary use**
A static preview or short gif version is shown next to each stage — the user can see what awaits
them at upcoming stages without entering a workout. **Not implemented** — the Branch Journey screen shows no animation preview (planned together with Bruno, which is not planned).

### 5.3 Who Performs the Exercises

**v1.1 — Goro** (Workout Screen):
Goro performs exercises in simplified poses. Uses the existing character — same proportions and
colours, anatomy adapted per exercise. Realistic body not needed — only readable key positions
and movement path.

**v1.2 — Bruno** (Branch Journey Screen):
A specialised demonstrator bear. More detailed technique. Appears next to the description of each
stage in the branch progression. Bruno has not yet been designed — a separate brief is needed for v1.2.

### 5.4 Technical Requirements

**Format:** Lottie (JSON) — export from After Effects or LottieFiles.
Alternative: Rive (.riv) — if interactive states are needed (idle / playing / done).

**Canvas:** 400×400 px logical (800×800 for 2×)

**Duration:** 2–4 seconds, seamless loop

**Camera angle:**
- Most exercises → side view (90°): most readable
- Symmetrical exercises (rotations, jumping jacks) → front view
- Asymmetric arm exercises (archer, diamond) → 45° or close-up of arms
- Specific angle — designer's call based on technique readability

**Style:**
- Same flat design, no outlines
- Palette matches Goro (body `#38384C`, face `#C4A882`, headband `#A8D8FF`)
- Minimal environment details — floor as a line, no backgrounds
- Do not show incorrect technique — only correct execution

**File naming:** must exactly match the exercise `id` from the catalogue.
Example: `push_s1_wall_pushup.json`, `core_s2_plank.json`, `legs_s5_pistol.json`

Location in project: `assets/animations/[id].json`

### 5.5 Full Animation List (v1.1)

All 5 branches + accessories. Total: **43 animations**.

**Push branch (7):**

| ID | Name | Angle | Key moment |
|----|------|-------|-----------|
| `push_s1_wall_pushup` | Wall push-ups | Side | Straight body, hands at chest level |
| `push_s2_knee_pushup` | Knee push-ups | Side | Straight line knees → shoulders |
| `push_s3_full_pushup` | Full push-ups | Side | Straight body from heels to head |
| `push_s4_diamond_pushup` | Diamond push-ups | 45° + close-up hands | Diamond hand placement |
| `push_s5_archer_pushup` | Archer push-ups | 45° / Front | Arm asymmetry, weight shift |
| `push_s6_one_arm_pushup` | One-arm push-ups | Side / 45° | Balance, feet wider than shoulders |
| `push_s7_handstand_pushup` | Handstand push-ups | Side | Inversion, straight body, feet at wall |

**Pull branch (6) — pull-up bar exercises:**

| ID | Name | Angle | Key moment |
|----|------|-------|-----------|
| `pull_s1_australian` | Australian pull-ups | Side | Body straight, heels on floor, pull with chest |
| `pull_s2_negative` | Negative pull-ups | Side | Slow descent, controlled |
| `pull_s3_pullup` | Pull-ups | Side | Chin above bar, shoulder blades engaged |
| `pull_s4_close_grip` | Close-grip pull-ups | Side | Narrow grip, elbows close to body |
| `pull_s5_archer` | Archer pull-ups | Front / 45° | One arm straight, the other pulls |
| `pull_s6_one_arm` | One-arm pull-ups | Side | Free arm does not assist |

**Core branch (6):**

| ID | Name | Angle | Key moment |
|----|------|-------|-----------|
| `core_s1_crunches` | Crunches | Side | Shoulder blades lift, not the neck — lower back pressed to floor |
| `core_s2_plank` | Plank | Side | Straight line heels → head, active core |
| `core_s3_lying_leg_raise` | Lying leg raises | Side | Lower back pressed to floor |
| `core_s4_hanging_leg_raise` | Hanging leg raises | Side | No swinging, legs together |
| `core_s5_l_sit` | L-sit | Side / 45° | Legs parallel to floor, arms straight |
| `core_s6_dragon_flag` | Dragon Flag | Side | Controlled descent, straight body |

**Legs branch (5):**

| ID | Name | Angle | Key moment |
|----|------|-------|-----------|
| `legs_s1_squat` | Squats | Side / 45° | Knees behind toes, back straight, thighs parallel |
| `legs_s2_lunge` | Lunges | Side | Knee doesn't touch floor, torso vertical |
| `legs_s3_bulgarian` | Bulgarian split squats | Side | Rear leg elevated, balance |
| `legs_s4_assisted_pistol` | Assisted pistol squats | Side | One leg forward, hand holds support |
| `legs_s5_pistol` | Pistol squats | Side | One leg horizontal forward, equilibrium |

**Balance branch (6):**

| ID | Name | Angle | Key moment |
|----|------|-------|-----------|
| `bal_s1_one_leg_stand` | One-leg stand | Front / 45° | Gaze fixed on a point, arms assist balance |
| `bal_s2_one_arm_plank` | One-arm plank | Side / 45° | Hips level, body straight |
| `bal_s3_crow_prep` | Crow pose prep | Side | Knees on shoulders, weight forward |
| `bal_s4_crow_pose` | Crow pose | Side | Both feet in the air, arms straight |
| `bal_s5_wall_hs` | Wall handstand | Side | Feet at wall, body straight, gaze downward |
| `bal_s6_free_hs` | Freestanding handstand | Side | Balance without support, fingers "gripping" the floor |

**Accessories — warm-ups and cool-downs (13):**

| ID | Name | Angle | Note |
|----|------|-------|------|
| `warmup_arm_rotations` | Arm circles | Front | Push |
| `warmup_jumping_jacks` | Jumping jacks | Front | General |
| `warmup_dead_hang` | Dead hang | Side | Pull — show relaxed hang |
| `warmup_leg_swings` | Leg swings | Side | Legs — alternating forward-back |
| `warmup_hip_circles` | Hip circles | Front | Legs — hands on hips |
| `warmup_wrist_circles` | Wrist circles | Close-up hands | Balance — mandatory before handstand |
| `cooldown_shoulder_stretch` | Shoulder and chest stretch | Side / 45° | Push |
| `cooldown_cat_cow` | Cat-cow | Side | Core |
| `cooldown_lat_stretch` | Lat stretch | Front / 45° | Pull — lean, arm overhead |
| `cooldown_quad_stretch` | Quad stretch | Side | Legs — standing, leg behind |
| `cooldown_hip_flexor` | Hip flexor stretch | Side | Legs — lunge, lower hips |
| `cooldown_wrist_stretch` | Wrist stretch | Close-up hands | Balance — straight arms, fingers toward you |
| `cooldown_downward_dog` | Downward-facing dog | Side | Balance — inverted V |

---

## 6. Files

### Ready Assets (v1.0)

| File | Description |
|------|-------------|
| `caliday_icon_face.svg` | Primary icon — Goro's face, "Happy" expression |
| `caliday_icon.svg` | Goro flexing bicep (for store and promo) |
| `caliday_icon_idle.svg` | Idle pose — Goro standing calmly |
| `caliday_icon_preview.html` | Preview of all variants with colour palette |
| `goro_notification.svg` | Source of the Android notification icon (`ic_goro_notif.xml`) |
| `caliday_design_concept.md` | This document |

### Ready Assets (v1.1) — received and integrated

The files are in `assets/goro/` and `assets/skala/` (the designer's delivery notes: `internal_docs/caliday_design_v1_1/RESULTS.md`).

| File | Description | Format |
|------|-------------|--------|
| `goro_idle_v2.svg` | Goro — idle pose (redesign, realistic gorilla proportions) | SVG |
| `goro_flex_v2.svg` | Goro — flex pose (redesign, realistic proportions) | SVG |
| `goro_face_happy.svg` | Goro — Happy | SVG |
| `goro_face_sad.svg` | Goro — Sad | SVG |
| `goro_face_angry.svg` | Goro — Angry / Motivating | SVG |
| `goro_face_sleeping.svg` | Goro — Sleeping | SVG |
| `goro_face_excited.svg` | Goro — Excited | SVG |
| `goro_face_supportive.svg` | Goro — Supportive | SVG |
| `skala_neutral.svg` | Skala — neutral pose (evaluating) | SVG |
| `skala_approve.svg` | Skala — approval (test passed) | SVG |

### Exercise animations — delivered

All exercises have an animation except two chosen by the owner (90/90 hip mobility and the pigeon pose) and 13 Yoga stages still to draw: **111 Lottie files in `assets/animations/`** for 133 exercises (some are shared; the 19 of Evening Stretch were added in 0.8.20, the 22 of Morning Routine in 0.9.0, 5 of Yoga so far in 0.9.1). The list of files per exercise is in `ARCHITECTURE.md` → Exercise Catalog. The character is Goro in all of them; part of the set was drawn by the designer, the rest is generated with `tools/lottie` (see `ARCHITECTURE.md` → Lottie Animation Tooling).

### Home screen widget — delivered

The Android widget uses `drawable-*/goro_idle.png` and `goro_flex.png`, exported from `goro_idle_v2.svg` and `goro_flex_v2.svg` (not the originally planned `goro_widget_*.png` names).

### Expected Assets (v1.2) — Bruno character

Bruno is a bear demonstrator of exercise technique, appearing on the Branch Journey Screen alongside stages.
Requires a separate brief and character design from scratch.