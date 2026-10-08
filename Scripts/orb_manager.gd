extends Node2D

@onready var orbs: Array[Orb] = [$Orb1, $Orb2, $Orb3]#this is an array: 0,1,2
@onready var Player: CharacterBody2D = get_parent()

var target_positions := [
	Vector2(-16, -14),
	Vector2(2, -14),
	Vector2(20, -14),
]

func _ready() -> void:
	for i in orbs.size():
		orbs[i].formation_position = target_positions[i]
		orbs[i].position = target_positions[i]
		
	

func _process(delta: float) -> void:
	pass
