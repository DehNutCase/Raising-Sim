extends Node2D

@onready var texture = $TextureRect
@onready var button = $Button
@onready var item: InventoryItem = InventoryItem.new()

func _ready():
	update_labels()
	
var tooltip:
	get: 
		return texture.tooltip_text
	set(value):
		texture.tooltip_text = value
	
func _on_button_pressed():
	get_tree().call_group("Main", "buy_item", item.get_prototype()._id, item.get_property("price"))

func update_labels():
	texture.texture = item.get_texture();
	button.text = "Buy: " + str(item.get_property("price", 0))
	tooltip = item.get_property("name", "")
	if tooltip: tooltip += "\n"
	tooltip += item.get_property("description", "tooltip error")

	var daily_stats:Dictionary = item.get_property("daily_stats", {})
	if (!daily_stats.keys().is_empty()):
		tooltip += "\nDaily Stats:"
		for stat in daily_stats.keys():
			tooltip += " "
			if (daily_stats[stat] > 0):
				tooltip += "+"
			tooltip += str(daily_stats[stat]) + " " + Constants.stats[stat].label
	
	var max_stats:Dictionary = item.get_property("max_stats", {})
	if (!max_stats.keys().is_empty()):
		tooltip += "\nMax Stats:"
		for stat in max_stats.keys():
			tooltip += " "
			if (max_stats[stat] > 0):
				tooltip += "+"
			tooltip += str(max_stats[stat]) + " " + Constants.stats[stat].label
	
	var min_stats:Dictionary = item.get_property("min_stats", {})
	if (!min_stats.keys().is_empty()):
		tooltip += "\nMin Stats:"
		for stat in min_stats.keys():
			tooltip += " "
			if (min_stats[stat] > 0):
				tooltip += "+"
			tooltip += str(min_stats[stat]) + " " + Constants.stats[stat].label
	
	var stats:Dictionary = item.get_property("stats", {})
	if (!stats.keys().is_empty()):
		tooltip += "\nStats:"
		for stat in stats.keys():
			tooltip += " "
			if (stats[stat] > 0):
				tooltip += "+"
			tooltip += str(stats[stat]) + " " + Constants.stats[stat].label
			
	var monthly_stats:Dictionary = item.get_property("monthly_stats", {})
	if (!monthly_stats.keys().is_empty()):
		tooltip += "\nMonthly Stats:"
		for stat in monthly_stats.keys():
			tooltip += " "
			if (monthly_stats[stat] > 0):
				tooltip += "+"
			tooltip += str(monthly_stats[stat]) + " " + Constants.stats[stat].label

#Display tooltip as a toast for mobile
func _on_texture_rect_gui_input(event):
	if OS.has_feature("mobile"):
		if event is InputEventMouseButton and event.pressed:
			ToastParty.show({
				"text": tooltip,
				"gravity": "bottom",
				"direction": "center",
			})
