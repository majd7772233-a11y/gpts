# GiftTrap — animated gift prank

A self-contained Arabic prank page built around a dimensionally consistent 3D gift box, a recessed interior, satin wrapping and the reveal **«خرا عليك»**.

## Run it

Open `index.html` in a modern browser. No build step, Node.js, packages, server, or backend is required.

## Design and implementation

- **Measured 3D construction:** the box uses a 280 × 190 × 180 body. Its front, back, sides, top rim and bottom plane share the same edge coordinates. The lid walls are aligned to the top rim with a consistent 38px depth and a correctly placed top panel.
- **Recessed interior:** opening the lid reveals four inner walls and a lower floor, rather than a flat surface pretending to be the inside of a box.
- **Gift-wrap finish:** matte paper texture, subtle panel seams, aligned satin bands, folded bow tails, a raised knot and a small front seal.
- **Two-way interaction:** click the gift to open it; click the revealed phrase to draw it smoothly back inside and close the scene. The replay control is available after opening.
- **Layered opening choreography:** the box recoils and rattles, the lid lifts, tumbles through the air and lands behind the box, while staggered fireworks, glowing rings, paper shards and ribbon confetti burst around it.
- **Optional sound and haptics:** synthesized chimes are off by default and can be enabled with the sound control. Supported devices also receive a short vibration on opening and closing.
- **WebGL 1:** procedural dark liquid-light atmosphere, with a CSS-gradient fallback.
- **Canvas 2D:** stars, rings, small glowing particles, shards and ribbon confetti.
- **Accessibility:** semantic buttons, keyboard activation, live announcements, focus handling, and reduced-motion support.
- **Responsive layout:** dedicated rules for narrow screens and short viewports.

The optional Tajawal font is loaded from Google Fonts; system fonts remain the fallback. The site requires no backend.
