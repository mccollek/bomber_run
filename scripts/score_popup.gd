extends Label

## Floating score number that drifts up and fades out.

const FLOAT_SPEED := 40.0
const DURATION := 0.8

var _timer := 0.0

func setup(value: int, pos: Vector2) -> void:
	text = "+%d" % value
	global_position = pos - Vector2(20, 10)
	modulate = Color.YELLOW

func _process(delta: float) -> void:
	_timer += delta
	position.y -= FLOAT_SPEED * delta
	modulate.a = 1.0 - _timer / DURATION
	if _timer >= DURATION:
		queue_free()
