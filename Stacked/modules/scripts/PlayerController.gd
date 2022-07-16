extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var sensitivity = 0.03
var speed = 10
var direction = Vector3()

# $ helps obtain objects in the scene, onready to define vars using gameobject
onready var head = $Head 

# Called when the node enters the scene tree for the first time.
func _ready():
	# tells the engine to not display mouse when capturing input
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _input(event):
	if event is InputEventMouseMotion:
		# apply sensitivity
		rotate_y(deg2rad(-event.relative.x * sensitivity))
		head.rotate_x(deg2rad(-event.relative.y * sensitivity))
		head.rotation.x = clamp(head.rotation.x, deg2rad(-89), deg2rad(89))
		
func _physics_process(delta):
	
	direction = Vector3()
	if Input.is_action_pressed("move_forward"):
		direction -= transform.basis.z
	elif Input.is_action_pressed("move_backward"):
		direction += transform.basis.z
	elif Input.is_action_pressed("move_left"):
		direction -= transform.basis.x
	elif Input.is_action_pressed("move_right"):
		direction += transform.basis.x
	direction = direction.normalized()
	# moves object in direction vector by speed, up is a vector to define relative movement
	move_and_slide(direction * speed, Vector3.UP)
	
		
