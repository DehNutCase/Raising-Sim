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
			print(stat)
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
	
	get_tree().call_group("Live2DPlayer", "start_motion", player_model.happy_motion)

func do_job(job: String, character = player) :
	var job_stats = Constants.jobs[job]['stats']
	get_success_chance(job)
	animation.stat_bars.load_stat_bars(job)
	for stat in job_stats:
		if stat == 'experience':
			character.gain_experience(job_stats['experience'])
		else:
			character.stats[stat] += job_stats[stat]
	work.visible = false
	animation.animation.visible = true
	animation.animation.play("Run")
	process_day(character)
	

func do_class(lesson: String, character = player) :
	#TODO add check for gold
	var class_stats = Constants.classes[lesson]['stats']
	for stat in class_stats:
		if stat == 'experience':
			character.gain_experience(class_stats['experience'])
		else:
			character.stats[stat] += class_stats[stat]
	process_day(character)

func do_rest(rest: String, character = player) :
	#TODO add check for gold
	var rest_stats = Constants.rests[rest]['stats']
	for stat in rest_stats:
		if stat == 'experience':
			character.gain_experience(rest_stats['experience'])
		else:
			character.stats[stat] += rest_stats[stat]
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
			#TODO More motion stuff (implement elsewhere)
			var motion = { "group": "Idle", "no": 0 }
			get_tree().call_group("Live2DPlayer", "start_motion", motion)
		4:
			shop.visible = !shop.visible
	menu_panel.visible = !menu_panel.visible


func _on_close_button_pressed():
	menu_panel.visible = false
	for menu in menus:
		menu.visible = false
	animation.stat_bars.remove_stat_bars()
	animation.animation.visible = false
	
