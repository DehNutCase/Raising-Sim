class_name CardResource
extends Resource

enum Type {NONE, ATTACK, BLOCK, REMOVE_FROM_PLAY, STATUS, DRAW, MANA, GOLD, ADD_CARD, HEAL, DISPEL, WIN_DUEL}
enum Target {SELF, SINGLE_ENEMY, ALL_ENEMIES, EVERYONE, THIS_CARD, DRAW_PILE, DISCARD_PILE, CARDS_IN_HAND}
enum EnemyAttackType {MELEE, RANGED, ANIMATION}
enum BonusEffectType {NONE, CARDS_IN_DECK, CARDS_IN_DISCARD}

@export_group("Card Attributes")
@export var id: String
@export var type: Type
@export var target: Target
@export var cost: int
@export var effect_amount: int
@export var bonus_effect: BonusEffectType
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
@export var second_bonus_effect: BonusEffectType
@export var second_status: CardGameStatusResource
@export var second_card_to_add: CardResource

@export_group("Third Effect Attributes")
@export var third_target: Target
@export var third_type: Type
@export var third_effect_amount: int
@export var third_bonus_effect: BonusEffectType
@export var third_status: CardGameStatusResource
@export var third_card_to_add: CardResource

@export_group("Card Visuals")
@export var icon: Texture


func is_single_target() -> bool:
	return target == Target.SINGLE_ENEMY
	
func get_targets(targets: Array[Node], effect_number:int = 0, enemy: CardGameEnemy = null) -> Array[Node]:
	if !targets:
		return []
	var tree := targets[0].get_tree()
	var this_target
	match effect_number:
		0:
			this_target = target
		1:
			this_target = second_target
		2:
			this_target = third_target
		_:
			printerr("unmatched effect_number in get_targets")
	
	match this_target:
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
		Target.THIS_CARD:
			return []
		Target.DISCARD_PILE:
			return []
		Target.DRAW_PILE:
			return []
		Target.CARDS_IN_HAND:
			return tree.get_first_node_in_group("CardGameHand").get_children()
		_:
			printerr("Unmatched target type for get_targets")
	return []

func play(targets: Array[Node]) -> void:
	if animation:
		var data = JSON.parse_string(animation)
		var main_node = Player.get_tree().get_first_node_in_group("CardGameMainNode")
		await main_node.play_live2d_animation(data.model, data.animation, data.duration)
	#Player only uses start sound for now
	if start_sound_effect:
		SoundManager.play_sound(start_sound_effect)
	
	apply_effects(get_targets(targets, 0), Player.card_game_player, 0)
	apply_effects(get_targets(targets, 1), Player.card_game_player, 1)
	apply_effects(get_targets(targets, 2), Player.card_game_player, 2)

func enemy_play(enemy: CardGameEnemy) -> void:
	#Impact sound here
	if impact_sound_effect:
		SoundManager.play_sound(impact_sound_effect)
	apply_effects(get_targets([enemy], 0, enemy), enemy, 0)
	apply_effects(get_targets([enemy], 1, enemy), enemy, 1)
	apply_effects(get_targets([enemy], 2, enemy), enemy, 2)

func apply_effects(targets: Array[Node], user, effect_number) -> void:
	var this_type
	var this_amount
	var this_status
	var this_target
	var this_card_to_add
	
	match effect_number:
		0:
			this_type = type
			this_amount = effect_amount
			this_status = status
			this_target = target
			this_card_to_add = card_to_add
			
			match bonus_effect:
				BonusEffectType.NONE:
					pass
				BonusEffectType.CARDS_IN_DECK:
					this_amount += Player.card_game_player.draw_pile.size()
					pass
				BonusEffectType.CARDS_IN_DISCARD:
					this_amount += Player.card_game_player.discard.size()
					pass
				_:
					printerr("Unmatched first bonus_effect")
		1:
			this_type = second_type
			this_amount = second_effect_amount
			this_status = second_status
			this_target = second_target
			this_card_to_add = second_card_to_add
			
			match second_bonus_effect:
				BonusEffectType.NONE:
					pass
				BonusEffectType.CARDS_IN_DECK:
					this_amount += Player.card_game_player.draw_pile.size()
					pass
				BonusEffectType.CARDS_IN_DISCARD:
					this_amount += Player.card_game_player.discard.size()
					pass
				_:
					printerr("Unmatched second bonus_effect")
		2:
			this_type = third_type
			this_amount = third_effect_amount
			this_status = third_status
			this_target = third_target
			this_card_to_add = third_card_to_add
			
			match third_bonus_effect:
				BonusEffectType.NONE:
					pass
				BonusEffectType.CARDS_IN_DECK:
					this_amount += Player.card_game_player.draw_pile.size()
					pass
				BonusEffectType.CARDS_IN_DISCARD:
					this_amount += Player.card_game_player.discard.size()
					pass
				_:
					printerr("Unmatched third bonus_effect")
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
		Type.REMOVE_FROM_PLAY:
			apply_remove_from_play(targets, this_target, user)
		Type.NONE:
			pass #used when a card doesn't have all effect slots filled
		Type.GOLD:
			apply_gold(targets, this_amount, user)
		Type.ADD_CARD:
			apply_add_card(targets, this_amount, user, this_card_to_add, this_target)
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

func apply_remove_from_play(targets: Array[Node], this_target, user) -> void:
	#Targets is irrelevant unless it's CARDS_IN_HAND
	match this_target:
		Target.CARDS_IN_HAND:
			for card_ui:CardUI in targets:
				card_ui.enter_state(card_ui.States.DISCARD)
				card_ui.queue_free()
		Target.DISCARD_PILE:
			Player.card_game_player.discard.clear()
		Target.DRAW_PILE:
			Player.card_game_player.draw_pile.clear()
		Target.THIS_CARD:
			pass #removing the card from play is handled in card_ui instead
		_:
			printerr("Failed to match this_target in apply_remove_from_play")
	
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
	
func apply_add_card(targets: Array[Node], effect_amount, user, this_card_to_add, target) -> void:
	match target:
		Target.DRAW_PILE:
			for i in range(effect_amount):
				Player.card_game_player.draw_pile.append(this_card_to_add)
			Player.card_game_player.draw_pile.shuffle()
		Target.DISCARD_PILE:
			for i in range(effect_amount):
				Player.card_game_player.discard.append(this_card_to_add)
		Target.CARDS_IN_HAND:
			var tree = Player.get_tree()
			var card_game = tree.get_first_node_in_group("CardGameMainNode")
			for i in range(effect_amount):
				card_game.add_card(this_card_to_add)
				await tree.create_timer(.05).timeout

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
