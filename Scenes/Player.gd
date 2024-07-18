extends Node2D
var cubism_model: GDCubismUserModel
var last_motion = null
var motion_dict: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	cubism_model = $PlayerSprite/PlayerModel
	var dict_motion = cubism_model.get_motions()
	for k in dict_motion:
		for v in range(dict_motion[k]):
			motion_dict["{0}_{1}".format([k, v])] = {"group": k, "no": v}
	print(motion_dict)
	
	
func _on_motion_finished():
	cubism_model.start_motion(
		last_motion.group,
		last_motion.no,
		GDCubismUserModel.PRIORITY_FORCE
	)

func start_motion(motion):
	cubism_model.start_motion(motion.group, motion.no, GDCubismUserModel.PRIORITY_FORCE)
