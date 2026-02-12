# TICK-16: Game Over, Restart & High Score Persistence

**Status:** TODO
**Priority:** Medium
**Depends on:** TICK-06, TICK-07

## Description
Handle player death, game over state, restart flow, and persisted high score.

## Tasks
- [ ] Game over sequence:
  - Player death: large explosion, brief pause (~1 sec)
  - "GAME OVER" text fades in (centered, large pixel font)
  - Final score display
  - "NEW HIGH SCORE!" if applicable
  - "Press ENTER to restart" prompt
- [ ] Restart flow:
  - Reset all game state (health, score, bombs, difficulty)
  - Clear all enemies and projectiles
  - Reset world scroller position
  - Respawn player at start position
  - Brief invincibility on restart
- [ ] High score persistence:
  - Save high score to `user://highscore.save` (simple ConfigFile)
  - Load on game start
  - Update when new high score is achieved
- [ ] Game manager state machine: `PLAYING` → `GAME_OVER` → `PLAYING`
- [ ] Pause all enemy spawning and scrolling during game over

## Acceptance Criteria
- Player death triggers a clear game over sequence
- High score persists between sessions
- Restart cleanly resets all game state
- No orphaned nodes or leftover state after restart
- Game over screen is readable and provides clear direction
