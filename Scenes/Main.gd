extends Node2D

@onready var player_model = $Ui/PlayerControl/Player
@onready var inventory = $Ui/PlayerControl/Player/CtrlInventory

@onready var stat_label = $Ui/MarginContainer/StatLabel
@onready var day_label = $Ui/MarginContainer2/DayLabel

@onready var work = $Ui/MenuPanel/Work
@onready var lessons = $Ui/MenuPanel/Lessons
@onready var rest = $Ui/MenuPanel/Rest
@onready var shop = $Ui/MenuPanel/Shop

@onready var menu_panel = $Ui/MenuPanel
@onready var buttons = $MarginContainer3/MenuPanel/VBoxContainer
@onready var animation = $Ui/MenuPanel/Animation
@onready var skip_checkbox = $Ui/MenuPanel/Skip

@onready var menus = [work, lessons, rest, shop]

var jobs = Constants.jobs
var classes = Constants.classes
var rests = Constants.rests

var day: int:
	get:
		return Player.day
	set(value):
		Player.day = value


# Called when the node enters the scene tree for the first time.
func _ready():
	Player.inventory = Inventory.new()
	inventory.inventory = Player.inventory
	Player.inventory.item_protoset = load('res://Constants/item_protoset.tres')
	
	if (day == 0):
		process_day()
	else:
		stat_label.display_stats(Player)
		day_label.display_day(day)
		get_tree().call_group("StatBars", "display_stats", Player)
		get_tree().call_group("Job_Button", "update_difficulty_color")	
		
	for button in buttons.get_children():
		button.pressed.connect(_on_action.bind(button))

func _input(event):
	if event.is_action_pressed("Key_X"):
		print('x is pressed')
	pass


func process_day():
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
	
	stat_label.display_stats()
	day_label.display_day(day)
	get_tree().call_group("StatBars", "display_stats", Player)
	get_tree().call_group("Job_Button", "update_difficulty_color")	
	if(skip_checkbox.button_pressed):
		_on_close_button_pressed()
	
	if (Player.stats['stress'] < 20):
		get_tree().call_group("Live2DPlayer", "start_expression", player_model.happy_expression)
	if (Player.stats['stress'] < 10):
		get_tree().call_group("Live2DPlayer", "queue_motion", player_model.happy_motion)	
	if (Player.stats['stress'] > 80):
		get_tree().call_group("Live2DPlayer", "start_expression", player_model.annoyed_expression)

#TODO remove stat bars in job pages
func do_job(job: String) :
	var job_stats = Constants.jobs[job]['stats']
	var rng = RandomNumberGenerator.new()
	animation.stat_bars.load_stat_bars(job)
	
	if ( get_success_chance(job) > rng.randf() * 100):
		get_tree().call_group("Live2DPlayer", "job_motion", player_model.success_motion)
		process_stats(job_stats)
	else:
		get_tree().call_group("Live2DPlayer", "job_motion", player_model.failure_motion)
		if 'stress' in job_stats:
			var stats = {'stress': job_stats['stress']}
			process_stats(stats)

	work.visible = false
	animation.animation.visible = true
	animation.animation.play("Run")
	process_day()
	
#TODO, add animations for class and resting
func do_class(lesson: String) :
	#TODO add check for gold & toast message
	"""
	if Player.stats['gold'] > price:
		Player.stats['gold'] -= price
		Player.inventory.create_and_add_item(item)
	else:
		display_toast("Not enough gold!", "top", "center")
	"""
	var class_stats = Constants.classes[lesson]['stats']
	process_stats(class_stats)
	lessons.visible = false
	animation.animation.visible = true
	animation.animation.play("Run")
	process_day()

func do_rest(rest: String) :
	#TODO add check for gold
	var rest_stats = Constants.rests[rest]['stats']
	process_stats(rest_stats)
	rests.visible = false
	animation.animation.visible = true
	animation.animation.play("Run")
	process_day()

func get_success_chance(job):
	var task = Constants.jobs[job]
	var task_total_stats = 1
	var adjusted_stats = 1
	for stat in task.required_stats:
		task_total_stats += task.required_stats[stat]
		if Player.stats[stat] >= task.required_stats[stat]:
			adjusted_stats += (Player.stats[stat] - task.required_stats[stat])/2
		else:
			adjusted_stats += Player.stats[stat] - task.required_stats[stat]
	
	return 100.0 * adjusted_stats / task_total_stats - task['difficulty'] - Player.stats['stress']

func buy_item(item: String, price: int):
	if Player.stats['gold'] > price:
		Player.stats['gold'] -= price
		Player.inventory.create_and_add_item(item)
	else:
		display_toast("Not enough gold!", "top", "center")
	stat_label.display_stats()
	
func _on_action(button):
	var open_menu: String
	for menu in menus:
		if menu.visible:
			open_menu = menu.name
	_on_close_button_pressed()
	
	match button.text:
		'Work':
			work.show()
		'Lessons':
			lessons.show()
		'Rest':
			rest.show()
		'Inventory':
			inventory.visible = !inventory.visible
			menu_panel.visible = true
		'Shop':
			shop.show()
		'Battle':
			SceneLoader.load_scene("uid://df0p3tawo2arq")
		_:
			print("hello else")
			
	if open_menu == button.text:
		_on_close_button_pressed()
	else:
		menu_panel.visible = !menu_panel.visible
	

func _on_close_button_pressed():
	menu_panel.visible = false
	for menu in menus:
		menu.visible = false
	animation.stat_bars.remove_stat_bars()
	animation.animation.visible = false
	

func display_toast(message, gravity = 'bottom', direction = 'center'):
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

func process_stats(stats):
	var toast = ""
	for stat in stats:
		var label
		if ( 'emoji' in Constants.stats[stat] ):
			label = Constants.stats[stat].emoji
		elif ( 'label' in Constants.stats[stat] ):
			label = Constants.stats[stat].label
		else:
			label = stat
		
		var plus = "+"
		if (stats[stat] < 0):
			plus = ""
		toast += "[" + plus + str(stats[stat]) + label + "] "
		
		if stat == 'experience':
			Player.gain_experience(stats['experience'])
		else:
			Player.stats[stat] += stats[stat]
	display_toast(toast, "top", "center")
