extends Node2D

@onready var protoset = preload("res://Constants/item_protoset.tres")

# Called when the node enters the scene tree for the first time.
func _ready():
	update_buttons()

func update_buttons():
	var i = 0
	for node in get_children():
		remove_child(node)
		node.queue_free()
	var items:ItemProtoset = ItemProtoset.new()
	items.parse(protoset.json_data)
	for key in items._prototypes.keys():
		#Don't display items that aren't unlocked yet
		if "shop_flag" in items._prototypes[key] and !(items._prototypes[key].shop_flag in Player.shop_flags):
			return
		#TODO, hide unique items from shop
		var button = load("res://Scenes/UI/Actions/shop_button.tscn").instantiate()
		add_child(button)
		self.get_child(i).position = Vector2( i%5 * 200, 150 * (i/5) )
		self.get_child(i).item.prototype_id = key
		self.get_child(i).update_labels()
		i += 1
