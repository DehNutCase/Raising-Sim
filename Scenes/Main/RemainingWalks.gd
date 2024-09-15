extends Label

var stat_name: String

func display_walks():
	text = "Walks left: " + str(Player.remaining_walks)
