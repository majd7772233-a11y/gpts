# GiftTrap — animated gift prank

A self-contained, full-screen Arabic prank page. The visitor sees a clearly angled, dimensional gift box; clicking it opens the lid on a hinge, releases a controlled two-beat burst of light and confetti, then reveals **«خرا عليك»** above the box.

## Run it

Open `index.html` in any modern browser. No build step, Node.js, package installation, server, or backend is required.

## Visual systems

- **WebGL 1 fragment shader:** animated deep-space light fields, procedural noise, caustic-like highlights, pointer glow, and a reveal glow.
- **Canvas 2D:** star shimmer, restrained expanding energy rings, glowing flecks, shards, and ribbon confetti.
- **CSS 3D:** faces positioned around a shared center, with distinct front, side and top materials; a separate lid and bow; and a deliberate isometric viewing angle.
- **Choreographed interaction:** one main burst, a smaller follow-up burst, a hinged lid motion and a text reveal staged to keep the message legible rather than crowding the box.
- **Liquid Glass styling:** translucent surfaces, directional highlights, soft neon edges, deep shadows, and pointer-responsive reflections.
- Responsive sizing, keyboard activation, an accessible live announcement, and `prefers-reduced-motion` support.
- WebGL has a CSS-gradient fallback. The page does not require a backend.

## Files

- `index.html` — complete standalone site, including the shaders and animation logic.
- `README.md` — this document.

The optional Tajawal font is requested from Google Fonts in CSS; system fonts are used if it is unavailable.
