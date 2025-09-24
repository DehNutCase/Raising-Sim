extends MarginContainer

var text: String
@onready var label = $Stats

func _ready() -> void:
	visibility_changed.connect(display_stats)
	
func display_stats():
	label.clear()
	text = "[table=2][cell padding=32,0,32,0]Starting Bonus Stats:[/cell][cell padding=32,0,32,0][/cell][cell padding=32,0,32,0][/cell][cell padding=32,0,32,0][/cell][cell padding=32,0,32,0][/cell][cell padding=32,0,32,0][/cell]"
	var font_size = Config.get_config("CustomSettings", "FontSize")
	
	var stats = Player.new_game_plus_bonuses.get("stats", {})
	for stat in stats:
		var label = stat
		if ("label" in Constants.stats[stat]):
			label = Constants.stats[stat]["label"]
		if ("emoji" in Constants.stats[stat]) and !("icon" in Constants.stats[stat]):
			label += " (" + Constants.stats[stat].emoji + ")"
		if ("icon" in Constants.stats[stat]):
			label += " ([img=" + str(font_size) + "]" + Constants.stats[stat].icon + "[/img])"
		if stat == "experience":
			text += "[cell padding=32,0,32,0]" + label + ": " + str(stats[stat])
		else:
			text += "[cell padding=32,0,32,0]" + label + ": " + str(stats[stat]) + "[/cell]"
	
	text += "[/table]\n"
	label.append_text(text)
