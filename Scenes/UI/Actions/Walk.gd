extends Node2D

var locations = Constants.locations

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(len(locations.keys())):
		var button = load("res://Scenes/UI/Actions/walk_button.tscn").instantiate()
		add_child(button)
		self.get_child(i).position = Vector2( i%5 * 200, 100 * (i/5) )
		self.get_child(i).update_label(locations.keys()[i])
	pass # Replace with function body.
