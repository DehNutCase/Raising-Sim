extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func load_stat_bars(job = 'farmwork'):
	var stats = Constants.jobs[job]['stats'].keys()
	for i in range(len(stats)):
		var job_bar = load("res://Actions/stat_bar.tscn").instantiate()
		job_bar.stat_name = str(stats[i])
		add_child(job_bar)
		self.get_child(i).position = Vector2((i%3  * 300) + 50, 200 * int(i/3))
		self.get_child(i).stat_bar['value'] = Player.stats[job_bar.stat_name]
		if 'max' in Constants.stats[job_bar.stat_name]:
			self.get_child(i).stat_bar.max_value = Constants.stats[job_bar.stat_name]['max']
		if 'minx' in Constants.stats[job_bar.stat_name]:
			self.get_child(i).stat_bar.min_value = Constants.stats[job_bar.stat_name]['min']
	pass # Replace with function body.

func remove_stat_bars():
	for node in self.get_children():
		node.queue_free()
