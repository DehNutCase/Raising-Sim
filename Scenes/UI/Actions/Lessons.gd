extends Node2D

var lessons = Constants.lessons

# Called when the node enters the scene tree for the first time.
func _ready():
	update_buttons()
	
func update_buttons():
	var i = 0
	for node in get_children():
		remove_child(node)
		node.queue_free()
	for key in lessons.keys():
		#Don't display lessons that aren't unlocked yet
		if "lesson_flag" in lessons[key] and !(lessons[key].lesson_flag in Player.lesson_flags):
			return
		var button = load("res://Scenes/UI/Actions/lesson_button.tscn").instantiate()
		add_child(button)
		self.get_child(i).position = Vector2( i%5 * 200, 100 * (i/5) )
		self.get_child(i).lesson_name = key
		if "label" in lessons[key]:
			self.get_child(i).update_label(lessons[key].label)
		else:
			self.get_child(i).update_label(key)
		i += 1
