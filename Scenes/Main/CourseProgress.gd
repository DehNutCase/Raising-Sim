extends RichTextLabel

func display_stats(metadata: Variant):
	#format metadata {"course_name": course_name, "lesson_name": lesson_name}
	var course_name = metadata.course_name
	var lesson_name = metadata.lesson_name
	clear()
	if Constants.courses.get(course_name) and Player.course_progress.get(lesson_name):
		var course_progress_required:int = Constants.courses[course_name][lesson_name].required_progress
		var current_progress:int = Player.course_progress[lesson_name]
		var percentage:int = current_progress * 100 / course_progress_required
		var tooltip = "Current Progress: " + str(percentage) + "%"
		add_text(tooltip)
