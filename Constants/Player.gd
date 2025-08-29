
extends Node

#List of variables to save, update when adding new variables
@export var save_list = ["inventories", "starting_items", "day", "max_walks", "remaining_walks", "daily_action_limit", "event_flags", "location_flags", "rest_flags", "job_flags", "lesson_flags", "skill_flags", "proficiencies", "player_class", "label", "combat_skills", "live2d_active", "live2d_mode", "enemies", "tower_level", "stats", "max_stats", "min_stats", "experience", "experience_total", "experience_required", "class_change_class", "active_mission", "unlocked_missions", "course_list", "course_progress", "courses_completed", "current_elective", "daily_schedule_list", "mandatory_daily_schedule_list", "card_game_deck", "bedtime_event_number", "active_quests", "completed_quests", "talent_tree", "talent_points_spent", "card_game_starting_status", "dumpling_stats"]
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
@export var daily_action_limit: int = 3
@export var event_flags = {}
@export var rest_flags = {}
@export var lesson_flags = {}
@export var job_flags = {}
@export var location_flags = {}
enum followup_attacks {NO_FOLLOWUP, BASIC_ATTACK, ADVANCED_ATTACK}
@export var skill_flags = {"followup_attacks": followup_attacks.NO_FOLLOWUP}
@export var proficiencies = {}
@export var player_class:String = "ink_mage"
@export var label = "Mao"
#TODO, remove combat skills? (maybe items as well), holdover from combat scene
@export var combat_skills = ['paintball',]
@export var combat_items = []
@export var class_change_class:String = ""
@export var active_mission = {}
@export var unlocked_missions = {}
@export var max_stats = {}
@export var min_stats = {}
@export var talent_tree = {}
@export var talent_points_spent = 0

@export var course_list = []
@export var course_progress = {}
@export var courses_completed = {}
@export var current_elective = "Ink Mage"

@export var active_quests = {}
@export var completed_quests = {}

@export var bedtime_event_number = 0

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
var in_expedition = false
var expedition_health = 10
var victory_stat_gain = {}
#TODO, hook this to dialogic signal
var reward_signal = {}

var save_loaded = false

#Easy access to card game player stuff
var card_game_player: CardGamePlayer = CardGamePlayer.new()
var card_game_deck: Array[CardResource] = []
var card_game_starting_status = {}

var dumpling_stats = {
	"name": "Dumpling",
	"stats": {
		"mood": 50,
		"bond": 0,
		"full": 100,
		"clean": 100,
		"strength": randi_range(0,5),
		"stamina": randi_range(0,5),
		"speed": randi_range(0,5),
	},
	"action_per_day": 2,
	"remaining_actions": 2,
	"action_bonuses": {}
}

var base_stats = {
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
	"talent_point": 1,
}

@export var stats = {}
var display_stats = ["level", "experience", "gold", "stress"] + Constants.stats.base_stats + ["scholarship"]

signal experience_gained(growth_data)

@export var experience = 0
@export var experience_total = 0
@export var experience_required = 100

@export var perspectives = {}

@export var new_game_plus_bonuses = {}

func get_required_experience(l) -> int:
	return int(pow(1.1, l) * 200)

func gain_experience(amount: int) -> void:
	if ("bonus_exp" in stats):
		amount = amount * (1 + stats.bonus_exp/100.0)
		amount = int(amount)
	experience_total += amount
	experience += amount
	var growth_data = []
	while experience >= experience_required:
		experience -= experience_required
		growth_data.append([experience_required,experience_required])
		level_up()
	
	stats.experience = experience
	growth_data.append([experience, experience_required])
	emit_signal("experience_gained", growth_data)
	
# Called when the node enters the scene tree for the first time.
func _ready():
	load_perspectives()
	for stat in display_stats:
		if !(stat in base_stats):
			stats[stat] = 0
		else:
			stats[stat] = base_stats[stat]
	for stat in base_stats:
		if !(stat in stats):
			stats[stat] = base_stats[stat]

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
	
func set_deck(flag: String) -> void:
	card_game_deck = load(flag).cards.duplicate()
	
