---
name: Aether HUD
colors:
  surface: '#1a0b2e'
  surface-dim: '#1a0b2e'
  surface-bright: '#413257'
  surface-container-lowest: '#150629'
  surface-container-low: '#231437'
  surface-container: '#27183b'
  surface-container-high: '#322346'
  surface-container-highest: '#3d2e52'
  on-surface: '#eddcff'
  on-surface-variant: '#b9cacb'
  inverse-surface: '#eddcff'
  inverse-on-surface: '#38294d'
  outline: '#849495'
  outline-variant: '#3b494b'
  surface-tint: '#00dbe9'
  primary: '#dbfcff'
  on-primary: '#00363a'
  primary-container: '#00f0ff'
  on-primary-container: '#006970'
  inverse-primary: '#006970'
  secondary: '#ffb692'
  on-secondary: '#552000'
  secondary-container: '#ff7009'
  on-secondary-container: '#5a2200'
  tertiary: '#fff2ff'
  on-tertiary: '#4e0078'
  tertiary-container: '#efceff'
  on-tertiary-container: '#9300dc'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#7df4ff'
  primary-fixed-dim: '#00dbe9'
  on-primary-fixed: '#002022'
  on-primary-fixed-variant: '#004f54'
  secondary-fixed: '#ffdbcb'
  secondary-fixed-dim: '#ffb692'
  on-secondary-fixed: '#341100'
  on-secondary-fixed-variant: '#793100'
  tertiary-fixed: '#f4d9ff'
  tertiary-fixed-dim: '#e5b5ff'
  on-tertiary-fixed: '#30004b'
  on-tertiary-fixed-variant: '#7000a8'
  background: '#1a0b2e'
  on-background: '#eddcff'
  surface-variant: '#3d2e52'
typography:
  headline-lg:
    fontFamily: Space Grotesk
    fontSize: 34px
    fontWeight: '700'
    lineHeight: 40px
    letterSpacing: -0.02em
  headline-lg-mobile:
    fontFamily: Space Grotesk
    fontSize: 28px
    fontWeight: '700'
    lineHeight: 34px
    letterSpacing: -0.02em
  headline-md:
    fontFamily: Space Grotesk
    fontSize: 22px
    fontWeight: '600'
    lineHeight: 28px
    letterSpacing: -0.01em
  headline-sm:
    fontFamily: Space Grotesk
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 24px
    letterSpacing: 0em
  body-lg:
    fontFamily: Sora
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
    letterSpacing: 0em
  body-md:
    fontFamily: Sora
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
    letterSpacing: 0.01em
  body-sm:
    fontFamily: Sora
    fontSize: 12px
    fontWeight: '300'
    lineHeight: 16px
    letterSpacing: 0.01em
  label-lg:
    fontFamily: JetBrains Mono
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 18px
    letterSpacing: 0.06em
  label-md:
    fontFamily: JetBrains Mono
    fontSize: 11px
    fontWeight: '500'
    lineHeight: 14px
    letterSpacing: 0.08em
  label-sm:
    fontFamily: JetBrains Mono
    fontSize: 9px
    fontWeight: '500'
    lineHeight: 12px
    letterSpacing: 0.12em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  gutter: 1rem
  margin: 1rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 0.75rem
  space-lg: 1.25rem
  space-xl: 2rem
---

## Brand & Style

This design system expresses a high-velocity, sensory-rich gaming operating environment tailored for modern Android handhelds. It converges refractive glassmorphism with dynamic tactical HUD ergonomics. 

- **Personality:** Hyper-modern, analytical, kinetic, and immersive. It replaces mundane utility panels with luminous, refractive optical surfaces that mimic liquid acrylic suspended in low-gravity deep space.
- **Target Audience:** Competitive mobile gamers, hardware tuners, and power users seeking tactile telemetry, low-latency responsiveness, and rich sci-fi immersion.
- **Emotional Response:** High situational awareness, precision control, and high-tech empowerment.
- **Design Style:** Liquid Glassmorphism meets Industrial Cybernetic HUD. Key visual anchors include deep optical blurs, ultra-crisp hairline specular rim-lighting, atmospheric chromatic glows, and high-legibility geometric technical typography.

