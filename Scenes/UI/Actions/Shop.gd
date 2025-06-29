extends Control

@onready var protoset:JSON = preload("res://Constants/item_protoset.json")

# Called when the node enters the scene tree for the first time.
func _ready():
	visibility_changed.connect(update_buttons)

func update_buttons():
	for node in get_children():
		remove_child(node)
		node.queue_free()
	var items = protoset.data
	
	for id in items.keys():
		var item_data = items[id]
		#Don't display items that aren't unlocked yet
		if "courses_completed" in item_data and !(item_data.courses_completed in Player.courses_completed):
			continue

		if "limit" in item_data:
			var amount_item = len(Player.inventory.get_items_with_prototype_id(id))
			if amount_item >= item_data.limit:
				continue
		var button = load("res://Scenes/UI/Actions/shop_button.tscn").instantiate()
		add_child(button)
		button.item = InventoryItem.new(protoset, id)
		button.update_labels()
