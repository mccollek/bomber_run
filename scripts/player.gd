extends Area2D

const SPEED := 200.0
const MARGIN := 8.0

@onready var sprite: Sprite2D = $Sprite2D

var viewport_rect: Rect2

func _ready() -> void:
	viewport_rect = get_viewport_rect()
	position = Vector2(viewport_rect.size.x / 2.0, viewport_rect.size.y - 80.0)

func _process(delta: float) -> void:
	var input := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	position += input * SPEED * delta

	# Clamp to screen bounds
	position.x = clampf(position.x, MARGIN, viewport_rect.size.x - MARGIN)
	position.y = clampf(position.y, MARGIN, viewport_rect.size.y - MARGIN)

	# Banking animation
	if input.x < -0.1:
		sprite.frame = 1  # bank left
	elif input.x > 0.1:
		sprite.frame = 2  # bank right
	else:
		sprite.frame = 0  # center
