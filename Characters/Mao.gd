extends DialogicPortrait

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _get_covered_rect() -> Rect2:
	return Rect2(10, 10, 600, 600)
