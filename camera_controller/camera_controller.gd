class_name CameraController extends Camera3D

# Speed settings (editable in the inspector)
@export var move_speed: float = 5.0
@export var mouse_sensitivity: float = 0.3
@export var shift_multiplier: float = 2.0
@export var flying: bool = false

@export var interactor:Interactor

# Internal variables
var yaw: float = 0.0
var pitch: float = 0.0

func _ready():
	# Capture mouse for rotation
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	# Handle mouse movement for rotation
	if event is InputEventMouseMotion:
		yaw -= event.relative.x * mouse_sensitivity * 0.01
		pitch -= event.relative.y * mouse_sensitivity * 0.01
		pitch = clamp(pitch, -PI/2, PI/2)  # Limit pitch to avoid flipping
		
		# Apply rotations
		rotation.y = yaw
		rotation.x = pitch

func _process(delta):
	var speed = move_speed
	
	# Apply shift multiplier if shift is held
	if Input.is_key_pressed(KEY_SHIFT):
		speed *= shift_multiplier
	
	# Movement direction
	var direction = Vector3.ZERO
	
	if Input.is_key_pressed(KEY_W):
		direction.z -= 1
	if Input.is_key_pressed(KEY_S):
		direction.z += 1
	if Input.is_key_pressed(KEY_A):
		direction.x -= 1
	if Input.is_key_pressed(KEY_D):
		direction.x += 1
	
	# Normalize direction to prevent faster diagonal movement
	if direction.length() > 0:
		direction = direction.normalized()
		if not flying:
			pass
	
	# Apply movement
	translate(direction * speed * delta)

func _unhandled_input(event):
	# Allow toggling mouse capture with Esc or Right Click
	if event is InputEventKey and event.keycode == KEY_ESCAPE and event.pressed:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
