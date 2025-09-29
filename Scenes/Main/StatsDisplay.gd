extends HBoxContainer

var text: String
@onready var label = $Stats

func _ready() -> void:
	visibility_changed.connect(call_deferred.bind("display_stats"))
#TODO, make the parent not disable tabs until class change card is read
func display_stats():
	#TODO, rework class change card
	if Player.background_inventory.get_item_with_prototype_id("class_change_card") or Player.background_inventory.get_item_with_prototype_id("class_change_card_witch"):
		get_parent().tabs_visible = true
	else:
		get_parent().tabs_visible = false
		
	#TODO, rewrite this via table and cell [table={number}]{cells}[/table]
	#[cell padding=32,0,32,0]{text}[/cell]
	var font_size = Config.get_config("CustomSettings", "FontSize")
	text = "[table=2][cell padding=32,0,32,0]Stats:[/cell][cell padding=32,0,32,0][/cell]"
	for stat in Player.display_stats:
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
	text += "[/table]"
	label.clear()
	label.append_text(text)
