extends Label

var stat_name: String

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func display_gold():
	text = ""
	if ('gold' in Player.display_stats):
		var label = 'gold'
		if ('label' in Constants.stats.gold):
			label = Constants.stats.gold['label']
		if ('emoji' in Constants.stats.gold):
			label += " (" + Constants.stats.gold.emoji + ")"
		text += label + ': ' + str(Player.stats.gold) + '\n'
