extends Character

var inventory: Inventory
var background_inventory: Inventory
var day: int = 0
var event_flags = {}
var proficiencies = {}

func _init():
	base_stats = {
		'max_hp': 100,
		'strength': 10,
		'magic': 15,
		'defense': 5,
		'resistance': 10,
		'level': 1,
		'gold': 0,
		'bonus_exp': 10, #in %, 100 bonus exp doubles exp gain
	}
