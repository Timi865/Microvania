extends CharacterBody2D


const MAX_SPEED: float = 150.0
const ACCELERATION: float = 18.5
const FRICTION: float = 22.5
const JUMP_HEIGHT: float = -165.5
const GRAVITY: float = 14.5

var look_dir_x: int = 1

var dash_unlocked: bool = true
const DASH_SPEED: float = 180
const DASH_TIME: float = 0.12
var can_dash: bool = true
var dash_timer: float = 0.0

var super_dash_unlocked: bool = true
const SUPER_DASH_SPEED: float = 280.0
const SUPER_DASH_CHARGE_COST: float = 0.5
var super_dash_timer: float = 0.0
var can_super_dash: bool = true




func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_HEIGHT

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("Move_left", "Move_right")
	if direction:
		velocity.x = direction * MAX_SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, MAX_SPEED)

	move_and_slide()
