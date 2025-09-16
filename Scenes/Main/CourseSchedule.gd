extends ItemList

func _ready():
	display_courses()
	visibility_changed.connect(update_buttons)

#Need to use item_count and manually iterate through list to search
#TODO, add tooltip and current progress
func add_course(course_name:String, lesson_name:String):
	#Moves course to front if already in list
	for i in range(item_count):
		if lesson_name == get_item_text(i):
			#remove course if it's already in the front
			if i == 0:
				remove_item(0)
			else:
				move_item(i, 0)
			if item_count:
				get_tree().call_group("CourseDetails", "display_stats", get_item_metadata(0))
			var list = []
			for j in range(item_count):
				list.append(get_item_metadata(j))
			Player.course_list = list
			return
	#otherwise add course to front of list
	add_item(lesson_name)
	set_item_metadata(item_count-1, {"course_name": course_name, "lesson_name": lesson_name})
	move_item(item_count-1, 0)
	get_tree().call_group("CourseDetails", "display_stats", get_item_metadata(0))
	var list = []
	for j in range(item_count):
		list.append(get_item_metadata(j))
	Player.course_list = list
	display_courses()

func display_courses():
	clear()
	#format metadata {"course_name": course_name, "lesson_name": lesson_name}
	for course in Player.course_list:
		var icon = null
		var course_name = course.course_name
		var lesson_name = course.lesson_name
		if Constants.courses[course_name][lesson_name].get("icon"):
			icon = load(Constants.courses[course_name][lesson_name].get("icon"))
		add_item(course.lesson_name, icon)
		set_item_metadata(item_count-1, course)
		
		var desc = Constants.courses[course_name][lesson_name].get("description")
		var tooltip = lesson_name
		if desc:
			tooltip += "\n\n" + desc
		set_item_tooltip(item_count-1, tooltip)
	if item_count:
		get_tree().call_group("CourseDetails", "display_stats", get_item_metadata(0))

func update_buttons():
	display_courses()

func display_stats():
	display_courses()
	
func _make_custom_tooltip(for_text):
	return Player.make_custom_tooltip(for_text)
