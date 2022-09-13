extends StaticBody


var hp = 10

func _physics_process(delta):
	if hp <=0:
		queue_free()
