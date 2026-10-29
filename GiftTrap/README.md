# GiftTrap — animated gift prank

A self-contained Arabic prank page with a dimensional gift box, a hinged lid, restrained particles, and the reveal **«خرا عليك»**.

## Run it

Open `index.html` in a modern browser. No build step, Node.js, packages, server, or backend is required.

## Design and implementation

- **Stable CSS 3D geometry:** the front, side, top, lid and bow use a consistent centered coordinate system instead of a stack of conflicting transform overrides.
- **Deliberate composition:** the intro, gift, reveal text and replay control occupy separate visual zones; the gift shifts down and scales after opening so the message stays readable.
- **Controlled motion:** a restrained lid-hinge animation, a subtle box settle, and a two-beat particle burst replace competing large movements.
- **WebGL 1:** procedural dark liquid-light atmosphere, with a CSS-gradient fallback.
- **Canvas 2D:** stars, rings, small glowing particles, shards and ribbon confetti.
- **Accessibility:** semantic button, keyboard activation, live announcement, and reduced-motion support.
- **Responsive layout:** dedicated rules for narrow screens and short viewports.

The optional Tajawal font is loaded from Google Fonts; system fonts remain the fallback. The site requires no backend.
