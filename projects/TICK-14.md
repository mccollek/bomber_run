# TICK-14: Pickup Drops (Health & Bomb Refill)

**Status:** TODO
**Priority:** Medium
**Depends on:** TICK-06

## Description
Enemies drop pickups on death that restore health or refill bombs.

## Tasks
- [ ] Create pickup pixel art sprites:
  - Health pickup (red cross or heart, ~12x12)
  - Bomb pickup (bomb icon, ~12x12)
- [ ] Create `pickup.tscn` (Area2D):
  - Layer 8 (Pickups), mask layer 1 (Player)
  - Gentle floating animation (bob up and down)
  - Scrolls down slowly (or stays at spawn point and drifts down with world)
  - Despawns after ~5 sec or when off-screen
  - Subtle glow/pulse effect to attract attention
- [ ] Drop logic:
  - Enemies have a configurable drop chance (e.g., 10% health, 5% bomb)
  - Higher-value enemies (ships, bombers) have higher drop rates
  - Drops spawn at enemy death position
- [ ] Pickup effects:
  - Health: restore 1 HP (capped at max)
  - Bomb: restore 1 bomb (capped at max of 5)
- [ ] Pickup collection feedback: brief flash + sound

## Acceptance Criteria
- Pickups occasionally drop from destroyed enemies
- Collecting a pickup restores health or bombs
- Pickups are visually distinct and noticeable
- Pickups despawn if not collected
- Drop rates feel fair (not too rare, not too generous)
