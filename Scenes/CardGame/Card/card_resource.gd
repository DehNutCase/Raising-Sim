class_name CardResource
extends Resource

enum Type {ATTACK, BLOCK, POWER, SPECIAL}
enum Target {SELF, SINGLE_ENEMY, ALL_ENEMIES, EVERYONE}

@export_group("Card Attributes")
@export var id: String
@export var type: Type
@export var target: Target
@export var cost: int
@export var effect_amount: int

@export_group("Card Visuals")
@export var icon: Texture
@export_multiline var tooltip_text: String

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

func play(targets: Array[Node], stats: CardGameCharacterStats) -> void:
	stats.mana -= cost
	apply_effects(get_targets(targets))

func enemy_play(enemy: CardGameEnemy) -> void:
	apply_effects(get_targets([enemy], enemy))

func apply_effects(targets: Array[Node]) -> void:
	match type:
		Type.ATTACK:
			apply_damage(targets)
		Type.BLOCK:
			apply_block(targets)
		_:
			printerr("Unmatched effect type for apply_effects")

func apply_block(targets: Array[Node]) -> void:
	for target in targets:
		if target is CardGameEnemy or target is CardGamePlayer:
			target.stats.block += effect_amount

func apply_damage(targets: Array[Node]) -> void:
	for target in targets:
		if target is CardGameEnemy or target is CardGamePlayer:
			target.take_damage(effect_amount)
