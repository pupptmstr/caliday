# CaliDay — Brand & Character Reference

> This file consolidates `internal_docs/design-concept/caliday_design_concept.md` (characters, colors, assets)
> with the UX style direction from `MASTER.md` (Vibrant & Block-based).
> Use this as the **single source of truth** when making visual decisions.

---

## Design Philosophy

**Style:** Vibrant & Block-based — bold, energetic, gamified. No flat/static visuals.

**Core principle:** The app must *feel* alive. Goro reacts to the user's state,
streaks glow orange, rank cards feel like earned badges, workout CTA must feel urgent and energetic.

**Avoid:** grey, flat, weightless. Every element should have depth or color emphasis.

---

## Color System

All implemented in `lib/core/theme/app_theme.dart`.

### Brand Colors

| Role | Token | HEX | When to use |
|------|-------|-----|------------|
| Primary | `AppTheme.brandBlue` | `#4DA6FF` | Buttons, hero zone, gradient start |
| Primary Dark | `AppTheme.brandBlueDark` | `#2B7DE9` | Gradient mid-stop, active states |
| Primary Deep | `AppTheme.brandBlueDeep` | `#1A5FA8` | Gradient bottom, hero shadow |
| Primary Light | — | `#A8D8FF` | Goro's headband (asset only) |
| Energy (streak) | `AppTheme.energy` | `#FF9500` | Always: streak numbers, fire icons |
| Success | `AppTheme.success` | `#34C759` | Workout done, progress complete |

### Semantic Contexts

| Element | Color | Rationale |
|---------|-------|-----------|
| Streak counter | Orange `#FF9500` | Fire / energy — most important daily metric |
| CTA button (primary) | Gradient brandBlue→brandBlueDark | Must feel energetic, not flat |
| Rank card | Gradient brandBlue→brandBlueDark | Earned badge feel |
| Done banner | Success green | Positive reinforcement |
| Challenge screen bg | `#5C1A1A` dark red | Arena feel, contrasts with Goro's blue |
| Streak cell bg (light) | `AppTheme.energyContainer` `#FFF0D9` | Warm orange tint |
| Streak cell bg (dark) | `AppTheme.energyContainerDark` `#3D2800` | Dark warm orange |

---

## Mascot System

### Goro (main mascot)

**Role:** Coach and mentor. Friendly, encouraging. The emotional core of the app.

**Visual:**
- Body: `#38384C` (dark grey with purple undertone), `#424258` highlights
- Face: `#C4A882` (upper) → `#A8896A` (lower)
- Headband: `#A8D8FF` light blue — brand accent
- Style: flat design, no outlines, large expressive eyes, simplified anatomy

**Why a gorilla:** calisthenics animal, powerful yet friendly, great silhouette at any size.

**Poses:**

| Pose | File | Usage |
|------|------|-------|
| Face expressions | `goro_face_[happy/sad/angry/sleeping/excited/supportive].svg` | Home screen hero |
| Flex | `goro_flex_v2.svg` | Summary screen, promo |
| Idle | `goro_idle_v2.svg` | Profile, About, Settings |

### Goro Expression System

| Expression | Trigger condition |
|------------|-----------------|
| `happy` | Workout done today OR default |
| `sleeping` | 23:00–06:00 |
| `angry` | Streak at risk (22h+ no workout, streak > 0) |
| `sad` | Evening (20h+), no workout today |
| `excited` | New achievement / rank up |
| `supportive` | Days since last workout ≥ 2 |

**Implementation:** `GoroExpressionProvider` in `lib/core/providers/goro_expression_provider.dart`.
The Home screen uses `AnimatedSwitcher` (400ms) to transition between expressions.

### Skala (challenge host)

**Role:** Strict but fair. Commands respect. Appears only on the Challenge screen.

**Visual:**
- Body: `#2E2A22` (dark), `#3D3728` / `#4A4232` (light)
- Horns: `#8B7355` → `#A89060`
- Background: `#5C1A1A` → `#3A0C0C` (dark red — arena feel)

**To be redrawn (owner, 2026-10-08):** today Skala is Goro's head and body recoloured, with thin loop horns. It must read as a bull: broad flat forehead with a forelock, thick horns from the sides of the head, ears sideways below them, wide muzzle with big nostrils (keep the nose ring), small eyes under heavy brows, massive hump, no neck. Same two poses and file names.

