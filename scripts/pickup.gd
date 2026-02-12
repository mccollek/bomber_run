extends Area2D

## Collectible pickup — health or bomb refill.
## Bobs gently, pulses brightness, despawns after timeout.

enum Type { HEALTH, BOMB }

var HealthTex: Texture2D = preload("res://assets/sprites/pickup_health.png")
var BombTex: Texture2D = preload("res://assets/sprites/pickup_bomb.png")

@export var type: Type = Type.HEALTH

@onready var sprite: Sprite2D = $Sprite2D

const DESPAWN_TIME := 6.0
const BOB_SPEED := 3.0
const BOB_AMOUNT := 3.0
const DRIFT_SPEED := 30.0  # drifts down slowly

var _lifetime := 0.0
var _start_y := 0.0

func _ready() -> void:
	match type:
		Type.HEALTH:
			sprite.texture = HealthTex
		Type.BOMB:
			sprite.texture = BombTex
	_start_y = position.y
	area_entered.connect(_on_area_entered)

func _process(delta: float) -> void:
	_lifetime += delta

	# Drift downward
	position.y += DRIFT_SPEED * delta

	# Bob up and down
	sprite.position.y = sin(_lifetime * BOB_SPEED) * BOB_AMOUNT

	# Pulse brightness
	var pulse: float = 1.0 + 0.3 * sin(_lifetime * 5.0)
	sprite.modulate = Color(pulse, pulse, pulse, 1.0)

	# Blink before despawn
	if _lifetime > DESPAWN_TIME - 1.5:
		sprite.visible = fmod(_lifetime, 0.15) < 0.075

	if _lifetime >= DESPAWN_TIME:
		queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.collision_layer & 1:  # Player layer
		_collect()

func _collect() -> void:
	match type:
		Type.HEALTH:
			GameManager.health += 1
		Type.BOMB:
			GameManager.bombs += 1
	queue_free()
