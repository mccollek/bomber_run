# TICK-17: Title Screen & Polish

**Status:** TODO
**Priority:** Medium
**Depends on:** TICK-16

## Description
Create a title screen and apply final polish to the game feel.

## Tasks
- [ ] Create `title_screen.tscn`:
  - Game title "BOMBER RUN" in large pixel art text
  - Scrolling ocean background (reuse from gameplay)
  - "PRESS START" blinking text
  - High score display
  - Simple controls reference (arrows/WASD, Space, X)
- [ ] Title screen transitions:
  - Press Enter/Space → fade to gameplay
  - Game over → option to return to title or quick restart
- [ ] Polish items:
  - Screen shake on large explosions (subtle, 2-3 frames)
  - Player engine exhaust particles (small trail from bomber)
  - Brief slowdown on player death (hit stop)
  - Muzzle flash on guns
  - Score popup numbers floating up from destroyed enemies
- [ ] Performance check:
  - Verify no frame drops with many bullets/enemies on screen
  - Profile and optimize if needed

## Acceptance Criteria
- Title screen displays on game launch
- Smooth transition between title and gameplay
- Polish effects enhance game feel without being distracting
- Game runs at solid 60 FPS throughout
