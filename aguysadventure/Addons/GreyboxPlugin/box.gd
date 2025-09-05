@tool
extends StaticBody3D
class_name GreyboxBox

@export var size: Vector3 = Vector3(2, 2, 2) :
	set(value):
		size = value
		_update()

var mesh_instance: MeshInstance3D
var collision: CollisionShape3D

func _ready():
	if Engine.is_editor_hint():
		call_deferred("_ensure_children")
		call_deferred("_update")

func _ensure_children() -> void:
	if mesh_instance == null:
		mesh_instance = MeshInstance3D.new()
		mesh_instance.name = "Mesh"
		add_child(mesh_instance)
		if get_tree().edited_scene_root:
			mesh_instance.owner = get_tree().edited_scene_root

	if collision == null:
		collision = CollisionShape3D.new()
		collision.name = "Collision"
		add_child(collision)
		if get_tree().edited_scene_root:
			collision.owner = get_tree().edited_scene_root


func _update():
	_ensure_children()

	# Visual mesh
	var box = BoxMesh.new()
	box.size = size
	mesh_instance.mesh = box

	# Collision
	var shape = BoxShape3D.new()
	shape.size = size
	collision.shape = shape
