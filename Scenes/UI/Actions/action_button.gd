class_name ActionButton
extends MarginContainer

@onready var button_label = $Button/Label
var action_type = "jobs"
var action_name = ""

signal pressed

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func update_label(text: String = button_label.text):
	button_label.text = text
	var task = Constants[action_type][action_name]
	if task.icon:
		%Button.icon = load(task.icon)
	update_difficulty_color()
	
func update_difficulty_color():
	var success = min(1, (max(0, get_success_chance(action_type, action_name)/100.0)))
	modulate = Color(1, success, success)

static func get_success_chance(action_type, action_name):
	#TODO, return 100 chance if action can't fail
	#TODO, check for actions with success chances, not just jobs (lessons)
	if action_type != "jobs":
		return 101
	var task = Constants[action_type][action_name]
	var task_total_stats = 1
	var adjusted_stats = 1
	for stat in task.required_stats:
		task_total_stats += task.required_stats[stat]
		if Player.stats[stat] >= task.required_stats[stat]:
			adjusted_stats += (Player.stats[stat] - task.required_stats[stat])/2
		else:
			adjusted_stats += Player.stats[stat] - task.required_stats[stat]
	task_total_stats += task.proficiency
	if (action_name in Player.proficiencies):
		adjusted_stats += Player.proficiencies[action_name]
	else:
		Player.proficiencies[action_name] = 0
		
	return 100.0 * adjusted_stats / task_total_stats - task["difficulty"] - Player.stats["stress"]
	
func _on_action_button_pressed():
	Player.play_ui_sound("bouncy_blop")
	get_tree().call_group("DailySchedule", "add_action", action_type, action_name)
