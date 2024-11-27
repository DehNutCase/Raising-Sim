extends Node2D

@onready var player_model = $Ui/PlayerControl/Player
@onready var inventory = $Ui/PlayerControl/Player/PlayerInventory
@onready var background = $Ui/PlayerControl/Player/BackgroundInventory
@onready var skills = $Ui/PlayerControl/Player/SkillInventory
@onready var dialogic_viewport = $Ui/DialogicPanel/DialogicViewportContainer/DialogicViewport
@onready var dialogic_viewport_container = $Ui/DialogicPanel/DialogicViewportContainer
@onready var dialogic_panel = $Ui/DialogicPanel

@onready var gold_label = $Ui/GoldLabelContainer/GoldLabel
@onready var day_label = $Ui/DayLabelContainer/DayLabel
@onready var walks_label = $RemainingWalks

@onready var work = $Ui/MenuPanel/Work
@onready var lessons = $Ui/MenuPanel/Lessons
@onready var rest = $Ui/MenuPanel/Rest
@onready var shop = $Ui/MenuPanel/Shop
@onready var walk = $Ui/MenuPanel/Walk
@onready var stats = $Ui/MenuPanel/Stats
@onready var tower = $Ui/MenuPanel/Tower

@onready var menu_panel = $Ui/MenuPanel
@onready var buttons = $LeftMenuContainer/MenuPanel/VBoxContainer
@onready var buttons2 = $RightMenuContainer/MenuPanel/VBoxContainer
@onready var animation = $Ui/MenuPanel/Animation
@onready var skip_checkbox = $Ui/MenuPanel/Skip

@onready var menus = [work, lessons, rest, shop, walk, stats, tower,]

#TODO Dev variable, remove when building
var skip_movie = false

var jobs = Constants.jobs
var rests = Constants.rests

var day: int:
	get:
		return Player.day
	set(value):
		Player.day = value

enum states {READY, DIALOGIC, BUSY}
var current_state = states.READY

#TODO, work on layout changes for different aspect ratios under expand
# Called when the node enters the scene tree for the first time.
func _ready():
	#TODO, add loading from intro screen instead
	Player.load_game()
	Player.max_walks = 100
	Dialogic.Styles.load_style("VisualNovelStyle", dialogic_viewport)
	Dialogic.signal_event.connect(_on_dialogic_signal)
	Dialogic.timeline_ended.connect(_on_timeline_ended)
	Dialogic.timeline_started.connect(_on_timeline_started)
	for inventory_name in Player.inventories:
		Player[inventory_name].item_added.connect(_on_inventory_item_added)
		
	if (day == 0):
		for inventory_name in Player.inventories:
			for starting_item in Player.starting_items[inventory_name]:
				Player[inventory_name].create_and_add_item(starting_item)
		process_day()
	else:
		display_stats()
		day_label.display_day(day)
		
	for button in buttons.get_children():
		button.pressed.connect(_on_action.bind(button))
	for button in buttons2.get_children():
		button.pressed.connect(_on_action.bind(button))
	get_tree().call_group("ButtonMenu", "update_buttons")

func process_day():
	if (day % Constants.constants.days_in_month == 0):
		var monthly_items = inventory.inventory.get_items().duplicate()
		monthly_items.append_array(background.inventory.get_items())
		monthly_items.append_array(skills.inventory.get_items())
		for item in monthly_items:
			for stat in item.get_property("monthly_stats", {}):
				Player.stats[stat] += item.get_property("monthly_stats")[stat]
		
	day +=1
	Player.remaining_walks = Player.max_walks
	
	var items = inventory.inventory.get_items().duplicate()
	items.append_array(background.inventory.get_items())
	items.append_array(skills.inventory.get_items())
	for item in items:
		for stat in item.get_property("daily_stats", {}):
			Player.stats[stat] += item.get_property("daily_stats")[stat]
	
	for stat in Player.stats:
		if !stat in Constants.stats:
			printerr(stat + " isn't in Constants.stats")
			continue
		if "min" in Constants.stats[stat] && Player.stats[stat] < Constants.stats[stat]["min"]:
			Player.stats[stat] = Constants.stats[stat]["min"]
		if "max" in Constants.stats[stat] && Player.stats[stat] > Constants.stats[stat]["max"]:
			Player.stats[stat] = Constants.stats[stat]["max"]
			
	if Player.victory_stat_gain:
		display_toast("Gained stats from combat!", "top")
		await(get_tree().create_timer(.5).timeout)
		process_stats(Player.victory_stat_gain)
		Player.victory_stat_gain = {}
		
	display_stats()
	day_label.display_day(day)
	if(skip_checkbox.button_pressed):
		_on_close_button_pressed()
	update_expressions()
	check_and_play_daily_events()
	get_tree().call_group("ButtonMenu", "update_buttons")

