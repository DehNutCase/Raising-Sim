class_name DumplingRaising
extends Control

var dumpling_stats = {
	"mood": {
		"label" : "Mood",
		"min": 0,
		"max": 100,
	},
	"bond": {
		"label": "Bond",
		"min": -5,
		"max": 100,
	},
	"full": {
		"label": "Full",
		"min": 0,
		"max": 100,
	},
	"clean": {
		"label": "Clean",
		"min": 0,
		"max": 100,
	},
	"strength": {
		"label": "Strength",
		"min": 0,
	},
	"stamina": {
		"label": "Stamina",
		"min": 0,
	},
	"speed": {
		"label": "Speed",
		"min": 0,
	},
}

var dumpling_actions = {
	"chat": {
		"label" : "Chat",
		"stats": {
			"stress": -5,
		},
		"dumpling_stats": {
			"bond": 1,
			"mood": 5,
		},
		"icon": "res://Art/Mori no oku no kakurezato/Skill Icon/Resized/element51_01.png",
		"messages": [
			{"toast": "Grow up healthy, okay?", "voice": "keep_it_up"},
			{"toast": "Grow up sweet and tasty, okay? *Drool*", "voice": "looks_delicious"},
			{"toast": "Teehee. Hello!", "voice": "greeting0"},
			{"toast": "Good morning!", "voice": "greeting3"},
			{"toast": "You have to eat lots to grow bigger, okay?", "voice": "proud"},
		],
		"is_training": false,
	},
	"feed": {
		"label" : "Feed",
		"stats": {
			"gold": -5,
		},
		"dumpling_stats": {
			"bond": 1,
			"full": 30,
		},
		"icon": "res://Art/Mori no oku no kakurezato/Skill Icon/Resized/flour01_01.png",
		"messages": [
			{"toast": "You scoop out some flour and put it into %s's feeding bowl." %Player.dumpling_stats.name,},
		],
		"is_training": false,
	},
	"bathe": {
		"label": "Bathe",
		"stats": {
			"max_mp": 1,
			"magic": 1,
		},
		"dumpling_stats": {
			"bond": 1,
			"clean": 50,
		},
		"icon": "res://Art/Mori no oku no kakurezato/Skill Icon/Resized/bath01_01.png",
		"messages": [
			{"toast": "You gave %s a bath." %Player.dumpling_stats.name,},
		],
		"is_training": false,
	},
	"strength_training": {
		"label": "Strength Training",
		"stats": {
			"max_hp": 1,
			"attack": 1,
		},
		"dumpling_stats": {
			"bond": 1,
			"mood": -10,
			"full": -20,
			"clean": -10,
			"strength": 5,
			"stamina": 1,
		},
		"icon": "res://Art/Mori no oku no kakurezato/Skill Icon/Resized/training01_01.png",
		"messages": [
			{"toast": "Strength training! %s worked hard." %Player.dumpling_stats.name,},
		],
		"is_training": true,
	},
	"stamina_training": {
		"label": "Stamina Training",
		"stats": {
			"max_hp": 1,
			"agility": 1,
		},
		"dumpling_stats": {
			"bond": 1,
			"mood": -5,
			"full": -30,
			"clean": -5,
			"strength": 1,
			"stamina": 4,
			"speed": 1,
		},
		"icon": "res://Art/Mori no oku no kakurezato/Skill Icon/Resized/swimring01_02.png",
		"messages": [
			{"toast": "Swimming is good for stamina."},
		],
		"is_training": true,
	},
	"speed_training": {
		"label": "Speed",
		"stats": {
			"magic": 1,
			"agility": 1,
		},
		"dumpling_stats": {
			"bond": 1,
			"mood": -5,
			"full": -20,
			"clean": -55,
			"stamina": 2,
			"speed": 4,
		},
		"icon": "res://Art/Mori no oku no kakurezato/Skill Icon/Resized/swimring01_02.png",
		"messages": [
			{"toast": "%s can't to fly, but they seem to enjoy running around." %Player.dumpling_stats.name},
		],
		"is_training": true,
	},
}

var training_toasts = {
	"great_success_toast": "Training went amazingly well!",
	"success_toast": "Training went well.",
	"failure_toast": "Training didn't go well...",
	"big_failure_toast": "Training failed in ways that shouldn't have been possible..."
}

var training_stats = {
	"strength": true,
	"stamina": true,
	"speed": true,
}

@onready var name_edit: LineEdit = %NameEdit
@onready var actions_label: Label = %ActionsRemainingLabel
@onready var bond_label: Label = %BondLabel
@onready var mood_label: Label = %MoodLabel
@onready var full_label: Label = %FullLabel
@onready var clean_label: Label = %CleanLabel
@onready var str_label: Label = %StrLabel
@onready var sta_label: Label = %StaLabel
@onready var spd_label: Label = %SpdLabel

var is_updating := false

