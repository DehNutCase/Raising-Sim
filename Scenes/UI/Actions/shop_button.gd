extends Control

@onready var texture = $TextureRect
@onready var button = $Button
@onready var item: InventoryItem = InventoryItem.new()

func _ready():
	update_labels()

#var tooltip:
	#get: 
		#return texture.tooltip_text
	#set(value):
		#texture.tooltip_text = value
	
func _on_button_pressed():
	Player.play_ui_sound("bouncy_blop")
	get_tree().call_group("Main", "buy_item", item.get_prototype()._id, item.get_property("price"))

func update_labels():
	texture.texture = item.get_texture();
	button.text = "Buy: " + str(item.get_property("price", 0))
	var item_data = {}
	for key in item.get_properties():
		item_data[key] = item.get_property(key)
	tooltip_text = Player.make_stat_tooltip(item_data)

#Display tooltip as a toast for mobile
func _on_texture_rect_gui_input(event):
	if OS.has_feature("mobile"):
		if event is InputEventMouseButton and event.pressed:
			ToastParty.show({
				"text": tooltip_text,
				"gravity": "bottom",
				"direction": "center",
			})

func _make_custom_tooltip(for_text):
	return Player.make_custom_tooltip(for_text)