## Colors

The palette operates in a pitch-black substrate punctuated by deep violet depth, vivid ion-charged cyan, and tactical combustion orange.

- **Deep Space Base (`#1a0b2e`):** The primary canvas substrate. Used as an ultra-deep, saturated violet canvas foundation that prevents pure black dead space while providing chromatic anchoring for translucent glass layers.
- **Electric Cyan (`#00f0ff`):** The primary kinetic signal. Represents systems online, active telemetry, critical affirmative states, energy meters, and navigational conduits.
- **Valve Amber (`#ff6e00`):** The operational and hazard beacon. Dictates aggressive actions, mission alerts, thermal throttles, warnings, and high-priority tactical triggers.
- **Atmospheric Void Tiers:**
  - `surface-canvas`: `#0a0414` (Deep absolute floor)
  - `surface-glass-low`: `rgba(26, 11, 46, 0.45)` with 16px blur
  - `surface-glass-mid`: `rgba(38, 16, 68, 0.55)` with 24px blur
  - `surface-glass-high`: `rgba(58, 25, 102, 0.65)` with 32px blur
- **Specular Rim Colors:**
  - `specular-edge-ambient`: `rgba(255, 255, 255, 0.12)`
  - `specular-edge-active`: `linear-gradient(135deg, rgba(0, 240, 255, 0.6) 0%, rgba(255, 255, 255, 0.2) 50%, rgba(255, 110, 0, 0.4) 100%)`
  - `specular-highlight`: `rgba(255, 255, 255, 0.85)` (0.5px directional refraction line)

## Typography

The type system draws from airborne radar instruments and cockpit heads-up displays, balancing technical density with immediate mobile glanceability.

- **Headlines (Space Grotesk):** Geometric, angular, and structured. In uppercase tracking, it gives a command-deck authority; in sentence case, it maintains an urgent, tech-forward cadence.
- **Body Text (Sora):** High x-height, clear circular apertures, and pristine clarity against variable-blur backdrops. Ensures uncompromised legibility over high-contrast glass gradients.
- **Technical & HUD Labels (JetBrains Mono):** Precise telemetry figures, coordinate grids, status toggles, frame counters, and load metrics. All micro-labels default to uppercase with extended tracking (`letterSpacing: 0.08em` to `0.12em`) to retain legibility at tiny physical dimensions on OLED mobile screens.

## Layout & Spacing

This design system employs an Android mobile-first, thumb-zone optimized responsive layout based on a compact 4-column dynamic grid on portrait handhelds and an 8-column split-view grid for foldables and landscape orientations.

- **Rhythm & Grid:** Built on an absolute 4px sub-grid with an 8px standard rhythm. Layout margins conform to Android safe areas (display cutouts, gesture bars, and curved corners).
- **Safe Area Insets:** Outer margins enforce a minimum `16px` (`margin`) clear boundary, expanding dynamically to avoid punch-hole cameras and pill cutouts.
- **Information Density:** Compact vertical hierarchy designed for low scroll fatigue during high-intensity usage. Element gaps default to `space-md` (`12px`) to maximize physical touch target areas while preserving spatial containment within frosted boundaries.

## Elevation & Depth

Visual hierarchy does not use standard drop shadows; it relies on refractive optical science, simulated acrylic transmission, and atmospheric plasma light fields.

- **Refractive Backdrops:**
  - *Tier 0 (Background Canvas):* Deep saturated base (`#0a0414`) with ambient radial ion blooms (`rgba(0, 240, 255, 0.08)` and `rgba(255, 110, 0, 0.06)`).
  - *Tier 1 (Panels & Shells):* Frosted acrylic fill `rgba(26, 11, 46, 0.45)`, `backdrop-filter: blur(16px) saturate(180%)`.
  - *Tier 2 (Floating Trays & Modals):* High-density fluid fill `rgba(38, 16, 68, 0.60)`, `backdrop-filter: blur(28px) saturate(200%)`.
