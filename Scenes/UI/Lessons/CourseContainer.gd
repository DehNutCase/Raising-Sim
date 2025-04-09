extends GridContainer

var courses
var course = "Core"

func _ready():
	courses = Constants.courses[course]
	update_buttons()
	
func update_buttons():
	var i = 0
	for node in get_children():
		remove_child(node)
		node.queue_free()
	for key in courses.keys():
		#Don't display courses that aren't unlocked yet
		if "course_flag" in courses[key] and !(courses[key].course_flag in Player.course_flags):
			continue
		var button = load("res://Scenes/UI/Actions/course_button.tscn").instantiate()
		add_child(button)
		self.get_child(i).lesson_name = key
		self.get_child(i).course_name = course
		if "label" in courses[key]:
			self.get_child(i).update_label(courses[key].label)
		else:
			self.get_child(i).update_label(key)
		i += 1
