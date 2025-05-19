extends CharacterBody3D

@export var move_speed := 5.0
@export var mouse_sensitivity := 0.003
@export var jump_velocity := 6.0  # Optional
@export var max_jumps := 1  # Upgradeable later

@onready var camera_pivot = $CameraPivot
@onready var camera = $CameraPivot/Camera3D
@onready var ray = $CameraPivot/Camera3D/RayCast3D

@onready var interact_prompt = $UI/InteractPrompt

var pitch := 0.0
var jumps_left := 1

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		# Rotate player (yaw)
		rotation.y -= event.relative.x * mouse_sensitivity
		# Rotate camera pivot (pitch)
		pitch = clamp(pitch - event.relative.y * mouse_sensitivity, deg_to_rad(-85), deg_to_rad(85))
		camera_pivot.rotation.x = pitch
		
func _process(_delta):
	if ray.is_colliding():
		var target = ray.get_collider()
		if target.has_method("interact"):
			interact_prompt.visible = true
			return
	interact_prompt.visible = false

func _physics_process(delta):
	var input_dir = Vector3.ZERO

	if Input.is_action_pressed("move_forward"):
		input_dir.z -= 1
	if Input.is_action_pressed("move_back"):
		input_dir.z += 1
	if Input.is_action_pressed("move_left"):
		input_dir.x -= 1
	if Input.is_action_pressed("move_right"):
		input_dir.x += 1

	input_dir = input_dir.normalized()

	# Transform direction relative to player rotation
	var direction = (transform.basis * input_dir).normalized()
	velocity.x = direction.x * move_speed
	velocity.z = direction.z * move_speed

	# Gravity
	if not is_on_floor():
		velocity.y -= 9.8 * delta
	else:
		jumps_left = max_jumps  # Reset jump count when grounded

	# Jump Input
	if Input.is_action_just_pressed("jump") and jumps_left > 0:
		velocity.y = jump_velocity
		jumps_left -= 1


	move_and_slide()

	# Interact with screen
	if Input.is_action_just_pressed("interact") and ray.is_colliding():
		var target = ray.get_collider()
		if target.has_method("interact"):
			target.interact()
