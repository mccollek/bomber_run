# TICK-06: Collision System & Damage

**Status:** TODO
**Priority:** Critical
**Depends on:** TICK-03, TICK-04, TICK-05
**Blocks:** TICK-07, TICK-08

## Description
Wire up collisions so bullets damage enemies, enemy bullets damage the player, and contact damage works.

## Tasks
- [ ] Player `area_entered` handler:
  - Enemy bullets: take damage (1 HP), destroy bullet
  - Enemy body contact: take damage (1 HP)
  - Pickups: apply pickup effect, destroy pickup
- [ ] Enemy `area_entered` handler:
  - Player bullets: take damage, destroy bullet
  - When HP <= 0: emit `destroyed` signal, queue_free
- [ ] Implement `take_damage()` on player:
  - Reduce health
  - Brief invincibility window (~1 sec) with flashing sprite
  - If health <= 0: trigger death/game over
- [ ] Implement `take_damage()` on enemies:
  - Reduce HP
  - Flash white briefly on hit
  - Emit score value on death
- [ ] Add score signal to game manager (enemy_destroyed → add points)
- [ ] Define damage values and HP for each entity type

## Acceptance Criteria
- Player bullets destroy enemy fighters
- Enemy bullets reduce player health
- Player flashes and gets brief invincibility on hit
- Score increments when enemies are destroyed
- No missed collisions at normal game speed
