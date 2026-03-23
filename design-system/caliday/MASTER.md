# Design System Master File

> **LOGIC:** When building a specific page, first check `design-system/pages/[page-name].md`.
> If that file exists, its rules **override** this Master file.
> If not, strictly follow the rules below.

---

**Project:** CaliDay
**Generated:** 2026-03-23 12:02:47
**Category:** Fitness/Gym App — Flutter (iOS primary, Android secondary)

> **CaliDay Override:** This is a Flutter app, not a web app. CSS variables and web CSS snippets below are
> **reference only**. Actual implementation uses `lib/core/theme/app_theme.dart` (AppTheme).
> Use the "CaliDay Brand Overrides" section below instead of the generic palette.

---

## CaliDay Brand Overrides (use these, not the generic palette below)

| Role | AppTheme Token | HEX | Usage |
|------|---------------|-----|-------|
| Primary | `AppTheme.brandBlue` | `#4DA6FF` | Buttons, hero zone, accents |
| Primary Dark | `AppTheme.brandBlueDark` | `#2B7DE9` | Gradient stop, pressed states |
| Primary Deep | `AppTheme.brandBlueDeep` | `#1A5FA8` | Gradient bottom stop, hero bg |
| Energy (streak) | `AppTheme.energy` | `#FF9500` | Streak counter, fire icon |
| Success | `AppTheme.success` | `#34C759` | Workout done, progress |
| Challenge bg | — | `#5C1A1A` | Skala (bull) screen only |
| Energy container light | `AppTheme.energyContainer` | `#FFF0D9` | Streak cell bg (light mode) |
| Energy container dark | `AppTheme.energyContainerDark` | `#3D2800` | Streak cell bg (dark mode) |

**Typography:** Flutter system fonts (San Francisco on iOS, Roboto on Android).
Recommended future direction: `Barlow Condensed` (headings) + `Barlow` (body) — athletic, energetic feel.
To apply: add `google_fonts` package and reference in `AppTheme`.

**Gradients:** `AppTheme.heroGradient` (brandBlue → brandBlueDeep), `AppTheme.rankGradient` (brandBlue → brandBlueDark)

**Shadows:** `AppTheme.cardShadowLight` / `AppTheme.cardShadowDark`

---

## Global Rules (generic template — see overrides above for Flutter/CaliDay specifics)

### Color Palette

| Role | Hex | CSS Variable |
|------|-----|--------------|
| Primary | `#2563EB` | `--color-primary` |
| Secondary | `#3B82F6` | `--color-secondary` |
| CTA/Accent | `#F97316` | `--color-cta` |
| Background | `#F8FAFC` | `--color-background` |
| Text | `#1E293B` | `--color-text` |

**Color Notes:** Energy orange + success green

### Typography

