extends TabContainer

var player_classes = Constants.player_classes

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func update_buttons():
	for tab in get_children():
		var i = 0
		for button in tab.get_children():
			tab.remove_child(button)
			button.queue_free()
			
		for player_class in player_classes.keys():
			if player_classes[player_class].get("type") != tab.name:
				continue
			var button = load("res://Scenes/UI/Actions/player_class_button.tscn").instantiate()
			tab.add_child(button)
			tab.get_child(i).player_class_name = player_class
			if "label" in player_classes[player_class]:
				tab.get_child(i).update_label(player_classes[player_class].label)
			else:
				tab.get_child(i).update_label(player_class)
			i += 1
