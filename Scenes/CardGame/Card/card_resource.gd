class_name CardResource
extends Resource

enum Type {NONE, ATTACK, BLOCK, POWER, STATUS, DRAW, MANA, GOLD, ADD_CARD, HEAL, DISPEL, WIN_DUEL}
enum Target {SELF, SINGLE_ENEMY, ALL_ENEMIES, EVERYONE}
enum EnemyAttackType {MELEE, RANGED, ANIMATION}

@export_group("Card Attributes")
@export var id: String
@export var type: Type
@export var target: Target
@export var cost: int
@export var effect_amount: int
@export var status: CardGameStatusResource
@export var enemy_attack_type: EnemyAttackType
#Multi-hit only for first effect
@export var multi_hit_amount: int
@export_multiline var animation: String
@export var price: int
@export var card_to_add: CardResource
@export var start_sound_effect: AudioStreamWAV
@export var impact_sound_effect: AudioStreamWAV

@export_group("Second Effect Attributes")
@export var second_target: Target
@export var second_type: Type
@export var second_effect_amount: int
@export var second_status: CardGameStatusResource

@export_group("Third Effect Attributes")
@export var third_target: Target
@export var third_type: Type
@export var third_effect_amount: int
@export var third_status: CardGameStatusResource

@export_group("Card Visuals")
@export var icon: Texture


func is_single_target() -> bool:
	return target == Target.SINGLE_ENEMY
	
func get_targets(targets: Array[Node], enemy: CardGameEnemy = null) -> Array[Node]:
	if !targets:
		return []
	
	var tree := targets[0].get_tree()
	
	match target:
		Target.SELF:
			if enemy:
				return [enemy]
			return tree.get_nodes_in_group("CardGamePlayer")
		Target.ALL_ENEMIES:
			return tree.get_nodes_in_group("CardGameEnemies")
		Target.EVERYONE:
			return tree.get_nodes_in_group("CardGamePlayer") + tree.get_nodes_in_group("CardGameEnemies")
		Target.SINGLE_ENEMY:
			if enemy:
				return tree.get_nodes_in_group("CardGamePlayer")
			return [targets[-1]]
		_:
			printerr("Unmatched target type for get_targets")
	return []

func get_second_targets(targets: Array[Node], enemy: CardGameEnemy = null) -> Array[Node]:
	if !targets:
		return []
	
	var tree := targets[0].get_tree()
	
	match second_target:
		Target.SELF:
			if enemy:
				return [enemy]
			return tree.get_nodes_in_group("CardGamePlayer")
		Target.ALL_ENEMIES:
			return tree.get_nodes_in_group("CardGameEnemies")
		Target.EVERYONE:
			return tree.get_nodes_in_group("CardGamePlayer") + tree.get_nodes_in_group("CardGameEnemies")
		Target.SINGLE_ENEMY:
			if enemy:
				return tree.get_nodes_in_group("CardGamePlayer")
			return [targets[-1]]
		_:
			printerr("Unmatched target type for get_second_targets")
	return []
	
func get_third_targets(targets: Array[Node], enemy: CardGameEnemy = null) -> Array[Node]:
	if !targets:
		return []
	
	var tree := targets[0].get_tree()
	
	match third_target:
		Target.SELF:
			if enemy:
				return [enemy]
			return tree.get_nodes_in_group("CardGamePlayer")
		Target.ALL_ENEMIES:
			return tree.get_nodes_in_group("CardGameEnemies")
		Target.EVERYONE:
			return tree.get_nodes_in_group("CardGamePlayer") + tree.get_nodes_in_group("CardGameEnemies")
		Target.SINGLE_ENEMY:
			if enemy:
				return tree.get_nodes_in_group("CardGamePlayer")
			return [targets[-1]]
		_:
			printerr("Unmatched target type for get_third_targets")
	return []

func play(targets: Array[Node]) -> void:
	if animation:
		var data = JSON.parse_string(animation)
		var main_node = Player.get_tree().get_first_node_in_group("CardGameMainNode")
		await main_node.play_live2d_animation(data.model, data.animation, data.duration)
	#Player only uses start sound for now
	if start_sound_effect:
		SoundManager.play_sound(start_sound_effect)
	
	apply_effects(get_targets(targets), Player.card_game_player, 0)
	apply_effects(get_second_targets(targets), Player.card_game_player, 1)
	apply_effects(get_third_targets(targets), Player.card_game_player, 2)

