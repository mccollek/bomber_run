# TICK-07: HUD (Health, Score, Bombs)

**Status:** TODO
**Priority:** High
**Depends on:** TICK-06

## Description
Create the heads-up display showing player health, bomb count, score, and high score.

## Tasks
- [ ] Create `hud.tscn` scene (CanvasLayer):
  - Health bar (top-left): segmented bar or hearts, pixel art style
  - Bomb count (below health): bomb icon × count
  - Score (top-right): retro pixel font
  - High score (below score): smaller text
- [ ] Create or source a pixel art font (or use Godot's built-in with pixel settings)
- [ ] Create `hud.gd`:
  - Connect to game manager signals: `health_changed`, `score_changed`, `bombs_changed`
  - Update display elements reactively
  - Score counter animates/rolls up
- [ ] Health bar shows damage with color change (green → yellow → red)
- [ ] Brief flash effect on HUD when player takes damage

## Acceptance Criteria
- All HUD elements are visible and correctly positioned
- Health bar updates in real time as player takes damage
- Score updates when enemies are destroyed
- Bomb count reflects current supply
- HUD does not obscure critical gameplay area
