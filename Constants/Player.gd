extends Character

#List of variables to save, update when adding new variables
@export var save_list = ["inventories", "starting_items", "day", "max_walks", "remaining_walks", "event_flags", "skill_flags", "proficiencies", "player_class", "label", "combat_skills", "live2d_active", "live2d_mode", "enemies", "tower_level", "stats", "experience", "experience_total", "experience_required"]
@export var inventory: Inventory
@export var background_inventory: Inventory
@export var skill_inventory: Inventory
@export var inventories: Array[String] = ["inventory", "background_inventory", "skill_inventory",]
@export var starting_items = { 
	"inventory": [], 
	"background_inventory": ["royal_backing", "ink_mage"],
	"skill_inventory": ["quick_learner"],
	}
@export var day: int = 0
@export var max_walks: int = 1
@export var remaining_walks: int = 0
@export var event_flags = {}
enum followup_attacks {NO_FOLLOWUP, BASIC_ATTACK, ADVANCED_ATTACK}
@export var skill_flags = {"followup_attacks": followup_attacks.NO_FOLLOWUP}
@export var proficiencies = {}
@export var player_class:String = "ink_mage"
@export var label = "Mao"
@export var combat_skills = []
@export var live2d_active = true

enum live2d_modes {LIVE2D, VIDEO}
@export var live2d_mode = live2d_modes.LIVE2D:
	set(value):
		live2d_mode = value
		#Check to avoid issues with duplicated player from combat scene
		if(get_parent()):
			get_tree().call_group("Live2DPlayer", "_update_live2d_display", value)


@export var enemies = [
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
@export var tower_level = 0
var in_tower = false
var victory_stat_gain = {}

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
	if !player_class or !background_inventory.get_item_by_id(player_class):
		for stat in stats_list:
			stats[stat] += 1
	else:
		stats_list = background_inventory.get_item_by_id(player_class).get_property("level_up_stats")
		for stat in stats_list:
			stats[stat] += stats_list[stat]

func save_game():
	var save_data = {}
	for data in save_list:
		save_data[data] = self[data]

	#serialize inventories
	for inventory in inventories:
		save_data[inventory] = self[inventory].serialize()
	
	#TODO, modify save name based on which save it is
	var save_file
	if Constants.mode != "PC":
		save_file = FileAccess.open("user://save.json", FileAccess.WRITE)
	else:
		DirAccess.make_dir_recursive_absolute("./Saves")
		save_file = FileAccess.open("./Saves/save.json", FileAccess.WRITE)
	save_file.store_line(JSON.stringify(save_data))

func load_game():
	var save_file
	if Constants.mode != "PC":
		save_file = FileAccess.open("user://save.json", FileAccess.READ)
	else:
		save_file = FileAccess.open("./Saves/save.json", FileAccess.READ)
	if !save_file:
		return
	var json_string = save_file.get_line()
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	if not parse_result == OK:
		printerr("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
		return
	var data = json.get_data()
	
	for variable in data:
		if variable == "inventories" or variable in data.inventories:
			continue
		Player[variable] = data[variable]
	
	for inventory in data.inventories:
		if !self[inventory].deserialize(data[inventory]):
			printerr("failed to deserialize inventory during load_game")
