extends Node2D

var classes = Constants.classes

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(len(classes.keys())):
		var button = load("res://Actions/class_button.tscn").instantiate()
		add_child(button)
		self.get_child(i).position = Vector2(i * 200, 0)
		self.get_child(i).update_label(classes.keys()[i])
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
