# TICK-09: Player Bombs

**Status:** TODO
**Priority:** High
**Depends on:** TICK-03, TICK-06
**Blocks:** TICK-11, TICK-12

## Description
Implement the player's bomb mechanic for hitting sea and ground targets.

## Tasks
- [ ] Create bomb pixel art sprite (~12x12, visible bomb shape)
- [ ] Create bomb shadow/target sprite (dark oval that appears on the surface layer)
- [ ] Create `player_bomb.tscn` scene (Area2D):
  - Bomb sprite (starts at player, grows slightly as it "falls")
  - Shadow sprite on ground plane (starts small, grows to target size)
  - Layer 3 (Player Bombs), mask layers 5 (Sea Enemies) + 6 (Ground Enemies)
- [ ] Create `player_bomb.gd`:
  - Bomb "falls" for ~0.8 sec (visual animation of descent)
  - On impact: create large explosion, check for collisions in blast radius
  - Blast radius area check (CircleShape2D overlap)
- [ ] Add bomb input to player:
  - "bomb" action mapped to X / Ctrl key
  - Limited bomb supply (start with 3)
  - Cooldown between bombs (~1 sec)
  - Drop from center of player
- [ ] Bomb count tracked in game manager

## Acceptance Criteria
- Pressing bomb key drops a bomb with visible falling animation
- Shadow on ground shows where bomb will land
- Bomb explodes on impact with large explosion effect
- Bomb damages sea and ground targets in blast radius
- Cannot bomb when supply is empty
- Bomb count decrements correctly
