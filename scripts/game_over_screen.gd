extends CanvasLayer

## Game over overlay — shows score, high score, and restart prompt.

@onready var panel: ColorRect = $Panel
@onready var game_over_label: Label = $Panel/VBox/GameOverLabel
@onready var score_label: Label = $Panel/VBox/ScoreLabel
@onready var high_score_label: Label = $Panel/VBox/HighScoreLabel
@onready var prompt_label: Label = $Panel/VBox/PromptLabel

var _show_timer := 0.0
var _active := false

func _ready() -> void:
	visible = false
	GameManager.game_over.connect(_on_game_over)

func _on_game_over() -> void:
	AudioManager.stop_music()
	_show_timer = 1.0  # delay before showing overlay
	_active = false

func _process(delta: float) -> void:
	if _show_timer > 0.0:
		_show_timer -= delta
		if _show_timer <= 0.0:
			_show()
		return

	if not _active:
		return

	# Blink restart prompt
	prompt_label.visible = fmod(Time.get_ticks_msec() / 1000.0, 0.8) < 0.5

	if Input.is_action_just_pressed("ui_accept"):
		_restart()

func _show() -> void:
	_active = true
	visible = true
	score_label.text = "SCORE: %07d" % GameManager.score
	var is_new := GameManager.check_high_score()
	if is_new:
		high_score_label.text = "NEW HIGH SCORE!"
		high_score_label.modulate = Color.YELLOW
	else:
		high_score_label.text = "HIGH: %07d" % GameManager.high_score
		high_score_label.modulate = Color(0.7, 0.7, 0.7, 1.0)

func _restart() -> void:
	_active = false
	visible = false
	# Clear all enemies, projectiles, effects
	_clear_group("air_enemies")
	_clear_group("projectiles")
	_clear_group("effects")
	# Clear world scroller children (islands, ships, AA guns)
	var world := get_tree().get_first_node_in_group("world_scroller")
	if world:
		for child in world.get_children():
			child.queue_free()
	# Reset game state
	GameManager.reset()
	# Reload main scene to get a clean slate
	get_tree().reload_current_scene()

func _clear_group(group_name: String) -> void:
	var container := get_tree().get_first_node_in_group(group_name)
	if container:
		for child in container.get_children():
			child.queue_free()
