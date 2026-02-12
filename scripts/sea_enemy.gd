extends Area2D

## Base script for sea enemies (patrol boats, destroyers).
## Ships don't move on their own — they scroll with the WorldScroller parent.

var BulletScene: PackedScene = preload("res://scenes/enemies/enemy_bullet.tscn")

@export var hp := 2
@export var score_value := 200
@export var fire_interval := 2.5
@export var bullet_count := 1  # 1 = single, 3 = spread
@export var bullet_speed := 200.0

@onready var sprite: Sprite2D = $Sprite2D

var _fire_timer := 0.0
var _flash_timer := 0.0

func _ready() -> void:
	_fire_timer = randf_range(0.5, fire_interval)

func _process(delta: float) -> void:
	# Only fire when on screen
	if global_position.y > 0.0 and global_position.y < 720.0:
		_fire_timer -= delta
		if _fire_timer <= 0.0:
			_fire_timer = fire_interval
			_fire()

	# Hit flash cooldown
	if _flash_timer > 0.0:
		_flash_timer -= delta
		if _flash_timer <= 0.0:
			sprite.modulate = Color.WHITE

func _fire() -> void:
	var projectiles := get_tree().get_first_node_in_group("projectiles")
	if not projectiles:
		return
	AudioManager.play_sfx("enemy_shoot")

	if bullet_count == 1:
		_spawn_bullet(projectiles, Vector2.UP * bullet_speed)
	else:
		# Spread pattern
		_spawn_bullet(projectiles, Vector2.UP * bullet_speed)
		_spawn_bullet(projectiles, Vector2(-0.3, -1.0).normalized() * bullet_speed)
		_spawn_bullet(projectiles, Vector2(0.3, -1.0).normalized() * bullet_speed)

func _spawn_bullet(parent: Node, vel: Vector2) -> void:
	var bullet := BulletScene.instantiate()
	bullet.position = global_position + Vector2(0, -10)
	bullet.velocity = vel
	parent.add_child(bullet)

func take_damage(amount: int) -> void:
	hp -= amount
	if hp <= 0:
		GameManager.add_score(score_value, global_position)
		GameManager.spawn_explosion(global_position, true)
		queue_free()
	else:
		_flash_hit()

func _flash_hit() -> void:
	sprite.modulate = Color(4.0, 4.0, 4.0, 1.0)
	_flash_timer = 0.08