var FAST_TOAST_TIMEOUT_DURATION = Constants.constants.FAST_TOAST_TIMEOUT_DURATION
func _ready() -> void:
	update_display()
	visibility_changed.connect(call_deferred.bind("update_display"))
	
	var buttons = get_tree().get_nodes_in_group("DumplingActionButton")
	for button in buttons:
		button.pressed.connect(_on_button_pressed.bind(button))
		
#TODO, disable button if action used already today, and also based on actions left
func update_display() -> void:
	if is_updating:
		return
	else:
		is_updating = true
	actions_label.text = str(Player.dumpling_stats.remaining_actions)
	
	var buttons = get_tree().get_nodes_in_group("DumplingActionButton")
	if Player.dumpling_stats.remaining_actions <= 0:
		for button in buttons:
			button.disabled = true
	else:
		for button in buttons:
			button.disabled = false
	
	#Make sure stats are between min and max
	for stat in Player.dumpling_stats.stats:
		var max = dumpling_stats[stat].get("max")
		if "max" in dumpling_stats[stat] and Player.dumpling_stats.stats[stat] > max:
			Player.dumpling_stats.stats[stat] = max
		
		var min = dumpling_stats[stat].get("min")
		if "min" in dumpling_stats[stat] and Player.dumpling_stats.stats[stat] < min:
			Player.dumpling_stats.stats[stat] = min
	
	bond_label.text = "Bond: %d" %Player.dumpling_stats.stats.bond
	mood_label.text = "Mood: %d" %Player.dumpling_stats.stats.mood
	full_label.text = "Full: %d" %Player.dumpling_stats.stats.full
	clean_label.text = "Clean: %d" %Player.dumpling_stats.stats.clean
	str_label.text = "Strength: %d" %Player.dumpling_stats.stats.strength
	sta_label.text = "Stamina: %d" %Player.dumpling_stats.stats.stamina
	spd_label.text = "Speed: %d" %Player.dumpling_stats.stats.speed
	is_updating = false

func _on_button_pressed(button: Button) -> void:
	if Player.dumpling_stats.remaining_actions > 0:
		Player.dumpling_stats.remaining_actions -= 1
		update_display()
	else:
		return
	var button_name = button.name
	match button_name:
		"ChatButton":
			do_dumpling_action("chat")
		"FeedButton":
			do_dumpling_action("feed")
		"BatheButton":
			do_dumpling_action("bathe")
		"StrengthTrainingButton":
			do_dumpling_action("strength_training")
		"StaminaTrainingButton":
			do_dumpling_action("stamina_training")
		"SpeedTrainingButton":
			do_dumpling_action("speed_training")
		_:
			printerr("Unmatched button_name in _on_button_pressed for DumplingRaising")

func _on_dumpling_name_changed(new_text):
	Player.dumpling_stats.name = new_text

func _on_name_config_button_pressed():
	name_edit.editable = !name_edit.editable
	name_edit.grab_focus()

func process_dumpling_stats(stats, icon = null):
	if !stats:
		return
	var toast = ""
	for stat in stats:
		var label
		if ( "emoji" in dumpling_stats[stat] ):
			label = dumpling_stats[stat].emoji
		elif ( "label" in dumpling_stats[stat] ):
			label = dumpling_stats[stat].label
		else:
			label = stat
		
		var plus = "+"
		if (stats[stat] < 0):
			plus = ""
		var stat_gain = stats[stat]
		Player.dumpling_stats.stats[stat] += stat_gain
		toast += "[" + plus + str(stat_gain) + " " + label + "] "
	
	Player.display_toast(toast, "top", "center", icon)
	update_display()

