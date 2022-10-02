extends StaticBody

signal enemy_killed(dmg_source, enemy)

export var hp = 10
export var gold_drop = 10

var coin_pickup = preload("res://modules/scenes/PickupCoin.tscn")

func take_damage(dmg_source, dmg):
	hp -= dmg
	if hp <= 0:
		emit_signal("enemy_killed", dmg_source, self)
		var coin_pickup_node = coin_pickup.instance()  # Create a coin pickup on death
		coin_pickup_node.gold_value = gold_drop
		coin_pickup_node.translation = self.translation
		get_parent().add_child(coin_pickup_node)
		queue_free()
