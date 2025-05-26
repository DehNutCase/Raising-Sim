extends Character

#List of variables to save, update when adding new variables
@export var save_list = ["inventories", "starting_items", "day", "max_walks", "remaining_walks", "event_flags", "location_flags", "rest_flags", "job_flags", "shop_flags", "lesson_flags", "skill_flags", "proficiencies", "player_class", "label", "combat_skills", "live2d_active", "live2d_mode", "enemies", "tower_level", "stats", "max_stats", "min_stats", "experience", "experience_total", "experience_required", "class_change_class", "active_mission", "unlocked_missions", "course_list", "course_progress", "courses_completed", "current_elective", "daily_schedule_list", "mandatory_daily_schedule_list", "card_game_health", "card_game_deck"]
@export var inventory: Inventory
@export var background_inventory: Inventory
@export var skill_inventory: Inventory
@export var inventories: Array[String] = ["inventory", "background_inventory", "skill_inventory",]
@export var resource_arrays = ["card_game_deck"]
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
@export var combat_items = []
@export var class_change_class:String = ""
@export var active_mission = {}
@export var unlocked_missions = {}
@export var max_stats = {}
@export var min_stats = {}

@export var course_list = []
@export var course_progress = {}
@export var courses_completed = {}
@export var current_elective = "Ink Mage"

@export var daily_schedule_list = []
#TODO, combine both mandatory and daily list into 1 list, and use the combination of both lengths
@export var mandatory_daily_schedule_list = [{"action_name": "School", "action_type": "school"}]

@export var live2d_active = true
var dialogic_temporary_flags = {}
enum live2d_modes {LIVE2D, VIDEO}

#TODO, remove class_change_card from class change rework
var class_change_card #variable to hold loaded class change, *do not save*

@export var live2d_mode = live2d_modes.LIVE2D:
	set(value):
		live2d_mode = value
		#Check to avoid issues with duplicated player from combat scene
		if(get_parent()):
			get_tree().call_group("Live2DPlayer", "_update_live2d_display", value)


