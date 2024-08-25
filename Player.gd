extends Character

var inventory: Inventory
var day: int = 0

func _init():
	base_stats = {
		'max_hp': 100,
		'strength': 10,
		'magic': 15,
		'defense': 5,
		'resistance': 10,
		'level': 1,
		'gold': 1000,
	}
