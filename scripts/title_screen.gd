extends CanvasLayer

## Title screen — shown on game launch.

@onready var prompt_label: Label = $Panel/VBox/PromptLabel
@onready var high_score_label: Label = $Panel/VBox/HighScoreLabel

var _active := true

func _ready() -> void:
	GameManager.state = GameManager.State.TITLE
	high_score_label.text = "HIGH SCORE: %07d" % GameManager.high_score
	AudioManager.play_music()

func _process(_delta: float) -> void:
	if not _active:
		return
	prompt_label.visible = fmod(Time.get_ticks_msec() / 1000.0, 0.8) < 0.5
	if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("shoot"):
		_start_game()

func _start_game() -> void:
	_active = false
	GameManager.reset()
	visible = false
