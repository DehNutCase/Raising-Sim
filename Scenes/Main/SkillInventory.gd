@tool
@icon("res://addons/gloot/images/icon_ctrl_inventory.svg")
extends CtrlInventory

func _ready() -> void:
	if (!Player.skill_inventory):
		Player.skill_inventory = Inventory.new()
		Player.skill_inventory.protoset = load("res://Constants/skill_protoset.json")
	inventory = Player.skill_inventory
	
	item_activated.connect(_on_list_item_activated)
	item_clicked.connect(_on_list_item_clicked)
	item_selected.connect(_on_list_item_selected)
	_refresh()
