extends RichTextLabel

var action_type = ""
var action_name = ""

func display_stats(metadata: Variant):
	#TODO, add description for all actions
	#format metadata {"action_type": action_type, "action_name": action_name}
	action_type = metadata.action_type
	action_name = metadata.action_name
	clear()
	if Constants[action_type].get(action_name):
		var desc = Constants[action_type][action_name].get("description")
		if desc: add_text(desc)
