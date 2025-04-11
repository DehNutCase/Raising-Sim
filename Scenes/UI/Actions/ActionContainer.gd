extends GridContainer

var actions
var action_type = "job"
var button_scene = "res://Scenes/UI/Actions/action_button.tscn"

func _ready():
	actions = Constants[action_type]
	update_buttons()
	
func update_buttons():
	var i = 0
	for node in get_children():
		remove_child(node)
		node.queue_free()
	for action in actions.keys():
		var button: ActionButton = load(button_scene).instantiate()
		add_child(button)
		button.action_name = action
		button.action_type = action_type
		if "label" in actions[action]:
			button.update_label(actions[action].label)
		else:
			button.update_label(action)
		i += 1
	
