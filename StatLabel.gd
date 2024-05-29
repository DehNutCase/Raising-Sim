extends Label

var stat_name: String

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func display_stats(player):
	text = "Stats:\n"
	for stat in player.display_stats:
		text += Constants.stats[stat]['label'] + ': ' + str(player.stats[stat]) + '\n'
