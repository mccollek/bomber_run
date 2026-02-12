extends Area2D

enum Pattern { STRAIGHT, DIAGONAL_LEFT, DIAGONAL_RIGHT, DIVE }

const BASE_SPEED := 150.0
const SCORE_VALUE := 100

var BulletScene: PackedScene = preload("res://scenes/enemies/enemy_bullet.tscn")

@export var hp := 1
@export var pattern: Pattern = Pattern.STRAIGHT
@export var fire_interval := 2.0

@onready var sprite: Sprite2D = $Sprite2D

var velocity := Vector2.ZERO
var _fire_timer := 0.0
var _dive_target := Vector2.ZERO
var _has_dived := false
var _flash_timer := 0.0

func _ready() -> void:
	match pattern:
		Pattern.STRAIGHT:
			velocity = Vector2.DOWN * BASE_SPEED
		Pattern.DIAGONAL_LEFT:
			velocity = Vector2(-0.4, 1.0).normalized() * BASE_SPEED
		Pattern.DIAGONAL_RIGHT:
			velocity = Vector2(0.4, 1.0).normalized() * BASE_SPEED
		Pattern.DIVE:
			velocity = Vector2.DOWN * BASE_SPEED * 0.6

	_fire_timer = randf_range(0.5, fire_interval)

func _process(delta: float) -> void:
	# Dive pattern: accelerate toward player once mid-screen
	if pattern == Pattern.DIVE and not _has_dived and position.y > 200.0:
		var player := get_tree().get_first_node_in_group("player")
		if player:
			_dive_target = player.global_position
			velocity = (player.global_position - global_position).normalized() * BASE_SPEED * 1.5
			_has_dived = true

	position += velocity * delta

	# Fire at intervals
	_fire_timer -= delta
	if _fire_timer <= 0.0:
		_fire_timer = fire_interval
		_fire_bullet()

	# Hit flash cooldown
	if _flash_timer > 0.0:
		_flash_timer -= delta
		if _flash_timer <= 0.0:
			sprite.modulate = Color.WHITE

	# Cleanup when off screen
	if position.y > 760.0 or position.y < -60.0 or position.x < -60.0 or position.x > 540.0:
		queue_free()

func _fire_bullet() -> void:
	var projectiles := get_tree().get_first_node_in_group("projectiles")
	if not projectiles:
		return
	AudioManager.play_sfx("enemy_shoot")
	var bullet := BulletScene.instantiate()
	bullet.position = global_position + Vector2(0, 12)
	# WW2 fighters fire forward (straight down relative to their heading)
	bullet.velocity = velocity.normalized() * 300.0
	projectiles.add_child(bullet)

func take_damage(amount: int) -> void:
	hp -= amount
	if hp <= 0:
		GameManager.add_score(SCORE_VALUE, global_position)
		GameManager.spawn_explosion(global_position, false)
		queue_free()
	else:
		_flash_hit()

func _flash_hit() -> void:
	sprite.modulate = Color(4.0, 4.0, 4.0, 1.0)
	_flash_timer = 0.08
