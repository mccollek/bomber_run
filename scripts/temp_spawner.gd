extends Node

## Temporary spawner — will be replaced by wave spawner in TICK-13.

var FighterScene: PackedScene = preload("res://scenes/enemies/enemy_fighter.tscn")

const SPAWN_INTERVAL := 1.5
const PATTERNS := [0, 0, 0, 1, 2, 3]  # weighted toward straight

var _timer := 0.0

func _process(delta: float) -> void:
	if GameManager.state != GameManager.State.PLAYING:
		return

	_timer -= delta
	if _timer <= 0.0:
		_timer = SPAWN_INTERVAL / GameManager.difficulty_level
		_spawn_fighter()

func _spawn_fighter() -> void:
	var enemies := get_tree().get_first_node_in_group("air_enemies")
	if not enemies:
		return

	var fighter := FighterScene.instantiate()
	fighter.position = Vector2(randf_range(30.0, 450.0), -30.0)
	fighter.set("pattern", PATTERNS.pick_random())
	enemies.add_child(fighter)
