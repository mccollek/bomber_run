extends Node

## Wave-based enemy spawner with difficulty scaling.
## Replaces temp_spawner.gd (TICK-13).

var FighterScene: PackedScene = preload("res://scenes/enemies/enemy_fighter.tscn")
var PatrolBoatScene: PackedScene = preload("res://scenes/enemies/patrol_boat.tscn")
var DestroyerScene: PackedScene = preload("res://scenes/enemies/destroyer.tscn")

# Formation types
enum Formation { V_SHAPE, LINE, SINGLE_FILE, SCATTER }

# Patterns from enemy_fighter.gd: STRAIGHT=0, DIAGONAL_LEFT=1, DIAGONAL_RIGHT=2, DIVE=3
const PAT_STRAIGHT := 0
const PAT_DIAG_L := 1
const PAT_DIAG_R := 2
const PAT_DIVE := 3

# Wave definitions: each wave is a dictionary
# { "count": int, "formation": Formation, "pattern": int, "delay": float }
const BASE_WAVES := [
	{ "count": 3, "formation": Formation.LINE, "pattern": PAT_STRAIGHT },
	{ "count": 4, "formation": Formation.V_SHAPE, "pattern": PAT_STRAIGHT },
	{ "count": 3, "formation": Formation.SINGLE_FILE, "pattern": PAT_DIAG_L },
	{ "count": 3, "formation": Formation.SINGLE_FILE, "pattern": PAT_DIAG_R },
	{ "count": 5, "formation": Formation.SCATTER, "pattern": PAT_STRAIGHT },
	{ "count": 3, "formation": Formation.V_SHAPE, "pattern": PAT_DIVE },
	{ "count": 4, "formation": Formation.LINE, "pattern": PAT_STRAIGHT },
	{ "count": 3, "formation": Formation.SCATTER, "pattern": PAT_DIVE },
]

const BASE_WAVE_INTERVAL := 4.0   # seconds between waves at difficulty 1
const MIN_WAVE_INTERVAL := 1.5    # minimum gap even at high difficulty
const QUIET_DURATION := 2.5       # brief rest between intensity peaks
const MILESTONE_INTERVAL := 60.0  # seconds between milestone waves

var _wave_timer := 3.0  # initial delay before first wave
var _wave_index := 0
var _waves_since_quiet := 0
var _next_milestone := 60.0  # elapsed_time threshold for next milestone

func _process(delta: float) -> void:
	if GameManager.state != GameManager.State.PLAYING:
		return

	_wave_timer -= delta
	if _wave_timer <= 0.0:
		# Check for milestone wave
		if GameManager.elapsed_time >= _next_milestone:
			_spawn_milestone_wave()
			_next_milestone += MILESTONE_INTERVAL
			_wave_timer = QUIET_DURATION + 1.0
			_waves_since_quiet = 0
			return

		# Pacing: quiet period every 4-5 waves
		_waves_since_quiet += 1
		if _waves_since_quiet >= 5:
			_waves_since_quiet = 0
			_wave_timer = QUIET_DURATION
			return

		_spawn_wave()

		# Scale wave interval with difficulty (faster waves over time)
		var interval: float = BASE_WAVE_INTERVAL / GameManager.difficulty_level
		_wave_timer = maxf(interval, MIN_WAVE_INTERVAL)

func _spawn_wave() -> void:
	var wave: Dictionary = BASE_WAVES[_wave_index]
	_wave_index = (_wave_index + 1) % BASE_WAVES.size()

	var count: int = wave["count"] + _bonus_enemies()
	var formation: int = wave["formation"]
	var pattern: int = wave["pattern"]

	var positions: Array[Vector2] = _get_formation_positions(count, formation)

	var enemies := get_tree().get_first_node_in_group("air_enemies")
	if not enemies:
		return

	for i in count:
		var fighter := FighterScene.instantiate()
		fighter.position = positions[i]
		fighter.set("pattern", pattern)
		# Scale fire rate with difficulty
		var base_interval: float = 2.0
		fighter.set("fire_interval", base_interval / minf(GameManager.difficulty_level, 3.0))
		enemies.add_child(fighter)

func _get_formation_positions(count: int, formation: int) -> Array[Vector2]:
	var positions: Array[Vector2] = []
	var center_x: float = randf_range(80.0, 400.0)
	var start_y := -30.0

	match formation:
		Formation.V_SHAPE:
			for i in count:
				var side: float = 1.0 if i % 2 == 0 else -1.0
				var row: int = (i + 1) / 2
				var x: float = center_x + side * row * 30.0
				var y: float = start_y - row * 25.0
				positions.append(Vector2(clampf(x, 20.0, 460.0), y))

		Formation.LINE:
			var total_width: float = (count - 1) * 40.0
			var left_x: float = clampf(center_x - total_width / 2.0, 20.0, 460.0 - total_width)
			for i in count:
				positions.append(Vector2(left_x + i * 40.0, start_y))

		Formation.SINGLE_FILE:
			for i in count:
				positions.append(Vector2(center_x, start_y - i * 35.0))

		Formation.SCATTER:
			for i in count:
				var x: float = randf_range(30.0, 450.0)
				var y: float = start_y - randf_range(0.0, 80.0)
				positions.append(Vector2(x, y))

	return positions

func _bonus_enemies() -> int:
	# Add more enemies as difficulty increases
	var extra: float = (GameManager.difficulty_level - 1.0) * 0.8
	return int(extra)

func _spawn_milestone_wave() -> void:
	# Large combined assault: big air formation + extra sea ships
	var enemies := get_tree().get_first_node_in_group("air_enemies")
	if enemies:
		var count := 7 + _bonus_enemies()
		var positions: Array[Vector2] = _get_formation_positions(count, Formation.V_SHAPE)
		for i in count:
			var fighter := FighterScene.instantiate()
			fighter.position = positions[i]
			fighter.set("pattern", PAT_STRAIGHT)
			fighter.set("hp", 2)  # tougher milestone fighters
			enemies.add_child(fighter)

	# Spawn extra ships into ScrollingWorld so they scroll with everything else
	var world: Node = get_parent().get_node_or_null("ScrollingWorld")
	if world:
		for i in 2:
			var ship: Node
			if randf() < 0.4:
				ship = DestroyerScene.instantiate()
			else:
				ship = PatrolBoatScene.instantiate()
			ship.position = Vector2(randf_range(60.0, 420.0), -50.0 - i * 80.0)
			world.add_child(ship)
