extends Spatial

export var gold = 0

func add_money(amount):
	if amount < 0:
		print("Cannot add negative gold value to inventory")
		return
	gold += amount

