# TICK-13: Wave Spawner & Difficulty Scaling

**Status:** TODO
**Priority:** High
**Depends on:** TICK-05, TICK-11, TICK-12

## Description
Replace temporary spawn logic with a proper wave spawner that scales difficulty over time.

## Tasks
- [ ] Create `wave_spawner.gd`:
  - Timer-driven wave system
  - Wave definitions: enemy type, count, formation pattern, entry direction
  - Formation patterns:
    - V-formation (fighters)
    - Line abreast (fighters)
    - Single file (dive bombers)
    - Random scatter
  - Spawn from top edge at designated positions
- [ ] Create difficulty scaling system:
  - `difficulty_level` float that increases over time
  - Scale factors applied to:
    - Enemy count per wave (more enemies)
    - Enemy HP (tankier)
    - Enemy fire rate (shoot more often)
    - Enemy bullet speed (harder to dodge)
    - Wave frequency (less downtime)
    - Ship spawn rate
  - Scaling curve: gentle start, ramps up, soft cap to stay playable
- [ ] Milestone waves every ~60 seconds:
  - Large formation attacks
  - Multiple simultaneous ship spawns
  - Combined air + sea assault
- [ ] Brief quiet periods between intensity spikes (pacing)
- [ ] Track elapsed time and display difficulty tier (hidden, for tuning)

## Acceptance Criteria
- Waves of enemies spawn in recognizable formations
- Game gets progressively harder over time
- Pacing has peaks and valleys (not constant stress)
- Game remains playable (difficult but not impossible) at high difficulty
- Variety in wave composition