func enemy_play(enemy: CardGameEnemy) -> void:
	#Impact sound here
	if impact_sound_effect:
		SoundManager.play_sound(impact_sound_effect)
	apply_effects(get_targets([enemy], enemy), enemy, 0)
	apply_effects(get_second_targets([enemy], enemy), enemy, 1)
	apply_effects(get_third_targets([enemy], enemy), enemy, 2)

func apply_effects(targets: Array[Node], user, effect_number) -> void:
	var this_type
	var this_amount
	var this_status
	match effect_number:
		0:
			this_type = type
			this_amount = effect_amount
			this_status = status
		1:
			this_type = second_type
			this_amount = second_effect_amount
			this_status = second_status
		2:
			this_type = third_type
			this_amount = third_effect_amount
			this_status = third_status
		_:
			printerr("effect_number failed to match")
	
	match this_type:
		Type.ATTACK:
			apply_damage(targets, this_amount, user, multi_hit_amount)
		Type.BLOCK:
			apply_block(targets, this_amount, user)
		Type.STATUS:
			apply_status(targets, this_amount, user, this_status)
		Type.DRAW:
			apply_draw(targets, this_amount, user)
		Type.MANA:
			apply_mana(targets, this_amount, user)
		Type.POWER:
			pass #POWER is currently only used to make sure a card is one use only
		Type.NONE:
			pass #used when a card doesn't have all effect slots filled
		Type.GOLD:
			apply_gold(targets, this_amount, user)
		Type.ADD_CARD:
			apply_add_card(targets, this_amount, user)
		Type.HEAL:
			apply_heal(targets, this_amount, user)
		Type.DISPEL:
			apply_dispel(targets, this_amount, user)
		Type.WIN_DUEL:
			#Only the player should have access to effects like this
			apply_win_duel(targets, this_amount, user)
		_:
			printerr("Unmatched effect type for apply_effects")

func apply_block(targets: Array[Node], effect_amount, user) -> void:
	for target in targets:
		if target is CardGameEnemy or target is CardGamePlayer:
			if user.active_status.get("Magic"):
				effect_amount = effect_amount + user.active_status.get("Magic").stacks
			if user.active_status.get("Fragile"):
				effect_amount = int(effect_amount / 2)
			target.block += effect_amount

func apply_damage(targets: Array[Node], effect_amount, user, multi_hit_amount = 0) -> void:
	for target in targets:
		if target is CardGameEnemy or target is CardGamePlayer:
			if user.active_status.get("Attack"):
				effect_amount = effect_amount + user.active_status.get("Attack").stacks
			if user.active_status.get("Weak"):
				effect_amount = int(effect_amount / 2)
			if multi_hit_amount:
				for i in range(multi_hit_amount):
					target.take_damage(effect_amount)
			else:
				target.take_damage(effect_amount)

func apply_draw(targets: Array[Node], effect_amount, user) -> void:
	var tree := targets[0].get_tree()
	tree.call_group("CardGameMainNode", "draw_cards", effect_amount)
		
func apply_status(targets: Array[Node], effect_amount, user, status) -> void:
	for target in targets:
		if target is CardGameEnemy or target is CardGamePlayer:
			target.apply_status(status, effect_amount, user)

func apply_mana(targets: Array[Node], effect_amount, user) -> void:
	Player.card_game_player.mana += effect_amount

func apply_gold(targets: Array[Node], effect_amount, user) -> void:
	Player.stats.gold += effect_amount
	var plus = "+"
	if (effect_amount < 0):
		plus = ""
	ToastParty.show({
		"text": plus + "%d 🪙" %effect_amount,           # Text (emojis can be used)
		"gravity": "top",                   # top or bottom
		"direction": "center",               # left or center or right
	})
	
func apply_add_card(targets: Array[Node], effect_amount, user) -> void:
	for i in range(effect_amount):
		Player.card_game_player.draw_pile.append(card_to_add)

func apply_heal(targets: Array[Node], effect_amount, user) -> void:
	for target in targets:
		if target is CardGameEnemy or target is CardGamePlayer:
			target.heal_damage(effect_amount)

func apply_dispel(targets: Array[Node], effect_amount, user) -> void:
	for target in targets:
		if target is CardGameEnemy or target is CardGamePlayer:
			target.dispel_status(effect_amount)
			
func apply_win_duel(targets: Array[Node], effect_amount, user) -> void:
	var tree := targets[0].get_tree()
	tree.call_group("CardGameMainNode", "win_duel")
