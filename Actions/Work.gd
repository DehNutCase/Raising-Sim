extends Node2D

var jobs = Constants.jobs

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(len(jobs.keys())):
		var button = load("res://Actions/job_button.tscn").instantiate()
		add_child(button)
		self.get_child(i).position = Vector2(i * 200, 0)
		self.get_child(i).update_label(jobs.keys()[i])
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
