# TICK-03: Player Bomber Movement

**Status:** TODO
**Priority:** Critical
**Depends on:** TICK-01
**Blocks:** TICK-04, TICK-06

## Description
Create the player bomber with 8-directional movement, constrained to the screen.

## Tasks
- [ ] Create player bomber pixel art sprite (top-down, ~32x32 or 48x48)
  - Idle frame
  - Banking left/right frames (at minimum 3 frames: left, center, right)
- [ ] Create `player.tscn` scene (Area2D-based for shmup-style)
  - Sprite2D with bomber texture
  - CollisionShape2D (smaller than sprite for forgiving hitbox)
  - Set collision layer 1 (Player), mask layer 7 (Enemy Bullets) + 8 (Pickups)
- [ ] Create `player.gd` script:
  - Input handling: arrow keys / WASD for 8-directional movement
  - Movement speed constant (~200 px/sec)
  - Clamp position to viewport bounds (with small margin)
  - Slight visual tilt when moving left/right
- [ ] Set up input map in project settings (ui_left, ui_right, ui_up, ui_down or custom actions)
- [ ] Player starts at bottom-center of screen

## Acceptance Criteria
- Player moves smoothly in all 8 directions
- Player cannot leave the visible screen area
- Visual tilt when banking left/right
- Responsive feel with no input lag
