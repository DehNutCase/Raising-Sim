extends Node2D

var locations = Constants.locations

# Called when the node enters the scene tree for the first time.
func _ready():
	update_buttons()
	
func update_buttons():
	var i = 0
	for node in get_children():
		remove_child(node)
		node.queue_free()
	for key in locations.keys():
		#Don't display locations that aren't unlocked yet
		if "location_flag" in locations[key] and !(locations[key].location_flag in Player.location_flags):
			return
		var button = load("res://Scenes/UI/Actions/walk_button.tscn").instantiate()
		add_child(button)
		self.get_child(i).position = Vector2( i%5 * 200, 100 * (i/5) )
		self.get_child(i).walk_name = key
		if "label" in locations[key]:
			self.get_child(i).update_label(locations[key].label)
		else:
			self.get_child(i).update_label(key)
		i += 1
