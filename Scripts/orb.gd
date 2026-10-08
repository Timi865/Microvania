class_name Orb
extends Area2D


enum State {
	ORBITING,
	FLYING,
	RETURNING,
}


var state: State = State.ORBITING# this is what Match state is "MATCHING"



@export var follow_speed: float = 8.0
@export var physics_reaction: float = 0.08
@export var float_height: float = 2.0
@export var float_speed: float = 3.0

var start_position: Vector2
var time: float = 0.0
var formation_position: Vector2

func _ready() -> void:
	start_position = position

func _process(delta: float) -> void:
	time += delta
	
	match state:
		State.ORBITING:
			_orbiting(delta)
		
		State.FLYING:
			_flying(delta)
			
		State.RETURNING:
			_returning(delta)


func _orbiting(delta: float) -> void:
	var player = get_parent().get_parent()#this gets the grandparent node(player). This is quite Fragile though so ill have to do something more secure later

	var target_position := start_position

	# React to player velocity
	target_position.y -= player.velocity.y * physics_reaction
	target_position.x -= player.velocity.x * physics_reaction

	# Small floating motion
	target_position.y += sin(time * float_speed) * float_height

	position = position.lerp(target_position, follow_speed * delta)

func _flying(delta: float) -> void:
	position.x += 50.0 * delta
	
func _returning(delta: float) -> void:
	pass
	
