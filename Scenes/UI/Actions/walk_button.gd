extends MarginContainer

@onready var button_label = $Button/Label
var walk_name = ""

signal pressed

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func update_label(text: String):
	button_label.text = text

func update_icon(icon: Texture2D):
	%Button.icon = icon

func _on_job_button_pressed():
	get_tree().call_group("Main", "do_walk", walk_name)
