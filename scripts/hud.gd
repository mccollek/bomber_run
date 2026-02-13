extends CanvasLayer

@onready var health_bar: HBoxContainer = $MarginContainer/TopBar/HealthSection/HealthBar
@onready var bomb_label: Label = $MarginContainer/TopBar/HealthSection/BombLabel
@onready var roll_label: Label = $MarginContainer/TopBar/HealthSection/RollLabel
@onready var score_label: Label = $MarginContainer/TopBar/ScoreSection/ScoreLabel
@onready var high_score_label: Label = $MarginContainer/TopBar/ScoreSection/HighScoreLabel

var _health_pips: Array[TextureRect] = []
var _pip_texture: Texture2D = preload("res://assets/sprites/health_pip.png")
var _bomb_texture: Texture2D = preload("res://assets/sprites/bomb_icon.png")

func _ready() -> void:
	GameManager.health_changed.connect(_on_health_changed)
	GameManager.score_changed.connect(_on_score_changed)
	GameManager.bombs_changed.connect(_on_bombs_changed)
	GameManager.rolls_changed.connect(_on_rolls_changed)

	_build_health_pips()
	_on_health_changed(GameManager.health)
	_on_score_changed(GameManager.score)
	_on_bombs_changed(GameManager.bombs)
	_on_rolls_changed(GameManager.rolls)
	high_score_label.text = "HI %07d" % GameManager.high_score

func _build_health_pips() -> void:
	for i in GameManager.MAX_HEALTH:
		var pip := TextureRect.new()
		pip.texture = _pip_texture
		pip.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		pip.custom_minimum_size = Vector2(12, 12)
		pip.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		health_bar.add_child(pip)
		_health_pips.append(pip)

func _on_health_changed(new_health: int) -> void:
	for i in _health_pips.size():
		var pip := _health_pips[i]
		if i < new_health:
			pip.visible = true
			if new_health <= 1:
				pip.modulate = Color.RED
			elif new_health <= 2:
				pip.modulate = Color.YELLOW
			else:
				pip.modulate = Color.WHITE
		else:
			pip.visible = false

func _on_score_changed(new_score: int) -> void:
	score_label.text = "%07d" % new_score

func _on_bombs_changed(new_count: int) -> void:
	bomb_label.text = "x%d" % new_count

func _on_rolls_changed(new_count: int) -> void:
	roll_label.text = "ROLL x%d" % new_count
	roll_label.modulate = Color.WHITE if new_count > 0 else Color(0.4, 0.4, 0.4, 1.0)
