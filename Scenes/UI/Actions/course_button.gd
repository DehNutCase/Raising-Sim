class_name CourseButton
extends MarginContainer

@onready var button_label = $Button/Label
var lesson_name = ""
var course_name = ""

signal pressed

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func update_label(text: String = button_label.text):
	button_label.text = text
	var task = Constants.courses[course_name][lesson_name]
	if task.icon:
		%Button.icon = load(task.icon)
	
func _on_job_button_pressed():
	Player.play_ui_sound("bouncy_blop")
	get_tree().call_group("Main", "course_button_click", course_name, lesson_name)
