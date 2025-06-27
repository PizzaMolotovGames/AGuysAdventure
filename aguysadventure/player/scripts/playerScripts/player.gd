extends CharacterBody3D

#Player pivot variable activated on the first frame
@onready var playerPivot: Node3D = $"pivot"

#Player speeds variables
@export var playerWalkingSpeed: float
@export var playerSprintingSpeed: float
@export var playerWeakJumpSpeed: float
@export var playerStrongJumpSpeed: float
@export var playerFallSpeed: float

#Player state variable and Array
var playerState: String = "Idle"
var playerStateArray: Array = ["Idle", "Attacking", "Walking", "Sprinting", "Stunned", "WeakJump", "StrongJump"]

#Player direction based on input
var playerDirection: Vector3 = Vector3()

func _physics_process(_delta: float) -> void:
	setDirection()
	if checkDirectionalInput():
		setPlayerState("Walking")
		if Input.is_action_pressed("press_SHIFT"):
			setPlayerState("Sprinting")
	else:
		setPlayerState("Idle")
	
	if Input.is_action_pressed("press_SPACE"):
		pass
	
	rotatePlayerPivot()
	move()

func setPlayerState(state):
	if state in playerStateArray:
		playerState = state

func jump():
	pass

func attack():
	pass

func checkDirectionalInput():
	return Input.is_action_pressed("press_W") or Input.is_action_pressed("press_S") or Input.is_action_pressed("press_D") or Input.is_action_pressed("press_A")

func setDirection() -> void:
	playerDirection = Vector3.ZERO
	if Input.is_action_pressed("press_W"):
		playerDirection.z = -1
	if Input.is_action_pressed("press_S"):
		playerDirection.z = 1
	if Input.is_action_pressed("press_D"):
		playerDirection.x = 1
	if Input.is_action_pressed("press_A"):
		playerDirection.x = -1
	playerDirection = playerDirection.normalized()

func move():
	match playerState:
		"Walking":
			velocity = playerDirection * playerWalkingSpeed
		"Sprinting":
			velocity = playerDirection * playerSprintingSpeed
		"Idle":
			velocity = Vector3.ZERO
		"WeakJump":
			pass
	
	move_and_slide()

func rotatePlayerPivot():
	if playerDirection != Vector3.ZERO:
		playerPivot.look_at(global_transform.origin + Vector3(playerDirection.x, 0, playerDirection.z), Vector3.UP)
