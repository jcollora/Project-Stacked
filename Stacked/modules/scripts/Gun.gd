extends Spatial

export var damage = 10

onready var anim = $AnimationPlayer
onready var ray = $RayCast
onready var player = $"../../../.."


func _input(_event):
	if Input.is_action_just_pressed("fire"):
		anim.play("fire")


func fire():
	if ray.get_collider() != null and ray.get_collider().is_in_group("enemy"):
		print(ray.get_collider())
		ray.get_collider().take_damage(player, damage)


func reload():
	pass
