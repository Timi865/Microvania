extends Node2D

@onready var orbs: Array[Orb] = [$Orb0, $Orb1, $Orb2]#this is an array: 0,1,2
@onready var Player: CharacterBody2D = get_parent()

var target_positions := [
	Vector2(-16, -14),
	Vector2(2, -14),
	Vector2(20, -14),
]

func _ready() -> void:
	for orb in orbs:
		orb.formation_position = orb.position
		
	

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("orb_throw"):
		var direction := Vector2.RIGHT
	
		if Player.look_dir_x < 0:
			direction = Vector2.LEFT
	
		orbs[1].launch(direction)
