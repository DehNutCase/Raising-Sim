extends Node2D
var cubism_model: GDCubismUserModel
var last_motion = { "group": "Idle", "no": 0 }
var motion_dict: Dictionary = {}
var content_motion = { "group": "Idle", "no": 0 }
var happy_motion = { "group": "", "no": 5 }


# Called when the node enters the scene tree for the first time.
func _ready():
	cubism_model = $PlayerSprite/PlayerModel
	var dict_motion = cubism_model.get_motions()
	cubism_model.motion_finished.connect(_on_motion_finished)
	for k in dict_motion:
		for v in range(dict_motion[k]):
			motion_dict["{0}_{1}".format([k, v])] = {"group": k, "no": v}
	
	
func _on_motion_finished():
	await get_tree().create_timer(RandomNumberGenerator.new().randi_range(5,10)).timeout
	cubism_model.start_motion(
		last_motion.group,
		last_motion.no,
		GDCubismUserModel.PRIORITY_FORCE
	)

func start_motion(motion):
	cubism_model.start_motion(motion.group, motion.no, GDCubismUserModel.PRIORITY_FORCE)
