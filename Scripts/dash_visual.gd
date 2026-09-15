extends Sprite2D

func _ready() -> void:
	var position_tween: Tween = create_tween().set_trans(Tween.TRANS_SINE)
	var look_dir: int = -1 if flip_h else 1
	position_tween.tween_property(self, "offset:x", 4*look_dir, 0.175)
	
	var visible_tween: Tween = create_tween().set_trans(Tween.TRANS_SINE)
	visible_tween.finished.connect(queue_free)
	visible_tween.tween_property(self, "modulate:a", 0.0, 0.018)
