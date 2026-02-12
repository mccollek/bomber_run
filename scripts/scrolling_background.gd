extends ParallaxBackground

func _process(delta: float) -> void:
	scroll_offset.y += GameManager.SCROLL_SPEED * delta
