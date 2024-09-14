extends Node2D

@onready var protoset = preload("res://Constants/item_protoset.tres")

# Called when the node enters the scene tree for the first time.
func _ready():
	var items:ItemProtoset = ItemProtoset.new()
	items.parse(protoset.json_data)
	for i in range(len(items._prototypes.keys())):
		var button = load("res://Scenes/UI/Actions/shop_button.tscn").instantiate()
		add_child(button)
		self.get_child(i).position = Vector2( i%5 * 200, 150 * (i/5) )
		self.get_child(i).item.prototype_id = items._prototypes.keys()[i]
		self.get_child(i).update_labels()
	pass # Replace with function body.
