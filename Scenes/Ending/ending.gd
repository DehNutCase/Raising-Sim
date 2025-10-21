extends Control

@onready var play_ending_button = %PlayEndingButton
@onready var ending_text:RichTextLabel = %EndingText

var ending:String = ""
var score:int = 0
var ending_list:Array = []
@onready var ending_image:Polygon2D = %EndingImage
@onready var ending_select_button:MenuButton = %EndingSelectButton
@onready var popup_menu:PopupMenu = ending_select_button.get_popup()
var is_updating := false

func _ready() -> void:
	update_display()
	visibility_changed.connect(call_deferred.bind("update_display"))
	
	popup_menu.connect("index_pressed", popup_menu_pressed)

func update_display() -> void:
	if is_updating:
		return
	else:
		is_updating = true
	var calculated_ending: Array = await Player.calculate_ending()
	ending = calculated_ending[2]
	score = calculated_ending[0]
	ending_list = calculated_ending[3]
	
	popup_menu.clear()
	for i in range(ending_list.size()):
		var ending_info = Constants.endings[ending_list[i]]
		popup_menu.add_item(ending_info.label)
		popup_menu.set_item_metadata(i, {"name": ending_list[i]})
	
	update_ending_text(ending)
	is_updating = false

func update_ending_text(ending:String):
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
		
		text += "[/table]\n\n\n\n"
		ending_text.append_text(text)
	ending_select_button.text = ending_info.label
	ending_image.texture = load(ending_info.image)

func _on_play_ending_button_pressed():
	get_tree().call_group("Main", "_on_play_ending_button_pressed", ending)

func popup_menu_pressed(id:int):
	ending = popup_menu.get_item_metadata(id).name
	update_ending_text(ending)
