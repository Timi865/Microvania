extends Area2D

@export var follow_speed: float = 8.0
@export var physics_reaction: float = 0.08
@export var float_height: float = 2.0
@export var float_speed: float = 3.0

var start_position: Vector2
var time: float = 0.0

func _ready() -> void:
	start_position = position

func _process(delta: float) -> void:
	time += delta

	var player = get_parent().get_parent()

	var target_position := start_position

	# React to player velocity
	target_position.y -= player.velocity.y * physics_reaction
	target_position.x -= player.velocity.x * physics_reaction

	# Small floating motion
	target_position.y += sin(time * float_speed) * float_height

	position = position.lerp(target_position, follow_speed * delta)