@export var enemies = [
	{
		"level": 1,
		"character_class": "wizard",
		"race": "dumpling",
	},
	{
		"level": 1,
		"character_class": "warrior",
		"race": "human",
	},
	{
		"level": 1,
		"character_class": "priest",
		"race": "teru",
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
@export var encounter = ""
@export var tower_level = 0
var in_tower = false
var in_mission = false
var victory_stat_gain = {}
#TODO, hook this to dialogic signal
var victory_signal = {}

var save_loaded = false

#Easy access to card game player stuff
var card_game_player: CardGamePlayer
var card_game_health = 10
var card_game_deck: Array[CardResource] = []

func _init():
	base_stats = {
		"max_hp": 20,
		"max_mp": 10,
		"attack": 10,
		"magic": 15,
		"defense": 5,
		"agility": 10,
		"resistance": 10,
		"level": 1,
		"gold": 0,
		"bonus_exp": 0,
		"scholarship": 0,
		"action_points": 1,
	}
	stats = base_stats
	name = "Player"

func level_up() -> void:
	stats["level"] += 1
	experience_required = get_required_experience(stats["level"] - 1)
	var stats_list = Constants.stats.base_stats
	if !player_class or !background_inventory.get_item_with_prototype_id(player_class):
		for stat in stats_list:
			stats[stat] += 1
	else:
		stats_list = background_inventory.get_item_with_prototype_id(player_class).get_property("level_up_stats")
		for stat in stats_list:
			stats[stat] += stats_list[stat]

#Helper function to allow Dialogic to set flags
func set_event_flag(flag: String) -> void:
	event_flags[flag] = true
	
#Helper function to allow Dialogic to set elective
func set_elective(flag: String) -> void:
	current_elective = flag
	
#Helper function to calculate ending type and score
func calculate_ending():
	#need to return a number score and a string for ending name
	#give every stat a score value which is multiplied to get added to score in constants
	#TODO, add ending requirements to constants
	var score = 0
	for stat in stats:
		if "value" in Constants.stats[stat]:
			score += Constants.stats[stat].value * stats[stat]
	return [int(score), "Ending Name"]

#TODO, put descriptions for each job in the constants file and return it
#Helper function to calculate ending type and score
func find_most_proficient_job() -> String :
	#need to return a number score and a string for ending name
	#give every stat a score value which is multiplied to get added to score in constants
	#TODO, add ending requirements to constants
	var most_proficient = "nothing. Did you completely avoid work this year? Fufufu"
	var proficiency = 0
	for key in proficiencies:
		if proficiencies[key] > proficiency:
			proficiency = proficiencies[key]
			most_proficient = key
			
	return most_proficient

#Helper function to set dialogic flags
func set_dialogic_temporary_flag(flag:String) -> void:
	dialogic_temporary_flags[flag] = true

func save_game():
	var save_data = {}
	for data in save_list:
		save_data[data] = self[data]

	#serialize inventories
	for inventory in inventories:
		save_data[inventory] = self[inventory].serialize()
	
	#serialize resource arrays
	for resource_array in resource_arrays:
		save_data[resource_array] = []
		for resource:Resource in self[resource_array]:
			save_data[resource_array].append(resource.resource_path)
		
	var save_file
	DirAccess.make_dir_recursive_absolute("user://Saves")
	save_file = FileAccess.open("user://Saves/save.json", FileAccess.WRITE)
	if save_file:
		save_file.store_line(JSON.stringify(save_data))
		ToastParty.show({"text": "Game Saved!", "gravity": "top", "direction": "center"})
	else:
		ToastParty.show({"text": "Game failed to save!", "gravity": "top", "direction": "center"})

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
		if variable == "inventories" or variable in data.inventories or variable in resource_arrays:
			continue
		if not variable in Player:
			continue
		Player[variable] = data[variable]
	
	for inventory in data.inventories:
		if !self[inventory].deserialize(data[inventory]):
			printerr("failed to deserialize inventory during load_game")
	
	for resource_array in resource_arrays:
		Player[resource_array].clear()
		for path in data[resource_array]:
			Player[resource_array].append(ResourceLoader.load(path))
	
func delete_game():
	DirAccess.remove_absolute("user://Saves/save.json")
	#Remove old class change card as well when deleting.
	DirAccess.remove_absolute("user://Saves/class_change_card.json")
	#TODO, fix save issue if we return to main menu
	#OS.set_restart_on_exit(true)
	#get_tree().quit()
	
func save_class_change_card(class_change_name:String):
	class_change_class = class_change_name
	var save_data = {}
	for data in save_list:
		save_data[data] = self[data]

	for inventory in inventories:
		save_data[inventory] = self[inventory].serialize()
	
	var save_file
	DirAccess.make_dir_recursive_absolute("user://Saves")
	save_file = FileAccess.open("user://Saves/class_change_card.json", FileAccess.WRITE)
	if save_file:
		save_file.store_line(JSON.stringify(save_data))
		#Below is currently unnecessary because item creation message is displayed when creating card
		#ToastParty.show({"text": "Class Change Card Created!", "gravity": "top", "direction": "center"})
		
		if class_change_name == "witch":
			var old_cards = []
			old_cards.append_array(Player.background_inventory.get_items_with_prototype_id("class_change_card"))
			old_cards.append_array(Player.background_inventory.get_items_with_prototype_id("class_change_card_witch"))
			for card in old_cards:
				Player.background_inventory.remove_item(card)
			Player.background_inventory.create_and_add_item("class_change_card_witch")
		else:
			var old_cards = []
			old_cards.append_array(Player.background_inventory.get_items_with_prototype_id("class_change_card"))
			old_cards.append_array(Player.background_inventory.get_items_with_prototype_id("class_change_card_witch"))
			for card in old_cards:
				Player.background_inventory.remove_item(card)
			Player.background_inventory.create_and_add_item("class_change_card")
	else:
		printerr("class change card save issue")
		ToastParty.show({"text": "Failed to create Class Change Card!", "gravity": "top", "direction": "center"})
			
func load_class_change_card():
	class_change_card = Player.duplicate()
	var save_file
	save_file = FileAccess.open("user://Saves/class_change_card.json", FileAccess.READ)
	if !save_file:
		printerr("no class change card loaded")
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
		class_change_card[variable] = data[variable]
	
	for inventory in data.inventories:
		class_change_card[inventory] = Inventory.new()
		if !class_change_card[inventory].deserialize(data[inventory]):
			printerr("failed to deserialize inventory during load_class_change_card")
			
func delete_class_change_card():
	DirAccess.remove_absolute("user://Saves/class_change_card.json")

func load_demo():
	var save_file
	save_file = FileAccess.open("res://Constants/demo_save.json", FileAccess.READ)
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

##Return max stat which is int
func calculate_max_stat(stat_name:String):
	if "max" in Constants.stats[stat_name]:
		var max = Constants.stats[stat_name].max
		if stat_name in Player.max_stats:
			max += Player.max_stats[stat_name]
		else:
			Player.max_stats[stat_name] = 0
		return max
	else:
		printerr("tried to find max_stat of a stat without max")
		
func calculate_min_stat(stat_name:String):
	if "min" in Constants.stats[stat_name]:
		var min = Constants.stats[stat_name].min
		if stat_name in Player.min_stats:
			min += Player.min_stats[stat_name]
		else:
			Player.min_stats[stat_name] = 0
		return min
	else:
		printerr("tried to find min_stat of a stat without min")

#Helper function for making tooltips, make the relevant control's _make_custom_tooltip(text) function call this
func make_custom_tooltip(text: String) -> Control:
	var custom_tooltip:Control = load("res://Scenes/UI/Tooltip/custom_tooltip.tscn").instantiate()
	var label: RichTextLabel = custom_tooltip.get_child(0)
	label.parse_bbcode("[center]" + text + "[/center]")
	return custom_tooltip


#Helper function for shaking things
func shake(target: Node, strength: float, duration: float = 0.2) -> void:
	if not target:
		return
	
	var original_position: Vector2 = target.position
	var shake_count: int = 10
	var tween: Tween = create_tween()
	
	for i in range(shake_count):
		var shake_offset: Vector2 = Vector2(randf_range(-1,1), randf_range(-1,1))
		var new_position: Vector2 = original_position + strength * shake_offset
		if i % 2 == 0:
			new_position = original_position
		tween.tween_property(target, "position", new_position, duration/float(shake_count))
		strength *= .75
		
	tween.finished.connect(func(): target.position = original_position)
	await tween.finished
	
