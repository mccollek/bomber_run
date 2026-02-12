extends Node2D

const FALL_DURATION := 0.8
const BLAST_RADIUS := 40.0
const BOMB_DAMAGE := 3

@onready var bomb_sprite: Sprite2D = $BombSprite
@onready var shadow_sprite: Sprite2D = $ShadowSprite

var _timer := 0.0
var _start_scale := Vector2(0.4, 0.4)
var _end_scale := Vector2(1.0, 1.0)
var _shadow_start := Vector2(0.3, 0.3)
var _shadow_end := Vector2(1.2, 1.2)

func _process(delta: float) -> void:
	_timer += delta
	var t := minf(_timer / FALL_DURATION, 1.0)

	# Bomb shrinks slightly then grows as it "falls"
	bomb_sprite.scale = _start_scale.lerp(_end_scale, t)
	bomb_sprite.modulate.a = 1.0 - t * 0.3

	# Shadow grows and darkens as bomb approaches ground
	shadow_sprite.scale = _shadow_start.lerp(_shadow_end, t)
	shadow_sprite.modulate.a = 0.3 + t * 0.5

	# Offset bomb sprite upward (simulates altitude), converging to shadow
	bomb_sprite.position.y = -30.0 * (1.0 - t)

	if _timer >= FALL_DURATION:
		_detonate()

func _detonate() -> void:
	GameManager.spawn_explosion(global_position, true)

	# Check blast radius against sea and ground enemies
	var space := get_world_2d().direct_space_state
	var query := PhysicsShapeQueryParameters2D.new()
	var circle := CircleShape2D.new()
	circle.radius = BLAST_RADIUS
	query.shape = circle
	query.transform = Transform2D(0, global_position)
	# Mask: SeaEnemies (bit 16) + GroundEnemies (bit 32)
	query.collision_mask = 16 + 32
	query.collide_with_areas = true
	query.collide_with_bodies = false

	var results := space.intersect_shape(query, 16)
	for result in results:
		var collider: Object = result["collider"]
		if collider.has_method("take_damage"):
			collider.take_damage(BOMB_DAMAGE)

	queue_free()
