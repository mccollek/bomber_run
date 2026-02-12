# TICK-02: Scrolling Ocean Background

**Status:** TODO
**Priority:** Critical
**Depends on:** TICK-01
**Blocks:** TICK-10

## Description
Create the continuously scrolling ocean background using ParallaxBackground with two layers for depth.

## Tasks
- [ ] Create ocean tile sprite (pixel art, ~480x240 tileable vertically)
  - Deep ocean: darker blue, subtle wave pattern
  - Surface ocean: lighter blue with whitecap details
- [ ] Set up `ParallaxBackground` node in main scene
  - Deep ocean layer: slower scroll (0.5x), mirroring enabled
  - Surface ocean layer: full scroll speed (1.0x), mirroring enabled
- [ ] Implement scroll speed constant (pixels/sec) in game manager
- [ ] Ensure seamless vertical tiling (no visible seam)

## Acceptance Criteria
- Ocean scrolls continuously top-to-bottom at steady speed
- Two visible depth layers with parallax effect
- No visible seam or pop-in at tile boundaries
- Scroll speed is configurable from game manager
