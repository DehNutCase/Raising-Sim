extends MarginContainer

@onready var button_label = $Button/Label
var walk_name = ""
var day:int

signal pressed

# Called when the node enters the scene tree for the first time.
func _ready():
	visibility_changed.connect(call_deferred.bind("check_requirements"))
	pass # Replace with function body.

func check_requirements() -> void:
	#Day is an requirement
	if day and !(Player.day == day):
		queue_free()
	 
func update_label(text: String):
	button_label.text = text

func update_icon(icon: Texture2D):
	%Button.icon = icon

func _on_job_button_pressed():
	Player.play_ui_sound("bouncy_blop")
	get_tree().call_group("Main", "do_walk", walk_name)
