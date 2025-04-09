class_name EdgeTemplate extends MeshInstance3D

const COLOR_SHIFT := 2


func set_color(color:Color):
	var material:ShaderMaterial = mesh.surface_get_material(0).duplicate()
	material.set_shader_parameter("color_shift", Vector3(-COLOR_SHIFT + (COLOR_SHIFT * color.r), -COLOR_SHIFT + (COLOR_SHIFT * color.g), -COLOR_SHIFT + (COLOR_SHIFT * color.b)))
	set_surface_override_material(0, material)
