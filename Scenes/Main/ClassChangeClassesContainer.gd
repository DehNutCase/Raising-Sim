extends TabContainer

var player_classes = Constants.player_classes

# Called when the node enters the scene tree for the first time.
func _ready():
	update_buttons()
	
func update_buttons():
	for tab in get_children():
		var i = 0
		for button in tab.get_children():
			remove_child(button)
			button.queue_free()
			
		for player_class in player_classes.keys():
			if player_classes[player_class].get("type") != tab.name:
				print(player_classes[player_class])
				print(player_classes[player_class].get("type"))
				continue
			print(player_classes[player_class])
			print(player_classes[player_class].get("type"))
			print("hello")
			var button = load("res://Scenes/UI/Actions/player_class_button.tscn").instantiate()
			tab.add_child(button)
			print(tab.get_child(i).get_children())
			print("buttons")
			tab.get_child(i).position = Vector2( i%5 * 200, 100 * (i/5) )
			tab.get_child(i).player_class_name = player_class
			if "label" in player_classes[player_class]:
				tab.get_child(i).update_label(player_classes[player_class].label)
			else:
				tab.get_child(i).update_label(player_class)
			i += 1
