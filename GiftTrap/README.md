# GiftTrap — animated gift prank

A self-contained Arabic prank page built around a real depth-preserving CSS 3D gift box, satin wrapping, a sculpted bow, a flying lid, and the reveal **«خرا عليك»**.

## Run it

Open `index.html` in a modern browser. No build step, Node.js, packages, server, or backend is required.

## Visual and interaction design

- **True CSS 3D construction:** the body uses six correctly placed planes around one shared center, with a fitted lid made from its own top and four walls. The lid apron seats over the body rim; no extra upright top panel is used.
- **No hover flattening:** filters are removed from the transformed 3D ancestors. Hover only changes the viewing angle and lift, preserving the separate faces and their depth.
- **Gift materials:** layered plum-paper gradients, subtle paper grain, inset borders, edge highlights, and dark recessed detailing.
- **Satin wrap:** the ribbon continues across the front, sides and horizontal top plane with shaded folds and highlights.
- **Sculpted bow:** layered loops, folded ribbon tails and a raised knot.
- **Separate flying lid:** the lid lifts, tumbles and settles behind the body. Its stacking order changes after the flight ends and is restored when the prank is reset.
- **Two-way interaction:** click the gift to open it; click the revealed phrase to draw it smoothly back inside and close the scene.
- **Layered opening choreography:** box recoil, staggered fireworks, glowing rings, paper shards and ribbon confetti.
- **Optional sound and haptics:** synthesized chimes are off by default and can be enabled with the sound control. Supported devices also receive a short vibration on opening and closing.
- **WebGL 1 and Canvas 2D:** animated liquid-light atmosphere, stars, rings, particles and confetti, with a CSS background fallback.
- **Accessibility:** semantic buttons, keyboard activation, live announcements, focus handling, and reduced-motion support.
- **Responsive layout:** dedicated rules for narrow screens and short viewports.

The optional Tajawal font is loaded from Google Fonts; system fonts remain the fallback. The site requires no backend.
