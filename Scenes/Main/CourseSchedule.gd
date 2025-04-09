extends ItemList

func _ready():
	display_courses()

#Need to use item_count and manually iterate through list to search
#TODO, add tooltip and current progress
func add_course(course_name:String, lesson_name:String):
	#Moves course to front if already in list
	for i in range(item_count):
		if lesson_name == get_item_text(i):
			move_item(i, 0)
			get_tree().call_group("CourseDetails", "update_text", get_item_metadata(0))
			var list = []
			for j in range(item_count):
				list.append(get_item_metadata(j))
			Player.course_list = list
			return
	#otherwise add course to front of list
	add_item(lesson_name)
	set_item_metadata(item_count-1, {"course_name": course_name, "lesson_name": lesson_name})
	move_item(item_count-1, 0)
	get_tree().call_group("CourseDetails", "update_text", get_item_metadata(0))
	var list = []
	for j in range(item_count):
		list.append(get_item_metadata(j))
	Player.course_list = list

func display_courses():
	clear()
	#format metadata {"course_name": course_name, "lesson_name": lesson_name}
	for course in Player.course_list:
		add_item(course.lesson_name)
		set_item_metadata(item_count-1, course)
	if item_count:
		get_tree().call_group("CourseDetails", "update_text", get_item_metadata(0))

func update_buttons():
	display_courses()
