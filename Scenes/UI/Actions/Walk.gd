extends GridContainer

var locations = Constants.locations
var buttons = []

# Called when the node enters the scene tree for the first time.
func _ready():
	visibility_changed.connect(update_buttons)

func update_buttons():
	for key in locations.keys():
		#Don't display locations that aren't unlocked yet
		if "location_flag" in locations[key] and !(locations[key].location_flag in Player.location_flags):
			continue
		if key in buttons:
			continue
		buttons.append(key)
		var button = load("res://Scenes/UI/Actions/walk_button.tscn").instantiate()
		add_child(button)
		button.walk_name = key
		if "label" in locations[key]:
			button.update_label(locations[key].label)
		else:
			button.update_label(key)
		if "icon" in locations[key]:
			button.update_icon(load(locations[key].icon))