### Course hosts (decided 2026-10-08, not yet drawn)

Every course has its own host — static flat art in 2–3 poses, like Skala — shown on the course cards (onboarding, Library), the summary of that course's workouts and its achievements. **Goro stays the coach** (Home hero, notifications) and **performs every exercise animation**; Skala stays the judge of every challenge.

| Host | Animal | Course |
|------|--------|--------|
| Goro | Gorilla | Calisthenics |
| Raffi | Giraffe | Healthy Body |
| Luna | Owl | Evening Stretch |
| Aurora | Lark | Morning Routine |
| Miso | Cat | Yoga |

Spec: `internal_docs/DEV_NOTES.md` § Course hosts.

### Other character ideas

- **Bruno** (bear, technique demonstrator): dropped in that role — stage previews on the Branch Journey screen will play Goro's animations
- **Rex** (small monkey): streak motivator concept, deferred

---

## Typography Direction

**Current:** System fonts — SF Pro (iOS), Roboto (Android).

**Recommended direction (future):** `Barlow Condensed` (headings) + `Barlow` (body)
— sports / athletic / energetic feel. To apply: add `google_fonts` package, update `AppTheme`.

**Type scale in use:**
- Display numbers (stats): 26sp, w900
- Rank name: 24sp, w900
- App title "CaliDay": 28sp, w900
- Button labels: 17sp, w700
- Body / labels: 14–16sp, w400–w600

---

## Animation System

**Goro exercise animations:** 65 Lottie JSON files, format `assets/animations/[exercise_id].json`.
Canvas: 400×400px, 2–4s seamless loop. Flat style matching Goro's colors.

**UI transitions:**
- Goro expression change: `AnimatedSwitcher` 400ms
- Standard micro-interactions: 150–300ms
- Spring physics preferred over linear easing

**Lottie status:** Push, Core, Pull, Legs, Balance ✅; Flex ✅ except 90/90 (intentionally no animation). Supplementary pool ✅ (9/9). Posture ✅ except pigeon (intentionally no animation; dead bug and kneeling lunge reuse existing files). Neck ✅ (6/6). The cat-cow cooldown was replaced by a generated one and the Pull animations (except `pull_s1_australian`) were redrawn with `tools/lottie` ; the review of the oldest designer files (2026-10) also redrew Push s4–s7 (side view like s1–s3, hand placement in a top-down inset, handstand back to the wall), the quad stretch, and fixed / animated the dog, L-sit and the balance holds. Flex, the supplementary pool, Posture, Neck and the cat-cow were generated with `tools/lottie` (see ARCHITECTURE.md § Lottie Animation Tooling); `supp_oblique_crunch` is drawn from above, the only top-down animation; `tools/lottie/frontview.py` draws the standing front views (hip march and four of the Neck animations).

---

## Gradients

| Name | Token | Direction | Colors |
|------|-------|-----------|--------|
| Hero zone | `AppTheme.heroGradient` | top-left → bottom-right | brandBlue → brandBlueDeep |
| Rank card | `AppTheme.rankGradient` | top-left → bottom-right | brandBlue → brandBlueDark |
| App icon bg | — | top-left → bottom-right | `#4DA6FF` → `#2B7DE9` |

---

## App Icon

- Primary: Goro's face close-up (fills full frame, no neck/body)
- `assets/icon/icon.png` — 1024×1024, opaque background
- `assets/icon/icon_foreground.png` — transparent background (Android adaptive)
- Adaptive background color: `#4DA6FF`

---

## Key Anti-Patterns (brand violations)

- ❌ Orange streak color replaced with blue or grey
- ❌ Goro missing or too small on Home (min 180px, ideally 200px)
- ❌ Flat CTA button without gradient and shadow
- ❌ Rank card without gradient — must feel like a badge
- ❌ Challenge screen without `#5C1A1A` dark red background
- ❌ All stat cells same color — streak must stand out
- ❌ Emoji as UI icons (use Material Icons or SVG)
- ❌ Static design — animations/transitions are part of the brand feel

