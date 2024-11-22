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
		var item_type = items._prototypes[key]
		#Don't display items that aren't unlocked yet
		if "shop_flag" in item_type and !(item_type.shop_flag in Player.shop_flags):
			continue
		if "limit" in item_type:
			var amount_item = len(Player.inventory.get_items_by_id(item_type.id))
			if amount_item >= item_type.limit:
				continue
		var button = load("res://Scenes/UI/Actions/shop_button.tscn").instantiate()
		add_child(button)
		self.get_child(i).position = Vector2( i%5 * 200, 150 * (i/5) )
		self.get_child(i).item.prototype_id = key
		self.get_child(i).update_labels()
		i += 1
