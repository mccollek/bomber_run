extends Camera2D

## Attaches to the main scene for screen shake on large explosions.

var _shake_amount := 0.0
var _shake_timer := 0.0

func _ready() -> void:
	GameManager.enemy_destroyed.connect(_on_enemy_destroyed)

func _process(delta: float) -> void:
	if _shake_timer > 0.0:
		_shake_timer -= delta
		offset = Vector2(randf_range(-_shake_amount, _shake_amount), randf_range(-_shake_amount, _shake_amount))
		if _shake_timer <= 0.0:
			offset = Vector2.ZERO
	else:
		offset = Vector2.ZERO

func shake(amount: float, duration: float) -> void:
	_shake_amount = amount
	_shake_timer = duration

func _on_enemy_destroyed(score_value: int, _pos: Vector2) -> void:
	# Shake more for higher-value targets
	if score_value >= 300:
		shake(3.0, 0.12)
	elif score_value >= 200:
		shake(2.0, 0.08)