#TODO remove stat bars in job pages
func do_job(job_name: String) :
	var job_stats = Constants.jobs[job_name]["stats"]
	var rng = RandomNumberGenerator.new()
	animation.stat_bars.load_stat_bars(job_name)
	if (JobButton.get_success_chance(job_name) > rng.randf() * 100):
		get_tree().call_group("Live2DPlayer", "job_motion", player_model.success_motion)
		process_stats(job_stats)
		Player.proficiencies[job_name] += Constants.jobs[job_name].proficiency_gain
		if ('skill' in Constants.jobs[job_name]):
			if (Player.proficiencies[job_name] >= Constants.jobs[job_name].skill.proficiency_required):
				if (!Player.skill_inventory.get_item_by_id(Constants.jobs[job_name].skill.id)):
					Player.skill_inventory.create_and_add_item(Constants.jobs[job_name].skill.id)
			
	else:
		get_tree().call_group("Live2DPlayer", "job_motion", player_model.failure_motion)
		if "stress" in job_stats:
			process_stats({"stress": job_stats["stress"]})
		Player.proficiencies[job_name] += Constants.jobs[job_name].proficiency_gain/2
	work.hide()
	animation.animation.show()
	animation.animation.play("Run")
	process_day()
	
#TODO, add animations for lesson and resting
func do_lesson(lesson_name: String) :
	var lesson_stats = Constants.lessons[lesson_name]["stats"]
	var cost = 0
	if "gold" in lesson_stats: cost = -lesson_stats.gold
	if (cost > Player.stats["gold"]):
		display_toast("Not enough gold! " + "(" + str(cost) + ")", "top", "center")
		return
	var rng = RandomNumberGenerator.new()
	if (LessonButton.get_success_chance(lesson_name) > rng.randf() * 100):
		get_tree().call_group("Live2DPlayer", "job_motion", player_model.success_motion)
		process_stats(lesson_stats)
		if 'proficiency' in Constants.lessons[lesson_name]:
			Player.proficiencies[lesson_name] += Constants.lessons[lesson_name].proficiency_gain
		if ('skill' in Constants.lessons[lesson_name]):
			if (Player.proficiencies[lesson_name] >= Constants.lessons[lesson_name].skill.proficiency_required):
				if (!Player.skill_inventory.get_item_by_id(Constants.lessons[lesson_name].skill.id)):
					Player.skill_inventory.create_and_add_item(Constants.lessons[lesson_name].skill.id)
	else:
		get_tree().call_group("Live2DPlayer", "job_motion", player_model.failure_motion)
		if "stress" in lesson_stats:
			process_stats({"stress": lesson_stats["stress"], "gold": lesson_stats["gold"]})
		Player.proficiencies[lesson_name] += Constants.lessons[lesson_name].proficiency_gain/2
	lessons.hide()
	animation.animation.show()
	animation.animation.play("Run")
	process_day()

func do_rest(rest_name: String) -> void:
	var rest_stats = Constants.rests[rest_name]["stats"]
	var cost = 0
	if "gold" in rest_stats: cost = -rest_stats.gold
	if ( cost > Player.stats["gold"]):
		display_toast("Not enough gold! " + "(" + str(cost) + ")", "top", "center")
		return
	process_stats(rest_stats)
	rest.visible = false
	animation.animation.visible = true
	animation.animation.play("Run")
	process_day()
	
