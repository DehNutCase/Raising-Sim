extends Node2D

var jobs = Constants.jobs

# Called when the node enters the scene tree for the first time.
func _ready():
	update_buttons()
	
func update_buttons():
	var i = 0
	for node in get_children():
		remove_child(node)
		node.queue_free()
	for key in jobs.keys():
		var button = load("res://Scenes/UI/Actions/job_button.tscn").instantiate()
		add_child(button)
		self.get_child(i).position = Vector2( i%5 * 200, 100 * (i/5) )
		self.get_child(i).job_name = key
		if "label" in jobs[key]:
			self.get_child(i).update_label(jobs[key].label)
		else:
			self.get_child(i).update_label(key)
		i += 1
