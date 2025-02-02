extends Character

#List of variables to save, update when adding new variables
@export var save_list = ["inventories", "starting_items", "day", "max_walks", "remaining_walks", "event_flags", "location_flags", "rest_flags", "job_flags", "shop_flags", "lesson_flags", "skill_flags", "proficiencies", "player_class", "label", "combat_skills", "live2d_active", "live2d_mode", "enemies", "tower_level", "stats", "experience", "experience_total", "experience_required",]
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
@export var rest_flags = {}
@export var lesson_flags = {}
@export var job_flags = {}
@export var shop_flags = {}
@export var location_flags = {}
enum followup_attacks {NO_FOLLOWUP, BASIC_ATTACK, ADVANCED_ATTACK}
@export var skill_flags = {"followup_attacks": followup_attacks.NO_FOLLOWUP}
@export var proficiencies = {}
@export var player_class:String = "ink_mage"
@export var label = "Mao"
@export var combat_skills = ['paintball',]

@export var live2d_active = true
var dialogic_temporary_flags = {}
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
		"character_class": "mage",
		"race": "dumpling",
	},
	{
		"level": 1,
		"character_class": "warrior",
		"race": "skeleton",
	},
	{
		"level": 1,
		"character_class": "priest",
		"race": "dumpling",
	},
	{
		"level": 1,
		"character_class": "rogue",
		"race": "dumpling",
	},
	{
		"level": 15,
		"character_class": "rice",
		"race": "lesser_phantom",
	},
]
@export var tower_level = 0
var in_tower = false
var victory_stat_gain = {}

var save_loaded = false

func _init():
	base_stats = {
		"max_hp": 20,
		"strength": 10,
		"magic": 15,
		"defense": 5,
		"speed": 10,
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
	
	var save_file
	DirAccess.make_dir_recursive_absolute("user://Saves")
	save_file = FileAccess.open("user://Saves/save.json", FileAccess.WRITE)
	if save_file:
		save_file.store_line(JSON.stringify(save_data))
		ToastParty.show({"text": "Game Saved!", "gravity": "top", "direction": "center"})
	else:
		ToastParty.show({"text": "Game failed to save!", "gravity": "top", "direction": "center"})

#Helper function to allow Dialogic to set flags
func set_event_flag(flag: String) -> void:
	event_flags[flag] = true
	
#Helper function to calculate ending type and score
func calculate_ending():
	#need to return a number score and a string for ending name
	#give every stat a score value which is multiplied to get added to score in constants
	#TODO, add ending requirements to constants
	var score = 0
	for stat in stats:
		if "value" in Constants.stats[stat]:
			score += Constants.stats[stat].value * stats[stat]
	return [score, "Ending Name"]

#Helper function to set dialogic flags
func set_dialogic_temporary_flag(flag:String) -> void:
	dialogic_temporary_flags[flag] = true
	
func load_game():
	var save_file
	save_file = FileAccess.open("user://Saves/save.json", FileAccess.READ)
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
			
func delete_game():
	DirAccess.remove_absolute("user://Saves/save.json")
	OS.set_restart_on_exit(true)
	get_tree().quit()