#TODO, add failure and great success chances
func do_dumpling_action(action_name: String) -> void:
	var action_info = {}
	var main_stat = ""
	match action_name:
		"chat":
			action_info = dumpling_actions.get("chat").duplicate(true)
			var action_bonus = Player.dumpling_stats.action_bonuses.get("chat")
			if action_bonus:
				for stat in action_bonus:
					action_info.dumpling_stats[stat] += action_bonus[stat]
		"feed":
			action_info = dumpling_actions.get("feed").duplicate(true)
			var action_bonus = Player.dumpling_stats.action_bonuses.get("feed")
			if action_bonus:
				for stat in action_bonus:
					action_info.dumpling_stats[stat] += action_bonus[stat]
		"bathe":
			action_info = dumpling_actions.get("bathe").duplicate(true)
			var action_bonus = Player.dumpling_stats.action_bonuses.get("bathe")
			if action_bonus:
				for stat in action_bonus:
					action_info.dumpling_stats[stat] += action_bonus[stat]
		"strength_training":
			action_info = dumpling_actions.get("strength_training").duplicate(true)
			main_stat = "strength"
			var action_bonus = Player.dumpling_stats.action_bonuses.get("strength_training")
			if action_bonus:
				for stat in action_bonus:
					action_info.dumpling_stats[stat] += action_bonus[stat]
		"stamina_training":
			action_info = dumpling_actions.get("stamina_training").duplicate(true)
			main_stat = "stamina"
			var action_bonus = Player.dumpling_stats.action_bonuses.get("stamina_training")
			if action_bonus:
				for stat in action_bonus:
					action_info.dumpling_stats[stat] += action_bonus[stat]
		"speed_training":
			action_info = dumpling_actions.get("speed_training").duplicate(true)
			main_stat = "speed"
			var action_bonus = Player.dumpling_stats.action_bonuses.get("speed_training")
			if action_bonus:
				for stat in action_bonus:
					action_info.dumpling_stats[stat] += action_bonus[stat]

	var player_stats = action_info.stats
	get_tree().call_group("Main", "process_stats", player_stats)
	await get_tree().create_timer(FAST_TOAST_TIMEOUT_DURATION).timeout
	
	var dumpling_action_stats = action_info.dumpling_stats
	var icon = action_info.get("icon", null)
	await get_tree().create_timer(FAST_TOAST_TIMEOUT_DURATION).timeout
	if !action_info.is_training:
		process_dumpling_stats(dumpling_action_stats, icon)
	else:
		#Stat gets harder to train as you get more of it, but bond and mood makes it easier to train
		var training_rng_value: int = randi_range(0,100) + Player.dumpling_stats.stats.mood + Player.dumpling_stats.stats.bond - Player.dumpling_stats.stats[main_stat]
		var training_toast = ""
		if training_rng_value > 100:
			Player.play_ui_sound("great_success")
			training_toast = training_toasts.great_success_toast
			for stat in dumpling_action_stats:
				if !stat in training_stats:
					continue
				dumpling_action_stats[stat] = int(dumpling_action_stats[stat] * (1 + randf()))
			await get_tree().create_timer(FAST_TOAST_TIMEOUT_DURATION).timeout
			Player.display_toast(training_toast)
		elif training_rng_value > 50:
			Player.play_ui_sound("success")
			training_toast = training_toasts.success_toast
			for stat in dumpling_action_stats:
				if !stat in training_stats:
					continue
				dumpling_action_stats[stat] = int(dumpling_action_stats[stat] * (.5 + randf()))
			await get_tree().create_timer(FAST_TOAST_TIMEOUT_DURATION).timeout
			Player.display_toast(training_toast)
		elif training_rng_value > 0:
			Player.play_ui_sound("failure")
			training_toast = training_toasts.failure_toast
			for stat in dumpling_action_stats:
				if !stat in training_stats:
					continue
				dumpling_action_stats[stat] = int(dumpling_action_stats[stat] * (randf()))
			await get_tree().create_timer(FAST_TOAST_TIMEOUT_DURATION).timeout
			Player.display_toast(training_toast)
		else:
			Player.play_ui_sound("great_failure")
			training_toast = training_toasts.big_failure_toast
			for stat in dumpling_action_stats:
				if !stat in training_stats:
					continue
				dumpling_action_stats[stat] = int(dumpling_action_stats[stat] * (-1 - randf()))
			await get_tree().create_timer(FAST_TOAST_TIMEOUT_DURATION).timeout
			Player.display_toast(training_toast)
		
		await get_tree().create_timer(FAST_TOAST_TIMEOUT_DURATION).timeout
		process_dumpling_stats(dumpling_action_stats, icon)
	await get_tree().create_timer(FAST_TOAST_TIMEOUT_DURATION).timeout
	
	var message = {}
	message = action_info.messages.pick_random()
	if message:
		if message.get("toast"):
			#Mao is speaking for 'chat' action, so put the message on the bottom
			var position = "top"
			if action_name == "chat":
				position = "bottom"
			Player.display_toast(message.toast, position)
		if message.get("voice"):
			Player.play_voice(message.voice)
			
func process_dumpling_daily_stats() -> void:
	#Runs every day
	#Lowers bond and mood if full is low
	if Player.dumpling_stats.stats.full < 20:
		Player.dumpling_stats.stats.bond -= 20 -Player.dumpling_stats.stats.full
		Player.dumpling_stats.stats.mood -= 20 -Player.dumpling_stats.stats.full

	if Player.dumpling_stats.stats.full > 80:
		Player.dumpling_stats.stats.mood += 5
	if Player.dumpling_stats.stats.clean > 80:
		Player.dumpling_stats.stats.mood += 5
	#Increases bond if mood is high
	if Player.dumpling_stats.stats.mood > 90:
		Player.dumpling_stats.stats.bond += 1
	
	if Player.dumpling_stats.stats.full < 20 and Player.dumpling_stats.stats.mood < 20 and Player.dumpling_stats.stats.bond < 20:
		if randi_range(0,100) > Player.dumpling_stats.stats.full + Player.dumpling_stats.stats.mood + Player.dumpling_stats.stats.bond + 70:
			pass #Do run away code here
	
	Player.dumpling_stats.stats.full -= 15
	Player.dumpling_stats.stats.clean -= 10
	
	Player.dumpling_stats.remaining_actions = Player.dumpling_stats.action_per_day
	update_display()
