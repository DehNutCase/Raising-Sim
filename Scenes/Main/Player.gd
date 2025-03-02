extends Node2D
@onready var cubism_model: GDCubismUserModel = $PlayerSprite/PlayerModel
@onready var live2d_video_player = $Live2dVideoPlayer
var effect_breath = GDCubismEffectBreath.new()

var motion_video_queue = []
var content_motion_video = load("res://Characters/Mao/Videos/mtn_01.ogv")
var idle_motion_video = load("res://Characters/Mao/Videos/mtn_01.ogv")
var bounce_motion_video = load("res://Characters/Mao/Videos/mtn_02.ogv")
var cheerful_motion_video = load("res://Characters/Mao/Videos/mtn_03.ogv")
var hat_tip_motion_video = load("res://Characters/Mao/Videos/mtn_04.ogv")
var success_motion_video = load("res://Characters/Mao/Videos/special_01.ogv")
var failure_motion_video = load("res://Characters/Mao/Videos/special_02.ogv")
var heal_motion_video = load("res://Characters/Mao/Videos/special_03.ogv")


var content_motion = { "group": "Idle", "no": 0, "video": content_motion_video, "weight": 10, }
var idle_motion = { "group": "Idle", "no": 0, "video": idle_motion_video, "weight": 10, }
var bounce_motion = { "group": "", "no": 0, "video": bounce_motion_video, "weight": 2, }
var cheerful_motion = { "group": "", "no": 1, "video": cheerful_motion_video, "weight": 3, }
var hat_tip_motion = { "group": "", "no": 2, "video": hat_tip_motion_video, "weight": 2, }
var success_motion = { "group": "", "no": 3, "video": success_motion_video, "weight": 1, }
var failure_motion = { "group": "", "no": 4, "video": failure_motion_video, "weight": 2, }
var heal_motion = { "group": "", "no": 5, "video": heal_motion_video, "weight": 2, }

var job_success_motions = [success_motion, heal_motion, hat_tip_motion]
var job_failure_motions = [failure_motion,]
var happy_motions = [content_motion, bounce_motion, cheerful_motion, heal_motion, success_motion]
var neutral_motions = [idle_motion,] #also mad
var fast_end_motions = [success_motion, heal_motion, hat_tip_motion, bounce_motion, success_motion, failure_motion,]

var last_motion = hat_tip_motion
var next_motion = content_motion

var normal_expression = "exp_01"
var smile_expression = "exp_02"
var eyes_closed_expression = "exp_03"
var excited_expression = "exp_04"
var sad_expression = "exp_05"
var blush_expression = "exp_06"
var surprised_expression = "exp_07"
var angry_expression = "exp_08"

var frame = 0
var delta_sum = 0
var frames_to_skip = 5

var timestamp = Time.get_unix_time_from_system()

# Called when the node enters the scene tree for the first time.
func _ready():
	#Use OS.has_feature to detect current deployment
	#if OS.has_feature("mobile"):
		#Player.live2d_mode = Player.live2d_modes.VIDEO
	_update_live2d_display(Player.live2d_mode)
	cubism_model.motion_finished.connect(_on_motion_finished)
	live2d_video_player.finished.connect(_on_motion_finished)
	effect_breath.name = "GDCubismEffectBreath"
	cubism_model.add_child(effect_breath)
	add_breath()
	var node = GDCubismEffectEyeBlink.new()
	node.name = "GDCubismEffectEyeBlink"
	cubism_model.add_child(node)

func _process(delta):
	#TODO, enable live2d for PHONE mode under certain circumstances
	if Player.live2d_mode == Player.live2d_modes.LIVE2D and Player.live2d_active:
		frame += 1
		delta_sum += delta
		if frame >= frames_to_skip:
			cubism_model.advance(delta_sum)
			if Engine.get_frames_per_second() > 50:
				frames_to_skip = max(1, frames_to_skip - 1)
			elif Engine.get_frames_per_second() < 10:
				frames_to_skip = min(20, frames_to_skip + 1)
			if frames_to_skip > 19:
				#Swap to video when framerate is low
				Player.live2d_mode = Player.live2d_modes.VIDEO
			delta_sum = 0
			frame = 0
	else:
		#Making sure motion_video_queue doesn't grow out of control
		if len(motion_video_queue) > 10:
			motion_video_queue.pop_back()
	
