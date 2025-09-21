extends GridContainer
#TODO, add sound manager to main menu or else make perspective timelines use self contained sounds
func _ready():
	visibility_changed.connect(update_buttons)
	
#Load perspectives file here? (where to save perspectives)
#save whenever new perspective is added
func update_buttons():
	await load_perspectives()
	
	var current_children:Dictionary = {}
	for node in get_children():
		if node.perspective in current_children:
			current_children[node.perspective].append(node)
		else:
			current_children[node.perspective] = [node]
		
	for perspective in Constants.perspectives:
		if perspective in current_children:
			current_children[perspective].pop_back()
			if !current_children[perspective]:
				current_children.erase(perspective)
			continue
			
		var perspective_data = Constants.perspectives[perspective]
		var button : PerspectivesButton = load("res://Scenes/GameTemplate/Menus/Perspectives/perspectives_button.tscn").instantiate()
		add_child(button)
		button.update_label(perspective_data.label)
		button.update_icon(load(perspective_data.icon))
		button.timeline = perspective_data.timeline
		button.perspective = perspective
	
	for key in current_children.keys():
		for node in current_children[key]:
			node.queue_free()
		current_children.erase(key)
		

func load_perspectives() -> void:
	await Player.load_perspectives()
	
