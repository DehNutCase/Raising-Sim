@tool
@icon("res://addons/gloot/images/icon_ctrl_inventory.svg")
extends CtrlInventory

func _ready() -> void:
	if (!Player.background_inventory):
		Player.background_inventory = Inventory.new()
		Player.background_inventory.protoset = load("res://Constants/background_protoset.json")
	inventory = Player.background_inventory
	
	item_activated.connect(_on_list_item_activated)
	item_clicked.connect(_on_list_item_clicked)
	item_selected.connect(_on_list_item_selected)
	_refresh()
