extends GridContainer
#TODO, add sound manager to main menu or else make perspective timelines use self contained sounds
func _ready():
	visibility_changed.connect(update_buttons)
	
#Load perspectives file here? (where to save perspectives)
#save whenever new perspective is added
func update_buttons():
	await load_perspectives()
	
	for node in get_children():
		remove_child(node)
		node.queue_free()
		
	for perspective in Constants.perspectives:
		var perspective_data = Constants.perspectives[perspective]
		var button : PerspectivesButton = load("res://Scenes/GameTemplate/Menus/Perspectives/perspectives_button.tscn").instantiate()
		add_child(button)
		button.update_label(perspective_data.label)
		button.update_icon(load(perspective_data.icon))
		button.timeline = perspective_data.timeline
		button.perspective = perspective

func load_perspectives() -> void:
	await Player.load_perspectives()
	
