extends VBoxContainer

@onready var buttons = $MarginContainer3/MenuPanel/HBoxContainer

@onready var pos1 = $MarginContainer/HBoxContainer/Enemy
@onready var pos2 = $MarginContainer/HBoxContainer/Enemy2
@onready var pos3 = $MarginContainer/HBoxContainer/Enemy3

@onready var pos4 = $MarginContainer2/HBoxContainer/Enemy
@onready var pos5 = $MarginContainer2/HBoxContainer/Enemy2
@onready var pos6 = $MarginContainer2/HBoxContainer/Enemy3

@onready var positions= [pos1, pos2, pos3, pos4, pos5, pos6]
@onready var target = pos1

var enemies: Array[Enemy] = []

var base_stats = ['max_hp', 'max_mp', 'strength', 'magic', 'skill', 'speed',
		'defense', 'resistance']
		
func _ready():
	for i in range(4):
		var node = Enemy.new()
		node.name = "Enemy"
		enemies.append(node)
		
	for enemy in positions:
		enemy.gui_input.connect(_on_enemy_gui_input.bind(enemy))
	
	for i in range(len(enemies)):
		positions[i].add_child(enemies[i])
		positions[i].update_portrait()
		positions[i].update_hp()
		positions[i].show()
	
	for button in buttons.get_children():
		button.pressed.connect(_on_action.bind(button))
	
	target.toggle_target(true)

		
func _on_action(button):
	match button.text:
		'Attack':
			var damage = Player.stats.strength - target.get_node("Enemy").stats.defense
			target.update_hp(-damage)
		'Flee':
			exit_combat()
		_:
			print("hello else")

	pass # Replace with function body.

func _on_enemy_gui_input(event, clicked):
	if event is InputEventMouseButton:
		for enemy in positions:
			enemy.toggle_target(false)
		clicked.toggle_target(true)
		target = clicked

func exit_combat() -> void:
	SceneLoader.load_scene("uid://dphq852upsasd")
