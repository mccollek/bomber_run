extends Area2D

## AA gun emplacement — sits on islands, turret tracks player, fires aimed bullets.
## Only vulnerable to bombs (collision_mask = PlayerBombs layer 3 = bit 4).

var BulletScene: PackedScene = preload("res://scenes/enemies/enemy_bullet.tscn")
var DestroyedTex: Texture2D = preload("res://assets/sprites/aa_destroyed.png")

@export var hp := 3
@export var score_value := 300
@export var fire_interval := 2.0
@export var bullet_speed := 180.0

@onready var turret: Sprite2D = $Turret
@onready var base_sprite: Sprite2D = $Base

var _fire_timer := 0.0
var _flash_timer := 0.0
var _destroyed := false

func _ready() -> void:
	_fire_timer = randf_range(0.8, fire_interval)

func _process(delta: float) -> void:
	if _destroyed:
		return

	# Only act when on screen
	if global_position.y < -20.0 or global_position.y > 740.0:
		return

	# Rotate turret toward player
	var player := get_tree().get_first_node_in_group("player")
	if player:
		var angle: float = (player.global_position - global_position).angle() + PI / 2.0
		turret.rotation = angle

	# Fire timer
	_fire_timer -= delta
	if _fire_timer <= 0.0:
		_fire_timer = fire_interval
		_fire()

	# Hit flash cooldown
	if _flash_timer > 0.0:
		_flash_timer -= delta
		if _flash_timer <= 0.0:
			base_sprite.modulate = Color.WHITE
			turret.modulate = Color.WHITE

func _fire() -> void:
	var player := get_tree().get_first_node_in_group("player")
	if not player:
		return

	var projectiles := get_tree().get_first_node_in_group("projectiles")
	if not projectiles:
		return

	var dir: Vector2 = (player.global_position - global_position).normalized()
	var bullet := BulletScene.instantiate()
	bullet.position = global_position
	bullet.velocity = dir * bullet_speed
	projectiles.add_child(bullet)

func take_damage(amount: int) -> void:
	if _destroyed:
		return
	hp -= amount
	if hp <= 0:
		_destroy()
	else:
		_flash_hit()

func _destroy() -> void:
	_destroyed = true
	GameManager.add_score(score_value, global_position)
	GameManager.spawn_explosion(global_position, false)
	# Replace with destroyed sprite
	turret.visible = false
	base_sprite.texture = DestroyedTex
	# Disable collision
	set_deferred("monitoring", false)
	set_deferred("monitorable", false)

func _flash_hit() -> void:
	base_sprite.modulate = Color(4.0, 4.0, 4.0, 1.0)
	turret.modulate = Color(4.0, 4.0, 4.0, 1.0)
	_flash_timer = 0.08
