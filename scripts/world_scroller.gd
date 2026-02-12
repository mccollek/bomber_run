extends Node2D

## Manages scrolling island chunks over the ocean.

const ISLAND_TEXTURES: Array[String] = [
	"res://assets/sprites/island_small.png",
	"res://assets/sprites/island_medium.png",
	"res://assets/sprites/island_large.png",
	"res://assets/sprites/island_archipelago.png",
	"res://assets/sprites/island_long.png",
	"res://assets/sprites/island_tiny.png",
]

const MIN_GAP := 300.0   # minimum vertical gap between islands
const MAX_GAP := 600.0   # maximum vertical gap
const DESPAWN_Y := 800.0  # below viewport

var _loaded_textures: Array[Texture2D] = []
var _next_spawn_y := -200.0  # y position to spawn next island (in world coords)

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
		# Despawn if below screen
		if child.position.y > DESPAWN_Y:
			child.queue_free()

	# Track virtual scroll position for spawning
	_next_spawn_y += scroll

	# Spawn new islands when needed
	while _next_spawn_y >= 0.0:
		_spawn_island()

func _spawn_island() -> void:
	var tex: Texture2D = _loaded_textures.pick_random()
	var sprite := Sprite2D.new()
	sprite.texture = tex
	sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST

	# Random horizontal position (keep island within viewport width)
	var tex_w := tex.get_width()
	var margin := tex_w / 2.0 + 10.0
	var x_pos := randf_range(margin, 480.0 - margin)

	# Place above viewport
	sprite.position = Vector2(x_pos, -tex.get_height() / 2.0)
	add_child(sprite)

	# Schedule next island
	var gap := randf_range(MIN_GAP, MAX_GAP)
	_next_spawn_y = -gap
