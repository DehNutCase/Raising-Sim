extends Control

@onready var player_model = $Ui/PlayerControl/Player
@onready var inventory = $Ui/PlayerControl/Player/PlayerInventory
@onready var background = $Ui/PlayerControl/Player/BackgroundInventory
@onready var skills = $Ui/PlayerControl/Player/SkillInventory
@onready var inventory_lists = [inventory, background, skills]
@onready var dialogic_viewport = $Ui/DialogicPanel/DialogicViewportContainer/DialogicViewport
@onready var dialogic_viewport_container = $Ui/DialogicPanel/DialogicViewportContainer
@onready var dialogic_panel = $Ui/DialogicPanel

@onready var day_label = $Ui/Calendar/VBoxContainer/DayLabel

@onready var menu_panel = $Ui/MenuPanel
@onready var lessons = $Ui/MenuPanel/MarginContainer/Lessons
@onready var schedule = $Ui/MenuPanel/MarginContainer/Schedule
@onready var shop = $Ui/MenuPanel/MarginContainer/Shop
@onready var walk = $Ui/MenuPanel/MarginContainer/Walk
@onready var tower = $Ui/MenuPanel/MarginContainer/Tower
@onready var class_change = $"Ui/MenuPanel/MarginContainer/Class Change"
@onready var story = $"Ui/MenuPanel/MarginContainer/Story"
@onready var stats = $Ui/MenuPanel/MarginContainer/Stats
@onready var spellbook = $Ui/MenuPanel/MarginContainer/Spellbook

@onready var course_schedule = $"Ui/MenuPanel/MarginContainer/Lessons/HBoxContainer/TabContainer/Course Schedule"

@onready var buttons = $LeftMenuContainer/MenuPanel/VBoxContainer
@onready var buttons2 = $RightMenuContainer/MenuPanel/VBoxContainer
@onready var buttons3 = $BottomMenuContainer/HBoxContainer

@onready var button_containers = [buttons, buttons2, buttons3]

@onready var gray_portrait = $Ui/PlayerControl/Player/Gray

@onready var deck = %Deck
#TODO, add spellbook menu
@onready var menus = [shop, walk, stats, tower, class_change, story, schedule, lessons, spellbook]

@onready var popup = %Popup

var jobs = Constants.jobs
var rests = Constants.rests

var day: int:
	get:
		return Player.day
	set(value):
		Player.day = value

enum states {READY, DIALOGIC, BUSY}
var current_state = states.READY
var day_state = states.READY

var selected_class_change_class: String
var class_change_requirements_fufilled = false

var selected_mission:String

#TODO, margin container 3 stretch ratio to .5, update images to use height of 200 or 300? for combat scene
func _ready():
	#TODO, sycnhronize background size of dialogic & main scene (move chars downward)
	#TODO, display class change card data in stats
	#Game needs to be loaded here
	self.hide()
	if !Player.save_loaded:
		if OS.has_feature("demo"):
			Player.load_demo()
		else:
			Player.load_game()
	Player.save_loaded = true
	
	#Load font size from settings
	var theme = load("res://Art/Themes/MainMenuTheme.tres")
	theme.default_font_size = Config.get_config("CustomSettings", "FontSize")
	
	if (Player.background_inventory.has_item_with_prototype_id("gray")):
		gray_portrait.show()
	
	Dialogic.Styles.load_style("VisualNovelStyle", dialogic_viewport)
	Dialogic.signal_event.connect(_on_reward_signal)
	Dialogic.timeline_ended.connect(_on_timeline_ended)
	Dialogic.timeline_started.connect(_on_timeline_started)
	for inventory_name in Player.inventories:
		Player[inventory_name].item_added.connect(_on_inventory_item_added)
		
	for button_container in button_containers:
		for button in button_container.get_children():
			button.pressed.connect(_on_action.bind(button))
	get_tree().call_group("MuteButton", "_update")
	display_stats()
	self.show()
	
	if (day == 0):
		for inventory_name in Player.inventories:
			for starting_item in Player.starting_items[inventory_name]:
				Player[inventory_name].create_and_add_item(starting_item)
				
		var course_list = []
		for course in Constants.courses.Core:
			course_list.append({"course_name": "Core", "lesson_name": course})
		Player.course_list = course_list
		process_day()
		
	
	if (Player.stats["stress"] < 50):
		get_tree().call_group("Live2DPlayer", "start_motion", player_model.hat_tip_motion)
	else:
		get_tree().call_group("Live2DPlayer", "start_motion", player_model.content_motion)
	
	if Player.reward_signal:
		display_toast("Gained rewards from the duel!", "top")
		await(get_tree().create_timer(.5).timeout)
		_on_reward_signal(Player.reward_signal)
		Player.reward_signal = {}
		if Player.tower_level == 21 and !Player.event_flags.get('ExitPass'):
			Player.event_flags['ExitPass'] = true
			Dialogic.start("ExitPass")
		display_stats()
	#TODO, delete below, dev use only
	if OS.has_feature("debug"):
		#Player.active_mission = ""
		#Player.max_walks = 100
		#Player.tower_level = 0
		#Player.skill_inventory.create_and_add_item("meteor")
		#var item = Player.inventory.get_item_with_prototype_id("diligent_student")
		#Player.inventory.remove_item(item)
		#Player.stats.gold = 0
		#Player.stats.art = 500
		#Player.stats.skill = 0
		#Dialogic.start("WizardsApprentice1")
		#Player.event_flags['mission_information_event'] = true
		#day = 1
		pass
	#TODO, end dev use section
	get_tree().call_group("ButtonMenu", "update_buttons")

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if menu_panel.visible:
			_on_close_button_pressed()
			get_viewport().set_input_as_handled()
		for item_list in inventory_lists:
			if item_list.visible:
				item_list.hide()
				get_viewport().set_input_as_handled()

