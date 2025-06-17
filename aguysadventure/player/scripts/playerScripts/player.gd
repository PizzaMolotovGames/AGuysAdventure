extends CharacterBody3D

@export var playerSpeed: int

var playerState: String
var playerStateArray: Array = ["Idle", "Attacking", "Walking", "Sprinting", "Stunned"]
var playerVelocity: Vector3 = Vector3()
var playerDirection: Vector3 = Vector3()

#----------------------------------------------------------------------------
func _ready() -> void:
	pass

#----------------------------------------------------------------------------
func _physics_process(_delta: float) -> void:
	pass

#----------------------------------------------------------------------------
func setPlayerState(state):
	if state in playerStateArray:
		playerState = state
	return

#----------------------------------------------------------------------------
func jump():
	pass

#----------------------------------------------------------------------------
func attack():
	pass

#----------------------------------------------------------------------------
func move():
	pass
