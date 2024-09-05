@tool
@icon("res://addons/gloot/images/icon_ctrl_inventory.svg")
extends CtrlInventory

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
	
	if (!Player.background_inventory):
		Player.background_inventory = Inventory.new()
		Player.background_inventory.item_protoset = load('res://Constants/background_protoset.tres')
		Player.background_inventory.create_and_add_item("royal_backing")
	
	inventory = Player.background_inventory