#TODO, process day should now call the schedule and then play the end of day scene
#(EOD scene mostly night events---bedtime story with Rice etc. sometimes just tiny
#text like walk where you didn't meet someone)
func process_day():
	day_state = states.BUSY
	
	var action_list = []
	action_list.append_array(Player.mandatory_daily_schedule_list)
	action_list.append_array(Player.daily_schedule_list)
	
	#TODO, handle main scene background changes here?
	#TODO, hide all open menus
	if day == 0:
		#don't do actions day 1
		action_list = []
	var i = 0
	#TODO, add messages as mao does her daily tasks <- important!
	#TODO, set state to not ready
	for action in action_list:
		#TODO, await actions---set time for scene to change etc.
		background_transition(Constants.constants.TIMES_OF_DAY[i])
		await (get_tree().create_timer(.5).timeout)
		await do_action(action.action_type, action.action_name)
		await (get_tree().create_timer(4).timeout)
		i+=1
	
	background_transition(Constants.constants.TIMES_OF_DAY[i])
	
	await play_bedtime_event()
	
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

		
	items = inventory.inventory.get_items().duplicate()
	var item_deletion_queue = []
	
	for item in items:
		if item.get_property("expiration", ""):
			var expiration = item.get_property("expiration", "")
			match expiration:
				"daily":
					item_deletion_queue.append(item)
				"monthly":
					#Off by one error if equal to 0
					if day % Constants.constants.days_in_month == 1:
						item_deletion_queue.append(item)
				_:
					printerr("expiration process_day failed to match")
	
	for item in item_deletion_queue:
		inventory.inventory.remove_item(item)
	
	for stat in Player.stats:
		if !stat in Constants.stats:
			printerr(stat + " isn't in Constants.stats")
			continue
		if "min" in Constants.stats[stat] && Player.stats[stat] < Player.calculate_min_stat(stat):
			Player.stats[stat] = Player.calculate_min_stat(stat)
		if "max" in Constants.stats[stat] && Player.stats[stat] > Player.calculate_max_stat(stat):
			Player.stats[stat] = Player.calculate_max_stat(stat)
	
	#always return to morning before next day
	background_transition()
	
	display_stats()
	_on_close_button_pressed()
	update_expressions()
	check_and_play_daily_events()
	if (Player.background_inventory.has_item_with_prototype_id("gray")):
		gray_portrait.show()
		
	day_state = states.READY

		
func do_action(action_type:String, action_name: String):
	if action_type == 'school':
		await daily_course()
		#NOTES, the below works as you'd expect, timeline starts and execution continues
		#Once signal is sent
		#TODO, add check for flags of timelines (only play ink mage school once etc.)
		#Dialogic.start("InkMageSchoolFirst")
		#await Dialogic.timeline_ended
		return
	
	if action_name == 'Cram School':
		await do_cram_school()
		return

	var action_stats = Constants[action_type][action_name].stats
	var icon = Constants[action_type][action_name].get("icon")
	var rng = RandomNumberGenerator.new()
	if (ActionButton.get_success_chance(action_type, action_name) > rng.randf() * 100):
		#Occasionally play a random event
		#TODO, change 0 to 95 or whatever is appropriate (odds = 100 - x)
		#if rng.randf() * 100 > 0:
		if rng.randf() * 100 > (100 - Constants.constants.JOB_EVENT_ODDS):
			if Constants[action_type][action_name].get("timelines"):
				var timeline = Constants[action_type][action_name].get("timelines").pick_random()
				Dialogic.start(timeline)
				await Dialogic.timeline_ended
				await(get_tree().create_timer(.5).timeout)
				
		get_tree().call_group("Live2DPlayer", "job_motion", true)
		process_stats(action_stats, icon)
		if Constants[action_type][action_name].get("proficiency"):
			Player.proficiencies[action_name] += Constants[action_type][action_name].proficiency_gain
			if ('skill' in Constants[action_type][action_name]):
				if (Player.proficiencies[action_name] >= Constants[action_type][action_name].skill.proficiency_required):
					if (!Player.skill_inventory.get_item_with_prototype_id(Constants[action_type][action_name].skill.id)):
						await(get_tree().create_timer(.5).timeout)
						Player.skill_inventory.create_and_add_item(Constants[action_type][action_name].skill.id)
	else:
		get_tree().call_group("Live2DPlayer", "job_motion", false)
		if "stress" in action_stats:
			process_stats({"stress": action_stats["stress"]}, icon)
		if Constants[action_type][action_name].get("proficiency"):
			Player.proficiencies[action_name] += Constants[action_type][action_name].proficiency_gain/2
	
