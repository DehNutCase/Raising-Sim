extends TabContainer

func _ready():
	for action in Constants.constants.ACTION_TYPES.keys():
		var scene = load("res://Scenes/UI/Actions/action_container.tscn").instantiate()
		var action_info = Constants.constants.ACTION_TYPES[action]
		if action:
			scene.get_child(0).action_type = action_info.id
			scene.name = action_info.label
			add_child(scene)
