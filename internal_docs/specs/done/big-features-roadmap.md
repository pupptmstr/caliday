# The big features (owner's plan, 2026-10-07) — done

> Part of the project notes — the index is [internal_docs/README.md](../../README.md).

## Roadmap — the big features (owner's plan, 2026-10-07)

The owner's order: **(1) German and Spanish translations (done as drafts, 0.8.16), (2) additional courses, (3) a configurator for the user's own courses, with many more exercises and branches added before it so that building a course is easy.** This records what is known and decided so that it is not looked up again.

### 1. German and Spanish
- **Part 1, the code, is done (2026-10-07, 0.8.16):** nothing assumes two languages any more. The UI languages are one list, `appLanguages` (`core/l10n/app_languages.dart`); the settings dialog, the onboarding menu, the system-language default (`LocaleNotifier`), the notification texts and the widget's rank names all follow it, the last two through the ARB files (`l10nFor`). The tests check every ARB file against the template and run their "every language" checks over all of them (`test/helpers/all_translations.dart`). Tried with a copy of `app_en.arb` as `app_de.arb`: exactly two tests failed, the missing line in `appLanguages` and the "What's new" entries left in English. See the Change History entry.
- **Part 2, the texts, is in as drafts (2026-10-07, also 0.8.16, at the owner's request):** `l10n/app_de.arb` and `app_es.arb`, all 562 messages each, written by Claude. **The owner will have native speakers proofread them**; until then the wording is provisional. Choices a proofreader should know: informal address (du / tú, like the Russian ты); German keeps the calisthenics anglicisms the community uses (Challenge, Skills, Plank, Pistol Squat, Dragon Flag, Crunches) and "Serie / Serienschutz" for streak / freeze; Spanish is neutral rather than Spain-only where it could be ("acuéstate", "parada de manos"), with "racha / protector de racha / reto / etapa"; the rank names follow the Russian ones (Anfänger, Amateur, Sportler, Athlet, Meister, Legende / Principiante, Aficionado, Deportista, Atleta, Maestro, Leyenda); counted messages are plurals even where the English one is not ("1 Freund", "1 vez"). Adding a message from now on means writing it in all four files.
- **The legal pages in `docs/` stay in English only** (owner, 2026-10-09). **Not written yet in any language:** the store listings.
- **Still assuming Russian on purpose:** a profile without a language (`UserProfile.locale == null`, older profiles) gets Russian notifications and shows "Русский" in Settings (`SettingsState.locale`), as before; a new profile always stores its language. `l10n.yaml` `preferred-supported-locales: en, ru` only orders the locale resolution and needs no change.
- **Checked on a 375 px screen (web):** German — the onboarding, Home, the Courses tab, Profile, Settings; Spanish — Settings, Home, Profile, the workout screen and its quit dialog. Nothing overflowed and the console showed no layout errors; the long rank names ("Principiante") shrink inside their chip. The segmented controls fit in both; only the Russian "Системная" broke mid-word (an older problem, not about the new languages; fixed in 0.9.2).
- ~~The native home screen widget is not localized~~ — fixed in 0.8.18 (Change History).

### Decisions on courses (owner, 2026-10-07)
- **A course stays what it is: a set of branches with staged progression.** No second kind of course (a "routine" with its own progression) and no day-by-day programme. Every new course is made of branches.
- **Yoga** = branches of progressively harder poses (a ladder, like Balance).
- **Morning routine / evening stretch** = branches too; their progression is mostly "more reps / longer holds", which the in-stage progression already does. Not seen as a problem.
- **More branches come before the builder, including branches that belong to no course.** They are there to be picked in the builder (and shown in the exercise library).
- **The custom course builder offers two things:** (a) a course from a set of *existing* branches; (b) *a branch of one's own*: the user picks exercises, puts them in order (each one is a stage) and the app runs the usual progression through them.
- **Exercises and whole branches may be shared between courses (owner, 2026-10-08).** A new course reuses what fits: an existing exercise (as its own stage id with the same animation, as `evening_back_s1_cat_cow`), an existing warm-up or cool-down, or a whole existing branch in `CourseCatalog.branchesFor` (progress is per branch, so it is shared, as Flex is in Calisthenics and Healthy Body). The "no stage repeats another branch" principle of Evening Stretch and Morning Routine was never the owner's rule and is dropped.
- **Friends stop carrying the progress of every branch**, so that a new branch never breaks the friend QR / BLE exchange (then: no branch progress at all, 0.8.19).

### 2a. Friends without branch progress — done (0.8.19)
The owner chose to drop branch progress from the friend exchange altogether (rather than freeze a list of eight): QR format 3, see the Change History entry and ARCHITECTURE § QR Profile Exchange. A new branch no longer touches the friend format.

### 2b. New courses: Yoga, Morning Routine, Evening Stretch
- Each is a `CourseId` value (appended: the Hive enum keeps its indices) and a list in `CourseCatalog.branchesFor`; the onboarding course cards and the Library pills already loop over the courses.
- **Content first, per course:** which branches, how many stages, which exercises per stage (existing ones reused where they fit: Flex / Posture / Neck for the stretches; new poses for Yoga), start / target reps, sets, rest and the challenge norms. To be designed with the owner course by course.
- **Costs of a new branch** (unchanged): a value in the `BranchId` Hive enum, its stages, a warm-up and cool-downs, tags, achievements (`<branch>_complete`), ARB texts in all four languages, a Lottie animation per exercise (the `tools/lottie` rigs; some poses do not read in a side view, see the pigeon and 90/90 decisions), the onboarding start stage.
- ~~Two courses on one day~~ — settled and done in 0.8.19: progression is per branch and per day, in any workout (the owner's rule), SP and the streak unchanged. See `internal_docs/reference/progression.md` § Primary vs Bonus Workout.

### 2b-1. Evening Stretch — the first new course, content agreed (owner, 2026-10-08)
- **Concept:** a calm stretch before sleep. Everything on the floor, nothing needed but a towel and a wall, slow, and every workout ends lying down. Host: **Luna** the owl (see § Course hosts).
- ~~**No pose repeats a progression stage of Flex, Posture or Neck**~~ (a principle of this course's draft, not a rule; dropped 2026-10-08, see § Decisions on courses), so that a user of Calisthenics or Healthy Body does not meet the same exercises twice. Only the cat-cow animation and the neck rolls are reused. (An earlier estimate, "built almost entirely from existing exercises", held only with such repeats.)
- **Four branches** (the owner asked for four: with three, as in Healthy Body today, the Standard size — 3 skills — and the Full size — all — give the same workout). ↔ = held on each side (§ Per-side holds); times are per side.

| Branch | # | Exercise | Grows within the stage | Challenge to enter | Animation |
|--------|---|----------|------------------------|--------------------|-----------|
| **Back** (Спина) | 1 | Cat-Cow | 5→12 reps | — | reuses `cooldown_cat_cow.json` |
| | 2 | Child's Pose | 20→60 s | 30 s | new, side |
| | 3 | Supine Twist ↔ | 20→60 s | 30 s | new, top view (`topview.py`) |
| | 4 | Sphinx | 20→60 s | 45 s | new, side |
| | 5 | Cobra | 30→90 s | 45 s | new, side |
| **Hips** (Бёдра) | 1 | Knees to Chest | 20→60 s | — | new, side |
| | 2 | Reclined Figure Four ↔ | 20→60 s | 30 s | new, top view |
| | 3 | Happy Baby | 20→60 s | 30 s | new, side |
| | 4 | Butterfly | 20→60 s | 45 s | new, ⚠️ seated front view |
| | 5 | Frog | 30→90 s | 45 s | new, ⚠️ view unclear — fallback: Lizard |
| **Folds** (Наклоны; "Ноги" is the Legs branch) | 1 | Legs Up the Wall | 30→90 s | — | new, side (wall prop) |
| | 2 | Lying Hamstring Stretch, with a towel ↔ | 20→60 s | 30 s | new, side |
| | 3 | Head-to-Knee Fold ↔ | 20→60 s | 45 s | new, side |
| | 4 | Straddle Fold | 30→90 s | 45 s | new, ⚠️ seated front view |
| **Shoulders** (Плечи) | 1 | Self-Hug | 20→60 s | — | new, seated front view |
| | 2 | Overhead Triceps Stretch ↔ | 20→60 s | 30 s | new, seated front view |
| | 3 | Eagle Arms ↔ | 20→60 s | 30 s | new, ⚠️ seated front view |
| | 4 | Puppy Pose | 30→90 s | 45 s | new, side |
| | 5 | Cow Face Arms ↔ | 20→60 s | 45 s | new, ⚠️ seated front view (or from behind) |

- The Shoulders branch leaves out what exists already: hands clasped behind the back (the Push cool-down, `neck_s2_chest_opener`), the doorway stretch, the lat stretch at the wall.
- **Common to every stage:** sets 1→2, rest 15→10 s (as Posture / Neck), `spBase` 1.
- **Warm-up** of every branch: `warmup_neck_rolls` (reused). **Cool-down** of every branch: a new stage-0 exercise **Lying Relaxation** (shavasana), 60 s; the generator de-duplicates cool-downs, so each evening workout ends with it once.
- **Onboarding:** all four branches start at stage 1, no calibration question.
- **Bonus workout:** no supplementary block in this course — implemented in 0.8.20 (`CourseCatalog.addsSupplementary`), **confirmed by the owner 2026-10-08**. The pool is strength work (Russian twists, side plank, calf raises), out of place before sleep. Today `generateDailyForCourse` adds it to every non-primary workout.
- **Identifiers** (proposed): `CourseId.eveningStretch`; four `BranchId` values appended to the enum. They are Hive enum values and the keys of `SkillProgress` and of the `<branch>_complete` achievements, so their names cannot change later — choose them once (e.g. `eveningBack`, `eveningHips`, `eveningFolds`, `eveningShoulders`).
- **Costs:** 19 new exercises (18 stages + Lying Relaxation), each a name, a description and a tip in four languages, tags, and a Lottie animation; 4 branches, 1 course, 4 branch achievements, the course card with Luna.
- **Rig work first:** a **seated front view** in `tools/lottie/frontview.py` (it draws standing poses only today) is needed by about seven animations (butterfly, straddle, the four arm stretches, maybe the frog). Build it and check that the ⚠️ poses read before drawing the rest; a pose that does not read is replaced, not shipped without an animation.
- **Order of work:** (1) per-side holds — done, 0.8.20; (2) — **done, 0.8.20 (Change History)** — the course, its branches and exercises **without animations** (the app already shows an exercise without one, as 90/90 and the pigeon) and their texts in four languages; (3) Luna and the host slot; (4) the animations, branch by branch — **done, 0.8.20, all 19 approved by the owner**. Users should see the course only once the animations are in — the web build is public, so either it lands in one go or it stays behind a debug-only switch until then (to decide at implementation).

### 2b-2. Morning Routine — the second new course, content agreed (owner, 2026-10-08)
- **Concept:** wake the body up — the opposite of Evening Stretch (calm holds lying down). Host: **Aurora** the lark (§ Course hosts). Course name: Morning Routine / Утренняя зарядка / Morgenroutine / Rutina matutina (to settle with the texts).
- **Principles:** everything **standing** (next to the bed, in pyjamas, no mat, no lying down — hands go to the floor only in the top stages); **quiet, no jumps** (the household and the neighbours may still be asleep); **dynamic** — mobility moves are counted in reps, the cardio is timed (hands-free through the get-ready countdown). An alternating move counts each side as one rep (`perSide` stays for timed holds only).
- ~~**No stage repeats a progression stage of another branch**~~ (Flex, Posture, Neck, Evening, Calisthenics; a principle of this course's draft, not a rule; dropped 2026-10-08, see § Decisions on courses). Accepted by the owner as different enough: the side lunge (the Legs lunge goes forward), the standing knee hug (Evening's knees to chest is lying), plank to downward dog (the Balance cool-down is a static hold), step jacks (jumping jacks is a warm-up, not a stage).
- **Branch names differ from the Evening ones** (Спина, Бёдра, Плечи) so that the Library and later the builder do not show two "Плечи".

| Branch | # | Exercise | Grows within the stage | Challenge to enter | Animation |
|--------|---|----------|------------------------|--------------------|-----------|
| **Spine** (Позвоночник) | 1 | Standing Side Bend | 6→16 reps | — | front |
| | 2 | Torso Twist | 10→24 reps | 12 | ⚠️ front, faked torso turn |
| | 3 | Good Morning (hands behind the head, hinge with a flat back) | 8→20 reps | 8 | side |
| | 4 | Roll-Down (vertebra by vertebra) | 3→8 reps | 4 | side (three-part spine) |
| | 5 | Windmill | 6→16 reps | 8 | ⚠️ front, fold + turn |
| **Joints** (Суставы) | 1 | Knee Circles | 8→20 reps | — | ⚠️ front |
| | 2 | Open the Gate (knee up and out) | 6→16 reps | 8 | front |
| | 3 | Standing Knee Hug, up on the toes | 6→16 reps | 8 | side |
| | 4 | Side Lunge | 6→16 reps | 8 | front |
| | 5 | Cossack Squat | 4→12 reps | 6 | front |
| **Arms** (Руки) | 1 | Arm Swings (hug yourself, open wide) | 10→24 reps | — | front |
| | 2 | Y Raises (leaning forward from the hips) | 8→20 reps | 10 | side |
| | 3 | Cactus Arms (elbows at 90°, rotate the shoulders) | 8→20 reps | 10 | front |
| | 4 | Inchworm (walk the hands out to a plank and back) | 3→8 reps | 4 | side |
| | 5 | Plank to Downward Dog | 4→10 reps | 5 | side |
| **Energy** (Бодрость) | 1 | Step Jacks (jumping jacks without the jump: step out, arms up) | 20→60 s | — | front |
| | 2 | Butt Kicks on the spot, soft | 20→45 s | 30 | side |
| | 3 | Standing Cross Crunch (elbow to the opposite knee) | 20→45 s | 30 | front |
| | 4 | Speed Skater without the hop | 20→45 s | 30 | ⚠️ front |
| | 5 | Slow Mountain Climbers | 20→45 s | 30 | side |

- The owner replaced shadow boxing (first proposed for Energy 1): most people do not know what it is or how to do it.
- **Common to every stage:** sets 1→2, rest 15→10 s, `spBase` 1 (as Evening Stretch).
- **Warm-up** of every branch: a new stage-0 **Morning Stretch-Up** (reach up on the toes, 5 reps). **Cool-down** of every branch: a new stage-0 **Shake-Out** (shake the arms and legs loose, 20 s) — an upbeat end, "ready for the day". The generator de-duplicates both.
- **Branch order in the workout:** unchanged — the daily rotation of `generateDailyForCourse` (owner, 2026-10-08; playing the branches in course order was offered and declined).
- **Bonus workout:** adds the two supplementary exercises like every course but Evening Stretch (owner, 2026-10-08) — `CourseCatalog.addsSupplementary` needs no change.
- **Onboarding:** all four branches start at stage 1, no calibration question.
- **Identifiers** (Hive enum values, cannot be renamed later): `CourseId.morningRoutine` (HiveField 3); `BranchId.morningSpine`, `morningJoints`, `morningArms`, `morningEnergy` (HiveFields 12–15, appended). Exercise ids `morning_<branch>_s<N>_<name>`, `warmup_morning_stretch_up`, `cooldown_shake_out`; achievements `morning_<branch>_complete` (and `all_complete` needs them).
- **Costs:** 21 new exercises (20 stages + warm-up + cool-down), each a name, a description and a tip in four languages, tags and a Lottie animation; 4 branches, 1 course, 4 branch achievements, Aurora (six faces + idle + cheer, `tools/characters/gen_hosts.py`).
- **Order of work:** (1) the four ⚠️ animations drafted first in the rig (torso twist, windmill, knee circles, speed skater) — **done, approved by the owner 2026-10-08, in `assets/`**; (2) the course, branches and exercises, texts in four languages, version 0.9.0 — **done (Change History)**; (3) Aurora — **done, approved by the owner 2026-10-08**; (4) the other 18 animations — **done, approved by the owner 2026-10-08 (the cross crunch redrawn once), in `assets/`**. The branch `0.9.0` is merged only when all of it is in.

### 2b-3. Yoga — the third new course (owner, 2026-10-08; done in 0.9.1)
- **Concept:** a ladder of harder and harder poses (the owner's 2026-10-07 decision), holds mostly, one-sided ones held on each side (§ Per-side holds). Host: **Miso** the cat. Version **0.9.1**, merged 2026-10-09 (the owner keeps 0.9.x until 1.0).
- **Reuse is allowed (owner, 2026-10-08):** exercises and whole branches may be shared with other courses (§ Decisions on courses). Yoga takes the existing **Balance** branch of Calisthenics as it is (crow, handstands; progress shared) and reuses the sphinx (Evening Stretch), the downward dog hold (`cooldown_downward_dog`), plank to dog (Morning Routine), the cat-cow (warm-up) and the lying relaxation (cool-down).
- **The branches** (agreed 2026-10-08; ↔ = on each side; the numbers are in `internal_docs/reference/courses.md` § Exercise Catalog):

| Branch | Stages |
|--------|--------|
| **Standing** (Стойки), new | chair → warrior I ↔ → warrior II ↔ → triangle ↔ → extended side angle ↔ |
| **Equilibrium** (Равновесие), new | tree ↔ → eagle ↔ → warrior III ↔ → dancer ↔ → half moon ↔ |
| **Backbends** (Прогибы), new | sphinx (reused) → locust → bridge hold → bow → camel → wheel |
| **Flow** (Поток), new | downward dog hold (reused) → plank to dog (reused) → half sun salutation → sun salutation A → B, counted in rounds |
| **Balance** (Баланс), shared with Calisthenics | single-leg stand → one-arm plank → crow prep → crow → wall handstand → free handstand |

- **Decided (owner, 2026-10-08):** the Balance branch is in; every stage as Morning Routine (sets 1→2, rest 15→10 s, `spBase` 1); the bonus workout adds the supplementary block; every new branch starts at stage 1 in the onboarding. Warm-up cat-cow, cool-down lying relaxation (both reused; Balance keeps its own wrist circles / downward dog).
- **The one-leg branch is called «Равновесие»** (owner, 2026-10-08), so the course has one «Баланс» (the shared branch); a separate branch rather than the one-leg poses at the end of Standing. Names elsewhere (drafts for the proofreaders): Equilibrium / Gleichgewicht / Estabilidad (the Spanish Balance is already «Equilibrio»). Hive name `yogaOneLeg`.
- **The camel keeps the hands on the lower back** (owner, 2026-10-08, after the stand showed both versions).
- **Order of work** (as the other courses): (1) the risky animations drafted first — eagle, half moon, camel, wheel, sun salutation A — **done 2026-10-08, in `assets/`** (the owner chose the camel version and raised nothing on the other four); (2) the course, branches and exercises with texts in four languages (0.9.1) — **done (Change History)**; (3) Miso — **done, approved by the owner 2026-10-08, in the app**; (4) the other 13 animations: chair, warrior I and II, triangle, side angle, tree, warrior III, dancer, locust, bridge, bow, half sun salutation, Sun Salutation B — **done, approved by the owner 2026-10-09, in `assets/`** (with the wheel's bridge phase fixed). The branch is merged when all of it is in.
- **Draft findings:** Goro's arms reach the heels in the camel only with the chest level behind him, which reads as a bow. The wheel is low (the torso is long next to the limbs) and starts with the hands by the shoulders rather than by the ears, or the feet could not stay planted.

### Per-side holds — done (0.8.20)
Implemented as decided; see `internal_docs/reference/workout.md` § Timed exercises (Holds on each side) and the Change History entry.

### Course hosts — decided (owner, 2026-10-08); Raffi and Luna done in 0.8.20, Aurora in 0.9.0, Miso in 0.9.1, on the achievements in 0.9.2
- **Every course gets its own host character.** Calisthenics — **Goro** (gorilla); Healthy Body — **Raffi** (giraffe: neck and posture); Evening Stretch — **Luna** (owl); Morning Routine — **Aurora** (lark: "жаворонок / сова", early bird / night owl, Lerche / Eule, alondra / búho); Yoga — **Miso** (cat). Names chosen by the owner; they read the same in RU / EN / DE / ES (Луна, Аврора, Мисо, Раффи).
- **Goro stays the coach:** the Home hero, the notifications, and he performs **every** exercise animation — no animation is redrawn for a host. **Skala stays the judge** of every course's challenge.
- **A host is static SVG art in 2–3 poses**, like Skala, in Goro's flat style (BRAND.md), drawn in-house.
- **Where a host appears:** the Home hero (with Goro's six moods) and the Profile header while its course is active (owner, 2026-10-08 — first planned as Goro's), the course cards (onboarding, Library), the summary of a workout of that course, and since 0.9.2 the achievements of its branches (`internal_docs/reference/progression.md` § Gamification). Goro keeps the icon, the onboarding welcome, notifications, the home-screen widget and About.
- **Order:** Luna with Evening Stretch, Raffi at the same time (the slot is built once); Aurora and Miso with their courses.
- **Skala is redrawn** — done in 0.8.20 (`tools/characters/gen_skala.py`, BRAND.md § Skala).
- **Bruno** (the bear demonstrator) is dropped in that role: stage previews on the Branch Journey screen can play Goro's existing animations. **Rex** (the streak monkey) is deferred — on Home it would compete with Goro, whose angry face already warns about the streak.

### 2c. More branches, also outside any course
- A branch can exist without a course: it is in the catalog and the exercise library, and the builder offers it. Nothing creates its `SkillProgress` until it is used (the onboarding only starts the branches of the chosen courses), so progress starts at stage 1 on first use.
- Same costs as above, per branch. The catalog grows in four languages from now on.

### 3. The course builder — done (0.9.3)
Built before 2c, at the owner's word (2026-10-09: "the builder now, the new exercises on the next branch"). As decided: (a) a course from existing branches, its progress shared with the built-in courses; (b) a branch of one's own, exercises in order, each a stage, the app sets the amounts and the progression ("количество повторений и прогрессия строится самим приложением", owner). The owner's choices of 2026-10-09: the host of an own course is picked from the five (Goro by default). The design that was open is settled in `internal_docs/reference/courses.md` § Courses (own courses and branches) and § CustomStages; no migration was needed (`activeCourseIds` stays, an own course is `activeCustomCourseId`). Not done on purpose: own courses in the onboarding, achievements of own branches (only `first_challenge` counts), sharing them with friends.

**Done in 0.9.5:** the many more exercises — Strong Back, Glutes, Arms & Shoulders, Cardio (`internal_docs/reference/courses.md` § Branches outside the courses). The plan was (owner, 2026-10-09): 3–4 branches outside any course (2c), about 20 exercises with animations; proposed gaps: a back without a pull-up bar (superman, prone Y-T-W, reverse snow angels…), glutes (donkey kicks, fire hydrants, single-leg bridge, hip thrust), arms and shoulders without equipment (chair dips, pike push-ups, shoulder taps), cardio. Content to be agreed with the owner first; the builder lists new branches by itself (a group "other branches" will be needed for branches outside the courses).
