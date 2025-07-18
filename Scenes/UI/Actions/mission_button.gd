extends MarginContainer

@onready var button_label = $Button/Label
var mission_name = ""

signal pressed

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func update_label(text: String):
	button_label.text = text

func _on_mission_button_pressed():
	Player.play_ui_sound("bouncy_blop")
	get_tree().call_group("Main", "display_mission_info", mission_name)
