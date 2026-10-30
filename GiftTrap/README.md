# GiftTrap — animated gift prank

A self-contained Arabic prank page built around a more carefully constructed 3D gift box, satin ribbon and bow, and the reveal **«خرا عليك»**.

## Run it

Open `index.html` in a modern browser. No build step, Node.js, packages, server, or backend is required.

## Design and implementation

- **Rebuilt 3D box geometry:** the top and bottom planes now align with the true edges of the box instead of sitting halfway through the sides. The lid has a consistent shallow thickness and a small overhang, with the bow attached to its top.
- **Gift-wrap details:** matte textured paper, beveled seams, a dark inner cavity, aligned satin bands, folded bow tails and a small front seal.
- **Two-way interaction:** click the gift to open it; click the revealed phrase to draw it smoothly back inside and close the scene. The replay control is available after opening.
- **Layered opening choreography:** the box recoils and rattles, the lid lifts, tumbles through the air and lands behind the box, while staggered fireworks, glowing rings, paper shards and ribbon confetti burst around it.
- **Optional sound and haptics:** synthesized chimes are off by default and can be enabled with the sound control. Supported devices also receive a short vibration on opening and closing.
- **WebGL 1:** procedural dark liquid-light atmosphere, with a CSS-gradient fallback.
- **Canvas 2D:** stars, rings, small glowing particles, shards and ribbon confetti.
- **Accessibility:** semantic buttons, keyboard activation, live announcements, focus handling, and reduced-motion support.
- **Responsive layout:** dedicated rules for narrow screens and short viewports.

The optional Tajawal font is loaded from Google Fonts; system fonts remain the fallback. The site requires no backend.
