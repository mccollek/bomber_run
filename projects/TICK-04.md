# TICK-04: Player Forward Guns

**Status:** TODO
**Priority:** Critical
**Depends on:** TICK-03
**Blocks:** TICK-06

## Description
Implement the player's forward-firing guns that shoot bullets upward.

## Tasks
- [ ] Create bullet pixel art sprite (~4x8 bright yellow/orange)
- [ ] Create `player_bullet.tscn` scene (Area2D):
  - Sprite2D
  - CollisionShape2D
  - Layer 2 (Player Bullets), mask layers 4 (Air Enemies)
- [ ] Create `player_bullet.gd`:
  - Moves upward at constant speed (~500 px/sec)
  - Queue-free when leaving screen (top edge)
- [ ] Add firing to player:
  - Hold-to-fire with fire rate timer (~0.15 sec between shots)
  - Spawn bullets from gun position(s) on player sprite
  - Input action: "shoot" mapped to Space / Z key
- [ ] Implement basic object pool or use direct instantiation (optimize later if needed)
- [ ] Dual gun positions (left and right of bomber nose)

## Acceptance Criteria
- Holding fire button produces steady stream of bullets
- Bullets travel straight up and despawn off-screen
- Fire rate feels responsive but not overwhelming
- Two bullet streams from dual gun mounts
