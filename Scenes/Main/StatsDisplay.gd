extends HBoxContainer

var text1: String
@onready var label1 = $Stats
var text2: String
@onready var label2 = $Stats2
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

#TODO, make the parent not disable tabs until class change card is read
func display_stats():
	#TODO, rework class change card
	if Player.background_inventory.get_item_with_prototype_id("class_change_card") or Player.background_inventory.get_item_with_prototype_id("class_change_card_witch"):
		get_parent().tabs_visible = true
	else:
		get_parent().tabs_visible = false
		
	text1 = "Stats:\n"
	text2 = "\n"
	var counter = 0
	for stat in Player.display_stats:
		var label = stat
		if ("label" in Constants.stats[stat]):
			label = Constants.stats[stat]["label"]
		if ("emoji" in Constants.stats[stat]):
			label += " (" + Constants.stats[stat].emoji + ")"
		if counter > 0:
			counter = 0
			if stat == "experience":
				text2 += label + ": " + str(Player.stats[stat]) + " / " + str(Player.get_required_experience(Player.stats.level - 1)) + "\n"
			else:
				text2 += label + ": " + str(Player.stats[stat]) + "\n"
		else:
			counter += 1
			if stat == "experience":
				text1 += label + ": " + str(Player.stats[stat]) + " / " + str(Player.get_required_experience(Player.stats.level - 1)) + "\n"
			else:
				text1 += label + ": " + str(Player.stats[stat]) + "\n"
	label1.text = text1
	label2.text = text2
