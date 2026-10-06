# Profile Screen — Design Rules

> **PROJECT:** CaliDay
> **Screen:** Profile (stats, rank, achievements tab)
> **Last updated:** 2026-10-06
>
> Rules here **override** `design-system/caliday/MASTER.md`.

---

## Screen Purpose

The Profile screen shows the user's progress snapshot:
rank, SP total, workout stats, streak record, achievements and a heatmap of the recent history.
It is read-heavy — the goal is **data at a glance with visual reward feeling**.

---

## Layout Structure

```
┌────────────────────────────────┐
│  Goro idle (h=100, centered)   │
│  Display name (if set)         │
├────────────────────────────────┤
│  _RankCard (gradient bg)       │
│  rank icon + name + SP + bar   │
├────────────────────────────────┤
│  _StatsGrid (one row of 4)     │
│  streak|record|workouts|freezes│
├────────────────────────────────┤
│  Friends count (if any)        │
├────────────────────────────────┤
│  Achievements row (scrollable) │
├────────────────────────────────┤
│  History: CompactHeatmap       │
│  (13×7) + "Open →" + last 5    │
│  workout tiles                 │
└────────────────────────────────┘
```

---

## Rank Card

**Background:** `AppTheme.rankGradient` — `LinearGradient(brandBlue → brandBlueDark)`

**Decayed rank:** the card shows the *effective* rank (what the user is currently rated) with an amber warning icon when it is lower than the earned one; tapping opens `showRankInfoSheet()`.

**Text:** white throughout. Rank name: 24sp, w900. SP value: 20sp, w700.

**Rank icon:** in a semi-transparent white box (`Colors.white.withAlpha(40)`), size 32.

**Progress bar:** `LinearProgressIndicator`, white with reduced opacity track.

**Shadow:** `AppTheme.cardShadowLight` / `AppTheme.cardShadowDark`

---

## Stats Grid (one row of four cells)

Each `_StatCell`:
- Value (number): **26sp, w900** — large display type, dominant visual
- Label: 12sp, secondary color
- Shadow: `AppTheme.cardShadowLight/Dark`
- BorderRadius: 16

### Streak cell — always orange

```
isStreak: true → special treatment:
  background: AppTheme.energyContainer (light) / energyContainerDark (dark)
  value color: AppTheme.energy
  icon color: AppTheme.energy
  icon: Icons.local_fire_department
```

### Other cells

- Normal `surfaceContainerHighest` background
- Icon and value in `colorScheme.onSurface`

| Cell | Icon | Value |
|------|------|-------|
| Streak | `local_fire_department` | current streak (orange) |
| Record | `emoji_events` | best streak |
| Workouts | `fitness_center` | total workouts |
| Freezes | `ac_unit` | remaining freezes |

---

## Anti-patterns for this screen

- ❌ All stat cells the same color — streak must visually stand out in orange
- ❌ Small numbers (< 20sp) for stats — numbers are the primary content, make them big
- ❌ Flat rank card (no gradient) — rank should feel like a reward/badge
- ❌ Missing shadows on cards — profile feels flat and cheap without depth

