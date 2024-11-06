extends DialogicPortrait

@onready var texture = get_node('PlayerSprite')
@onready var model = get_node('PlayerSprite/PlayerModel')
@onready var visibility_checker = $VisibleOnScreenNotifier2D
var frame = 0
var delta_sum = 0
var frames_to_skip = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	set_meta('texture_holder_node', texture)
	var node = get_meta('texture_holder_node')
	#Due to the way dialogic works and issues with godot editor handling the camera, it's simpler
	#To comment out the next line if you need to work on this scene
	texture.position = Vector2(model.get_viewport().size) * Vector2(-0.5, -1)
	model.motion_finished.connect(_on_motion_finished)
	_on_motion_finished()

func _process(delta):
	if !visibility_checker.is_on_screen():
		return
	if Player.live2d_mode == Player.live2d_modes.LIVE2D:
		frame += 1
		delta_sum += delta
		if frame >= frames_to_skip:
			model.advance(delta_sum)
			if Engine.get_frames_per_second() > 50:
				frames_to_skip = max(1, frames_to_skip - 1)
			elif Engine.get_frames_per_second() < 10:
				frames_to_skip = min(10, frames_to_skip + 1)
			delta_sum = 0
			frame = 0
			
func _get_covered_rect() -> Rect2:
	if has_meta('texture_holder_node') and get_meta('texture_holder_node', null) != null and is_instance_valid(get_meta('texture_holder_node')):
		var node: Node = get_meta('texture_holder_node')
		if node is Sprite2D:
			return Rect2(texture.position, model.get_viewport().size)
	return Rect2()

func _on_motion_finished():
	await get_tree().create_timer(RandomNumberGenerator.new().randi_range(0, 10)).timeout
	model.start_motion("Idle", 0, GDCubismUserModel.PRIORITY_FORCE)
