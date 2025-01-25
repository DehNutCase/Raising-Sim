extends MarginContainer

@onready var button_label = $Button/Label
var player_class_name = ""

signal pressed

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func update_label(text: String):
	button_label.text = text

func _on_job_button_pressed():
	get_tree().call_group("Main", "display_player_class_info", player_class_name)
