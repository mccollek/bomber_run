extends Area2D

## AA gun emplacement — sits on islands, turret tracks player, fires aimed bullets.
## Only vulnerable to bombs (collision_mask = PlayerBombs layer 3 = bit 4).

var BulletScene: PackedScene = preload("res://scenes/enemies/enemy_bullet.tscn")
var DestroyedTex: Texture2D = preload("res://assets/sprites/aa_destroyed.png")

@export var hp := 3
@export var score_value := 300
@export var burst_cooldown := 3.0  # seconds between bursts
@export var burst_count := 3
@export var burst_shot_delay := 0.15  # seconds between shots in a burst
@export var bullet_speed := 180.0
@export var engage_range := 200.0  # only fire when player is within this distance
@export var turret_rotation_speed := 1.5  # radians per second

@onready var turret: Sprite2D = $Turret
@onready var base_sprite: Sprite2D = $Base

var _cooldown_timer := 0.0
var _burst_timer := 0.0
var _shots_remaining := 0
var _locked_dir := Vector2.ZERO  # aim direction locked during burst
var _flash_timer := 0.0
var _destroyed := false

func _ready() -> void:
	_cooldown_timer = randf_range(0.8, burst_cooldown)

func _process(delta: float) -> void:
	if _destroyed:
		return

	# Only act when on screen
	if global_position.y < -20.0 or global_position.y > 740.0:
		return

	var player := get_tree().get_first_node_in_group("player")
	var in_burst := _shots_remaining > 0

	# Rotate turret toward player — but lock direction during burst
	if player and not in_burst:
		var target_angle: float = (player.global_position - global_position).angle() + PI / 2.0
		var max_rot: float = turret_rotation_speed * delta
		turret.rotation = rotate_toward(turret.rotation, target_angle, max_rot)

	# Burst firing
	if in_burst:
		_burst_timer -= delta
		if _burst_timer <= 0.0:
			_burst_timer = burst_shot_delay
			_fire_locked()
	else:
		_cooldown_timer -= delta
		if _cooldown_timer <= 0.0 and player:
			var dist: float = global_position.distance_to(player.global_position)
			if dist <= engage_range:
				_start_burst(player)

	# Hit flash cooldown
	if _flash_timer > 0.0:
		_flash_timer -= delta
		if _flash_timer <= 0.0:
			base_sprite.modulate = Color.WHITE
			turret.modulate = Color.WHITE

func _start_burst(player: Node) -> void:
	_locked_dir = (player.global_position - global_position).normalized()
	_shots_remaining = burst_count
	_burst_timer = 0.0  # fire first shot immediately

func _fire_locked() -> void:
	var projectiles := get_tree().get_first_node_in_group("projectiles")
	if not projectiles:
		return
	AudioManager.play_sfx("enemy_shoot")

	var bullet := BulletScene.instantiate()
	bullet.position = global_position
	bullet.velocity = _locked_dir * bullet_speed
	projectiles.add_child(bullet)

	_shots_remaining -= 1
	if _shots_remaining <= 0:
		_cooldown_timer = burst_cooldown

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
