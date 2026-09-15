extends Area2D

var start_position: Vector2
var time: float = 0.0

func _ready() -> void:
	start_position = position

func _process(delta: float) -> void:
	time += delta
	position.y = start_position.y + sin(time * 3.0) * 2.0
