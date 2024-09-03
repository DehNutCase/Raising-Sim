extends MarginContainer

@onready var button_label = $Button/Label

signal pressed

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func update_label(text: String = button_label.text):
	button_label.text = text
	
func update_difficulty_color():
	var success = min(1, (max(0, get_success_chance()/100.0)))
	modulate = Color(1,success,success)

func get_success_chance(job = button_label.text):
	var task = Constants.jobs[job]
	var task_total_stats = 1
	var adjusted_stats = 1
	for stat in task.required_stats:
		task_total_stats += task.required_stats[stat]
		if Player.stats[stat] >= task.required_stats[stat]:
			adjusted_stats += (Player.stats[stat] - task.required_stats[stat])/2
		else:
			adjusted_stats += Player.stats[stat] - task.required_stats[stat]
	task_total_stats += task.proficiency
	if (job in Player.proficiencies):
		adjusted_stats += Player.proficiencies[job]
	else:
		Player.proficiencies[job] = 0
	
	return 100.0 * adjusted_stats / task_total_stats - task['difficulty'] - Player.stats['stress']
	
func _on_job_button_pressed():
	get_tree().call_group("Main", "do_job", button_label.text)
	pass # Replace with function body.
