# GiftTrap — animated gift prank

A self-contained Arabic prank page with a hand-detailed isometric SVG gift, satin ribbon and sculpted bow, a flying lid, and the reveal **«خرا عليك»**.

## Run it

Open `index.html` in a modern browser. No build step, Node.js, packages, server, or backend is required.

## Visual and interaction design

- **Unified gift artwork:** the former stack of independently transformed CSS faces has been replaced with a single perspective-consistent SVG illustration for the box body. This prevents the box faces from collapsing into a flat stack on hover.
- **Gift materials:** layered plum paper gradients, fine paper grain, folded edges, edge highlights, a recessed opening, and a contact shadow.
- **Satin wrap:** the ribbon follows the top plane and front faces, with specular highlights and shaded folds.
- **Sculpted bow:** layered SVG ribbon loops, folded tails, a raised knot, highlights and cast shadow.
- **Separate flying lid:** the lid is an independent illustrated layer; it lifts, tumbles and settles behind the body. Its stacking order changes only after the flight animation finishes.
- **Two-way interaction:** click the gift to open it; click the revealed phrase to draw it smoothly back inside and close the scene. The replay control is available after opening.
- **Layered opening choreography:** box recoil, staggered fireworks, glowing rings, paper shards and ribbon confetti.
- **Optional sound and haptics:** synthesized chimes are off by default and can be enabled with the sound control. Supported devices also receive a short vibration on opening and closing.
- **WebGL 1 and Canvas 2D:** animated liquid-light atmosphere, stars, rings, particles and confetti, with a CSS background fallback when WebGL is unavailable.
- **Accessibility:** semantic buttons, keyboard activation, live announcements, focus handling, and reduced-motion support.
- **Responsive layout:** dedicated rules for narrow screens and short viewports.

The optional Tajawal font is loaded from Google Fonts; system fonts remain the fallback. The site requires no backend.
