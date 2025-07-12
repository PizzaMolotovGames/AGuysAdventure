extends CharacterBody3D

# --- Node References ---
@onready var Pivot: Node3D = $"pivot"
#@onready var cameraOrigin: Node3D = $cameraOrigin

# --- Movement Config ---
@export var WalkingSpeed: float = 5.0
@export var SprintingSpeed: float = 9.0
#@export var WeakJumpSpeed: float = 6.0
#@export var StrongJumpSpeed: float = 10.0
#@export var Gravity: float = 18.0
#@export var WeakFallSpeedMultiplier: float = 1.5
#@export var StrongFallSpeedMultiplier: float = 3.0
#@export var JumpCounterMin: int = 10
#@export var JumpCounterMax: int = 30
#@export var jumpLimiter: int = 8

# --- Mouse Config ---
#@export var sensitivity: float = 0.2

# --- Jump Buffer + Coyote Time ---
#@export var coyote_time: float = 0.2
#@export var jump_buffer_time: float = 0.2
#var coyote_timer: float = 0.0
#var jump_buffer_timer: float = 0.0

# --- State Management ---
var State: String = "Idle"
var Direction: Vector3 = Vector3.ZERO
var JumpCounter: int = 0

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

#var yaw: float= 0.0
#var pitch: float = 0.0
#
#func _input(event):
	#if event is InputEventMouseMotion:
		#yaw -= event.relative.x * sensitivity
		#pitch -= event.relative.y * sensitivity
		#pitch = clamp(pitch, -80, 45)
#
		## Apply yaw to the cameraOrigin (horizontal)
		#var yaw_quat = Quaternion(Vector3.UP, deg_to_rad(yaw))
		#cameraOrigin.rotation = yaw_quat.get_euler()
#
		## Apply pitch to the pivot (vertical)
		#var pitch_quat = Quaternion(Vector3.RIGHT, deg_to_rad(pitch))
		#cameraOrigin.rotation = pitch_quat.get_euler()
		
# --- Main Loop ---
func _physics_process(_delta: float) -> void:
	update_direction()
	#update_timers()
	#handle_input()
	state_logic()
	rotate_()
	move_and_slide()

# --- Input/State Transition ---
#func handle_input():
	#if Input.is_action_pressed("press_SPACE") and JumpCounter < JumpCounterMax:
		#JumpCounter += 1
	#if Input.is_action_just_pressed("press_SPACE"):
		#jump_buffer_timer = jump_buffer_time

#func update_timers():
	#if is_on_floor():
		#coyote_timer = coyote_time
	#else:
		#coyote_timer = max(coyote_timer, 0)
	#jump_buffer_timer = max(jump_buffer_timer, 0)

func update_direction():
	Direction = Vector3.ZERO
	if Input.is_action_pressed("press_W"):
		Direction.z -= 1
	if Input.is_action_pressed("press_S"):
		Direction.z += 1
	if Input.is_action_pressed("press_A"):
		Direction.x -= 1
	if Input.is_action_pressed("press_D"):
		Direction.x += 1
	Direction = Direction.normalized()
	Direction = Direction.rotated(Vector3.UP, deg_to_rad(45))

# --- State Dispatcher ---
func state_logic():
	match State:
		"Idle":
			state_idle()
		"Walking":
			state_walking()
		"Sprinting":
			state_sprinting()
		#"WeakJump":
			#state_weak_jump()
		#"StrongJump":
			#state_strong_jump()
		#"Falling":
			#state_falling()
		_:
			state_idle()  # fallback

# --- States ---
func state_idle():
	velocity.x = 0
	velocity.z = 0
	#apply_gravity()
	
	if Direction != Vector3.ZERO:
		if Input.is_action_pressed("press_SHIFT"):
			change_state("Sprinting")
		else:
			change_state("Walking")

	#try_jump()

func state_walking():
	velocity.x = Direction.x * WalkingSpeed
	velocity.z = Direction.z * WalkingSpeed
	#apply_gravity()

	if Input.is_action_pressed("press_SHIFT"):
		change_state("Sprinting")
	elif Direction == Vector3.ZERO:
		change_state("Idle")

	#try_jump()

func state_sprinting():
	velocity.x = Direction.x * SprintingSpeed
	velocity.z = Direction.z * SprintingSpeed
	#apply_gravity()

	if not Input.is_action_pressed("press_SHIFT"):
		change_state("Walking")
	elif Direction == Vector3.ZERO:
		change_state("Idle")

	#try_jump()

#func state_weak_jump():
	#velocity.y += WeakJumpSpeed
	#if abs(velocity.y) >= WeakJumpSpeed * jumpLimiter:
		#change_state("Falling")
#
#func state_strong_jump():
	#velocity.y += StrongJumpSpeed
	#if abs(velocity.y) >= StrongJumpSpeed * jumpLimiter:
		#change_state("Falling")

#func state_falling():
	#apply_gravity()
	#if is_on_floor():
		#change_state("Idle")

# --- Helper Functions ---
#func try_jump():
	#if jump_buffer_timer > 0 and coyote_timer > 0:
		#var jump_state = "StrongJump" if JumpCounter > JumpCounterMin else "WeakJump"
		#change_state(jump_state)
		#JumpCounter = 0
		#jump_buffer_timer = 0
		#coyote_timer = 0

#func apply_gravity():
	#if not is_on_floor():
		#if velocity.y > 0 and not Input.is_action_pressed("press_SPACE"):
			#velocity.y -= Gravity * StrongFallSpeedMultiplier
		#elif velocity.y > 0:
			#velocity.y -= Gravity * WeakFallSpeedMultiplier
		#else:
			#velocity.y -= Gravity * StrongFallSpeedMultiplier
	#elif velocity.y < 0:
		#velocity.y = 0

func rotate_():
	if Direction != Vector3.ZERO:
		Pivot.look_at(transform.origin + Vector3(Direction.x, 0, Direction.z), Vector3.UP)

func change_state(new_state: String):
	State = new_state
