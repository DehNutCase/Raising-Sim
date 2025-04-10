extends RichTextLabel

func display_stats(metadata: Variant):
	#format metadata {"course_name": course_name, "lesson_name": lesson_name}
	var course_name = metadata.course_name
	var lesson_name = metadata.lesson_name
	clear()
	if Constants.courses.get(course_name):
		var course_daily_stats = Constants.courses[course_name][lesson_name].stats
		var rng = RandomNumberGenerator.new()
		var tooltip = ""
		if (!course_daily_stats.keys().is_empty()):
			tooltip += "Daily Stats:"
			for stat in course_daily_stats.keys():
				tooltip += " "
				if (course_daily_stats[stat] > 0):
					tooltip += "+"
				tooltip += str(course_daily_stats[stat]) + " " + Constants.stats[stat].label
		add_text(tooltip)
