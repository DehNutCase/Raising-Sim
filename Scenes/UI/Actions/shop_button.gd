extends Control

@onready var texture = $TextureRect
@onready var button = $Button
@onready var item: InventoryItem = InventoryItem.new()

func _ready():
	update_labels()

#var tooltip:
	#get: 
		#return texture.tooltip_text
	#set(value):
		#texture.tooltip_text = value
	
func _on_button_pressed():
	Player.play_ui_sound("bouncy_blop")
	get_tree().call_group("Main", "buy_item", item.get_prototype()._id, item.get_property("price"))

func update_labels():
	texture.texture = item.get_texture();
	button.text = "Buy: " + str(item.get_property("price", 0))
	tooltip_text = item.get_property("name", "")
	if tooltip_text: 
		tooltip_text += "\n"
	tooltip_text += item.get_property("description", "tooltip error")
	tooltip_text += "\n"
	
	var daily_stats:Dictionary = item.get_property("daily_stats", {})
	if (!daily_stats.keys().is_empty()):
		tooltip_text += "\nDaily Stats:"
		for stat in daily_stats.keys():
			tooltip_text += " "
			if (daily_stats[stat] > 0):
				tooltip_text += "+"
			tooltip_text += str(daily_stats[stat]) + " " + Constants.stats[stat].label
	
	var max_stats:Dictionary = item.get_property("max_stats", {})
	if (!max_stats.keys().is_empty()):
		tooltip_text += "\nMax Stats:"
		for stat in max_stats.keys():
			tooltip_text += " "
			if (max_stats[stat] > 0):
				tooltip_text += "+"
			tooltip_text += str(max_stats[stat]) + " " + Constants.stats[stat].label
	
	var min_stats:Dictionary = item.get_property("min_stats", {})
	if (!min_stats.keys().is_empty()):
		tooltip_text += "\nMin Stats:"
		for stat in min_stats.keys():
			tooltip_text += " "
			if (min_stats[stat] > 0):
				tooltip_text += "+"
			tooltip_text += str(min_stats[stat]) + " " + Constants.stats[stat].label
	
	var stats:Dictionary = item.get_property("stats", {})
	if (!stats.keys().is_empty()):
		tooltip_text += "\nStats:"
		for stat in stats.keys():
			tooltip_text += " "
			if (stats[stat] > 0):
				tooltip_text += "+"
			tooltip_text += str(stats[stat]) + " " + Constants.stats[stat].label
			
	var monthly_stats:Dictionary = item.get_property("monthly_stats", {})
	if (!monthly_stats.keys().is_empty()):
		tooltip_text += "\nMonthly Stats:"
		for stat in monthly_stats.keys():
			tooltip_text += " "
			if (monthly_stats[stat] > 0):
				tooltip_text += "+"
			tooltip_text += str(monthly_stats[stat]) + " " + Constants.stats[stat].label

#Display tooltip as a toast for mobile
func _on_texture_rect_gui_input(event):
	if OS.has_feature("mobile"):
		if event is InputEventMouseButton and event.pressed:
			ToastParty.show({
				"text": tooltip_text,
				"gravity": "bottom",
				"direction": "center",
			})

func _make_custom_tooltip(for_text):
	return Player.make_custom_tooltip(for_text)
