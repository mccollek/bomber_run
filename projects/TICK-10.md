# TICK-10: Island Chunks & Scrolling Terrain

**Status:** TODO
**Priority:** High
**Depends on:** TICK-02
**Blocks:** TICK-12

## Description
Create island terrain that scrolls through the play area over the ocean background.

## Tasks
- [ ] Create island tile art:
  - Sand/beach edge tiles (for island borders)
  - Green vegetation interior tiles
  - Rocky terrain tiles
  - Small detail tiles (trees, rocks)
- [ ] Design 4-6 island chunk layouts (pre-built segments, ~480px wide, varying heights):
  - Small island (single atoll)
  - Medium island (with clearing for AA guns)
  - Large island (with multiple structures)
  - Archipelago (cluster of small islands)
- [ ] Create island chunk scenes (Node2D with TileMapLayer or assembled sprites)
- [ ] Create `world_scroller.gd`:
  - Manages a queue of upcoming chunks
  - Spawns chunks above viewport, scrolls them down
  - Recycles/frees chunks that pass below viewport
  - Random selection with spacing rules (min/max gap between islands)
  - Scroll speed synced with ocean background
- [ ] Islands should appear to be ON the ocean (proper z-ordering)

## Acceptance Criteria
- Islands scroll smoothly at the same rate as the surface ocean
- Variety of island shapes appear
- Reasonable spacing between islands (not too crowded, not too sparse)
- Islands layer correctly over ocean background
- No pop-in visible (spawn above viewport edge)
