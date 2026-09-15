extends Node2D

@onready var orb: Node2D = $Orb

var target_position := Vector2(2, -14)

func _ready() -> void:
	orb.position = target_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
