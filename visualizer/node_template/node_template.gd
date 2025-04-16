class_name NodeMesh extends MeshInstance3D

@export var darkened_albedo:Texture2D
@export var highlighted_albedo:Texture2D

var original_albedo:Texture2D

const COLOR_SHIFT := 2

var node_text:String

func _ready():
	var material:ShaderMaterial = mesh.surface_get_material(0).duplicate()
	original_albedo = material.get_shader_parameter("texture_albedo")

func set_color(color:Color):
	var material:ShaderMaterial = mesh.surface_get_material(0).duplicate()
	material.set_shader_parameter("color_shift", Vector3(-COLOR_SHIFT + (COLOR_SHIFT * color.r), -COLOR_SHIFT + (COLOR_SHIFT * color.g), -COLOR_SHIFT + (COLOR_SHIFT * color.b)))
	set_surface_override_material(0, material)

func _on_area_3d_area_entered(area: Area3D) -> void:
	Interactor.text = node_text


func _on_area_3d_body_entered(body: Node3D) -> void:
	Global.camera_controller.interactor.text = node_text


func darken():
	var material:ShaderMaterial = mesh.surface_get_material(0).duplicate()
	material.set_shader_parameter("texture_albedo", darkened_albedo)
	set_surface_override_material(0, material)


func highlight():
	var material:ShaderMaterial = mesh.surface_get_material(0).duplicate()
	material.set_shader_parameter("texture_albedo", highlighted_albedo)
	set_surface_override_material(0, material)


# ----------------------- #
# -         Node        - #
# ----------------------- #

func reset():
	var material:ShaderMaterial = mesh.surface_get_material(0).duplicate()
	material.set_shader_parameter("texture_albedo", original_albedo)
	set_surface_override_material(0, material)

func try_highlight(activated_nodes:Array[String]):
	if node_text in activated_nodes:
		highlight()
	else:
		darken()
