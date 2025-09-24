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
		
func display_default_text():
	clear()
	var tooltip = "This is where you set your schedule for the day. Some actions are mandatory and will be done first, but you can freely adjust the rest of your schedule."
	append_text(tooltip)
