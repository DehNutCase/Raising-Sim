extends Control

@onready var play_ending_button = %PlayEndingButton
@onready var ending_text:RichTextLabel = %EndingText

var ending = ""
var score = 0

func _ready() -> void:
	update_display()
	visibility_changed.connect(update_display)

func update_display() -> void:
	var calculated_ending: Array = await Player.calculate_ending()
	ending = calculated_ending[2]
	score = calculated_ending[0]
	
	var ending_info = Constants.endings[ending]
	
	ending_text.clear()
	ending_text.append_text("Your current ending is: %s\n\nYour current score is: %d" %[ending_info.label, score])
	
	var description = Constants.endings[ending].get("description")
	if description:
		ending_text.append_text("\n\n" + description)
	
	if Player.new_game_plus_bonuses:
		var text = "\n\n[table=3][cell padding=0,0,64,0]New Game Bonus Stats:[/cell][cell padding=0,0,64,0][/cell][cell padding=0,0,64,0][/cell]"
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
				text += "[cell padding=0,0,64,0]" + label + ": " + str(stats[stat])
			else:
				text += "[cell padding=0,0,64,0]" + label + ": " + str(stats[stat]) + "[/cell]"
		
		text += "[/table]"
		ending_text.append_text(text)

func _on_play_ending_button_pressed():
	get_tree().call_group("Main", "_on_play_ending_button_pressed")