func _on_motion_finished():
	timestamp = Time.get_unix_time_from_system()
	var previous_stamp = timestamp
	if Player.live2d_mode == Player.live2d_modes.LIVE2D:
		add_breath()
			
		if (last_motion in fast_end_motions):
			await get_tree().create_timer(RandomNumberGenerator.new().randi_range(1,2)).timeout
		else:
			await get_tree().create_timer(RandomNumberGenerator.new().randi_range(5, 15)).timeout
		
		if timestamp == previous_stamp:
			start_motion(next_motion)
			last_motion = next_motion
			play_idle_motion()

	else:
		if len(motion_video_queue):
			live2d_video_player.stream = motion_video_queue.pop_front()
			live2d_video_player.play()
		else:
			live2d_video_player.stream = idle_motion_video
			live2d_video_player.play()
	
func _update_live2d_display(live2d_mode) -> void:
	live2d_mode = int(live2d_mode)
	match live2d_mode:
		Player.live2d_modes.LIVE2D:
			live2d_video_player.hide()
			live2d_video_player.stop()
			$PlayerSprite.show()
		Player.live2d_modes.VIDEO:
			live2d_video_player.show()
			$PlayerSprite.hide()
		_:
			printerr("_update_live2d_display match error")
			
func start_motion(motion) -> void:
	timestamp = Time.get_unix_time_from_system()
	var previous_stamp = timestamp
	if Player.live2d_mode == Player.live2d_modes.LIVE2D:
		remove_breath()
		cubism_model.start_motion(motion.group, motion.no, GDCubismUserModel.PRIORITY_FORCE)
		
		await get_tree().create_timer(RandomNumberGenerator.new().randi_range(0, 10)).timeout
		if previous_stamp == timestamp:
			add_breath()
		
	elif Player.live2d_mode == Player.live2d_modes.VIDEO:
		motion_video_queue.append(motion.video)
	
func start_expression(expression) -> void:
	if Player.live2d_mode == Player.live2d_modes.VIDEO:
		return
	cubism_model.start_expression(expression)

func job_motion(motion) -> void:
	var weights = []
	var motions = job_success_motions
	if !motion: motions = job_failure_motions
	for choice in motions:
		if ('weight' in choice):
			var weight = choice.weight
			weights.append(weight)
		else:
			weights.append(1)
	motion = motions[rand_weighted(weights)]
	
	if Player.live2d_mode == Player.live2d_modes.LIVE2D:
		start_motion(motion)
		last_motion = motion
	elif Player.live2d_mode == Player.live2d_modes.VIDEO:
		motion_video_queue.push_front(motion.video)
		_on_motion_finished()
		
func random_motion(type:String) -> void:
	var motions = self[type]
	var weights = []
	var motion = idle_motion
	for choice in motions:
		if ('weight' in choice):
			var weight = choice.weight
			weights.append(weight)
		else:
			weights.append(1)
	motion = motions[rand_weighted(weights)]
	
	if Player.live2d_mode == Player.live2d_modes.LIVE2D:
		queue_motion(motion)
	elif Player.live2d_mode == Player.live2d_modes.VIDEO:
		motion_video_queue.append(motion.video)

func play_idle_motion():
	if (Player.stats["stress"] < 70):
		random_motion("happy_motions")
	else:
		random_motion("neutral_motions")
	
func queue_motion(motion) -> void:
	if Player.live2d_mode == Player.live2d_modes.LIVE2D:
		next_motion = motion
	elif Player.live2d_mode == Player.live2d_modes.VIDEO:
		motion_video_queue.append(motion.video)

func pause_live2d() -> void:
	Player.live2d_active = false

func resume_live2d() -> void:
	Player.live2d_active = true
	
#TODO, figure out a way to use effect_breath.active without making model look choppy
#current implementation is repetitive but smooth
func add_breath() -> void:
	if (!effect_breath.get_parent()):
		cubism_model.add_child(effect_breath)
	#effect_breath.active = true
	
func remove_breath() -> void:
	if (effect_breath.get_parent()):
		cubism_model.remove_child(effect_breath)
	#effect_breath.active = false
	
#helper function due to 4.2 lacking 4.3's weighted random chocie
func rand_weighted(weights) -> int:
	var weight_sum = 0
	for weight in weights:
		weight_sum += weight
	var rng = RandomNumberGenerator.new()
	var choice = rng.randf_range(0, weight_sum)
	for i in range(len(weights)):
		if(choice <= weights[i]):
			return i
		choice -= weights[i]
	return 0
