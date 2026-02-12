# TICK-15: Audio (SFX + Music)

**Status:** TODO
**Priority:** Medium
**Depends on:** TICK-04, TICK-08, TICK-09

## Description
Add sound effects and a looping chiptune music track.

## Tasks
- [ ] Generate or source SFX (chiptune/retro style):
  - `shoot.wav` — player gun fire (short, snappy)
  - `bomb_drop.wav` — bomb release sound
  - `bomb_explode.wav` — bomb impact explosion
  - `explosion_small.wav` — enemy plane destroyed
  - `explosion_large.wav` — ship destroyed
  - `hit_player.wav` — player takes damage
  - `pickup.wav` — collecting a pickup
  - `engine_hum.ogg` — looping engine ambient
  - `enemy_shoot.wav` — enemy gunfire
- [ ] Generate or source looping chiptune music track (~60-90 sec loop)
- [ ] Create `audio_manager.gd` autoload:
  - AudioStreamPlayer nodes for music + SFX channels
  - Methods: `play_sfx(name)`, `play_music()`, `stop_music()`
  - SFX volume control, music volume control
  - Polyphonic SFX support (multiple overlapping sounds)
- [ ] Integrate audio calls at trigger points:
  - Player fires → `shoot.wav`
  - Bomb dropped → `bomb_drop.wav`
  - Explosion → appropriate explosion sound
  - Player hit → `hit_player.wav`
  - Pickup → `pickup.wav`
- [ ] Music starts on game begin, stops on game over

## Acceptance Criteria
- All listed SFX play at appropriate moments
- Music loops seamlessly
- Multiple SFX can play simultaneously without cutting each other off
- Audio enhances the retro arcade feel
- Volume levels are balanced (SFX audible over music)
