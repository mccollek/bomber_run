# Bomber Run — Project Plan

## Overview
A top-down vertical scrolling bomber game inspired by 1942. The player pilots a bomber over an endless ocean with islands scrolling beneath. Enemy planes, ships, and island-based AA guns provide escalating challenge. Pixel art retro aesthetic at 480x720 resolution.

## Core Design

### Gameplay Loop
- Ocean and islands scroll top-to-bottom continuously
- Player bomber moves freely anywhere on screen
- Forward guns fire at air targets (enemy planes)
- Bombs drop on surface targets (ships, AA guns on islands)
- Health bar depletes on hits; heal via pickups from destroyed enemies
- Difficulty scales endlessly — enemy count, speed, fire rate increase over time
- Score accumulates; high score is tracked and persisted

### Player
- **Movement:** 8-directional, constrained to screen bounds
- **Forward Guns:** Auto-fire or hold-to-fire, bullets travel upward
- **Bombs:** Limited supply (refill from drops), fall straight down with a shadow/target indicator
- **Health:** Single health bar (5 HP), flashing on hit, game over at 0
- **Hitbox:** Smaller than visual sprite (forgiving collision)

### Enemies
| Type | Layer | Behavior | Threat |
|------|-------|----------|--------|
| **Fighter Plane** | Air | Flies in formations from top, some dive at player | Bullets fired forward/aimed |
| **Bomber Plane** | Air | Slow, tanky, drops bombs downward | Area denial |
| **Patrol Boat** | Sea | Scrolls with ocean, fires upward | Steady bullet stream |
| **Destroyer** | Sea | Larger ship, fires spreads | Heavy fire, high HP |
| **AA Gun** | Ground (island) | Static on islands, tracks player | Aimed shots |

### Scrolling World
- Parallax layers: deep ocean (slow) → surface water (medium) → islands/ships (main speed)
- Islands are pre-designed tile chunks placed procedurally
- Ocean tile with animated wave texture
- Island tiles with beach edges, vegetation, AA gun placements

### Difficulty Scaling
- **Wave system:** Waves of enemies spawn at intervals
- **Scaling factors** (increase over time): enemy count per wave, enemy HP, fire rate, bullet speed, spawn frequency
- **Milestone events:** Every ~60 seconds, a mini-boss wave (large formation or capital ship)

### Audio
- Engine hum loop (player)
- Gunfire SFX (player + enemies)
- Explosion SFX (small for planes, large for ships)
- Bomb drop + impact SFX
- Hit/damage SFX
- Looping chiptune music track

### HUD
- Health bar (top-left)
- Bomb count (top-left, below health)
- Score (top-right)
- High score (top-right, below score)

---

## Technical Architecture

### Viewport & Rendering
- Game viewport: 480x720 pixels
- Window scaling: integer scale, stretch mode `canvas_items`
- Pixel-perfect rendering with texture filtering disabled

### Scene Tree Structure
```
Main (Node2D)
├── ParallaxBackground
│   ├── DeepOceanLayer
│   └── SurfaceOceanLayer
├── ScrollingWorld (Node2D) — moves downward each frame
│   ├── IslandChunks (tiled island segments)
│   ├── SeaEnemies (ships placed on chunks)
│   └── GroundEnemies (AA guns on islands)
├── Player (CharacterBody2D)
├── AirEnemies (Node2D) — enemy planes
├── Projectiles (Node2D) — all bullets/bombs pooled here
├── Effects (Node2D) — explosions, particles
├── HUD (CanvasLayer)
└── GameManager (Node) — scoring, difficulty, state
```

### Key Systems
- **Object pooling** for bullets and explosions (performance)
- **Chunk-based world gen:** pre-made island segments placed ahead of scroll, recycled behind
- **Collision layers:** Air (player + planes + air bullets), Sea (bombs + ships), Ground (bombs + AA guns)
- **Wave spawner:** Timer-driven, picks from enemy patterns, scales with difficulty

### Collision Layer Plan
| Layer | Bit | Contents |
|-------|-----|----------|
| 1 | Player | Player hitbox |
| 2 | Player Bullets | Forward gun projectiles |
| 3 | Player Bombs | Bomb projectiles |
| 4 | Air Enemies | Enemy planes |
| 5 | Sea Enemies | Ships |
| 6 | Ground Enemies | AA guns |
| 7 | Enemy Bullets | All enemy projectiles |
| 8 | Pickups | Health/bomb drops |

---

## Tickets

See individual ticket files in this directory for implementation details.

## Ticket Order (Critical Path)
1. `TICK-01` — Project scaffold & settings
2. `TICK-02` — Scrolling ocean background
3. `TICK-03` — Player bomber movement
4. `TICK-04` — Player forward guns
5. `TICK-05` — Basic enemy fighter planes
6. `TICK-06` — Collision system & damage
7. `TICK-07` — HUD (health, score, bombs)
8. `TICK-08` — Explosions & hit effects
9. `TICK-09` — Player bombs
10. `TICK-10` — Island chunks & scrolling terrain
11. `TICK-11` — Sea enemies (patrol boat, destroyer)
12. `TICK-12` — Ground enemies (AA guns on islands)
13. `TICK-13` — Wave spawner & difficulty scaling
14. `TICK-14` — Pickup drops (health, bomb refill)
15. `TICK-15` — Audio (SFX + music)
16. `TICK-16` — Game over, restart, high score persistence
17. `TICK-17` — Title screen & polish
18. `TICK-18` — GitHub repo setup & README
