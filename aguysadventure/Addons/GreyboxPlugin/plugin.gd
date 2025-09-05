extends EditorPlugin

func _enter_tree():
	add_custom_type(
		"GreyboxBox",                 # Name in the "Add Node" menu
		"StaticBody3D",             # Base class
		preload("res://Addons/GreyboxPlugin/box.gd"), # Script
		null                          # Optional icon (use null for now)
	)

	add_custom_type(
		"GreyboxRamp",
		"MeshInstance3D",
		preload("res://Addons/GreyboxPlugin/ramp.gd"),
		null
	)

func _exit_tree():
	remove_custom_type("GreyboxBox")
	remove_custom_type("GreyboxRamp")