func do_walk(walk_name: String) -> void:
	if Player.remaining_walks > 0:
		var weights = []
		var outcomes = Constants.locations[walk_name].outcomes
		for outcome in outcomes:
			if ('weight' in outcome):
				weights.append(outcome.weight)
			else:
				weights.append(1)
		var outcome = outcomes[rand_weighted(weights)]
		var walk_stats = outcome.stats
		walk.visible = false
		animation.animation.visible = true
		animation.animation.play("Run")
		Player.remaining_walks -= 1
		if(skip_checkbox.button_pressed):
			_on_close_button_pressed()
		if 'toasts' in outcome:
			if 'first_toasts' in outcome and !(outcome.flag in Player.event_flags):
				for toast in outcome.first_toasts:
					display_toast(toast)
					await(get_tree().create_timer(.5).timeout)
				if !'first_timeline' in outcome:
					Player.event_flags[outcome.flag] = 1
			elif 'second_toasts' in outcome and !(Player.event_flags[outcome.flag] > 1):
				for toast in outcome.second_toasts:
					display_toast(toast)
					await(get_tree().create_timer(.5).timeout)
				if !'second_timeline' in outcome:
					Player.event_flags[outcome.flag] = 2
			else:
				for toast in outcome.toasts:
					display_toast(toast)
					await(get_tree().create_timer(.5).timeout)
		if 'timeline' in outcome:
			if 'first_timeline' in outcome and !(outcome.flag in Player.event_flags):
				Dialogic.start(outcome.first_timeline)
				Player.event_flags[outcome.flag] = 1
			elif 'second_timeline' in outcome and !(Player.event_flags[outcome.flag] > 1):
				Dialogic.start(outcome.second_timeline)
				Player.event_flags[outcome.flag] = 2
			else:
				Dialogic.start(outcome.timeline)
		await(get_tree().create_timer(.5).timeout)
		process_stats(walk_stats)
	else:
		display_toast("No walks left!", "top")
		if(skip_checkbox.button_pressed):
			_on_close_button_pressed()

func buy_item(item: String, price: int):
	if Player.stats["gold"] >= price:
		Player.stats["gold"] -= price
		Player.inventory.create_and_add_item(item)
	else:
		display_toast("Not enough gold!", "top", "center")
	display_stats()


func _on_action(button):
	if current_state != states.READY:
		printerr("_on_action state not READY")
		return
	var open_menu: String
	for menu in menus:
		if menu.visible:
			open_menu = menu.name
	_on_close_button_pressed()
	
	match button.text:
		"Work":
			work.show()
		"Lessons":
			lessons.show()
		"Rest":
			rest.show()
		"Inventory":
			inventory.visible = !inventory.visible
			menu_panel.visible = true
		"Shop":
			shop.show()
		"Walk":
			walk.show()
		"Battle":
			SceneLoader.load_scene("res://Scenes/Combat/Combat.tscn")
		"Stats":
			stats.show()
		"Background":
			background.visible = !background.visible
			skills.visible = false
			menu_panel.visible = true
		"Skills":
			skills.visible = !skills.visible
			background.visible = false
			menu_panel.visible = true
		"Tower":
			tower.show()
			if(Player.tower_level < len(Constants.tower_levels)):
				tower.get_node("Description").text = Constants.tower_levels[Player.tower_level].description
			else:
				tower.get_node("Description").text = "The tower is cleared."
		"Save":
			Player.save_game()
			background.visible = false
			menu_panel.visible = true
		_:
			printerr("_on_action failed to match")
			
	if open_menu == button.text:
		_on_close_button_pressed()
	else:
		menu_panel.visible = !menu_panel.visible
	

func _on_close_button_pressed():
	menu_panel.visible = false
	for menu in menus:
		menu.visible = false
	animation.stat_bars.remove_stat_bars()
	animation.animation.visible = false
	

func display_toast(message, gravity = "bottom", direction = "center"):
	ToastParty.show({
		"text": message,           # Text (emojis can be used)
		"gravity": gravity,                   # top or bottom
		"direction": direction,               # left or center or right
	})
	
	"""
		ToastParty.show({
		"text": "Toast test",           # Text (emojis can be used)
		"bgcolor": Color(0, 0, 0, 0.7),     # Background Color
		"color": Color(1, 1, 1, 1),         # Text Color
		"gravity": "top",                   # top or bottom
		"direction": "right",               # left or center or right
		"text_size": 18,                    # [optional] Text (font) size // experimental (warning!)
		"use_font": true                    # [optional] Use custom ToastParty font // experimental (warning!)
	})
	"""

func process_stats(stats):
	if !stats:
		return
	var toast = ""
	for stat in stats:
		var label
		if ( "emoji" in Constants.stats[stat] ):
			label = Constants.stats[stat].emoji
		elif ( "label" in Constants.stats[stat] ):
			label = Constants.stats[stat].label
		else:
			label = stat
		
		var plus = "+"
		if (stats[stat] < 0):
			plus = ""
		
		if stat == "experience":
			Player.gain_experience(stats["experience"])
			toast += "[" + plus + str(stats[stat]) + " " + label + "] "
		elif stat in Constants.stats.scholarship_unaffected:
			Player.stats[stat] += stats[stat]
			toast += "[" + plus + str(stats[stat]) + " " + label + "] "
		else:
			var stat_gain:int = stats[stat] * (1 + Player.stats.scholarship/Constants.stats.scholarship.bonus_ratio)
			Player.stats[stat] += stat_gain
			toast += "[" + plus + str(stat_gain) + " " + label + "] "
			
	display_toast(toast, "top", "center")
	display_stats()

