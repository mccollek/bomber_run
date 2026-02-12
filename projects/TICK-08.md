# TICK-08: Explosions & Hit Effects

**Status:** TODO
**Priority:** High
**Depends on:** TICK-06

## Description
Add visual feedback for hits and destruction — explosions, flashes, and particles.

## Tasks
- [ ] Create explosion spritesheet (pixel art, 5-8 frames):
  - Small explosion (for planes, bullets)
  - Large explosion (for ships, player death)
- [ ] Create `explosion.tscn` scene (AnimatedSprite2D):
  - Plays animation once, then queue_free
  - Configurable size (small/large)
- [ ] Create hit flash shader or AnimationPlayer:
  - White flash on enemies when hit (1-2 frames)
- [ ] Spawn explosions:
  - On enemy death (at enemy position)
  - On player bullet hitting something
  - On player death (large, lingering)
- [ ] Optional: screen shake on large explosions (Camera2D)
- [ ] Optional: debris particles (small pixel chunks flying out)

## Acceptance Criteria
- Every enemy death produces a visible explosion
- Hit flashes give clear feedback that damage was dealt
- Explosions are appropriately sized (small for fighters, large for ships)
- Animations play fully and clean themselves up
