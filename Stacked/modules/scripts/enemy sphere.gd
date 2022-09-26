extends StaticBody


var hp = 10


func take_damage(damage):
	hp -= damage
	if hp <= 0:
		queue_free()
