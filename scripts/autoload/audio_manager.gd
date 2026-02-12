extends Node

## Audio manager — plays SFX and music with polyphonic support.

var _sfx := {}
var _music_player: AudioStreamPlayer

const SFX_LIST := {
	"shoot": "res://assets/audio/shoot.wav",
	"bomb_drop": "res://assets/audio/bomb_drop.wav",
	"bomb_explode": "res://assets/audio/bomb_explode.wav",
	"explosion_small": "res://assets/audio/explosion_small.wav",
	"explosion_large": "res://assets/audio/explosion_large.wav",
	"hit_player": "res://assets/audio/hit_player.wav",
	"pickup": "res://assets/audio/pickup.wav",
	"enemy_shoot": "res://assets/audio/enemy_shoot.wav",
}

const SFX_DB := -6.0
const MUSIC_DB := -12.0
const MAX_POLYPHONY := 8

func _ready() -> void:
	# Preload all SFX
	for key in SFX_LIST:
		_sfx[key] = load(SFX_LIST[key])

	# Music player
	_music_player = AudioStreamPlayer.new()
	_music_player.bus = "Master"
	_music_player.volume_db = MUSIC_DB
	add_child(_music_player)

func play_sfx(sfx_name: String) -> void:
	if not _sfx.has(sfx_name):
		return
	var player := AudioStreamPlayer.new()
	player.stream = _sfx[sfx_name]
	player.volume_db = SFX_DB
	player.bus = "Master"
	add_child(player)
	player.play()
	player.finished.connect(player.queue_free)

func play_music() -> void:
	_music_player.stream = load("res://assets/audio/music_loop.wav")
	_music_player.play()

func stop_music() -> void:
	_music_player.stop()
