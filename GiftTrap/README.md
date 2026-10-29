# GiftTrap — animated gift prank

A self-contained, full-screen Arabic prank page. The visitor sees a luminous 3D gift box; clicking it launches the lid, bursts ribbons and particles, and reveals **«خرا عليك»**.

## Run it

Open `index.html` in any modern browser. No build step, Node.js, package installation, server, or backend is required.

## Visual systems

- **WebGL 1 fragment shader:** animated deep-space fluid light fields, procedural noise, caustic-like highlights, pointer glow, and a reveal glow.
- **Canvas 2D:** star shimmer, expanding energy rings, glowing flecks, shards, and ribbon confetti.
- **CSS 3D:** a faceted gift body, separate lid, glossy wrapping, reflective ribbon, and a dimensional bow.
- **Liquid Glass styling:** translucent surfaces, directional highlights, soft neon edges, deep shadows, and pointer-responsive reflections.
- Responsive layout, keyboard activation, an accessible live announcement, and `prefers-reduced-motion` support.
- WebGL has a CSS-gradient fallback. The page is local-only and makes no network requests from its own JavaScript.

## Files

- `index.html` — complete standalone site, including the shaders and all animation logic.
- `README.md` — this document.

The optional Tajawal font is requested from Google Fonts in CSS; system fonts are used if it is unavailable.
