extends Node2D

var rests = Constants.rests

# Called when the node enters the scene tree for the first time.
func _ready():
	update_buttons()
	
func update_buttons():
	var i = 0
	for node in get_children():
		remove_child(node)
		node.queue_free()
	for key in rests.keys():
		#Don't display rests that aren't unlocked yet
		if "rest_flag" in rests[key] and !(rests[key].rest_flag in Player.rest_flags):
			continue
		var button = load("res://Scenes/UI/Actions/rest_button.tscn").instantiate()
		add_child(button)
		self.get_child(i).position = Vector2( i%5 * 200, 100 * (i/5) )
		self.get_child(i).rest_name = key
		if "label" in rests[key]:
			self.get_child(i).update_label(rests[key].label)
		else:
			self.get_child(i).update_label(key)
		i += 1
