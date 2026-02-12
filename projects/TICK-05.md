# TICK-05: Basic Enemy Fighter Planes

**Status:** TODO
**Priority:** Critical
**Depends on:** TICK-01
**Blocks:** TICK-06, TICK-13

## Description
Create the basic fighter plane enemy that flies in from the top of the screen.

## Tasks
- [ ] Create enemy fighter pixel art sprite (~24x24, distinct color from player)
- [ ] Create `enemy_fighter.tscn` scene (Area2D):
  - Sprite2D
  - CollisionShape2D
  - Layer 4 (Air Enemies), mask layers 2 (Player Bullets) + 1 (Player)
- [ ] Create `enemy_fighter.gd`:
  - Configurable movement patterns:
    - Straight down
    - Diagonal sweep (left-to-right or right-to-left)
    - Dive toward player position
  - Fire bullets at intervals (aimed or straight down)
  - HP variable (starts at 1, scales with difficulty)
  - Queue-free when leaving bottom of screen
- [ ] Create `enemy_bullet.tscn` (Area2D):
  - Small red/pink bullet sprite
  - Layer 7 (Enemy Bullets), mask layer 1 (Player)
  - Moves in assigned direction at constant speed
- [ ] Temporary spawn logic (simple timer spawning from random x at top) — will be replaced by wave spawner in TICK-13

## Acceptance Criteria
- Fighter planes appear from top and fly downward with variety
- Some fighters fire bullets at the player
- Fighters despawn when off-screen
- Multiple movement patterns are functional
