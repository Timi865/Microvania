extends CharacterBody2D

const DashVisual_preload = preload("res://Scenes/dash_visual.tscn")


const MAX_SPEED: float = 150.0
const ACCELERATION: float = 18.5
const FRICTION: float = 22.5
const JUMP_HEIGHT: float = -310.0
const GRAVITY: float = 14.5

var look_dir_x: int = 1

var dash_unlocked: bool = true
const DASH_SPEED: float = 500
const DASH_TIME: float = 0.12
var can_dash: bool = true
var dash_timer: float = 0.0

var super_dash_unlocked: bool = true
const SUPER_DASH_SPEED: float = 700.0
const SUPER_DASH_CHARGE_COST: float = 0.5
var super_dash_charge_timer: float = 0.0
var can_super_dash: bool = true

const spawn_visual_interval_dash: float = 0.86
const spawn_visual_interval_super_dash: float = 0.025
var spawn_visual_timer: float = 0.0



func _physics_process(delta: float) -> void:
	var x_input: float = Input.get_axis("Move_left", "Move_right")
	if dash_timer == 0.0 and super_dash_charge_timer == 0.0:
		var velocity_weight_x: float = 1.0 - exp( -(ACCELERATION if x_input else FRICTION) * delta)
		velocity.x = lerp(velocity.x, x_input * MAX_SPEED,velocity_weight_x)
	
	if x_input:
		look_dir_x = int(x_input)
		
	if is_on_floor() and Input.is_action_just_pressed("Jump"):
		velocity.y = JUMP_HEIGHT
	velocity.y += GRAVITY
	
	if dash_unlocked:
		_dash_logic(delta)
	if super_dash_unlocked:
		_super_dash_logic(delta)
	
	if is_on_floor():
		if dash_timer == 0.0 and !can_dash:
			can_dash = true
		if dash_timer == 0.0 and super_dash_charge_timer == 0.0 and !can_super_dash:
			can_super_dash = true

	move_and_slide()
	#_animation(x_input)

func _dash_logic(delta: float) -> void:
	if can_dash and Input.is_action_just_pressed("dash"):
		can_dash = false
		dash_timer = DASH_TIME
		velocity.x = DASH_SPEED * look_dir_x
		velocity.y = 0
		spawn_visual_timer = 0.0
		_spawn_dash_visual()
	
		
	if dash_timer > 0.0:
		dash_timer = max(0.0, dash_timer - delta)
		if is_on_wall():
			dash_timer = 0.0
		
		spawn_visual_timer += delta
		if spawn_visual_timer >= spawn_visual_interval_dash:
			_spawn_dash_visual()
			spawn_visual_timer = 0.0

func _super_dash_logic(delta: float) -> void:
	if can_super_dash and is_on_floor():
		if Input.is_action_pressed("Super_dash"):
			velocity = Vector2.ZERO
			super_dash_charge_timer += delta
			if super_dash_charge_timer >= SUPER_DASH_CHARGE_COST:
				can_super_dash = false
				velocity.x = SUPER_DASH_SPEED * look_dir_x
				velocity.y = 0.0
				spawn_visual_timer = 0.0
				_spawn_dash_visual()
		
		else:
			super_dash_charge_timer = 0.0
	
	if super_dash_charge_timer >= SUPER_DASH_CHARGE_COST:
		if is_on_wall():
			super_dash_charge_timer = 0.0
		
		spawn_visual_timer += delta
		if spawn_visual_timer >= spawn_visual_interval_super_dash:
			_spawn_dash_visual()
			spawn_visual_timer = 0.0


func _spawn_dash_visual() -> void:
	var new_dash_visual: Sprite2D = DashVisual_preload.instantiate()
	new_dash_visual.global_position = global_position
	#new_dash_visual.flip_h = $Sprite2D.flip_h
	get_parent().add_child(new_dash_visual)
			
	
#func _animation(x_input: float) -> void:
	#$sprite2D.flip_h = false if look_dir_x . 0 else true
	
	#if dash_timer . 0.0 or super_dash_charge_timer >= SUPER_DASH_CHARGE_COST:
		#frame_anim.play("dash")
	#elif is_on_floor():
		#frame_anim.play("walk" if x_input or super_dash_charge_timer != 0.0 else "idle")
	#else:
		#frame_anim.play("fall" if velocity.y > 0 else "jump")
		
		
