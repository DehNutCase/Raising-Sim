extends TabContainer

func _ready():
	for course in Constants.courses:
		#TODO, only add courses if flagged
		if !Constants.courses.get(course):
			return
		var scene = load("res://Scenes/UI/Lessons/lessons_container.tscn").instantiate()
		scene.get_child(0).course = course
		scene.name = course
		add_child(scene)
		pass
