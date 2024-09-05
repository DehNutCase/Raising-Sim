extends Node2D

@onready var player_model = $Ui/PlayerControl/Player
@onready var inventory = $Ui/PlayerControl/Player/PlayerInventory
@onready var background = $Ui/PlayerControl/Player/BackgroundInventory

@onready var gold_label = $Ui/MarginContainer/GoldLabel
@onready var day_label = $Ui/MarginContainer2/DayLabel

@onready var work = $Ui/MenuPanel/Work
@onready var lessons = $Ui/MenuPanel/Lessons
@onready var rest = $Ui/MenuPanel/Rest
@onready var shop = $Ui/MenuPanel/Shop
@onready var stats = $Ui/MenuPanel/Stats

@onready var menu_panel = $Ui/MenuPanel
@onready var buttons = $MarginContainer3/MenuPanel/VBoxContainer
@onready var buttons2 = $MarginContainer4/MenuPanel/VBoxContainer
@onready var animation = $Ui/MenuPanel/Animation
@onready var skip_checkbox = $Ui/MenuPanel/Skip

@onready var menus = [work, lessons, rest, shop, stats,]

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
	Dialogic.signal_event.connect(_on_dialogic_signal)
	if (day == 0):
		process_day()
		#TODO, uncomment this line
		#Dialogic.start('timeline')
	else:
		display_stats()
		day_label.display_day(day)
		
	for button in buttons.get_children():
		button.pressed.connect(_on_action.bind(button))	
	for button in buttons2.get_children():
		button.pressed.connect(_on_action.bind(button))	

func _input(event):
	if event.is_action_pressed("Key_X"):
		print('x is pressed')
	pass

func process_day():
	if (day % Constants.constants.days_in_month == 0):
		var items = inventory.inventory.get_items().duplicate()
		items.append_array(background.inventory.get_items())
		for item in items:
			for stat in item.get_property('monthly_stats'):
				Player.stats[stat] += item.get_property('monthly_stats')[stat]
		
	day +=1
	var items = inventory.inventory.get_items().duplicate()
	items.append_array(background.inventory.get_items())
	for item in items:
		for stat in item.get_property('daily_stats'):
			Player.stats[stat] += item.get_property('daily_stats')[stat]
	
	for stat in Player.stats:
		if 'min' in Constants.stats[stat] && Player.stats[stat] < Constants.stats[stat]['min']:
			Player.stats[stat] = Constants.stats[stat]['min']
		if 'max' in Constants.stats[stat] && Player.stats[stat] > Constants.stats[stat]['max']:
			Player.stats[stat] = Constants.stats[stat]['max']
	
	display_stats()
	day_label.display_day(day)
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
		Player.proficiencies[job] += Constants.jobs[job].proficiency_gain
	else:
		get_tree().call_group("Live2DPlayer", "job_motion", player_model.failure_motion)
		if 'stress' in job_stats:
			var stats = {'stress': job_stats['stress']}
			process_stats(stats)
		Player.proficiencies[job] += Constants.jobs[job].proficiency_gain/2
	work.visible = false
	animation.animation.visible = true
	animation.animation.play("Run")
	process_day()
	
#TODO, add animations for class and resting
#TODO, display cost of rest and classes
func do_class(lesson: String) :
	var class_stats = Constants.classes[lesson]['stats']
	var cost = 0
	if'gold' in class_stats: cost = -class_stats.gold
	if (cost > Player.stats['gold']):
		display_toast("Not enough gold!", "top", "center")
		return
	process_stats(class_stats)
	lessons.visible = false
	animation.animation.visible = true
	animation.animation.play("Run")
	process_day()

func do_rest(rest: String) -> void:
	var rest_stats = Constants.rests[rest]['stats']
	var cost = 0
	if 'gold' in rest_stats: cost = -rest_stats.gold
	if ( cost > Player.stats['gold']):
		display_toast("Not enough gold!", "top", "center")
		return
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
	task_total_stats += task.proficiency
	if (job in Player.proficiencies):
		adjusted_stats += Player.proficiencies[job]
	else:
		Player.proficiencies[job] = 0
		
	return 100.0 * adjusted_stats / task_total_stats - task['difficulty'] - Player.stats['stress']

func buy_item(item: String, price: int):
	if Player.stats['gold'] >= price:
		Player.stats['gold'] -= price
		add_item(item)
	else:
		display_toast("Not enough gold!", "top", "center")
	display_stats()

func add_item(item_name: String):
	Player.inventory.create_and_add_item(item_name)
	var item = Player.inventory.get_item_by_id(item_name)
	for stat in item.get_property('stats'):
		Player.stats[stat] += item.get_property('stats')[stat]

#TODO, edit new menu bar with new buttons (add stats page)
#TODO, add 'Background' and 'Skills' inventories
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
		'Stats':
			stats.show()
		'Background':
			background.visible = !background.visible
			menu_panel.visible = true
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

func display_stats() -> void:
	stats.display_stats()
	gold_label.display_gold()
	get_tree().call_group("StatBars", "display_stats")
	get_tree().call_group("Job_Button", "update_difficulty_color")	

func _on_dialogic_signal(item: String) -> void:
	add_item(item)