#Helper function to calculate ending type and score
func calculate_ending(final_ending: bool = false):
	#Player.event_flags["ending_reached"] = true
	var score = 0
	for stat in stats:
		if "value" in Constants.stats[stat]:
			score += Constants.stats[stat].value * stats[stat]
			
	var endings_reached = []
	var highest_ending = ""
	
	for ending in Constants.endings:
		if !check_ending_requirements(ending):
			continue
		else:
			endings_reached.append(ending)
			if !highest_ending:
				highest_ending = ending
			var highest_ending_score = Constants.endings[highest_ending].points
			var ending_score = Constants.endings[ending].points
			if ending_score > highest_ending_score:
				highest_ending = ending
				
	var highest_ending_info = Constants.endings[highest_ending]
	
	if final_ending:
		var timeline = highest_ending_info.get("timeline")
		if timeline:
			Dialogic.start(timeline)
		#TODO, delete game on pressed, currently disabled for dev work
		#delete_game()
		#TODO, update new game plus bonuses from talents, items, etc.
		for talent in talent_tree:
			var bonuses = Constants.talents[talent].get("new_game_plus_bonuses")
			if !bonuses:
				continue
			
			var stat_bonuses = bonuses.get("stats", {})
			for bonus in stat_bonuses:
				update_new_game_plus_bonus("stats", bonus, stat_bonuses[bonus])
			
			var talent_bonuses = bonuses.get("talents", {})
			for bonus in talent_bonuses:
				update_new_game_plus_bonus("stats", bonus, talent_bonuses[bonus])
			

	return [int(score), highest_ending_info.label, highest_ending]

