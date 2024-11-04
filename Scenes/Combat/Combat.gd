extends VBoxContainer

@onready var buttons = $MarginContainer3/MenuPanel/HBoxContainer
@onready var flee_button = $MarginContainer3/MenuPanel/HBoxContainer/Flee

@onready var pos1 = $MarginContainer/HBoxContainer/Enemy
@onready var pos2 = $MarginContainer/HBoxContainer/Enemy2
@onready var pos3 = $MarginContainer/HBoxContainer/Enemy3
@onready var pos4 = $MarginContainer2/HBoxContainer/Enemy
@onready var pos5 = $MarginContainer2/HBoxContainer/Enemy2
@onready var pos6 = $MarginContainer2/HBoxContainer/Enemy3

@onready var positions= [pos1, pos2, pos3, pos4, pos5, pos6]
@onready var target = pos1

@onready var skill_menu = $MarginContainer3/MenuPanel/HBoxContainer/Skill.get_popup()
@onready var player_stats_display = $MarginContainer3/MenuPanel/HBoxContainer/PlayerStats

#Copy player to prevent combat stat changes from affecting Player permanently
#Only variables marked with @export are copied
@onready var player_combat_copy = Player.duplicate()

const TOAST_TIMEOUT_DURATION = .5

enum states {READY, PROCESSING}
var state = states.READY

var enemies: Array[Enemy] = []
var order: Array[Character] = []
var death_queue: Array[Enemy] = []
var fight_won = false
var victory_stat_gain = {}

var base_stats = ["max_hp", "max_mp", "strength", "magic", "skill", "speed",
		"defense", "resistance"]
	
func _ready():
	player_combat_copy.stats.current_hp = player_combat_copy.stats.max_hp
	update_player_hp()
	order.append(player_combat_copy)
	
	for i in range(len(player_combat_copy.enemies)):
		var node = Enemy.new(player_combat_copy.enemies[i])
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
	
	for skill in player_combat_copy.combat_skills:
		skill_menu.add_item(skill)
	skill_menu.id_pressed.connect(_on_skill_press)
	update_target(pos1.get_node("Enemy"))
	
func process_turns(player_action: String):
	if player_combat_copy.stats.current_hp <= 0:
		display_toast("Mao is unconsious and can't act!", "top")
		return
	order.sort_custom(speed_sort)
	var message = ""
	
	for node in order:
		if node.name == "Player":
			#Skip player's turn if they're dead
			if player_combat_copy.stats.current_hp <= 0:
				await get_tree().create_timer(TOAST_TIMEOUT_DURATION).timeout
				continue
			message = node.label + "'s turn!"
			display_toast(message)
			await get_tree().create_timer(TOAST_TIMEOUT_DURATION).timeout
			var action = Constants.combat_skills[player_action]
			match action.effect_type:
				"attack":
					if target.get_node("Enemy") in death_queue:
						return
					var damage = max(1, (player_combat_copy.stats.strength * action.effect_strength/100) - target.get_node("Enemy").stats.defense)
					message = "Attacked and dealt " + str(damage) + " damage."
					display_toast(message)
					await update_enemy_hp(target, -damage)
				"magic_attack":
					if target.get_node("Enemy") in death_queue:
						return
					var damage = max(1, ((player_combat_copy.stats.magic * action.effect_strength/100) - target.get_node("Enemy").stats.resistance))
					message = "Used " + action.label + " and dealt " + str(damage) + " damage."
					display_toast(message)
					await update_enemy_hp(target, -damage)
				"buff":
					message = "Used " + action.label + ". " + action.message_player
					for stat in action.stats:
						player_combat_copy.stats[stat] += action.stats[stat]
					display_toast(message)
				"heal":
					var heal_amount = max(1, ((player_combat_copy.stats.magic * action.effect_strength/100)))
					message = "Healed " + str(heal_amount) + " hit points."
					update_player_hp(heal_amount)
					display_toast(message)
				_:
					printerr("Unknown action.effect_type")
			await process_followups()
			await get_tree().create_timer(TOAST_TIMEOUT_DURATION).timeout
			continue
		
		#Skip dead enemy's turn
		if node in death_queue:
			continue
			
		var weights = []
		for skill in node.combat_skills:
			if 'weight' in Constants.combat_skills[skill]:
				weights.append(Constants.combat_skills[skill].weight)
			else:
				printerr("missing weight for skill")
				weights.append(1)
		
		message = node.label + "'s turn!"
		display_toast(message)
		await(get_tree().create_timer(TOAST_TIMEOUT_DURATION).timeout)
		for i in range(node.stats.action_points):
			var action = Constants.combat_skills[node.combat_skills[rand_weighted(weights)]]
			match action.effect_type:
				"attack":
					var damage = max(1, ((node.stats.strength * action.effect_strength/100) - player_combat_copy.stats.defense))
					message = "Enemy attacked and dealt " + str(damage) + " damage."
					display_toast(message)
					update_player_hp(-damage)
				"magic_attack":
					var damage = max(1, ((node.stats.magic * action.effect_strength/100) - player_combat_copy.stats.resistance))
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
	
	
	for enemy in death_queue:
		order.erase(enemy)
	if not target.get_node("Enemy") in enemies and enemies:
		update_target(enemies[0])
	#Process victory if player is still alive when no enemies remain
	if !enemies:
		if player_combat_copy.stats.current_hp > 0:
			display_toast("Victory!")
			Player.victory_stat_gain = victory_stat_gain
			flee_button.text = "Leave"
	if player_combat_copy.stats.current_hp <= 0:
		flee_button.text = "Leave"
	
