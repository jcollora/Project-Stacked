extends Spatial


onready var anim = $AnimationPlayer
onready var ray = $"../RayCast"


func _input(event):
	if Input.is_action_just_pressed("fire"):
		anim.play("fire")
		


func fire():
	print("fire")
	if ray.get_collider() != null and ray.get_collider().is_in_group("enemy"):
		print(ray.get_collider())
		ray.get_collider().hp -= 10
		
