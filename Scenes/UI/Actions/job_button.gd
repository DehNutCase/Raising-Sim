class_name JobButton
extends MarginContainer

@onready var button_label = $Button/Label
var job_name = ""

signal pressed

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func update_label(text: String = button_label.text):
	button_label.text = text
	update_difficulty_color()
	
func update_difficulty_color():
	var success = min(1, (max(0, get_success_chance(job_name)/100.0)))
	modulate = Color(1,success,success)

static func get_success_chance(name):
	var task = Constants.jobs[name]
	var task_total_stats = 1
	var adjusted_stats = 1
	for stat in task.required_stats:
		task_total_stats += task.required_stats[stat]
		if Player.stats[stat] >= task.required_stats[stat]:
			adjusted_stats += (Player.stats[stat] - task.required_stats[stat])/2
		else:
			adjusted_stats += Player.stats[stat] - task.required_stats[stat]
	task_total_stats += task.proficiency
	if (name in Player.proficiencies):
		adjusted_stats += Player.proficiencies[name]
	else:
		Player.proficiencies[name] = 0
		
	return 100.0 * adjusted_stats / task_total_stats - task["difficulty"] - Player.stats["stress"]
	
func _on_job_button_pressed():
	get_tree().call_group("Main", "do_job", job_name)