func player_attack():
	var damage = max(1, player_combat_copy.stats.strength - target.get_node("Enemy").stats.defense)
	var message = "Attacked and dealt " + str(damage) + " damage."
	await get_tree().create_timer(TOAST_TIMEOUT_DURATION).timeout
	display_toast(message)
	await update_enemy_hp(target, -damage)
	
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
			var buff_target = enemies[rand_weighted(weights)]
			for stat in action.stats:
				buff_target.stats[stat] += action.stats[stat]
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
			await process_turns("basic_attack")
		"Skill":
			pass
		"Item":
			pass
		"Flee":
			exit_combat()
		"Leave":
			exit_combat()
		_:
			printerr("Button text match issue: " + button.text)
	state = states.READY
	
func _on_skill_press(id: int):
	if state != states.READY:
		return
	state = states.PROCESSING
	await process_turns(skill_menu.get_item_text(id).to_lower())
	state = states.READY
	
func _on_enemy_gui_input(event, clicked):
	if event is InputEventMouseButton:
		if state != states.READY:
			return
		for enemy in positions:
			enemy.toggle_target(false)
		clicked.toggle_target(true)
		target = clicked

func exit_combat() -> void:
	if Player.in_tower and fight_won:
		Player.tower_level += 1
	Player.in_tower = false
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
	player_combat_copy.stats.current_hp += change
	player_stats_display.text = "Hp: " + str(player_combat_copy.stats.current_hp)
	#TODO, add unconsious status to play status box once hp drops to 0

func update_enemy_hp(enemy, amount) -> void:
	enemy.update_hp(amount)
	if enemy.get_hp() <= 0:
		await kill_enemy(enemy)
	
func update_target(enemy) -> void:
	target = enemy.get_parent()
	target.toggle_target(true)
	
func kill_enemy(enemy) -> void:
	await get_tree().create_timer(TOAST_TIMEOUT_DURATION).timeout
	enemy.gui_input.disconnect(_on_enemy_gui_input.bind(enemy))
	death_queue.append(enemy.get_node("Enemy"))
	enemies.erase(enemy.get_node("Enemy"))
	enemy.hide()
	var message = "Killed " + enemy.get_node("Enemy").label + "!"
	display_toast(message)
	
	var enemy_stats = enemy.get_node("Enemy").stats
	for stat in enemy_stats:
		if stat == "gold" or stat == "experience":
			if stat in victory_stat_gain:
				victory_stat_gain[stat] =+ enemy_stats[stat]
			else:
				victory_stat_gain[stat] = enemy_stats[stat]
			continue
		if stat == "current_hp":
			continue
		
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

func process_followups() -> void:
	match player_combat_copy.skill_flags.followup_attacks:
		player_combat_copy.followup_attacks.NO_FOLLOWUP:
			return
		player_combat_copy.followup_attacks.BASIC_ATTACK:
			if player_combat_copy.stats.action_points > 1:
				for i in range(player_combat_copy.stats.action_points -1):
					if target.get_node("Enemy") in death_queue:
						return
					await player_attack()
			return
		player_combat_copy.followup_attacks.ADVANCED_ATTACK:
			if player_combat_copy.stats.action_points > 1:
				for i in range(player_combat_copy.stats.action_points -1):
					if target.get_node("Enemy") in death_queue:
						if enemies:
							update_target(enemies[0])
						else:
							return
					await player_attack()
		_:
			printerr("Followup issue")
