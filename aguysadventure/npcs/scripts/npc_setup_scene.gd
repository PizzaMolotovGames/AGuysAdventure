extends Node3D

@export var hitboxHeight: float = 2.0
@export var hitboxRadius: float = 0.5

func _ready() -> void:
	var hitboxShape = $HitBox/CollisionShape3D
	
	if hitboxHeight >= 1:
		hitboxShape.shape.height = hitboxHeight
	
	if hitboxRadius >= 0.5:
		hitboxShape.shape.radius = hitboxRadius