func background_transition(time:String = "morning"):
	var bg_holder:TextureRect= $Ui/BackgroundLayer/BackgroundHolder
	var next_background = load("res://Art/Background/Background material shop/bg007a.bmp")
	match time:
		"morning":
			next_background = load("res://Art/Background/Background material shop/bg007a.bmp")
		"noon":
			next_background = load("res://Art/Background/Background material shop/bg007b.bmp")
		"afternoon":
			next_background = load("res://Art/Background/Background material shop/bg007b.bmp")
		"night":
			next_background = load("res://Art/Background/Background material shop/bg007c.bmp")
		"bedtime":
			next_background = load("res://Art/Background/Background material shop/bg007d.bmp")
	bg_holder.material.set_shader_parameter("next_background", next_background)
	var tween := create_tween()
	var tweener := tween.tween_property(bg_holder, "material:shader_parameter/progress", 1.0, 4.0).from(0.0)
	await tweener.finished
	bg_holder.material.set_shader_parameter("previous_background", next_background)
	

func do_job(job_name: String) :
	var job_stats = Constants.jobs[job_name]["stats"]
	var rng = RandomNumberGenerator.new()
	if (JobButton.get_success_chance(job_name) > rng.randf() * 100):
		get_tree().call_group("Live2DPlayer", "job_motion", true)
		process_stats(job_stats)
		Player.proficiencies[job_name] += Constants.jobs[job_name].proficiency_gain
		if ('skill' in Constants.jobs[job_name]):
			if (Player.proficiencies[job_name] >= Constants.jobs[job_name].skill.proficiency_required):
				if (!Player.skill_inventory.get_item_with_prototype_id(Constants.jobs[job_name].skill.id)):
					Player.skill_inventory.create_and_add_item(Constants.jobs[job_name].skill.id)
	else:
		get_tree().call_group("Live2DPlayer", "job_motion", false)
		if "stress" in job_stats:
			process_stats({"stress": job_stats["stress"]})
		Player.proficiencies[job_name] += Constants.jobs[job_name].proficiency_gain/2
	#process_day()
	
func do_lesson(lesson_name: String) :
	var lesson_stats = Constants.lessons[lesson_name]["stats"]
	var cost = 0
	if "gold" in lesson_stats: cost = -lesson_stats.gold
	if (cost > Player.stats["gold"]):
		display_toast("Not enough gold! " + "(" + str(cost) + ")", "top", "center")
		return
	var rng = RandomNumberGenerator.new()
	if (LessonButton.get_success_chance(lesson_name) > rng.randf() * 100):
		get_tree().call_group("Live2DPlayer", "job_motion", true)
		process_stats(lesson_stats)
		if 'proficiency' in Constants.lessons[lesson_name]:
			Player.proficiencies[lesson_name] += Constants.lessons[lesson_name].proficiency_gain
		if ('skill' in Constants.lessons[lesson_name]):
			if (Player.proficiencies[lesson_name] >= Constants.lessons[lesson_name].skill.proficiency_required):
				if (!Player.skill_inventory.get_item_with_prototype_id(Constants.lessons[lesson_name].skill.id)):
					Player.skill_inventory.create_and_add_item(Constants.lessons[lesson_name].skill.id)
	else:
		get_tree().call_group("Live2DPlayer", "job_motion", false)
		if "stress" in lesson_stats:
			process_stats({"stress": lesson_stats["stress"], "gold": lesson_stats["gold"]})
		Player.proficiencies[lesson_name] += Constants.lessons[lesson_name].proficiency_gain/2
	lessons.hide()
	#process_day()

