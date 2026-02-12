extends Area2D

var velocity := Vector2.DOWN * 300.0

func _process(delta: float) -> void:
	position += velocity * delta
	if position.y > 740.0 or position.y < -20.0 or position.x < -20.0 or position.x > 500.0:
		queue_free()
