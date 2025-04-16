class_name Interactor extends RayCast3D

static var text := ""
static var interactable:Interactable = null
static var is_interacting := false

func _physics_process(delta):
	# Force the ray to update its collision check
	force_raycast_update()
	
	# Check if the ray is colliding with something
	if is_colliding():
		is_interacting = true
		if get_collider() is Area3D:
			var area := get_collider() as Area3D
			area.body_entered.emit(null)
			Global.hud.show_interaction_hint(text)
	else:
		Global.hud.hide_interaction_hint()


func _input(event: InputEvent) -> void:
	if not(is_interacting and interactable):
		return
	if event.is_action_pressed("interact"):
		interactable.interact()
