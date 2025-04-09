class_name Visualizer extends Node3D

@onready var edge_template: PackedScene = preload("res://visualizer/edge_template/edge_template.tscn")
@onready var node_template: PackedScene = preload("res://visualizer/node_template/node_template.tscn")

func _ready() -> void:
	$EdgeTemplate.queue_free()
	$NodeTemplate.queue_free()
	# Ensure there’s lighting in the scene (add a DirectionalLight3D if none exists)
	if not get_node_or_null("DirectionalLight3D"):
		var light: DirectionalLight3D = DirectionalLight3D.new()
		light.position = Vector3(0, 10, 0)
		add_child(light)
		light.owner = self

	# Load the JSON file
	var file: FileAccess = FileAccess.open("res:///visualizer/graph_data.json", FileAccess.READ)
	if not file:
		print("Failed to open graph_data.json")
		return
	var json_text: String = file.get_as_text()
	file.close()
	
	var json: JSON = JSON.new()
	var error: int = json.parse(json_text)
	if error != OK:
		print("JSON Parse Error: ", json.get_error_message())
		return
	
	var graph_data: Dictionary = json.data
	var nodes: Array = graph_data["nodes"]
	var edges: Array = graph_data["edges"]
	
	# Dictionary to store node positions for edge creation
	var node_positions: Dictionary = {}
	
	# Create nodes (spheres)
	for i: int in range(nodes.size()):
		var node: Dictionary = nodes[i]
		var position: Vector3 = Vector3(node["position"][0], node["position"][1], node["position"][2])
		node_positions[i] = position
		
		var sphere: NodeMesh = node_template.instantiate()
		sphere.node_text = node["name"]
		#sphere.mesh = SphereMesh.new()
		sphere.mesh.radius = 0.1  # Adjust size as needed
		sphere.mesh.height = 0.2
		
		sphere.position = position
		
		sphere.set_color(get_color_from_value(node["color"]))
		#var material = sphere.mesh.surface_get_material(0)
		#material.shading_mode = BaseMaterial3D.ShadingMode.SHADING_MODE_UNSHADED  # Ensure no lighting affects color
		#material.albedo_color = get_color_from_value(node["color"])
		#material.vertex_color_use_as_albedo = true  # Optional: Use vertex colors if needed
		
		#sphere.set_surface_override_material(0, material)
		
		add_child(sphere)
		sphere.owner = self  # Ensure it appears in the scene tree
	
	# Create edges (edge_meshs)
	for edge: Array in edges:
		var idx1: int = edge[0]
		var idx2: int = edge[1]
		var pos1: Vector3 = node_positions[idx1]
		var pos2: Vector3 = node_positions[idx2]
		
		var edge_mesh: EdgeTemplate = edge_template.instantiate()
		#edge_mesh.mesh = edge_meshMesh.new()
		edge_mesh.mesh.top_radius = 0.02    # Thin edge_mesh
		edge_mesh.mesh.bottom_radius = 0.02
		edge_mesh.mesh.height = 1.0         # Default height, will be scaled
		
		# Position at midpoint
		var midpoint: Vector3 = (pos1 + pos2) / 2
		var direction: Vector3 = pos2 - pos1
		var distance: float = direction.length()
		edge_mesh.position = midpoint
		
		# Orient edge_mesh along direction
		var basis: Basis = Basis()
		basis.y = direction.normalized()
		basis.x = basis.y.cross(Vector3.UP).normalized()
		if basis.x.length_squared() < 0.01:  # If parallel to UP, use another vector
			basis.x = basis.y.cross(Vector3.FORWARD).normalized()
		basis.z = basis.x.cross(basis.y).normalized()
		edge_mesh.transform.basis = basis
		
		# Scale to match distance
		edge_mesh.scale = Vector3.ONE * Vector3(1, distance, 1)
		
		var edge_material:ShaderMaterial = edge_mesh.get_active_material(0)
		#edge_material.shading_mode = BaseMaterial3D.ShadingMode.SHADING_MODE_UNSHADED  # Ensure no lighting affects color
		#edge_material.albedo_color = Color(0.5, 0.5, 0.5, 0.5)  # Gray, semi-transparent
		#edge_material.transparency = BaseMaterial3D.Transparency.TRANSPARENCY_ALPHA  # Enable transparency
		
		#edge_mesh.set_surface_override_material(0, edge_material)
		
		add_child(edge_mesh)
		edge_mesh.owner = self

# Function to map normalized sales (0 to 1) to a color (red -> yellow -> green)
func get_color_from_value(value: float) -> Color:
	if value < 0.5:
		return Color.RED.lerp(Color.YELLOW, value * 2)  # Red to Yellow
	else:
		return Color.YELLOW.lerp(Color.GREEN, (value - 0.5) * 2)  # Yellow to Green
