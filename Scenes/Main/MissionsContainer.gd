extends TabContainer

var missions = Constants.missions

# Called when the node enters the scene tree for the first time.
func _ready():
	visibility_changed.connect(call_deferred.bind("update_buttons"))
	
#TODO, finish this---copied from class button rn
func update_buttons():
	for tab in get_children():
		var i = 0
		for button in tab.get_children():
			tab.remove_child(button)
			button.queue_free()
			
		for mission in missions.keys():
			#don't add mission if it's not unlocked or not the type's type
			if missions[mission].get("type") != tab.name or !Player.unlocked_missions.get(mission):
				continue
			var button = load("res://Scenes/UI/Actions/mission_button.tscn").instantiate()
			tab.add_child(button)
			tab.get_child(i).mission_name = mission
			if "label" in missions[mission]:
				tab.get_child(i).update_label(missions[mission].label)
			else:
				tab.get_child(i).update_label(mission)
			i += 1
