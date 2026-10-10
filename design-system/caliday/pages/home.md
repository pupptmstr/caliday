# Home Screen — Design Rules

> **PROJECT:** CaliDay
> **Screen:** Home (main tab, daily entry point)
> **Last updated:** 2026-10-10 (the middle and the folded plan, 0.9.4)
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
│  MIDDLE (scrolls)              │
│  before the 1st workout today: │
│    host's line (bubble ↑ host) │
│    [challenge card if open]    │
│    Next goals (rank, nearest   │
│      achievement)              │
│    Branches (animation, stage) │
│  after it:                     │
│    Workout history (3, "All")  │
│    Progress today (growth)     │
├────────────────────────────────┤
│  CTA Button  ─────────────│ ^ │  ← narrow arrow strip unfolds the plan upwards
│  Custom workout button         │
└────────────────────────────────┘
```

**The middle** is the owner's pick (2026-10-10) among the options of DEV_NOTES § Next ideas 3: before the first workout of the day the host's line (a speech bubble with its tail pointing up at the host in the hero — never a second portrait of the host), an unlocked challenge (tertiary card, next stage's animation, norm, Skala, "Accept challenge"), the next goals and the course's branches; after it the last three workouts and how the branches grew today. No week row: the calendar is one tap on the streak chip. Cards have the shadow of BRAND.md. Details: ARCHITECTURE § Home: the middle and the plan.

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

**All three chips are tappable** (they get a slightly stronger fill): streak → `/calendar`, SP → recent-workout history sheet, rank → `showRankInfoSheet()`.

**Value text:** the streak chip reads "1 day" / "5 days" through the plural message `homeStreakDays`. Each chip is only ~105 px wide on a 375 px phone, so the text is `Flexible` + `FittedBox(scaleDown)` — a long rank name shrinks instead of overflowing.

**Decayed rank:** when the rank is shown lower because of inactivity (21+ days), the rank chip shows the *effective* rank with an amber icon / text (`Colors.amber.shade300`). The same sheet explains it.

---

## Done Banner — removed in 0.9.4

The history and "Progress today" show that the workout is done; the host's happy face says it too.

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

**The folded plan (both states):** a 52 px strip at the right end of the button, behind a 1 px divider (`fg` at alpha 70), with an up arrow that turns over when open. It unfolds the plan above the label inside the same button: a `surface` card with a row per exercise (44 px animation, name, amount). Always folded when Home opens and after a start; its height is bounded by the free space, the list scrolls.

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

- **Goro tap interaction:** Tap Goro to trigger a mini reaction animation (idea stage)