func daily_course():
	if day == 1:
		#TODO, get different timeline depending on which elective Mao has
		Dialogic.start("InkMageSchoolFirst")
		await Dialogic.timeline_ended
		await(get_tree().create_timer(.5).timeout)
	
	display_toast("Mao went to class!", "top")
	
	
	if Player.course_list:
		await process_course_progress()
		await(get_tree().create_timer(.5).timeout)
		
		var course_name = Player.course_list[0].course_name
		var lesson_name = Player.course_list[0].lesson_name
		var icon = Constants.courses[course_name][lesson_name].get("icon")
		#Can only modify a duplicate if changing the stat array is needed
		var course_daily_stats = Constants.courses[course_name][lesson_name].stats.duplicate()
		#School is free so remove gold cost
		get_tree().call_group("Live2DPlayer", "job_motion", true)
		course_daily_stats.erase("gold")
		process_stats(course_daily_stats, icon) 
		

	else:
		await(get_tree().create_timer(.5).timeout)
		display_toast("But she doesn't have any classes to take.", "top")
		await(get_tree().create_timer(.5).timeout)
		get_tree().call_group("Live2DPlayer", "job_motion", true)
		process_stats({"stress": -10})
	
	
		
func do_cram_school():
	if Player.course_list:
		var course_name = Player.course_list[0].course_name
		var lesson_name = Player.course_list[0].lesson_name
		var course_daily_stats = Constants.courses[course_name][lesson_name].stats
		var icon = Constants.courses[course_name][lesson_name].get("icon")
		
		#For now disabled cost check, allowing Mao to go into debt for cram school
		#var cost = 0
		#if "gold" in course_daily_stats: cost = -course_daily_stats.gold
		#if (cost > Player.stats["gold"]):
			#display_toast("Not enough gold! " + "(" + str(cost) + ")", "top", "center")
			#return
		
		display_toast("Mao went to cram school.", "top")
		await process_course_progress()
		
		await(get_tree().create_timer(.5).timeout)
		get_tree().call_group("Live2DPlayer", "job_motion", true)
		process_stats(course_daily_stats, icon)
	else:
		display_toast("Mao doesn't have any classes scheduled.", "top")
		await(get_tree().create_timer(.5).timeout)
		get_tree().call_group("Live2DPlayer", "job_motion", true)
		process_stats({"stress": -10})
	
func process_course_progress():
	var lesson_name = Player.course_list[0].lesson_name
	var course_name = Player.course_list[0].course_name
	
	if lesson_name in Player.course_progress:
		Player.course_progress[lesson_name] += Constants.constants.BASE_COURSE_PROGRESS + Player.stats.scholarship
		if Player.course_progress[lesson_name] >= Constants.courses[course_name][lesson_name].required_progress * .5:
			#If we're more than 50% done and we have 3 timelines and haven't played the timeline before, play the middle one
			var timelines = Constants.courses[course_name][lesson_name].get("timelines")
			if timelines and len(timelines) == 3 and !Player.event_flags.get(timelines[1]):
				Player.event_flags[timelines[1]] = true
				await play_course_progress_timeline(course_name, lesson_name, 1)
	else:
		#Play first course timeline if it's the first time
		await play_course_progress_timeline(course_name, lesson_name, 0)
		Player.course_progress[lesson_name] = Constants.constants.BASE_COURSE_PROGRESS + Player.stats.scholarship
		
	if Player.course_progress[lesson_name] >= Constants.courses[course_name][lesson_name].required_progress:
		#Play last timeline before finishing course
		await play_course_progress_timeline(course_name, lesson_name, -1)
		Player.courses_completed[lesson_name] = true
		Player.course_list.pop_front()
		if Constants.courses[course_name][lesson_name].get("skill"):
			var skill = Constants.courses[course_name][lesson_name].skill.id
			if (!Player.skill_inventory.get_item_with_prototype_id(skill)):
				Player.skill_inventory.create_and_add_item(skill)
	
func play_course_progress_timeline(course_name:String, lesson_name:String, index=0):
	var timelines = Constants.courses[course_name][lesson_name].get("timelines")
	if !timelines:
		return
	else:
		Dialogic.start(timelines[index])
		await Dialogic.timeline_ended
		await(get_tree().create_timer(.5).timeout)
	
func course_button_click(course_name:String, lesson_name:String):
	course_schedule.add_course(course_name, lesson_name)

func do_rest(rest_name: String) -> void:
	var rest_stats = Constants.rests[rest_name]["stats"]
	var cost = 0
	if "gold" in rest_stats: cost = -rest_stats.gold
	if ( cost > Player.stats["gold"]):
		display_toast("Not enough gold! " + "(" + str(cost) + ")", "top", "center")
		return
	process_stats(rest_stats)
	#process_day()
	
func do_walk(walk_name: String) -> void:
	if Player.remaining_walks > 0:
		var weights = []
		var outcomes = Constants.locations[walk_name].outcomes
		for outcome in outcomes:
			if ('weight' in outcome):
				var weight = outcome.weight
				if Player.inventory.get_item_with_prototype_id("lucky_clover") and 'timeline' in outcome:
					weight *= 5
				weights.append(weight)
			else:
				weights.append(1)
		var outcome = outcomes[rand_weighted(weights)]
		var walk_stats = outcome.stats
		walk.visible = false
		Player.remaining_walks -= 1
		#TODO, double check if we should always close after walks
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
		_on_close_button_pressed()

