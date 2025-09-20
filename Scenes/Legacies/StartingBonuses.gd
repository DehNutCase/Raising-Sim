extends MarginContainer

var text: String
@onready var label = $Stats

func _ready() -> void:
	visibility_changed.connect(display_stats)
	
func display_stats():
	text = "[table=2][cell padding=32,0,32,0]New Game Bonus Stats:[/cell][cell padding=32,0,32,0][/cell][cell padding=32,0,32,0][/cell][cell padding=32,0,32,0][/cell]"
	var font_size = Config.get_config("CustomSettings", "FontSize")
	for stat in Player.new_game_plus_bonuses.get("stats", {}):
		var label = stat
		if ("label" in Constants.stats[stat]):
			label = Constants.stats[stat]["label"]
		if ("emoji" in Constants.stats[stat]) and !("icon" in Constants.stats[stat]):
			label += " (" + Constants.stats[stat].emoji + ")"
		if ("icon" in Constants.stats[stat]):
			label += " ([img=" + str(font_size) + "]" + Constants.stats[stat].icon + "[/img])"
		if stat == "experience":
			text += "[cell padding=32,0,32,0]" + label + ": " + str(Player.stats[stat]) + " / " + str(Player.get_required_experience(Player.stats.level - 1)) + "[/cell]"
		else:
			var max = ""
			if Player.calculate_max_stat(stat):
				max = " / " + str(Player.calculate_max_stat(stat))
			text += "[cell padding=32,0,32,0]" + label + ": " + str(Player.stats[stat]) + max + "[/cell]"
	
	text += "[/table]\n"
	label.clear()
	label.append_text(text)