- **Heading Font:** Barlow Condensed
- **Body Font:** Barlow
- **Mood:** sports, fitness, athletic, energetic, condensed, action
- **Google Fonts:** [Barlow Condensed + Barlow](https://fonts.google.com/share?selection.family=Barlow+Condensed:wght@400;500;600;700|Barlow:wght@300;400;500;600;700)

**CSS Import:**
```css
@import url('https://fonts.googleapis.com/css2?family=Barlow+Condensed:wght@400;500;600;700&family=Barlow:wght@300;400;500;600;700&display=swap');
```

### Spacing Variables

| Token | Value | Usage |
|-------|-------|-------|
| `--space-xs` | `4px` / `0.25rem` | Tight gaps |
| `--space-sm` | `8px` / `0.5rem` | Icon gaps, inline spacing |
| `--space-md` | `16px` / `1rem` | Standard padding |
| `--space-lg` | `24px` / `1.5rem` | Section padding |
| `--space-xl` | `32px` / `2rem` | Large gaps |
| `--space-2xl` | `48px` / `3rem` | Section margins |
| `--space-3xl` | `64px` / `4rem` | Hero padding |

### Shadow Depths

| Level | Value | Usage |
|-------|-------|-------|
| `--shadow-sm` | `0 1px 2px rgba(0,0,0,0.05)` | Subtle lift |
| `--shadow-md` | `0 4px 6px rgba(0,0,0,0.1)` | Cards, buttons |
| `--shadow-lg` | `0 10px 15px rgba(0,0,0,0.1)` | Modals, dropdowns |
| `--shadow-xl` | `0 20px 25px rgba(0,0,0,0.15)` | Hero images, featured cards |

---

## Component Specs

### Buttons

```css
/* Primary Button */
.btn-primary {
  background: #F97316;
  color: white;
  padding: 12px 24px;
  border-radius: 8px;
  font-weight: 600;
  transition: all 200ms ease;
  cursor: pointer;
}

.btn-primary:hover {
  opacity: 0.9;
  transform: translateY(-1px);
}

/* Secondary Button */
.btn-secondary {
  background: transparent;
  color: #2563EB;
  border: 2px solid #2563EB;
  padding: 12px 24px;
  border-radius: 8px;
  font-weight: 600;
  transition: all 200ms ease;
  cursor: pointer;
}
```

### Cards

```css
.card {
  background: #F8FAFC;
  border-radius: 12px;
  padding: 24px;
  box-shadow: var(--shadow-md);
  transition: all 200ms ease;
  cursor: pointer;
}

.card:hover {
  box-shadow: var(--shadow-lg);
  transform: translateY(-2px);
}
```

### Inputs

```css
.input {
  padding: 12px 16px;
  border: 1px solid #E2E8F0;
  border-radius: 8px;
  font-size: 16px;
  transition: border-color 200ms ease;
}

.input:focus {
  border-color: #2563EB;
  outline: none;
  box-shadow: 0 0 0 3px #2563EB20;
}
```

### Modals

```css
.modal-overlay {
  background: rgba(0, 0, 0, 0.5);
  backdrop-filter: blur(4px);
}

.modal {
  background: white;
  border-radius: 16px;
  padding: 32px;
  box-shadow: var(--shadow-xl);
  max-width: 500px;
  width: 90%;
}
```

---

## Style Guidelines

**Style:** Vibrant & Block-based

**Keywords:** Bold, energetic, playful, block layout, geometric shapes, high color contrast, duotone, modern, energetic

**Best For:** Startups, creative agencies, gaming, social media, youth-focused, entertainment, consumer

**Key Effects:** Large sections (48px+ gaps), animated patterns, bold hover (color shift), scroll-snap, large type (32px+), 200-300ms

### Page Pattern

**Pattern Name:** App Store Style Landing

- **Conversion Strategy:** Show real screenshots. Include ratings (4.5+ stars). QR code for mobile. Platform-specific CTAs.
- **CTA Placement:** Download buttons prominent (App Store + Play Store) throughout
- **Section Order:** 1. Hero with device mockup, 2. Screenshots carousel, 3. Features with icons, 4. Reviews/ratings, 5. Download CTAs

---

## Anti-Patterns (Do NOT Use)

- ❌ Static design
- ❌ No gamification

### Additional Forbidden Patterns

- ❌ **Emojis as icons** — Use SVG icons (Heroicons, Lucide, Simple Icons)
- ❌ **Missing cursor:pointer** — All clickable elements must have cursor:pointer
- ❌ **Layout-shifting hovers** — Avoid scale transforms that shift layout
- ❌ **Low contrast text** — Maintain 4.5:1 minimum contrast ratio
- ❌ **Instant state changes** — Always use transitions (150-300ms)
- ❌ **Invisible focus states** — Focus states must be visible for a11y

---

## Pre-Delivery Checklist

Before delivering any UI code, verify:

- [ ] No emojis used as icons (use SVG instead)
- [ ] All icons from consistent icon set (Heroicons/Lucide)
- [ ] `cursor-pointer` on all clickable elements
- [ ] Hover states with smooth transitions (150-300ms)
- [ ] Light mode: text contrast 4.5:1 minimum
- [ ] Focus states visible for keyboard navigation
- [ ] `prefers-reduced-motion` respected
- [ ] Responsive: 375px, 768px, 1024px, 1440px
- [ ] No content hidden behind fixed navbars
- [ ] No horizontal scroll on mobile