func buy_item(item: String, price: int):
	if Player.stats["gold"] >= price:
		Player.stats["gold"] -= price
		Player.inventory.create_and_add_item(item)
	else:
		display_toast("Not enough gold!", "top", "center")
	display_stats()
	%Shop.update_buttons()


func _on_action(button):
	if current_state != states.READY or day_state != states.READY:
		printerr("_on_action state not READY")
		return
	var open_menu: String
	for menu in menus:
		if menu.visible:
			open_menu = menu.name
	_on_close_button_pressed()
	
	match button.name:
		"Schedule":
			schedule.show()
		"Spellbook":
			spellbook.show()
		"Lessons":
			lessons.show()
		"Inventory":
			inventory.visible = !inventory.visible
			menu_panel.visible = true
		"Shop":
			shop.show()
		"Walk":
			walk.show()
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
			tower.get_node("Description").clear()
			if(Player.tower_level < len(Constants.tower_levels)):
				if "image" in Constants.tower_levels[Player.tower_level]:
					var image = load(Constants.tower_levels[Player.tower_level].image)
					tower.get_node("Description").add_image(image, 0, 150)
					tower.get_node("Description").add_text("\n")
				tower.get_node("Description").add_text(Constants.tower_levels[Player.tower_level].description)
			else:
				tower.get_node("Description").add_text("A mysterious force (Rice grabbing you by the scruff of your neck) prevents you from climbing any higher.")
		"Class Change":
			load_class_change_text("ink_mage_journeyman")
			class_change.show()
		"Story":
			if Player.active_mission:
				#Start next timeline if no combat
				if !Player.active_mission.get('combat'):
					Dialogic.start(Player.active_mission.get('next'))
				else:
					#'combat' entry should be list of enemies for the fight
					Player.enemies = Player.active_mission.combat.enemies
					Player.in_tower = false
					Player.in_mission = true
					SceneLoader.load_scene("res://Scenes/Combat/Combat.tscn")
			else:
				if Player.unlocked_missions:
					load_mission_text(Player.unlocked_missions.keys()[0])
				else:
					printerr("No missions are unlocked yet, story button shouldn't be displayed")
				story.show()
		"Save":
			Player.save_game()
			menu_panel.visible = true
		"Wishlist":
			if Steam.isSteamRunning():
				Steam.activateGameOverlayToStore(3552520)
				#url: https://store.steampowered.com/app/3552520/Raising_Niziiro_Albions_Witch
			else:
				display_toast("Steam isn't running! Please wishlist 'Raising Niziiro: Albion's Witch' manually.","top")
			menu_panel.visible = true
		"Demo":
			display_toast("Please check out the story if you haven't already. The Demo is over.")
			menu_panel.visible = true
		_:
			printerr("_on_action failed to match")
			
	if open_menu == button.name:
		_on_close_button_pressed()
	else:
		menu_panel.visible = !menu_panel.visible
	

func _on_close_button_pressed():
	menu_panel.visible = false
	for menu in menus:
		menu.visible = false
	

