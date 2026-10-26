extends CharacterBody2D

@onready var animation_tree:AnimationTree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")
var was_on_floor: bool = false
var is_landing: bool = false



#const DashVisual_preload = preload("res://Scenes/dash_visual.tscn")

@export_category("Movement")
@export var MAX_SPEED: float = 90.0
@export var ACCELERATION: float = 22.5
@export var FRICTION: float = 28.0
@export var JUMP_HEIGHT: float = -250.0
@export var GRAVITY: float = 16.5

var look_dir_x: int = 1

var dash_unlocked: bool = true#set to true later
var is_ground_attacking: bool = false
var is_air_attacking: bool = false
var attack_number: int = 1
var previous_dash_dir: int = 1

@export_category("Dash")
@export var DASH_SPEED: float = 200
@export var DASH_TIME: float = 0.25
@export var DASH_COOLDOWN: float = 0.7
var can_dash: bool = true
var dash_timer: float = 0.0
var dash_cooldown_timer: float = 0.0

@export_category("Visual")
@export var spawn_visual_interval_dash: float = 0.2
var spawn_visual_timer: float = 0.0

func _ready() -> void:
	animation_tree.active = true
	was_on_floor = is_on_floor()

func _physics_process(delta: float) -> void:
	var x_input: float = Input.get_axis("Move_left", "Move_right")
	if dash_timer > 0.0 and x_input != 0:
		var input_dir := int(sign(x_input))
		velocity.y = 0

		if input_dir != previous_dash_dir:
			velocity.x = DASH_SPEED * input_dir
			look_dir_x = input_dir
			previous_dash_dir = input_dir
			$Sprite2D.flip_h = input_dir < 0
		
		
	var attack_speed_multiplier: float = 0.5
	var current_max_speed = MAX_SPEED * attack_speed_multiplier if is_ground_attacking else MAX_SPEED
	if dash_timer <= 0.0:#this is the normal player movement
		var velocity_weight_x: float = 1.0 - exp( -(ACCELERATION if x_input else FRICTION) * delta)
		velocity.x = lerp(velocity.x, x_input * current_max_speed ,velocity_weight_x)#framerate independent smooth dash bullshit
		

	if dash_cooldown_timer > 0.0:
		dash_cooldown_timer -= delta#if the cooldown timer is greater than zero count it down using delta
	
	if x_input:
		look_dir_x = int(x_input)
		
	if x_input != 0 and dash_timer <= 0.0:
		$Sprite2D.flip_h = x_input < 0
 
		
	if is_on_floor() and Input.is_action_just_pressed("Jump"):
		var current_state: StringName = state_machine.get_current_node()
		velocity.y = JUMP_HEIGHT
		state_machine.travel("JUMP")
		
		
	velocity.y += GRAVITY
	
	
	if dash_unlocked:
		_dash_logic(delta)
	
	if is_on_floor():
		if dash_timer == 0.0 and !can_dash:
			can_dash = true
			


	move_and_slide()

	var on_floor_now: bool = is_on_floor()

	if on_floor_now and !was_on_floor:
		is_landing = true
		state_machine.travel("LAND")

	_update_animation(x_input)

	if is_landing and state_machine.get_current_node() == &"IDLE":
		is_landing = false

	was_on_floor = on_floor_now

func _dash_logic(delta: float) -> void:
	if can_dash and dash_cooldown_timer <= 0.0 and Input.is_action_just_pressed("dash"):
		dash_cooldown_timer = DASH_COOLDOWN
		_start_dash()

	if dash_timer > 0.0:
		dash_timer = max(0.0, dash_timer - delta)
	if is_on_wall():
		dash_timer = 0.0

	#spawn_visual_timer += delta
	#if spawn_visual_timer >= spawn_visual_interval_dash:
		#spawn_visual_timer = 0.0


func _start_dash() -> void:
	can_dash = false
	dash_timer = DASH_TIME
	velocity.x = DASH_SPEED * look_dir_x
	velocity.y = 0
	spawn_visual_timer = 0.0
	previous_dash_dir = look_dir_x
	
func _update_animation(x_input: float) -> void:
	var current_state: StringName = state_machine.get_current_node()

	# Dash
	if dash_timer > 0.0:
		if current_state != &"DASH":
			state_machine.travel("DASH")
		return

	
	# Landing animation
	if is_landing:
		return

# Jump animation while rising
	if !is_on_floor():
		if velocity.y < 0.0:
			if current_state != &"JUMP":
				state_machine.travel("JUMP")
		return

	# Return to ground animations after landing or dashing
	if current_state == &"DASH" or current_state == &"JUMP" or current_state == &"LAND":
		if abs(x_input) > 0.0:
			state_machine.travel("IDLE to WALK")
		else:
			state_machine.travel("IDLE")
		return

	# Don't change ground animations while airborne
	if !is_on_floor():
		return

	if abs(x_input) > 0.0:
		if current_state == &"IDLE":
			state_machine.travel("IDLE to WALK")
		elif current_state == &"WALK to IDLE":
			state_machine.travel("WALK")
	elif current_state == &"WALK":
		state_machine.travel("WALK to IDLE")
	elif current_state == &"IDLE to WALK":
		state_machine.travel("IDLE")
	
#func _spawn_dash_visual() -> void:
	#var new_dash_visual: Sprite2D = DashVisual_preload.instantiate()
	#new_dash_visual.global_position = global_position
	#new_dash_visual.flip_h = $Sprite2D.flip_h
	#get_parent().add_child(new_dash_visual)
			
	
#func _animation(x_input: float) -> void:
	#$sprite2D.flip_h = false if look_dir_x . 0 else true
	
	#if dash_timer . 0.0 or super_dash_charge_timer >= SUPER_DASH_CHARGE_COST:
		#frame_anim.play("dash")
	#elif is_on_floor():
		#frame_anim.play("walk" if x_input or super_dash_charge_timer != 0.0 else "idle")
	#else:
		#frame_anim.play("fall" if velocity.y > 0 else "jump")
		
		
