extends Character

var inventory: Inventory
var background_inventory: Inventory
var skill_inventory: Inventory
var inventories: Array[String] = ["inventory", "background_inventory", "skill_inventory",]
var starting_items = { 
	"inventory": [], 
	"background_inventory": ["royal_backing", "ink_mage"],
	"skill_inventory": ["quick_learner"],
	}
var day: int = 0
var max_walks: int = 1
var remaining_walks: int = 0
var event_flags = {}
var proficiencies = {}
var player_class:String = "ink_mage"

var enemies = [
	{
		"level": 1,
		"character_class": "warrior",
		"race": "slime",
	},
	{
		"level": 1,
		"character_class": "warrior",
		"race": "slime",
	},
]
var tower_level = 0

func _init():
	base_stats = {
		"max_hp": 100,
		"strength": 10,
		"magic": 15,
		"defense": 5,
		"speed": 1,
		"resistance": 10,
		"level": 1,
		"gold": 0,
		"bonus_exp": 0,
		"scholarship": 0,
		"action_points": 1,
	}
	name = "Player"

func level_up() -> void:
	stats["level"] += 1
	experience_required = get_required_experience(stats["level"] - 1)
	var stats = Constants.stats.base_stats
	if !player_class and !background_inventory.get_item_by_id(player_class):
		for stat in stats:
			self.stats[stat] += 1
	else:
		stats = background_inventory.get_item_by_id(player_class).get_property("level_up_stats")
		for stat in stats:
			self.stats[stat] += stats[stat]
