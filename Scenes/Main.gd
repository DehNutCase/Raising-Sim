extends Node2D

@onready var player_model = $Ui/PlayerControl/Player
@onready var player
@onready var inventory = $Ui/PlayerControl/Player/CtrlInventory

@onready var stat_label = $Ui/MarginContainer/StatLabel
@onready var day_label = $Ui/MarginContainer2/DayLabel

@onready var button = $Ui/TextureButton
@onready var work = $Ui/MenuPanel/Work
@onready var day_menu = $DayMenu
@onready var lessons = $Ui/MenuPanel/Classes
@onready var rest = $Ui/MenuPanel/Rest
@onready var shop = $Ui/MenuPanel/Shop

@onready var menu_panel = $Ui/MenuPanel
@onready var animation = $Ui/MenuPanel/Animation
@onready var skip_checkbox = $Ui/MenuPanel/Skip

@onready var menus = [work, lessons, rest, shop]

var jobs = Constants.jobs
var classes = Constants.classes
var rests = Constants.rests

var day: int = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	player = Player
	Player.inventory = Inventory.new()
	inventory.inventory = Player.inventory
	Player.inventory.item_protoset = load('res://Constants/item_protoset.tres')
	process_day()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event.is_action_pressed("Key_X"):
		print('x is pressed')
	pass

func process_day(character = player):
	day +=1
	
	var items = inventory.inventory.get_items()
	for item in items:
		for stat in item.get_property('daily_stats'):
			Player.stats[stat] += item.get_property('daily_stats')[stat]
	
	for stat in Player.stats:
		if 'min' in Constants.stats[stat] && Player.stats[stat] < Constants.stats[stat]['min']:
			Player.stats[stat] = Constants.stats[stat]['min']
		if 'max' in Constants.stats[stat] && Player.stats[stat] > Constants.stats[stat]['max']:
			Player.stats[stat] = Constants.stats[stat]['max']
	
	stat_label.display_stats(character)
	day_label.display_day(day)
	get_tree().call_group("StatBars", "display_stats", Player)
	get_tree().call_group("Job_Button", "update_difficulty_color")	
	if(skip_checkbox.button_pressed):
		_on_close_button_pressed()
	
	if (Player.stats['stress'] < 20):
		get_tree().call_group("Live2DPlayer", "start_expression", player_model.happy_expression)
	if (Player.stats['stress'] < 1):
		get_tree().call_group("Live2DPlayer", "start_motion", player_model.happy_motion)	
	if (Player.stats['stress'] > 80):
		get_tree().call_group("Live2DPlayer", "start_expression", player_model.annoyed_expression)

func do_job(job: String, character = player) :
	var job_stats = Constants.jobs[job]['stats']
	var rng = RandomNumberGenerator.new()
	animation.stat_bars.load_stat_bars(job)
	
	if ( get_success_chance(job) > rng.randf() * 100):
		get_tree().call_group("Live2DPlayer", "job_motion", player_model.success_motion)
		process_stats(job_stats, character)
	else:
		get_tree().call_group("Live2DPlayer", "job_motion", player_model.failure_motion)
		if 'stress' in job_stats:
			var stats = {'stress': job_stats['stress']}
			process_stats(stats, character)

	work.visible = false
	animation.animation.visible = true
	animation.animation.play("Run")
	process_day(character)
	
#TODO, add animations for class and resting
func do_class(lesson: String, character = player) :
	#TODO add check for gold
	var class_stats = Constants.classes[lesson]['stats']
	process_stats(class_stats, character)
	process_day(character)

func do_rest(rest: String, character = player) :
	#TODO add check for gold
	var rest_stats = Constants.rests[rest]['stats']
	process_stats(rest_stats, character)
	process_day(character)

func get_success_chance(job, player = player):
	var task = Constants.jobs[job]
	var task_total_stats = 1
	var adjusted_stats = 1
	for stat in task.required_stats:
		task_total_stats += task.required_stats[stat]
		if player.stats[stat] >= task.required_stats[stat]:
			adjusted_stats += (player.stats[stat] - task.required_stats[stat])/2
		else:
			adjusted_stats += player.stats[stat] - task.required_stats[stat]
	
	return 100.0 * adjusted_stats / task_total_stats - task['difficulty'] - player.stats['stress']

func buy_item(item: String, price: int):
	if player.stats['gold'] > price:
		player.stats['gold'] -= price
		player.inventory.create_and_add_item(item)
	stat_label.display_stats(player)
func _on_texture_button_pressed():
	day_menu.position = get_viewport().get_mouse_position()
	day_menu.popup()
	pass # Replace with function body.


func _on_day_menu_id_pressed(id):
	match id:
		0:
			work.visible = !work.visible
		1:
			lessons.visible = !lessons.visible
		2:
			rest.visible = !rest.visible
		3:
			inventory.visible = !inventory.visible
			menu_panel.visible = true
		4:
			shop.visible = !shop.visible
	menu_panel.visible = !menu_panel.visible


func _on_close_button_pressed():
	menu_panel.visible = false
	for menu in menus:
		menu.visible = false
	animation.stat_bars.remove_stat_bars()
	animation.animation.visible = false
	

func display_toast(message, gravity = 'bottom', direction = 'right'):
	ToastParty.show({
		"text": message,           # Text (emojis can be used)
		"gravity": gravity,                   # top or bottom
		"direction": direction,               # left or center or right
	})
	
	"""
		ToastParty.show({
		"text": "Toast test",           # Text (emojis can be used)
		"bgcolor": Color(0, 0, 0, 0.7),     # Background Color
		"color": Color(1, 1, 1, 1),         # Text Color
		"gravity": "top",                   # top or bottom
		"direction": "right",               # left or center or right
		"text_size": 18,                    # [optional] Text (font) size // experimental (warning!)
		"use_font": true                    # [optional] Use custom ToastParty font // experimental (warning!)
	})
	"""

func process_stats(stats, character = Player):
	var toast = ""
	for stat in stats:
		var label
		if ( 'emoji' in Constants.stats[stat] ):
			label = Constants.stats[stat].emoji
		elif ( 'label' in Constants.stats[stat] ):
			label = Constants.stats[stat].label
		else:
			label = stat
		var sign = "+"
		if (stats[stat] < 0):
			sign = ""
		toast += "[" + sign + str(stats[stat]) + label + "] "
		
		if stat == 'experience':
			character.gain_experience(stats['experience'])
		else:
			character.stats[stat] += stats[stat]
	display_toast(toast, "top", "center")
