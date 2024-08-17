extends Node2D
var cubism_model: GDCubismUserModel
var last_motion = { "group": "Idle", "no": 0 }
var content_motion = { "group": "Idle", "no": 0 }
var happy_motion = { "group": "", "no": 5 }
var success_motion = { "group": "", "no": 3 }
var failure_motion = { "group": "", "no": 4 }

var content_expression = "exp_01"
var happy_expression = "exp_02"
var annoyed_expression = "exp_08"

# Called when the node enters the scene tree for the first time.
func _ready():
	cubism_model = $PlayerSprite/PlayerModel
	cubism_model.motion_finished.connect(_on_motion_finished)
	
	var dict_expression = cubism_model.get_expressions()
	print(dict_expression)
	
func _on_motion_finished():
	await get_tree().create_timer(RandomNumberGenerator.new().randi_range(5,10)).timeout
	cubism_model.start_motion(
		last_motion.group,
		last_motion.no,
		GDCubismUserModel.PRIORITY_NORMAL
	)
	last_motion = content_motion

func start_motion(motion):
	cubism_model.start_motion(motion.group, motion.no, GDCubismUserModel.PRIORITY_NORMAL)

func start_expression(expression):
	cubism_model.start_expression(expression)

func job_motion(motion):
	cubism_model.start_motion(motion.group, motion.no, GDCubismUserModel.PRIORITY_FORCE)

func queue_motion(motion):
	last_motion = motion
	
