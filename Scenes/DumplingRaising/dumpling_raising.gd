class_name DumplingRaising
extends Control

var chat_toasts = [
	{"toast": "Grow up healthy, okay?", "voice": "keep_it_up"},
	{"toast": "Grow up sweet and tasty, okay? *Drool*", "voice": "looks_delicious"},
	{"toast": "Teehee. Hello!", "voice": "greeting0"},
	{"toast": "Good morning!", "voice": "greeting3"},
	{"toast": "You have to eat lots to grow bigger, okay?", "voice": "proud"},
]

@onready var name_edit: LineEdit = %NameEdit

func _ready() -> void:
	update_display()
	visibility_changed.connect(update_display)
	var buttons = get_tree().get_nodes_in_group("Button")
	for button in buttons:
		#For now only buttons should be the raising ones, redo this section if changed
		button.connect("pressed", Player._play_button_sound)
		button.pressed.connect(_on_button_pressed.bind(button))
		
#TODO, disable button if action used already today
func update_display() -> void:
	pass

func _on_button_pressed(button: Button) -> void:
	var button_name = button.name
	match button_name:
		"ChatButton":
			var chat = chat_toasts.pick_random()
			Player.display_toast(chat.toast)
			Player.play_voice(chat.voice)
		"FeedButton":
			var toast = "You scoop out some flour and put it into %s's feeding bowl." %Player.dumpling_stats.name
			Player.display_toast(toast)
		"BatheButton":
			var toast = "You gave %s a bath." %Player.dumpling_stats.name
			Player.display_toast(toast)
			pass
		"StrengthTrainingButton":
			var toast = "Time for weight training! %s worked hard." %Player.dumpling_stats.name
			Player.display_toast(toast)
			pass
		"StaminaTrainingButton":
			var toast = "Swimming is good for stamina." %Player.dumpling_stats.name
			Player.display_toast(toast)
			pass
		"SpeedTrainingButton":
			var toast = "%s isn't able to fly, but they seem to enjoy running around." %Player.dumpling_stats.name
			Player.display_toast(toast)
			pass
		_:
			printerr("Unmatched button_name in _on_button_pressed for DumplingRaising")

var dumpling_stats = {
	"name": "Dumpling",
	"stats": {
		"mood": 50,
		"bond": 0,
		"clean": 100,
		"strength": 0,
		"stamina": 0,
		"speed": 0,
	},
	"action_per_day": 2,
	"remaining_actions": 2,
}

func _on_dumpling_name_changed(new_text):
	Player.dumpling_stats.name = new_text

func _on_name_config_button_pressed():
	name_edit.editable = !name_edit.editable
	name_edit.grab_focus()