func check_ending_requirements(ending: String) -> bool:
	var requirements = Constants.endings[ending].requirements
	var stat_requirements = requirements.get("stats", {})
	for stat in stat_requirements:
		if Player.stats[stat] < stat_requirements[stat]:
			return false
	var course_requirements = requirements.get("courses_completed", [])
	for course in course_requirements:
		if !check_course_completion(course):
			return false
	var lesson_requirements = requirements.get("lessons_completed", [])
	for lesson in lesson_requirements:
		if !lesson in courses_completed:
			return false
	var event_requirements = requirements.get("events", [])
	for event_flag in event_requirements:
		if !event_flag in Player.event_flags:
			return false
	var tower_level_requirements = requirements.get("tower_level", 0)
	if !Player.tower_level >= tower_level_requirements:
		return false
	return true

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
	for inv in inventories:
		save_data[inv] = self[inv].serialize()
	
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
		printerr("load_game JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
		return
	var data = json.get_data()
	
	for variable in data:
		if variable == "inventories" or variable in data.inventories or variable in resource_arrays:
			continue
		if not variable in Player:
			continue
		Player[variable] = data[variable]
	
	for inv in data.inventories:
		if !self[inv].deserialize(data[inv]):
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
	
func save_perspectives() -> void:
	var save_data = perspectives
	var save_file
	DirAccess.make_dir_recursive_absolute("user://Saves")
	save_file = FileAccess.open("user://Saves/perspectives_save.json", FileAccess.WRITE)
	if save_file:
		save_file.store_line(JSON.stringify(save_data))
	else:
		printerr("save_perspectives failed to save")

func load_perspectives() -> void:
	var save_file
	save_file = FileAccess.open("user://Saves/perspectives_save.json", FileAccess.READ)
	if !save_file:
		return
	var json_string = save_file.get_line()
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	if not parse_result == OK:
		printerr("load_perspectives JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
		return
	var data = json.get_data()
	perspectives = data

func unlock_perspective(perspective: String) -> void:
	perspectives[perspective] = true
	save_perspectives()

func save_class_change_card(class_change_name:String):
	class_change_class = class_change_name
	var save_data = {}
	for data in save_list:
		save_data[data] = self[data]

	for inv in inventories:
		save_data[inv] = self[inv].serialize()
	
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
	
	for inv in data.inventories:
		class_change_card[inv] = Inventory.new()
		if !class_change_card[inv].deserialize(data[inv]):
			printerr("failed to deserialize inventory during load_class_change_card")
			
func delete_class_change_card():
	DirAccess.remove_absolute("user://Saves/class_change_card.json")

func save_new_game_plus_bonuses() -> void:
	var save_data = new_game_plus_bonuses
	var save_file
	DirAccess.make_dir_recursive_absolute("user://Saves")
	save_file = FileAccess.open("user://Saves/new_game_plus.json", FileAccess.WRITE)
	if save_file:
		save_file.store_line(JSON.stringify(save_data))
	else:
		printerr("save_perspectives failed to save")

func load_new_game_plus_bonuses() -> void:
	var save_file
	save_file = FileAccess.open("user://Saves/new_game_plus.json", FileAccess.READ)
	if !save_file:
		return
	var json_string = save_file.get_line()
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	if not parse_result == OK:
		printerr("load_perspectives JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
		return
	var data = json.get_data()
	new_game_plus_bonuses = data

#make sure new game plus bonuses are in the format of name: value
func update_new_game_plus_bonus(category: String, bonus: String, value: int) -> void:
	if !category in new_game_plus_bonuses:
		new_game_plus_bonuses[category] = {}
		
	if bonus in new_game_plus_bonuses[category]:
		new_game_plus_bonuses[category][bonus] += value
	else:
		new_game_plus_bonuses[category][bonus] = value
	save_new_game_plus_bonuses()

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
	
	for inv in data.inventories:
		if !self[inv].deserialize(data[inv]):
			printerr("failed to deserialize inventory during load_game")

##Return max stat which is int, return 0 if no max stat
func calculate_max_stat(stat_name:String) -> int:
	if Constants.stats[stat_name].get("max"):
		var max_value = Constants.stats[stat_name].max
		if stat_name in Player.max_stats:
			max_value += Player.max_stats[stat_name]
		else:
			Player.max_stats[stat_name] = 0
		return max_value
	else:
		return 0
		
func calculate_min_stat(stat_name:String):
	if "min" in Constants.stats[stat_name]:
		var min_value = Constants.stats[stat_name].min
		if stat_name in Player.min_stats:
			min_value += Player.min_stats[stat_name]
		else:
			Player.min_stats[stat_name] = 0
		return min_value
	else:
		printerr("tried to find min_stat of a stat without min")

#Helper function for making tooltips, make the relevant control's _make_custom_tooltip(text) function call this
func make_custom_tooltip(text: String) -> Control:
	var custom_tooltip:Control = load("res://Scenes/UI/Tooltip/custom_tooltip.tscn").instantiate()
	var rich_text_label: RichTextLabel = custom_tooltip.get_child(0)
	rich_text_label.parse_bbcode("[center]" + text + "[/center]")
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
	
###Music and Audio section
var songs = {
	"spring": load("res://Music/Meraj Melody/Last Adventure 87 no afterglow.wav"),
	"summer": load("res://Music/Tim Beek/Chiptune Dream Loop.wav"),
	"autumn": load("res://Music/Tim Beek/New Road Loop.wav"),
	"winter": load("res://Music/Meraj Melody/Walk Alone 80 no afterglow.wav"),
	"battle": load("res://Music/Tim Beek/8Bit DNA Loop.wav"),
	"cheerful": load("res://Music/Tim Beek/Sun Shine Loop.wav"),
	"rising_hope": load("res://Music/Tim Beek/Quantum Loop.wav"),
	"upcoming_battle": load("res://Music/Tim Beek/Purple Black Loop.wav"),
	"sad": load("res://Music/Meraj Melody/Arena Light 106 no afterglow.wav"),
	"slightly_sad": load("res://Music/Meraj Melody/No Exit 106 no afterglow.wav"),
	"new_dawn": load("res://Music/Meraj Melody/New Dawn 87 no afterglow.wav"),
	"sea_adventure": load("res://Music/Meraj Melody/Sea Adventure Loop BPM 106 F no afterglow.wav"),
	"sleep": load("res://Music/Meraj Melody/Sea Adventure Loop BPM 106 F no afterglow.wav"),
}

var voices = {
	"greeting0": load("res://Voice/Sakura An/Greetings/Hallo.wav"),
	"greeting1": load("res://Voice/Sakura An/Greetings/Hello.wav"),
	"greeting2": load("res://Voice/Sakura An/Greetings/Yaho (Hello).wav"),
	"greeting3": load("res://Voice/Sakura An/Greetings/Good Morning.wav"),
	"greeting4": load("res://Voice/Sakura An/Greetings/Good Morning polite.wav"),
	"greeting5": load("res://Voice/Sakura An/Greetings/Hi Hi.wav"),
	"damaged0": load("res://Voice/Sakura An/Battle/[Damage] Ugh!.wav"),
	"damaged1": load("res://Voice/Sakura An/Battle/[Damage] Ugh....wav"),
	"damaged2": load("res://Voice/Sakura An/Battle/[Damage] Ugh.wav"),
	
	"amazing": load("res://Voice/Sakura An/Misc/Amazing.wav"),
	"happy": load("res://Voice/Sakura An/Misc/Happy.wav"),
	"proud": load("res://Voice/Sakura An/Misc/Proud.wav"),
	"boom": load("res://Voice/Sakura An/Misc/Boom.wav"),
	"laugh": load("res://Voice/Sakura An/Misc/Laugh.wav"),
	"tada": load("res://Voice/Sakura An/Misc/Tada.wav"),
	"thank_you": load("res://Voice/Sakura An/Misc/Thank you.wav"),
	"thank_you_polite": load("res://Voice/Sakura An/Misc/Thank you polite.wav"),
	"keep_it_up": load("res://Voice/Sakura An/Misc/Keep it up.wav"),
	"un_yeah": load("res://Voice/Sakura An/Misc/Un (yeah).wav"),
	"yay!": load("res://Voice/Sakura An/Misc/Yay!.wav"),
	"yes_enthusiastic": load("res://Voice/Sakura An/Misc/Yes(Enthusiastic).wav"),
	"oh!": load("res://Voice/Sakura An/Misc/Oh!.wav"),
	"oh...":load("res://Voice/Sakura An/Misc/Oh....wav"),
	
	"baka": load("res://Voice/Sakura An/Misc/Baka.wav"),
	"disappointed": load("res://Voice/Sakura An/Misc/Disappointed.wav"),
	"hate": load("res://Voice/Sakura An/Misc/Hate.wav"),
	"oh no": load("res://Voice/Sakura An/Misc/Oh no.wav"),
	"sigh": load("res://Voice/Sakura An/Misc/Sigh.wav"),
	"sorry": load("res://Voice/Sakura An/Misc/Sorry.wav"),
	"sorry_polite": load("res://Voice/Sakura An/Misc/Sorry polite.wav"),
	"huh!?": load("res://Voice/Sakura An/Misc/Huh!？.wav"),
	"eh_no_way": load("res://Voice/Sakura An/Misc/Uh...(No way).wav"),
	
	"looks_delicious": load("res://Voice/Sakura An/Misc/Looks Delicious!.wav"),
	"huh?": load("res://Voice/Sakura An/Misc/huh？.wav"),
	"hmm": load("res://Voice/Sakura An/Misc/Hmm.wav"),
	"good_night": load("res://Voice/Sakura An/Greetings/Good Night.wav"),
	"wow_blank_stare": load("res://Voice/Sakura An/Misc/Wow...(Blank stare).wav"),
}

var voice_lists = {
	"damaged": [voices["damaged0"], voices["damaged1"], voices["damaged2"],],
	"greetings": [voices["greeting0"], voices["greeting1"], voices["greeting2"], voices["greeting3"], voices["greeting4"], voices["greeting5"],],
	"success": [voices["amazing"], voices["happy"], voices["proud"], voices["boom"], voices["laugh"], voices["tada"], voices["thank_you"], voices["thank_you_polite"], voices["keep_it_up"], voices["un_yeah"], voices["yay!"], voices["yes_enthusiastic"],],
	"failure": [voices["baka"], voices["disappointed"], voices["hate"], voices["oh no"], voices["sigh"], voices["sorry"], voices["sorry_polite"], voices["huh!?"],]
}

#SFX

var sound_effects = {
	"bubble": load("res://SFX/JDWasabi/Bubble 1.wav"),
	"select": load("res://SFX/JDWasabi/Select 1.wav"),
	"confirm": load("res://SFX/JDWasabi/Confirm 1.wav"),
	"cancel": load("res://SFX/JDWasabi/Cancel 1.wav"),
	"ping": load("res://SFX/Atelier Magicae/5_ping.wav"),
	"blop": load("res://SFX/Kronbits/Retro Blop 22.wav"),
	"cancel_blop": load("res://SFX/Kronbits/Retro Blop 07.wav"),
	"bouncy_blop": load("res://SFX/Kronbits/Retro Blop StereoUP 09.wav"),
	"draw_card": load("res://SFX/JDSherbert/JDSherbert - Tabletop Games SFX Pack - Paper Flip - 1.wav"),
	"discard_card": load("res://SFX/JDSherbert/JDSherbert - Tabletop Games SFX Pack - Deck Deal - 2.wav"),
	"door": load("res://SFX/Tom Music/Doors Gates and Chests/Door Close 1.wav"),
	"footsteps": load("res://SFX/Tom Music/Footsteps/Edited/Footsteps.wav"),
	"time_passing": load("res://SFX/Atelier Magicae/Long/Fantasy UI Vol (28).wav"),
	"jump": load("res://SFX/JDWasabi/Jump 1.wav"),
	"heal": load("res://SFX/Leohpaz/8_Buffs_Heals_SFX/02_Heal_02.wav"),
	"water": load("res://SFX/Leohpaz/8_Atk_Magic_SFX/22_Water_02.wav"),
	"success": load("res://SFX/Kronbits/Retro Event Acute 08.wav"),
	"great_success": load("res://SFX/Kronbits/Retro Success Melody 01 - sawtooth lead 1.wav"),
	"failure": load("res://SFX/Kronbits/Retro Descending Short 14.wav"),
	"great_failure": load("res://SFX/Kronbits/Retro Negative Melody 01 - aCustom1.wav"),
	
}
func play_song(song:String) -> void:
	song = song.to_lower()
	SoundManager.play_music(songs[song])

func play_voice(voice: String) -> void:
	voice = voice.to_lower()
	SoundManager.play_ambient_sound(voices[voice])

func play_random_voice(voice_list: String) -> void:
	voice_list = voice_list.to_lower()
	var voice = voice_lists[voice_list].pick_random()
	SoundManager.play_ambient_sound(voice)

#Helper function for displaying toast, call this if toast is needed?
func display_toast(message, gravity = "top", direction = "center", icon = null):
	ToastParty.show({
		"text": message,           # Text (emojis can be used)
		"gravity": gravity,                   # top or bottom
		"direction": direction,               # left or center or right
		"icon": icon,
	})
	Player.play_ui_sound("bubble")

func play_ui_sound(sound_effect: String) -> void:
	sound_effect = sound_effect.to_lower()
	SoundManager.play_ui_sound(sound_effects[sound_effect])

func play_sound_effect(sound_effect: String) -> void:
	sound_effect = sound_effect.to_lower()
	SoundManager.play_sound(sound_effects[sound_effect])

func start_quest(quest: String) -> void:
	#Don't start duplicate quests
	if active_quests.get(quest):
		return
	active_quests[quest] = {'active': true}
	display_toast("Quest added: " + Constants.quests[quest].name)
	
func check_course_completion(course: String) -> bool:
	var course_data = Constants.courses[course]
	var completed := true
	for course_name in course_data:
		if !course_name in courses_completed:
			completed = false
	return completed

func check_gold_below_zero() -> bool:
	if Player.stats.gold < 0:
		return true
	else:
		return false
		
func _play_button_sound() -> void:
	Player.play_ui_sound("blop")
