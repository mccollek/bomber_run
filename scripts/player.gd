extends Area2D

const SPEED := 200.0
const MARGIN := 8.0
const FIRE_RATE := 0.15
const GUN_OFFSET_X := 6.0
const GUN_OFFSET_Y := -8.0
const INVINCIBILITY_DURATION := 1.0
const FLASH_RATE := 0.08
const BOMB_COOLDOWN := 1.0

var BulletScene: PackedScene = preload("res://scenes/player/player_bullet.tscn")
var BombScene: PackedScene = preload("res://scenes/player/player_bomb.tscn")

@onready var sprite: Sprite2D = $Sprite2D
@onready var fire_timer: Timer = $FireTimer

var viewport_rect: Rect2
var can_fire := true
var can_bomb := true
var invincible := false
var _invincibility_timer := 0.0
var _flash_timer := 0.0
var _bomb_cooldown_timer := 0.0

func _ready() -> void:
	viewport_rect = get_viewport_rect()
	position = Vector2(viewport_rect.size.x / 2.0, viewport_rect.size.y - 80.0)
	fire_timer.wait_time = FIRE_RATE
	fire_timer.one_shot = true
	fire_timer.timeout.connect(_on_fire_timer_timeout)
	area_entered.connect(_on_area_entered)

func _process(delta: float) -> void:
	if GameManager.state != GameManager.State.PLAYING:
		visible = GameManager.state == GameManager.State.PLAYING
		return

	visible = true
	# Movement
	var input := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	position += input * SPEED * delta
	position.x = clampf(position.x, MARGIN, viewport_rect.size.x - MARGIN)
	position.y = clampf(position.y, MARGIN, viewport_rect.size.y - MARGIN)

	# Banking animation
	if input.x < -0.1:
		sprite.frame = 1
	elif input.x > 0.1:
		sprite.frame = 2
	else:
		sprite.frame = 0

	# Firing
	if Input.is_action_pressed("shoot") and can_fire:
		_fire()

	# Bombing
	if Input.is_action_just_pressed("bomb") and can_bomb and GameManager.bombs > 0:
		_drop_bomb()

	# Bomb cooldown
	if not can_bomb:
		_bomb_cooldown_timer -= delta
		if _bomb_cooldown_timer <= 0.0:
			can_bomb = true

	# Invincibility flash
	if invincible:
		_invincibility_timer -= delta
		_flash_timer -= delta
		if _flash_timer <= 0.0:
			_flash_timer = FLASH_RATE
			sprite.visible = not sprite.visible
		if _invincibility_timer <= 0.0:
			invincible = false
			sprite.visible = true

func take_damage(amount: int) -> void:
	if invincible:
		return
	GameManager.health -= amount
	AudioManager.play_sfx("hit_player")
	invincible = true
	_invincibility_timer = INVINCIBILITY_DURATION
	_flash_timer = FLASH_RATE
	if GameManager.health <= 0:
		_die()

func _die() -> void:
	GameManager.spawn_explosion(global_position, true)
	GameManager.state = GameManager.State.GAME_OVER
	GameManager.game_over.emit()
	visible = false
	set_process(false)

func _on_area_entered(area: Area2D) -> void:
	if area.collision_layer & 64:  # EnemyBullets layer
		take_damage(1)
		area.queue_free()
	elif area.collision_layer & 8:  # AirEnemies layer
		take_damage(1)

func _fire() -> void:
	can_fire = false
	fire_timer.start()
	AudioManager.play_sfx("shoot")

	var projectiles := get_tree().get_first_node_in_group("projectiles")
	if not projectiles:
		projectiles = get_parent()

	var bullet_l := BulletScene.instantiate()
	bullet_l.position = global_position + Vector2(-GUN_OFFSET_X, GUN_OFFSET_Y)
	projectiles.add_child(bullet_l)

	var bullet_r := BulletScene.instantiate()
	bullet_r.position = global_position + Vector2(GUN_OFFSET_X, GUN_OFFSET_Y)
	projectiles.add_child(bullet_r)

func _drop_bomb() -> void:
	GameManager.bombs -= 1
	can_bomb = false
	_bomb_cooldown_timer = BOMB_COOLDOWN
	AudioManager.play_sfx("bomb_drop")

	var projectiles := get_tree().get_first_node_in_group("projectiles")
	if not projectiles:
		projectiles = get_parent()

	var bomb := BombScene.instantiate()
	bomb.position = global_position
	projectiles.add_child(bomb)

func _on_fire_timer_timeout() -> void:
	can_fire = true
