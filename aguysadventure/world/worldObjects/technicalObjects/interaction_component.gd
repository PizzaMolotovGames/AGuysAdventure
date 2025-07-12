extends Node

@onready var interactionCollider: Area3D = $interactionCollider
@onready var interactionPaticle: CPUParticles3D = $InteractionParticle

func _physics_process(_delta: float) -> void:
	for x in interactionCollider.get_overlapping_bodies():
		if x.is_in_group("CanInteract"):
			interactionPaticle.emitting = true
		else:
			interactionPaticle.emitting = false
