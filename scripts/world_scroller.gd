extends Node2D

## Manages scrolling island chunks and sea enemies over the ocean.

const ISLAND_TEXTURES: Array[String] = [
	"res://assets/sprites/island_small.png",
	"res://assets/sprites/island_medium.png",
	"res://assets/sprites/island_large.png",
	"res://assets/sprites/island_archipelago.png",
	"res://assets/sprites/island_long.png",
	"res://assets/sprites/island_tiny.png",
]

var PatrolBoatScene: PackedScene = preload("res://scenes/enemies/patrol_boat.tscn")
var DestroyerScene: PackedScene = preload("res://scenes/enemies/destroyer.tscn")

const MIN_GAP := 300.0
const MAX_GAP := 600.0
const DESPAWN_Y := 800.0
const SHIP_SPAWN_INTERVAL := 8.0  # base seconds between ship spawns

var _loaded_textures: Array[Texture2D] = []
var _next_spawn_y := -200.0
var _ship_timer := 5.0  # first ship after 5 seconds

func _ready() -> void:
	for path in ISLAND_TEXTURES:
		_loaded_textures.append(load(path))

func _process(delta: float) -> void:
	if GameManager.state != GameManager.State.PLAYING:
		return

	# Scroll all children downward
	var scroll := GameManager.SCROLL_SPEED * delta
	for child in get_children():
		child.position.y += scroll
		if child.position.y > DESPAWN_Y:
			child.queue_free()

	# Island spawning
	_next_spawn_y += scroll
	while _next_spawn_y >= 0.0:
		_spawn_island()

	# Ship spawning
	_ship_timer -= delta
	if _ship_timer <= 0.0:
		_ship_timer = SHIP_SPAWN_INTERVAL / GameManager.difficulty_level
		_spawn_ship()

func _spawn_island() -> void:
	var tex: Texture2D = _loaded_textures.pick_random()
	var sprite := Sprite2D.new()
	sprite.texture = tex
	sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST

	var tex_w := tex.get_width()
	var margin := tex_w / 2.0 + 10.0
	var x_pos := randf_range(margin, 480.0 - margin)

	sprite.position = Vector2(x_pos, -tex.get_height() / 2.0)
	add_child(sprite)

	var gap := randf_range(MIN_GAP, MAX_GAP)
	_next_spawn_y = -gap

func _spawn_ship() -> void:
	# 70% patrol boat, 30% destroyer
	var ship: Node
	if randf() < 0.7:
		ship = PatrolBoatScene.instantiate()
	else:
		ship = DestroyerScene.instantiate()

	var x_pos := randf_range(40.0, 440.0)
	ship.position = Vector2(x_pos, -40.0)
	add_child(ship)
