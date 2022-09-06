extends KinematicBody

var fov = 90

const ACCEL_DEFAULT = 7
const ACCEL_AIR = 1
onready var accel = ACCEL_DEFAULT
var gravity = 9.8
var default_height = 10

var cam_accel = 40
var mouse_sense = 0.1
var snap

var speed = 7
var jump = 5
var sprint_multiplier = 3
var crouching_speed = 20
var crouch_multiplier = 0.6
var crouch_height = 0.5

var direction = Vector3()
var velocity = Vector3()
var gravity_vec = Vector3()
var movement = Vector3()

onready var head = $Head
onready var camera = $Head/Camera
onready var pcap = $CollisionShape

func _ready():
	#hides the cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	#get mouse input for camera rotation
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sense))
		head.rotate_x(deg2rad(-event.relative.y * mouse_sense))
		head.rotation.x = clamp(head.rotation.x, deg2rad(-89), deg2rad(89))

func _process(delta):
	#camera physics interpolation to reduce physics jitter on high refresh-rate monitors
	if Engine.get_frames_per_second() > Engine.iterations_per_second:
		camera.set_as_toplevel(true)
		camera.global_transform.origin = camera.global_transform.origin.linear_interpolate(head.global_transform.origin, cam_accel * delta)
		camera.rotation.y = rotation.y
		camera.rotation.x = head.rotation.x
	else:
		camera.set_as_toplevel(false)
		camera.global_transform = head.global_transform
		
func _physics_process(delta):
	#get keyboard input
	direction = Vector3.ZERO
	var h_rot = global_transform.basis.get_euler().y
	var f_input = Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
	var h_input = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	
	direction = Vector3(h_input, 0, f_input).rotated(Vector3.UP, h_rot).normalized()
	
	#jumping and gravity
	if is_on_floor():
		snap = -get_floor_normal()
		accel = ACCEL_DEFAULT
		gravity_vec = Vector3.ZERO
	else:
		snap = Vector3.DOWN
		accel = ACCEL_AIR
		gravity_vec += Vector3.DOWN * gravity * delta
		
	if Input.is_action_just_pressed("move_jump") and is_on_floor():
		snap = Vector3.ZERO
		gravity_vec = Vector3.UP * jump
	
	## crouching
	var speed_mult = 1
	if Input.is_action_pressed("move_crouch") and !Input.is_action_pressed("move_sprint"):
		pcap.shape.height -= crouching_speed * delta
		speed_mult = crouch_multiplier
	else:
		pcap.shape.height += crouching_speed * delta
		
	pcap.shape.height = clamp(pcap.shape.height, crouch_height, default_height)
	
	## sprinting
	if Input.get_action_strength("move_sprint") and Input.get_action_strength("move_forward") and !Input.get_action_strength("move_crouch"):
		speed_mult = sprint_multiplier
	
	## movement calculation
	var move_multiply = Vector3(1, 1, speed_mult)
	velocity = velocity.linear_interpolate(direction * speed * move_multiply, accel * delta)
	move_and_slide_with_snap(movement, snap, Vector3.UP)
	movement = velocity + gravity_vec

	var new_fov = fov * speed_mult
	var t = 0.75
	camera.fov = camera.fov * (new_fov - camera.fov) * t
