class_name CardUI
extends Control

signal reparent_requested(card: CardUI)

@onready var icon = %CardIcon
@onready var cost_label: RichTextLabel = %CostLabel

@onready var collision = %CollisionShape2D

enum States {BASE, DRAGGING, RELEASED, DISCARD, SPELLBOOK}
@export var current_state:States
@export var initial_state:States

var targets: Array[Node] = []
var played = false

@export var card: CardResource : set = _set_card

@onready var card_text_label: RichTextLabel = %CardTextLabel

func _ready():
	pass
	
func enter_state(state:States) -> void:
	match state:
		States.BASE:
			reparent_requested.emit(self)
			pivot_offset = Vector2.ZERO
			current_state = States.BASE
			collision.disabled = true
			Player.play_ui_sound("discard_card")
		States.DRAGGING:
			collision.disabled = false
			reparent(get_tree().get_first_node_in_group("CardGameMainNode"))
			current_state = States.DRAGGING
			Player.play_ui_sound("draw_card")
		States.RELEASED:
			collision.disabled = false
			current_state = States.RELEASED
			played = false
			if targets:
				if card.is_single_target():
					if targets.size() < 2:
						enter_state(States.BASE)
						return
				play_card()
		States.DISCARD:
			current_state = States.DISCARD
	
func exit_state(state:States) -> void:
	pass

func _gui_input(event):
	match current_state:
		States.BASE:
			if event.is_action_pressed("ui_click"):
				pivot_offset = get_global_mouse_position() - global_position
				change_state(States.BASE, States.DRAGGING)

func _input(event):
	match current_state:
		States.DRAGGING:
			if event is InputEventMouseMotion or InputEventJoypadMotion:
				global_position = get_global_mouse_position() - pivot_offset
			if event.is_action_pressed("ui_accept") or event.is_action("ui_click"):
				change_state(States.DRAGGING, States.RELEASED)
				get_viewport().set_input_as_handled()
			if event.is_action_pressed("ui_cancel"):
				change_state(States.DRAGGING, States.BASE)
				get_viewport().set_input_as_handled()
		States.RELEASED:
			if played:
				return
			change_state(States.RELEASED, States.BASE)

func change_state(from:States, to:States):
	if from != current_state:
		return
	exit_state(from)
	enter_state(to)

func play_card():
	played = true
	if targets and targets[-1] is CardGameEnemy:
		targets[-1].arrow.hide()
	if Player.card_game_player.mana >= card.cost:
		Player.card_game_player.mana -= card.cost
		card.play(targets.duplicate())
		if card.type != card.Type.POWER:
			discard()
		else:
			enter_state(States.DISCARD)
			queue_free()
	else:
		played = false
		enter_state(States.BASE)

func _on_area_area_entered(area: Area2D) -> void:
	if !(area in targets):
		if card.is_single_target() and area is CardGameEnemy:
			area.arrow.show()
			if targets and targets[-1] is CardGameEnemy:
				targets[-1].arrow.hide()
		targets.append(area)

func _on_area_area_exited(area: Area2D) -> void:
	targets.erase(area)
	if area is CardGameEnemy:
		area.arrow.hide()
	if card.is_single_target() and targets and targets[-1] is CardGameEnemy:
		targets[-1].arrow.show()

func _set_card(value: CardResource) -> void:
	if not is_node_ready():
		await ready
	card = value
	cost_label.clear()
	if is_instance_valid(Player.card_game_player) and card.cost > Player.card_game_player.mana:
		cost_label.append_text("[center][color=red]" + str(card.cost) + "[/color][/center]")
	else:
		cost_label.append_text("[center][color=white]" + str(card.cost) + "[/color][/center]")
	icon.texture = card.icon
	tooltip_text = _create_tooltip()
	card_text_label.parse_bbcode("[center]" + _create_tooltip() + "[/center]")
	
func _update_mana_label():
	cost_label.clear()
	if is_instance_valid(Player.card_game_player) and card.cost > Player.card_game_player.mana:
		cost_label.append_text("[center][color=red]" + str(card.cost) + "[/color][/center]")
	else:
		cost_label.append_text("[center][color=white]" + str(card.cost) + "[/color][/center]")
	
