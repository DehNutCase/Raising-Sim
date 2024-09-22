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

var base_stats = ["max_hp", "max_mp", "strength", "magic", "skill", "speed",
		"defense", "resistance"]
		
func _ready():
	
	for i in range(len(Player.enemies)):
		var enemy_stats = calculate_stats(Player.enemies[i])
		var node = Enemy.new({'stats': enemy_stats})
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
		"Attack":
			var damage = max(1, Player.stats.strength - target.get_node("Enemy").stats.defense)
			var message = "Attacked and dealt " + str(damage) + " damage."
			display_toast(message)
			target.update_hp(-damage)
		"Flee":
			exit_combat()
		_:
			print("hello else")

func _on_enemy_gui_input(event, clicked):
	if event is InputEventMouseButton:
		for enemy in positions:
			enemy.toggle_target(false)
		clicked.toggle_target(true)
		target = clicked

func exit_combat() -> void:
	SceneLoader.load_scene("res://Scenes/Main/Main.tscn")

func calculate_stats(enemy) -> Variant:
	var enemy_stats = {}
	
	if "race" in enemy:
		var base_stats = {}
		if "base_stats" in Constants.races[enemy.race]:
			base_stats = Constants.races[enemy.race].base_stats
		for stat in base_stats:
			if stat in enemy_stats:
				enemy_stats[stat] += base_stats[stat]
			else:
				enemy_stats[stat] = base_stats[stat]
		
		var level_stats = {}
		if "level_stats" in Constants.races[enemy.race]:
			level_stats = Constants.races[enemy.race].level_stats
		for stat in level_stats:
			if stat in enemy_stats:
				enemy_stats[stat] += level_stats[stat] * enemy.level
			else:
				enemy_stats[stat] = level_stats[stat] * enemy.level

	if "character_class" in enemy:
		var base_stats = {}
		if "base_stats" in Constants.character_classes[enemy.character_class]:
			base_stats = Constants.character_classes[enemy.character_class].base_stats
		for stat in base_stats:
			if stat in enemy_stats:
				enemy_stats[stat] += base_stats[stat]
			else:
				enemy_stats[stat] = base_stats[stat]
				
		var level_stats = {}
		if "level_stats" in Constants.character_classes[enemy.character_class]:
			level_stats = Constants.character_classes[enemy.character_class].level_stats
		for stat in level_stats:
			if stat in enemy_stats:
				enemy_stats[stat] += level_stats[stat] * enemy.level
			else:
				enemy_stats[stat] = level_stats[stat] * enemy.level	
	return enemy_stats
	
func display_toast(message, gravity = "top", direction = "center"):
	ToastParty.show({
		"text": message,           # Text (emojis can be used)
		"gravity": gravity,                   # top or bottom
		"direction": direction,               # left or center or right
	})
