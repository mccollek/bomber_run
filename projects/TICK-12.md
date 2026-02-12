# TICK-12: Ground Enemies (AA Guns on Islands)

**Status:** TODO
**Priority:** High
**Depends on:** TICK-09, TICK-10
**Blocks:** TICK-13

## Description
Create anti-aircraft gun emplacements placed on islands that track and fire at the player.

## Tasks
- [ ] Create AA gun pixel art sprite (~16x16, turret that rotates)
  - Base (static, part of island)
  - Turret/barrel (rotates toward player)
- [ ] Create `aa_gun.tscn` (Area2D):
  - Layer 6 (Ground Enemies), mask layer 3 (Player Bombs)
  - Turret rotates to track player position
  - Fires aimed bullets at player (every ~2 sec)
  - HP: 3
  - Score: 300
- [ ] AA guns are placed as child nodes of island chunks
- [ ] AA guns activate when their island is on-screen (optimization)
- [ ] Only vulnerable to bombs (not forward guns)
- [ ] Destruction leaves a damaged/burnt sprite on the island

## Acceptance Criteria
- AA guns rotate to face the player
- AA guns fire aimed bullets periodically
- Only bombs can destroy AA guns
- Destroyed AA guns show damage on the island
- AA guns scroll with their parent island
