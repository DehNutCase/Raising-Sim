extends Node2D
var cubism_model: GDCubismUserModel

# Called when the node enters the scene tree for the first time.
func _ready():
	cubism_model = GDCubismUserModel.new()
	$PlayerSprite.add_child(cubism_model)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
