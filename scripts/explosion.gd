extends Sprite2D

var _frame_timer := 0.0
var _frame_duration := 0.08
var _total_frames := 6

func setup(large: bool) -> void:
	if large:
		texture = preload("res://assets/sprites/explosion_large.png")
		hframes = 8
		_total_frames = 8
		_frame_duration = 0.07
	else:
		texture = preload("res://assets/sprites/explosion_small.png")
		hframes = 6
		_total_frames = 6
		_frame_duration = 0.08
	frame = 0

func _process(delta: float) -> void:
	_frame_timer += delta
	if _frame_timer >= _frame_duration:
		_frame_timer -= _frame_duration
		if frame + 1 >= _total_frames:
			queue_free()
		else:
			frame += 1
