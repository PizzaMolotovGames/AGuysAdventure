extends Node3D

@export var hitboxHeight: float = 2.0
@export var hitboxRadius: float = 0.5

func _ready() -> void:
	var hitboxShape = $HitBox/CollisionShape3D
	
	var interactionComponent: Node3D = $interactionComponent
	
	if hitboxHeight >= 1:
		hitboxShape.shape.height = hitboxHeight
	
	if hitboxRadius >= 0.5:
		hitboxShape.shape.radius = hitboxRadius
		
	interactionComponent.transform.origin.y = hitboxHeight / 2 + 0.3