func _create_tooltip() -> String:
	var tooltip = "[center][color=Turquoise]%s[/color][/center]\n" %card.id
	
	for i in range(3):
		var this_type
		var this_amount
		var this_status
		var this_target
		var this_bonus_effect
		match i:
			0:
				this_type = card.type
				this_amount = card.effect_amount
				this_status = card.status
				this_target = card.target
				this_bonus_effect = card.bonus_effect
			1:
				this_type = card.second_type
				this_amount = card.second_effect_amount
				this_status = card.second_status
				this_target = card.second_target
				this_bonus_effect = card.second_bonus_effect
			2:
				this_type = card.third_type
				this_amount = card.third_effect_amount
				this_status = card.third_status
				this_target = card.third_target
				this_bonus_effect = card.third_bonus_effect
			_:
				printerr("_create_tooltip effect_number failed to match")
				
		if this_type != card.Type.NONE:
			tooltip += "\n"
		
		match this_type:
			card.Type.ATTACK:
				var multi_text = ""
				#multi hits should only ever be first effect
				if card.multi_hit_amount and i == 0:
					multi_text = " [color=red]%d[/color] times" %card.multi_hit_amount
				match this_target:
					card.Target.SELF:
						tooltip += "Deal [color=red]%d[/color] damage to yourself%s." %[this_amount, multi_text]
					card.Target.SINGLE_ENEMY:
						tooltip += "Deal [color=red]%d[/color] damage%s." %[this_amount, multi_text]
					card.Target.ALL_ENEMIES:
						tooltip += "Deal [color=red]%d[/color] damage to all enemies%s." %[this_amount, multi_text]
					card.Target.EVERYONE:
						tooltip += "Deal [color=red]%d[/color] damage to everyone%s." %[this_amount, multi_text]
			card.Type.BLOCK:
				match this_target:
					card.Target.SELF:
						tooltip += "Gain [color=blue]%d[/color] block." %this_amount
					card.Target.SINGLE_ENEMY:
						tooltip += "Target enemy gains [color=blue]%d[/color] block." %this_amount
					card.Target.ALL_ENEMIES:
						tooltip += "All enemies gain [color=blue]%d[/color] block." %this_amount
					card.Target.EVERYONE:
						tooltip += "Everyone gains [color=blue]%d[/color] block." %this_amount
			card.Type.STATUS:
				match this_target:
					card.Target.SELF:
						tooltip += "Gain [color=yellow]%d[/color] %s." %[this_amount, this_status.status_name]
					card.Target.SINGLE_ENEMY:
						tooltip += "Target enemy gains [color=yellow]%d[/color] %s." %[this_amount, this_status.status_name]
					card.Target.ALL_ENEMIES:
						tooltip += "All enemies gain [color=yellow]%d[/color] %s." %[this_amount, this_status.status_name]
					card.Target.EVERYONE:
						tooltip += "Everyone gains [color=yellow]%d[/color] %s." %[this_amount, this_status.status_name]
			card.Type.DRAW:
						tooltip += "Draw [color=green]%d[/color] card(s)." % this_amount
			card.Type.MANA:
						tooltip += "Gain [color=blue]%d[/color] mana." % this_amount
			#NOTE, power should always be the first effect, doesn't do anything.
			card.Type.POWER:
						tooltip += "Once per duel."
			card.Type.GOLD:
						tooltip += "Gain [color=yellow]%d[/color] gold." % this_amount
			card.Type.ADD_CARD:
						tooltip += "Add [color=blue]%d[/color] [color=green]%s[/color] into your draw pile." % [this_amount, card.card_to_add.id]
			card.Type.DISPEL:
				match this_target:
					card.Target.SELF:
						tooltip += "Remove [color=yellow]%d[/color] of every status effect." %this_amount
					card.Target.SINGLE_ENEMY:
						tooltip += "Target enemy loses [color=yellow]%d[/color] of every status effect." %this_amount
					card.Target.ALL_ENEMIES:
						tooltip += "All enemies loses [color=yellow]%d[/color] of every status effect." %this_amount
					card.Target.EVERYONE:
						tooltip += "Everyone loses [color=yellow]%d[/color] of every status effect." %this_amount
			card.Type.HEAL:
				match this_target:
					card.Target.SELF:
						tooltip += "Heal [color=green]%d[/color] health points." %this_amount
					card.Target.SINGLE_ENEMY:
						tooltip += "Heal [color=green]%d[/color] health points for target enemy." %this_amount
					card.Target.ALL_ENEMIES:
						tooltip += "Heal [color=green]%d[/color] health points for all enemies." %this_amount
					card.Target.EVERYONE:
						tooltip += "Heal [color=green]%d[/color] health points for everyone." %this_amount
			card.Type.WIN_DUEL:
				tooltip += "Win the duel."
		match this_bonus_effect:
			card.BonusEffectType.NONE:
				#None type bonus effect doesn't add tooltip
				pass
			card.BonusEffectType.CARDS_IN_DECK:
				var bonus_amount = Player.card_game_player.draw_pile.size()
				tooltip += " (%d bonus from cards remaining in deck.)" %bonus_amount
			card.BonusEffectType.CARDS_IN_DISCARD:
				var bonus_amount = Player.card_game_player.discard.size()
				tooltip += " (%d bonus from cards in discard pile.)" %bonus_amount
			_:
				printerr("match this_bonus_effect failed")
	return tooltip

func _make_custom_tooltip(for_text):
	return Player.make_custom_tooltip(for_text)

func discard() -> void:
	if current_state == States.SPELLBOOK:
		queue_free()
		return
	Player.card_game_player.discard.append(card)
	enter_state(States.DISCARD)
	queue_free()
