extends Control

@onready var protoset:JSON = preload("res://Constants/item_protoset.json")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func update_buttons():
	for node in get_children():
		remove_child(node)
		node.queue_free()
	var items = protoset.data
	
	for id in items.keys():
		var item_data = items[id]
		#Don't display items that aren't unlocked yet
		if "shop_flag" in item_data and !(item_data.shop_flag in Player.shop_flags):
			continue
		if "limit" in item_data:
			var amount_item = len(Player.inventory.get_items_with_prototype_id(id))
			if amount_item >= item_data.limit:
				continue
		var button = load("res://Scenes/UI/Actions/shop_button.tscn").instantiate()
		add_child(button)
		button.item = InventoryItem.new(protoset, id)
		button.update_labels()
