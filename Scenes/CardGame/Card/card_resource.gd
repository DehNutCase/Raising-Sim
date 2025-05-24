class_name CardResource
extends Resource

enum Type {NONE, ATTACK, BLOCK, POWER, STATUS, DRAW, MANA}
enum Target {SELF, SINGLE_ENEMY, ALL_ENEMIES, EVERYONE}

@export_group("Card Attributes")
@export var id: String
@export var type: Type
@export var target: Target
@export var cost: int
@export var effect_amount: int
@export var status: CardGameStatusResource

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
	apply_effects(get_targets(targets), Player.card_game_player)
	apply_second_effects(get_second_targets(targets), Player.card_game_player)
	apply_third_effects(get_third_targets(targets), Player.card_game_player)

func enemy_play(enemy: CardGameEnemy) -> void:
	apply_effects(get_targets([enemy], enemy), enemy)
	apply_second_effects(get_second_targets([enemy], enemy), enemy)
	apply_third_effects(get_third_targets([enemy], enemy), enemy)

#TODO, implement MANA
func apply_effects(targets: Array[Node], user) -> void:
	match type:
		Type.ATTACK:
			apply_damage(targets, effect_amount, user)
		Type.BLOCK:
			apply_block(targets, effect_amount, user)
		Type.STATUS:
			apply_status(targets, effect_amount, user, status)
		Type.DRAW:
			apply_draw(targets, effect_amount, user)
		Type.MANA:
			apply_mana(targets, effect_amount, user)
		_:
			printerr("Unmatched effect type for apply_effects")

func apply_second_effects(targets: Array[Node], user) -> void:
	match second_type:
		Type.ATTACK:
			apply_damage(targets, second_effect_amount, user)
		Type.BLOCK:
			apply_block(targets, second_effect_amount, user)
		Type.STATUS:
			apply_status(targets, second_effect_amount, user, second_status)
		Type.DRAW:
			apply_draw(targets, second_effect_amount, user)
		Type.MANA:
			apply_mana(targets, second_effect_amount, user)
		Type.NONE:
			pass
		_:
			printerr("Unmatched effect second_type for apply_effects")

func apply_third_effects(targets: Array[Node], user) -> void:
	match third_type:
		Type.ATTACK:
			apply_damage(targets, third_effect_amount, user)
		Type.BLOCK:
			apply_block(targets, third_effect_amount, user)
		Type.STATUS:
			apply_status(targets, third_effect_amount, user, third_status)
		Type.DRAW:
			apply_draw(targets, third_effect_amount, user)
		Type.MANA:
			apply_mana(targets, third_effect_amount, user)
		Type.NONE:
			pass
		_:
			printerr("Unmatched effect third_type for apply_effects")


func apply_block(targets: Array[Node], effect_amount, user) -> void:
	for target in targets:
		if target is CardGameEnemy or target is CardGamePlayer:
			if user.active_status.get("Magic"):
				effect_amount = effect_amount + user.active_status.get("Magic").stacks
			if user.active_status.get("Fragile"):
				effect_amount = int(effect_amount / 2)
			target.block += effect_amount

func apply_damage(targets: Array[Node], effect_amount, user) -> void:
	for target in targets:
		if target is CardGameEnemy or target is CardGamePlayer:
			if user.active_status.get("Attack"):
				effect_amount = effect_amount + user.active_status.get("Attack").stacks
			if user.active_status.get("Weak"):
				effect_amount = int(effect_amount / 2)
			target.take_damage(effect_amount)

func apply_draw(targets: Array[Node], effect_amount, user) -> void:
	var tree := targets[0].get_tree()
	#TODO, replace draws per turn gain from scholarship with wisdom stacks
	if user.active_status.get("Wisdom"):
		effect_amount = effect_amount + user.active_status.get("Wisdom").stacks
	if user.active_status.get("Agility"):
		effect_amount = effect_amount + user.active_status.get("Agility").stacks
	for i in range(effect_amount):
		tree.call_group("CardGameMainNode", "draw_cards", effect_amount)
		
func apply_status(targets: Array[Node], effect_amount, user, status) -> void:
	for target in targets:
		if target is CardGameEnemy or target is CardGamePlayer:
			target.apply_status(status, effect_amount, user)

func apply_mana(targets: Array[Node], effect_amount, user) -> void:
	Player.card_game_player.mana += effect_amount