func display_stats() -> void:
	stats.display_stats()
	gold_label.display_gold()
	walks_label.display_walks()
	get_tree().call_group("StatBars", "display_stats")
	get_tree().call_group("Job_Button", "update_difficulty_color")	
	get_tree().call_group("Lesson_Button", "update_difficulty_color")	

func _on_dialogic_signal(dialogic_signal) -> void:
	dialogic_signal = JSON.parse_string(dialogic_signal)
	if "item" in dialogic_signal:
		Player.inventory.create_and_add_item(dialogic_signal.item)
	if "stats" in dialogic_signal:
		process_stats(dialogic_signal.stats)
	if "location_flags" in dialogic_signal:
		for flag in dialogic_signal.location_flags:
			Player.location_flags[flag] = dialogic_signal.location_flags[flag]
	#TODO, verify 'gray' background
	if "background" in dialogic_signal:
		Player.background_inventory.create_and_add_item(dialogic_signal.background)
	
func _on_timeline_started() -> void:
	get_tree().call_group("Live2DPlayer", "pause_live2d")
	dialogic_panel.show()
	dialogic_viewport_container.show()
	current_state = states.DIALOGIC
	
func _on_timeline_ended() -> void:
	get_tree().call_group("Live2DPlayer", "resume_live2d")
	update_expressions()
	dialogic_panel.hide()
	dialogic_viewport_container.hide()
	current_state = states.READY
	
func _on_inventory_item_added(item):
	#Note: Do not apply scholarhsip bonus to items
	var toast = "Obtained " + item.get_property("name")
	display_toast(toast, "bottom", "center")
	for stat in item.get_property("stats", {}):
		Player.stats[stat] += item.get_property("stats")[stat]
	
	for flag in item.get_property("flags", {}):
		var value = item.get_property("flags")[flag]
		if flag in Player.skill_flags:
			if value > Player.skill_flags[flag]:
				Player.skill_flags[flag] = value
		else:
			Player.skill_flags[flag] = value
			
	if item.get_property("combat_skill", {}):
		Player.combat_skills.append(item.get_property("combat_skill", {}))
		
	get_tree().call_group("ButtonMenu", "update_buttons")
#helper function due to 4.2 lacking 4.3's weighted random chocie
func rand_weighted(weights) -> int:
	var weight_sum = 0
	for weight in weights:
		weight_sum += weight
	var rng = RandomNumberGenerator.new()
	var choice = rng.randf_range(0, weight_sum)
	for i in range(len(weights)):
		if(choice <= weights[i]):
			return i
		choice -= weights[i]
	return 0

func update_expressions() -> void:
	if (Player.stats["stress"] < 20):
		get_tree().call_group("Live2DPlayer", "start_expression", player_model.smile_expression)
	if (Player.stats["stress"] < 10):
		get_tree().call_group("Live2DPlayer", "queue_motion", player_model.heal_motion)
	else:
		get_tree().call_group("Live2DPlayer", "queue_motion", player_model.content_motion)
	if (Player.stats["stress"] > 80):
		get_tree().call_group("Live2DPlayer", "start_expression", player_model.angry_expression)


func _on_enter_tower_button_pressed() -> void:
	if Player.tower_level < len(Constants.tower_levels):
		Player.enemies = Constants.tower_levels[Player.tower_level].enemies
		Player.in_tower = true
		SceneLoader.load_scene("res://Scenes/Combat/Combat.tscn")
	else:
		display_toast("The tower is cleared", "top", "center")

func check_and_play_daily_events() -> void:
	if skip_movie:
		return
	if Player.day == 1 and !('Day1Event' in Player.event_flags):
		Dialogic.start("Day1Event")
		Player.event_flags['Day1Event'] = true
		
	if Player.day == 5 and !('Day5Event' in Player.event_flags):
		Dialogic.start("Day1Event")
		Player.event_flags['Day5Event'] = true
		
#Tooltip replacement for mobile which doesn't have hover tooltips
func _on_player_inventory_item_activated(tooltip):
	if Constants.mode == "PHONE":
		display_toast(tooltip, "bottom", "center")
