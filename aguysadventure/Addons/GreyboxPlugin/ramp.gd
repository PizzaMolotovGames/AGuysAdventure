@tool
extends StaticBody3D
class_name GreyboxRamp

# --- exported properties visible in the inspector ---
@export var width: float = 2.0:
	set(value):
		width = value
		_update()
@export var depth: float = 4.0:
	set(value):
		depth = value
		_update()
@export var height: float = 2.0:
	set(value):
		height = value
		_update()

@export var color: Color = Color(0.7, 0.7, 0.7):
	set(value):
		color = value
		if mesh_instance:
			_update_material()

# --- child nodes ---
var mesh_instance: MeshInstance3D
var collision: CollisionShape3D

# --- ready ---
func _ready():
	if Engine.is_editor_hint():
		_ensure_children()
		_update()

# --- ensure child nodes exist ---
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

# --- update mesh and collision ---
func _update() -> void:
	_ensure_children()

	# --- vertices ---
	var hw = width * 0.5
	var hd = depth * 0.5

	var v0 = Vector3(-hw, 0.0, -hd)  # back-left bottom
	var v1 = Vector3( hw, 0.0, -hd)  # back-right bottom
	var v2 = Vector3( hw, 0.0,  hd)  # front-right bottom
	var v3 = Vector3(-hw, 0.0,  hd)  # front-left bottom
	var v4 = Vector3(-hw, height, hd) # front-left top
	var v5 = Vector3( hw, height, hd) # front-right top

	var verts = PackedVector3Array([v0, v1, v2, v3, v4, v5])

	# --- triangles ---
	var idx = PackedInt32Array([
		0,1,2, 0,2,3,       # bottom
		3,2,5, 3,5,4,       # back vertical
		0,3,4, 0,4,1,       # left side
		1,2,5, 1,5,4,       # right side
		3,4,5, 3,5,2        # ramp slope
	])

	# --- normals ---
	var normals = _compute_normals(verts, idx)

	# --- build mesh ---
	var arrays = []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = verts
	arrays[Mesh.ARRAY_NORMAL] = normals
	arrays[Mesh.ARRAY_INDEX] = idx

	var a_mesh = ArrayMesh.new()
	a_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	mesh_instance.mesh = a_mesh

	# --- add simple material ---
	_update_material()

	# --- collision ---
	var shape = ConvexPolygonShape3D.new()
	shape.points = verts
	collision.shape = shape

# --- helper: update material ---
func _update_material() -> void:
	if mesh_instance.mesh:
		var mat := StandardMaterial3D.new()
		mat.albedo_color = color
		mesh_instance.material_override = mat

# --- helper: compute per-vertex normals ---
func _compute_normals(verts: PackedVector3Array, idx: PackedInt32Array) -> PackedVector3Array:
	var normals := []
	normals.resize(verts.size())
	for i in range(normals.size()):
		normals[i] = Vector3.ZERO

	for i in range(0, idx.size(), 3):
		var a = verts[idx[i]]
		var b = verts[idx[i + 1]]
		var c = verts[idx[i + 2]]
		var tri_n = (b - a).cross(c - a)
		if tri_n.length() > 0.00001:
			tri_n = tri_n.normalized()
		normals[idx[i]] += tri_n
		normals[idx[i + 1]] += tri_n
		normals[idx[i + 2]] += tri_n

	# normalize per-vertex sums
	for j in range(normals.size()):
		if normals[j].length() > 0.00001:
			normals[j] = normals[j].normalized()

	return PackedVector3Array(normals)
