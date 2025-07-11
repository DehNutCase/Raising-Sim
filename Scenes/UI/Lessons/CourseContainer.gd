extends GridContainer

var courses
var course = "Core"

func _ready():
	courses = Constants.courses[course]
	visibility_changed.connect(update_buttons)
	
func update_buttons():
	var i = 0
	for node in get_children():
		remove_child(node)
		node.queue_free()
	for lesson in courses.keys():
		#Don't display courses that are already complete
		if Player.courses_completed.get(lesson):
			continue
		
		var button = load("res://Scenes/UI/Actions/course_button.tscn").instantiate()
		add_child(button)
		self.get_child(i).lesson_name = lesson
		self.get_child(i).course_name = course
		if "label" in courses[lesson]:
			self.get_child(i).update_label(courses[lesson].label)
		else:
			self.get_child(i).update_label(lesson)
		i += 1
