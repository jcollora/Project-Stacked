extends RigidBody

export var gold_value = 5

# Listener function that gives the player that walks into this money
func _on_pickup(body):
	print(body)
	if body.is_in_group("Players"):
		body.get_node("Inventory").add_money(gold_value)
		queue_free()