func display_toast(message, gravity = "bottom", direction = "center", icon = null):
	ToastParty.show({
		"text": message,           # Text (emojis can be used)
		"gravity": gravity,                   # top or bottom
		"direction": direction,               # left or center or right
		"icon": icon,
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

func process_stats(stats, icon = null):
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
			var stat_gain = stats[stat]
			if "bonus_exp" in Player.stats:
				stat_gain *= (1 + Player.stats.bonus_exp/100.0)
				stat_gain = int(stat_gain)
			toast += "[" + plus + str(stat_gain) + " " + label + "] "
		elif stat in Constants.stats.scholarship_unaffected:
			Player.stats[stat] += stats[stat]
			toast += "[" + plus + str(stats[stat]) + " " + label + "] "
		else:
			var stat_gain:int = stats[stat]
			#Apply scholarship only to stat increases
			if stat_gain > 0: stat_gain *= (1 + Player.stats.scholarship/Constants.stats.scholarship.bonus_ratio)
			Player.stats[stat] += stat_gain
			toast += "[" + plus + str(stat_gain) + " " + label + "] "
			
	display_toast(toast, "top", "center", icon)
	display_stats()

func display_stats() -> void:
	#TODO, change day label to call group instead
	day_label.display_day(day)
	get_tree().call_group("StatBars", "display_stats")
	#TODO, make sure to only update buttons when something needs to be displayed
	#Performance issues
	get_tree().call_group("ActionButton", "update_difficulty_color")
	get_tree().call_group("Job_Button", "update_difficulty_color")
	get_tree().call_group("Lesson_Button", "update_difficulty_color")
	#Update Menu Button displays
	if Player.event_flags.get("class_change_information_event"):
		$"LeftMenuContainer/MenuPanel/VBoxContainer/Class Change".show()
	else:
		$"LeftMenuContainer/MenuPanel/VBoxContainer/Class Change".hide()
	if Player.unlocked_missions:
		$"RightMenuContainer/MenuPanel/VBoxContainer/Story".show()
	else:
		$"RightMenuContainer/MenuPanel/VBoxContainer/Story".hide()
	if OS.has_feature("playtest") or OS.has_feature("demo"):
		$"RightMenuContainer/MenuPanel/VBoxContainer/Wishlist".show()
	else:
		$"RightMenuContainer/MenuPanel/VBoxContainer/Wishlist".hide()
	if OS.has_feature("demo"):
		$"RightMenuContainer/MenuPanel/VBoxContainer/Save".hide()
		#TODO, unhide this for later demo
		$"LeftMenuContainer/MenuPanel/VBoxContainer/Tower".hide()
		#Hide ways to advance day after demo ends
		if day > 2 * Constants.constants.days_in_month:
			$"RightMenuContainer/MenuPanel/VBoxContainer/Schedule".hide()
			$"RightMenuContainer/MenuPanel/VBoxContainer/Demo".show()
	else:
		$"RightMenuContainer/MenuPanel/VBoxContainer/Save".show()
	
func _on_reward_signal(dialogic_signal) -> void:
	dialogic_signal = JSON.parse_string(dialogic_signal)
	if "item" in dialogic_signal:
		#TODO Make sure not to let dialogic create too many items (perhaps add dialogic_limit setting and handler?)
		Player.inventory.create_and_add_item(dialogic_signal.item)
	if "stats" in dialogic_signal:
		process_stats(dialogic_signal.stats)
	if "location_flags" in dialogic_signal:
		for flag in dialogic_signal.location_flags:
			Player.location_flags[flag] = dialogic_signal.location_flags[flag]
	if "event_flags" in dialogic_signal:
		for flag in dialogic_signal.event_flags:
			Player.event_flags[flag] = dialogic_signal.event_flags[flag]
	if "background" in dialogic_signal:
		if (!Player.background_inventory.get_item_with_prototype_id(dialogic_signal.background)):
			Player.background_inventory.create_and_add_item(dialogic_signal.background)
	if "skill" in dialogic_signal:
		if (!Player.skill_inventory.get_item_with_prototype_id(dialogic_signal.skill)):
			Player.skill_inventory.create_and_add_item(dialogic_signal.skill)
	if "music" in dialogic_signal:
		get_tree().call_group("BackgroundMusicPlayer", "play_song", dialogic_signal.music)
	if "mission" in dialogic_signal:
		Player.active_mission = dialogic_signal.mission
		if Player.active_mission.get('combat'):
			var mission = Player.active_mission.combat.split(',')[0]
			var combat_number = int(Player.active_mission.combat.split(',')[1])
			Player.active_mission.combat = Constants.missions[mission].combats[combat_number]
		#recognize mission is finished when there's no timeline next
		if !Player.active_mission.get('next'): Player.active_mission = false
	if "unlocked_missions" in dialogic_signal:
		for mission in dialogic_signal.unlocked_missions:
			Player.unlocked_missions[mission] = dialogic_signal.unlocked_missions[mission]
	display_stats()
	#Below might be dangerous, never call timeline inside an actual timeline
	if "timeline" in dialogic_signal:
		Dialogic.start(dialogic_signal.timeline)
	
func _on_timeline_started() -> void:
	get_tree().call_group("BackgroundMusicPlayer", "pause_song")
	get_tree().call_group("Live2DPlayer", "pause_live2d")
	dialogic_panel.show()
	dialogic_viewport_container.show()
	current_state = states.DIALOGIC
	#Clear temporary flags
	Player.dialogic_temporary_flags = {}
	
func _on_timeline_ended() -> void:
	get_tree().call_group("BackgroundMusicPlayer", "resume_song")
	get_tree().call_group("Live2DPlayer", "resume_live2d")
	update_expressions()
	dialogic_panel.hide()
	dialogic_viewport_container.hide()
	current_state = states.READY
	display_stats()
	#Clear temporary flags
	Player.dialogic_temporary_flags = {}
	#Close open menus after timeline ends
	_on_close_button_pressed()
	
func _on_inventory_item_added(item:InventoryItem):
	#Note: Do not apply scholarship bonus to items
	var toast = "Obtained " + item.get_property("name", "")
	var icon_path = item.get_property("image", null)
	if item.get_property("special_type", null):
		match item.get_property("special_type", null):
			"card_pack":
				var card_pack = load(item.get_property("card_pack", null))
				var card = card_pack.cards.pick_random()
				toast = "Obtained " + card.id
				icon_path = card.icon.resource_path
				Player.card_game_deck.append(card)
				item.get_inventory().remove_item(item)
			_:
				printerr("item.get_property('special_type') failed to match")
	display_toast(toast, "bottom", "center", icon_path)
	for stat in item.get_property("stats", {}):
		Player.stats[stat] += item.get_property("stats")[stat]
		
	for stat in item.get_property("max_stats", {}):
		if Player.max_stats.get(stat):
			Player.max_stats[stat] += item.get_property("max_stats")[stat]
		else:
			Player.max_stats[stat] = item.get_property("max_stats")[stat]
	
	for stat in item.get_property("min_stats", {}):
		if Player.min_stats.get(stat):
			Player.min_stats[stat] += item.get_property("min_stats")[stat]
		else:
			Player.min_stats[stat] = item.get_property("min_stats")[stat]
	
	for flag in item.get_property("flags", {}):
		var value = item.get_property("flags")[flag]
		if flag in Player.skill_flags:
			if value > Player.skill_flags[flag]:
				Player.skill_flags[flag] = value
		else:
			Player.skill_flags[flag] = value
			
	if item.get_property("combat_skill", {}):
		Player.combat_skills.append(item.get_property("combat_skill", {}))
		
	if item.get_property("walks", 0):
		Player.max_walks += int(item.get_property("walks", 0))

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
	#TODO, add more expressions/motions
	if (Player.stats["stress"] < 20):
		get_tree().call_group("Live2DPlayer", "start_expression", player_model.smile_expression)
	elif (Player.stats["stress"] > 75):
		get_tree().call_group("Live2DPlayer", "start_expression", player_model.angry_expression)
	else:
		get_tree().call_group("Live2DPlayer", "start_expression", player_model.normal_expression)
	
	#Disabled idle motion on expression update for now
	#get_tree().call_group("Live2DPlayer", "queue_idle_motion")


func _on_enter_tower_button_pressed() -> void:
	if Player.tower_level < len(Constants.tower_levels):
		if Player.remaining_walks > 0:
			Player.remaining_walks -= 1
			_on_close_button_pressed()
			#TODO, remove all the double checking for whether player is in a mission or tower combat
			#centralize checks
			Player.in_tower = true
			Player.in_mission = false
			Player.encounter = Constants.tower_levels[Player.tower_level].encounter
			SceneLoader.load_scene("res://Scenes/CardGame/card_game.tscn")
		else:
			display_toast("No walks left!", "top")
	else:
		display_toast("Rice shakes her head. You can't climb any higher for now.", "top", "center")

func check_and_play_daily_events() -> void:
	var played = false
	if Player.day == 1 and !('Day1Event' in Player.event_flags):
		Dialogic.start("Day1Event")
		Player.event_flags['Day1Event'] = true
		played = true
	
	if Player.day == 5 and !('Day5Event' in Player.event_flags):
		Dialogic.start("Day5Event")
		Player.event_flags['Day5Event'] = true
		played = true
	
	#Note, this triggers at the last day of the month
	if Player.day == Constants.constants.days_in_month:
		Dialogic.start("Day30Event")
		played = true
	
	if Player.day == Constants.constants.days_in_month * 2:
		Dialogic.start("Day60Event")
		played = true
		
	if Player.day == Constants.constants.days_in_month * 3:
		Dialogic.start("Day90Event")
		played = true
	
	#Give the player a few days before the end of the year for this.
	if Player.day == Constants.constants.days_in_month * 4 - 5:
		Dialogic.start("Day120Event")
		played = true
	
	if Player.day == Constants.constants.days_in_month * 4 and Player.event_flags.get("class_change_information_event"):
		Dialogic.start("EndOfYearEvent")
		played = true
	
	#TODO, add check for if class changed (either have exitpass *or* is class changed)
	if !Player.event_flags.get('mission_information_event') and Player.event_flags.get('ExitPass') and !played:
			Player.event_flags['mission_information_event'] = true
			Dialogic.start("MissionRoom")
	
#Tooltip replacement for mobile which doesn't have hover tooltips
func _on_player_inventory_item_activated(tooltip):
	#Check if mobile and replace tooltips with toast
	if OS.has_feature("mobile"):
		ToastParty.show_mobile_tooltip({
				"text": tooltip,
				"gravity": "bottom",
				"direction": "center",
			})

func load_class_change_text(player_class: String):
	selected_class_change_class = player_class
	#Use below to add correct font that displays emoji if needed
	#var font = load("res://Art/Fonts/emoji_font_variation.tres")
	var desc = $"Ui/MenuPanel/MarginContainer/Class Change/DescriptionContainer/Description"
	var req = $"Ui/MenuPanel/MarginContainer/Class Change/DescriptionContainer/Requirements"
	var text = Constants.player_classes[player_class].description
	desc.clear()
	desc.append_text(text)
	
	class_change_requirements_fufilled = true
	if "required_stats" in Constants.player_classes[player_class]:
		var text1 = "Required Stats:\n"
		var text2 = "\n"
		var counter = 0
		for stat in Constants.player_classes[player_class].required_stats:
			var label = stat
			if ("label" in Constants.stats[stat]):
				label = Constants.stats[stat]["label"]
			if ("emoji" in Constants.stats[stat]):
				label += " (" + Constants.stats[stat].emoji + ")"
			var check_mark = "✅"
			if Constants.player_classes[player_class].required_stats[stat] > Player.stats[stat]:
				check_mark = "❌"
				class_change_requirements_fufilled = false
			if counter > 0:
				counter = 0
				text2 += label + ": " + str(Constants.player_classes[player_class].required_stats[stat]) + " " + check_mark + " " + "\n"
			else:
				counter += 1
				text1 += label + ": " + str(Constants.player_classes[player_class].required_stats[stat]) + " " + check_mark + " " + "\t\n"
		text = ""
		#Using p tab_stops and \t for dividing columns currently, see if there's better method
		text += "[table=2][cell][p tab_stops=525.0]"
		text += text1
		text += "[/p][/cell][cell]"
		text += text2
		text += "[/cell][/table]"
		req.clear()
		req.append_text(text)
	else:
		text = "This class has no required stats."
		req.clear()
		req.append_text(text)
		
	if "required_skills" in Constants.player_classes[player_class]:
		var skills = []
		for skill in Constants.player_classes[player_class].required_skills:
			var prototype = Player.skill_inventory.get_prototree().get_prototype(skill)
			var check_mark = "✅"
			if not Player.skill_inventory.get_item_with_prototype_id(skill):
				check_mark = "❌"
				class_change_requirements_fufilled = false
			if prototype and prototype.get_property("name"):
				skills.append(prototype.get_property("name") + " " + check_mark + " ")
				
		text = "\n\nRequired Skills: " + ", ".join(skills) + "\n"
		req.append_text(text)
		
func display_player_class_info(player_class:String) -> void:
	load_class_change_text(player_class)

func _on_select_class_button_pressed() -> void:
	if class_change_requirements_fufilled:
		Player.save_class_change_card(selected_class_change_class)
	else:
		display_toast("Class change requirements not fufilled!", "top")

func load_mission_text(mission: String):
	selected_mission = mission
	#Use below to add correct font that displays emoji if needed
	#var font = load("res://Art/Fonts/emoji_font_variation.tres")
	var desc = $"Ui/MenuPanel/MarginContainer/Story/DescriptionContainer/Description"
	#Displays mission info if not completed, else displays completion image.
	if !(selected_mission in Player.event_flags):
		var text = Constants.missions[mission].description
		desc.clear()
		desc.append_text(text)
	else:
		var image = load(Constants.missions[mission].mission_complete_image)
		desc.clear()
		desc.add_image(image)
	
		
func display_mission_info(mission:String) -> void:
	load_mission_text(mission)

func _on_select_mission_pressed() -> void:
	var mission_timeline_name = Constants.missions[selected_mission].first_timeline
	#Checks if mission is completed, otherwise only plays after end of year (day 121 or later)
	if !(selected_mission in Player.event_flags) or Player.day > Constants.constants.days_in_month * 4:
		Dialogic.start(mission_timeline_name)
	else:
		display_toast("Mission replay only available after the end of the year.", "top")
		
func _on_pause_menu_button_pressed():
	var pause_menu_packed = load("res://Scenes/GameTemplate/Menus/PauseMenu.tscn")
	InGameMenuController.open_menu(pause_menu_packed, get_viewport())

func _on_volume_button_toggled(toggled_on):
	AppSettings.set_mute(toggled_on)
	get_tree().call_group("MuteButton", "_update")


func _on_start_day_button_pressed():
	var action_amount = len(Player.mandatory_daily_schedule_list) + len(Player.daily_schedule_list)
	if action_amount >= Constants.constants.DAILY_ACTION_LIMIT:
		_on_close_button_pressed()
		process_day()
	else:
		display_toast("There are still empty slots in today's schedule.", "top")

func play_bedtime_event():
#TODO, at the end of day play specific bedtime event
	if day == 1:
		await (get_tree().create_timer(1).timeout)
		Dialogic.start("BedtimeFirst")
		await Dialogic.timeline_ended
		await(get_tree().create_timer(.5).timeout)

func _on_card_button_pressed(card: CardResource):
	if popup.visible:
		return
	popup.set_text("[center]Sell %s for %dG?[center]"%[card.id, card.price]) 
	popup.show()
	
	var sell = await popup.button_clicked
	if sell:
		Player.card_game_deck.erase(card)
		deck.update_buttons()
		process_stats({'gold': card.price})
