extends Node2D

@onready var texture = $TextureRect
@onready var item = $InventoryItem
@onready var button = $Button

func _ready():
	update_labels()
	
func _on_button_pressed():
	get_tree().call_group("Main", "buy_item", item.get_property('id'), item.get_property('price'))
	pass

func update_labels():
	texture.texture = item.get_texture();
	button.text = 'Buy: ' + str(item.get_property('price', 0))
	texture.tooltip_text = item.get_property('description', 'tooltip error')
