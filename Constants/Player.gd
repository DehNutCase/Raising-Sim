extends Character

var inventory: Inventory
var background_inventory: Inventory
var skill_inventory: Inventory
var inventories: Array[String] = ['inventory', 'background_inventory', 'skill_inventory',]
var starting_items = { 
	'inventory': [], 
	'background_inventory': ['royal_backing'],
	'skill_inventory': ['quick_learner'],
	}
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
		'bonus_exp': 0,
	}
