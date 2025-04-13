extends TabContainer

func _ready():
	for course in Constants.courses:
		if !Constants.courses.get(course):
			continue
			
		if !(course == Player.current_elective or course in Constants.constants.ALWAYS_ACTIVE_COURSES):
			continue
			
		var scene = load("res://Scenes/UI/Lessons/course_container.tscn").instantiate()
		scene.get_child(0).course = course
		scene.name = course
		add_child(scene)
		pass
