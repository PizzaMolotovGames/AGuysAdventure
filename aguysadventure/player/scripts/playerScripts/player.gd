extends CharacterBody3D

@export var playerWalkingSpeed: float
@export var playerSprintingSpeed: float

@export var playerWeakJumpSpeed: float
@export var playerStrongJumpSpeed: float

var playerState: String = "Idle"
var playerStateArray: Array = ["Idle", "Attacking", "Walking", "Sprinting", "Stunned"]
var playerDirection: Vector3 = Vector3()

func _ready() -> void:
	pass

func _physics_process(_delta: float) -> void:
	if playerDirection != Vector3.ZERO:
		setPlayerState("Walking")
	else:
		setPlayerState("Idle")

	move()

func setPlayerState(state):
	if state in playerStateArray:
		playerState = state

func jump():
	pass

func attack():
	pass

func setDirection() -> void:
	if Input.is_action_pressed("press_W"):
		playerDirection.z -= 1
	if Input.is_action_pressed("press_S"):
		playerDirection.z += 1
	if Input.is_action_pressed("press_D"):
		playerDirection.x += 1
	if Input.is_action_pressed("press_A"):
		playerDirection.x -= 1
	return

func move():
	match playerState:
		"Walking":
			velocity = playerDirection * playerWalkingSpeed
		"Sprinting":
			velocity = playerDirection * playerSprintingSpeed
		"Idle":
			velocity = Vector3.ZERO
	
	move_and_slide()
