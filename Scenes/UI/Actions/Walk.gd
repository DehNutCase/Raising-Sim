extends GridContainer

var locations = Constants.locations

var is_updating := false
# Called when the node enters the scene tree for the first time.
func _ready():
	visibility_changed.connect(call_deferred.bind("update_buttons"))

func update_buttons():
	if is_updating:
		return
	else:
		is_updating = true
	var current_children = {}
	for node in get_children():
		if node.walk_name in current_children:
			current_children[node.walk_name].append(node)
		else:
			current_children[node.walk_name] = [node]
	
	for key in locations.keys():
		#Don't display locations that aren't unlocked yet
		var to_show = true
		if "location_flag" in locations[key] and !(locations[key].location_flag in Player.location_flags):
			to_show = false
		if "day" in locations[key] and !(Player.day == locations[key].day):
			to_show = false
		
		if !to_show:
			if key in current_children.keys():
				for node in current_children[key]:
					node.queue_free()
				current_children.erase(key)
			continue
		
		
		if key in current_children:
			continue
		var button = load("res://Scenes/UI/Actions/walk_button.tscn").instantiate()
		Player.background_thread.start(self.call_deferred.bind("add_child", button))
		await Player.background_thread.wait_to_finish()
		if !button.is_node_ready():
			await button.ready

		button.walk_name = key
		if 'day' in locations[key]:
			button.day = locations[key].day
		if "label" in locations[key]:
			button.update_label(locations[key].label)
		else:
			button.update_label(key)
		if "icon" in locations[key]:
			button.update_icon(load(locations[key].icon))
		current_children[key] = [button]
	is_updating = false
