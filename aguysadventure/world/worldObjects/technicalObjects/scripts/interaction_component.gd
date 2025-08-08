extends Node

@onready var interactionCollider: Area3D = $interactionCollider
@onready var interactionParticle: CPUParticles3D = $InteractionParticle

@export var interactionAreaRadius: float = 1.5

signal interacted

func _ready() -> void:
	var collisionShape = $interactionCollider/CollisionShape3D
	collisionShape.shape.radius = interactionAreaRadius

func _physics_process(_delta: float) -> void:
	for x in interactionCollider.get_overlapping_bodies():
		if x.is_in_group("CanInteract"):
			interactionParticle.emitting = true
		else:
			interactionParticle.emitting = false
	
	if interactionParticle.emitting and Input.is_action_just_pressed("press_E"):
		emit_signal("interacted")
