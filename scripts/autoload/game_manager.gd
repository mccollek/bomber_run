extends Node

## Signals
signal health_changed(new_health: int)
signal score_changed(new_score: int)
signal bombs_changed(new_count: int)
signal enemy_destroyed(score_value: int, position: Vector2)
signal player_died
signal game_over
signal game_restarted

## Constants
const MAX_HEALTH := 5
const MAX_BOMBS := 5
const STARTING_BOMBS := 3
const SCROLL_SPEED := 120.0  # pixels per second

## Game state
enum State { TITLE, PLAYING, GAME_OVER }
var state: State = State.PLAYING

## Player stats
var health: int = MAX_HEALTH:
	set(value):
		health = clampi(value, 0, MAX_HEALTH)
		health_changed.emit(health)
		if health <= 0:
			player_died.emit()

var score: int = 0:
	set(value):
		score = value
		score_changed.emit(score)

var bombs: int = STARTING_BOMBS:
	set(value):
		bombs = clampi(value, 0, MAX_BOMBS)
		bombs_changed.emit(bombs)

var high_score: int = 0

## Difficulty
var elapsed_time: float = 0.0
var difficulty_level: float = 1.0

func _ready() -> void:
	_load_high_score()

func _process(delta: float) -> void:
	if state == State.PLAYING:
		elapsed_time += delta
		difficulty_level = 1.0 + elapsed_time / 60.0  # +1 per minute

func reset() -> void:
	health = MAX_HEALTH
	score = 0
	bombs = STARTING_BOMBS
	elapsed_time = 0.0
	difficulty_level = 1.0
	state = State.PLAYING
	game_restarted.emit()

func add_score(value: int, pos: Vector2) -> void:
	score += value
	enemy_destroyed.emit(value, pos)

func _save_high_score() -> void:
	var config := ConfigFile.new()
	config.set_value("game", "high_score", high_score)
	config.save("user://highscore.save")

func _load_high_score() -> void:
	var config := ConfigFile.new()
	if config.load("user://highscore.save") == OK:
		high_score = config.get_value("game", "high_score", 0)

var ExplosionScene: PackedScene = preload("res://scenes/effects/explosion.tscn")

func spawn_explosion(pos: Vector2, large: bool = false) -> void:
	var effects := get_tree().get_first_node_in_group("effects")
	if not effects:
		return
	var explosion := ExplosionScene.instantiate()
	explosion.position = pos
	effects.add_child(explosion)
	explosion.setup(large)

func check_high_score() -> bool:
	if score > high_score:
		high_score = score
		_save_high_score()
		return true
	return false