- **Specular Hairline Borders:**
  - Every surface is bound by a `1px` (or `0.5dp` where hardware permits) inner border.
  - Border orientation simulates a dynamic top-left light incidence: a sharp gradient transition from `rgba(255, 255, 255, 0.35)` to `rgba(255, 255, 255, 0.03)` at the bottom-right.
- **Neon Luminescence:**
  - Interactive nodes cast dual-phase diffuse halos: an inner core glow (`0 0 10px rgba(0, 240, 255, 0.6)`) coupled with an ultra-soft atmospheric bleed (`0 0 32px rgba(0, 240, 255, 0.2)`).
  - Amber alerts emit aggressive localized scattering (`0 0 14px rgba(255, 110, 0, 0.7)`).

## Shapes

The geometry balances organic liquid curvature with engineered precision. Surfaces adopt smooth squircle curvature that matches ergonomic mobile chassis corners.

- **Base Radius:** `0.5rem` (`8px`) for micro elements, inputs, telemetry badges, and nested chips.
- **Large Radius (`rounded-lg`):** `1rem` (`16px`) for primary cards, cockpit modules, and utility drawers.
- **Extra Large Radius (`rounded-xl`):** `1.5rem` (`24px`) for full-bleed modal sheets, overlay dialogs, and HUD command anchors.
- **Chamfered Nuance:** Strategic micro-components (such as active state badges or status triggers) incorporate a 45-degree angled corner accent to punctuate the liquid geometry with tactical cybernetic identity.

## Components

### Buttons
- **Primary Cybernetic (Electric Cyan):** Background is a fluid horizontal gradient from `rgba(0, 240, 255, 0.25)` to `rgba(0, 240, 255, 0.1)`. Bound by a 1px specular cyan rim (`#00f0ff`). Inner text rendered in bright white with a faint neon drop-glow. Box shadow features a sustained `0 0 16px rgba(0, 240, 255, 0.35)`. Press state triggers a liquid fill pulse to `rgba(0, 240, 255, 0.45)`.
- **Tactical Action (Valve Amber):** Reserved for destructive, override, or urgent triggers. Layered amber glass fill (`rgba(255, 110, 0, 0.25)`), bound by `1px solid #ff6e00` with `0 0 18px rgba(255, 110, 0, 0.4)`.
- **Ghost HUD (Secondary):** Deep violet glass (`rgba(26, 11, 46, 0.5)`), neutral hairline border (`rgba(255, 255, 255, 0.15)`), active hover/touch blooms into electric cyan.

### Cards & Telemetry Pods
- Multi-layered frosted containers. Acrylic base blurred at `20px`. The upper boundary features a crisp 0.5px white highlight mimicking internal edge refraction. Interior layout uses structural technical dividers rendered in `rgba(0, 240, 255, 0.1)`.

### Chips & Badges
- Ultra-compact capsules with `JetBrains Mono` text (`label-sm`).
- Bordered in variable luminescence: passive states use `rgba(255, 255, 255, 0.1)`; active metrics glow in high-contrast cyan or amber, paired with a miniature pulsing status node.

### Inputs & Sliders
- **Text Inputs:** Recessed dark glass wells (`rgba(10, 4, 20, 0.7)`), inset specular shadow along the top edge, and a focused state that drives the border into a vivid cyan neon highlight with an ambient glow. Placeholder styled with muted violet mono-type.
- **Sliders & Dial Trackers:** Tracks rendered as illuminated energy tubes with internal cyan fluid gradients. The scrub thumb is a floating refractive sphere with a 3D isometric neon core.

### Checkboxes & Switches
- **Switches:** Pill-shaped glass enclosure with an offset glowing orb. The active state charges the track with an amber-cyan plasma conduit while the thumb emits an electric cyan halo.
- **Checkboxes:** Angled squircle glass frames. When checked, filled with an electric cyan core containing a sharp, high-contrast black vector checkmark.

### 3D Neon Glass Icons
- System icons are composed of multi-planar strokes and extruded translucent forms. Foreground strokes hold full-chroma cyan or amber neon luminance, casting soft colored reflections across the frosted background surfaces behind them.