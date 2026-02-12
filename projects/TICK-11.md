# TICK-11: Sea Enemies (Patrol Boat & Destroyer)

**Status:** TODO
**Priority:** High
**Depends on:** TICK-05, TICK-06, TICK-09
**Blocks:** TICK-13

## Description
Create ship enemies that float on the ocean surface, scrolling with the world and firing at the player.

## Tasks
- [ ] Create patrol boat pixel art sprite (~16x32, small military boat)
- [ ] Create destroyer pixel art sprite (~24x64, larger warship)
- [ ] Create `patrol_boat.tscn` (Area2D):
  - Layer 5 (Sea Enemies), mask layer 3 (Player Bombs)
  - Scrolls with world
  - Fires single bullets upward at intervals
  - HP: 2
  - Score: 200
- [ ] Create `destroyer.tscn` (Area2D):
  - Layer 5 (Sea Enemies), mask layer 3 (Player Bombs)
  - Scrolls with world
  - Fires 3-bullet spread upward
  - HP: 5
  - Score: 500
- [ ] Ships are only vulnerable to bombs (not forward guns)
- [ ] Ships spawn as part of world chunks or independently on open ocean
- [ ] Wake effect behind moving ships (simple particle or animated sprite)

## Acceptance Criteria
- Patrol boats and destroyers scroll with the ocean
- Ships fire at the player with distinct patterns
- Ships are damaged by bombs only (not bullets)
- Destroyed ships produce appropriately large explosions
- Score awards correctly on destruction
