@icon("res://addons/gloot/images/icon_ctrl_inventory.svg")
class_name CtrlInventory
extends Control
#Modified version of CtrlInventory to handle tooltips

signal inventory_item_activated(item)
signal inventory_item_context_activated(item)

@export var inventory_path: NodePath :
	set(new_inv_path):
		inventory_path = new_inv_path
		var node: Node = get_node_or_null(inventory_path)

		if node == null:
			return

		if is_inside_tree():
			assert(node is Inventory)
			
		inventory = node
		update_configuration_warnings()


@export var default_item_icon: Texture2D
var inventory: Inventory = null :
	set(new_inventory):
		if new_inventory == inventory:
			return
	
		_disconnect_inventory_signals()
		inventory = new_inventory
		_connect_inventory_signals()

		_queue_refresh()
var _vbox_container: VBoxContainer
var _item_list: ItemList
var _refresh_queued: bool = false

const KEY_IMAGE = "image"
const KEY_NAME = "name"


func _get_configuration_warnings() -> PackedStringArray:
	if inventory_path.is_empty():
		return PackedStringArray([
				"This node is not linked to an inventory, so it can't display any content.\n" + \
				"Set the inventory_path property to point to an Inventory node."])
	return PackedStringArray()


func _ready():
	if Engine.is_editor_hint():
		# Clean up, in case it is duplicated in the editor
		if is_instance_valid(_vbox_container):
			_vbox_container.queue_free()

	_vbox_container = VBoxContainer.new()
	_vbox_container.size_flags_horizontal = SIZE_EXPAND_FILL
	_vbox_container.size_flags_vertical = SIZE_EXPAND_FILL
	_vbox_container.anchor_right = 1.0
	_vbox_container.anchor_bottom = 1.0
	add_child(_vbox_container)

	_item_list = ItemList.new()
	_item_list.size_flags_horizontal = SIZE_EXPAND_FILL
	_item_list.size_flags_vertical = SIZE_EXPAND_FILL
	_item_list.item_activated.connect(_on_list_item_activated)
	_item_list.item_clicked.connect(_on_list_item_clicked)
	_vbox_container.add_child(_item_list)

	if has_node(inventory_path):
		inventory = get_node(inventory_path)

	_queue_refresh()


func _connect_inventory_signals() -> void:
	if !is_instance_valid(inventory):
		return

	if !inventory.contents_changed.is_connected(_queue_refresh):
		inventory.contents_changed.connect(_queue_refresh)
	if !inventory.item_modified.is_connected(_on_item_modified):
		inventory.item_modified.connect(_on_item_modified)


func _disconnect_inventory_signals() -> void:
	if !is_instance_valid(inventory):
		return

	if inventory.contents_changed.is_connected(_queue_refresh):
		inventory.contents_changed.disconnect(_queue_refresh)
	if inventory.item_modified.is_connected(_on_item_modified):
		inventory.item_modified.disconnect(_on_item_modified)


func _on_list_item_activated(index: int) -> void:
	inventory_item_activated.emit(_get_inventory_item(index))


func _on_list_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	#if mouse_button_index == MOUSE_BUTTON_RIGHT:
		#inventory_item_context_activated.emit(_get_inventory_item(index))
	#Modified to emit tooltip when item is clicked
	inventory_item_context_activated.emit(_item_list.get_item_tooltip(index))


func _on_item_modified(_item: InventoryItem) -> void:
	_queue_refresh()


func _process(_delta) -> void:
	if _refresh_queued:
		_refresh()
		_refresh_queued = false


func _queue_refresh() -> void:
	_refresh_queued = true


func _refresh() -> void:
	if is_inside_tree():
		_clear_list()
		_populate_list()


func _clear_list() -> void:
	if is_instance_valid(_item_list):
		_item_list.clear()


func _populate_list() -> void:
	if !is_instance_valid(inventory):
		return

	for item in inventory.get_items():
		var texture := item.get_texture()
		if !texture:
			texture = default_item_icon
		_item_list.add_item(_get_item_title(item), texture)
		_item_list.set_item_metadata(_item_list.get_item_count() - 1, item)
		
		var tooltip = item.get_property("description", "Tooltip Error")
		var daily_stats:Dictionary = item.get_property("daily_stats", {})
		if (!daily_stats.keys().is_empty()):
			tooltip += "\nDaily Stats:"
			for stat in daily_stats.keys():
				tooltip += " "
				if (daily_stats[stat] > 0):
					tooltip += "+"
				tooltip += str(daily_stats[stat]) + " " + Constants.stats[stat].label
		
		var stats:Dictionary = item.get_property("stats", {})
		if (!stats.keys().is_empty()):
			tooltip += "\nStats:"
			for stat in stats.keys():
				tooltip += " "
				if (stats[stat] > 0):
					tooltip += "+"
				tooltip += str(stats[stat]) + " " + Constants.stats[stat].label
				
		var monthly_stats:Dictionary = item.get_property("monthly_stats", {})
		if (!monthly_stats.keys().is_empty()):
			tooltip += "\nMonthly Stats:"
			for stat in monthly_stats.keys():
				tooltip += " "
				if (monthly_stats[stat] > 0):
					tooltip += "+"
				tooltip += str(monthly_stats[stat]) + " " + Constants.stats[stat].label

		var level_up_stats:Dictionary = item.get_property("level_up_stats", {})
		if (!level_up_stats.keys().is_empty()):
			tooltip += "\nLevel Up Stats:"
			for stat in level_up_stats.keys():
				tooltip += " "
				if (level_up_stats[stat] > 0):
					tooltip += "+"
				tooltip += str(level_up_stats[stat]) + " " + Constants.stats[stat].label
		
		_item_list.set_item_tooltip(_item_list.get_item_count() - 1, tooltip)
		

func _get_item_title(item: InventoryItem) -> String:
	if item == null:
		return ""

	var title = item.get_title()
	var stack_size: int = InventoryStacked.get_item_stack_size(item)
	if stack_size > 1:
		title = "%s (x%d)" % [title, stack_size]

	return title


func get_selected_inventory_item() -> InventoryItem:
	if _item_list.get_selected_items().is_empty():
		return null

	return _get_inventory_item(_item_list.get_selected_items()[0])


func _get_inventory_item(index: int) -> InventoryItem:
	assert(index >= 0)
	assert(index < _item_list.get_item_count())

	return _item_list.get_item_metadata(index)


func deselect_inventory_item() -> void:
	_item_list.deselect_all()


func select_inventory_item(item: InventoryItem) -> void:
	_item_list.deselect_all()
	for index in _item_list.item_count:
		if _item_list.get_item_metadata(index) != item:
			continue
		_item_list.select(index)
		return

