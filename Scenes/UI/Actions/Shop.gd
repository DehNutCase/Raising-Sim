extends Control

@onready var protoset:JSON = preload("res://Constants/item_protoset.json")

var SHOP_COLUMN_COUNT = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	update_buttons()

func update_buttons():
	var i = 0
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
		self.get_child(i).position = Vector2( i%SHOP_COLUMN_COUNT * 200 + 80, 220 * (i/SHOP_COLUMN_COUNT) )
		self.get_child(i).item = InventoryItem.new(protoset, id)
		self.get_child(i).update_labels()
		i += 1
		

	#Force minimum size to add scrolling for shop when items overflow
	var row_count = i/SHOP_COLUMN_COUNT
	if i%SHOP_COLUMN_COUNT:
		row_count += 1
	custom_minimum_size = Vector2(0, row_count* 220)
	
