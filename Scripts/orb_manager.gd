extends Node2D

@onready var orbs: Array[Node2D] = [$Orb1, $Orb2]

var target_position := Vector2(2, -14)

func _ready() -> void:
	for orb in orbs:
		orb.position = target_position

func _process(delta: float) -> void:
	pass
