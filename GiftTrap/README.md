# GiftTrap — animated gift prank

A self-contained Arabic prank page with a dimensional gift box, a flying lid that tumbles and lands behind the box, and the reveal **«خرا عليك»**.

## Run it

Open `index.html` in a modern browser. No build step, Node.js, packages, server, or backend is required.

## Design and implementation

- **Consistent CSS 3D gift:** aligned box faces, the ribbon continuing across the top, a tied bow with ribbon tails, and a lid that follows one flight path instead of leaving a stray upright cardboard panel.
- **Two-way interaction:** click the gift to open it; once the phrase appears, click the phrase itself to have it glide back into the gift and close the scene. The replay button remains available as well.
- **Layered reveal choreography:** the box recoils and rattles, the lid lifts, spins through the air and falls behind the gift, while staggered fireworks, glowing rings, paper shards and ribbon confetti burst around it.
- **WebGL 1:** procedural dark liquid-light atmosphere, with a CSS-gradient fallback.
- **Canvas 2D:** stars, rings, small glowing particles, shards and ribbon confetti.
- **Accessibility:** semantic buttons, keyboard activation, live announcement, focus handling, and reduced-motion support.
- **Responsive layout:** dedicated rules for narrow screens and short viewports.

The optional Tajawal font is loaded from Google Fonts; system fonts remain the fallback. The site requires no backend.
