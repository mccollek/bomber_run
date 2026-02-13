extends Node

## Signals
signal health_changed(new_health: int)
signal score_changed(new_score: int)
signal bombs_changed(new_count: int)
signal rolls_changed(new_count: int)
signal enemy_destroyed(score_value: int, position: Vector2)
signal player_died
signal game_over
signal game_restarted

## Constants
const MAX_HEALTH := 5
const MAX_BOMBS := 5
const STARTING_BOMBS := 3
const MAX_ROLLS := 3
const STARTING_ROLLS := 3
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

var rolls: int = STARTING_ROLLS:
	set(value):
		rolls = clampi(value, 0, MAX_ROLLS)
		rolls_changed.emit(rolls)

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
	rolls = STARTING_ROLLS
	elapsed_time = 0.0
	difficulty_level = 1.0
	state = State.PLAYING
	game_restarted.emit()

func add_score(value: int, pos: Vector2) -> void:
	score += value
	enemy_destroyed.emit(value, pos)
	_try_drop_pickup(value, pos)
	_spawn_score_popup(value, pos)

func _save_high_score() -> void:
	var config := ConfigFile.new()
	config.set_value("game", "high_score", high_score)
	config.save("user://highscore.save")

func _load_high_score() -> void:
	var config := ConfigFile.new()
	if config.load("user://highscore.save") == OK:
		high_score = config.get_value("game", "high_score", 0)

var ExplosionScene: PackedScene = preload("res://scenes/effects/explosion.tscn")
var PickupScene: PackedScene = preload("res://scenes/pickups/pickup.tscn")

const DROP_CHANCE_HEALTH := 0.10
const DROP_CHANCE_BOMB := 0.05
const DROP_CHANCE_BONUS_PER_100_SCORE := 0.02  # higher value enemies drop more often

func spawn_explosion(pos: Vector2, large: bool = false) -> void:
	var effects := get_tree().get_first_node_in_group("effects")
	if not effects:
		return
	var explosion := ExplosionScene.instantiate()
	explosion.position = pos
	effects.add_child(explosion)
	explosion.setup(large)
	AudioManager.play_sfx("explosion_large" if large else "explosion_small")

func _try_drop_pickup(score_value: int, pos: Vector2) -> void:
	var effects := get_tree().get_first_node_in_group("effects")
	if not effects:
		return
	# Bonus drop chance for higher-value enemies
	var bonus: float = (score_value / 100.0) * DROP_CHANCE_BONUS_PER_100_SCORE
	var roll := randf()
	if roll < DROP_CHANCE_HEALTH + bonus:
		_spawn_pickup(effects, pos, 0)  # HEALTH
	elif roll < DROP_CHANCE_HEALTH + DROP_CHANCE_BOMB + bonus * 2.0:
		_spawn_pickup(effects, pos, 1)  # BOMB

func _spawn_pickup(parent: Node, pos: Vector2, pickup_type: int) -> void:
	# Deferred to avoid spawning Area2D during physics callbacks
	(func():
		var pickup := PickupScene.instantiate()
		pickup.position = pos
		pickup.set("type", pickup_type)
		parent.add_child(pickup)
	).call_deferred()

func _spawn_score_popup(value: int, pos: Vector2) -> void:
	var effects := get_tree().get_first_node_in_group("effects")
	if not effects:
		return
	var popup := Label.new()
	popup.text = "+%d" % value
	popup.add_theme_font_size_override("font_size", 10)
	popup.add_theme_color_override("font_color", Color.YELLOW)
	popup.position = pos - Vector2(15, 10)
	popup.set_script(load("res://scripts/score_popup.gd"))
	effects.add_child(popup)

func check_high_score() -> bool:
	if score > high_score:
		high_score = score
		_save_high_score()
		return true
	return false
