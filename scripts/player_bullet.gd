extends Area2D

const SPEED := 500.0

func _process(delta: float) -> void:
	position.y -= SPEED * delta
	if position.y < -16.0:
		queue_free()
