class_name Orb
extends Area2D


enum State {
	ORBITING,
	FLYING,
	RETURNING,
	HIDDEN,
}


var state: State = State.ORBITING# this is what Match state is "MATCHING"


@export_category("Orb")
@export var follow_speed: float = 8.0
@export var physics_reaction: float = 0.08
@export var float_height: float = 2.0
@export var float_speed: float = 3.0

@export_category("Boomerang")
@export var fly_speed: float = 180
@export var fly_duration: float = 0.35
@export var return_speed: float = 12.0
@export var orb_damage: int = 1
@export var max_wall_bounces: int = 1
@export_flags_2d_physics var wall_collision_mask: int = 1


var fly_direction: Vector2 = Vector2.RIGHT
var fly_timer: float = 0.0
var wall_bounces_left: int = 0
var hit_enemies: Array[Node] = []

var start_position: Vector2
var time: float = 0.0
var formation_position: Vector2

func _ready() -> void:
	start_position = formation_position
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)

func _process(delta: float) -> void:
	time += delta
	
	match state:
		State.ORBITING:
			_orbiting(delta)
		
		State.FLYING:
			_flying(delta)
			
		State.RETURNING:
			_returning(delta)
			
		State.HIDDEN:
			_hidden()


func _orbiting(delta: float) -> void:
	var player = get_parent().get_parent()

	var target_position := formation_position

	# React to player velocity
	target_position.y -= player.velocity.y * physics_reaction
	target_position.x -= player.velocity.x * physics_reaction

	# Small floating motion
	target_position.y += sin(time * float_speed) * float_height

	position = position.lerp(
		target_position,
		follow_speed * delta
	)


func launch(direction: Vector2) -> void:
	if state != State.ORBITING:
		return

	fly_direction = direction.normalized()
	fly_timer = 0.0
	wall_bounces_left = max_wall_bounces
	hit_enemies.clear()
	state = State.FLYING
	
	
func _flying(delta: float) -> void:
	var start_position := global_position
	global_position += fly_direction * fly_speed * delta
	_bounce_if_wall_hit(start_position, global_position)
	fly_timer += delta

	if fly_timer >= fly_duration:
		state = State.RETURNING
	
func _returning(delta: float) -> void:
	var target := _get_formation_target()

	position = position.lerp(
		target,
		minf(return_speed * delta, 1.0)
	)

	if position.distance_to(target) < 2.0:
		state = State.ORBITING
		
		
func _get_formation_target() -> Vector2:
	var player = get_parent().get_parent()
	var target := formation_position

	# React to player velocity
	target.y -= player.velocity.y * physics_reaction
	target.x -= player.velocity.x * physics_reaction

	# Small floating motion
	target.y += sin(time * float_speed) * float_height

	return target

func _hidden() -> void:
	visible = false
	
func _on_body_entered(body: Node2D) -> void:
	if state != State.FLYING:
		return

	if _try_damage_enemy(body):
		state = State.RETURNING


func _on_area_entered(area: Area2D) -> void:
	if state != State.FLYING:
		return

	if _try_damage_enemy(area):
		state = State.RETURNING


func _try_damage_enemy(target: Node) -> bool:
	if hit_enemies.has(target):
		return false

	if target.has_method("take_damage"):
		target.take_damage(orb_damage)
	elif target.has_method("damage"):
		target.damage(orb_damage)
	elif target.has_method("hurt"):
		target.hurt(orb_damage)
	else:
		return false

	hit_enemies.append(target)
	return true


func _bounce_if_wall_hit(from: Vector2, to: Vector2) -> void:
	if wall_bounces_left <= 0:
		return

	var query := PhysicsRayQueryParameters2D.create(from, to)
	query.collision_mask = wall_collision_mask
	query.exclude = [self]

	var hit := get_world_2d().direct_space_state.intersect_ray(query)
	if hit.is_empty():
		return

	global_position = hit.position
	fly_direction = fly_direction.bounce(hit.normal).normalized()
	wall_bounces_left -= 1
