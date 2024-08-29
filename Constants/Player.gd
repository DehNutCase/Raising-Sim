extends Node2D
var cubism_model: GDCubismUserModel
var effect_breath = GDCubismEffectBreath.new()
var last_motion = { "group": "Idle", "no": 0 }
var next_motion = { "group": "Idle", "no": 0 }
var content_motion = { "group": "Idle", "no": 0 }
var idle_motion = { "group": "Idle", "no": 0 }
var happy_motion = { "group": "", "no": 5 }
var success_motion = { "group": "", "no": 3 }
var failure_motion = { "group": "", "no": 4 }

var content_expression = "exp_01"
var happy_expression = "exp_02"
var annoyed_expression = "exp_08"

# Called when the node enters the scene tree for the first time.
func _ready():
	cubism_model = $PlayerSprite/PlayerModel
	#For dev work only, remove this line and add assets to node when building
	cubism_model.assets = 'res://addons/gd_cubism/example/res/live2d/mao_pro_en/runtime/mao_pro.model3.json'
	cubism_model.motion_finished.connect(_on_motion_finished)
	effect_breath.name = "GDCubismEffectBreath"
	cubism_model.add_child(effect_breath)
	var node = GDCubismEffectEyeBlink.new()
	node.name = 'GDCubismEffectEyeBlink'
	cubism_model.add_child(node)
	
func _on_motion_finished():
	#TODO, figure out how to stop motion
	cubism_model.add_child(effect_breath)
	
	if (last_motion != content_motion):
		await get_tree().create_timer(RandomNumberGenerator.new().randi_range(1,2)).timeout
		start_motion(next_motion)
	else:
		await get_tree().create_timer(RandomNumberGenerator.new().randi_range(5, 15)).timeout
		start_motion(next_motion)
		
	#TODO, change motion based on mood
	last_motion = next_motion
	next_motion = content_motion

func start_motion(motion):
	cubism_model.remove_child(effect_breath)
	cubism_model.start_motion(motion.group, motion.no, GDCubismUserModel.PRIORITY_NORMAL)
	
	
func start_expression(expression):
	cubism_model.start_expression(expression)

func job_motion(motion):
	cubism_model.remove_child(effect_breath)
	cubism_model.start_motion(motion.group, motion.no, GDCubismUserModel.PRIORITY_FORCE)


func queue_motion(motion):
	next_motion = motion
	
