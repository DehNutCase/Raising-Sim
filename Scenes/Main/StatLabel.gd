extends Label

var stat_name: String

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func display_stats():
	text = "Stats:\n"
	for stat in Player.display_stats:
		var label = stat
		if ("label" in Constants.stats[stat]):
			label = Constants.stats[stat]["label"]
		if ("emoji" in Constants.stats[stat]):
			label += " (" + Constants.stats[stat].emoji + ")"
		text += label + ": " + str(Player.stats[stat]) + "\n"
