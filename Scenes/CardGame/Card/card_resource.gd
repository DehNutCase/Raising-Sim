class_name CardResource
extends Resource

enum Type {ATTACK, BLOCK, POWER, STATUS}
enum StatusType {IMMUNE}
enum Target {SELF, SINGLE_ENEMY, ALL_ENEMIES, EVERYONE}

@export_group("Card Attributes")
@export var id: String
@export var type: Type
@export var status_type: StatusType
@export var target: Target
@export var cost: int
@export var effect_amount: int

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

func play(targets: Array[Node]) -> void:
	apply_effects(get_targets(targets))

func enemy_play(enemy: CardGameEnemy) -> void:
	apply_effects(get_targets([enemy], enemy))

func apply_effects(targets: Array[Node]) -> void:
	match type:
		Type.ATTACK:
			apply_damage(targets)
		Type.BLOCK:
			apply_block(targets)
		Type.STATUS:
			apply_status(targets)
		_:
			printerr("Unmatched effect type for apply_effects")

func apply_block(targets: Array[Node]) -> void:
	for target in targets:
		if target is CardGameEnemy:
			target.block += effect_amount
		if target is CardGamePlayer:
			target.block += effect_amount

func apply_damage(targets: Array[Node]) -> void:
	for target in targets:
		if target is CardGameEnemy or target is CardGamePlayer:
			target.take_damage(effect_amount)

#TODO, UNFINISHED
func apply_status(targets: Array[Node]) -> void:
	for target in targets:
		if target is CardGameEnemy or target is CardGamePlayer:
			match status_type:
				StatusType.IMMUNE:
					target.apply_immune(effect_amount)
