extends HBoxContainer

var text1: String
@onready var label1 = $Stats
var text2: String
@onready var label2 = $Stats2
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

#TODO, display stats in 2 labels
func display_stats():
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
			text2 += label + ": " + str(Player.stats[stat]) + "\n"
		else:
			counter += 1
			text1 += label + ": " + str(Player.stats[stat]) + "\n"
	label1.text = text1
	label2.text = text2
