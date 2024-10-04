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

@onready var player_stats_display = $MarginContainer3/MenuPanel/HBoxContainer/PlayerStats

const TOAST_TIMEOUT_DURATION = .5

enum states {READY, PROCESSING}
var state = states.READY

var enemies: Array[Enemy] = []
var order: Array[Character] = [Player]

var base_stats = ["max_hp", "max_mp", "strength", "magic", "skill", "speed",
		"defense", "resistance"]
	
func _ready():
	Player.stats.current_hp = Player.stats.max_hp
	update_player_hp()
	
	for i in range(len(Player.enemies)):
		var node = Enemy.new(Player.enemies[i])
		enemies.append(node)
		order.append(node)
		
	for enemy in positions:
		enemy.gui_input.connect(_on_enemy_gui_input.bind(enemy))
	
	for i in range(len(enemies)):
		positions[i].add_child(enemies[i])
		positions[i].update_portrait()
		positions[i].update_hp()
		positions[i].show()
	
	for button in buttons.get_children():
		if button.name == "PlayerStats":
			continue
		button.pressed.connect(_on_action.bind(button))
	
	target.toggle_target(true)
	
#TODO, process victory/defeat
#TODO, add action points system for Player
func process_turns(player_action: String):
	order.sort_custom(speed_sort)
	
	for node in order:
		if node.name == "Player":
			var message = node.label + "'s turn!"
			display_toast(message)
			await(get_tree().create_timer(TOAST_TIMEOUT_DURATION).timeout)
			await player_attack()
			continue
			
		var weights = []
		for skill in node.combat_skills:
			if 'weight' in Constants.combat_skills[skill]:
				weights.append(Constants.combat_skills[skill].weight)
			else:
				printerr("missing weight for skill")
				weights.append(1)
		
		var message = node.label + "'s turn!"
		display_toast(message)
		await(get_tree().create_timer(TOAST_TIMEOUT_DURATION).timeout)
		for i in range(node.stats.action_points):
			var action = Constants.combat_skills[node.combat_skills[rand_weighted(weights)]]
			match action.effect_type:
				"attack":
					var damage = max(1, ((node.stats.strength * action.effect_strength/100) - Player.stats.defense))
					message = "Enemy attacked and dealt " + str(damage) + " damage."
					display_toast(message)
					update_player_hp(-damage)
				"magic_attack":
					var damage = max(1, ((node.stats.magic * action.effect_strength/100) - Player.stats.resistance))
					message = "Enemy used " + action.label + " and dealt " + str(damage) + " damage."
					display_toast(message)
					update_player_hp(-damage)
				"buff":
					message = "Enemey used " + action.label + ". " + action.message
					apply_buffs_enemy(action, node)
					display_toast(message)
				"heal":
					var heal_amount = max(1, ((node.stats.magic * action.effect_strength/100)))
					message = "Enemy healed " + str(heal_amount) + " hit points."
					heal_enemy(action, node, heal_amount)
					display_toast(message)
				_:
					printerr("Unknown action.effect_type")
			await(get_tree().create_timer(TOAST_TIMEOUT_DURATION).timeout)
		
func player_attack():
	var damage = max(1, Player.stats.strength - target.get_node("Enemy").stats.defense)
	var message = "Attacked and dealt " + str(damage) + " damage."
	for i in range(Player.stats.action_points):
		display_toast(message)
		update_enemy_hp(target, -damage)
		await(get_tree().create_timer(TOAST_TIMEOUT_DURATION).timeout)
	
func apply_buffs_enemy(action, caster):
	match action.effect_range:
		"area":
			for stat in action.stats:
				for enemy in enemies:
					enemy.stats[stat] += action.stats[stat]
		"single":
			var weights = []
			for enemy in enemies:
				weights.append(1)
			target = enemies[rand_weighted(weights)]
			for stat in action.stats:
				target.stats[stat] += action.stats[stat]
		"self":
			for stat in action.stats:
				caster.stats[stat] += action.stats[stat]
		_:
			printerr("Unmatched action.effect_range")
	
func heal_enemy(action, caster, amount):
	match action.effect_range:
		"area":
			for enemy in enemies:
				update_enemy_hp(enemy.get_parent(), amount)
		"single":
			var weights = []
			for enemy in enemies:
				weights.append(1)
			var heal_target = enemies[rand_weighted(weights)]
			update_enemy_hp(heal_target.get_parent(), amount)
		"self":
			update_enemy_hp(caster.get_parent(), amount)
		_:
			printerr("Unmatched action.effect_range")
			
func _on_action(button):
	if state != states.READY:
		return
	state = states.PROCESSING
	match button.text:
		"Attack":
			await process_turns("Attack")
		"Flee":
			exit_combat()
		_:
			printerr("hello else")
	state = states.READY
	
func _on_enemy_gui_input(event, clicked):
	if event is InputEventMouseButton:
		for enemy in positions:
			enemy.toggle_target(false)
		clicked.toggle_target(true)
		target = clicked

func exit_combat() -> void:
	SceneLoader.load_scene("res://Scenes/Main/Main.tscn")
	
func display_toast(message, gravity = "top", direction = "center"):
	ToastParty.show({
		"text": message,           # Text (emojis can be used)
		"gravity": gravity,                   # top or bottom
		"direction": direction,               # left or center or right
	})

func speed_sort(a, b):
	return a["stats"].speed > b["stats"].speed

func update_player_hp(change: int = 0) -> void:
	Player.stats.current_hp += change
	player_stats_display.text = "Hp: " + str(Player.stats.current_hp)

func update_enemy_hp(enemy, amount) -> void:
	enemy.update_hp(amount)
	#TODO, kill target if hp reaches 0
	if enemy.get_hp() <= 0:
		kill_enemy(enemy)
	
func kill_enemy(enemy) -> void:
	pass
	
#helper function due to 4.2 lacking 4.3's weighted random chocie
func rand_weighted(weights) -> int:
	var weight_sum = 0
	for weight in weights:
		weight_sum += weight
	var rng = RandomNumberGenerator.new()
	var choice = rng.randi_range(0, weight_sum)
	for i in range(len(weights)):
		if(choice <= weights[i]):
			return i
		choice -= weights[i]
	return 0
