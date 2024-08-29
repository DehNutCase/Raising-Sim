extends DialogicPortrait

@onready var texture = get_node('PlayerSprite')
@onready var model = get_node('PlayerSprite/PlayerModel')

# Called when the node enters the scene tree for the first time.
func _ready():
	set_meta('texture_holder_node', texture)
	var node = get_meta('texture_holder_node')
	#For dev work only, remove this line and add assets to node when building
	model.assets = 'res://addons/gd_cubism/example/res/live2d/mao_pro_en/runtime/mao_pro.model3.json'
	#Due to the way dialogic works and issues with godot editor handling the camera, it's simpler
	#To comment out the next line if you need to work on this scene
	texture.position = Vector2(model.get_viewport().size) * Vector2(-0.5, -1)

func _get_covered_rect() -> Rect2:
	if has_meta('texture_holder_node') and get_meta('texture_holder_node', null) != null and is_instance_valid(get_meta('texture_holder_node')):
		var node: Node = get_meta('texture_holder_node')
		if node is Sprite2D:
			return Rect2(texture.position, model.get_viewport().size)
	return Rect2()
