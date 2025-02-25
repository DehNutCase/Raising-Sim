@tool
@icon("res://addons/gloot/images/icon_ctrl_inventory.svg")
extends CtrlInventory

func _ready() -> void:
	if (!Player.inventory):
		Player.inventory = Inventory.new()
		Player.inventory.protoset = load("res://Constants/item_protoset.json")
	inventory = Player.inventory
	
	item_activated.connect(_on_list_item_activated)
	item_clicked.connect(_on_list_item_clicked)
	item_selected.connect(_on_list_item_selected)
	_refresh()
