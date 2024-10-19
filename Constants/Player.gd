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
var skill_flags = {"followup_attacks": followup_attacks.NO_FOLLOWUP}
var proficiencies = {}
var player_class:String = "ink_mage"
var label = "Mao"
var combat_skills = []
enum followup_attacks {NO_FOLLOWUP, BASIC_ATTACK, ADVANCED_ATTACK}

var enemies = [
	{
		"level": 1,
		"character_class": "warrior",
		"race": "slime",
	},
	{
		"level": 1,
		"character_class": "mage",
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
	var stats_list = Constants.stats.base_stats
	if !player_class and !background_inventory.get_item_by_id(player_class):
		for stat in stats_list:
			stats[stat] += 1
	else:
		stats_list = background_inventory.get_item_by_id(player_class).get_property("level_up_stats")
		for stat in stats_list:
			stats[stat] += stats_list[stat]
