# Home Screen — Design Rules

> **PROJECT:** CaliDay
> **Screen:** Home (main tab, daily entry point)
> **Last updated:** 2026-03-23
>
> Rules here **override** `design-system/caliday/MASTER.md`.
> For anything not covered here, refer to MASTER.md.

---

## Screen Purpose

The Home screen is the **daily emotional hub** of the app.
The user opens it every day. It must:
1. Instantly communicate state (streak, SP, rank)
2. Show Goro's emotional reaction to the user's activity
3. Present one clear primary CTA — start today's workout

---

## Layout Structure

```
┌────────────────────────────────┐
│  HERO ZONE (gradient bg)       │
│  "CaliDay" title               │
│  Stat chips: streak / SP / rank│
│  Goro SVG (200px, centered)    │
└────────────────────────────────┘
         rounded bottom corners (r=32)
         shadow: brandBlue.withAlpha(50–60)

┌────────────────────────────────┐
│  [Done banner — if workout ✓]  │
│  (spacer)                      │
│  CTA Button (bottom)           │
│  bottom padding: 32px          │
└────────────────────────────────┘
```

---

## Hero Zone

**Background:** `AppTheme.heroGradient` — `LinearGradient(brandBlue → brandBlueDeep)`, top-left → bottom-right

**Corners:** only bottom-left and bottom-right rounded (r=32). Full-bleed at top (status bar).

**Shadow:** `BoxShadow(color: brandBlue.withAlpha(isDark ? 60 : 50), blurRadius: 24, offset: (0, 8))`

**Top padding:** `MediaQuery.padding.top + 16` (safe area under notch / Dynamic Island)

**Goro:** `AnimatedSwitcher` (400ms), SVG height = 200, centered. Expression driven by `GoroExpressionProvider`.

### Goro expressions and their triggers

| Expression | Trigger |
|------------|---------|
| `sleeping` | 23:00–06:00 |
| `happy` | Workout done today |
| `angry` | Streak at risk (22h+ no workout, streak>0) |
| `sad` | Evening (20h+), no workout |
| `supportive` | Days since last workout ≥ 2 |
| `happy` (default) | Otherwise |

### Stat chips

Three chips in a `Row`, glass style on blue background:

```
color: Colors.white.withAlpha(30)
border: Colors.white.withAlpha(50), 1px
borderRadius: 14
padding: 14h × 10v
```

| Chip | Icon | Value | Color |
|------|------|-------|-------|
| Streak | `Icons.local_fire_department` | N days | `AppTheme.energy` (#FF9500) — orange |
| SP | `Icons.bolt` | N SP | `Colors.white` |
| Rank | `Icons.military_tech` | rank name | `Colors.white` |

**Streak chip is always orange** — this is the primary energy signal on the screen.

---

## Done Banner (conditional)

Shown only when `data.hasWorkoutToday == true`.

```
background: AppTheme.success.withAlpha(20)
border: AppTheme.success.withAlpha(60), 1px
borderRadius: 14
icon: Icons.check_circle_rounded, color: AppTheme.success
```

Text: `l10n.homeWorkoutDone`

---

## CTA Button

**Primary (no workout today):** gradient button — `DecoratedBox` + `Material` + `InkWell`

```
gradient: LinearGradient(brandBlue → brandBlueDark)
borderRadius: 20
shadow: brandBlue.withAlpha(80), blurRadius 16, offset (0,6)
height: 64
```

Text: `l10n.homeWorkoutStart`, white, 17sp, w700
Icon: `Icons.fitness_center`, white, 22px

**Secondary (workout done, want another):** `FilledButton` with `secondaryContainer` color

```
backgroundColor: scheme.secondaryContainer
foregroundColor: scheme.onSecondaryContainer
borderRadius: 20
height: 64
```

Icon: fitness_center with a `+` badge (primary color circle, 14×14)
Text: `l10n.homeWorkoutAgain`, 17sp, w700

---

## Anti-patterns for this screen

- ❌ Flat solid background — always use the gradient hero zone
- ❌ Streak number in white — must be orange (`AppTheme.energy`)
- ❌ Goro smaller than 180px — hero should feel large and welcoming
- ❌ CTA as a flat `FilledButton` for the primary state — must feel energetic (gradient + shadow)
- ❌ Hardcoded colors outside AppTheme tokens
- ❌ Missing `AnimatedSwitcher` on Goro — expression changes must animate

---

## Goro Brand Notes (from design concept)

- Body: `#38384C` dark grey with purple undertone
- Headband: `#A8D8FF` light blue — brand accent
- Flat design, no outlines, large expressive eyes
- The mascot is the emotional core of the screen — it must be prominent

---

## Future Enhancements (backlog)

- **v2.0 Liquid Glass (iOS):** Replace gradient hero with a frosted glass / Liquid Glass material.
  On Android: semi-transparent frosted glass without blur. See DEV_NOTES.md spec.
- **Goro tap interaction:** Tap Goro to trigger a mini reaction animation (idea stage)