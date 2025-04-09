extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func load_stat_bars(job = "farmwork", type = "jobs"):
	var stats = Constants[type][job]["stats"].keys()
	for i in range(len(stats)):
		var job_bar = load("res://Scenes/UI/Actions/stat_bar.tscn").instantiate()
		job_bar.stat_name = str(stats[i])
		add_child(job_bar)
		self.get_child(i).position = Vector2((i%3  * 300) + 50, 120 * int(i/3))
		self.get_child(i).stat_bar["value"] = Player.stats[job_bar.stat_name]
		if "max" in Constants.stats[job_bar.stat_name]:
			self.get_child(i).stat_bar.max_value = Player.calculate_max_stat(job_bar.stat_name)
		if job_bar.stat_name == "experience":
			self.get_child(i).stat_bar.max_value = Player.get_required_experience(Player.stats.level - 1)
		if "minx" in Constants.stats[job_bar.stat_name]:
			self.get_child(i).stat_bar.min_value = Player.calculate_min_stat(job_bar.stat_name)

func remove_stat_bars():
	for node in self.get_children():
		node.queue_free()
