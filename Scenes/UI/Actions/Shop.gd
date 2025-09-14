extends Control

@onready var protoset:JSON = preload("res://Constants/item_protoset.json")

# Called when the node enters the scene tree for the first time.
func _ready():
	visibility_changed.connect(update_buttons)

func update_buttons():
	var current_children = {}
	for node in get_children():
		if node.item.get_title() in current_children:
			current_children[node.item.get_title()].append(node)
		else:
			current_children[node.item.get_title()] = [node]
	
	var items = protoset.data
	for id in items.keys():
		var item_data = items[id]
		var item = InventoryItem.new(protoset, id)
		
		#Don't display items that aren't unlocked yet
		if "courses_completed" in item_data and !(item_data.courses_completed in Player.courses_completed):
			if item.get_title() in current_children.keys():
				for node in current_children[item.get_title()]:
					node.queue_free()
				current_children.erase(item.get_title())
			continue

		if "limit" in item_data:
			var amount_item = len(Player.inventory.get_items_with_prototype_id(id))
			if amount_item >= item_data.limit:
				if item.get_title() in current_children.keys():
					for node in current_children[item.get_title()]:
						node.queue_free()
					current_children.erase(item.get_title())
				continue
		
		if item.get_title() in current_children:
			continue
		var button = load("res://Scenes/UI/Actions/shop_button.tscn").instantiate()
		add_child(button)
		button.item = item
		button.update_labels()
		current_children[item.get_title()] = [button]
